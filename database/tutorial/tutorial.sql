DROP DATABASE IF EXISTS tutorial;
CREATE DATABASE IF NOT EXISTS tutorial;
USE tutorial;

GRANT ALL PRIVILEGES ON `tutorial`.* TO 'training_user'@'%';

-- -----------------------------------------------------
-- Create Table
-- -----------------------------------------------------

DROP TABLE IF EXISTS `employees` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `employees` (
  `employee_id` TINYINT NOT NULL ,
  `name` VARCHAR(128) ,
  `department_id` TINYINT ,
  PRIMARY KEY (`employee_id`) )
ENGINE = InnoDB;

DROP TABLE IF EXISTS `department` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `department` (
  `department_id` TINYINT NOT NULL ,
  `department_name` VARCHAR(128) ,
  PRIMARY KEY (`department_id`) )
ENGINE = InnoDB;

DROP TABLE IF EXISTS `employees_2` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `employees_2` (
  `employee_id` TINYINT NOT NULL ,
  `name` VARCHAR(128) ,
  `department_id` TINYINT ,
  PRIMARY KEY (`employee_id`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Insert Data
-- -----------------------------------------------------
insert into `employees` (`employee_id`, `name`, `department_id`) values
(1, "田中太郎", 3),
(2, "鈴木花子", 2),
(3, "高橋拓実", 1),
(4, "木下洋子", NULL);

insert into `department` (`department_id`, `department_name`) values
(1, "人事"),
(2, "営業"),
(3, "エンジニア"),
(4, "経理");

insert into `employees_2` (`employee_id`, `name`, `department_id`) values
(1, "田中太郎", 3),
(2, "鈴木花子", 2),
(8, "森本浩", 1),
(9, "藤崎楓", 2);
