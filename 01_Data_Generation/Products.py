import csv
import random
from faker import Faker
import pandas as pd
fake=Faker()
row_nums=int(input("Enter the number of rows the csv file should have: "))
name_csv=input("enter the name of csv file: ")
excel_path_='Product_Category.xlsx'
product_col="Product"
category_col="Category"
df=pd.read_excel(excel_path_)

with open(name_csv,mode='w',newline='') as file:
    writer=csv.writer(file)
    header=['Product Name','Category','Brand','Unit Price']
    writer.writerow(header)

    for _ in range(row_nums):
        sample_row = df.sample(n=1).iloc[0]
        random_product = sample_row[product_col]
        random_category = sample_row[category_col]
        
        row=[
            random_product,
            random_category,
            random.choice(["Zenith Corp", "NovaTech", "EcoHome Essentials", "UrbanWear Co.", "PrimeSports Ltd."]),
            random.randint(100,1000)
        ]
        writer.writerow(row)