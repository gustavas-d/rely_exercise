import xmlschema, os, json, mysql.connector
from datetime import date
from xmlschema import XMLSchemaValidationError
import xml.etree.ElementTree as ET


#setup logging
import logging
if not 'logs' in os.listdir('./'):
    os.mkdir('./logs/')
today = date.today() 

logging.basicConfig(filename=f'./logs/apotek_rely_summary_{today}.log',
    format='%(asctime)s %(levelname)-8s %(message)s',
    level=logging.DEBUG,
    datefmt='%Y-%m-%d %H:%M:%S'
)
logging.info("== Daily sales summary DB upload started ==")

#setup environ variables
import dotenv
dotenv.load_dotenv(override=True)

def validate_xml_files(directory:str) -> list:
    '''This function validates all xml files in a given directory against POSLogV6.0.0.xsd
    It returns a list of valid files and logs failed validations'''
    logging.info(f'starting file validation. Source directory "{directory}"')
    xsd = xmlschema.XMLSchema('POSLogV6.0.0.xsd')
    valid_files = []
    try:
        all_files = os.listdir(directory)
    except FileNotFoundError:
        logging.critical(f'the provided directory "{directory}" could not be found. Please check your configuration.')
    for filename in all_files:
        try:
            xsd.validate(f'{directory}{filename}')
            valid_files.append(filename)
        except XMLSchemaValidationError as e:
            logging.error(f'"{filename}" file is invalid. Excluding it from daily calculations. Please restart the script after fixing the file to include it in the report.')
            logging.error(e.message)
            logging.error(e.reason)
    if len(valid_files) < len(all_files):
        logging.info(f'file validation complete.{len(valid_files)}/{len(all_files)} are valid in "{directory}"')
    else:
        logging.info(f'File validation complete. All files in "{directory}" are valid')
    return valid_files

class  TransactionItem:
    """XML Parsing Class - Turns given Transaction XML to a dict. 
    Requires an ElementrTree or a destination to file, using the load_from_file method. 
    Skips first 2 levels of dict, use 'to_dict' to get full tree"""
    def __init__(self, element_tree:ET=None):
        self.element_tree = element_tree
        self.root = None

        if self.element_tree is not None:
            self.root = self.element_tree.getroot()
            self.result_dict = self.to_dict()
            self.receipt = self.raw_receipt("ReceiptImage")   
            self.result_dict = self.result_dict['POSLog']['Transaction']
            self.trans_id = self.result_dict['TransactionID']
            self.result_dict['ReceiptImage']['ReceiptLine'] = self.receipt

    def load_from_file(self, file_path:str):
        self.element_tree = ET.parse(file_path)
        self.root = self.element_tree.getroot()
        self.result_dict = self.to_dict()
        self.receipt = self.raw_receipt("ReceiptImage")       
        self.result_dict = self.result_dict['POSLog']['Transaction']
        self.trans_id = self.result_dict['TransactionID']
        self.result_dict['ReceiptImage']['ReceiptLine'] = self.receipt

        return self

    
    def remove_namespace(self, tag:str) -> str:
        # Remove the namespace prefix and return only the local part of the tag
        return tag.split('}')[-1]
    
    def _parse_text_content(self, text):
        # Parse text content into appropriate data types
        if text.lower() == 'true':
            return True
        elif text.lower() == 'false':
            return False
        try:
            return int(text)
        except ValueError:
            try:
                return float(text)
            except ValueError:
                return text
    
    
    def element_to_dict(self, element:ET) -> dict:
        #return a dict representation of an XML element
        result = {}
        
        # Add element attributes as dictionary keys
        if element.tag == 'Quantity':
            print (element.attrib.items())
        for key, value in element.attrib.items():
            result[f'@{self.remove_namespace(key)}'] = self._parse_text_content(value)
        
        # Add element text content
        if element.text:
            result['text'] = self._parse_text_content(element.text.strip())
        
        # Add child elements recursively
        for child in element:
            child_tag = self.remove_namespace(child.tag)
            child_data = self.element_to_dict(child)
            if child_tag in result:
                if isinstance(result[child_tag], list):
                    result[child_tag].append(child_data)
                else:
                    result[child_tag] = [result[child_tag], child_data]
            else:
                #remove redundant nesting
                if len(child_data) == 1 and 'text' in child_data:
                    result[child_tag] = child_data['text']
                else:
                    result[child_tag] = child_data

        return result
    
    def to_dict(self, element=None):
        #parse XML into dict. 
        if element is None:
            element = self.root

        return {self.remove_namespace(element.tag): self.element_to_dict(element)}


        
    def raw_receipt(self, tag_name:str, element=None):
        if element is None:
            element = self.root

        found_elements = []

        def search_for_tag(element:ET):
            if self.remove_namespace(element.tag) == tag_name:
                for child in element:
                    if child.text:
                        found_elements.append(child.text)
                    else:
                        found_elements.append('')
            for child in element:
                search_for_tag(child)

        search_for_tag(element)
        return '\n\r'.join(found_elements)
    
    def __repr__(self):
        return str(json.dumps(self.result_dict, indent=4))
                


def sql_query_dicts(xml_parsed:TransactionItem) -> (dict, list, dict):
    """Prepares dictionaries to be saved in SQL database. \n
    input: XML file of TransactionItem class
    output: transaction - dict, sales - list of dicts, receipt - dict"""
    transaction = {}
    sales_items = []
    sales = []
    receipt = {}
    
    #load the dictionary
    xml_dict = xml_parsed.result_dict
    transaction_id = xml_dict['TransactionID']
    if xml_dict['@TrainingModeFlag']:
       logging.INFO(f'transaction {transaction_id} is training. Skipping this invoice. ')
       return
    

    #transaction table fields
    transaction['transaction_id'] = transaction_id
    transaction['zero_sales'] = '@ZeroSales' in xml_dict.keys()
    transaction['unit_id'] = xml_dict['BusinessUnit']['UnitID']
    transaction['workstation_id'] = xml_dict['WorkstationID']['text']
    transaction['operator_id'] = xml_dict['OperatorID']['text']
    transaction['sequence_no'] = xml_dict['SequenceNumber']
    transaction['currency_code'] = xml_dict['CurrencyCode']
    transaction['transaction_status'] = xml_dict['RetailTransaction']['@TransactionStatus']
    line_items = xml_dict['RetailTransaction']['LineItem']
    if type(line_items) == dict:
        line_items = [line_items]
    for line_item in line_items:
        if 'Tender' in line_item:
            if '@internalTenderId' in line_item['Tender']:
                transaction['tender_id'] = line_item['Tender']['@internalTenderId']
                transaction['tender_ammount'] = line_item['Tender']['Amount']
            elif 'Rounding' in line_item['Tender']:
                transaction['rounding'] = line_item['Tender']['Rounding']['text']
        else:
            sales_items.append(line_item)
    for total in xml_dict['RetailTransaction']['Total']:
        try:
            if total['@TotalType'] == 'TransactionNetAmount':
                transaction['net_amount'] = total['text']
            elif total['@TotalType'] == 'TransactionTaxAmount':
                transaction['tax_amount'] = total['text']
            elif total['@TotalType'] == 'VRExt:TransactionVatRateAmount':
                transaction['vat_amount'] = total['@VATAmount']
                transaction['vat_rate'] = total['@VATRate']
        except TypeError:
            continue

    if transaction['zero_sales']:
        transaction['net_amount'] = 0
    transaction['begin_dt'] = xml_dict['BeginDateTime']
    transaction['end_dt'] = xml_dict['EndDateTime']


    #Sales items

    for item in sales_items:
        sales_item = {}

        sales_item['transaction_id'] = transaction_id
        try:
            sales_item['cancel_flag'] = item['@CancelFlag']
        except TypeError:
            print(sales_items)
            sales_item['cancel_flag'] = item
        sales_item['entry_method'] = item['@EntryMethod']
        sale = item['Sale']
        sales_item['item_subtype'] = sale['@ItemSubType']
        sales_item['item_type'] = sale['@ItemType']
        for posid in sale['POSIdentity']:
            if posid['@POSIDType'] == 'GTIN':
                sales_item['gtin'] = posid['POSItemID']
            elif posid['@POSIDType'] == 'RSID':
                sales_item['rsid'] = posid['POSItemID']
        sales_item['merchandise_group'] = sale['MerchandiseHierarchy']['text']
        if 'SpecialOrderNumber' in sale:
            sales_item['special_order_no'] = sale['SpecialOrderNumber']
        sales_item['short_description'] = sale['Description']['text']
        sales_item['unit_cost_price'] = sale['UnitCostPrice']
        sales_item['suggested_price'] = sale['SuggestedPrice']
        sales_item['extended_amount'] = sale['ExtendedAmount']
        sales_item['quantity'] = sale['Quantity']['text']
        sales_item['units'] = sale['Quantity']['@Units'] 
        sales_item['unit_of_measure'] = sale['Quantity']['@UnitOfMeasureCode']
        sales_item['tax_group_id'] = sale['Tax']['TaxGroupID']['text']
        sales_item['loyalty_type'] = sale['LoyaltyAccount']['LoyaltyProgram']['Points']['@Type']
        sales_item['loyalty_points'] = sale['LoyaltyAccount']['LoyaltyProgram']['Points']['text']
        sales_item['price_type'] = sale['PriceType']
        sales_item['sequence_no'] = item['SequenceNumber']
        sales_item['dt'] = item['DateTime']

        sales.append(sales_item)

    #receipt
    receipt['transaction_id'] = transaction_id
    receipt['receipt_text'] = xml_dict['ReceiptImage']['ReceiptLine']
    receipt['receipt_image'] = xml_dict['ReceiptImage']['ReceiptData']

    return transaction, sales, receipt

def upload_sql_data(table_name, data_to_save):

    db_config = {
        'host': os.getenv('DB_URL'),
        'user': os.getenv('DB_ACC'),
        'password': os.getenv('DB_PASS'),
        'database': os.getenv('DB_NAME'),
        'port': os.getenv('DB_PORT')
    }

    try:
        connection = mysql.connector.connect(**db_config)
    except mysql.connector.Error as e:
        logging.critical('connecting to DB failed:')
        logging.critical(e)
        return False
    
    cursor = connection.cursor()

    # Create the SQL statement to insert data
    insert_query = f'INSERT INTO {table_name} ({", ".join(data_to_save.keys())}) VALUES ({", ".join(["%s"] * len(data_to_save))})'
    values = list(data_to_save.values())


    try:
        # Execute and commit the SQL statement
        cursor.execute(insert_query, values)
        connection.commit()
    except mysql.connector.Error as e:
        cursor.close()
        connection.close()
        print(e)
        if e.errno == 1452:
            logging.critical(f"transaction ID {data_to_save['transaction_id']} data uploading failed")
            logging.critical(f'Missing foreign key. Details: {e}')
            return False
        elif e.errno == 1062:
            logging.info(f"transaction ID {data_to_save['transaction_id']} already in {table_name}. Skipping upload.")
            return True
        else:
            logging.critical(f"transaction ID {data_to_save['transaction_id']} data uploading to {table_name} failed")
            logging.critical(e)
            return False
    else:
        logging.info(f'uploading data to {table_name} successful.')
        cursor.close()
        connection.close()
        return True


if __name__ == "__main__":
    receipts_dir = os.getenv('FILE_DIR')
    receipts_bak_dir = f'{receipts_dir[:-1]}_bak/'
    if not os.path.isdir(receipts_bak_dir):
        os.mkdir(receipts_bak_dir)
    successful_files = []
    # validate XML files in /receipts/ dir
    valid_files = validate_xml_files(receipts_dir)

    #create transaction class items for valid xml files
    transactions  = [TransactionItem().load_from_file(f'{receipts_dir}{x}') for x in valid_files]

    #loop transactions and save data to DB
    for transaction, file in zip(transactions, valid_files):
        logging.info(f'parsing and uploading {file}')
        trans, sales, receipt = sql_query_dicts(transaction)

        result = upload_sql_data('transactions', trans)
        if result:
            for item in sales:
                result = upload_sql_data('transaction_sale_items', item)
            if result:
                result = upload_sql_data('receipts', receipt)
        if result:
            logging.info(f'All {file} data successfully uploaded.')
            successful_files.append(file)
    logging.info('== Data parsing and uploading finished. ==')

    for file in successful_files:
        os.rename(f'{receipts_dir}/{file}', f'{receipts_bak_dir}/{file}')
    
    logging.info(f'fully backuped files, have been moved to {receipts_bak_dir}')
        




