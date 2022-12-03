CREATE DATABASE SQL_CASE_STUDY
USE SQL_CASE_STUDY

SELECT * FROM Customer
SELECT * FROM prod_cat_info
SELECT * FROM Transactions
------------------------------------
alter table Transactions
alter  column total_amt  numeric

alter  table  transactions
alter  column  qty  numeric

alter table   transactions
alter  column rate  numeric

alter  table  transactions
alter column  tax  numeric
-----------------------------------
--DATA PREPARATION AND UNDERSTANDING
--Q1--BEGIN 

SELECT COUNT(*) AS ROW_COUNT FROM Customer
SELECT COUNT(*) AS ROW_COUNT FROM prod_cat_info
SELECT COUNT(*) AS ROW_COUNT FROM Transactions
--Q1--END

--Q2--BEGIN 
SELECT COUNT(TOTAL_AMT ) AS TOT_RETURN_AMT
FROM TransactionS
where TOTAL_AMT <0
--Q2--END

--Q3--BEGIN 

SELECT convert(date,dob,105) as date_of_birth
FROM Customer

SELECT CONVERT(DATE,TRAN_DATE,105) AS TRANSACTION_DATE
FROM TRANSACTIONS
--Q3--END
--Q4--BEGIN 
SELECT DATEDIFF(DAY,MIN(CONVERT(DATE,TRAN_DATE,105)),MAX(CONVERT(DATE,TRAN_DATE,105))) AS NO_OF_DAYSS,
DATEDIFF(MONTH,MIN(CONVERT(DATE,TRAN_DATE,105)),MAX(CONVERT(DATE,TRAN_DATE,105))) AS MONTHS,
DATEDIFF(YEAR,MIN(CONVERT(DATE,TRAN_DATE,105)),MAX(CONVERT(DATE,TRAN_DATE,105))) AS YEARS
FROM TRANSACTIONS
--Q4--END
--Q5--BEGIN 
SELECT PROD_CAT,
PROD_SUBCAT
FROM PROD_CAT_INFO
WHERE PROD_SUBCAT IN('DIY')
--Q5--END



--DATA ANALYSIS
--Q1--BEGIN 
SELECT TOP 1
STORE_TYPE,
COUNT(TRANSACTION_ID) AS COUNT_ORDER
FROM Transactions
GROUP BY Store_type
ORDER BY COUNT_ORDER DESC
--Q1--END

--Q2--BEGIN 
SELECT Gender,
COUNT(CUSTOMER_ID) AS COUNT_
FROM CUSTOMER
GROUP BY GENDER
HAVING GENDER IN ('M','F')
--Q2--END

--Q3--BEGIN 
SELECT TOP 1
CITY_CODE,
COUNT(CUSTOMER_ID) AS MAX_CUSTOMER
FROM CUSTOMER
GROUP BY CITY_CODE
--Q3--END


--Q4--BEGIN 
select  
count(prod_subcat) as count_subcat
from prod_cat_info
group by prod_cat
having prod_cat = 'books'
--Q4--END

 


--Q5--BEGIN 
SELECT top 1
X.prod_cat_code,
X.prod_sub_cat_code,
prod_subcat
FROM prod_cat_info AS X
INNER JOIN TRANSACTIONS AS Y
ON X.prod_sub_cat_code =  Y.prod_subcat_code
AND X.prod_cat_code = Y.prod_cat_code
ORDER BY QTY DESC

SELECT * FROM CUSTOMER
SELECT * FROM Transactions
SELECT * FROM prod_cat_info
--Q5--END

--Q6--BEGIN 
select prod_cat,
sum(total_amt ) as tot_rev
from Transactions as x
inner join prod_cat_info as y
on x.prod_cat_code = y.prod_cat_code 
and x.prod_subcat_code = y.prod_sub_cat_code
group by prod_cat
having prod_cat in ('electronics', 'books')
--Q6--END


--Q7--BEGIN 
select * from Customer as x
inner join Transactions as y
on x.customer_Id = y.cust_id

select * from Customer
select * from Transactions
--Q7--END

--Q8--BEGIN 
SELECT 
SUM(TOTAL_AMT ) AS TOTAL_REV
FROM Transactions AS X 
INNER JOIN prod_cat_info AS Y
on x.prod_cat_code = y.prod_cat_code 
and x.prod_subcat_code = y.prod_sub_cat_code
where prod_cat IN ('ELECTRONICS','CLOTHING')
AND STORE_TYPE = 'FLAGSHIP STORE'

--Q8--END


--Q9--BEGIN 
SELECT PROD_SUBCAT,
SUM(TOTAL_AMT) AS TOT_REV
FROM Transactions AS X
LEFT JOIN Customer AS Y
ON X.cust_id = Y.customer_Id
LEFT JOIN prod_cat_info AS Z
ON X.prod_subcat_code = Z.prod_sub_cat_code
AND  x.prod_cat_code = Z.prod_cat_code 
GROUP BY prod_subcat , Gender, prod_cat
HAVING Gender = 'M' AND
prod_cat = 'ELECTRONICS'

--Q9--END

--Q10--BEGIN 
SELECT TOP 5
 prod_subcat,
(SUM(total_amt)/(SELECT SUM(TOTAL_AMT) FROM Transactions))*100 AS PERCENT_SALES,
(COUNT(
CASE 
		WHEN QTY <0 THEN QTY ELSE NULL END)/SUM(QTY))*100 AS PERCENTAGE_OF_RETURN
FROM Transactions as X
INNER JOIN prod_cat_info AS Y
on x.prod_cat_code = y.prod_cat_code 
and x.prod_subcat_code = y.prod_sub_cat_code
GROUP BY prod_subcat
ORDER BY SUM(TOTAL_AMT) DESC
--Q10--END

--Q11--BEGIN
select CUST_ID,
sum(TOTAL_AMT) AS Tot_Rev
FROM Transactions
where CUST_ID IN (select CUSTOMER_ID 
FROM Customer 
Where datediff(year,CONVERT(DATE,DOB,103),GETDATE()) BETWEEN 25 AND 35)
AND CONVERT(DATE,tran_date,103) BETWEEN Dateadd(Day,-30,(select Max(CONVERT(date,tran_date,103)) FROM Transactions)) 
AND
(select MAX(convert(DATE,tran_date,103)) FROM Transactions)
Group by CUST_ID
--Q11--END

--Q12--BEGIN 
SELECT top 1
PROD_CAT,
SUM(TOTAL_AMT) as tot_amt
FROM Transactions AS X
INNER JOIN prod_cat_info AS Y
on x.prod_cat_code = y.prod_cat_code 
and x.prod_subcat_code = y.prod_sub_cat_code
WHERE total_amt<0 AND
CONVERT(date,tran_date,103) between DATEADD(month,-3,(select max(convert(date,tran_date,103)) from Transactions))
and (select max(convert(date,tran_date,103)) from Transactions)
GROUP BY prod_cat
order by tot_amt desc
--Q12--END


--Q13--BEGIN
SELECT STORE_TYPE ,
SUM(CAST(TOTAL_AMT AS FLOAT)) AS TOT_SALE,
SUM(CAST(QTY AS INT)) AS TOT_QTY
FROM TRANSACTIONS
GROUP BY Store_type
HAVING SUM(CAST(TOTAL_AMT AS FLOAT)) >=ALL (SELECT SUM(CAST(TOTAL_AMT AS FLOAT)) FROM TRANSACTIONS group by Store_type )
AND SUM(CAST(Qty AS INT)) >= ALL ( SELECT SUM(CAST(QTY AS INT)) FROM Transactions group by Store_type )

--Q13--END

--Q14--BEGIN
SELECT PROD_CAT,
AVG(TOTAL_AMT) AS AVG_AMT 
FROM TRANSACTIONS AS X
INNER JOIN prod_cat_info AS Y
on x.prod_cat_code = y.prod_cat_code 
and x.prod_subcat_code = y.prod_sub_cat_code
GROUP BY PROD_CAT
HAVING AVG(TOTAL_AMT ) > ALL( SELECT AVG(TOTAL_AMT) FROM Transactions )
--Q14--END

--Q15--BEGIN
SELECT prod_subcat, prod_cat , 
SUM(TOTAL_AMT) AS TOT_REV, 
AVG(TOTAL_AMT) AS AVG_REV
FROM Transactions AS X 
INNER JOIN prod_cat_info AS Y
ON X.prod_cat_code = Y.prod_cat_code
AND X.prod_subcat_code = Y.prod_sub_cat_code
GROUP BY prod_subcat, prod_cat
HAVING  PROD_CAT IN 
(
SELECT  TOP 5
PROD_CAT
FROM TRANSACTIONS AS X
INNER JOIN prod_cat_info AS Y
ON X.prod_cat_code = Y.prod_cat_code
AND X.prod_subcat_code = Y.prod_sub_cat_code
GROUP BY PROD_CAT
ORDER BY SUM(TOTAL_AMT) DESC
)
--Q15--END






