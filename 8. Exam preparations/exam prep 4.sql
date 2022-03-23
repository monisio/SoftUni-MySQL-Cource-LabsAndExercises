CREATE SCHEMA IF NOT EXISTS softuni_stores_system;

USE softuni_stores_system;


CREATE TABLE towns(
id int primary key auto_increment,
`name` varchar(20) not null unique 
);

CREATE TABLE pictures(
id int primary key auto_increment,
url varchar(100) not null, 
added_on datetime not null
);

CREATE TABLE categories(
id int primary key auto_increment,
`name` varchar(40) not null unique
);

CREATE TABLE addresses(
id int primary key auto_increment,
`name` varchar(50) not null unique,
town_id int not null,
CONSTRAINT fk_addresses_towns
FOREIGN KEY (town_id)
REFERENCES towns(id)
);

CREATE TABLE stores(
id int primary key auto_increment,
`name` varchar(20) not null unique,
rating FLOAT not null, 
has_parking TINYINT(1) default 0,
address_id int not null,
CONSTRAINT fk_stores_addresses
FOREIGN KEY (address_id)
REFERENCES addresses(id) 
);

CREATE TABLE employees(
id int primary key auto_increment,
first_name varchar(15) not null ,
middle_name CHAR(1) ,
last_name varchar(20) not null, 
salary decimal(19, 2) default 0,
hire_date date not null,
manager_id int ,
store_id int not null,
CONSTRAINT fk_employee_manager
FOREIGN KEY (manager_id)
REFERENCES employees(id),
CONSTRAINT fk_employee_stores 
FOREIGN KEY (store_id)
REFERENCES stores(id)
);

CREATE TABLE products(
id int primary key auto_increment,
`name` varchar(40) not null unique, 
best_before date, 
price decimal(10,2) not null, 
`description` text,
category_id int not null,
picture_id int not null, 
CONSTRAINT fk_products_category
FOREIGN KEY (category_id)
REFERENCES categories(id),
CONSTRAINT fk_products_pictures
FOREIGN KEY (picture_id)
REFERENCES pictures(id)

);


CREATE TABLE products_stores(
 product_id int not null ,
 store_id int not null,
 CONSTRAINT fk_products_stores_product
 FOREIGN KEY (product_id)
 REFERENCES products(id),
 CONSTRAINT fk_product_stores_store
 FOREIGN KEY (store_id)
 REFERENCES stores(id),
 CONSTRAINT pk_composite_key
 PRIMARY KEY (product_id , store_id)
);


#2.	Insert
INSERT INTO products_stores(product_id , store_id)
SELECT p.id  , 1 from products as p left join products_stores on p.id = product_id 
WHERE product_id is NULL;

#3.	Update
UPDATE employees as e JOIN stores as s on store_id = s.id 
SET manager_id = 3 , salary= salary - 500
where s.name not in ('Cardguard','Veribet') and YEAR(hire_date) > 2003
;

#4.	Delete
DELETE e FROM  employees as e 
WHERE manager_id is not null and salary >= 6000;


#5.	Employees 
SELECT first_name , middle_name , last_name , salary , hire_date 
FROM employees 
ORDER BY hire_date DESC;

 
 #6. Products with old pictures
 SELECT p.name , p.price , best_before , CONCAT(SUBSTRING(p.description ,1 , 10), "...") as short_description , pic.url 
 FROM products as p join pictures as pic ON p.picture_id = pic.id
 WHERE char_length(p.description)> 100 and YEAR(pic.added_on) < 2019 and price > 20
 ORDER BY price DESC ;
 
 
 #7. Counts of products in stores and their average
 SELECT s.name , (SELECT count(*) FROM products_stores psd right join products as pd on pd.id = psd.product_id
 WHERE store_id = s.id) as count, ROUND(avg(p.price), 2)  as avg_price
 FROM stores as s 
 left join products_stores as ps on s.id = ps.store_id 
 left join products as p on ps.product_id = p.id
 GROUP BY s.name
 ORDER BY count DESC, avg_price DESC, s.id ;
 
 #8. Specific employee
 SELECT CONCAT_WS(" ",e.first_name, last_name) as full_name  , s.name , a.name as address, e.salary
 FROM employees as e 
 join stores as s on e.store_id = s.id
 join addresses as a on s.address_id = a.id
 WHERE e.salary < 4000  and a.name like '%5%' and char_length(s.name) >8 and e.last_name like '%n';
 

#9.	Find all information of stores
SELECT reverse(s.name) as reversed_name , concat(UPPER(t.name),'-' , a.name) as full_address , count(*) as count
FROM stores as s 
left join  addresses as a on s.address_id = a.id
join towns as t on a.town_id = t.id
right join employees as e on s.id = e.store_id
GROUP by s.name having count>=1
order by full_address ASC; 

#10. Find full name of top paid employee by store name

DELIMITER $$
CREATE FUNCTION `udf_top_paid_employee_by_store` (store_name VARCHAR(50))
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN

RETURN (SELECT CONCAT_WS(" ",first_name , CONCAT(middle_name,'.') ,last_name ,'works in store for' ,TIMESTAMPDIFF(YEAR ,hire_date , STR_TO_DATE('2020-10-18', '%Y-%m-%d')),'years'  )
FROM stores as s join employees as e  on e.store_id = s.id  
WHERE s.name like store_name
ORDER BY salary DESC
LIMIT 1  )  ;
END
$$
DELIMITER ;

SELECT udf_top_paid_employee_by_store('Stronghold') as 'full_info';

#11. Update product price by address
DELIMITER $$
CREATE PROCEDURE `udp_update_product_price`(address_name VARCHAR(50))
BEGIN
UPDATE products as p  
join products_stores as ps on p.id = ps.product_id  
join stores as s  on ps.store_id = s.id 
join addresses as a on s.address_id = a.id
SET p.price = (CASE when address_name LIKE '0%' THEN  p.price + 100 else price + 200 end)
WHERE a.name like address_name;
END
$$
DELIMITER ;

