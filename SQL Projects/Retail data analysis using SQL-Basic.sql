select * from Customer
select * from Transactions
select * from prod_cat_info


--DATA PREPARATION AND UNDERSTANDING
--BEGIN Q1
select count(*) from Customer
select count(*) from Transactions
select count(*) from prod_cat_info
--END

--BEGIN Q2
select Qty,count(transaction_id) as returnedtransactions
from Transactions
where Qty < 0
group by Qty
--END

--BEGIN Q3
alter table Customer
alter column DOB date;

select convert(date,DOB,103) as DOB
FROM Customer;
select convert(date,tran_date,103) as tran_date
from Transactions;
--END

--BEGIN Q4
select convert(date,tran_date,103) as ndays
from transactions
--WRONG--



--END

--BEGIN Q5
select prod_cat
from prod_cat_info
where prod_subcat in ('DIY');
--END

--DATA ANALYSIS

--BEGIN Q1
select top 1 Store_type,count(Store_type) as storecount
from Transactions
group by Store_type
order by storecount desc;
--END

--BEGIN Q2
select
count(case when gender = 'M' THEN 1 end) as MALE,
count(case when gender = 'F' then 1 end) as FEMALE
from customer;
--END

--BEGIN Q3
select * from customer
select top 1 city_code,count(customer_id) as numberofcustomers
from customer
group by city_code;
--END

--BEGIN Q4
select * from prod_cat_info
select prod_cat,count(prod_subcat) as numberofsubcat
from prod_cat_info
where prod_cat = 'Books'
group by prod_cat
--END

--BEGIN Q5
select p3.prod_cat,max(T2.Qty) as maximumQty
from Transactions as T2
join prod_cat_info as p3 on T2.prod_cat_code = p3.prod_cat_code
group by p3.prod_cat;
--END

--BEGIN Q6
select p3.prod_cat,sum(cast(T2.total_amt as decimal(18,0))) as total
from Transactions as T2
left join prod_cat_info as p3 on T2.prod_cat_code = p3.prod_cat_code
where p3.prod_cat in ('Electronics','Books')
group by p3.prod_cat;
--END

--BEGIN Q7
select count(cust_id) as numofcustomers
from Transactions
where Qty > 0
having count(cust_id) > 10;


select 
count(case when cust_id > 10 then 1 end) as numofcust
from Transactions
where Qty > 0
--END

-- BEGIN Q8
select p3.prod_cat,T2.Store_type,sum(cast(T2.total_amt as decimal(18,0))) as combinedrevenue
from Transactions as T2
left join prod_cat_info as p3 on T2.prod_cat_code = p3.prod_cat_code
where p3.prod_cat in ('Electronics','Clothing')
and T2.Store_type = 'Flagship store'
group by p3.prod_cat,T2.Store_type;
--END
--BEGIN Q9
select c1.Gender,p3.prod_cat,p3.prod_subcat,sum(cast(T2.total_amt as decimal(18,0))) as totalrevenue
from Customer as c1
left join Transactions as T2 on c1.customer_Id = T2.cust_id
left join prod_cat_info as p3 on T2.prod_cat_code = P3.prod_cat_code
where c1.Gender = 'M'
and p3.prod_cat = 'Electronics'
group by c1.Gender,p3.prod_cat,p3.prod_subcat;
--END

--BEGIN Q10
select top 5 p3.prod_subcat,T2.Qty * 100/sum(cast(T2.Qty as decimal)) over() as percentageofreturns,
T2.total_amt * 100/sum(cast(T2.total_amt as decimal)) as percentageofsales
from Transactions as T2
left join prod_cat_info as p3 on T2.prod_cat_code = p3.prod_cat_code
group by  p3.prod_subcat,T2.Qty,T2.total_amt
having sum(cast(T2.Qty as decimal)) < 0
--END

--BEGIN Q11
select c1.customer_id,T2.total_amt,datediff(YY,convert(date,DOB,103),getdate()) as age,dateadd(day,-30,convert(date,'28-02-2014',103)) as last_30days
from Customer as c1
left join Transactions as T2 on c1.customer_Id = T2.cust_id
where datediff(YY,convert(date,DOB,103),getdate()) between 25 and 35
--END

--BEGIN Q12
select p3.prod_cat,dateadd(month,-3,convert(date,'28-02-2014',103)) as last_transaction
from prod_cat_info as p3
left join Transactions as T2 on T2.prod_cat_code = p3.prod_cat_code
group by p3.prod_cat,T2.tran_date
having max(T2.Qty) < 0 
--END



--BEGIN Q13
select top 1 Store_type,sum(cast(total_amt as decimal)) as total,max(Qty) as maxQty
from Transactions 
group by Store_type
having max(Qty) > 0
order by total desc;
--END

--BEGIN Q14

select P.prod_cat,avg(cast(T.total_amt as float)) as avg_revenue
from prod_cat_info as P
join Transactions as T on P.prod_cat_code = T.prod_cat_code
group by P.prod_cat
having avg(cast(T.total_amt as float)) >(select avg(cast(total_amt as decimal(18,0))) as overall_avg
                   from Transactions)






--END

--BEGIN Q15
select  top 5 p3.prod_subcat,avg(cast(T2.total_amt as decimal)) as average,sum(cast(T2.total_amt as decimal)) as totalrevenue,max(T2.Qty) as MaxQty
from prod_cat_info as p3
join Transactions as T2 on p3.prod_cat_code = T2.prod_cat_code
group by p3.prod_subcat
order by MaxQty desc;
--END
