CREATE SCHEMA IF NOT EXISTS fsd ;
USE fsd;

# 1. Table design.

CREATE TABLE countries(
id int primary key auto_increment,
`name` varchar(45) not null
);

CREATE TABLE towns(
id int primary key auto_increment,
`name` varchar(45) not null, 
country_id  INT NOT NULL,
 CONSTRAINT fk_towns_countries
 FOREIGN KEY (country_id)
 REFERENCES countries(id) 
);


CREATE TABLE stadiums(
id INT PRIMARY KEY AUTO_INCREMENT ,
`name` VARCHAR(45) NOT NULL,
capacity INT NOT NULL, 
 town_id INT NOT NULL,
 CONSTRAINT fk_stadiums_towns 
 FOREIGN KEY (town_id)
 REFERENCES towns(id)
);

CREATE TABLE teams(
id INT PRIMARY KEY auto_increment,
`name` varchar(45) not null,
established DATE not null,
fan_base BIGINT default 0 NOT NULL,
stadium_id  INT NOT NULL,
CONSTRAINT fk_teams_statiums 
FOREIGN KEY (stadium_id)
REFERENCES stadiums(id) 
);

CREATE TABLE skills_data(
id INT PRIMARY KEY auto_increment ,
dribbling INT DEFAULT(0),
pace INT DEFAULT(0),
passing INT DEFAULT(0),
shooting INT DEFAULT(0),
speed INT DEFAULT(0),
strength INT DEFAULT(0)
);

CREATE TABLE coaches(
id INT PRIMARY KEY auto_increment ,
first_name VARCHAR(10) NOT NULL,
last_name VARCHAR(20) NOT NULL,
salary DECIMAL(10, 2) default 0 NOT NULL ,
coach_level INT NOT NULL default 0 
);



CREATE TABLE players(
 id INT PRIMARY KEY AUTO_INCREMENT,
 first_name VARCHAR(10) NOT NULL,
 last_name VARCHAR(20) NOT NULL,
 age INT NOT NULL default(0),
 position CHAR(1) NOT NULL,
 salary DECIMAL(10, 2) NOT NULL default(0),
 hire_date datetime , 
 skills_data_id INT NOT NULL, 
 team_id INT ,
 CONSTRAINT fk_player_skill_data
 FOREIGN KEY (skills_data_id)
 REFERENCES skills_data(id),
 CONSTRAINT fk_player_team
 FOREIGN KEY (team_id)
 REFERENCES teams(id)
);


CREATE TABLE players_coaches(
player_id INT ,
coach_id INT ,
CONSTRAINT fk_player_id 
FOREIGN KEY (player_id)
references players(id),
CONSTRAINT fk_coach_id
foreign key (coach_id)
references coaches(id)
);

# SECTION 2 DATA MANUPULATION LANGUAGE (DML)
# 2. Insert

 INSERT INTO coaches(first_name, last_name, salary , coach_level)
 (SELECT first_name , last_name , salary*2 , CHAR_LENGTH(first_name) AS coach_level FROM players WHERE age >= 45);


#3. Update 

#variant 1 
UPDATE coaches INNER JOIN players_coaches SET coach_level = coach_level + 1 WHERE first_name LIKE 'A%';

#variant 2 
UPDATE coaches SET coach_level = coach_level+1 WHERE first_name LIKE 'A%' AND  (SELECT COUNT(*) FROM players_coaches WHERE coach_id = id) > 0;


#4. Delete 
DELETE FROM  players WHERE age >=45;


#5. Players 
SELECT first_name , age , salary FROM players ORDER BY salary DESC;



#6. Young offense players without contract
SELECT p.id , CONCAT_WS(" ", first_name , last_name) AS full_name , age , position , hire_date 
FROM  players AS p JOIN skills_data AS sk on p.skills_data_id = sk.id
WHERE age < 23 AND strength>50 AND position LIKE 'A' AND hire_date IS NULL
ORDER BY salary, age;

#7. Detail info for all teams
SELECT t.name as team_name , t.established , t.fan_base , (SELECT COUNT(*) FROM players as p where p.team_id = t.id ) as count 
FROM teams as t
ORDER BY count DESC, fan_base DESC ;

#8. The fastest player by towns

SELECT MAX(sd.speed ) as max_speed , t.name AS town_name FROM  
players as p 
RIGHT JOIN skills_data as sd ON p.skills_data_id = sd.id 
RIGHT JOIN teams  as te on p.team_id = te.id 
RIGHT JOIN stadiums as s ON te.stadium_id = s.id 
RIGHT JOIN towns as t ON s.town_id = t.id 
WHERE te.name NOT LIKE 'Devify'
GROUP BY t.name 
ORDER BY max_speed DESC , town_name ;

#9. Total salaries and players by country

SELECT  c.name   , COUNT(p.id) as count_of_players , SUM(p.salary) AS total_sum_of_salaries
FROM countries as c 
LEFT JOIN towns AS t ON c.id = t.country_id 
LEFT JOIN stadiums AS s ON  s.town_id = t.id 
LEFT JOIN teams AS tm ON tm.stadium_id = s.id
LEFT JOIN players as p ON p.team_id = tm.id
GROUP BY c.name
ORDER BY count_of_players DESC , c.name asc ;


#10. Find all players that play on stadium

DELIMITER $$
CREATE FUNCTION udf_stadium_players_count (stadium_name VARCHAR(30)) 
RETURNS INTEGER
deterministic
BEGIN 
RETURN ( SELECT COUNT(*) FROM players as p 
RIGHT JOIN skills_data as sd ON p.skills_data_id = sd.id 
RIGHT JOIN teams  as te on p.team_id = te.id 
RIGHT JOIN stadiums as s ON te.stadium_id = s.id 
RIGHT JOIN towns as t ON s.town_id = t.id 
WHERE s.name like stadium_name);
END 
$$
DELIMITER ;

#11. Find good playmaker by teams




DELIMITER $$
CREATE PROCEDURE udp_find_playmaker(min_dribble_points INT , team_name VARCHAR(45)  )
BEGIN 
SELECT CONCAT(first_name , " " , last_name ) as full_name , age , salary , dribbling , speed , t.name as team_name
FROM players as p JOIN skills_data as sd ON p.skills_data_id  = sd.id right JOIN teams as t ON p.team_id = t.id 
WHERE t.name = team_name AND sd.dribbling > min_dribble_points AND speed > ( SELECT AVG(speed) FROM skills_data )
ORDER BY sd.speed DESC
LIMIT 1 ;
END
$$
DELIMITER ;


CALL udp_find_playmaker(20, 'Skyble');