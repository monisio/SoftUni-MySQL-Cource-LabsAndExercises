
# 1. Managers
SELECT e.employee_id , CONCAT_WS(" ",e.first_name, e.last_name ) full_name , d.department_id , d.name
FROM employees e JOIN departments d ON e.employee_id = d.manager_id
ORDER BY employee_id LIMIT 5;

# 2. Towns and addresses 
SELECT t.town_id , t.name , a.address_text
FROM towns t JOIN addresses a ON a.town_id = t.town_id
WHERE t.name IN ('San Francisco', 'Sofia' , 'Carnation')
ORDER BY t.town_id ,a.address_id;


# 3. Employees Without Managers
SELECT employee_id, first_name, last_name, department_id, salary 
FROM employees WHERE manager_id IS NULL ;


# 4. Higher Salary
SELECT COUNT(*) AS employee_count
FROM employees WHERE salary > (SELECT AVG(salary) FROM employees);
