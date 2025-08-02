select * from netflix;
select count(*) as total_content
from netflix;
Select Distinct type from netflix;
Select * from netflix;
-- 15 Business Problems & Solutions
--1. Count the number of Movies vs TV Shows.
Select type, 
	Count(*) as total_countent
From netflix
Group by type

--2. Find the most common rating for movies and TV shows.
Select
	type,
	rating
From 
(
	select
		type,
		rating,
		Count(*),
		RANK() Over(partition by type order by COUNT(*) DESC) as ranking
		FROM netflix
		Group by 1,2
) as t1
Where ranking = 1

--3. List all movies released in a specific year (e.g., 2020).

select * from netflix
Where type = 'Movie' AND release_year = 2020

--4. Find the top 5 countries with the most content on Netflix.

select 
	unnest(string_to_array(country, ',')) as new_country,
	Count(show_id) as total_content
from netflix
Group by 1
order by 2 DESC
Limit 5
--5. Identify the longest movie or TV show duration.

Select * from netflix
where
	type = 'Movie'
	AND
	duration = (select MAX(duration) From netflix)

--6. Find content added in the last 5 years.

select * from netflix
	where To_Date(date_added, 'Month DD, YYYY') >= current_date - interval '5 years'


--7. Find all the movies/TV shows by director 'rajiv Chilaka'.

select * from netflix
	where director ILike '%Rajiv Chilaka%'

--8. List all TV shows wiht more than 5 seasons.

select * from netflix
	Where type= 'TV Show' AND split_part(duration,' ', 1) :: numeric > 5 


--9. Count the number of content items in each genre.

select  
	unnest(string_to_array(listed_in, ',')) as sep_genre,
	count(show_id)
from netflix
group by 1


--10. Find the average release year for content produced in a specific country.

select 
	extract(YEAR from to_date(date_added,'Month DD, YYYY')) as year, 
	count(*),
	round(count(*) :: numeric/(select count(*) from netflix where country='India')*100,2) as avg_content_per_year
from netflix
where country = 'India'
Group by 1

--11. List all movies that are documentires.

select * from netflix
where listed_in ILIKE '%documentaries%'

--12. Fnd all content without a director.

select * from netflix
where director IS NULL

--13. Find how many movies actor 'Salman Khan' apperaed in last 10 years!

select * from netflix
where casts ILIKE '%Salman Khan%' AND release_year > extract(YEAR from current_date
)- 10

--14. Find the top 10 actors who have appeared in the highest number of movies produced in India

select 

unnest(string_to_array(casts, ',')) as actors,
count(*) as total_count
from netflix
where country ILIKE '%India%'
Group by 1
order by 2 desc
limit 10


--15. Categorize the content based on the presence of the keywords 'kill' and 'violence' in the description field. Label content containing these keywords as 'Bad' and all other content as 'Good'. Count how many items fall into each category.
with new_table
as
(
select 
	*,
	CASE
	WHEN 
		description ilike '%kill%'
		or 
		description ilike '%violance%' THEN 'Bad_Content'
		Else 'Good Content'
	End category
from netflix
)
Select
	category,
	count(*) as total_content
From
new_table
Group by 1
