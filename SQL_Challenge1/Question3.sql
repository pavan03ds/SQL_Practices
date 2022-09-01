/*
3. For the year 2012, create a 3 column, 1 row report showing the percent share of gdp_per_capita for the following regions:
(i) Asia, (ii) Europe, (iii) the Rest of the World.

-Your result should look something like
Asia	Europe	Rest of World
25.0%	25.0%	50.0%
*/

SELECT * INTO GDPTemp
FROM
(SELECT pc.*,c.country_name, con.continent_name    
FROM dbo.per_capita  pc 
JOIN dbo.countries c ON pc.country_code = c.country_code
JOIN dbo.continent_map cm ON c.country_code = cm.country_code
JOIN dbo.continents con ON cm.continent_code = con.continent_code
) x


-- After creating [GDPTemp(1)] temporary table
UPDATE [GDPTemp(1)]
SET continent_name = 'Rest of World'
Where continent_name NOT IN ('Asia','Europe')


SELECT * from 
(
SELECT  continent_name, gdp_per_capita 
FROM [GDPTemp(1)]
) t
PIVOT
(SUM(gdp_per_capita)
FOR continent_name IN (Asia,Europe,[Rest of World]) 


--..........................................................................................................................................................

/* By doing the above we cannot get the GDP share of continents as asked in question */

SELECT 
CONCAT(ROUND(
       (SELECT SUM(gdp_per_capita)
        FROM dbo.GDPTemp where continent_name = 'Asia') /(SELECT SUM(gdp_per_capita)
                                                          FROM dbo.GDPTemp)* 100 ,1),'%') As Asia,
CONCAT(ROUND(
       (SELECT SUM(gdp_per_capita)
        FROM dbo.GDPTemp where continent_name = 'Europe') /(SELECT SUM(gdp_per_capita)
                                                          FROM dbo.GDPTemp)* 100 ,1),'%') As Europe,
CONCAT(ROUND(
       (SELECT SUM(gdp_per_capita)
        FROM dbo.GDPTemp where continent_name NOT IN ('Asia','Europe')) /(SELECT SUM(gdp_per_capita)
                                                          FROM dbo.GDPTemp)* 100 ,1),'%') [Rest of World]


