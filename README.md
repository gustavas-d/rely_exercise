# RelyITS Python test exercise

This is a git repository used as a part of interview for a Python developer role in RelyITS.
This project has 2 scripts:
* [save_data_to_db.py](save_data_to_db.py) to populate a MySQL database with receipt data from [Receipts](receipts).
* [export_daily_csv.py](export_daily_csv.py) to produce a daily report.

Daily receipts are stored in: 
* [receipts folder](receipts) before processing
* [receipts backup folder](receipts_bak) - after successful processing

Both Scripts log usage information in a day-based log file in: 
* [logging directory](logs)

The SQL_schema can be found in [SQL schema](db-schema.sql). Since the schema is relational, you can use [SQL query to build and populate example DB](sb_building_query.sql) to build and populate the DB with necessary values for given examples.

## Usage instructions
### First use

All non standard libraries are provided in [requirements.txt](requirements.txt)
Please install them using:
```pip install -r requirements.txt```

An example venv build with is provided in [initial_run.sh](initial_run.sh)

The scripts also require the following environmental values:
* DB_URL='the URL to your database'
* DB_ACC='mysql database username'
* DB_PASS='mysql databes password'
* DB_NAME='the name of the mysql database holding required schema'
* DB_PORT=database port
* FILE_DIR='./receipts/' - can be changed to change location where all receipts are held. (this will also update backup folder accordingly)

### Regular usage

Since the process is emant to be daily, setting up the following cron jobs is recomended, e.g.:
```
crontab -e
30 23 * * * /path/to/the/script/daily_reports.sh
``` 
This will run both python script in succession daily at 23:30
Both scripts can be ran independently.

To start the scripts manually:
* launch the [daily_reports.sh](daily_reports.sh) bach script for regular use in previously set up venv.
* alternatively first launch [save_data_to_db.py](save_data_to_db.py) to populate the database with fresh receipts.
* follow up with [export_daily_csv.py](export_daily_csv.py) to produce the report

[export_daily_csv.py](export_daily_csv.py) has 2 optional arguments:
* **--date/-d** to change the Date for which to generate the report
* **--output_directory/-o** to change the location where the resulting CSV will be uploaded 


### Saving data to DB
The  [save_data_to_db.py](save_data_to_db.py) script performs the following actions:
* Parses all XML files in receipts directory and validates them against the [POSLogV6.0.0.xsd](POSLogV6.0.0.xsd) XSD schema.
* After validation infromation being stored in DB is extracted and formatted
* All the data is pushed to relevant SQL tables
* successfully parsed and uploaded files, get moved over to the backup folder
* Files that failed this process are left in the initial folder for review and reatemts, once errors fixed.

The whole process is logged daily, in [logs](logs) folder, apotek_rely_summary_{date}.log files

### Generating CSV export
The [export_daily_csv.py](export_daily_csv.py) takes in daily SQL data and fromats it to a csv.
Output CSV saves the following fields:
* Date -          Today’s date
* StoreID	-       Internal ID of the Store
* TotalItems-     Amount of items sold
* TotalAmount	-   Total amount paid in the receipt
* TotalReceipts 
All of the data is aggregated by StoreID
The data for all available stores in business_units table is provided, even if no transactions are present on the given day (it will return 0's for those stores)
The date can be changed to generate a report for any date of interest
