select * from DIM_CUSTOMER

select * from DIM_DATE

select * from DIM_LOCATION

select * from DIM_MANUFACTURER

select * from FACT_TRANSACTIONS


select * from DIM_MODEL
--BEGIN Q1
---1. List all the states in which we have customers who have bought cellphones from 2005 till today. 

select distinct State
from DIM_LOCATION,FACT_TRANSACTIONS
where year(Date) between 2005 and datepart(year,getdate());
--END

--BEGIN Q2
---2. What state in the US is buying the most 'Samsung' cell phones? 

select L.State,M.Manufacturer_Name,sum(F.Quantity) as mostbuying
from DIM_LOCATION as L
join FACT_TRANSACTIONS as F on L.IDLocation = F.IDLocation
join DIM_MODEL as MO on F.IDModel = MO.IDModel
join DIM_MANUFACTURER as M on MO.IDManufacturer = M.IDManufacturer
where L.Country = 'US' and M.Manufacturer_Name = 'Samsung'
group by L.State,M.Manufacturer_Name
order by mostbuying desc
--END

--BEGIN Q3
---3. Show the number of transactions for each model per zip code per state.

select L.State,L.ZipCode,MO.Model_Name,count(F.IDCustomer) as numoftransactions
from DIM_LOCATION as L
join FACT_TRANSACTIONS as F on L.IDLocation = F.IDLocation
join DIM_MODEL as MO on F.IDModel = MO.IDModel
group by L.State,L.ZipCode,MO.Model_Name;
--END

--BEGIN Q4
---4. Show the cheapest cellphone (Output should contain the price also)

select top 1 M.Manufacturer_Name,MO.Model_Name,min(MO.Unit_price) as Price
from DIM_MODEL as MO
join DIM_MANUFACTURER as M on MO.IDManufacturer = M.IDManufacturer
group by M.Manufacturer_Name,MO.Model_Name;
--END

--BEGIN Q5
---5. Find out the average price for each model in the top5 manufacturers in terms of sales quantity and order by average price. 

select Manufacturer_Name,TotalQuantity,AvgPrice
from (select top 5 sum(F.Quantity) as TotalQuantity,M.Manufacturer_Name,avg(F.TotalPrice/F.Quantity) as AvgPrice
      from FACT_TRANSACTIONS as F
	  join DIM_MODEL as MO on F.IDModel = MO.IDModel
      join DIM_MANUFACTURER as M on MO.IDManufacturer = M.IDManufacturer
	  group by M.Manufacturer_Name
	  order by TotalQuantity desc) MA
order by AvgPrice;

---END---


---BEGIN Q6
---6. List the names of the customers and the average amount spent in 2009, where the average is higher than 500 

select C1.Customer_Name,avg(F.TotalPrice) as Avg_price,D.YEAR
from DIM_CUSTOMER as C1
join FACT_TRANSACTIONS as F on C1.IDCustomer=F.IDCustomer
join DIM_DATE as D on F.Date = D.DATE
where D.YEAR = 2009
group by C1.Customer_Name,D.Year
having avg(F.TotalPrice) > 500
---END



---BEGIN Q7
---7. List if there is any model that was in the top 5 in terms of quantity, simultaneously in 2008, 2009 and 2010 

select IDModel,year
from (select F.IDModel,year(F.Date) as year,row_number() over(partition by year(F.Date) order by sum(F.Quantity) desc) as row_num
     from FACT_TRANSACTIONS as F
     where year(F.Date) in (2008,2009,2010)
     group by F.IDModel,year(F.Date))MA
where row_num <=5
group by IDModel,year
having count(*)=3






---END

---BEGIN Q8
---8. Show the manufacturer with the 2nd top sales in the year of 2009 and the manufacturer with the 2nd top sales in the year of 2010.

with cte as
(
select M.Manufacturer_Name,year(F.Date) as year,dense_rank() over(partition by year(F.Date) order by sum(F.TotalPrice) desc) as rank
from  FACT_TRANSACTIONS as F
join DIM_MODEL as MO on F.IDModel = MO.IDModel
join DIM_MANUFACTURER as M on MO.IDManufacturer = M.IDManufacturer
group by  M.Manufacturer_Name,year(F.Date)
)
select Manufacturer_Name,Year
from cte
where rank = 2 and year in (2009,2010)






---END

---BEGIN Q9
---9. Show the manufacturers that sold cellphones in 2010 but did not in 2009. 

select Manufacturer_Name
from DIM_MANUFACTURER as M
where exists (select M.Manufacturer_Name,F.Date
              from FACT_TRANSACTIONS as F
			  join DIM_MODEL as MO on F.IDModel = MO.IDModel
			  join DIM_MANUFACTURER as M on MO.IDManufacturer = M.IDManufacturer
			  where year(F.Date) = 2010 and year(F.Date) not in (2009))



---END






---BEGIN Q10
---10. Find top 100 customers and their average spend, average quantity by each year. Also find the percentage of change in their spend. 

select Customer,Avg_Quantity,
Avg_spend,year,format((TotalPrice - lag(TotalPrice)over(order by Customer))/(TotalPrice),'p') as Percentage_change
from(
select top 10 avg(F.TotalPrice) as Avg_spend,C.IDCustomer as Customer,avg(F.Quantity) as Avg_Quantity,D.YEAR as year,
F.TotalPrice as TotalPrice
from FACT_TRANSACTIONS as F
join DIM_DATE as D on F.Date = D.DATE
join DIM_CUSTOMER as C on C.IDCustomer = F.IDCustomer
group by C.IDCustomer,F.TotalPrice,D.YEAR,F.Quantity
order by Avg_spend desc)MA;

---END---

select format((sum(F.TotalPrice) - lag(sum(F.TotalPrice))over(order by D.YEAR))/lag(sum(F.TotalPrice))over(order by D.YEAR),'p') as percentagechange,D.YEAR,sum(F.TotalPrice)
from FACT_TRANSACTIONS as F
join DIM_DATE as D on F.Date = D.DATE
group by D.YEAR

