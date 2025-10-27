--1. Rostou v prubehu let mzdy ve vsech odvetvich, nebo v nekterych klesaji?
WITH salaries AS (
	SELECT DISTINCT
		pt.industry_branch ,
		pt.year_value,
		pt.avg_payroll_value AS salaries
	FROM t_vit_sterba_project_sql_primary_final pt 
),
changes AS (
	SELECT 
		industry_branch,
		year_value,
		salaries,
		LAG(salaries) OVER (PARTITION BY industry_branch ORDER BY year_value ) AS previous_value,
		ROUND (
			(salaries-LAG(salaries) OVER (PARTITION BY industry_branch ORDER BY year_value ))
			/ LAG(salaries) OVER (PARTITION BY industry_branch ORDER BY year_value ) * 100, 2
			) AS percentage_change
	FROM salaries
)
SELECT
	industry_branch,
	year_value AS "year",
	salaries,
	previous_value,
	percentage_change
FROM changes
WHERE previous_value IS NOT NULL AND percentage_change < 0
ORDER BY percentage_change;
	