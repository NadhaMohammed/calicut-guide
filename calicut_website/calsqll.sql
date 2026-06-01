/*
SQLyog Community v13.0.1 (64 bit)
MySQL - 5.1.32-community : Database - calicut_website
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`calicut_website` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `calicut_website`;

/*Table structure for table `add_course` */

DROP TABLE IF EXISTS `add_course`;

CREATE TABLE `add_course` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `program_name` varchar(50) NOT NULL,
  `core_course` varchar(50) NOT NULL,
  `duration` varchar(50) NOT NULL,
  `fees` int(11) NOT NULL,
  `edu_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

/*Data for the table `add_course` */

insert  into `add_course`(`id`,`program_name`,`core_course`,`duration`,`fees`,`edu_id`) values 
(2,'UG pgm','hhy','yhhyy',12000,19),
(3,'UG pgm','gfggfhgf','1',12000,19);

/*Table structure for table `ambulance_details` */

DROP TABLE IF EXISTS `ambulance_details`;

CREATE TABLE `ambulance_details` (
  `ambulance_id` int(11) NOT NULL AUTO_INCREMENT,
  `vehicle_no` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `contact_no` varchar(20) NOT NULL,
  `facility` varchar(50) NOT NULL,
  `hospital_id` int(11) NOT NULL,
  PRIMARY KEY (`ambulance_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

/*Data for the table `ambulance_details` */

insert  into `ambulance_details`(`ambulance_id`,`vehicle_no`,`name`,`contact_no`,`facility`,`hospital_id`) values 
(1,1,'amisha',11111134,'Oxygen Support',3),
(2,2,'akshara',2345,'Oxygen Support',3);

/*Table structure for table `beach_details` */

DROP TABLE IF EXISTS `beach_details`;

CREATE TABLE `beach_details` (
  `beach_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `place` varchar(50) NOT NULL,
  `facility` varchar(50) NOT NULL,
  `latitude` varchar(50) NOT NULL,
  `longitude` varchar(50) NOT NULL,
  `description` TEXT NOT NULL,
  PRIMARY KEY (`beach_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

/*Data for the table `beach_details` */

insert  into `beach_details`(`beach_id`,`name`,`place`,`facility`,`latitude`,`longitude`,`description`) values 
(2,'lk','jjjj','Restaurant','1.22','1.33','fggg');

/*Table structure for table `bus_details` */

DROP TABLE IF EXISTS `bus_details`;

CREATE TABLE `bus_details` (
  `bus_id` int(11) NOT NULL AUTO_INCREMENT,
  `bus_name` varchar(50) NOT NULL,
  `latitude` varchar(50) NOT NULL,
  `longitude` varchar(50) NOT NULL,
  PRIMARY KEY (`bus_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

/*Data for the table `bus_details` */

insert  into `bus_details`(`bus_id`,`bus_name`,`latitude`,`longitude`) values 
(1,'cvb ','1.2','2.2'),
(2,'cvb ','1.7','2.2');

/*Table structure for table `doctor_details` */

DROP TABLE IF EXISTS `doctor_details`;

CREATE TABLE `doctor_details` (
  `doctor_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `specialization` varchar(50) NOT NULL,
  `contact` varchar(20) NOT NULL,
  `hospital_id` int(11) NOT NULL,
  PRIMARY KEY (`doctor_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

/*Data for the table `doctor_details` */

insert  into `doctor_details`(`doctor_id`,`name`,`specialization`,`contact`,`hospital_id`) values 
(2,'bdd','ortho',4558866,4),
(3,'bdd','cardio',4558866,4);

/*Table structure for table `education_details` */

DROP TABLE IF EXISTS `education_details`;

CREATE TABLE `education_details` (
  `edu_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `place` varchar(50) NOT NULL,
  `post` varchar(50) NOT NULL,
  `pincode` int(11) NOT NULL,
  `contact` varchar(20) NOT NULL,
  `email` varchar(50) NOT NULL,
  `opens` varchar(50) NOT NULL,
  `closes` varchar(50) NOT NULL,
  `login_id` int(11) NOT NULL,
  PRIMARY KEY (`edu_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

/*Data for the table `education_details` */

insert  into `education_details`(`edu_id`,`name`,`place`,`post`,`pincode`,`contact`,`email`,`opens`,`closes`,`login_id`) values 
(2,'jdt','vellimaad','hihiiiii',67445,9856443322,'jdt123@gmail.com','10.am','12 pm',20);

/*Table structure for table `hospital_booking` */

DROP TABLE IF EXISTS `hospital_booking`;

CREATE TABLE `hospital_booking` (
  `book_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `booking_time` int(11) NOT NULL,
  `booking_day` varchar(50) NOT NULL,
  `hospital_id` int(11) NOT NULL,
  PRIMARY KEY (`book_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;

/*Data for the table `hospital_booking` */

insert  into `hospital_booking`(`book_id`,`name`,`booking_time`,`booking_day`,`hospital_id`) values 
(5,'3',11,'Wednesday',4),
(6,'3',11,'Wednesday',4);

/*Table structure for table `hospital_details` */

DROP TABLE IF EXISTS `hospital_details`;

CREATE TABLE `hospital_details` (
  `hospital_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `place` varchar(50) NOT NULL,
  `post` varchar(50) NOT NULL,
  `pincode` int(11) NOT NULL,
  `contact` varchar(20) NOT NULL,
  `Image` varchar(255) NOT NULL,
  `email` varchar(50) NOT NULL,
  `latitude` varchar(50) NOT NULL,
  `longitude` varchar(50) NOT NULL,
  `login_id` int(50) NOT NULL,
  PRIMARY KEY (`hospital_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;

/*Data for the table `hospital_details` */

insert  into `hospital_details`(`hospital_id`,`name`,`place`,`post`,`pincode`,`contact`,`Image`,`email`,`latitude`,`longitude`,`login_id`) values 
(4,'anagha','dxhdfdn','vbxdvb',5555,3455,'bmh.jpg','anaghasivan817@gmail.com','xcvnxgh','fbfxb',11);

/*Table structure for table `hospital_facilities` */

DROP TABLE IF EXISTS `hospital_facilities`;

CREATE TABLE `hospital_facilities` (
  `facility_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `description` TEXT NOT NULL,
  `hospital_id` int(11) NOT NULL,
  PRIMARY KEY (`facility_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

/*Data for the table `hospital_facilities` */

insert  into `hospital_facilities`(`facility_id`,`name`,`description`,`hospital_id`) values 
(3,'ddsfdsf 222','vdfgvdffd',4);

/*Table structure for table `login` */

DROP TABLE IF EXISTS `login`;

CREATE TABLE `login` (
  `login_id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `password` varchar(50) NOT NULL,
  `usertype` varchar(50) NOT NULL,
  PRIMARY KEY (`login_id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=latin1;

/*Data for the table `login` */

insert  into `login`(`login_id`,`username`,`password`,`usertype`) values 
(1,'admin','123','admin'),
(2,'h1','dnhdfm',''),
(3,'h3','789','ambulance'),
(4,'h2','456','hospital'),
(5,'bncbfnc','ghhh','hospital'),
(6,'bncbfnc','123456','hospital'),
(7,'bncbfnc','123','hospital'),
(8,'shop1','1234','Shop'),
(9,'shop1','1234','Shop'),
(10,'shop1','1234','Shop'),
(11,'bncbfnc','qwerty','hospital'),
(17,'rest2','rest2','restaurant'),
(18,'topform123','123','restaurant'),
(19,'kgptc123','123','education'),
(20,'jdt123','jdt1234','education'),
(21,'fancy','111','Shop');

/*Table structure for table `mall_details` */

DROP TABLE IF EXISTS `mall_details`;

CREATE TABLE `mall_details` (
  `mall_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `place` varchar(50) NOT NULL,
  `post` varchar(50) NOT NULL,
  `contact` varchar(20) NOT NULL,
  `facility` varchar(50) NOT NULL,
  `opens` varchar(50) NOT NULL,
  `closes` varchar(50) NOT NULL,
  `image` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`mall_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

/*Data for the table `mall_details` */

insert  into `mall_details`(`mall_id`,`name`,`place`,`post`,`contact`,`facility`,`opens`,`closes`,`image`) values 
(1,'anagha','beypore','11111',1111111,'on','9:00','6:00','kgptc.jpg');

/*Table structure for table `railway_details` */

DROP TABLE IF EXISTS `railway_details`;

CREATE TABLE `railway_details` (
  `rail_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `about` TEXT NOT NULL,
  `latitude` varchar(50) NOT NULL,
  `longitude` varchar(50) NOT NULL,
  PRIMARY KEY (`rail_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

/*Data for the table `railway_details` */

insert  into `railway_details`(`rail_id`,`name`,`about`,`latitude`,`longitude`) values 
(1,'fdd','dff','11.9','5.9'),
(2,'calicut','dff','11.9','5.9'),
(3,'kannur','dff>','11.9','5.9');

/*Table structure for table `registration` */

DROP TABLE IF EXISTS `registration`;

CREATE TABLE `registration` (
  `reg_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `email` varchar(50) NOT NULL,
  `login_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`reg_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `registration` */

/*Table structure for table `res_food` */

DROP TABLE IF EXISTS `res_food`;

CREATE TABLE `res_food` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `dish` varchar(50) NOT NULL,
  `category` varchar(50) NOT NULL,
  `veg` varchar(50) NOT NULL,
  `non_veg` varchar(50) NOT NULL,
  `price` int(11) NOT NULL,
  `res_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=latin1;

/*Data for the table `res_food` */

insert  into `res_food`(`id`,`dish`,`category`,`veg`,`non_veg`,`price`,`res_id`) values 
(3,'chicken soup','Soup','Non-Veg','Non-Veg',330,17),
(4,'chicken soup','Soup','Non-Veg','Non-Veg',200,17),
(5,'chicken soup','Soup','Vegetarian','Vegetarian',200,17),
(6,'chicken soup','Soup','Non-Veg','Non-Veg',500,17),
(7,'chicken soup','Soup','Non-Veg','Non-Veg',500,17),
(8,'chicken soup','Soup','Non-Veg','Non-Veg',330,17),
(9,'chicken soup','Soup','Vegetarian','Vegetarian',500,17),
(10,'chicken soup','Soup','Vegetarian','Vegetarian',500,17);

/*Table structure for table `res_room` */

DROP TABLE IF EXISTS `res_room`;

CREATE TABLE `res_room` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `room_details` varchar(50) NOT NULL,
  `occupancy` varchar(50) NOT NULL,
  `price` int(11) NOT NULL,
  `room_des` TEXT NOT NULL,
  `photo` varchar(255) NOT NULL,
  `res_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;

/*Data for the table `res_room` */

insert  into `res_room`(`id`,`room_details`,`occupancy`,`price`,`room_des`,`photo`,`res_id`) values 
(4,'Suit Room','Single Occupancy',3500,'bhbhbkjbkj','im.avif',5),
(6,'Executive Room','Double Occupancy',3500,' b nm nm nm nm ','bmh.jpg',5);

/*Table structure for table `res_workingtime` */

DROP TABLE IF EXISTS `res_workingtime`;

CREATE TABLE `res_workingtime` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `morning_hrs` varchar(50) NOT NULL,
  `evng_hrs` varchar(50) NOT NULL,
  `res_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=latin1;

/*Data for the table `res_workingtime` */

insert  into `res_workingtime`(`id`,`morning_hrs`,`evng_hrs`,`res_id`) values 
(10,'14:21','17:19',18),
(11,'15:32','13:34',18),
(12,'14:35','15:35',18),
(14,'23:03','20:02',17),
(15,'23:03','20:02',17);

/*Table structure for table `restaurant_details` */

DROP TABLE IF EXISTS `restaurant_details`;

CREATE TABLE `restaurant_details` (
  `res_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `place` varchar(50) NOT NULL,
  `post` varchar(50) NOT NULL,
  `nearby` varchar(50) NOT NULL,
  `contact` varchar(20) NOT NULL,
  `latitude` varchar(50) NOT NULL,
  `longitude` varchar(50) NOT NULL,
  `image` varchar(255) NOT NULL,
  `login_id` int(11) NOT NULL,
  PRIMARY KEY (`res_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;

/*Data for the table `restaurant_details` */

insert  into `restaurant_details`(`res_id`,`name`,`place`,`post`,`nearby`,`contact`,`latitude`,`longitude`,`image`,`login_id`) values 
(5,'mayflower','kozhikode','kozhikode','sasa',13331,'1.33','2.11','kgptc.jpg',17),
(6,'topform','mavoor road','calicut','mavoor road',984533455,'11.3','11.7','bmh.jpg',18);

/*Table structure for table `shop_details` */

DROP TABLE IF EXISTS `shop_details`;

CREATE TABLE `shop_details` (
  `shop_id` int(11) NOT NULL AUTO_INCREMENT,
  `shop_type` varchar(50) NOT NULL,
  `name` varchar(50) NOT NULL,
  `place` varchar(50) NOT NULL,
  `post` varchar(50) NOT NULL,
  `pincode` int(11) NOT NULL,
  `contact` varchar(20) NOT NULL,
  `opens` varchar(50) NOT NULL,
  `closes` varchar(50) NOT NULL,
  `login_id` int(11) NOT NULL,
  PRIMARY KEY (`shop_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

/*Data for the table `shop_details` */

insert  into `shop_details`(`shop_id`,`shop_type`,`name`,`place`,`post`,`pincode`,`contact`,`opens`,`closes`,`login_id`) values 
(1,'Grocery shop','anagha','zzz','111',1111,122233,'asoo','fggff',21);

/*Table structure for table `taxi_details` */

DROP TABLE IF EXISTS `taxi_details`;

CREATE TABLE `taxi_details` (
  `taxi_id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(50) NOT NULL,
  `place` varchar(50) NOT NULL,
  `contact_person` varchar(50) NOT NULL,
  `contact_no` varchar(20) NOT NULL,
  PRIMARY KEY (`taxi_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;

/*Data for the table `taxi_details` */

insert  into `taxi_details`(`taxi_id`,`type`,`place`,`contact_person`,`contact_no`) values 
(2,'car','beypore','anju',23456789),
(3,'Auto','clt','anamika',2345),
(4,'Auto','qwertyu','asdfgh',123456);

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
