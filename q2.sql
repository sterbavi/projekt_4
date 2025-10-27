--2. Kolik je mozne si koupit litru mleka a kilogramu chleba za prvni a posledni srovnatelne obdobi v dostupnych datech cen a mezd?

WITH food AS (
	SELECT DISTINCT
		name,
		avg_price AS food_price,
		price_value,
		price_unit,
		year_value
	FROM t_vit_sterba_project_sql_primary_final
	WHERE year_value IN (2006,2018) and (name like 'Mléko%' OR name like 'Chléb%')
),
payroll AS (
	SELECT DISTINCT
		industry_branch,
	    year_value,
		avg_payroll_value
	FROM t_vit_sterba_project_sql_primary_final
),
avg_payroll AS (
	SELECT
		year_value,
		AVG(avg_payroll_value) payroll	  
	FROM payroll
	WHERE year_value IN (2006,2018)
	GROUP BY year_value
)
SELECT 
		fo.name,
		ROUND(payroll/food_price) AS "payroll/food",
		fo.year_value,
		ROUND(fo.food_price::numeric, 2) AS food_price,
		fo.price_value,
		fo.price_unit,
		ROUND(pa.payroll) AS payroll	
FROM avg_payroll pa
JOIN food fo
ON pa.year_value = fo.year_value
ORDER BY name,year_value;

