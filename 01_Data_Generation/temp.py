import mysql.connector
import pandas as pd
import warnings
warnings.filterwarnings("ignore", category=UserWarning)
connection = mysql.connector.connect(
    host="localhost",        
    user="root",             
    password="",
    database="salesproject" 
)
query = "Select * FROM LoyaltyPrograms;"

# Load data into Pandas DataFrame
df = pd.read_sql(query, con=connection)

print(df.head())
df.to_csv('Dimloyaltypgms.csv',index=False)