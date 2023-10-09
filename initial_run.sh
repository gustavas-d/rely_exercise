#!/bin/bash

# Set up a Python virtual environment
python -m venv apothec

# Activate the virtual environment
source apothec/bin/activate

# Install required packages from requirements.txt
pip install -r requirements.txt

deactivate 