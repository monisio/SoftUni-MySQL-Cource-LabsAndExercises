USE camp;

# 1. Mountains and Peaks
CREATE TABLE mountains (
 `id` INT PRIMARY KEY AUTO_INCREMENT,
 `name` VARCHAR(30) NOT NULL 
);


CREATE TABLE peaks(
 id INT PRIMARY KEY AUTO_INCREMENT,
  `name` VARCHAR(30) NOT NULL ,
  mountain_id INT,
  CONSTRAINT  `fk_peaks_mountain`
  FOREIGN KEY(mountain_id)
  REFERENCES mountains(id)
);

# 2. Trip Organization
SELECT c.id AS driver_id , v.vehicle_type , CONCAT_WS(" ", first_name , last_name) AS 'Full Name'
FROM campers AS c
JOIN vehicles AS v  ON c.id = driver_id;


# 3.  SoftUni Hiking
SELECT starting_point , end_point , c.id AS 'leader_id' , CONCAT_WS(" ", c.first_name , c.last_name) AS 'leader_name'
FROM routes
JOIN campers AS c ON  leader_id = c.id;

# 4. Delete Mountains
DROP TABLE mountains;
DROP TABLE peaks;

CREATE TABLE mountains (
 `id` INT PRIMARY KEY AUTO_INCREMENT,
 `name` VARCHAR(30) NOT NULL 
);


CREATE TABLE peaks(
 id INT PRIMARY KEY AUTO_INCREMENT,
  `name` VARCHAR(30) NOT NULL ,
  mountain_id INT,
  CONSTRAINT  `fk_peaks_mountain`
  FOREIGN KEY(mountain_id)
  REFERENCES mountains(id)
  ON DELETE CASCADE 
);



# 5. Project Management DB*
CREATE TABLE `employees`(
id INT(11) PRIMARY KEY AUTO_INCREMENT,
first_name VARCHAR(30) NOT NULL,
last_name VARCHAR(30) NOT NULL,
project_id INT(11) 
);


CREATE TABLE `clients`(
id INT(11) PRIMARY KEY AUTO_INCREMENT,
client_name VARCHAR(100)
);

CREATE TABLE `projects`(
id INT PRIMARY KEY AUTO_INCREMENT,
client_id INT(11),
project_lead INT(11),
CONSTRAINT `fk_prjects_employees`
FOREIGN KEY (project_lead)
REFERENCES employees(id),
CONSTRAINT `fk_projects_clients`
FOREIGN KEY (client_id)
REFERENCES clients(id)
);

ALTER TABLE employees
ADD CONSTRAINT `fk_project_id`
FOREIGN KEY (project_id)
REFERENCES projects(id);

