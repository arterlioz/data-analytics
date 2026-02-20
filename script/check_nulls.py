from sqlalchemy import create_engine
import pandas as pd

engine = create_engine('postgresql://postgres:Kiwi@localhost:5433/burnout_analysis')

df = pd.read_sql('SELECT * FROM burnout_data', engine)

# Count nulls for each column
null_counts = df.isnull().sum()

print("\n📊 NULL COUNTS BY COLUMN:\n")
for col, count in null_counts.items():
    print(f"{col:25} {count:>6} nulls")

print(f"\nTotal rows: {len(df)}")