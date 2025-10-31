CREATE or replace database Project
CREATE or replace schema Proj
USE Project;
USE schema proj;
use role accountadmin;



CREATE TABLE DimDate (
    DateID INT PRIMARY KEY,
    Date DATE,
    DayOfWeek VARCHAR(10),
    Month VARCHAR(10),
    Quarter INT,
    Year INT,
    IsWeekend BOOLEAN
);

CREATE OR REPLACE TABLE DimCustomer (
    CustomerID INT PRIMARY KEY autoincrement start 1 increment 1,
    FirstName VARCHAR(100),
    LastName VARCHAR(100),
    Gender VARCHAR(100),
    DateOfBirth DATE,
    Email VARCHAR(100),
    PhoneNumber VARCHAR(100),
    Address VARCHAR(255),
    City VARCHAR(100),
    State VARCHAR(100),
    ZipCode VARCHAR(100),
    Country VARCHAR(200),
    LoyaltyProgramID INT
);
CREATE TABLE DimProduct (
    ProductID INT PRIMARY KEY autoincrement start 1 increment 1,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Brand VARCHAR(50),
    UnitPrice DECIMAL(10, 2)
);
-- Dimension Table: DimStore
CREATE TABLE DimStore (
    StoreID INT PRIMARY KEY autoincrement start 1 increment 1,
    StoreName VARCHAR(200),
    StoreType VARCHAR(100),
    StoreOpeningDate DATE,
    Address VARCHAR(255),
    City VARCHAR(200),
    State VARCHAR(200),
    Country VARCHAR(200),
    Region VARCHAR(200),
    ManagerName VARCHAR(100)
);
-- Fact Table: FactOrders
CREATE TABLE FactOrders (
    OrderID INT PRIMARY KEY autoincrement start 1 increment 1,
    DateID INT,
    CustomerID INT,
    ProductID INT,
    StoreID INT,
    QuantityOrdered INT,
    OrderAmount DECIMAL(10, 2),
    DiscountAmount DECIMAL(10, 2),
    ShippingCost DECIMAL(10, 2),
    TotalAmount DECIMAL(10, 2),
    FOREIGN KEY (DateID) REFERENCES DimDate(DateID),
    FOREIGN KEY (CustomerID) REFERENCES DimCustomer(CustomerID),
    FOREIGN KEY (ProductID) REFERENCES DimProduct(ProductID),
    FOREIGN KEY (StoreID) REFERENCES DimStore(StoreID)
);
CREATE OR REPLACE TABLE DimLoyaltyInfo (
    LoyaltyProgramID   INT PRIMARY KEY,
    ProgramName        VARCHAR(100),
    ProgramTier        VARCHAR(50),
    PointsAccrued     INT
);

CREATE OR REPLACE FILE FORMAT csv_file_format
TYPE='CSV'
SKIP_HEADER=1
FIELD_OPTIONALLY_ENCLOSED_BY='"'
DATE_FORMAT='YYYY-MM-DD';


CREATE OR REPLACE STAGE Projectstage;

COPY INTO DimLoyaltyInfo
FROM @PROJECT.PROJ.PROJECTSTAGE/DIMLOYALTYINFO/
FILE_FORMAT = (FORMAT_NAME = 'CSV_FILE_FORMAT');

select * from DIMLOYALTYINFO;

COPY INTO DIMSTORE(StoreName,StoreType,StoreOpeningDate,Address,City,State,Country,REGION,ManagerName)
FROM @PROJECT.PROJ.PROJECTSTAGE/DimStore/
FILE_FORMAT = (FORMAT_NAME = 'CSV_FILE_FORMAT');
select * from DIMSTORE;

COPY INTO DimCustomer(FirstName, LastName, Gender, DateOfBirth, Email, PhoneNumber, Address, City, State, ZipCode, Country, LoyaltyProgramID)
FROM @PROJECT.PROJ.PROJECTSTAGE/DimCustomer/
FILE_FORMAT = (FORMAT_NAME = 'CSV_FILE_FORMAT');
select * from DimCustomer;

COPY INTO DimProduct(ProductName, Category, Brand, UnitPrice)
FROM @PROJECT.PROJ.PROJECTSTAGE/DimProduct/
FILE_FORMAT = (FORMAT_NAME = 'CSV_FILE_FORMAT');
select * from DimProduct;


ALTER TABLE DimDate RENAME COLUMN Date TO FullDate;

COPY INTO DimDate(DateID, FullDate, DayOfWeek, Month, Quarter, Year, IsWeekend)
FROM @PROJECT.PROJ.PROJECTSTAGE/DimDate/
FILE_FORMAT = (FORMAT_NAME = 'CSV_FILE_FORMAT');

SELECT * FROM DimDate;

COPY INTO FactOrders(DateID, CustomerID, ProductID, StoreID, QuantityOrdered, OrderAmount, DiscountAmount, ShippingCost, TotalAmount)
FROM @PROJECT.PROJ.PROJECTSTAGE/FACTORDERS
FILE_FORMAT = (FORMAT_NAME = 'CSV_FILE_FORMAT');

select * from FactOrders limit 100;

COPY INTO FactOrders(DateID, CustomerID, ProductID, StoreID, QuantityOrdered, OrderAmount, DiscountAmount, ShippingCost, TotalAmount)
FROM @PROJECT.PROJ.PROJECTSTAGE/DAILYORDERS
FILE_FORMAT = (FORMAT_NAME = 'CSV_FILE_FORMAT');

select * from FactOrders limit 100;

CREATE OR REPLACE USER Test_PowerBI_User
PASSWORD = 'Test_PowerBI_User'
LOGIN_NAME = 'PowerBI User'
DEFAULT_ROLE = 'ACCOUNTADMIN'
DEFAULT_WAREHOUSE = 'COMPUTE_WH'
MUST_CHANGE_PASSWORD = TRUE;

-- grant it accountadmin access
grant role accountadmin to user Test_PowerBI_User;

-- QUERY 1
-- SELECT DATEDIFF(DAY,'2014-01-01',CURRENT_DATE());

UPDATE DIMSTORE SET STOREOPENINGDATE=DATEADD(DAY,UNIFORM(0,3800,RANDOM()),'2014-01-01');

SELECT * FROM DIMSTORE;

-- QUERY2

-- SELECT dateadd(year,-1,current_date())

CREATE OR REPLACE TABLE DIMSTORE AS
SELECT * FROM DIMSTORE BEFORE (STATEMENT => '01bf714e-0000-3699-0061-a18b0004706e');

UPDATE DIMSTORE  SET STOREOPENINGDATE=DATEADD(DAY,UNIFORM(0,365,RANDOM()),'2023-07-30') 
WHERE STOREID BETWEEN 91 AND 100;

SELECT * FROM DIMSTORE;

-- QUERY 3
-- select * from dimcustomer where dateofbirth>=DATEADD(years,-12,CURRENT_DATE());
UPDATE DIMCUSTOMER 
SET DATEOFBIRTH=DATEADD(YEAR,-12,DATEOFBIRTH) where dateofbirth>=DATEADD(years,-12,CURRENT_DATE());

-- QUERY 4
-- SELECT * FROM FACTORDERS AS F
-- JOIN DIMDATE AS D ON D.DATEID=F.DATEID
-- JOIN DIMSTORE AS S ON F.STOREID=S.STOREID
-- WHERE D.FULLDATE<S.STOREOPENINGDATE;
UPDATE FACTORDERS f
SET f.dateid = r.dateid
FROM (
    SELECT o.orderid, d2.dateid
    FROM (
        SELECT f.orderid,
               DATEADD(
                   day,
                   DATEDIFF(day, s.storeopeningdate, CURRENT_DATE) * UNIFORM(1, 10, RANDOM())*1,
                   s.storeopeningdate
               ) AS new_date
        FROM FACTORDERS f
        JOIN DIMDATE d1 ON f.dateid = d1.dateid
        JOIN DIMSTORE s ON f.storeid = s.storeid
        WHERE d1.fulldate > s.storeopeningdate
    ) o
    JOIN DIMDATE d2 ON o.new_date = d2.fulldate
) r
WHERE f.orderid = r.orderid;

-- UPDATE FACTORDERS f
-- SET f.dateid = r.dateid
-- FROM (
--     SELECT o.orderid, d2.dateid
--     FROM (
--         SELECT f.orderid,
--                DATEADD(
--                    day,
--                    DATEDIFF(day, s.storeopeningdate, CURRENT_DATE) * UNIFORM(1, 10, RANDOM())*.1,
--                    s.storeopeningdate
--                ) AS new_date
--         FROM FACTORDERS f
--         JOIN DIMDATE d1 ON f.dateid = d1.dateid
--         JOIN DIMSTORE s ON f.storeid = s.storeid
       
--     ) o
--     JOIN DIMDATE d2 ON o.new_date = d2.fulldate
-- ) r
-- WHERE f.orderid = r.orderid;


-- QUERY 5
select * from dimcustomer
where customerid NOT IN
(SELECT distinct c.customerid from dimcustomer as c
join factorders as f
on c.customerid=f.customerid
join dimdate d on f.dateid=d.dateid
where d.FULLDATE>=dateadd(month,-1,current_date()));

-- Query 6
With storerank as(
Select storeid,storeopeningdate, row_number()over(order by storeopeningdate desc) as final_rank
from dimstore
),
mostrecentstore as(
select storeid from storerank
where final_rank=1
),
storeamount as
(
select f.storeid,sum(totalamount) as totalamount from factorders as f join mostrecentstore as r 
on f.storeid=r.storeid
group by f.storeid
)
select s.*,a.* from dimstore as s join storeamount as a
on s.storeid=a.storeid;


-- query 7
with basedata as(
select f.customerid,p.category from factorders as f join dimdate as d
on d.dateid=f.dateid
join dimproduct as p on f.productid=p.productid
where d.fulldate=dateadd(months,-6,current_date())
group by f.customerid,p.category
)
select customerid from basedata
group by customerid
having count(distinct category)>3;

-- query 8


select month,sum(f.totalamount)from factorders as f join dimdate as d
on f.dateid=d.dateid
-- where d.year=2016

where d.year=extract(year from current_date())
group by month
order by month;

-- query 9
select orderid,max(discountamount)as max from factorders as f join dimdate as d on f.dateid=d.dateid
where d.fulldate=dateadd(year,-1,current_date())
group by orderid
order by max desc
limit 1;

-- query 10
select sum(quantityordered *unitprice)from factorders as f join dimproduct as p
on f.productid=p.productid;
-- query 11
select customerid,sum(discountamount) as sumof from factorders as f
group by customerid
order by sumof desc
limit 1;
-- query 12
with basicdata as(
select customerid,count(orderid) as counti ,row_number()over(order by counti desc) as finrank from factorders as f
group by customerid
)
select customerid from basicdata
where finrank=1;

-- query 13
select brand,sum(totalamount) as total from factorders as f join dimdate as d
on f.dateid = d.dateid
join dimproduct as p on f.productid=p.productid

where d.fulldate>=dateadd(year,-1,current_date())
group  by brand
order by total desc
limit 3;
-- query 14
select
case when sum(orderamount-orderamount*0.5-orderamount*0.8)>sum(totalamount) then 'yes'
else 'no'
end
from factorders as f;
  
-- query 15
select l.programtier, count(customerid) as totalcustomer from dimcustomer as c join dimloyaltyinfo as l
on c.loyaltyprogramid=l.loyaltyprogramid
group by programtier;

-- query 16
select region,category,sum(totalamount) as totalsales
from factorders as f
join dimdate as d on f.dateid=d.dateid
join dimproduct as p on f.productid=p.productid
join dimstore as s on f.storeid=s.storeid
where d.fulldate>=dateadd(month,-6,current_date())
group by region,category;
-- query 17
Select p.productid, sum(quantityordered)   from factorders as f
join dimproduct as p on f.productid=p.productid
join dimdate as d on f.dateid=d.dateid
where d.fulldate>=dateadd(year,-3,current_date())
group by p.productid
order by sum(quantityordered) desc
limit 5;
-- query 18
select l.programname ,sum(totalamount) as amount from factorders as f 
join dimdate as d on f.dateid = d.dateid
join dimcustomer as c on f.customerid = c.customerid
join dimloyaltyinfo as l on c.loyaltyprogramid = l.loyaltyprogramid
where d.year>=2023
group by programname;
-- query 19
select s.managername ,sum(totalamount) as amount from factorders as f 
join dimdate as d on f.dateid = d.dateid
join dimcustomer as c on f.customerid = c.customerid
join dimstore as s on f.storeid=s.storeid
where d.year=2024 and d.month=7
group by s.managername;

-- query 20
select avg(orderamount),f.storeid, s.storename from factorders as f
join dimstore as s on f.storeid=s.storeid
join dimdate as d on f.dateid = d.dateid
where d.year=2024
group by storename,f.storeid;

-- query 21
list @projectstage;
SELECT $1,$2,$3
FROM @PROJECT.PROJ.PROJECTSTAGE/DimCustomer
(FILE_FORMAT=>'csv_file_format');
-- query 22
select count($1)
FROM @PROJECT.PROJ.PROJECTSTAGE/DimCustomer
(FILE_FORMAT=>'csv_file_format');
-- query 23
select $1,$2,$3,$4,$5 from
@PROJECT.PROJ.PROJECTSTAGE/DimCustomer
(FILE_FORMAT=>'csv_file_format')
where $4<'2000-01-01';
-- query 24
with custo as
(
SELECT $1 as First_name , $12 as loyalityprogramid
FROM @PROJECT.PROJ.PROJECTSTAGE/DimCustomer/
(FILE_FORMAT=>'csv_file_format')
),
LOYALITY AS
(
SELECT $1 as loyalityprogramid, $3 as programtier
FROM @PROJECT.PROJ.PROJECTSTAGE/DIMLOYALTYINFO/
(FILE_FORMAT=>'csv_file_format')
)
select FIRST_NAME,programtier FROM CUSTO AS C JOIN LOYALITY AS L
ON C.LOYALITYPROGRAMID=L.LOYALITYPROGRAMID;

-- QUERY 25
with custo as
(
SELECT $1 as First_name , $12 as loyalityprogramid
FROM @PROJECT.PROJ.PROJECTSTAGE/DimCustomer/
(FILE_FORMAT=>'csv_file_format')
),
LOYALITY AS
(
SELECT $1 as loyalityprogramid, $3 as programtier
FROM @PROJECT.PROJ.PROJECTSTAGE/DIMLOYALTYINFO/
(FILE_FORMAT=>'csv_file_format')
)
select programtier,COUNT(1) AS TOTALCOUNT FROM CUSTO AS C JOIN LOYALITY AS L
ON C.LOYALITYPROGRAMID=L.LOYALITYPROGRAMID
GROUP BY programtier;



;





