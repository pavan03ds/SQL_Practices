/*4a. What is the count of countries and sum of their related gdp_per_capita values for the year 2007
      where the string 'an' (case insensitive) appears anywhere in the country name?
*/

SELECT COUNT(*) [Count_of_countries],    --Case insensitive
       SUM(gdp_per_capita)  [Sum_of_gdp_per_capita]
FROM
(
 SELECT pc.*,c.country_name    
 FROM dbo.per_capita  pc 
 JOIN dbo.countries c ON pc.country_code = c.country_code
) x
WHERE year = 2007 AND country_name LIKE '%an%'

---------------------------------------------------
/*
4b. Repeat question 4a, but this time make the query case sensitive.
*/

SELECT COUNT(*) [Count_of_countries],    --Case insensitive
       SUM(gdp_per_capita)  [Sum_of_gdp_per_capita]
FROM
(
 SELECT pc.*,c.country_name    
 FROM dbo.per_capita  pc 
 JOIN dbo.countries c ON pc.country_code = c.country_code
) x
WHERE year = 2007 AND country_name COLLATE Latin1_General_CS_AS  LIKE '%an%'
