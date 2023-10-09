#!/bin/bash

# Activate the virtual environment
source apothec/bin/activate

# Feel free to change the date of the report, by adding the -d [date] flag
python save_data_to_db.py
python export_daily_csv.py

# Deactivate the virtual environment when done
deactivate