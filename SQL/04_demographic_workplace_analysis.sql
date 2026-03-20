
/*
PART 1: DEMOGRAPHIC ANALYSIS
*/

-- Average Burnout Level by Age Group

SELECT 
    CASE
        WHEN age BETWEEN 22 AND 30 THEN '22-30'
        WHEN age BETWEEN 31 AND 40 THEN '31-40'
        WHEN age BETWEEN 41 AND 50 THEN '41-50'
        WHEN age BETWEEN 51 AND 59 THEN '51-59'
    END as age_group,
    ROUND(AVG(burnout_level)::numeric, 2) as avg_burnout
FROM burnout_data
GROUP BY 1
ORDER BY 1 ASC 

-- Average Burnout Level by Gender

SELECT gender,
    ROUND(AVG(burnout_level)::numeric, 2) as avg_burnout
FROM burnout_data
GROUP BY 1;

-- Average Burnout Level by Education Level

SELECT 
    gender,
    ROUND(AVG(burnout_level)::numeric, 2) as avg_burnout
FROM burnout_data
GROUP BY 1;

-- Remote Work Percentage by Country 

SELECT 
    country,
    ROUND(AVG(burnout_level)::numeric, 2) as avg_burnout,
    ROUND(AVG(stress_level)::numeric, 2) as avg_stress,
    ROUND(AVG(work_hours_per_week)::numeric, 1) as avg_hours,
    ROUND(COUNT(case when remote_work = 'Yes' THEN 1 ELSE NULL END) * 100.0 / COUNT(*),2) as pct_remote
FROM burnout_data
GROUP BY country
ORDER BY avg_burnout DESC;

-- Does the gender gap vary by age group?

SELECT CASE
        WHEN age < 30 THEN 'Under 30'
        WHEN age BETWEEN 30 AND 45 THEN '30-45'
        ELSE '45+'
    END as age_bracket,
    gender,
    COUNT(*) as count,
    ROUND(AVG(burnout_level)::numeric, 2) as avg_burnout,
    ROUND(STDDEV(burnout_level)::numeric, 2) as std_dev
FROM burnout_data
GROUP BY 1,2
ORDER BY 1,2;

-- How does remote work affect gender differences in burnout?

SELECT gender,
    remote_work,
    COUNT(*) as employee_count,
    ROUND(AVG(burnout_level)::numeric, 2) as avg_burnout,
    ROUND(STDDEV(burnout_level)::numeric, 2) as std_dev,
    ROUND(MIN(burnout_level)::numeric, 2) as min_burnout,
    ROUND(MAX(burnout_level)::numeric, 2) as max_burnout,
    ROUND(
        MAX(burnout_level)::numeric - MIN(burnout_level)::numeric,
        2
    ) as burnout_range
FROM burnout_data
WHERE gender IN ('Male', 'Female', 'Non-binary') -- Focus on main groups
GROUP BY gender,
    remote_work
ORDER BY std_dev DESC;

-- By Department

SELECT Department,
    COUNT(*) as employee_count,
    ROUND(AVG(burnout_level)::numeric, 2) as avg_burnout,
    ROUND(STDDEV(burnout_level)::numeric, 2) as std_dev,
    ROUND(MIN(burnout_level)::numeric, 2) as min_burnout,
    ROUND(MAX(burnout_level)::numeric, 2) as max_burnout,
    ROUND(
        MAX(burnout_level)::numeric - MIN(burnout_level)::numeric,
        2
    ) as burnout_range
FROM burnout_data
GROUP BY Department
ORDER BY std_dev DESC;

-- By Country

SELECT country,
    COUNT(*) as employee_count,
    ROUND(AVG(burnout_level)::numeric, 2) as avg_burnout,
    ROUND(STDDEV(burnout_level)::numeric, 2) as std_dev,
    ROUND(MIN(burnout_level)::numeric, 2) as min_burnout,
    ROUND(MAX(burnout_level)::numeric, 2) as max_burnout,
    ROUND(
        MAX(burnout_level)::numeric - MIN(burnout_level)::numeric,
        2
    ) as burnout_range
FROM burnout_data
GROUP BY country
ORDER BY std_dev DESC;

-- By Age Group

SELECT 
    CASE
        WHEN age < 30 THEN 'Under 30'
        WHEN age BETWEEN 30 AND 39 THEN '30-39'
        WHEN age BETWEEN 40 AND 49 THEN '40-49'
        ELSE '50+'
    END as age_group,
    COUNT(*) as employee_count,
    ROUND(AVG(burnout_level)::numeric, 2) as avg_burnout,
    ROUND(STDDEV(burnout_level)::numeric, 2) as std_dev,
    ROUND(MIN(burnout_level)::numeric, 2) as min_burnout,
    ROUND(MAX(burnout_level)::numeric, 2) as max_burnout,
    ROUND(
        MAX(burnout_level)::numeric - MIN(burnout_level)::numeric,
        2
    ) as burnout_range
FROM burnout_data
GROUP BY 1
ORDER BY std_dev DESC;

-- By Work Hours

SELECT 
    CASE
        WHEN work_hours_per_week < 40 THEN '<40 hours'
        WHEN work_hours_per_week BETWEEN 40 AND 50 THEN '40-50'
        ELSE '50+'
    END as work_hours_group,
    COUNT(*) as employee_count,
    ROUND(AVG(burnout_level)::numeric, 2) as avg_burnout,
    ROUND(STDDEV(burnout_level)::numeric, 2) as std_dev,
    MIN(work_hours_per_week) as min_hours,
    MAX(work_hours_per_week) as max_hours
FROM burnout_data
GROUP BY 1 


/*   
PART 2: WORKPLACE FACTORS ANALYSIS
*/

-- Burnout level by team size
    
SELECT 
    CASE
        WHEN team_size < 10 THEN 'Small (<10)'
        WHEN team_size BETWEEN 10 AND 20 THEN 'Medium (10-20)'
        ELSE 'Large (20+)'
    END as team_size,
    COUNT(*) as employee_count,
    ROUND(AVG(burnout_level)::numeric, 2) as avg_burnout
FROM burnout_data
GROUP BY 1
ORDER BY avg_burnout DESC;

-- Manager Support Impact on Burnout Level

SELECT CASE
        WHEN manager_support_score BETWEEN 1 AND 3 THEN 'Low Support (1-3)'
        WHEN manager_support_score BETWEEN 4 AND 7 THEN 'Medium Support (4-7)'
        ELSE 'High Support (8-10)'
    END as support_level,
    COUNT(*) as employee_count,
    ROUND(AVG(burnout_level)::numeric, 2) as avg_burnout
FROM burnout_data
GROUP BY 1
ORDER BY avg_burnout DESC;

-- Mental Health Benefits Effect on Burnout Level

SELECT has_mental_health_support,
    has_therapy_access,
    COUNT(*) as count,
    ROUND(AVG(burnout_level)::numeric, 2) as avg_burnout
FROM burnout_data
GROUP BY 1,
    2
ORDER BY avg_burnout DESC;

-- Mental Health Days Off Effect

SELECT CASE
        WHEN mental_health_days_off < 3 THEN 'Minimal days (0-2)'
        WHEN mental_health_days_off <= 6 THEN 'Moderate days (3-6)'
        ELSE 'Frequent days (7-10)'
    END as mh_days_category,
    COUNT(*) as count,
    ROUND(AVG(burnout_level)::numeric, 2) as avg_burnout,
    ROUND(AVG(mental_health_days_off)::numeric, 1) as avg_days
FROM burnout_data
GROUP BY mh_days_category
ORDER BY avg_burnout;

-- Mental health days seem to have minimal effect on burnout level.

-- Work-Life Balance Score Impact on Burnout Level

SELECT CASE
        WHEN work_life_balance_score BETWEEN 1 AND 3 THEN 'Low Balance (1-3)'
        WHEN work_life_balance_score BETWEEN 4 AND 7 THEN 'Medium Balance (4-7)'
        ELSE 'High Balance (8-10)'
    END as balance_level,
    COUNT(*) as employee_count,
    ROUND(AVG(burnout_level)::numeric, 2) as avg_burnout
FROM burnout_data
GROUP BY 1
ORDER BY avg_burnout DESC;

-- Pretty straightforward, low work-life balance scores have the highest burnout levels on average, while high scores have the lowest.

-- Sleep Hours Impact on Burnout Level

SELECT CASE
        WHEN sleep_hours < 6 THEN 'under 6 hours'
        WHEN sleep_hours BETWEEN 6 and 8 THEN '6-8 hours'
        ELSE 'over 8 hours'
    END as sleep_hours,
    COUNT(*) as employee_count,
    Round(avg(burnout_level)::numeric, 2) as avg_burnout
FROM burnout_data
GROUP BY 1
ORDER BY avg_burnout DESC;

-- It doesn't have direct correlation 

-- Job Satisfaction Impact on Burnout Level

SELECT CASE
        WHEN job_satisfaction BETWEEN 1 AND 3 THEN 'Low Satisfaction (1-3)'
        WHEN job_satisfaction BETWEEN 4 AND 7 THEN 'Medium Satisfaction (4-7)'
        ELSE 'High Satisfaction (8-10)'
    END as satisfaction_level,
    COUNT(*) as employee_count,
    ROUND(AVG(burnout_level)::numeric, 2) as avg_burnout
FROM burnout_data
GROUP BY 1
ORDER BY avg_burnout DESC;

-- Physical Activity Hours Impact on Burnout Level

SELECT CASE
        WHEN physical_activity_hrs < 2 THEN 'Low Activity (<2 hrs)'
        WHEN physical_activity_hrs BETWEEN 2 AND 4 THEN 'Moderate Activity (2-4 hrs)'
        ELSE 'High Activity (4+ hrs)'
    END as activity_level,
    COUNT(*) as employee_count,
    ROUND(AVG(burnout_level)::numeric, 2) as avg_burnout
FROM burnout_data
GROUP BY 1
ORDER BY avg_burnout DESC;

-- Low activity group has the highest burnout average, moderate and high has the same.
-- High hours (50+) × Remote work (does flexibility offset long hours?)

SELECT CASE
        WHEN work_hours_per_week >= 50 THEN '50+ hours'
        ELSE '<50 hours'
    END as work_hours_group,
    CASE
        WHEN remote_work = 'Yes' THEN 'Remote'
        WHEN remote_work = 'No' THEN 'Office'
        ELSE 'Hybrid'
    END as work_mode,
    COUNT(*) as employee_count,
    ROUND(AVG(burnout_level)::numeric, 2) as avg_burnout
FROM burnout_data
GROUP BY 1,
    2
ORDER BY avg_burnout DESC;


-- Remote work × Mental health benefits
SELECT has_mental_health_support,
        remote_work,
        COUNT(*) as count,
        ROUND(AVG(burnout_level)::numeric, 2) as avg_burnout
FROM burnout_data
GROUP BY 1,
    2
ORDER BY avg_burnout DESC;

-- High hours × Manager support (does good management offset long hours?)

SELECT CASE
        WHEN work_hours_per_week >= 50 THEN '50+ hours'
        ELSE '<50 hours'
    END as work_hours_group,
    CASE
        WHEN manager_support_score >7 THEN 'High Support'
        ELSE 'Low Support'
    END as support_level,
    COUNT(*) as employee_count,
    ROUND(AVG(burnout_level)::numeric, 2) as avg_burnout
FROM burnout_data
GROUP BY 1,2
ORDER BY avg_burnout DESC;

-- Employees with less manager support are more likely to burnout, regardless of work hours

--Department × Manager support (which depts have management issues?)

SELECT 
    Department,
    CASE
        WHEN manager_support_score >7 THEN 'High Support'
        ELSE 'Low Support'
    END as support_level,
    count(*) as employee_count,
    ROUND(AVG(burnout_level)::numeric, 2) as avg_burnout
FROM burnout_data
GROUP BY 1,2
ORDER BY avg_burnout DESC

--Job role × Work hours (which roles suffer most from overtime?)

SELECT 
    job_role,
    CASE WHEN work_hours_per_week >= 40 THEN '40+ hours'
         ELSE '<40 hours'
    END as work_hours,
    count(*) as employee_count,
    ROUND(AVG(burnout_level)::numeric, 2) as avg_burnout
FROM burnout_data
GROUP BY 1,2
ORDER BY avg_burnout DESC


-- Compare top vs bottom 10% on ALL available factors

WITH burnout_percentiles AS (
    SELECT 
        PERCENTILE_CONT(0.10) WITHIN GROUP (ORDER BY burnout_level) as p10,
        PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY burnout_level) as p90
    FROM burnout_data
)
SELECT 
    CASE WHEN burnout_level <= (SELECT p10 FROM burnout_percentiles) THEN 'Bottom 10% (Thriving)'
         WHEN burnout_level >= (SELECT p90 FROM burnout_percentiles) THEN 'Top 10% (Struggling)'
    END AS group_name,
    count(*) as count,

    -- Demographics
    ROUND(AVG(age)::numeric, 1) as avg_age,
    ROUND(AVG(years_at_company)::numeric, 1) as avg_tenure,
    
    -- Work factors
    ROUND(AVG(work_hours_per_week)::numeric, 1) as avg_hours,
    ROUND(AVG(team_size)::numeric, 0) as avg_team_size,
    COUNT(*) FILTER (WHERE remote_work = 'Yes') * 100.0 / COUNT(*) as pct_remote,
    
    -- Support & Benefits
    ROUND(AVG(manager_support_score)::numeric, 1) as avg_manager_support,
    COUNT(*) FILTER (WHERE has_mental_health_support = 'Yes') * 100.0 / COUNT(*) as pct_has_mh_support,
    COUNT(*) FILTER (WHERE has_therapy_access = 'Yes') * 100.0 / COUNT(*) as pct_has_therapy,
    
    -- Wellbeing
    ROUND(AVG(sleep_hours)::numeric, 1) as avg_sleep,
    ROUND(AVG(physical_activity_hrs)::numeric, 1) as avg_exercise,
    ROUND(AVG(work_life_balance_score)::numeric, 1) as avg_wlb_score,
    
    -- Job factors
    ROUND(AVG(job_satisfaction)::numeric, 1) as avg_satisfaction,
    ROUND(AVG(career_growth_score)::numeric, 1) as avg_growth_score,
    ROUND(AVG(stress_level)::numeric, 1) as avg_stress

FROM burnout_data
WHERE burnout_level <= (SELECT p10 FROM burnout_percentiles)
   OR burnout_level >= (SELECT p90 FROM burnout_percentiles)
GROUP BY group_name;


-- What characterizes low-burnout employees?

SELECT 
    'Protective Factor Profile' as analysis,
    
    -- Sleep adequacy
    COUNT(*) FILTER (WHERE sleep_hours >= 7) * 100.0 / COUNT(*) as pct_adequate_sleep,
    -- Exercise
    COUNT(*) FILTER (WHERE physical_activity_hrs >= 3) * 100.0 / COUNT(*) as pct_regular_exercise,
    -- Manager support
    COUNT(*) FILTER (WHERE manager_support_score >= 7) * 100.0 / COUNT(*) as pct_good_manager,
    -- Work-life balance
    COUNT(*) FILTER (WHERE work_life_balance_score >= 7) * 100.0 / COUNT(*) as pct_good_wlb,
    -- Reasonable hours
    COUNT(*) FILTER (WHERE work_hours_per_week < 50) * 100.0 / COUNT(*) as pct_reasonable_hours,
    -- Mental health support
    COUNT(*) FILTER (WHERE has_mental_health_support = 'Yes') * 100.0 / COUNT(*) as pct_mh_support,
    -- Job satisfaction
    COUNT(*) FILTER (WHERE job_satisfaction >= 7) * 100.0 / COUNT(*) as pct_satisfied
FROM burnout_data
WHERE burnout_level < 3;  -- Low burnout group

-- Compare to high burnout group

SELECT 
    'Risk Factor Profile' as analysis,
    -- Sleep adequacy
    COUNT(*) FILTER (WHERE sleep_hours >= 7) * 100.0 / COUNT(*) as pct_adequate_sleep,
    -- Exercise
    COUNT(*) FILTER (WHERE physical_activity_hrs >= 3) * 100.0 / COUNT(*) as pct_regular_exercise,
    -- Manager support
    COUNT(*) FILTER (WHERE manager_support_score >= 7) * 100.0 / COUNT(*) as pct_good_manager,
    -- Work-life balance
    COUNT(*) FILTER (WHERE work_life_balance_score >= 7) * 100.0 / COUNT(*) as pct_good_wlb,
    -- Reasonable hours
    COUNT(*) FILTER (WHERE work_hours_per_week < 50) * 100.0 / COUNT(*) as pct_reasonable_hours,
    -- Mental health support
    COUNT(*) FILTER (WHERE has_mental_health_support = 'Yes') * 100.0 / COUNT(*) as pct_mh_support,
    -- Job satisfaction
    COUNT(*) FILTER (WHERE job_satisfaction >= 7) * 100.0 / COUNT(*) as pct_satisfied
FROM burnout_data
WHERE burnout_level >= 7;






