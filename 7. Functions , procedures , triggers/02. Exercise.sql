
# 1. Employees with Salary Above 35000
DROP PROCEDURE IF EXISTS usp_get_employees_salary_above_35000 ;

DELIMITER //
CREATE PROCEDURE usp_get_employees_salary_above_35000()
BEGIN
   SELECT first_name , last_name 
   FROM employees 
   WHERE salary > 35000
   ORDER BY first_name , last_name ;
END //
DELIMITER ;


# 2. Employees with Salary Above Number
DROP PROCEDURE IF EXISTS usp_get_employees_salary_above;

DELIMITER //
CREATE PROCEDURE usp_get_employees_salary_above(IN input_number DECIMAL(14,4))
BEGIN
  SELECT first_name , last_name 
  FROM employees 
  WHERE salary>= input_number
  ORDER BY first_name , last_name , employee_id;
END//
DELIMITER ;


# 3. Town Names Starting With
DROP PROCEDURE IF EXISTS usp_get_towns_starting_with ;


DELIMITER //
CREATE PROCEDURE usp_get_towns_starting_with(IN input_string VARCHAR(30))
BEGIN
   SELECT name town_name FROM towns WHERE name LIKE CONCAT(input_string,'%')
   ORDER BY town_name; 
END // 
DELIMITER ;


# 4. Employees from Town
DROP PROCEDURE IF EXISTS usp_get_employees_from_town;


DELIMITER //
CREATE PROCEDURE usp_get_employees_from_town(IN town_name VARCHAR(50))
BEGIN
SELECT first_name , last_name  FROM employees JOIN addresses a USING(address_id) JOIN towns  t USING(town_id)
WHERE t.name LIKE town_name 
ORDER BY first_name , last_name , employee_id;
END//
DELIMITER ;


# 5. Salary Level Function


DELIMITER // 
CREATE FUNCTION ufn_get_salary_level(employee_salary DECIMAL(14,2))
RETURNS VARCHAR(10)
 DETERMINISTIC
 BEGIN
  RETURN   (CASE 
            WHEN  employee_salary < 30000 THEN 'Low'
			WHEN  employee_salary BETWEEN 30000 AND 50000 THEN 'Average'
            WHEN  employee_salary > 50000 THEN 'High'
            END) ;
 END //
DELIMITER ;


# 6. Employees by Salary Level

DELIMITER //
CREATE PROCEDURE usp_get_employees_by_salary_level(IN salary_level VARCHAR(10))
BEGIN 
	SELECT first_name , last_name 
    FROM employees 
    WHERE (SELECT CASE 
            WHEN  salary < 30000 THEN 'Low'
			WHEN  salary BETWEEN 30000 AND 50000 THEN 'Average'
            WHEN  salary > 50000 THEN 'High'
            END  ) LIKE salary_level
    ORDER BY first_name DESC, last_name DESC;
END //
DELIMITER ;


# 7. Define Function 
DELIMITER //
CREATE FUNCTION ufn_is_word_comprised(set_of_letters varchar(50), word varchar(50))
RETURNS INT  DETERMINISTIC
BEGIN 
   RETURN (SELECT word  REGEXP (CONCAT('^[',set_of_letters , ']+$')));
END//
DELIMITER ;


# 8. Find Full Name

DELIMITER //
CREATE PROCEDURE usp_get_holders_full_name()
BEGIN 
 SELECT CONCAT_WS(" ", first_name , last_name ) AS full_name FROM account_holders 
 ORDER BY full_name , account_holders.id;
END //
DELIMITER ; 

# 9. People with Balance Higher Than
DELIMITER //
CREATE PROCEDURE usp_get_holders_with_balance_higher_than (IN input_salary DECIMAL(19, 4) )
BEGIN 
 SELECT first_name , last_name  FROM account_holders  
 WHERE (SELECT SUM( balance ) FROM accounts  WHERE account_holders.id = account_holder_id )> input_salary
 ORDER BY account_holders.id;
END //
DELIMITER ; 


# 10. Future Value Function
 DROP FUNCTION IF EXISTS ufn_calculate_future_value;
 
DELIMITER // 
CREATE FUNCTION ufn_calculate_future_value( sum DECIMAL(20,4 ),  yearly_interest_rate DOUBLE ,  number_of_years INT )
RETURNS DECIMAL (20, 4)
deterministic
BEGIN 
    RETURN  sum*( POWER((1 + yearly_interest_rate),number_of_years)); 
END //
DELIMITER ;



# 11. Calculating Interest
DROP PROCEDURE IF EXISTS usp_calculate_future_value_for_account;

DELIMITER //
CREATE PROCEDURE usp_calculate_future_value_for_account( acc_id INT , interest_rate DECIMAL(20, 4) )
BEGIN
 SELECT a.id, ah.first_name , ah.last_name , a.balance , ufn_calculate_future_value(a.balance, interest_rate , 5)  AS balance_in_5_years
 FROM accounts AS a JOIN account_holders AS ah ON  a.account_holder_id = ah.id
 WHERE a.id = acc_id;
 END//
DELIMITER ;

# 12. Deposit Money


DELIMITER //
CREATE PROCEDURE usp_deposit_money(account_id INT, money_amount DECIMAL(20, 4))
BEGIN
   START transaction;
   IF((SELECT COUNT(*) FROM accounts WHERE account_id = id )=1 AND money_amount >0 )
   THEN UPDATE accounts 
        SET balance = balance + money_amount
        WHERE account_id = id  ;
        COMMIT;
    ELSE ROLLBACK ;
    END IF;
END //
DELIMITER ;


# 13. Withdraw Money

DELIMITER // 
CREATE PROCEDURE usp_withdraw_money(account_id INT , money_amount DECIMAL(20,4 )) 
BEGIN 
   START TRANSACTION ;
	 IF((SELECT COUNT(*) FROM accounts WHERE account_id = id )=1 
     AND (SELECT balance FROM accounts WHERE account_id = id) - money_amount > 0
     AND money_amount > 0)
   THEN UPDATE accounts 
        SET balance = balance - money_amount
        WHERE account_id = id  ;
        COMMIT;
    ELSE ROLLBACK ;
    END IF;
END // 
DELIMITER ; 


# 14. Money Transfer
USE bank;

DELIMITER $$
CREATE PROCEDURE usp_transfer_money(from_account_id INT, to_account_id INT, amount DECIMAL(20, 4))
BEGIN
	START TRANSACTION;
		CASE WHEN 
			(SELECT a.id FROM accounts as a WHERE a.id = from_account_id) IS NULL
            OR (SELECT a.id FROM accounts as a WHERE a.id = to_account_id) IS NULL
            OR from_account_id = to_account_id
            OR amount < 0
            OR (SELECT a.balance FROM accounts as a WHERE a.id = from_account_id) < amount
		THEN ROLLBACK;
	ELSE 
		UPDATE accounts a
		SET a.balance = a.balance - amount
        WHERE a.id = from_account_id;
        
        UPDATE accounts a
		SET a.balance = a.balance + amount
        WHERE a.id = to_account_id;
	END CASE;
	COMMIT;
END $$

CALL usp_transfer_money(1, 2, 10);

SELECT a.id, h.id, a.balance
FROM account_holders AS h
JOIN accounts AS a ON a.account_holder_id = h.id
WHERE a.id IN (1, 2);