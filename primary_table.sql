
DROP TABLE IF EXISTS t_vit_sterba_project_SQL_primary_final;

CREATE TABLE t_vit_sterba_project_SQL_primary_final AS
--payroll
WITH payroll AS (
	SELECT 
		cp.payroll_year,
	    cp.industry_branch_code,
		cpib.name AS industry_branch,		 
		AVG(value) AS avg_payroll_value		
	FROM czechia_payroll cp 
	JOIN czechia_payroll_industry_branch cpib 
	ON cp.industry_branch_code = cpib.code
    WHERE cp.industry_branch_code IS NOT NULL AND cp.value_type_code =5958 AND cp.calculation_code = 200	
    GROUP BY cp.payroll_year, cp.industry_branch_code, cpib.name  
    ORDER BY cp.payroll_year, cpib.name
),
--prices
price AS (
	SELECT 
		name,
		avg(value) AS avg_price,
		price_value,
		price_unit,
		date_part('year',date_from)::int AS price_year	
	FROM czechia_price p
    JOIN czechia_price_category cpc
    ON p.category_code=cpc.code	
	WHERE region_code IS NULL
	GROUP BY category_code, name, price_value, price_unit, date_part('year',date_from)	
)
SELECT 
	pa.payroll_year AS year_value,
	pa.industry_branch_code,
	pa.industry_branch,
	pa.avg_payroll_value,
	pr.name,
	pr.avg_price,
	pr.price_value,
	pr.price_unit
FROM payroll pa
JOIN price pr
ON pa.payroll_year=pr.price_year;

SELECT * FROM t_vit_sterba_project_SQL_primary_final;