"""
Purpose: Import burnout dataset from CSV to PostgreSQL
- Standardizes column names to lowercase
- Automatically detects and assigns data types
- Creates burnout_data table in database

"""

import pandas as pd
from sqlalchemy import create_engine

df = pd.read_csv('burnout_data.csv')

# Covert all column names to lowercase
df.columns = df.columns.str.lower()

engine = create_engine('postgresql://postgres:{password}@localhost:5433/burnout_analysis')

df.to_sql('burnout_data', engine, if_exists='replace', index=False)

print(f"✅ Success! Imported {len(df)} rows with {len(df.columns)} columns")
print(f"Columns: {list(df.columns)}")