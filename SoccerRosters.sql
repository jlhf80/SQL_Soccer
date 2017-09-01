USE EPL_master;

-- get team rosters
-- check for incorrect rows when using OR in join
-- use player_api id
-- #Roster shows players that played in a given season, not total team roster

CREATE TABLE Roster(
  home_team_api_id int
  ,season varchar(55)
  ,player_api_id int
  )
  
INSERT INTO Roster
SELECT *
FROM #Roster
  
  IF OBJECT_ID('tempdb...#Roster') IS NOT NULL
  DROP TABLE #Roster
  SELECT
    a.home_team_api_id
    ,a.season
    ,a.home_player_1 as player_fifa_api_id
  INTO #Roster
  FROM Match as a
  JOIN Player as b
    --ON a.home_player_1 = b.player_fifa_api_id
    ON a.home_player_1 = b.player_api_id
  GROUP BY
    a.home_team_api_id
    ,a.season
    ,a.home_player_1
  UNION ALL
  SELECT
    a.home_team_api_id
    ,a.season
    ,a.home_player_2
  FROM Match as a
  JOIN Player as b
    --ON a.home_player_2 = b.player_fifa_api_id
    ON a.home_player_2 = b.player_api_id
  GROUP BY
    a.home_team_api_id
    ,a.season
    ,a.home_player_2
  UNION ALL
  SELECT
    a.home_team_api_id
    ,a.season
    ,a.home_player_3
  FROM Match as a
  JOIN Player as b
    --ON a.home_player_3 = b.player_fifa_api_id
    ON a.home_player_3 = b.player_api_id
  GROUP BY
    a.home_team_api_id
    ,a.season
    ,a.home_player_3
  UNION ALL
  SELECT
    a.home_team_api_id
    ,a.season
    ,a.home_player_4
  FROM Match as a
  JOIN Player as b
    --ON a.home_player_4 = b.player_fifa_api_id
    ON a.home_player_4 = b.player_api_id
  GROUP BY
    a.home_team_api_id
    ,a.season
    ,a.home_player_4
  UNION ALL
  SELECT
    a.home_team_api_id
    ,a.season
    ,a.home_player_5
  FROM Match as a
  JOIN Player as b
    --ON a.home_player_5 = b.player_fifa_api_id
    ON a.home_player_5 = b.player_api_id
  GROUP BY
    a.home_team_api_id
    ,a.season
    ,a.home_player_5
  UNION ALL
  SELECT
    a.home_team_api_id
    ,a.season
    ,a.home_player_6
  FROM Match as a
  JOIN Player as b
    --ON a.home_player_6 = b.player_fifa_api_id
    ON a.home_player_6 = b.player_api_id
  GROUP BY
    a.home_team_api_id
    ,a.season
    ,a.home_player_6
  UNION ALL
  SELECT
    a.home_team_api_id
    ,a.season
    ,a.home_player_7
  FROM Match as a
  JOIN Player as b
    --ON a.home_player_7 = b.player_fifa_api_id
    ON a.home_player_7 = b.player_api_id
  GROUP BY
    a.home_team_api_id
    ,a.season
    ,a.home_player_7
  UNION ALL
  SELECT
    a.home_team_api_id
    ,a.season
    ,a.home_player_8
  FROM Match as a
  JOIN Player as b
    --ON a.home_player_8 = b.player_fifa_api_id
    ON a.home_player_8 = b.player_api_id
  GROUP BY
    a.home_team_api_id
    ,a.season
    ,a.home_player_8
  UNION ALL
  SELECT
    a.home_team_api_id
    ,a.season
    ,a.home_player_9
  FROM Match as a
  JOIN Player as b
    --ON a.home_player_9 = b.player_fifa_api_id
    ON a.home_player_9 = b.player_api_id
  GROUP BY
    a.home_team_api_id
    ,a.season
    ,a.home_player_9
  UNION ALL
  SELECT
    a.home_team_api_id
    ,a.season
    ,a.home_player_10
  FROM Match as a
  JOIN Player as b
    --ON a.home_player_10 = b.player_fifa_api_id
   ON a.home_player_10 = b.player_api_id
  GROUP BY
    a.home_team_api_id
    ,a.season
    ,a.home_player_10
  UNION ALL
  SELECT
    a.home_team_api_id
    ,a.season
    ,a.home_player_11
  FROM Match as a
  JOIN Player as b
    --ON a.home_player_11 = b.player_fifa_api_id
    ON a.home_player_11 = b.player_api_id
  GROUP BY
    a.home_team_api_id
    ,a.season
    ,a.home_player_11
    
SELECT top 100 * from #Roster

IF OBJECT_ID('tempdb...#test') IS NOT NULL
DROP TABLE #test
SELECT
  b.team_short_name
  ,a.home_team_api_id
  ,a.season
  ,a.player_fifa_api_id as player_api_id
  ,rank = DENSE_RANK() OVER(PARTITION BY a.home_team_api_id ORDER BY a.SEASON DESC)
INTO #test
FROM #Roster as a
JOIN team as b
  ON a.home_team_api_id = b.team_api_id
WHERE home_team_api_id = 8455


SELECT 
  season
  ,count(distinct player_api_id) as ct
FROM #test
GROUP BY season


-- check chelsea for roster
-- Roster shows players who played in season, not total roster
SELECT
  distinct z.player_name
FROM(
  SELECT
    a.season
    ,a.player_api_id
    ,b.player_name
  FROM #test as a
  JOIN Player as b
    ON a.player_api_id = b.player_api_id
  WHERE a.season = '2015/2016'
  ) as z

-- player starts are incomplete
SELECT 
  b.team_long_name
  ,a.season
  ,a.player_api_id
  ,c.player_name
  ,COUNT(c.player_name) as ctAppearances
FROM roster as a
JOIN Team as b
  ON a.home_team_api_id = b.team_api_id
JOIN Player as c
  ON a.player_api_id = c.player_api_id
WHERE home_team_api_id = 8455
  AND season = '2015/2016'
GROUP BY
  b.team_long_name
  ,a.season
  ,a.player_api_id
  ,c.player_name
