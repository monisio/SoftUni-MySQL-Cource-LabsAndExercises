CREATE SCHEMA `movies`;
CREATE TABLE `movies`.`directors`(
`id` INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
`director_name` VARCHAR(50) NOT NULL,
`notes` TEXT(200)
);

CREATE TABLE `movies`.`genres`(
`id` INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
`genre_name` VARCHAR(50) NOT NULL UNIQUE ,
`notes` TEXT(200)
);

CREATE TABLE `movies`.`categories`(
`id` INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
`category_name` VARCHAR(50) NOT NULL UNIQUE ,
`notes` TEXT(200)
);


CREATE TABLE `movies`.`movies`(
`id` INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
`title` VARCHAR(100) NOT NULL UNIQUE,
`director_id` INT NOT NULL,
`copyright_year` YEAR NOT NULL,
`length` TIME NOT NULL,
`genre_id` INT NOT NULL,
`category_id` INT NOT NULL,
`rating` INT NOT NULL,
`notes` TEXT(200)

);


ALTER TABLE `movies`.`movies`
ADD CONSTRAINT `fk_director_id`
FOREIGN KEY (`director_id`)
REFERENCES `movies`.`directors`(`id`)
ON DELETE RESTRICT
ON UPDATE CASCADE,

ADD CONSTRAINT `fk_genre_id`
FOREIGN KEY (`genre_id`)
REFERENCES `movies`.`genres`(`id`)
ON DELETE RESTRICT
ON UPDATE CASCADE,

ADD CONSTRAINT `fk_category_id`
FOREIGN KEY (`category_id`)
REFERENCES `movies`.`categories`(`id`)
ON DELETE RESTRICT
ON UPDATE CASCADE;

INSERT INTO `directors` (`director_name`,`notes`)
VALUES
('Stiven Speilberg','Oscar Winner'),
('Corado Catany', 'No Oscars'),
('Jekie Chan', NULL),
('Mincho Minkov',"Golqma rabota"),
('Punko Punchev',NULL);


INSERT INTO `genres` (`genre_name`,`notes`)
VALUES
('Action', 'fighting movies'),
('Drama', 'sopoli i sulzi'),
('Comedy','Laught'),
('Thriller', 'suspence'),
('Tragedy', 'sakantiq');


INSERT INTO `categories` (`category_name`, `notes`)
VALUES
('Asian', 'ujas'),
('USA', 'ujas'),
('Canadian', 'ujas'),
('Indonesian', 'ujas'),
('Japan', NULL );
 
 
 INSERT INTO `movies`(`title`,`director_id`,`copyright_year`,`length`,`genre_id`,`category_id`,`rating`,`notes`)
 VALUES
 ('Test1',3,2002,'2:20',1,1,20,'no notes'),
 ('Test2',1,2020,'1:02',3,2,20, NULL),
 ('Test3',5,1999,'4:06',2,4,20,'test note'),
 ('Test4',2,2000,'22:02',5,5,20,'note'),
 ('Test5',4,1975,'18:02',4,3,20,'kawabunga');
 
