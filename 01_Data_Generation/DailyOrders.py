import numpy as np
import pandas as pd
import os

DateId='20240728'
directory = "C:/Users/Swathi's/Desktop/project/DailyOrders"
for i in range(1,101):
    row_nums=np.random.randint(100,1000)
    data={

        'DateId':[DateId]*row_nums,
        'ProductID':np.random.randint(1,101,size=row_nums),
        'StoreID':[i]*row_nums,
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

    file_name=f'Store_{i}_{DateId}.csv'
    file_path=os.path.join(directory,file_name)
    if os.path.exists(file_path):
        os.remove(file_path)
    df.to_csv(file_path,index=False)
