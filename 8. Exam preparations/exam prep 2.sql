CREATE SCHEMA IF NOT EXISTS instd;

USE instd;

#1. Table design 

create table users(
  id int primary key auto_increment,
  username varchar(30) not null unique ,
  `password` varchar(30) not null,
  email  varchar(50) not null,
  gender CHAR(1) not null,
  age int not null, 
  job_title varchar(40) not null,
  ip varchar(30) not null
);

create table photos(
id int primary key  auto_increment,
`description` text not null,
`date` DATETIME not null,
views int not null default 0  
);

create table addresses(
 id int primary key auto_increment,
 address varchar(30) not null, 
 town varchar(30) not null,
 country varchar(30) not null,
 user_id int not null,
 constraint fk_addresses_users
 foreign key (user_id)
 references users(id)
);

create table comments(
id int primary key auto_increment,
`comment` varchar(255) not null,
`date` datetime not null, 
photo_id int not null,
constraint fk_comments_photos
foreign key (photo_id)
references photos(id)
);

create table users_photos(
user_id int not null,
photo_id int not null,
constraint fk_user
foreign key (user_id)
references users(id),
constraint fk_photo 
foreign key (photo_id)
references photos(id) 
);


create table likes(
id int primary key auto_increment,
photo_id int ,
user_id int,
constraint fk_likes_photos
foreign key (photo_id)
references photos(id),
constraint fk_likes_users
foreign key (user_id)
references users(id)
);


#2. Insert 

insert into addresses(address , town , country , user_id )
(SELECT username , `password` , ip , age from users where  gender = 'M'); 


#3. Update
update addresses 
set country = 
case 
when country like 'B%' then  'Blocked'
when country like 'T%' then   'Test'
when country like 'P%' then  'In Progress'
else country
END ;

#4. Delete
delete from addresses where MOD(id, 3) = 0;


#5. Users
select username , gender , age from users order by age desc, username asc;

#6. Extract 5 Most Commented Photos
SELECT p.id , p.date as date_and_time , p.description , (SELECT count(*) from comments where p.id = photo_id) commentsCount 
FROM photos as p 
ORDER BY commentsCount desc , id asc
LIMIT 5;

#07. Lucky Users
SELECT CONCAT(u.id , " " ,  u.username ) as id_username  , u.email 
FROM users as u join users_photos on u.id = user_id join photos as p on photo_id =p.id 
WHERE u.id = p.id
order by u.id asc;


#8.	Count Likes and Comments
SELECT p.id as photo_id, ( SELECT count(*) from likes where p.id = photo_id ) as likes_count , (select count(*) from comments where p.id = photo_id) as comments_count
FROM photos as p
order by likes_count desc, comments_count desc , photo_id asc
;

#09. The Photo on the Tenth Day of the Month
SELECT CONCAT(substr(p.description, 1, 30), "...")  as summary , p.date
FROM photos as p
WHERE DAY(p.date) = 10
ORDER BY p.date DESC;



#10. Get User’s Photos Count

SELECT count(*) 
FROM  users as u join users_photos as up on u.id = up.user_id join photos as p on up.photo_id = p.id
WHERE username LIKE 'ssantryd';

DELIMITER $$
CREATE FUNCTION `udf_users_photos_count` (username VARCHAR(30))
RETURNS INTEGER
deterministic
BEGIN
RETURN (SELECT count(*) 
FROM  users as u join users_photos as up on u.id = up.user_id join photos as p on up.photo_id = p.id
WHERE u.username LIKE username);
END
$$
DELIMITER ;

SELECT udf_users_photos_count('ssantryd') AS photosCount;


#11. Increase User Age
DELIMITER $$
CREATE PROCEDURE `udp_modify_user`(address VARCHAR(30), town VARCHAR(30) )
BEGIN
UPDATE users as u join addresses as a on u.id = a.user_id
SET u.age = u.age+10 
WHERE a.address LIKE address and a.town like town;
END$$
DELIMITER ;


CALL udp_modify_user ('97 Valley Edge Parkway', 'Divinópolis');
SELECT u.username, u.email,u.gender,u.age,u.job_title FROM users AS u
WHERE u.username = 'eblagden21';
