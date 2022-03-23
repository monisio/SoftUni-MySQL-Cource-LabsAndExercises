USE `gringotts`;

# 1. Records' Count
SELECT COUNT(id) AS "Count"
FROM wizzard_deposits;

# 2. Longest Magic Wand
SELECT MAX(magic_wand_size) AS "Longest Wand"
FROM  wizzard_deposits;

# 3. Longest Magic Wand Per Deposit Groups
SELECT deposit_group , MAX(magic_wand_size) AS 'Max wand size'
FROM wizzard_deposits
GROUP BY deposit_group
ORDER BY `Max wand size`, deposit_group;

# 4. Smallest Deposit Group Per Magic Wand Size*
SELECT deposit_group
FROM wizzard_deposits
GROUP BY deposit_group
ORDER BY MIN(magic_wand_size)
LIMIT 1;


# 5. Deposits Sum
SELECT deposit_group , SUM(deposit_amount) AS 'total_sum' 
FROM wizzard_deposits
GROUP BY deposit_group
ORDER BY `total_sum`;


# 6. Deposits Sum for Ollivander Family
SELECT deposit_group , SUM(deposit_amount) AS 'total_sum' 
FROM wizzard_deposits
WHERE magic_wand_creator = "Ollivander family"
GROUP BY deposit_group
ORDER BY deposit_group;

# 7. Deposits Filter
SELECT deposit_group , SUM(deposit_amount) AS 'total_sum' 
FROM wizzard_deposits
WHERE magic_wand_creator = "Ollivander family"
GROUP BY deposit_group
HAVING `total_sum`< 150000
ORDER BY `total_sum` DESC;

# 8. Deposit Charge
SELECT deposit_group , magic_wand_creator , MIN(deposit_charge) AS "minimum_charge"
FROM wizzard_deposits
GROUP BY deposit_group , magic_wand_creator
ORDER BY magic_wand_creator , deposit_group;

# 9. Age Groups
SELECT 
(CASE 
 WHEN age BETWEEN  0 AND 10 THEN "[0-10]"
 WHEN age BETWEEN  11 AND 20 THEN "[11-20]"
 WHEN age BETWEEN  21 AND 30 THEN "[21-30]"
 WHEN age BETWEEN  31 AND 40 THEN "[31-40]"
 WHEN age BETWEEN  41 AND 50 THEN "[41-50]"
 WHEN age BETWEEN  51 AND 60 THEN "[51-60]"
 WHEN age >60 THEN  "[61+]"
 END ) AS "age group", COUNT(*) AS "Persons count"
 FROM wizzard_deposits 
 GROUP BY `age group`
 ORDER BY `age group`;
 
 
 # 10. First Letter
 SELECT LEFT(first_name ,1) AS "First Letter"
 FROM wizzard_deposits
 WHERE deposit_group LIKE "Troll chest"
 GROUP BY `First Letter`
 ORDER BY `First Letter`;


# 11. Average Interest 
SELECT deposit_group , is_deposit_expired , AVG(deposit_interest) AS "Average Interest"
FROM wizzard_deposits
WHERE `deposit_start_date` > '1985-01-01'
GROUP BY deposit_group,is_deposit_expired
ORDER BY deposit_group DESC, is_deposit_expired;

# 12.  Employees Minimum Salaries
SELECT department_id , MIN(salary) 
FROM employees
WHERE department_id IN (2,5,7) AND  hire_date > "2000-01-01"
GROUP BY department_id
ORDER BY department_id ;

# 13. Employees Average Salaries
SELECT department_id , AVG(
CASE 
  WHEN department_id = 1 THEN salary +5000
  ELSE salary
END) AS "average_salary" 
FROM employees
WHERE salary > 30000 AND manager_id != 42
GROUP BY department_id
ORDER BY department_id ;

# 14. Employees Maximum Salaries
SELECT department_id , MAX(salary) AS "max_salary"
FROM employees
GROUP BY department_id
HAVING `max_salary` NOT BETWEEN 30000 AND 70000
ORDER BY department_id ;


# 15. Employees Count Salaries
SELECT COUNT(*) AS ""
FROM  employees
WHERE manager_id IS NULL;

# 16. 3rd Highest Salary*
SELECT e.`department_id`, 
( SELECT DISTINCT e2.`salary` FROM `employees` as e2
       WHERE e2.`department_id`= e.`department_id`
       ORDER BY e2.`salary` DESC
       LIMIT 2,1) AS 'ths'
 FROM `employees` AS e
 GROUP BY e.`department_id`
 HAVING  `ths` IS NOT NULL
 ORDER BY e.department_id;
 
 # 17. Salary Challenge**
 SELECT first_name , last_name, e.department_id 
 FROM employees AS e 
 WHERE salary > (SELECT  AVG(e2.salary)
				FROM employees AS e2
                WHERE e.department_id = e2.department_id)
 ORDER BY e.department_id , employee_id
 LIMIT 10 ;
 
 # 18. Departments Total Salaries
SELECT department_id , SUM(salary)
FROM employees
GROUP BY department_id
ORDER BY department_id;
 