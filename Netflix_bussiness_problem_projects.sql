---- NETFLIX PROJECT ------

CREATE TABLE Netflix
(
	show_id	VARCHAR(10),
	type	VARCHAR(15),
	title	VARCHAR(150),
	director VARCHAR(250),	
	casts	VARCHAR(1000),
	country	VARCHAR(150),
	date_added	VARCHAR(30),
	release_year INT,	
	rating	    VARCHAR(15),
	duration	VARCHAR(25),
	listed_in	VARCHAR(200),
	description VARCHAR(250)

);
SELECT * FROM Netflix;
SELECT COUNT(*) AS total_rows FROM Netflix;

-- 15 Business Problems & Solutions
/*
1. Count the number of Movies vs TV Shows
2. Find the most common rating for movies and TV shows
3. List all movies released in a specific year (e.g., 2020)
4. Find the top 5 countries with the most content on Netflix
5. Identify the longest movie
6. Find content added in the last 5 years
7. Find all the movies/TV shows by director 'Rajiv Chilaka'!
8. List all TV shows with more than 5 seasons
9. Count the number of content items in each genre
10.Find each year and the average numbers of content release in India on netflix. 
return top 5 year with highest avg content release!
11. List all movies that are documentaries
12. Find all content without a director
13. Find how many movies actor 'Salman Khan' appeared in last 10 years!
14. Find the top 10 actors who have appeared in the highest number of movies produced in India.
15.
Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
the description field. Label content containing these keywords as 'Bad' and all other 
content as 'Good'. Count how many items fall into each category.
*/

--1. Count the number of Movies vs TV Shows
SELECT type,COUNT(*) FROM Netflix GROUP BY type;
---2. Find the most common rating for movies and TV shows
WITH total_rating AS(
SELECT type , rating , COUNT(*) AS Total
FROM Netflix GROUP BY 1,2
),
Ranked as(
SELECT type, rating ,Total,
RANK()OVER(PARTITION BY type ORDER BY Total DESC) AS total_rank
FROM total_rating
)
SELECT * FROM ranked WHERE total_rank =1;
----3. List all movies released in a specific year (e.g., 2020)
SELECT * FROM Netflix WHERE type = 'Movie' AND release_year = 2020;

----4. Find the top 5 countries with the most content on Netflix
SELECT * FROM
(
	SELECT 
	   UNNEST (STRING_TO_ARRAY(country,','))AS COUNTRY_ARRAY,
	   COUNT(*) AS Total_content
	   FROM Netflix
	   GROUP BY 1
) AS t1
WHERE COUNTRY_ARRAY IS NOT NULL
ORDER BY  total_content DESC
LIMIT 5;

---5. Identify the longest movie
SELECT * FROM Netflix 
WHERE duration =(select max(duration) FROM Netflix) AND type = 'Movie';

----- OR ANOTHER METHODS
SELECT 
    *
FROM netflix
WHERE type = 'Movie'
ORDER BY SPLIT_PART(duration, ' ', 1)::INT DESC;
-----6. Find content added in the last 5 years
SELECT * FROM Netflix 
WHERE TO_DATE(date_added,'Month DD ,YYYY')>=(CURRENT_DATE - INTERVAL '5 YEARS');


----7. Find all the movies/TV shows by director 'Rajiv Chilaka'!
SELECT * FROM Netflix
WHERE director  ILIKE '%Rajiv Chilaka%';
--- 8. List all TV shows with more than 5 seasons
SELECT * FROM Netflix 
WHERE type = 'TV Show' AND SPLIT_PART(duration , ' ',1):: INT >5;
-----9. Count the number of content items in each genre
SELECT 
UNNEST (STRING_TO_ARRAY(listed_in,' ,')) AS genre,
COUNT(*) AS total_content
FROM Netflix
GROUP BY 1
ORDER BY 2 DESC;
--10.Find each year and the average numbers of content release in India on netflix. 
--return top 5 year with highest avg content release!.

SELECT country,release_year, COUNT(show_id) AS total_release,
ROUND(
	COUNT(show_id):: numeric/(SELECT COUNT(show_id) FROM Netflix WHERE
	country = 'India'):: NUMERIC *100,2 )As average from Netflix
WHERE country = 'India'
GROUP BY release_year, country
ORDER BY average DESC
limit 5;
------ same method is below
SELECT 
    country,
    release_year,
    COUNT(show_id) AS total_release,
    ROUND(
        COUNT(show_id)::numeric /
        (SELECT COUNT(show_id) FROM netflix WHERE country = 'India')::numeric * 100, 2
    ) AS avg_release
FROM netflix
WHERE country = 'India'
GROUP BY country, release_year
ORDER BY avg_release DESC
LIMIT 5;

--11. List all movies that are documentaries
SELECT * FROM Netflix WHERE listed_in ILIKE '%documentaries%' AND type = 'Movie';
---12. Find all content without a director
 SELECT * FROM Netflix WHERE director IS  NULL;
 --13. Find how many movies actor 'Salman Khan' appeared in last 10 years!
 SELECT * FROM Netflix WHERE casts ILIKE '%Salman Khan%' AND type = 'Movie'
 AND release_year>  EXTRACT(YEAR FROM CURRENT_DATE)-10;

--- 14. Find the top 10 actors who have appeared in the highest number of movies produced in India.
SELECT UNNEST(STRING_TO_ARRAY(casts ,',')) AS actors,
COUNT(*) AS TOTAL_NUMBER
FROM Netflix
WHERE country = 'India'
GROUP BY actors
ORDER BY COUNT(*) DESC
LIMIT 10;
/*
15.
Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
the description field. Label content containing these keywords as 'Bad' and all other 
content as 'Good'. Count how many items fall into each category.
*/
SELECT category , COUNT(*) AS TOTAL_COUNT
FROM (

	SELECT 
	CASE
	  WHEN description ILIKE '%kill%' OR description ILIKE'%violence%' THEN 'BAD'
	ELSE 'GOOD'
	END AS Category
	FROM Netflix
	)
GROUP BY category;