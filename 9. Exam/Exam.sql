CREATE SCHEMA IF NOt EXISTS online_store;

use online_store;

create table brands(
id int PRIMARY KEY AUTO_INCREMENT,
`name` varchar(40) not null unique 
);

create table categories(
id int PRIMARY KEY AUTO_INCREMENT,
`name` varchar(40) not null unique 
);

create table reviews(
id int PRIMARY KEY AUTO_INCREMENT,
content TEXT ,
rating decimal(10,2) not null,
picture_url varchar(80) not null,
published_at datetime not null
);

create table products(
id int PRIMARY KEY AUTO_INCREMENT,
`name` varchar(40) not null, 
price decimal(19,2) not null,
quantity_in_stock int ,
`description` text,
brand_id int not null,
category_id int not null, 
review_id int,
CONSTRAINT fk_products_brand 
FOREIGN KEY (brand_id)
REFERENCES brands(id),
CONSTRAINT fk_products_category
FOREIGN KEY (category_id)
REFERENCES categories(id),
CONSTRAINT fk_products_reviews
FOREIGN KEY (review_id)
REFERENCES reviews(id)
);

create table customers(
id int primary key AUTO_INCREMENT,
first_name varchar(20) not null,
last_name varchar(20) not null,
phone varchar(30) not null unique, 
address varchar(60) not null, 
discount_card bit(1) default 0
);

create table orders(
id int PRIMARY key AUTO_INCREMENT, 
order_datetime datetime not null, 
customer_id int not null , 
CONSTRAINT fk_orders_customer
FOREIGN KEY (customer_id)
REFERENCES customers(id)
);

create table orders_products(
order_id int , 
product_id int ,
CONSTRAINT fk_op_order
FOREIGN KEY (order_id)
REFERENCES orders(id),
CONSTRAINT fk_op_product
FOREIGN KEY (product_id)
REFERENCES products(id)
);


#2. Insert 
INSERT INTO reviews(content ,rating ,picture_url , published_at  )
 SELECT SUBSTRING(p.description, 1, 15 ) ,(p.price / 8) ,reverse(p.name) , STR_TO_DATE('2010-10-10', '%Y-%m-%d') 
 FROM products as p
 WHERE p.id >= 5
 ;
 
 
 #3. Update 
 UPDATE products 
 set quantity_in_stock = quantity_in_stock - 5
 where quantity_in_stock >= 60 ;


#4. Delete

DELETE c FROM customers as c LEFT JOIN orders as o on c.id= customer_id
where o.id is null; 

#5. Categories 
SELECT id , name 
FROM categories 
ORDER by name DESC;


#6. Quantity 
SELECT p.id , b.id as brand_id , p.name , p.quantity_in_stock 
from products as p join brands as b on p.brand_id = b.id 
where p.price> 1000 and p.quantity_in_stock < 30
order by p.quantity_in_stock asc , p.id 
;

#7. Review 
SELECT * 
FROM reviews 
where content like 'My%' and char_length(content)> 61
order by rating desc
;

#8. First customers 
SELECT CONCAT(c.first_name , " ", c.last_name ) as full_name , c.address , o.order_datetime
FROM customers as c join orders as o on c.id = o.customer_id 
where YEAR(order_datetime) <= 2018
ORDER BY full_name desc
;


#9. Best categories 
SELECT COUNT(p.id) as items_count , ct.name , SUM(p.quantity_in_stock) as total_quantity
FROM categories as ct join products as p on ct.id = p.category_id
GROUP BY ct.id 
ORDER BY items_count desc, total_quantity asc
LIMIT 5 ;


#10. Extract client cards count 
DELIMITER $$
CREATE FUNCTION `udf_customer_products_count`(name VARCHAR(30))
RETURNS INTEGER
DETERMINISTIC
BEGIN

RETURN (
SELECT count(pr.product_id) 
from customers as c 
left join orders as o on c.id = o.customer_id 
left join  orders_products as pr on o.id = pr.order_id 
WHERE c.first_name = `name` );
END
$$
DELIMITER ;


SELECT c.first_name,c.last_name, udf_customer_products_count('Shirley') as `total_products` FROM customers as c
WHERE c.first_name = 'Shirley';


#11. Reduce price
DELIMITER $$
CREATE PROCEDURE `udp_reduce_price`(category_name VARCHAR(50))
BEGIN
UPDATE products as p join categories as c on p.category_id = c.id join reviews as r on p.review_id = r.id
SET p.price = p.price * 0.7
WHERE r.rating < 4 and c.name = category_name;
END
$$
DELIMITER ;

SELECT * from products ;

CALL udp_reduce_price ('Phones and tablets');