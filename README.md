# Netflix-SQL-Analysis-Project
This repository contains a comprehensive set of SQL queries for analyzing Netflix content data. The project demonstrates data exploration, aggregation, string manipulation, window functions, and business-driven SQL problem solving.
Project Overview

Dataset: Netflix content information including shows, movies, directors, cast, release year, country, genre, ratings, duration, and descriptions.

Goal: Solve 15 business questions and perform advanced SQL analysis to generate actionable insights from the Netflix dataset.

SQL Skills Demonstrated:

Aggregations (COUNT, SUM, AVG, MAX, MIN)

String manipulation (UNNEST, STRING_TO_ARRAY, SPLIT_PART, ILIKE)

Conditional logic (CASE, WHEN)

Window functions (RANK, DENSE_RANK)

Date handling and filtering (TO_DATE, INTERVAL)

CTEs and query optimization

📝 Table Schema
CREATE TABLE Netflix
(
    show_id     VARCHAR(10),
    type        VARCHAR(15),
    title       VARCHAR(150),
    director    VARCHAR(250),
    casts       VARCHAR(1000),
    country     VARCHAR(150),
    date_added  VARCHAR(30),
    release_year INT,
    rating      VARCHAR(15),
    duration    VARCHAR(25),
    listed_in   VARCHAR(200),
    description VARCHAR(250)
);

🏷️ Business Questions Solved
Basic Queries

Count the number of Movies vs TV Shows.

Find the most common rating for movies and TV shows.

List all movies released in a specific year (e.g., 2020).

Find the top 5 countries with the most content.

Identify the longest movie.

Intermediate Queries

Find content added in the last 5 years.

List all movies/TV shows by director 'Rajiv Chilaka'.

List TV shows with more than 5 seasons.

Count content items in each genre.

Find top 5 years with the highest average content release in India.

List all movies that are documentaries.

Find all content without a director.

Advanced Queries

Count movies actor 'Salman Khan' appeared in the last 10 years.

Find top 10 actors with the highest number of movies produced in India.

Categorize content as 'Good' or 'Bad' based on keywords 'kill' or 'violence' in descriptions.

⚡ Example SQL Queries
-- Count Movies vs TV Shows
SELECT type, COUNT(*) FROM Netflix GROUP BY type;

-- Top 5 countries with most content
SELECT UNNEST(STRING_TO_ARRAY(country,',')) AS country_array, COUNT(*) AS total_content
FROM Netflix
GROUP BY country_array
ORDER BY total_content DESC
LIMIT 5;

-- Top 10 actors in movies produced in India
SELECT UNNEST(STRING_TO_ARRAY(casts,',')) AS actors, COUNT(*) AS total_number
FROM Netflix
WHERE country = 'India'
GROUP BY actors
ORDER BY total_number DESC
LIMIT 10;

-- Categorize content based on 'kill' or 'violence'
SELECT category, COUNT(*) AS total_count
FROM (
  SELECT CASE
    WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'BAD'
    ELSE 'GOOD'
  END AS category
  FROM Netflix
) AS t
GROUP BY category;
