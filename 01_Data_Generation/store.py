import csv
import random
from faker import Faker
import pandas as pd
fake=Faker()
row_nums=int(input("Enter the number of rows the csv file should have: "))
name_csv=input("enter the name of csv file: ")
excel_path='Adjectives_Nouns.xlsx'
adj_col="Adjectives"
noun_col="Nouns"
df=pd.read_excel(excel_path)

with open(name_csv,mode='w',newline='') as file:
    writer=csv.writer(file)
    header=['Store Name','Store Type','Store Opening Date','Address','City','State','Country','Region','Manager Name']
    writer.writerow(header)

    for _ in range(row_nums):
        random_adjective=df[adj_col].sample(n=1).values[0]
        random_noun=df[noun_col].sample(n=1).values[0]
        store_name=f"The {random_adjective} {random_noun}"
        row=[
            store_name,
            random.choice(['Exclusive','MBO','SMB','Outlet Stores']),
            fake.date(),
            fake.address().replace(","," ").replace("\n"," "),
            fake.city(),
            fake.state(),
            fake.country(),
            random.choice(['East','West','North','South']),
            fake.first_name()


        ]
        writer.writerow(row)