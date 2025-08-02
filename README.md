# Netflix Movies and TV Shows Data Analysis Using SQL

![Netflix_Logo](https://github.com/CarmenVartanian/netflix_sql_project/blob/main/BrandAssets_Logos_01-Wordmark%20(1).png?raw=true)

## Overview

This project presents a thorough exploration of Netflix's catalog of movies and TV shows through structured SQL analysis. Its core objective is to uncover meaningful insights and provide data-driven answers to key business questions by examining various aspects of the dataset.

## Objective

- Analyze the distribution of content types (movies vs TV shows).
- Identify the most common ratings for movies and TV shows.
- List and analyze content based on release years, countries, and durations.
- Explore and categorize content based on specific criteria and keywords.

## Dataset
The data for this project is retrieved from the Kaggle dataset:
https://www.kaggle.com/datasets/cdr0101/netflix-dataset<img width="468" height="29" alt="image" src="https://github.com/user-attachments/assets/723bc952-32b1-488a-b2f4-8b6f16194193" />


## Schema
```sql
DROP TABLE IF EXIST netflix;
CREATE TABLE netflix
(
  show_id      VARCHAR(5),
    type         VARCHAR(10),
    title        VARCHAR(250),
    director     VARCHAR(550),
    casts        VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(550)
);
```
## Business Problems and Solutions

### 1. Count the number of Movies vs TV Shows.
```sq;
Select type, 
	Count(*) as total_countent
From netflix
Group by type
```

### 2. Find the most common rating for movies and TV shows.
```sql
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
```

## 3. List all movies released in a specific year (e.g., 2020).
```sql
select * from netflix
Where type = 'Movie' AND release_year = 2020
```

### 4. Find the top 5 countries with the most content on Netflix.
```sql
select 
	unnest(string_to_array(country, ',')) as new_country,
	Count(show_id) as total_content
from netflix
Group by 1
order by 2 DESC
Limit 5
```

### 5. Identify the longest movie or TV show duration.
```sql
Select * from netflix
where
	type = 'Movie'
	AND
	duration = (select MAX(duration) From netflix)
```
### 6. Find content added in the last 5 years.
```sql
select * from netflix
	where To_Date(date_added, 'Month DD, YYYY') >= current_date - interval '5 years'
```

### 7. Find all the movies/TV shows by director 'rajiv Chilaka'.
```sql
select * from netflix
	where director ILike '%Rajiv Chilaka%'
```
### 8. List all TV shows wiht more than 5 seasons.
```sql
select * from netflix
	Where type= 'TV Show' AND split_part(duration,' ', 1) :: numeric > 5 
```

### 9. Count the number of content items in each genre.
```sql
select  
	unnest(string_to_array(listed_in, ',')) as sep_genre,
	count(show_id)
from netflix
group by 1
```

### 10. Find the average release year for content produced in a specific country.
```sql
select 
	extract(YEAR from to_date(date_added,'Month DD, YYYY')) as year, 
	count(*),
	round(count(*) :: numeric/(select count(*) from netflix where country='India')*100,2) as avg_content_per_year
from netflix
where country = 'India'
Group by 1
```
### 11. List all movies that are documentires.
```sql
select * from netflix
where listed_in ILIKE '%documentaries%'
```
### 12. Fnd all content without a director.
```sql
select * from netflix
where director IS NULL
```
### 13. Find how many movies actor 'Salman Khan' apperaed in last 10 years!
```sql
select * from netflix
where casts ILIKE '%Salman Khan%' AND release_year > extract(YEAR from current_date
)- 10
```
### 14. Find the top 10 actors who have appeared in the highest number of movies produced in India
```sql
select 

unnest(string_to_array(casts, ',')) as actors,
count(*) as total_count
from netflix
where country ILIKE '%India%'
Group by 1
order by 2 desc
limit 10
```

### 15. Categorize the content based on the presence of the keywords 'kill' and 'violence' in the description field. Label content containing these keywords as 'Bad' and all other content as 'Good'. Count how many items fall into each category.
```sql
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
```
## Conclusion
- **Content Distribution:** The dataset contains a diverse range of movies and TV shows with varying ratings and genres.
- **Common Ratings:** Insights into the most common ratings provide an understanding of the content's target audience.
- **Geographical Insights:** The top countries and the average content releases by India highlight regional content distribution.
- **Content Categorization:** Categorizing content based on specific keywords helps in understanding the nature of content available on Netflix.

This analysis provides a comprehensive view of Netflix's content and can help inform content strategy and decision-making.
