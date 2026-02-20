
-- Avgerage Burnout Level by Country

SELECT
    country,
    round(avg(burnout_level)::numeric,2) as average_burnout
FROM burnout_data
GROUP BY country;

-- Rank Countries by Average Burnout Level

SELECT
    country,
    rank() OVER (ORDER BY avg(burnout_level) DESC) as burnout_rank
FROM burnout_data
GROUP BY country;

-- Burnout level Variance by Country


SELECT 
    country,
    MIN(burnout_level) as min_burnout,
    MAX(burnout_level) as max_burnout,
    ROUND(AVG(burnout_level)::numeric, 2) as avg_burnout,
    ROUND(STDDEV(burnout_level)::numeric, 2) as std_dev
FROM burnout_data
GROUP BY country
ORDER BY avg_burnout DESC;


-- Developed vs Emerging Markets Burnout Comparison

SELECT
    CASE WHEN country IN ('USA', 'Canada', 'UK', 'Germany', 'Australia') THEN 'developed countries'
         WHEN country IN ('India', 'Brazil') THEN 'emerging countries'
         END as country_type,
    ROUND(AVG(burnout_level)::numeric, 2) as avg_burnout,
    Round(AVG(work_hours_per_week)::numeric, 2) as avg_work_hours
FROM burnout_data
GROUP BY 1;
