USE EPL_master;

-- checking for duplicates in Player table
SELECT
  z.*
FROM(
  SELECT
    player_api_id
    ,COUNT(player_api_id) as Count
  FROM Player
  GROUP BY
    player_api_id
  )as z
WHERE z.[Count]>1

-- calculate average, count, peak, start
IF OBJECT_ID('tempdb...#PlayerStats') IS NOT NULL
DROP TABLE #PlayerStats
SELECT
  player_api_id
  ,AvgRating = AVG(overall_rating)
  ,CountRating = COUNT(overall_rating)
  ,MaxRating = MAX(overall_rating)
  ,MinRating = MIN(overall_rating)
  ,YearsRated =datediff(yy,MIN(date),MAX(date))
  ,StartYear = MIN(date)
  ,FinalYear = MAX(date)
INTO #PlayerStats
FROM Player_Attributes
GROUP BY
  player_api_id


-- Get the first value for overall rating per player: StartOverall
-- Some records have duplicates filled with nulls, added a.id to order by in the rank
IF OBJECT_ID('tempdb...#StartOverall') IS NOT NULL
DROP TABLE #StartOverall
SELECT
  z.player_api_id
  ,z.overall_rating as StartOverall
INTO #StartOverall
FROM(
  SELECT
    a.player_api_id
    ,a.overall_rating
    ,FirstRank = RANK()OVER(PARTITION BY a.player_api_id ORDER BY [date], a.id )
  FROM Player_Attributes as a
  ) as z
WHERE FirstRank = 1



-- Get most recent overall rating 
IF OBJECT_ID('tempdb...#RecentOverall') IS NOT NULL
DROP TABLE #RecentOverall
SELECT
  z.player_api_id
  ,z.overall_rating as RecentOverall
INTO #RecentOverall
FROM(
  SELECT
    RecentRank = ROW_NUMBER()OVER(PARTITION BY player_api_id ORDER BY date DESC)
    ,overall_rating
    ,player_api_id
  FROM Player_Attributes
  ) as z
WHERE z.RecentRank = 1

-- create player table

SELECT
  a.player_api_id
  ,a.height
  ,a.weight
  ,b.AvgRating
  ,b.CountRating
  ,b.MaxRating
  ,b.MinRating
  ,b.YearsRated
  ,b.StartYear
  ,b.FinalYear
  ,c.StartOverall
  ,d.RecentOverall
FROM Player as a
JOIN #Playerstats as b
  ON a.player_api_id = b.player_api_id
JOIN #StartOverall as c
  ON a.player_api_id = c.player_api_id
JOIN #RecentOverall as d
  ON a.player_api_id = d.player_api_id



-- grab team attributes by api_id and date aka different coaches(?) and join to player via roster and date specification
-- create final table with multiples of individual player by coach(?)

-- incomplete data acquisition for the following:
  -- Home Matches played career 
  -- Home Matches played last season
  -- Away Matches played career
  -- Away Matches played last season
  -- Matches as subs career
  -- Matches as subs last season
  
-- avg betting stats for team match (indication of being on a better team?)
-- join player to player attributes (ranked)

SELECT
  ,league_id
  ,season
  ,stage
  ,date
  ,match_api_id
  ,home_team_api_id
  ,away_team_api_id
  ,home_team_goal
  ,away_team_goal
  ,B365H
  ,B365D
  ,B365A
  ,BWH
  ,BWD
  ,BWA
  ,IWH
  ,IWD
  ,IWA
  ,LBH
  ,LBD
  ,LBA
FROM Match
