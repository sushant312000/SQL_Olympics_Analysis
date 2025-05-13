use sql_capstone;


select * from olympics_history;

select * from OLYMPICS_HISTORY_NOC_REGIONS;

select count(distinct(games)) as Total_games from olympics_history;

select distinct year, season, city from olympics_history order by year;

select games, count(distinct noc) as total_countries from olympics_history 
group by games order by games;

with lowest As
(
	select concat(games, "-", total_countries) as lowest_country_count from (select games, count(distinct noc) as 
	total_countries from olympics_history group by games order by games limit 1) as sec
),
Highest As
(
	select concat(games, "-", total_countries) as highest_country_count from (select games, count(distinct noc) as 
	total_countries from olympics_history group by games order by games desc limit 1) as sec
)
select * from lowest, highest;

create index game_idx 
on olympics_history(games);

select count(distinct games) as total_games, team from olympics_history 
group by team having total_games = (select count(distinct(games)) as Total_games from olympics_history);

select sport, count(distinct games) as game_count from olympics_history 
group by sport 
having game_count = (select count(distinct games) from olympics_history where season = "Summer"); 

with temp_sport_count as
(
	select count(distinct games) as game_count, sport from olympics_history group by sport
)
select * from temp_sport_count where game_count = 1;

select count(distinct sport) as sport_count, games  from olympics_history group by games order by sport_count desc;

select * from olympics_history where age <= (select max(age) from olympics_history where not age = "NA") and medal = "Gold" 
limit 1;

with gold as
(
select name, team, medal from olympics_history where medal = "Gold"
)
select name, team, count(medal) as medal_count from gold group by name, team order by medal_count desc limit 5;

with gold as
(
select name, team, medal from olympics_history where not medal = "NA"
)
select name, team, count(medal) as medal_count from gold group by name, team order by medal_count desc limit 5;

select noc, count(medal) as medal_count, rank()over(order by count(medal) desc) as rnk from 
olympics_history group by noc order by medal_count desc limit 5;

select noc, 
COUNT(CASE WHEN medal = 'Gold' THEN 1 END) AS gold_count,
COUNT(CASE WHEN medal = 'Silver' THEN 1 END) AS silver_count,
COUNT(CASE WHEN medal = 'Bronze' THEN 1 END) AS bronze_count
from olympics_history
group by noc 
order by gold_count desc;
