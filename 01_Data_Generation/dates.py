import pandas as pd
start_date='2014-01-01'
end_date='2024-12-31'
date_range=pd.date_range(start=start_date,end=end_date)
date=pd.DataFrame(date_range,columns=['Date'])
date['Dayofweek']=date['Date'].dt.day_of_week
date['Month']=date['Date'].dt.month
date['Quarter']=date['Date'].dt.quarter
date['Year']=date['Date'].dt.year
date['Isweekend']=date['Dayofweek'].isin([5,6])
date['DateId']=date['Date'].dt.strftime('%Y%m%d').astype(int)
cols=['DateId']+[col for col in date.columns if col!='DateId']
date=date[cols]
# export to csv
date.to_csv('DimDate.csv',index=False)