CREATE TABLE `people`(
`id` INT AUTO_INCREMENT,
`name` VARCHAR(200) NOT NULL,
`picture` MEDIUMBLOB ,
`height` DOUBLE(5,2),
`weight` DOUBLE(5,2),
`gender` ENUM('m','f') NOT NULL,
`birthdate` DATE NOT NULL,
`biography` LONGTEXT,
PRIMARY KEY (`id`)
);

INSERT INTO `people` (`name`, `picture`,`height`,`weight`, `gender`, `birthdate`,`biography`)
VALUES
('kiro', 'no pic', 200.02, 130.58 , 'm', '2002/12/30' ,'drun drun'  ),
('miro', 'no pic', 200.02, 130.58 , 'm', '2002/12/30' ,'drun drun'  ),
('spiro', 'no pic', 200.02, 130.58 , 'f', '2002/12/30' ,'drun drun'  ),
('kolio', 'no pic', 200.02, 130.58 , 'm', '2002/12/30' ,'drun drun'  ),
('jorko', 'no pic', 200.02, 130.58 , 'f', '2002/12/30' ,'drun drun'  );