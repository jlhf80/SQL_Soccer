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

SELECT
  player_api_id
  ,AvgRating = AVG(overall_rating)
  ,CountRating = COUNT(overall_rating)
  ,MaxRating = MAX(overall_rating)
  ,MinRating = MIN(overall_rating)
  ,YearsRated =datediff(yy,MIN(date),MAX(date))
  ,StartYear = MIN(date)
  ,FinalYear = MAX(date)
FROM Player_Attributes
WHERE player_api_id = 505942
GROUP BY
  player_api_id

-- Get the first value for overall rating per player: StartOverall
SELECT
  z.player_api_id
  ,StartOverall = z.overall_rating
FROM(
  SELECT
    player_api_id
    ,overall_rating
    ,FirstRank = RANK()OVER(PARTITION BY player_api_id ORDER BY [date])
  FROM Player_Attributes
  ) as z
WHERE FirstRank = 1

-- Get most recent overall rating 
SELECT
  z.*
FROM(
  SELECT
    RecentRank = RANK()OVER(PARTITION BY player_api_id ORDER BY date DESC)
    ,*
  FROM Player_Attributes
  WHERE player_api_id = 505942
  ) as z
WHERE z.RecentRank = 1


select * from Player_Attributes where player_api_id = 505942

-- join player to player attributes (ranked)


