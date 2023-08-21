-- Q1
SELECT * from movie
where mov_year>1995 and mov_time>120 and mov_title like '%A%'

-- Q2
SELECT CONCAT(Act_Fname, " ", Act_Lname) as Actor_Name from actor where act_id in(SELECT act_id from cast where mov_id in (SELECT mov_id from movie where mov_title = 'Chinatown'))

-- Q3
SELECT mov_title
FROM movie
WHERE mov_id = (
    SELECT mov_id
    FROM ratings
    WHERE Num_o_ratings = (
        SELECT MAX(Num_o_ratings)
        FROM ratings
    )
)

-- Q4
select mov_title
from movie
where mov_rel_country = 'UK' and mov_id in (
	Select mov_id
	from ratings
	group by mov_id
	order by Sum(Num_o_ratings) desc)
limit 7;

-- Q5
update movie set Mov_lang = 'Chinese' where Mov_lang = 'Japanese' and Mov_year = 2001;


-- Q6
SELECT genres.Gen_title, MAX(movie.Mov_time) AS max_duration, COUNT(*) AS movie_count
FROM movie_genres
JOIN movie AS movie ON movie_genres.mov_id = movie.mov_id
JOIN genres AS genres ON movie_genres.Gen_id = genres.Gen_id
GROUP BY genres.Gen_title

-- Q7
Create or replace view movie_cast as
Select actor.act_fname, actor.act_lname, movie.mov_title, cast.role
from movie
join cast on movie.mov_id = cast.mov_id 
join actor on cast.act_id = actor.act_id

select * from movie_cast;

-- Q8
SELECT * from movie where mov_dt_rel > 31/03/1995


-- Q9
Select actor.act_fname , actor.act_lname, cast.role 
from actor join cast on actor.act_id = cast.act_id
where actor.act_gender <> "M"


-- Q10
INSERT into practice.cast(Mov_id, Role, Act_id ) VALUES
(936, 'Darth Vader', 126),
(939, 'Sarah Connor', 140),
(942, 'Ethan Hunt', 135),
(930, 'Travis Bickle', 131),
(941, 'Antoine Doinel', 144)




