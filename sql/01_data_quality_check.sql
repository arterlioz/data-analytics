-- Data Quality Assessment and Summary Statistics
-- Checking for invalid values, outliers, and inconsistencies

-- Check for missing values
SELECT 
    COUNT(*) - COUNT(age) as age_nulls,
    COUNT(*) - COUNT(gender) as gender_nulls,
    COUNT(*) - COUNT(burnout_score) as burnout_nulls,
FROM burnout_data;

/* result: no nulls! */


-- Check age range
SELECT 
    MIN(age) as min_age,
    MAX(age) as max_age
FROM burnout_data;

/* result: ages between 22 and 59 */


-- Check burnout range and variation
SELECT 
    MIN(burnout_level) as min_burnout,
    MAX(burnout_level) as max_burnout,
    ROUND(AVG(burnout_level)::numeric, 2) as avg_burnout,
    ROUND(STDDEV(burnout_level)::numeric, 2) as std_dev,
    COUNT(DISTINCT burnout_level) as unique_values
FROM burnout_data;

-- Result: min=1, max=10, avg=5.51, std_dev=2.57, unique_values=863
-- Interpretation: Full range with high individual variation. 
-- Continuous scale with 863 unique decimal values indicates granular measurement.


-- Distribution across burnout spectrum
SELECT 
    CASE 
        WHEN burnout_level < 2 THEN '1.0-1.9 (Very Low)'
        WHEN burnout_level < 3 THEN '2.0-2.9 (Low)'
        WHEN burnout_level < 4 THEN '3.0-3.9 (Low-Moderate)'
        WHEN burnout_level < 5 THEN '4.0-4.9 (Moderate)'
        WHEN burnout_level < 6 THEN '5.0-5.9 (Moderate-High)'
        WHEN burnout_level < 7 THEN '6.0-6.9 (High)'
        WHEN burnout_level < 8 THEN '7.0-7.9 (High)'
        WHEN burnout_level < 9 THEN '8.0-8.9 (Very High)'
        ELSE '9.0-10.0 (Extreme)'
    END as burnout_range,
    COUNT(*) as count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM burnout_data), 1) as percentage
FROM burnout_data
GROUP BY burnout_range
ORDER BY MIN(burnout_level);

-- Result: Nearly uniform distribution - each level represents 9-12% of population
-- Key Finding: Burnout is evenly distributed across spectrum, not concentrated at extremes or middle. This suggests burnout is highly individual and not strongly predicted by demographic categories alone.


-- Verify full range exists within demographic groups
SELECT 
    country,
    MIN(burnout_level) as min,
    MAX(burnout_level) as max,
    ROUND(STDDEV(burnout_level)::numeric, 2) as std_dev
FROM burnout_data
GROUP BY country
ORDER BY country;

-- Result: Every country shows full 1-10 range with std_dev ~2.5
-- Confirms demographic groups overlap completely in burnout distribution


-- ============================================
-- BURNOUT RISK CLASSIFICATION
-- ============================================

-- Investigate burnout_risk threshold

SELECT 
    FLOOR(burnout_level) as burnout_level,
    burnout_risk,
    COUNT(*) as count,
FROM burnout_data
GROUP BY 1, 2
ORDER BY 1, 2;

-- Caculate Burnout Risk Percentage

SELECT 
    burnout_risk,
    COUNT(*) as count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM burnout_data), 1) as pct
FROM burnout_data
GROUP BY 1;

-- Result: burnout_risk is binary classification based on threshold
-- burnout_risk = 0: burnout_level < 7 (Low Risk) - 2,216 employees (73.9%)
-- burnout_risk = 1: burnout_level >= 7 (High Risk) - 784 employees (26.1%)
-- Note: 4 employees at level 7.0-7.99 classified as risk=0 (boundary cases)



-- Overall dataset summary

-- Basic statistics on burnout levels, age, and work hours

SELECT 
    COUNT(*) as total_respondents,
    ROUND(AVG(burnout_level)::numeric, 2) as avg_burnout,
    MIN(burnout_level) as min_burnout,
    MAX(burnout_level) as max_burnout,
    ROUND(AVG(age)::numeric,2) as avg_age,
    ROUND(AVG(work_hours_per_week)::numeric,2) as avg_work_hours
FROM burnout_data;

-- Number of respondents by country

SELECT 
    count(*) as total_respondents,
    country
FROM burnout_data
GROUP BY country
ORDER BY 1 DESC;

-- Number of respondents by gender

SELECT
    gender,
    count(*)
FROM burnout_data
GROUP BY gender
ORDER BY 2 DESC;

-- Number of respondents by salary range

SELECT 
    salary_range,
    count(*)
FROM burnout_data
GROUP BY salary_range
ORDER BY 2 DESC;





