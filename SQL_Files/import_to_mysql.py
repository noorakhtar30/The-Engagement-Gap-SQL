import pandas as pd
from sqlalchemy import create_engine

# Read CSV
df = pd.read_csv(r"C:\Users\Prime\Downloads\social_media_dataset.csv")

# Connect to MySQL
engine = create_engine(
    "mysql+pymysql://root:Metaknight79@localhost:3306/engagement_gap"
)

# Import data into MySQL
df.to_sql(
    name="social_media_raw",
    con=engine,
    if_exists="replace",
    index=False
)

print("Data imported successfully!")
print("Rows imported:", len(df))