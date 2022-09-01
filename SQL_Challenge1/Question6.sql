/*
6. All in a single query, execute all of the steps below and provide the results as your final answer:

a.create a single list of all per_capita records for year 2009 that includes columns:
-continent_name
-country_code
-country_name
-gdp_per_capita

b. order this list by:
-continent_name ascending
-characters 2 through 4 (inclusive) of the country_name descending

c. create a running total of gdp_per_capita by continent_name

d. return only the first record from the ordered list for which each continent's running total of gdp_per_capita meets or exceeds $70,000.00 with the following columns:

-continent_name
-country_code
-country_name
-gdp_per_capita
-running_total
*/

SELECT con.continent_name, 
       pc.country_code,
	   c.country_name,
	   pc.gdp_per_capita
	   --NO sufficient data to calculate running total
FROM dbo.per_capita  pc 
JOIN dbo.countries c ON pc.country_code = c.country_code
JOIN dbo.continent_map cm ON c.country_code = cm.country_code
JOIN dbo.continents con ON cm.continent_code = con.continent_code
WHERE year = 2009
ORDER BY con.continent_name ASC, SUBSTRING(c.country_name, 2, 3) DESC;
