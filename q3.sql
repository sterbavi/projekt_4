--Ktera kategorie potravin zdrazuje nejpomaleji (je u ni nejnizsi percentualni mezirocni narust)?

WITH avg_prices AS (
	SELECT DISTINCT
		name,
		year_value,
		avg_price
	FROM t_vit_sterba_project_sql_primary_final
),
prev_price AS (
	SELECT
		name,
		year_value,
		avg_price,
		LAG(avg_price) OVER (PARTITION BY name ORDER BY year_value) AS previous_price
	FROM avg_prices	
),
percentages AS (
	SELECT
		name,
		year_value,
		CASE 
			WHEN previous_price IS NULL THEN NULL
			ELSE ((avg_price - previous_price)/previous_price)*100
		END AS "year_on_year_growth%"
	FROM prev_price		
)
SELECT  
	name,
	ROUND(AVG("year_on_year_growth%")::numeric,2) as avg_percentages_growth
FROM percentages
WHERE "year_on_year_growth%" IS NOT NULL
GROUP BY name
ORDER BY avg_percentages_growth;

