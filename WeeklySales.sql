select count(*) from weekly_sales;

select week_date,
weekofyear(week_date) wk,
month(week_date) mnth,
year(week_date) yr,
case
when segment like '%1%' then 'Young Adults'
when segment like '%2%' then 'Middle Aged'
when segment like '%3%' or '%4%' then 'Retirees'
else 'unknown'
end as age_band,
case 
when segment like 'C%' then 'Couples'
when segment like 'F%' then 'Families'
else 'unknown'
end as demographic,
sales/transactions as avg_transactions
from weekly_sales;

create table clean_weekly_sales as
select week_date, 
weekofyear(week_date) wk,
month(week_date) mnth,
year(week_date) yr,
region, platform,
segment,
case
when segment like '%1%' then 'Young Adults'
when segment like '%2%' then 'Middle Aged'
when segment like '%3%' or segment like '%4%' then 'Retirees'
else 'unknown'
end as age_band,
case 
when segment like 'C%' then 'Couples'
when segment like 'F%' then 'Families'
else 'unknown'
end as demographic,
customer_type, transactions, sales,
sales/transactions as avg_transactions
from weekly_sales;

select * from clean_weekly_sales;



-- 2.	How many total transactions were there for each year in the dataset? 
select yr, sum(transactions) total
from clean_weekly_sales
group by yr;

-- 3.	What are the total sales for each region for each month?
select region, mnth, sum(sales) total
from clean_weekly_sales
group by region, mnth;

-- 4.	What is the total count of transactions for each platform
select platform, count(transactions) cnt
from clean_weekly_sales
group by platform;

-- 5.	What is the percentage of sales for Retail vs Shopify for each month?
select platform,mnth, (sum(sales)*100)/(select sum(sales) from clean_weekly_sales) percent
from clean_weekly_sales
group by platform,mnth;

-- 6.	What is the percentage of sales by demographic for each year in the dataset?
select yr,demographic, (sum(sales)*100)/(select sum(sales) from clean_weekly_sales) percent
from clean_weekly_sales
group by yr,demographic;

-- 7.	Which age_band and demographic values contribute the most to Retail sales?
select yr,age_band, demographic, sum(sales) total
from clean_weekly_sales
group by yr, age_band, demographic
order by total desc;
