CREATE SCHEMA IF NOT EXISTS stc;

USE stc;

CREATE TABLE addresses(
id int primary key AUTO_INCREMENT,
`name` varchar(100) not null
);

CREATE TABLE clients(
id int primary key auto_increment,
full_name varchar(50) not null,
phone_number varchar(20) not null
);

CREATE TABLE drivers(
id int primary key AUTO_INCREMENT,
first_name varchar(30) not null,
last_name varchar(30) not null,
age int not null,
rating FLOAT DEFAULT 5.5
);

CREATE TABLE categories(
id int PRIMARY key	AUTO_INCREMENT,
`name` varchar(10) not null
);

CREATE TABLE cars(
id INT primary key auto_increment, 
make varchar(20) not null,
model varchar(20),
`year` int not null DEFAULT 0,
mileage int DEFAULT 0 ,
`condition` CHAR(1) not null,
category_id int not null ,
CONSTRAINT fk_cars_category
FOREIGN KEY (category_id)
REFERENCES categories(id)  
);

CREATE TABLE courses(
id int primary key auto_increment ,
from_address_id int not null,
`start` DATETIME not null,
bill DECIMAL(10,2) DEFAULT 10,
car_id int not null, 
client_id int not null,
CONSTRAINT fk_courses_adresses
FOREIGN KEY (from_address_id)
REFERENCES addresses(id), 
CONSTRAINT fk_courses_cars 
FOREIGN KEY (car_id)
REFERENCES cars(id),
CONSTRAINT fk_cources_clients
FOREIGN KEY (client_id)
REFERENCES clients(id)
);

CREATE TABLE cars_drivers(
car_id int not null,
driver_id int not null,
CONSTRAINT fk_car_id
FOREIGN KEY (car_id)
REFERENCES cars(id),
CONSTRAINT fk_driver_id 
FOREIGN KEY (driver_id)
REFERENCES drivers(id),
CONSTRAINT pk_cars_drivers
PRIMARY KEY (car_id , driver_id)
);

#2. Insert
insert into clients(full_name , phone_number) 
SELECT concat(first_name, " " , last_name) as full_name  , concat("(088) 9999", (id*2) ) as phone_number
from drivers where id between 10 AND 20;


#3. Update
UPDATE cars 
SET `condition` = 'C'
 Where mileage is null or mileage>=800000 
 and `year` <= 2010  
 and make NOT LIKE 'Mercedes-Benz';
 
 
#4. Delete 
DELETE c from clients as c LEFT JOIN courses  as cour on c.id = client_id
WHERE cour.client_id is NULL and char_length(c.full_name)>3;

#5. Cars
SELECT make , model , `condition` from cars order by id;

#6. Drivers and Cars
SELECT first_name , last_name , make , model , mileage 
FROM drivers as d 
join cars_drivers as cd ON d.id = driver_id 
join cars as c ON  car_id = c.id
WHERE mileage is not null 
ORDER BY  mileage DESC , first_name asc;


#7.	Number of courses for each car
SELECT c.id , make , mileage , (select count(*) from courses where car_id = c.id ) as count , round(avg(bill),2) as average_bill
FROM cars as c left join courses cr on c.id = car_id
GROUP BY c.id having count !=2
ORDER BY count DESC , c.id 
;  

#8.	Regular clients
SELECT full_name , count(*)  as count_of_cars , SUM(bill) total_sum 
FROM clients as cl left join courses as cr on cl.id = cr.client_id  join cars as c ON car_id = c.id 
GROUP BY full_name HAVING count_of_cars >1  and full_name like '_a%'
ORDER BY full_name;

#9.	Full information of courses

SELECT a.name ,  (CASE when hour(cu.start) between 6 and 20 then 'Day' else  'Night'
end )as day_time , bill , cl.full_name , c.make , c.model , cat.name
FROM courses  as cu 
join clients as cl on cu.client_id = cl.id 
join cars as c on cu.car_id = c.id
join categories as cat on c.category_id = cat.id
join addresses as a on cu.from_address_id = a.id
order by cu.id;  

#10. Find all courses by client’s phone number

DELIMITER $$
CREATE FUNCTION `udf_courses_by_client` (phone_num VARCHAR (20))
RETURNS INTEGER
DETERMINISTIC
BEGIN
RETURN (SELECT count(*) FROM courses join  clients as cl on client_id = cl.id where cl.phone_number like phone_num);
END
$$
DELIMITER ;
 
 SELECT udf_courses_by_client ('(803) 6386812') as `count`; 
 SELECT udf_courses_by_client ('(831) 1391236') as `count`;
 SELECT udf_courses_by_client ('(704) 2502909') as `count`;
 
 #11. Full info for address
 DELIMITER $$
 CREATE PROCEDURE `udp_courses_by_address` (address_name VARCHAR(100))
BEGIN
 SELECT a.name , cl.full_name ,(CASE when cu.bill < 20 then 'Low' when cu.bill between 21 and 30 then 'Medium' else 'High' END ) as level_of_bill ,
 c.make , c.condition , cat.name 
 FROM courses as cu 
 join addresses as a on a.id = cu.from_address_id
 join clients as cl on cu.client_id = cl.id 
 join cars as c on cu.car_id = c.id 
 join categories as cat on c.category_id = cat.id
 where a.name like address_name
 order by c.make , cl.full_name;
 
END
$$
DELIMITER ;

CALL udp_courses_by_address('700 Monterey Avenue');

