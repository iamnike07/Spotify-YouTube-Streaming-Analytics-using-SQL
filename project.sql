-- Spotify Database SQL Project

-- create table
DROP TABLE IF EXISTS spotify;
CREATE TABLE spotify (
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
    danceability FLOAT,
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(255),
    channel VARCHAR(255),
    views FLOAT,
    likes BIGINT,
    comments BIGINT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);

select count(*) from spotify;

select count(distinct artist) from spotify;

select distinct album_type from spotify;

select max(duration_min) from spotify;
select min(duration_min) from spotify;

select * from spotify
where duration_min = 0

delete from spotify
where duration_min=0;

select distinct most_played_on from spotify;

--Q1 Retrieving the names of all tracks that have more than 1 billion streams

select * from spotify
where stream > 1000000000

--Q2 list all albums along with their respective artists

select
distinct album, artist
from spotify
order by 1

--Q3 get the total number of commments for tracks where licensed=true

select
sum(comments) as total_comments
from spotify 
where licensed='true'

--Q4 Are danceable songs more popular?

SELECT
    track,
    danceability,
    stream
FROM 0spotify
ORDER BY danceability DESC;

--Q5 What duration gets the most streams?

SELECT
    CASE
        WHEN duration_min < 3 THEN 'Short'
        WHEN duration_min BETWEEN 3 AND 4 THEN 'Medium'
        ELSE 'Long'
    END AS duration_category,
    ROUND(AVG(stream) / 1000000.0, 2) AS avg_streams_millions --converted those big outputs in millions
FROM spotify
GROUP BY duration_category;

--Q6 find all tracks that belong to the album type single.

select * from spotify
where album_type ='single'

--Q7 count the total number of tracks by each artist

select
artist,
count(*) as total_no_songs
from spotify
group by artist
order by 2 desc

-- -----------------------------------------------------------------

--Q8 calculate the average danceability of tracks in each album.

select 
	album,
	avg(danceability) as avg_danceability
from spotify
group by 1
order by 2 desc

--Q9 find the top 5 tracks with highest energy values
select 
	track, avg(energy)
	from spotify
	group by 1
	order by 2 desc
	limit 5

--Q10 list all tracks along with their views and likes where official_video = true

select 
	track,
	sum(views) as total_views,
	sum(likes) as total_likes
from spotify
where official_video = 'true'
group by 1
order by 2 desc
limit 5

--Q11 for each album, calculate the total views of all associated tracks.

select
	album,
	track,
sum(views)
from spotify
group by 1,2
order by 3 desc

--Q12 retrieve the tracks names that have been streamed on spotify more than youtube.

SELECT track, stream, views
FROM spotify
WHERE COALESCE(stream, 0) > COALESCE(views, 0)
ORDER BY stream DESC;

--Q13 find the top 3 most viewed tracks for each artist using window function

with ranking_artist
as 
(select 
	artist,
	track,
	sum(views) as total_view,
	dense_rank() over(partition by artist order by sum(views) desc) as rank
	from spotify
	group by 1,2
	order by 1,3 desc
	)
select * from ranking_artist
where rank <=3;

--Q14 write a query to find tracks where the liveness score is above the average.

select 
	track,artist,liveness
from spotify
where liveness > (select avg(liveness)from spotify)

/*Q15 use a with clause to calculate the differences between the highest and lowest
energy values for tracks in each album*/

with cte
as
(select album,
	MAX(energy) as highest_energy,
	MIN(energy) as lowest_energy
from spotify
group by 1
)
select 
	album,
	highest_energy - lowest_energy as energy_diff
from cte
order by 1

--Q16 Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions

SELECT
    track,
    views,
    likes,
    SUM(likes) OVER (
        ORDER BY views
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
   ) AS cumulative_likes
FROM spotify
where views > 0 --removing those songs which has no views hence no need to keep it for cumulative likes.
ORDER BY views;


--Q17 Find tracks where the energy-to-liveness ratio is greater than 1.2

SELECT
    track,
    energy,
    liveness,
    energy / liveness AS energy_liveness_ratio
FROM spotify
WHERE liveness > 0 --prevents division by zero
  AND energy / liveness > 1.2;

--Q18 high energy songs but did not go viral so much.

SELECT
    track,
    energy,
    views,
    stream
FROM spotify
WHERE energy > 0.8
  AND views < (SELECT AVG(views) FROM spotify);

--Q19 Which tracks perform better than their artist’s average?

SELECT
    artist,
    track,
    ROUND(stream / 1000000.0, 2) AS stream_millions,
    ROUND(artist_avg_streams / 1000000.0, 2) AS artist_avg_streams_millions
FROM (
    SELECT
        artist,
        track,
        stream,
        AVG(stream) OVER (PARTITION BY artist) AS artist_avg_streams
    FROM spotify
) t
WHERE stream > artist_avg_streams;

--Q20 Find tracks with unusually high engagement.

SELECT *
FROM (
    SELECT
        track,
        stream,
        (stream - AVG(stream) OVER ()) /
        NULLIF(STDDEV(stream) OVER (), 0) AS z_score,
        AVG(stream) OVER () + 2 * STDDEV(stream) OVER () AS threshold
    FROM spotify
) t
WHERE stream > threshold;
