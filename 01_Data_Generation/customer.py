import csv
import random
from faker import Faker
fake=Faker()
row_nums=int(input("Enter the number of rows the csv file should have: "))
name_csv=input("enter the name of csv file: ")
with open(name_csv,mode='w',newline='') as file:
    writer=csv.writer(file)
    header=['First Name','Last Name','Gender','Date Of Birth','Email','Phone Number','Address','City','State','Postal Code','Country','LoyaltyProgramID']
    writer.writerow(header)

    for _ in range(row_nums):
        f_name=fake.first_name()
        l_name=fake.last_name()
        email=f_name+l_name+'@gmail.com'
        row=[
            f_name,
            l_name,
            random.choice(['M','F','Others','Not Specified']),
            fake.date(),
            email.lower(),
            fake.phone_number(),
            fake.address().replace(","," ").replace("\n"," "),
            fake.city(),
            fake.state(),
            fake.postcode(),
            fake.country(),
            random.randint(1,5)


        ]
        writer.writerow(row)