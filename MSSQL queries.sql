select * from museum
select * from museum_hours


--identify the muesum which are open both on sunday and monday.display mueseum name and city
select m.name, m.city
from museum m
join museum_hours mh on mh.museum_id = m.museum_id
where mh.day in ('Sunday', 'Monday')

--which museum is open for the longest during the day. display museum name, state and hours and which days
with cte as (select 
       museum_id,
       day, 
	   DATEPART(HOUR,[open]) AS HourPartOpen, DATEPART(HOUR,[close]) AS HourPartClose, 
	   (DATEPART(HOUR,[close])- DATEPART(HOUR,[open])) as opening_hours,
       rank() over(order by (DATEPART(HOUR,[close])- DATEPART(HOUR,[open])) desc) as rnk
from museum_hours)


select name, state, day, opening_hours, rnk
from museum m
join cte  on cte.museum_id=m.museum_id
where rnk = 1



--display the country and the city with the most with most num of museum. output two separte column to display the city and country. 
--if there  are multiple values separate them by a comma

with cte as (select count(name) as tot_museum , country, rank() over(order by count(name) desc) as rnk
from museum
group by country
),


cte2 as (select count(name) as tot_museum , city, rank() over(order by count(name) desc) as rnk
from museum
group by city
)

select distinct country, STRING_AGG(city, ' ,') as city
from cte
cross join cte2
where cte.rnk=1
and cte2.rnk=1
group by country






