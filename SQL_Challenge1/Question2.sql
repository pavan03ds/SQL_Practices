//*
2.List the countries ranked 10-12 in each continent by the percent of year-over-year growth descending from 2011 to 2012.
The percent of growth should be calculated as: ((2012 gdp - 2011 gdp) / 2011 gdp)
The list should include the columns:
-rank
-continent_name
-country_code
-country_name
-growth_percent
*/


SELECT pc.*,c.country_name, con.continent_name   --query to fecth required columns from different tables 
FROM dbo.per_capita  pc 
JOIN dbo.countries c ON pc.country_code = c.country_code
JOIN dbo.continent_map cm ON c.country_code = cm.country_code
JOIN dbo.continents con ON cm.continent_code = con.continent_code



SELECT  gdp11.country_code, 
        gdp11.country_name, 
	    gdp11.continent_name,
		CONCAT(ROUND(((gdp12.gdp_per_capita - gdp11.gdp_per_capita)/ gdp11.gdp_per_capita),2) * 100,'%') AS growth_percent,
	    RANK() OVER(PARTITION BY gdp11.continent_name ORDER BY ((gdp12.gdp_per_capita - gdp11.gdp_per_capita) / gdp11.gdp_per_capita) DESC) AS RANK
FROM 
(
SELECT pc.*,c.country_name, con.continent_name
FROM 
dbo.per_capita pc
JOIN dbo.countries c ON pc.country_code = c.country_code
JOIN dbo.continent_map cm ON c.country_code = cm.country_code
JOIN dbo.continents con ON cm.continent_code = con.continent_code
WHERE year = 2012 AND gdp_per_capita IS NOT NULL
) gdp12

JOIN 
(
SELECT pc.*,c.country_name, con.continent_name
FROM 
dbo.per_capita pc
JOIN dbo.countries c ON pc.country_code = c.country_code
JOIN dbo.continent_map cm ON c.country_code = cm.country_code
JOIN dbo.continents con ON cm.continent_code = con.continent_code
WHERE year = 2011 AND gdp_per_capita IS NOT NULL
) gdp11 
ON gdp12.country_code = gdp11.country_code
