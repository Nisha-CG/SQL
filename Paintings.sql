use Paintings;


select * from artist;
select * from canvas_size;
select * from image_link;
select * from museum;
select * from museum_hours;
select * from product_size;
select * from subject;
select * from work;

-- 1. Fetch all the paintings which are not displayed on any museums?
select * from work
where museum_id is null;

-- 2. Are there museums without any paintings?
select m.museum_id, w.work_id from museum m
full outer join work w
on m.museum_id = w.museum_id
where w.work_id is null;

-- 3. How many paintings have an asking price of more than their regular price?
select * from product_size
where sale_price > regular_price;

--4. Identify the paintings whose asking price is less than 50% of its regular price
select * from product_size
where sale_price < (0.5*regular_price);

--5. Which canva size costs the most?
select top 1 ps.size_id, max(ps.sale_price) max_sale,max(ps.regular_price) max_reg from canvas_size cs
join product_size ps 
on cs.size_id = ps.size_id
group by ps.size_id
order by max_sale desc,max_reg desc;

--6. Delete duplicate records from work, product_size, subject and image_link tables
select distinct * from work;
select distinct * from product_size;
select distinct * from image_link;

delete from work
where work_id not in(
select work_id 
from work
group by work_id
having count(*) = 1);

delete from product_size
where (work_id,size_id) in(
select work_id, size_id 
from product_size
group by work_id, size_id
having count(*) > 1);

delete from product_size
where work_id in (
select work_id 
from product_size
group by work_id
having count(*) > 1)
and size_id in(
select size_id 
from product_size
group by size_id
having count(*) > 1);

drop table product_size;

delete from image_link
where work_id not in(
select work_id 
from image_link
group by work_id
having count(*) = 1);

--7. Identify the museums with invalid city information in the given dataset

select * from museum
where ISNUMERIC(city) = 1;




