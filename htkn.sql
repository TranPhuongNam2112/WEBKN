/*
SQLyog Enterprise - MySQL GUI v6.15
MySQL - 5.7.26-log : Database - htkn
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

create database if not exists `htkn`;

USE `htkn`;

/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

/*Table structure for table `category` */

DROP TABLE IF EXISTS `category`;

CREATE TABLE `category` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `category_name` varchar(100) DEFAULT NULL,
  `description` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

/*Data for the table `category` */

insert  into `category`(`id`,`category_name`,`description`) values (1,'Education','aaaaa'),(2,'Economics','aaaaaaa');

/*Table structure for table `contributions` */

DROP TABLE IF EXISTS `contributions`;

CREATE TABLE `contributions` (
  `user_id` int(11) NOT NULL,
  `project_id` int(11) NOT NULL,
  `contributed` int(11) DEFAULT NULL,
  `timestamp` date DEFAULT NULL,
  PRIMARY KEY (`user_id`,`project_id`),
  KEY `FK_contributions_1` (`project_id`),
  CONSTRAINT `FK_contributions` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `FK_contributions_1` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `contributions` */

/*Table structure for table `projects` */

DROP TABLE IF EXISTS `projects`;

CREATE TABLE `projects` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_title` varchar(100) DEFAULT NULL,
  `project_description` varchar(100) DEFAULT NULL,
  `goal` int(11) DEFAULT NULL,
  `current_amount` int(11) DEFAULT NULL,
  `days` int(11) DEFAULT NULL,
  `userId` int(11) NOT NULL,
  `created` date DEFAULT NULL,
  `categoryId` int(11) NOT NULL,
  `deadline` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_projects` (`userId`),
  KEY `FK_projects_1` (`categoryId`),
  CONSTRAINT `FK_projects` FOREIGN KEY (`userId`) REFERENCES `users` (`id`),
  CONSTRAINT `FK_projects_1` FOREIGN KEY (`categoryId`) REFERENCES `category` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `projects` */

/*Table structure for table `users` */

DROP TABLE IF EXISTS `users`;

CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `first_name` varchar(100) DEFAULT NULL,
  `last_name` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `password` varchar(100) DEFAULT NULL,
  `created` date DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;

/*Data for the table `users` */

insert  into `users`(`id`,`first_name`,`last_name`,`email`,`password`,`created`) values (1,NULL,'nam','nam@gmail.com','$2b$10$3xejzBIkOyZ99GqvgwnfM.Ol2r4HgFr4dArAr83sGf.IOdVw1RqIa','2019-11-15'),(2,'nam','nam','elle@gmail.com','$2b$10$xEeMMaOSh9dKxtUkhaXBxOTuDAY/kVlx/gm6lyVYEmOOoLkSJ.Udi','2019-11-16'),(3,'olle','olle','olle@gmail.com','$2b$10$.5nsRcD1AFxA/EE5Q2HdJOsJY6x5JTLIk22GfX2vZe2gfAmn7XnLu','2019-11-16'),(4,'kkk','kkk','kkk@gmail.com','$2b$10$qTUgdav3Hat4j.IdFbxtluxpcZq03HxmVKaWvmrpp0PW.35WKmSSu','2019-11-22');

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
