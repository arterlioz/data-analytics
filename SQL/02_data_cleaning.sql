-- DATA CLEANING
-- Date: 2024-12-30

-- Assessment: No cleaning required
-- Quality checks revealed high-quality data with no issues requiring correction.
-- 
-- Details:
-- - No missing values in critical columns
-- - No invalid values (all ages 22-59, work hours 30-59)
-- - No duplicates detected
-- - Column names standardized during import (see import_data.py)

-- Verification: Dataset ready for analysis
SELECT 
    COUNT(*) as total_rows,
    COUNT(DISTINCT employee_id) as unique_employees
FROM burnout_data;
/* Result: 3000 rows, 3000 unique employees - no duplicates */