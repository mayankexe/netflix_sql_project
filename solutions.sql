-- Netflix Project
drop table if exists netflix;
create table netflix
(
	show_id varchar(7),
	type varchar(10),
	title varchar(150),
	director varchar(210), 
	casts varchar(780),
	country varchar(150),
	date_added varchar(50),
	release_year int,
	rating varchar(10),
	duration varchar(15),
	listed_in varchar(100),
	description varchar(300)
);

select * from netflix;

select count(*) as total_content from netflix;
select distinct release_year from netflix;

--15 Buisness Problems

-- 1. Count the number of Movies vs TV Shows
select
	type,
	count(*) as total_content
from netflix
group by type

-- 2. Find the most common rating for movies and TV Shows
select
	type ,
	rating,
	count(*)
from netflix
group by 1, 2
order by 3 desc

-- 3. List all the movies released in a specific year (e.g. 2020)
select * from netflix 
where type = 'Movie' and release_year = 2020

-- 4. Find the top 5 countries with the most content on netflix
select 
	unnest(string_to_array(country, ',')) as new_country,
	count(show_id) as total_content
from netflix
group by 1
order by 2 desc
limit 5

-- 5. Identify the longest movie
select * from netflix
	where type = 'Movie' and duration = (select max(duration) from netflix)

-- 6. Find content added in the last 5 years
select * from netflix
where
	to_date(date_added, 'Month DD YYYY') >= current_date - interval '5 years'

-- 7. Find all the movies/TV Shows by director 'Rajiv Chilaka'
select * from netflix
	where director ilike '%Rajiv Chilaka%'

-- 8. List all TV Shows with less than 5 seasons
select * from netflix
where
	type = 'TV Show' and
	split_part(duration, ' ', 1)::numeric > 5

-- 9. Count the number of content items in each genre
select 
	unnest(string_to_array(listed_in, ',')) as genre,
	count(show_id) as total_content
from netflix
group by 1

-- 10. Find each year and the average numbers of conten release in India on netflix. Return top 5 year with highest avg content release
select 
	extract(year from to_date(date_added, 'Month DD, YYYY')) as year,
	count(*) as yearly_content,
	round(count(*)::numeric/(select count(*) from netflix where country = 'India')::numeric * 100, 2) as avg_content_per_year
	from netflix
where country = 'India'
group by 1
group by 1

-- 11. List all the movies which are documentries
select * from netflix
	where listed_in ilike '%Documentaries%'

-- 12. Find all the content without a director
select * from netflix 
	where director is null

-- 13. Find how many movies actor 'Salman Khan' appeared in last 10 years
select * from netflix 
	where casts ilike '%Salman Khan%' and
	release_year > extract(year from current_date) - 10

-- 14. Find the top 10 actors appeared in the highest number of movies produced in India
select 
unnest(string_to_array(casts, ',')) as actors,
count(*) as total_content
from netflix
where country ilike '%India%'
group by 1
order by 2 desc
limit 10

-- 15. Categorize the content based on the presence of keywprds like 'Kill' and 'Violence' in the description field. Label content containing these keywords as 'Bad' and all other content as 'Good'. Count how many fall into each category.
with new_table as (
select *,
	case when 
		description ilike '%kill%' or 
		description ilike '%violence%'
		then 'Bad_content'
		else 'Good_content'
	end category
from netflix
)
select category,
		count(*) as total_content
from new_table
group by 1