/*5. Find the sum of gpd_per_capita by year and the count of countries for each year that have non-null gdp_per_capita 
     where (i) the year is before 2012 and 
	       (ii) the country has a null gdp_per_capita in 2012. 

Your result should have the columns:
-year
-country_count
-total
*/

SELECT year,
	   COUNT(c.country_code) [country_count],
	   SUM(gdp_per_capita) [Total_GDP]
FROM dbo.per_capita pc
JOIN dbo.countries c ON pc.country_code = c.country_code
WHERE gdp_per_capita IS NOT NULL 
GROUP BY year
HAVING year < 2012
ORDER BY year;
