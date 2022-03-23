CREATE TABLE `users` (
`id` INT UNSIGNED  PRIMARY KEY AUTO_INCREMENT,
`username` VARCHAR(30) UNIQUE NOT NULL, 
`password` VARCHAR(26) NOT NULL ,
`profile_picture` BLOB ,
`last_login_time` DATETIME, 
`is_deleted` CHAR(1));


INSERT INTO `users` (`username`,`password`, `profile_picture`, `last_login_time`,`is_deleted`)
VALUES
('kiriku', '12345', 'odkojaojdow','9999-12-31 23:59:59','1' ),
('ki', '12345', 'odkojaojdow','9999-12-31 23:59:59','0' ),
('iku', '12345', 'odkojaojdow','9999-12-31 23:59:59','0' ),
('k', '12345', 'odkojaojdow','9999-12-31 23:59:59','0' ),
('kiku', '12345', 'odkojaojdow','9999-12-31 23:59:59','1' );
