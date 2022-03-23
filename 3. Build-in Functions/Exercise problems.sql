USE soft_uni;

# 1. Find Names of All Employees by First Name
SELECT first_name , last_name FROM employees 
WHERE STRCMP(SUBSTRING(first_name , 1, 2), 'Sa'COLLATE utf8mb4_general_ci)=0
ORDER BY employee_id; 

#  2. Find Names of All Employees by Last Name
SELECT first_name, last_name FROM employees 
WHERE  LOCATE('ei',last_name COLLATE utf8mb3_general_ci) > 0 
ORDER BY employee_id; 


# 3. Find First Names of All Employees
SELECT first_name FROM employees
WHERE department_id IN (3,10) AND YEAR( hire_date) BETWEEN 1995 AND 2005;

# 4. Find All Employees Except Engineers
SELECT first_name , last_name FROM employees 
WHERE job_title NOT LIKE "%engineer%"
ORDER BY employee_id;

# 5. Find Towns with Name Length
SELECT name FROM towns
WHERE LENGTH(name) IN (5,6)
ORDER BY name;

# 6. Find Towns Starting With
SELECT * FROM towns
WHERE UPPER(SUBSTRING(name,1,1)) IN ('M','K','B','E')
ORDER BY name;
# variant 2 
SELECT * FROM towns
WHERE UPPER(LEFT(name,1)) IN ('M','K','B','E')
ORDER BY name;

# 7. Find Towns Not Starting With
SELECT * FROM towns
WHERE UPPER(LEFT(name,1)) NOT IN ('R','D','B')
ORDER BY name;


# 8. Create View Employees Hired After 2000 Year
CREATE VIEW `v_employees_hired_after_2000`  AS
SELECT first_name, last_name FROM employees
WHERE YEAR(hire_date) >2000;

# 9. Length of Last Name
SELECT first_name , last_name FROM employees 
WHERE LENGTH(last_name)=5;

# 10.Countries Holding 'A' 3 or More Times
USE geography;
SELECT country_name , iso_code FROM countries
WHERE country_name LIKE '%a%a%a%'
ORDER BY iso_code;


# 11. Mix of Peak and River Names
SELECT p.`peak_name` AS `peak name` , r.`river_name` AS `river name` , LOWER(CONCAT(p.peak_name , SUBSTRING(r.river_name ,2))) AS `mix`
FROM `peaks` AS p , `rivers` AS r
WHERE  RIGHT(p.peak_name,1) LIKE LEFT(r.river_name,1)
ORDER BY mix;

# 12. Games from 2011 and 2012 Year
USE diablo;
SELECT `name` , DATE_FORMAT(`start`, '%Y-%m-%d') AS start FROM games
WHERE YEAR(start) IN  (2011, 2012)
ORDER BY `start`, `name` DESC
LIMIT 50; 

# 13. User Email Providers
SELECT user_name , SUBSTRING(email , LOCATE('@' , email)+1 ) AS 'Email Provider'
FROM users
ORDER BY `Email Provider`, user_name;

# 14. Get Users with IP Address Like Pattern
SELECT user_name , ip_address
FROM users
WHERE ip_address LIKE "___.1%.%.___"
ORDER BY user_name;

# 15. Show All Games with Duration and Part of the Day
SELECT `name` , 
(CASE 
    WHEN HOUR(`start`) BETWEEN 0 AND 11 THEN 'Morning'
    WHEN HOUR(`start`) BETWEEN 12 AND 17 THEN 'Afternoon'
    ELSE 'Evening'
END) AS 'Part of the Day' , 
(CASE 
	WHEN `duration` BETWEEN 0 and 3 THEN 'Extra Short'
	WHEN `duration` BETWEEN  4 AND 6 THEN 'Short'
	WHEN `duration` BETWEEN 7 AND 10 THEN 'Long'
    ELSE 'Extra Long'
		END ) AS 'Duration'
   FROM games;     


# 16. Orders Table
SELECT product_name, order_date ,
DATE_ADD(order_date, INTERVAL 3 DAY) AS 'pay_due',
DATE_ADD(order_date, INTERVAL 1 MONTH) AS 'delivery_due'
FROM orders;
