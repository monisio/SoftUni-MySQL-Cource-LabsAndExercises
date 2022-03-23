
# 1. Employee Address
SELECT e.employee_id , e.job_title , e.address_id , address_text
FROM employees AS e JOIN addresses AS a ON e.address_id = a.address_id
ORDER BY address_id LIMIT 5;

# 2. Addresses with Towns
SELECT e.first_name , e.last_name , t.name , a.address_text
FROM employees AS e JOIN addresses as a  ON  e.address_id = a.address_id JOIN towns AS t ON a.town_id = t.town_id 
ORDER BY e.first_name , e.last_name
LIMIT 5;

# 3. Sales Employee
SELECT e.employee_id , e.first_name ,e.last_name , d.name AS department_name
FROM employees e JOIN departments d ON e.department_id = d.department_id
WHERE d.name LIKE 'Sales'
ORDER BY e.employee_id DESC;


# 4. Employee Departments
SELECT e.employee_id  , e.first_name , e.salary, d.name 
FROM employees e JOIN departments d ON e.department_id = d.department_id
WHERE e.salary>15000 
ORDER BY d.department_id DESC
LIMIT 5 ;


# 5. Employees Without Project
SELECT employee_id , first_name 
FROM employees 
WHERE employee_id NOT IN (SELECT employee_id FROM employees_projects)
ORDER BY employee_id DESC 
LIMIT 3;

# 5. variant 2 
SELECT e.employee_id , first_name 
FROM employees as e LEFT JOIN employees_projects AS ep ON e.employee_id = ep.employee_id
WHERE ep.project_id IS NULL 
ORDER BY employee_id DESC
LIMIT 5 ;

# 6. Employees Hired After
SELECT first_name , last_name , hire_date ,d.name AS dept_name
FROM employees AS e JOIN departments AS d ON d.department_id = e.department_id
WHERE d.name IN ('Sales','Finance') AND  e.hire_date > 1999-01-01 
ORDER BY hire_date;

# 7. Employees with Project
SELECT e.employee_id , e.first_name , p.name AS project_name 
FROM  employees AS e
JOIN employees_projects AS ep ON ep.employee_id = e.employee_id 
JOIN projects AS p ON ep.project_id = p.project_id
WHERE DATE(p.start_date) > '2002-08-13' AND p.end_date IS NULL
ORDER BY e.first_name , p.name 
LIMIT 5;


# 8. Employee 24
SELECT e.employee_id , e.first_name , IF(YEAR(start_date) >= 2005, NULL ,p.name ) AS project_name 
FROM employees AS e JOIN employees_projects AS ep ON e.employee_id = ep.employee_id JOIN projects AS p ON ep.project_id = p.project_id
WHERE e.employee_id = 24
ORDER BY project_name ; 


# 9. Employee Manager
SELECT e.employee_id , e.first_name , e.manager_id , (SELECT first_name FROM employees AS e2 WHERE e2.employee_id = e.manager_id ) manager_name
FROM employees AS e  
WHERE manager_id IN (3,7)
ORDER BY first_name;


# 10. Employee Summary
SELECT e.employee_id ,CONCAT( e.first_name, " " , e.last_name ) AS  employee_name , 
(SELECT CONCAT( e2.first_name ," " , e2.last_name)FROM employees AS e2 WHERE e2.employee_id = e.manager_id ) manager_name , d.name 
FROM employees AS e JOIN departments as d ON e.department_id = d.department_id
WHERE e.manager_id IS NOT NULL
ORDER BY employee_id 
LIMIT 5 ;

# 11. Min Average Salary
SELECT MIN(p.salary) as min_average_salary
FROM (SELECT AVG(salary) as salary FROM employees 
GROUP BY department_id) as p;

# 12. Highest Peaks in Bulgaria
USE geography;
SELECT c.country_code , m.mountain_range , p.peak_name , p.elevation 
FROM countries AS c 
JOIN mountains_countries AS mc ON c.country_code = mc.country_code 
JOIN mountains  AS m ON mc.mountain_id = m.id
JOIN peaks as p ON p.mountain_id = m.id
WHERE c.country_code LIKE 'BG' AND p.elevation > 2835
ORDER BY elevation DESC;

# 13. Count Mountain Ranges
SELECT c.country_code , COUNT(m.mountain_range) AS mountain_range_count
FROM countries AS c JOIN mountains_countries as mc ON c.country_code = mc.country_code  
JOIN mountains AS m ON m.id = mc.mountain_id
GROUP BY c.country_code HAVING c.country_code IN ('US', 'RU', 'BG') 
ORDER BY mountain_range_count DESC;


# 14. Countries with Rivers
SELECT c.country_name , r.river_name 
FROM countries AS c
 LEFT JOIN countries_rivers AS cr ON  c.country_code = cr.country_code 
 LEFT JOIN rivers AS r ON cr.river_id = r.id  
 JOIN continents AS cont ON c.continent_code = cont.continent_code
WHERE cont.continent_code LIKE 'AF'
ORDER BY c.country_name
LIMIT 5; 


# 15. *Continents and Currencies
SELECT d1.continent_code, d1.currency_code, d1.currency_usage FROM 
	(SELECT `c`.`continent_code`, `c`.`currency_code`,
    COUNT(`c`.`currency_code`) AS `currency_usage` FROM countries as c
	GROUP BY c.currency_code, c.continent_code HAVING currency_usage > 1) as d1
LEFT JOIN 
	(SELECT `c`.`continent_code`,`c`.`currency_code`,
    COUNT(`c`.`currency_code`) AS `currency_usage` FROM countries as c
	 GROUP BY c.currency_code, c.continent_code HAVING currency_usage > 1) as d2
ON d1.continent_code = d2.continent_code AND d2.currency_usage > d1.currency_usage
WHERE d2.currency_usage IS NULL
ORDER BY d1.continent_code, d1.currency_code;

# 16. Countries Without Any Mountains
SELECT COUNT(*) AS countries_without_mountain 
FROM  countries  as c LEFT JOIN mountains_countries AS mc ON c.country_code = mc.country_code
WHERE mc.mountain_id IS NULL ;

# 17. Highest Peak and Longest River by Country
SELECT c.country_name , peaks.height AS hightest_peak , rivers_length.max_length AS longest_river  
FROM countries as c 
LEFT JOIN  (SELECT mc.country_code, MAX(elevation) AS height FROM mountains_countries AS mc  LEFT JOIN mountains AS m ON  mc.mountain_id = m.id LEFT JOIN peaks as p ON m.id = p.mountain_id GROUP BY mc.country_code) AS peaks ON peaks.country_code = c.country_code 
LEFT JOIN (SELECT  rc.country_code , MAX(r.length) as max_length  FROM countries_rivers AS rc LEFT JOIN rivers AS r ON rc.river_id = r.id GROUP BY rc.country_code) as rivers_length ON c.country_code = rivers_length.country_code
ORDER BY hightest_peak DESC, longest_river DESC , country_name
LIMIT 5 ;