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
  `addr_zip` VARCHAR(255) DEFAULT NULL,
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
  `name` VARCHAR(255) UNIQUE KEY NOT NULL,
  `site` INT(11) UNSIGNED NOT NULL,
  `length` INT(11) UNSIGNED NOT NULL,
  `width` INT(11) UNSIGNED NOT NULL,
  `location_x` INT(11) UNSIGNED NOT NULL,
  `location_y` INT(11) UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `dimensions` (`name`,`length`,`width`,`location_x`,`location_y`),
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


INSERT INTO `gardener`(`fname`, `lname`) VALUES
('David','Wiens'),
('Ruby','Reitz'),
('Lesley','Neighbor'),
('Tedd','Neighbor');


--
-- Data for table `site`///////////////////////////////////////////////////////////////////////////
--

INSERT INTO `site`(`name`, `length`, `width`, `addr_street`, `addr_city`, `addr_state`, `addr_zip`) VALUES
('Housey Gardens', 100, 70, '134 NE 79th Ave','Portland','OR','97213'),
('Neighbor Garden', 100, 80,'132 NE 79th Ave','Portland','OR','97213'),
('Montavilla Community Garden',200, 200, '202 NE 80th Ave','Portland','OR','97213');


--
-- Data for table `gardener_site`///////////////////////////////////////////////////////////////////////////
--

INSERT INTO `gardener_site`(`gardener`, `site`) VALUES 
((SELECT id FROM gardener WHERE fname='David' AND lname='Wiens'), (SELECT id FROM `site` WHERE name='Housey Gardens')),
((SELECT id FROM gardener WHERE fname='David' AND lname='Wiens'), (SELECT id FROM `site` WHERE name='Montavilla Community Garden')),
((SELECT id FROM gardener WHERE fname='Ruby' AND lname='Reitz'), (SELECT id FROM `site` WHERE name='Housey Gardens')),
((SELECT id FROM gardener WHERE fname='Ruby' AND lname='Reitz'), (SELECT id FROM `site` WHERE name='Montavilla Community Garden')),
((SELECT id FROM gardener WHERE fname='Lesley' AND lname='Neighbor'), (SELECT id FROM `site` WHERE name='Neighbor Garden')),
((SELECT id FROM gardener WHERE fname='Lesley' AND lname='Neighbor'), (SELECT id FROM `site` WHERE name='Montavilla Community Garden')),
((SELECT id FROM gardener WHERE fname='Tedd' AND lname='Neighbor'), (SELECT id FROM `site` WHERE name='Neighbor Garden')),
((SELECT id FROM gardener WHERE fname='Tedd' AND lname='Neighbor'), (SELECT id FROM `site` WHERE name='Montavilla Community Garden'));


--
-- Data for table `workshift`///////////////////////////////////////////////////////////////////////////
--
INSERT INTO `workshift`(`gardener`, `site`, `date`, `hours_worked`) VALUES 
((SELECT id FROM gardener WHERE fname='David' AND lname='Wiens'), (SELECT id FROM `site` WHERE name='Housey Gardens'), '2018-03-03', 3),
((SELECT id FROM gardener WHERE fname='Ruby' AND lname='Reitz'), (SELECT id FROM `site` WHERE name='Housey Gardens'), '2018-03-03', 4),
((SELECT id FROM gardener WHERE fname='Ruby' AND lname='Reitz'), (SELECT id FROM `site` WHERE name='Housey Gardens'), '2018-03-15', 2),
((SELECT id FROM gardener WHERE fname='Ruby' AND lname='Reitz'), (SELECT id FROM `site` WHERE name='Housey Gardens'), '2018-03-31', 2),
((SELECT id FROM gardener WHERE fname='David' AND lname='Wiens'), (SELECT id FROM `site` WHERE name='Housey Gardens'), '2018-04-01', 1),
((SELECT id FROM gardener WHERE fname='Lesley' AND lname='Neighbor'), (SELECT id FROM `site` WHERE name='Montavilla Community Garden'), '2018-04-15', 12),
((SELECT id FROM gardener WHERE fname='Tedd' AND lname='Neighbor'), (SELECT id FROM `site` WHERE name='Montavilla Community Garden'), '2018-04-15', 1),
((SELECT id FROM gardener WHERE fname='Tedd' AND lname='Neighbor'), (SELECT id FROM `site` WHERE name='Neighbor Garden'), '2018-04-15', 11),
((SELECT id FROM gardener WHERE fname='Lesley' AND lname='Neighbor'), (SELECT id FROM `site` WHERE name='Neighbor Garden'), '2018-04-16', 12);


--
-- Data for table `bed`///////////////////////////////////////////////////////////////////////////
--

INSERT INTO `bed`(`name`, `site`, `length`, `width`, `location_x`, `location_y`) VALUES 
('Yardcorner plot', (SELECT id FROM `site` WHERE name='Housey Gardens'), 10, 10, 50, 10),
('Fenceline box', (SELECT id FROM `site` WHERE name='Housey Gardens'), 10, 1, 10, 10),
('Metal dirt-filled tub', (SELECT id FROM `site` WHERE name='Neighbor Garden'), 20, 20, 20, 20),
('Primary arable plot', (SELECT id FROM `site` WHERE name='Montavilla Community Garden'), 30, 30, 10, 10);


--
-- Data for table `plant_variety`///////////////////////////////////////////////////////////////////////////
--

INSERT INTO `plant_variety`(`common_name`, `rec_plant_date`, `rec_harvest_date`, `cost`, `food_unit`) VALUES 
('cabbage', '2000-05-01', '2000-08-01', '2.19', 'head'),
('tomato', '2000-05-01', '2000-08-01', '0.90', 'tomato'),
('thyme', '2000-05-01', '2000-08-01', '0.07', 'gram');


--
-- Data for table `plant`///////////////////////////////////////////////////////////////////////////
--

INSERT INTO `plant`(`variety`, `bed`, `date_planted`, `date_dead`) VALUES 
((SELECT id FROM `plant_variety` WHERE common_name='cabbage'), (SELECT id FROM `bed` WHERE name='Yardcorner plot'), '2018-04-01', NULL),
((SELECT id FROM `plant_variety` WHERE common_name='cabbage'), (SELECT id FROM `bed` WHERE name='Yardcorner plot'), '2018-04-01', NULL),
((SELECT id FROM `plant_variety` WHERE common_name='cabbage'), (SELECT id FROM `bed` WHERE name='Yardcorner plot'), '2018-04-01', NULL),
((SELECT id FROM `plant_variety` WHERE common_name='tomato'), (SELECT id FROM `bed` WHERE name='Fenceline box'), '2018-04-02', NULL),
((SELECT id FROM `plant_variety` WHERE common_name='tomato'), (SELECT id FROM `bed` WHERE name='Fenceline box'), '2018-04-02', NULL),
((SELECT id FROM `plant_variety` WHERE common_name='thyme'), (SELECT id FROM `bed` WHERE name='Fenceline box'), '2018-04-02', NULL),
((SELECT id FROM `plant_variety` WHERE common_name='thyme'), (SELECT id FROM `bed` WHERE name='Fenceline box'), '2018-04-15', NULL),
((SELECT id FROM `plant_variety` WHERE common_name='thyme'), (SELECT id FROM `bed` WHERE name='Fenceline box'), '2018-04-03', NULL),
((SELECT id FROM `plant_variety` WHERE common_name='tomato'), (SELECT id FROM `bed` WHERE name='Metal dirt-filled tub'), '2018-04-15', NULL),
((SELECT id FROM `plant_variety` WHERE common_name='thyme'), (SELECT id FROM `bed` WHERE name='Primary arable plot'), '2018-04-16', NULL);


--
-- Data for table `harvest`///////////////////////////////////////////////////////////////////////////
--

-- Note insertion based on hard-coded primary key is only way, because no other attribures are unique
INSERT INTO `harvest`(`plant`, `date`, `yield`, `quality`) VALUES 
(5, '2018-07-31', 3, 7),
(2, '2018-08-01', 1, 10),
(1, '2018-08-03', 1, 1),
(7, '2018-08-27', 3, 5),
(10, '2018-09-31', 0.7, 7),
(2, '2018-10-01', 0.1, 2);