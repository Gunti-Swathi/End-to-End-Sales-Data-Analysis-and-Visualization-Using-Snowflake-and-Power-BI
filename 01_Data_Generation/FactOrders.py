import numpy as np
import pandas as pd

row_nums=int(input("Enter the number of rows the csv file should have: "))
random_dates=np.random.choice(np.arange(np.datetime64("2014-01-01"), np.datetime64("2024-07-28")),size=row_nums)
formatted_rows=pd.to_datetime(random_dates).strftime('%y%m%d')

data={
    'DateId':formatted_rows,
    'ProductID':np.random.randint(1,101,size=row_nums),
    'StoreID':np.random.randint(1,101,size=row_nums),
    'CustomerID':np.random.randint(1,101,size=row_nums),
    'QuantityOrdered':np.random.randint(1,21,size=row_nums),
    'OrderAmount':np.random.randint(100,1001,size=row_nums),

}



df=pd.DataFrame(data)
discount_perc=np.random.uniform(0.02,0.5,size=row_nums)
shipping_cost=np.random.uniform(0.05,0.5,size=row_nums)
df['DiscountAmount']=df['OrderAmount']*discount_perc
df['ShippingCost']=df['OrderAmount']*shipping_cost
df['TotalAmount']=df['OrderAmount']-(df['DiscountAmount']+df['ShippingCost'])

df.to_csv('factorders.csv',index=False)