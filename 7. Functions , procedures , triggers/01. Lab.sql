USE soft_uni;

# 1. Count Employees by Town


DELIMITER //
CREATE FUNCTION ufn_count_employees_by_town(town_name VARCHAR(50))
RETURNS INT DETERMINISTIC 
BEGIN 
 RETURN	(SELECT COUNT(*) FROM employees JOIN addresses USING (address_id) JOIN towns AS t USING (town_id) WHERE t.name LIKE town_name);
 END //
 DELIMITER ;
 
 SELECT ufn_count_employees_by_town("Sofia");
 
 
 # 2. Employees Promotion
 DROP PROCEDURE usp_raise_salaries;
 DELIMITER //
 CREATE PROCEDURE usp_raise_salaries(IN department_name VARCHAR(50))
 BEGIN 
     UPDATE employees JOIN departments d USING (department_id) 
     SET salary = salary * 1.05 
     WHERE d.name = department_name;
 END//
 DELIMITER ;
 
CALL usp_raise_salaries('Finance');
SELECT first_name , salary FROM employees;



# 3. Employees Promotion by ID
DELIMITER //
CREATE PROCEDURE usp_raise_salary_by_id(IN id INT)
BEGIN
   START transaction;
   IF((SELECT COUNT(*) FROM employees WHERE employee_id = id )=1)
   THEN UPDATE employees 
        SET salary = salary *1.05
        WHERE employee_id = id ;
        COMMIT;
    ELSE ROLLBACK ;
    END IF;
END //
DELIMITER ;


# 4. Triggered
CREATE TABLE deleted_employees(
employee_id INT PRIMARY KEY AUTO_INCREMENT , 
first_name VARCHAR(50),
last_name VARCHAR(50),
middle_name VARCHAR(50), 
job_title VARCHAR(50), 
department_id INT , 
salary DECIMAL 
);

DELIMITER //
CREATE TRIGGER tr_deleted_employees
AFTER DELETE 
ON employees
FOR EACH ROW 
BEGIN
 INSERT INTO `deleted_employees`(`first_name`,`last_name`,`middle_name`,`job_title`,`department_id`,`salary`)
VALUES
(OLD.first_name,OLD.last_name ,OLD.middle_name,OLD.job_title,OLD.department_id,OLD.salary);
END //
DELIMITER ;

