/*
1a.Alphabetically list all of the country codes in the continent_map table that appear more than once.
Display any values where country_code is null as country_code = "FOO" and make this row appear first in the list, 
even though it should alphabetically sort to the middle.
Provide the results of this query as your answer.
*/

SELECT COALESCE(country_code, 'FOO')  AS country_code
FROM dbo.continent_map
GROUP BY country_code
HAVING COUNT(COALESCE(country_code, 'FOO')) > 1
ORDER BY CASE WHEN country_code is null then 1 else 2 end;