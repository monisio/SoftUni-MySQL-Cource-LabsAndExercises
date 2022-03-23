


# 1. One-To-One Relationship

CREATE TABLE passports(
passport_id INT PRIMARY KEY , 
passport_number VARCHAR(30) UNIQUE
);

CREATE TABLE people(
  person_id INT ,
  first_name VARCHAR(20) NOT NULL,
  salary DECIMAL(10,2) NOT NULL , 
  passport_id INT UNIQUE
);


INSERT INTO `people` (first_name, salary, passport_id) 
VALUES 
('Roberto',43300.00,102),
('Tom',56100.00,103),
('Yana',60200.00,101)
;

INSERT INTO passports (passport_id ,passport_number)
VALUES 
(101 ,'N34FG21B'),
(102 ,'K65LO4R7'),
(103, 'ZE657QP2');

ALTER TABLE people
CHANGE person_id  person_id INT PRIMARY KEY AUTO_INCREMENT;

ALTER TABLE people
ADD CONSTRAINT `fk_pasportId_passports`
  FOREIGN KEY (passport_id)
  REFERENCES passports(passport_id);




# 2. One-To-Many Relationship


CREATE TABLE manufacturers(
manufacturer_id INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(20) NOT NULL UNIQUE,
established_on DATE 
);

CREATE TABLE models(
model_id INT PRIMARY KEY NOT NULL , 
`name` VARCHAR(30) NOT NULL,
manufacturer_id INT,
CONSTRAINT `fk_models_manufacturer_id`
FOREIGN KEY (manufacturer_id)
REFERENCES manufacturers(manufacturer_id)
);


INSERT INTO manufacturers(name, established_on )
VALUES 
("BMW", "1916-03-01"),
("Tesla", "2003-01-01"),
("Lada", "1966-05-01");


INSERT INTO models (model_id,name, manufacturer_id)
VALUES 
(101,"X1", 1),
(102,"i6", 1),
(103,"Model S", 2),
(104,"Model X",2),
(105,"Model 3", 2),
(106,"Nova", 3);

# 3. Many-To-Many Relationship

CREATE TABLE students(
student_id INT AUTO_INCREMENT PRIMARY KEY, 
name VARCHAR(30)
);

CREATE TABLE exams (
exam_id INT PRIMARY KEY , 
name VARCHAR(30)
);


CREATE TABLE students_exams (
student_id INT , 
exam_id INT, 
CONSTRAINT `fk_student_id`
FOREIGN KEY (student_id)
REFERENCES students(student_id),
CONSTRAINT `fk_exam_id`
FOREIGN KEY (exam_id)
REFERENCES exams(exam_id),
PRIMARY KEY (student_id, exam_id)
);

INSERT INTO students(name) VALUES
('Mila'),('Toni'),('Ron');

INSERT INTO exams(exam_id,name) VALUES
(101,'Spring MVC'), (102, 'Neo4j'),(103,'Oracle 11g');

INSERT INTO students_exams(student_id , exam_id) VALUES
(1, 101),(1,102),(2, 101), (3,103), (2, 102), (2,103);


# 4. Self-Referencing

CREATE TABLE teachers(
teacher_id INT PRIMARY KEY , 
name VARCHAR(20) , 
manager_id  INT 
);

INSERT INTO teachers(teacher_id, name , manager_id) VALUES
(101, 'John', NULL),
(102 , 'Maya', 106),
(103 ,'Silvia', 106),
(104 ,'Ted', 105),
(105 ,'Mark', 101),
(106 ,'Greta', 101);



ALTER TABLE teachers
ADD CONSTRAINT `fk_manager_id_teacher_id`
FOREIGN  KEY (manager_id)
REFERENCES teachers(teacher_id);



# 5. Online Store Database



CREATE SCHEMA `online_store`;
USE online_store;

CREATE TABLE cities(
city_id INT(11) PRIMARY KEY auto_increment,
name VARCHAR(50) 
);


CREATE TABLE customers(
customer_id INT PRIMARY KEY AUTO_INCREMENT , 
name  VARCHAR(50), 
birthday DATE, 
city_id INT(11),
CONSTRAINT `fk_city_id`
FOREIGN KEY (city_id) 
REFERENCES cities(city_id)
);


CREATE TABLE item_types(
item_type_id INT(11) PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(50) 
);


CREATE TABLE items(
item_id INT(11) PRIMARY KEY AUTO_INCREMENT, 
name VARCHAR(50), 
item_type_id INT(11),
CONSTRAINT `fk_items_items_types_id`
FOREIGN KEY (item_type_id)
REFERENCES item_types(item_type_id)
);


CREATE TABLE orders(
order_id INT(11) PRIMARY KEY AUTO_INCREMENT,
customer_id INT(11),
CONSTRAINT `fk_orders_customer_id`
FOREIGN KEY (customer_id)
REFERENCES customers(customer_id)
 );


CREATE TABLE order_items(
order_id INT(11) ,
item_id INT(11),
CONSTRAINT `fk_order_id`
FOREIGN KEY (order_id)
REFERENCES orders(order_id),
CONSTRAINT `fk_items_id`
FOREIGN KEY (item_id)
REFERENCES items(item_id),
PRIMARY KEY (order_id , item_id)

);


# 6. University Database


CREATE SCHEMA university_database;
USE university_database;

CREATE TABLE payments(
payment_id INT PRIMARY KEY AUTO_INCREMENT, 
payment_date DATE, 
payment_amount DECIMAL (8,2),
student_id INT 
);

CREATE TABLE students (
student_id INT PRIMARY KEY AUTO_INCREMENT, 
student_number VARCHAR(12), 
student_name VARCHAR(50) , 
major_id INT
);


CREATE TABLE majors (
major_id INT PRIMARY KEY AUTO_INCREMENT, 
name VARCHAR(50)
);

CREATE TABLE agenda (
student_id INT, 
subject_id INT,
CONSTRAINT `pk_student_subject`
PRIMARY KEY (student_id , subject_id)
);


CREATE TABLE subjects(
subject_id INT PRIMARY KEY AUTO_INCREMENT,
subject_name VARCHAR(50)
);


ALTER TABLE payments 
ADD CONSTRAINT `fk_payments_students`
FOREIGN KEY (student_id)
REFERENCES students(student_id);

ALTER TABLE students
ADD CONSTRAINT `fk_students_majors`
FOREIGN KEY (major_id)
REFERENCES majors(major_id);


ALTER TABLE agenda 
ADD CONSTRAINT `fk_agenda_student_id`
FOREIGN KEY (student_id)
REFERENCES students(student_id),
ADD CONSTRAINT `fk_agenda_subject_id`
FOREIGN KEY (subject_id)
REFERENCES subjects(subject_id);



# 9.Peaks in Rila
USE geography;

SELECT m.mountain_range , peak_name,  elevation AS peak_elevation
FROM mountains AS m
JOIN peaks
ON m.id = mountain_id 
WHERE m.mountain_range LIKE 'Rila'
ORDER BY peak_elevation DESC;
