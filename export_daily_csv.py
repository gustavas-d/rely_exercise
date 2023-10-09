import mysql.connector, os, argparse
from datetime import date

#load env vars
import dotenv
dotenv.load_dotenv(override=True)

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
logging.info("== Daily sales summary csv export started ==")

def fetch_mysql_data(date:date) -> list:
    """Fetches the following saved data from DB grouped by StoreID:
    Total amount of items sold;
    Total amount paid;
    Count of receipts;
    """

    start_date = f"{date} 00:00:00"
    end_date = f"{date} 23:59:59"

    logging.info(f'fetching receipt data from {start_date} to {end_date}')
    
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

    query = f"""
    SELECT bu.unit_id AS StoreID,
	    COALESCE(SUM(tsi.quantity), 0) AS TotalItems,
	    COALESCE(SUM(t.net_amount), 0) AS TotalAmount,
	    COALESCE(COUNT(t.transaction_id), 0) AS TotalReceipts
    FROM (
        SELECT DISTINCT unit_id
        FROM business_units
    ) bu
    LEFT JOIN (
        SELECT transaction_id, unit_id, net_amount
        FROM transactions
        WHERE end_dt >= "{start_date}" AND end_dt <= "{end_date}"
    ) t ON bu.unit_id = t.unit_id
    LEFT JOIN (
        SELECT quantity, transaction_id
        FROM transaction_sale_items
    ) tsi ON t.transaction_id = tsi.transaction_id
    GROUP BY StoreID;
    """

    try:
        # Execute and commit the SQL statement
        cursor.execute(query)
        result = cursor.fetchall()
        logging.info('fetching data from DB - success')
        return result

    except mysql.connector.Error as e:
        cursor.close()
        connection.close()
        logging.critical('Fetching data from DB failed with the following error:')
        logging.critical(e)
        return None
    
    
def prepare_csv(db_entries:list, date, save_dir:str):
    """Takes in daily SQL data and fromats it to a csv.
    Output CSV saves the following fields:
    Date -          Today’s date
    StoreID	-       Internal ID of the Store
    TotalItems-     Amount of items sold
    TotalAmount	-   Total amount paid in the receipt
    TotalReceipts 
    """
    if not os.path.isdir(save_dir):
        os.mkdir(save_dir)

    with open(save_dir+f'{date}_report.csv', 'w') as file:
        file.write('Date, StoreID, TotalItems, TotalAmount, TotalReceipts\n')
        file.write(f'{date}')
        for i, store in enumerate(db_entries):
            for item in store:
                file.write(f',{str(item)}')
            if i+1 < len(db_entries):
                file.write('\n')
    logging.info(f'CSV report exported to {save_dir}{date}_report.csv')



if __name__ == "__main__":

    parser = argparse.ArgumentParser(description='This script takes in a date and ')

    # Add a single argument to the parser
    parser.add_argument('-d','--date', type=str, default=str(today), help='The date for which to generate report')
    parser.add_argument('-o', '--output_directory', type=str, default='./csv_exports/', help='The directory where finished reports will be saved.')

    # Parse the command-line arguments
    args = parser.parse_args()

    # Access the value of the argument
    report_date = args.date
    output_directory = args.output_directory
    
    db_entries = fetch_mysql_data(report_date)

    for entry in db_entries:
        print(entry)

    prepare_csv(db_entries, report_date, output_directory)

    logging.info("== Daily sales summary csv export finished ==")

    import export_daily_csv