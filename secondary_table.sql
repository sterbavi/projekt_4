
DROP TABLE IF EXISTS t_vit_sterba_project_SQL_secondary_final;

CREATE TABLE t_vit_sterba_project_SQL_secondary_final AS
SELECT 
	c.country,
	e.year AS year_value,
	e.GDP,
	e.GINI,
	e.population
FROM economies e
JOIN countries c
ON e.country = c.country 
WHERE 
	e.year BETWEEN 2006 AND 2018
	AND c.continent = 'Europe'
ORDER BY c.country,e.year;


SELECT * FROM t_vit_sterba_project_SQL_secondary_final;
	
	