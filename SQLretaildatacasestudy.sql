--CASESTUDY RETAIL DATA ANALYSIS
--Q1.Begins
select  count (*)as totalrows_Customer from Customer
union
select  count (*) as totalrows_prod from prod_cat_info 
union
select  count (*) as totalrows_trans from Transactions
--Q1.Ends

--Q2.Begins
select count(*) from Transactions
where Qty<1
--Q2.Ends

--Q3.Begins:
--dates are converted to datetime format
--before importing files convert csv format to excel file format
--It will change date format itself.
--Q3.Ends

--Q4.Begins:
select datediff(day,min(tran_date),max(tran_date))as days,
DATEDIFF(month,min(tran_date),max(tran_date)) as months,
DATEDIFF(year,min(tran_date),max(tran_date)) as year
from Transactions
--Q4.Ends

--Q5.Begins
select prod_cat,prod_subcat from  prod_cat_info
where prod_subcat='DIY'
--Q5.Ends

--Data Analysis
--Q1.Begins
select top 1 Store_type
from Transactions
group by Store_type 
order by count(transaction_id) desc
--Q1.Ends

--Q2.Begins
select 
sum( case when gender='m' then 1 else 0 end)as malecount,
sum( case when gender='f' then 1 else 0 end)as femalecount
from customer
--Q2.Ends

--Q3.Begins
select  top 1 count(customer_id) as numberofcustomer,city_code
from Customer
group by city_code
order by count(customer_Id) desc
--Q3.Ends

--Q4.Begins
select count(prod_subcat) from prod_cat_info
where prod_cat='books'
--Q4.Ends

--Q5.Begins
select  top 1 Qty from Transactions
order by qty desc
--Q5.Ends

--Q6.Begins
select sum(t.total_amt)  from Transactions as t
inner join prod_cat_info as p
on t.prod_cat_code=p.prod_cat_code and p.prod_sub_cat_code=t.prod_subcat_code
where p.prod_cat in('electronics','books') 
--Q6.Ends

--Q7.Begins 
select count(customer_Id) from Customer
where customer_Id in (
select cust_id as customer from Transactions
where total_amt not like '-%'
 group by cust_id
having count(transaction_id)>10)
--Q7.Ends

--Q8.Begins
select round(sum(t.total_amt),2) as totalrevenue from Transactions as t
inner join prod_cat_info as p
on t.prod_cat_code=p.prod_cat_code and p.prod_sub_cat_code=t.prod_subcat_code
where p.prod_cat in('electronics','clothing' )
and Store_type='flagship store'
--Q8.Ends

--Q9.Begins
select prod_subcat,sum(total_amt) as total_revenue from customer as c
left join  Transactions as t 
on c.customer_Id=t.cust_id
left join prod_cat_info as p
on t.prod_cat_code=p.prod_cat_code and
 t.prod_subcat_code=p.prod_sub_cat_code
where gender='m' and prod_cat='electronics'
group by prod_subcat
--Q9.End

--Q10.Begin
select  top 5 (sp.prod_subcat), salespercent,returnpercent from
(select  distinct p.prod_subcat,
(sum(qty)/(select  
sum(qty) as bc
from Transactions as t 
left join prod_cat_info as p
on  t.prod_cat_code=p.prod_cat_code
 and prod_subcat_code=p.prod_sub_cat_code
where Qty>0)*100) as salespercent
from Transactions as t 
left join prod_cat_info as p
on t. prod_subcat_code=p.prod_sub_cat_code
where Qty>0
group by  prod_subcat) as sp
left join
(select  distinct p.prod_subcat,
(sum(qty)*(-1)/(select (sum(qty)) as bc
from Transactions as t 
left join prod_cat_info as p
on t. prod_subcat_code=p.prod_sub_cat_code
where Qty>0)*100)
 as returnpercent
from Transactions as t  
left join prod_cat_info as p
on t. prod_subcat_code=p.prod_sub_cat_code
where Qty<0
group by  prod_subcat) as rp
on sp.prod_subcat=rp.prod_subcat
order by salespercent desc
--Q10.Ends

--Q11.Begins 
select sum(total_amt) as totalrevenue from Transactions
where cust_id in 
(select customer_id from Customer
where datediff (year,DOB,getdate()) between 25 and 35) 
and tran_date between dateadd(day,-30,(select max(tran_date)from Transactions)) and 
(select max(tran_date) from Transactions)
--Q11 Ends

--Q12.Begins
select top 1 prod_cat from Transactions as t
inner join prod_cat_info as p
on t.prod_cat_code=p.prod_cat_code and t.prod_subcat_code=p.prod_sub_cat_code
where t.total_amt<0  and t.tran_date between dateadd(month,-3,(select max(tran_date)from Transactions)) and 
(select Max(tran_date) from Transactions)
group by p.prod_cat
order by sum(total_amt) asc
--Q12.Ends

--Q13.Begins
select top 1 store_type from Transactions
group by Store_type
order by sum(qty) desc,sum(total_amt) desc
--Q13Ends

--Q14 Begins
select prod_cat,  avg(total_amt) as averagerevenue from Transactions as t
inner join prod_cat_info as p 
on t.prod_cat_code=p.prod_cat_code and t.prod_subcat_code=p.prod_sub_cat_code
group by prod_cat
having avg(total_amt)>(select avg(total_amt) from Transactions)
--Q14 Ends

--Q15 Begins
 select prod_cat, prod_subcat,avg(total_amt) as averagerevenue ,
 sum(total_amt) as totalrevenue from Transactions as t
inner join prod_cat_info as p
on t.prod_cat_code=p.prod_cat_code and t.prod_subcat_code=p.prod_sub_cat_code
where prod_cat in (select  top 5 prod_cat from Transactions as t
inner join prod_cat_info as p
on t.prod_cat_code=p.prod_cat_code and t.prod_subcat_code=p.prod_sub_cat_code
group by prod_cat
order by count(qty) desc) 
group by prod_cat, prod_subcat
--Q15 Ends
