use Airline;

show tables;

select * from maindata;

describe maindata;

alter table maindata rename column `%Distance Group ID` to `Distance_Group_ID`;
alter table maindata rename column `# Available Seats` to `Available_Seats`;
alter table maindata rename column `From - To City` to `From_To_City`;
alter table maindata rename column `Carrier Name` to `Carrier_Name`;
alter table maindata rename column `# Transported Passengers` to `Transported_Passengers`;
alter table maindata rename column `%Airline ID` to `Airline_ID`;
alter table maindata rename column `Month (#)` to `Month`;

create view order_date as 
select
	concat(Year,'-', Month,'-', day) as order_date,
    Distance_Group_ID,
    Available_Seats,
    From_To_City,
    Carrier_Name,
    Transported_Passengers,
    Airline_ID
from
	maindata;

####"1.calcuate the following fields from the Year	Month (#)	Day  fields ( First Create a Date Field from Year , Month , Day fields)"
--   A.Year
--   B.Monthno
--   C.Monthfullname
--   D.Quarter(Q1,Q2,Q3,Q4)
--   E. YearMonth ( YYYY-MMM)
--   F. Weekdayno
--   G.Weekdayname
--   H.FinancialMOnth
--   I. Financial Quarter 

create view kpi1 as select year(order_date) as year_number,
month(order_date) as month_number,
day (order_date) as day_number,
monthname(order_date) as month_name,
concat("Q",quarter(order_date)) as quarter_number,
concat(year(order_date),'-',monthname(order_date)) as year_month_number,
weekday(order_date) as weekday_number,
dayname(order_date) as day_name,
case
when quarter(order_date) = 1 then "FQ4"
when quarter(order_date) = 2 then "FQ1"
when quarter(order_date) = 3 then "FQ2"
when quarter(order_date) = 4 then "FQ3"
end as Financial_Quarters,
case
when month(order_date) = 1 then "10"
when month(order_date) = 2 then "11"
when month(order_date) = 3 then "12"
when month(order_date) = 4 then "1"
when month(order_date) = 5 then "2"
when month(order_date) = 6 then "3"
when month(order_date) = 7 then "4"
when month(order_date) = 8 then "5"
when month(order_date) = 9 then "6"
when month(order_date) = 10 then "7"
when month(order_date) = 11 then "8"
when month(order_date) = 12 then "9"
end as Financial_month,
case
when weekday(order_date) in (5,6) then "Weekend"
when weekday(order_date) in (0, 1, 2, 3, 4) then "Weekday"
end as weekend_Weekday,
	Distance_Group_ID,
    Available_Seats,
    From_To_City,
    Carrier_Name,
    Transported_Passengers,
    Airline_ID

from order_date;


select * from kpi1;
-------------------------------------------------------------------------------------
-- 2. Find the load Factor percentage on a yearly , Quarterly , Monthly basis ( Transported passengers / Available seats)

select year_number,sum(Transported_Passengers),sum(Available_Seats),
(sum(Transported_Passengers)/sum(Available_Seats)*100)
as "load_Factor" from kpi1 group by year_number;

select quarter_number,sum(Transported_Passengers),sum(Available_Seats),
(sum(Transported_Passengers)/sum(Available_Seats)*100)
as "load_Factor" from kpi1 group by quarter_number order by quarter_number;

select month_name,sum(Transported_Passengers),sum(Available_Seats),
(sum(Transported_Passengers)/sum(Available_Seats)*100)
as "load_Factor" from kpi1 group by month_name order by load_Factor desc;

--------------------------------------------------------------------------------------------------
-- 3. Find the load Factor percentage on a Carrier Name basis ( Transported passengers / Available seats)

select Carrier_Name, sum(Transported_Passengers),sum(Available_Seats),
(sum(Transported_Passengers)/sum(Available_Seats)*100)
as "load_Factor" from kpi1 group by Carrier_Name order by load_Factor desc;

-----------------------------------------------------------------------------------------------------------------
-- 4. Identify Top 10 Carrier Names based passengers preference

select Carrier_Name,sum(Transported_Passengers)
from kpi1 group by Carrier_Name order by sum(Transported_Passengers) desc limit 10;

-----------------------------------------------------------------------------------------------------------------
-- 5. Display top Routes ( from-to City) based on Number of Flights 

select From_To_City,count(From_To_City) as Number_of_flights from kpi1
group by From_To_City order by count(From_To_City) desc limit 10;

--------------------------------------------------------------------------------------------------------------
-- 6. Identify the how much load factor is occupied on Weekend vs Weekdays.

select weekend_weekday,sum(Transported_Passengers),sum(Available_Seats),
(sum(Transported_Passengers)/sum(Available_Seats)*100)
as "load_Factor" from kpi1 group by weekend_weekday;

--------------------------------------------------------------------------------------------------------------





