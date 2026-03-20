# Mental Health and Burnout in the Workplace: A Data Analysis of Employee Well-Being

## Overview

This project analyzes workplace burnout across 3,000 employees in 7 countries to identify which factors most influence employee wellbeing. While most workplace variables show minimal group-level impact on burnout, the analysis uncovers a striking exception: **gender moderates how workplace structures affect burnout**, with remote work and manager support producing meaningfully different outcomes for male versus female employees.

**Tools:** PostgreSQL · Tableau Public · GitHub

**Dataset:** [Mental Health & Burnout in the Workplace](https://www.kaggle.com/datasets/khushikyad001/mental-health-and-burnout-in-the-workplace) (Kaggle)

📊 **[View Interactive Dashboard on Tableau Public](#)** *(link to be added)*

![Dashboard Screenshot](visualizations/dashboard_screenshot.png)

---

## Key Findings

### 1. Remote Work Shows Opposite Effects by Gender
Remote work reduces male burnout by 0.38 points (5.79 → 5.41) but *increases* female burnout by 0.38 points (5.40 → 5.78). This bidirectional effect — identical in magnitude but opposite in direction — challenges assumptions about universal benefits of remote work policies.

### 2. Manager Support Narrows the Gender Burnout Gap
Women with low manager support report the highest burnout of any group (5.76), while men with low support report the lowest (5.37) — a 0.39-point gender gap. High manager support reduces this gap to just 0.08 points, suggesting that strong management disproportionately benefits female employees.

### 3. Most Factors Don't Predict Burnout
Work hours, sleep, benefit access, mental health days, work-life balance scores, and job satisfaction all show less than 0.2-point variation across groups. The R² between work hours and burnout is less than 0.01 — hours explain less than 1% of burnout variation. Burnout is distributed uniformly across the 1–10 scale, affecting all levels equally.

### 4. Countries Show Strikingly Similar Patterns
Across all 7 countries (USA, Canada, UK, Germany, India, Brazil, Australia), average burnout ranges only from 5.39 to 5.60 — a 0.21-point spread. Stress levels, sleep hours, work hours, and remote work rates are all similarly clustered. Geography does not explain burnout.

---

## Methodology

### Data Exploration & Quality Check
- Verified 3,000 rows with zero null values across all columns
- Confirmed balanced sample sizes (~400 per country, even gender splits)
- Identified uniform burnout distribution (1–10 scale) with high individual variance (SD ≈ 2.5)
- Validated all numeric fields within expected ranges

### SQL Analysis (PostgreSQL)
Analysis progressed from descriptive statistics through interaction effects:

1. **Country-level profiling** — Multi-metric comparison across 7 countries
2. **Demographic analysis** — Age, gender, and education patterns
3. **Interaction effects** — Gender × Remote Work, Gender × Manager Support
4. **Extreme case analysis** — Top 10% vs Bottom 10% burnout profiling across 15+ dimensions
5. **Workplace factor combinations** — Hours × Support, Benefits access vs utilization

### Tableau Visualization
Single-page dashboard with progressive disclosure:
- **Context layer:** KPI cards, burnout distribution histogram, country heat map
- **Exploration layer:** Work hours vs burnout scatter plot (3,000 jittered data points)
- **Insight layer:** Gender × Remote Work and Gender × Manager Support line charts
- **Action layer:** Recommendations text

---

## SQL Highlights

**Gender × Remote Work Interaction:**
```sql
SELECT
    gender,
    remote_work,
    COUNT(*) as count,
    ROUND(AVG(burnout_level)::numeric, 2) as avg_burnout
FROM burnout_data
WHERE gender IN ('Male', 'Female')
GROUP BY gender, remote_work
ORDER BY gender, remote_work;
```

**Extreme Case Profiling (Top vs Bottom 10%):**
```sql
WITH burnout_percentiles AS (
    SELECT
        PERCENTILE_CONT(0.10) WITHIN GROUP (ORDER BY burnout_level) as p10,
        PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY burnout_level) as p90
    FROM burnout_data
)
SELECT
    CASE
        WHEN burnout_level <= (SELECT p10 FROM burnout_percentiles) THEN 'Bottom 10% (Thriving)'
        WHEN burnout_level >= (SELECT p90 FROM burnout_percentiles) THEN 'Top 10% (Struggling)'
    END as group_name,
    COUNT(*) as count,
    ROUND(AVG(age)::numeric, 1) as avg_age,
    ROUND(AVG(work_hours_per_week)::numeric, 1) as avg_hours,
    ROUND(AVG(managersupportscore)::numeric, 1) as avg_manager_support,
    ROUND(AVG(stress_level)::numeric, 1) as avg_stress
FROM burnout_data
WHERE burnout_level <= (SELECT p10 FROM burnout_percentiles)
   OR burnout_level >= (SELECT p90 FROM burnout_percentiles)
GROUP BY group_name;
```

**Country Multi-Metric Profile:**
```sql
SELECT
    country,
    ROUND(AVG(burnout_level)::numeric, 2) as avg_burnout,
    ROUND(AVG(sleep_hours)::numeric, 2) as avg_sleep,
    ROUND(AVG(stress_level)::numeric, 2) as avg_stress,
    ROUND(AVG(work_hours_per_week)::numeric, 2) as avg_hours,
    ROUND(COUNT(*) FILTER (WHERE remote_work = 'Remote') * 100.0 / COUNT(*), 1) as pct_remote
FROM burnout_data
GROUP BY country
ORDER BY avg_burnout DESC;
```

---

## Recommendations

1. **Replace universal remote work mandates with gender-aware flexible policies.** Remote work reduces male burnout but increases female burnout — one-size-fits-all approaches create unintended gender disparities.

2. **Invest in manager training.** High manager support narrows the gender burnout gap by 80% (from 0.39 to 0.08 points). This is the strongest modifiable predictor in the dataset.

3. **Audit existing workplace policies for differential gender impact.** If remote work and manager support affect genders differently, other policies likely do too.

---

## Limitations

- **Synthetic dataset.** This dataset exhibits uniformly distributed variables with limited natural correlations, consistent with synthetic data generation. While this constrains the depth of findings, the analysis demonstrates a complete analytical workflow and the ability to identify interaction effects within noisy data.
- **Correlation, not causation.** The gender × remote work relationship may be driven by unmeasured confounders (caregiving responsibilities, workspace quality, social support needs).
- **Self-reported data.** Burnout scores are subjective and may vary in interpretation across cultures and genders.
- **Cross-sectional design.** A single time point cannot capture how burnout develops over time.

---

## Repository Structure

```
workplace-burnout-analysis/
├── sql/
│   ├── 01_data_quality_check.sql
│   ├── 02_data_cleaning.sql
│   ├── 03_country_analysis.sql
│   ├── 04_demographic_analysis.sql
│   ├── 05_workplace_analysis.sql
│   └── 06_export_for_tableau.sql
├── script/
│   └── import_data.py
├── data_raw/
│   └── burnout_data.csv
├── data_clean/
│   └── (cleaned exports)
├── visualizations/
│   └── dashboard_screenshot.png
└── README.md
```

---

## Technical Skills Demonstrated

| Category | Skills |
|----------|--------|
| **SQL** | CTEs, window functions (RANK, PERCENTILE_CONT), FILTER clause, CASE WHEN, multi-table aggregations, interaction effect analysis |
| **Tableau** | 7 chart types (KPI cards, histogram, scatter plot, heat map, line charts, grouped bars), calculated fields, jitter technique, separate legends, dashboard layout |
| **Analysis** | Interaction effects, extreme case profiling, variance analysis, hypothesis testing through exploration, negative finding documentation |
| **Communication** | Insight-driven chart titles, progressive disclosure dashboard structure, actionable recommendations tied to findings |

---

## Author

**Amber** · [GitHub](https://github.com/arterlioz)
