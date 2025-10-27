--4. Existuje rok, ve kterem byl mezirocni narust cen potravin vyrazne vyssi nez rust mezd (vetsi nez 10 %)?

WITH prices AS (
  	SELECT DISTINCT 
  		name,
  		avg_price,
  		year_value
	FROM t_vit_sterba_project_sql_primary_final
),
prev_price AS (
	SELECT
		name,
		year_value,
		avg_price,
		LAG(avg_price) OVER (PARTITION BY name ORDER BY year_value) AS previous_price
	FROM prices	
),
price_rise AS (
	SELECT
		name,
		year_value,
		CASE 
			WHEN previous_price IS NULL THEN NULL
			ELSE ((avg_price - previous_price)/previous_price)*100
		END AS "price_rise"
	FROM prev_price		
),
avg_price_rise AS (
	SELECT
		year_value,
		AVG(price_rise) AS avg_price_rise
	FROM price_rise
	GROUP BY year_value
),
payroll AS (
	SELECT DISTINCT
		industry_branch,
	    year_value,
		avg_payroll_value
	FROM t_vit_sterba_project_sql_primary_final
),
prev_payroll AS (
	SELECT
		industry_branch,
		year_value,
		avg_payroll_value,
		LAG(avg_payroll_value) OVER (PARTITION BY industry_branch ORDER BY year_value) AS previous_payroll_value
	FROM payroll	
),
payroll_rise AS (
	SELECT
		industry_branch,
		year_value,
		avg_payroll_value,
		CASE 
			WHEN previous_payroll_value IS NULL THEN NULL
			ELSE ((avg_payroll_value - previous_payroll_value)/previous_payroll_value)*100
		END AS "payroll_rise"
	FROM prev_payroll		
),
avg_payroll_rise AS (
	SELECT
		year_value,
		AVG(payroll_rise) AS avg_payroll_rise
	FROM payroll_rise
	GROUP BY year_value
)
SELECT
	pa.year_value AS "year",
	ROUND(avg_price_rise::numeric,2) AS price_rise,
	ROUND(avg_payroll_rise::numeric,2) AS payroll_rise,
	ROUND((avg_price_rise-avg_payroll_rise)::numeric,2) AS difference
FROM avg_payroll_rise pa
JOIN avg_price_rise pr
ON pa.year_value = pr.year_value
WHERE pa.avg_payroll_rise IS NOT NULL AND pr.avg_price_rise IS NOT NULL
ORDER BY difference DESC;