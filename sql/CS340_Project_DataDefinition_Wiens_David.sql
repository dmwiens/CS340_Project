-- Class:       CS340 Intro to Databases
-- Name:        David Wiens
-- Description: Data Table declaration for Project




-- CLEAR TABLES
DROP TABLE IF EXISTS `harvest`;
DROP TABLE IF EXISTS `plant`;
DROP TABLE IF EXISTS `plant_variety`;
DROP TABLE IF EXISTS `bed`;
DROP TABLE IF EXISTS `workshift`;
DROP TABLE IF EXISTS `gardener_site`;
DROP TABLE IF EXISTS `site`;
DROP TABLE IF EXISTS `gardener`;



--
-- Table structure for table `gardener`
--

CREATE TABLE `gardener` (
  `id` INT(11) UNSIGNED AUTO_INCREMENT NOT NULL,
  `fname` VARCHAR(255) NOT NULL,
  `lname` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`fname`,`lname`)
) ENGINE=InnoDB;


--
-- Table structure for table `site`
--

CREATE TABLE `site` (
  `id` INT(11) UNSIGNED AUTO_INCREMENT NOT NULL,
  `name` VARCHAR(255) UNIQUE KEY NOT NULL,
  `length` INT(11) UNSIGNED NOT NULL,
  `width` INT(11) UNSIGNED NOT NULL,
  `addr_street` VARCHAR(255) DEFAULT NULL,
  `addr_city` VARCHAR(255) DEFAULT NULL,
  `addr_state` VARCHAR(255) DEFAULT NULL,
  `addr_zip` INT(11) UNSIGNED DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `address` (`addr_street`,`addr_city`,`addr_state`,`addr_zip`)
) ENGINE=InnoDB;


--
-- Table structure for table `gardener_site`
--

CREATE TABLE `gardener_site` (
  `id` INT(11) UNSIGNED AUTO_INCREMENT NOT NULL,
  `gardener` INT(11) UNSIGNED NOT NULL,
  `site` INT(11) UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`gardener`) REFERENCES `gardener`(`id`) ON UPDATE CASCADE ON DELETE CASCADE,
  FOREIGN KEY (`site`) REFERENCES `site`(`id`) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;


--
-- Table structure for table `workshift`
--

CREATE TABLE `workshift` (
  `id` INT(11) UNSIGNED AUTO_INCREMENT NOT NULL,
  `gardener` INT(11) UNSIGNED NOT NULL,
  `site` INT(11) UNSIGNED NOT NULL,
  `date` DATE NOT NULL,
  `hours_worked` INT(11) UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`gardener`) REFERENCES `gardener`(`id`) ON UPDATE CASCADE ON DELETE CASCADE,
  FOREIGN KEY (`site`) REFERENCES `site`(`id`) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;


--
-- Table structure for table `bed`
--

CREATE TABLE `bed` (
  `id` INT(11) UNSIGNED AUTO_INCREMENT NOT NULL,
  `bname` VARCHAR(255) UNIQUE KEY NOT NULL,
  `site` INT(11) UNSIGNED NOT NULL,
  `blength` INT(11) UNSIGNED NOT NULL,
  `bwidth` INT(11) UNSIGNED NOT NULL,
  `location_x` INT(11) UNSIGNED NOT NULL,
  `location_y` INT(11) UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `dimensions` (`bname`,`blength`,`bwidth`,`location_x`,`location_y`),
  FOREIGN KEY (`site`) REFERENCES `site`(`id`) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;


--
-- Table structure for table `plant_variety`
--

CREATE TABLE `plant_variety` (
  `id` INT(11) UNSIGNED AUTO_INCREMENT NOT NULL,
  `common_name` VARCHAR(255) UNIQUE KEY NOT NULL,
  `rec_plant_date` DATE NOT NULL,
  `rec_harvest_date` DATE NOT NULL,
  `cost` DECIMAL(5,2) NOT NULL,
  `food_unit` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;


--
-- Table structure for table `plant`
--

CREATE TABLE `plant` (
  `id` INT(11) UNSIGNED AUTO_INCREMENT NOT NULL,
  `variety` INT(11) UNSIGNED NOT NULL,
  `bed` INT(11) UNSIGNED NOT NULL,
  `date_planted` DATE NOT NULL,
  `date_dead` DATE DEFAULT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`variety`) REFERENCES `plant_variety`(`id`) ON UPDATE CASCADE ON DELETE CASCADE,
  FOREIGN KEY (`bed`) REFERENCES `bed`(`id`) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;



--
-- Table structure for table `harvest`
--

CREATE TABLE `harvest` (
  `id` INT(11) UNSIGNED AUTO_INCREMENT NOT NULL,
  `plant` INT(11) UNSIGNED NOT NULL,
  `date` DATE NOT NULL,
  `yield` FLOAT NOT NULL,
  `quality` INT(11) UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`plant`) REFERENCES `plant`(`id`) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;



--
-- Data for table `gardener`///////////////////////////////////////////////////////////////////////////
--


INSERT INTO `gardener`(`id`, `fname`, `lname`) VALUES
(1,'David','Wiens'),
(2,'Ruby','Reitz'),
(3,'Lesley','Neighbor'),
(4,'Tedd','Neighbor');


--
-- Data for table `site`///////////////////////////////////////////////////////////////////////////
--

INSERT INTO `site`(`id`, `name`, `length`, `width`, `addr_street`, `addr_city`, `addr_state`, `addr_zip`) VALUES
(1,'Housey Gardens', 100, 70, '134 NE 79th Ave','Portland','OR',97213),
(2,'Neighbor Garden', 100, 80,'132 NE 79th Ave','Portland','OR',97213),
(3,'Montavilla Community Garden',200, 200, '202 NE 80th Ave','Portland','OR',97213);


--
-- Data for table `gardener_site`///////////////////////////////////////////////////////////////////////////
--

INSERT INTO `gardener_site`(`id`, `gardener`, `site`) VALUES 
(1, 1, 1),
(2, 1, 3),
(3, 2, 1),
(4, 2, 3),
(5, 3, 2),
(6, 3, 3),
(7, 4, 2),
(8, 4, 3);


--
-- Data for table `workshift`///////////////////////////////////////////////////////////////////////////
--
INSERT INTO `workshift`(`id`, `gardener`, `site`, `date`, `hours_worked`) VALUES 
(1, 1, 1, '2018-03-03', 3),
(2, 2, 1, '2018-03-03', 4),
(3, 2, 1, '2018-03-15', 2),
(4, 2, 1, '2018-03-31', 2),
(5, 1, 1, '2018-04-01', 1),
(6, 3, 3, '2018-04-15', 12),
(7, 4, 3, '2018-04-15', 1),
(8, 4, 2, '2018-04-15', 11),
(9, 3, 2, '2018-04-16', 12);


--
-- Data for table `bed`///////////////////////////////////////////////////////////////////////////
--

INSERT INTO `bed`(`id`, `name`, `site`, `blength`, `bwidth`, `location_x`, `location_y`) VALUES 
(1, 'Yardcorner plot', 1, 10, 10, 50, 10),
(2, 'Fenceline box', 1, 10, 1, 10, 10),
(3, 'Metal dirt-filled tub', 2, 20, 20, 20, 20),
(4, 'Primary arable plot', 3, 30, 30, 10, 10);


--
-- Data for table `plant_variety`///////////////////////////////////////////////////////////////////////////
--

INSERT INTO `plant_variety`(`id`, `common_name`, `rec_plant_date`, `rec_harvest_date`, `cost`, `food_unit`) VALUES 
(1, 'cabbage', '2000-05-01', '2000-08-01', '2.19', 'head'),
(2, 'tomato', '2000-05-01', '2000-08-01', '0.90', 'tomato'),
(3, 'thyme', '2000-05-01', '2000-08-01', '0.07', 'gram');


--
-- Data for table `plant`///////////////////////////////////////////////////////////////////////////
--

INSERT INTO `plant`(`id`, `variety`, `bed`, `date_planted`, `date_dead`) VALUES 
(1, 1, 1, '2018-04-01', NULL),
(2, 1, 1, '2018-04-01', NULL),
(3, 1, 1, '2018-04-01', NULL),
(4, 2, 2, '2018-04-02', NULL),
(5, 2, 2, '2018-04-02', NULL),
(6, 3, 2, '2018-04-02', NULL),
(7, 3, 2, '2018-04-15', NULL),
(8, 3, 2, '2018-04-03', NULL),
(9, 2, 3, '2018-04-15', NULL),
(10, 3, 4, '2018-04-16', NULL);


--
-- Data for table `harvest`///////////////////////////////////////////////////////////////////////////
--

INSERT INTO `harvest`(`id`, `plant`, `date`, `yield`, `quality`) VALUES 
(1, 5, '2018-07-31', 3, 7),
(2, 2, '2018-08-01', 1, 10),
(3, 1, '2018-08-03', 1, 1),
(4, 7, '2018-08-27', 3, 5),
(5, 10, '2018-09-31', 0.7, 7),
(6, 2, '2018-10-01', 0.1, 2);