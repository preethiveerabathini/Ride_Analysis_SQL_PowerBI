

USE rides_analysis;

-- ==========================================================
-- PHASE 1 : DATA EXPLORATION
-- ==========================================================

-- Q1. Total number of driver records
SELECT COUNT(*) AS total_records
FROM rideit_drivers; 	 

-- Q2. Total unique drivers
SELECT COUNT(DISTINCT id_driver) AS total_drivers
FROM rideit_drivers;

-- Q3. View table structure
DESC rideit_drivers;

-- Q4. Check NULL values
SELECT *
FROM rideit_drivers
WHERE id_driver IS NULL
   OR driver_rating IS NULL
   OR service_type IS NULL
   OR country_code IS NULL;

-- Q5. Find duplicate drivers
SELECT
id_driver,
COUNT(*) AS duplicate_count
FROM rideit_drivers
GROUP BY id_driver
HAVING COUNT(*) > 1;

-- Q6. Count duplicate driver IDs
SELECT COUNT(*) AS duplicate_driver_ids
FROM
(
SELECT id_driver
FROM rideit_drivers
GROUP BY id_driver
HAVING COUNT(*) > 1
) AS duplicates;

-- Q7. Unique service types
SELECT DISTINCT service_type
FROM rideit_drivers;

-- Q8. Unique countries
SELECT DISTINCT country_code
FROM rideit_drivers;

-- Q9. Unique marketing preferences
SELECT DISTINCT receive_marketing
FROM rideit_drivers;

-- ==========================================================
-- PHASE 2 : DATA CLEANING
-- ==========================================================

-- Q10. Check duplicate records
SELECT
id_driver,
COUNT(*) AS duplicates
FROM rideit_drivers
GROUP BY id_driver
HAVING COUNT(*) > 1;

-- Q11. Check missing values
SELECT *
FROM rideit_drivers
WHERE id_driver IS NULL
OR driver_rating IS NULL
OR service_type IS NULL
OR country_code IS NULL;

-- Q12. Check invalid ratings
SELECT *
FROM rideit_drivers
WHERE driver_rating < 0
OR driver_rating > 5;

-- ==========================================================
-- PHASE 3 : EDA (Exploratory Data Analysis)
-- ==========================================================

-- Q13. Drivers by service type
SELECT
service_type,
COUNT(DISTINCT id_driver) AS total_drivers
FROM rideit_drivers
GROUP BY service_type
ORDER BY total_drivers DESC;

-- Q14. Overall average rating
SELECT
ROUND(AVG(driver_rating),2) AS average_rating
FROM rideit_drivers;

-- Q15. Average rating by service type
SELECT
service_type,
ROUND(AVG(driver_rating),2) AS average_rating
FROM rideit_drivers
GROUP BY service_type
ORDER BY average_rating DESC;

-- Q16. Gold vs Regular drivers
SELECT
CASE
WHEN gold_level_count > 0 THEN 'Gold Driver'
ELSE 'Regular Driver'
END AS driver_category,
COUNT(DISTINCT id_driver) AS total_drivers
FROM rideit_drivers
GROUP BY driver_category;

-- Q17. Drivers by country
SELECT
country_code,
COUNT(DISTINCT id_driver) AS total_drivers
FROM rideit_drivers
GROUP BY country_code
ORDER BY total_drivers DESC;

-- Q18. Rating distribution
SELECT
driver_rating,
COUNT(*) AS number_of_drivers
FROM rideit_drivers
GROUP BY driver_rating
ORDER BY driver_rating DESC;

-- Q19. Driver registrations by year
SELECT
YEAR(STR_TO_DATE(date_registration,'%Y-%m-%d')) AS registration_year,
COUNT(DISTINCT id_driver) AS new_drivers
FROM rideit_drivers
GROUP BY registration_year
ORDER BY registration_year;

-- Q20. Top 5 service types
SELECT
service_type,
COUNT(DISTINCT id_driver) AS total_drivers
FROM rideit_drivers
GROUP BY service_type
ORDER BY total_drivers DESC
LIMIT 5;

-- Q21. Top 10 highest-rated drivers
SELECT
id_driver,
driver_rating
FROM rideit_drivers
ORDER BY driver_rating DESC
LIMIT 10;

-- Q22. Average rating by country
SELECT
country_code,
ROUND(AVG(driver_rating),2) AS average_rating
FROM rideit_drivers
GROUP BY country_code
ORDER BY average_rating DESC;

-- Q23. Marketing participation
SELECT
receive_marketing,
COUNT(DISTINCT id_driver) AS total_drivers
FROM rideit_drivers
GROUP BY receive_marketing;

-- Q24. Gold drivers by country
SELECT
country_code,
COUNT(DISTINCT id_driver) AS gold_drivers
FROM rideit_drivers
WHERE gold_level_count > 0
GROUP BY country_code
ORDER BY gold_drivers DESC;

-- Q25. Service type performance
SELECT
service_type,
COUNT(*) AS drivers,
ROUND(AVG(driver_rating),2) AS average_rating
FROM rideit_drivers
GROUP BY service_type
ORDER BY average_rating DESC;

-- Q26. Driver rating categories
SELECT
CASE
WHEN driver_rating >= 4.5 THEN 'Excellent'
WHEN driver_rating >= 4.0 THEN 'Good'
WHEN driver_rating >= 3.0 THEN 'Average'
ELSE 'Needs Improvement'
END AS rating_category,
COUNT(*) AS drivers
FROM rideit_drivers
GROUP BY rating_category;

-- ==========================================================
-- PHASE 4 : ADVANCED SQL
-- ==========================================================

-- Q27. CASE WHEN
SELECT
id_driver,
driver_rating,
CASE
WHEN driver_rating >= 4.5 THEN 'Excellent'
WHEN driver_rating >= 4.0 THEN 'Good'
WHEN driver_rating >= 3.0 THEN 'Average'
ELSE 'Needs Improvement'
END AS rating_category
FROM rideit_drivers;

-- Q28. Above-average rated drivers (Subquery)
SELECT
id_driver,
driver_rating
FROM rideit_drivers
WHERE driver_rating >
(
SELECT AVG(driver_rating)
FROM rideit_drivers
);

-- Q29. CTE
WITH service_rating AS
(
SELECT
service_type,
ROUND(AVG(driver_rating),2) AS average_rating
FROM rideit_drivers
GROUP BY service_type
)
SELECT *
FROM service_rating
WHERE average_rating >= 4;

-- Q30. ROW_NUMBER()
SELECT
id_driver,
driver_rating,
ROW_NUMBER() OVER(
ORDER BY driver_rating DESC
) AS row_num
FROM rideit_drivers;

-- Q31. RANK()
SELECT
id_driver,
driver_rating,
RANK() OVER(
ORDER BY driver_rating DESC
) AS ranking
FROM rideit_drivers;

-- Q32. DENSE_RANK()
SELECT
id_driver,
driver_rating,
DENSE_RANK() OVER(
ORDER BY driver_rating DESC
) AS dense_ranking
FROM rideit_drivers;

-- Q33. Top 5 drivers in each service type
WITH ranked_drivers AS
(
SELECT
id_driver,
service_type,
driver_rating,
RANK() OVER(
PARTITION BY service_type
ORDER BY driver_rating DESC
) AS rank_no
FROM rideit_drivers
)
SELECT *
FROM ranked_drivers
WHERE rank_no <= 5;

-- Q34. Running total of driver registrations
SELECT
date_registration,
COUNT(*) AS daily_registrations,
SUM(COUNT(*)) OVER(
ORDER BY date_registration
) AS running_total
FROM rideit_drivers
GROUP BY date_registration;

-- ==========================================================
-- PHASE 5 : BUSINESS INSIGHTS
-- ==========================================================

-- Q35. Overall driver network
SELECT
COUNT(DISTINCT id_driver) AS total_drivers
FROM rideit_drivers;

-- Q36. Highest driver availability by service
SELECT
service_type,
COUNT(DISTINCT id_driver) AS total_drivers
FROM rideit_drivers
GROUP BY service_type
ORDER BY total_drivers DESC;

-- Q37. Largest driver base by country
SELECT
country_code,
COUNT(DISTINCT id_driver) AS total_drivers
FROM rideit_drivers
GROUP BY country_code
ORDER BY total_drivers DESC;

-- Q38. Driver quality distribution
SELECT
CASE
WHEN driver_rating >= 4.5 THEN 'Excellent'
WHEN driver_rating >= 4.0 THEN 'Good'
WHEN driver_rating >= 3.0 THEN 'Average'
ELSE 'Needs Improvement'
END AS rating_category,
COUNT(*) AS drivers
FROM rideit_drivers
GROUP BY rating_category;

-- Q39. Gold program adoption
SELECT
CASE
WHEN gold_level_count > 0 THEN 'Gold'
ELSE 'Regular'
END AS driver_type,
COUNT(DISTINCT id_driver) AS drivers
FROM rideit_drivers
GROUP BY driver_type;
