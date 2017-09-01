USE EPL_2016_2017
SELECT count(*) FROM TeamStatRollup

SELECT * FROM TeamStatRollup

select * from StatAttributeDefinitions


SELECT TOP 5
  HomeTeam
  ,SUM(FTHG) as Total_Goals
  ,AVG(HS) as Avg_Shots
FROM TeamStatRollup
GROUP BY HomeTeam
ORDER BY SUM(FTHG) DESC