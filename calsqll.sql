-- MySQL dump 10.13  Distrib 8.0.44, for Win64 (x86_64)
--
-- Host: localhost    Database: calicut_website
-- ------------------------------------------------------
-- Server version	8.0.44

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `add_course`
--

DROP TABLE IF EXISTS `add_course`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `add_course` (
  `id` int NOT NULL AUTO_INCREMENT,
  `program_name` varchar(50) NOT NULL,
  `core_course` varchar(50) NOT NULL,
  `duration` varchar(50) NOT NULL,
  `fees` int NOT NULL,
  `edu_id` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `add_course`
--

LOCK TABLES `add_course` WRITE;
/*!40000 ALTER TABLE `add_course` DISABLE KEYS */;
INSERT INTO `add_course` VALUES (2,'UG pgm','hhy','yhhyy',12000,19),(3,'UG pgm','gfggfhgf','1',12000,19);
/*!40000 ALTER TABLE `add_course` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `admin_profile`
--

DROP TABLE IF EXISTS `admin_profile`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `admin_profile` (
  `id` int NOT NULL AUTO_INCREMENT,
  `login_id` int NOT NULL,
  `full_name` varchar(100) DEFAULT '',
  `email` varchar(100) DEFAULT '',
  `phone` varchar(20) DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_login` (`login_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin_profile`
--

LOCK TABLES `admin_profile` WRITE;
/*!40000 ALTER TABLE `admin_profile` DISABLE KEYS */;
INSERT INTO `admin_profile` VALUES (1,1,'Nadha ','nadhamohammed12@gmail.com','9447617663');
/*!40000 ALTER TABLE `admin_profile` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ambulance_details`
--

DROP TABLE IF EXISTS `ambulance_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ambulance_details` (
  `ambulance_id` int NOT NULL AUTO_INCREMENT,
  `vehicle_no` varchar(20) NOT NULL,
  `name` varchar(50) NOT NULL,
  `contact_no` varchar(20) NOT NULL,
  `facility` varchar(255) NOT NULL,
  `hospital_id` int NOT NULL,
  PRIMARY KEY (`ambulance_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ambulance_details`
--

LOCK TABLES `ambulance_details` WRITE;
/*!40000 ALTER TABLE `ambulance_details` DISABLE KEYS */;
INSERT INTO `ambulance_details` VALUES (5,'KL-11-AB-1021','Emergency Control Room - Aster MIMS','04952488222','Mobile ICU,Cardiac Monitor,Oxygen Support,Ventilator',1),(6,'KL-11-EF-3048','Emergency Departmet -Baby Memorial Hospital','04952777000','Mobile ICU,Cardiac Monitor,Oxygen Support',1);
/*!40000 ALTER TABLE `ambulance_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `beach_details`
--

DROP TABLE IF EXISTS `beach_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `beach_details` (
  `beach_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `place` varchar(50) NOT NULL,
  `facility` varchar(255) NOT NULL,
  `latitude` varchar(50) NOT NULL,
  `longitude` varchar(50) NOT NULL,
  `description` text,
  PRIMARY KEY (`beach_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `beach_details`
--

LOCK TABLES `beach_details` WRITE;
/*!40000 ALTER TABLE `beach_details` DISABLE KEYS */;
INSERT INTO `beach_details` VALUES (4,'Kozhikode Beach','Beach Road, Kozhikode','Children\'s Park,Restaurant,Car Parking','11.2588','75.7697','Kozhikode Beach is the most popular beach in Kozhikode city. It is known for its beautiful sunsets, historic piers, lighthouse, food stalls, and recreational facilities. It attracts tourists and local visitors throughout the year.'),(5,'Beypore Beach','Beypore, Kozhikode','Restaurant,Car Parking','11.1715','75.8046','Beypore Beach is located near the historic Beypore Port. It is famous for its scenic views, fishing harbor, and traditional Uru shipbuilding heritage.');
/*!40000 ALTER TABLE `beach_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bus_details`
--

DROP TABLE IF EXISTS `bus_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bus_details` (
  `bus_id` int NOT NULL AUTO_INCREMENT,
  `bus_name` varchar(50) NOT NULL,
  `latitude` varchar(50) NOT NULL,
  `longitude` varchar(50) NOT NULL,
  PRIMARY KEY (`bus_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bus_details`
--

LOCK TABLES `bus_details` WRITE;
/*!40000 ALTER TABLE `bus_details` DISABLE KEYS */;
INSERT INTO `bus_details` VALUES (7,'Kozhikode KSRTC Bus Stand','11.2588','75.7804'),(8,'Palayam Bus Stand','11.2582','75.7800'),(9,'Medical College Bus Stop','11.2739','75.8354');
/*!40000 ALTER TABLE `bus_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `doctor_details`
--

DROP TABLE IF EXISTS `doctor_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `doctor_details` (
  `doctor_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `specialization` varchar(50) NOT NULL,
  `contact` varchar(20) NOT NULL,
  `hospital_id` int NOT NULL,
  PRIMARY KEY (`doctor_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `doctor_details`
--

LOCK TABLES `doctor_details` WRITE;
/*!40000 ALTER TABLE `doctor_details` DISABLE KEYS */;
INSERT INTO `doctor_details` VALUES (5,'Dr. Rajesh Kumar','Orthopaedics','04957123456',1),(6,'Dr. Prashanth Nair','Cardiology','04952488222',1);
/*!40000 ALTER TABLE `doctor_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `education_details`
--

DROP TABLE IF EXISTS `education_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `education_details` (
  `edu_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `place` varchar(50) NOT NULL,
  `post` varchar(50) NOT NULL,
  `pincode` int NOT NULL,
  `contact` varchar(20) NOT NULL,
  `email` varchar(50) NOT NULL,
  `opens` varchar(50) NOT NULL,
  `closes` varchar(50) NOT NULL,
  `login_id` int NOT NULL,
  PRIMARY KEY (`edu_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `education_details`
--

LOCK TABLES `education_details` WRITE;
/*!40000 ALTER TABLE `education_details` DISABLE KEYS */;
INSERT INTO `education_details` VALUES (2,'jdt','vellimaad','hihiiiii',67445,'9856443322','jdt123@gmail.com','10.am','12 pm',20);
/*!40000 ALTER TABLE `education_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hospital_booking`
--

DROP TABLE IF EXISTS `hospital_booking`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hospital_booking` (
  `book_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `booking_time` int NOT NULL,
  `booking_day` varchar(50) NOT NULL,
  `hospital_id` int NOT NULL,
  PRIMARY KEY (`book_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hospital_booking`
--

LOCK TABLES `hospital_booking` WRITE;
/*!40000 ALTER TABLE `hospital_booking` DISABLE KEYS */;
INSERT INTO `hospital_booking` VALUES (5,'3',11,'Wednesday',4),(6,'3',11,'Wednesday',4);
/*!40000 ALTER TABLE `hospital_booking` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hospital_details`
--

DROP TABLE IF EXISTS `hospital_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hospital_details` (
  `hospital_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `place` varchar(50) NOT NULL,
  `post` varchar(50) NOT NULL,
  `pincode` int NOT NULL,
  `contact` varchar(50) DEFAULT NULL,
  `Image` varchar(255) NOT NULL,
  `email` varchar(50) NOT NULL,
  `latitude` varchar(50) NOT NULL,
  `longitude` varchar(50) NOT NULL,
  `login_id` int NOT NULL,
  PRIMARY KEY (`hospital_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hospital_details`
--

LOCK TABLES `hospital_details` WRITE;
/*!40000 ALTER TABLE `hospital_details` DISABLE KEYS */;
INSERT INTO `hospital_details` VALUES (7,'Aster MIMS Hospital','Govindapuram','Kozhikode',673016,'0495 248 8222','aster_mims_calicut_building-min.webp','info@astermims.com','11.2589','75.7915',28),(8,'Meitra Hospital','Edakkad','Kozhikode',673005,'0495 712 3456','meitra_calicut','info@meitra.com','11.2890','75.8175',29);
/*!40000 ALTER TABLE `hospital_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hospital_facilities`
--

DROP TABLE IF EXISTS `hospital_facilities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hospital_facilities` (
  `facility_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `description` text,
  `hospital_id` int NOT NULL,
  PRIMARY KEY (`facility_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hospital_facilities`
--

LOCK TABLES `hospital_facilities` WRITE;
/*!40000 ALTER TABLE `hospital_facilities` DISABLE KEYS */;
INSERT INTO `hospital_facilities` VALUES (3,'ddsfdsf 222','vdfgvdffd',4);
/*!40000 ALTER TABLE `hospital_facilities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `login`
--

DROP TABLE IF EXISTS `login`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `login` (
  `login_id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `password` varchar(50) NOT NULL,
  `usertype` varchar(50) NOT NULL,
  PRIMARY KEY (`login_id`)
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `login`
--

LOCK TABLES `login` WRITE;
/*!40000 ALTER TABLE `login` DISABLE KEYS */;
INSERT INTO `login` VALUES (1,'admin','123','admin'),(2,'h1','dnhdfm',''),(3,'h3','789','ambulance'),(4,'h2','456','hospital'),(5,'bncbfnc','ghhh','hospital'),(6,'bncbfnc','123456','hospital'),(7,'bncbfnc','123','hospital'),(8,'shop1','1234','Shop'),(9,'shop1','1234','Shop'),(10,'shop1','1234','Shop'),(11,'bncbfnc','qwerty','hospital'),(19,'kgptc123','123','education'),(20,'jdt123','jdt1234','education'),(21,'fancy','111','Shop'),(22,'admin','123','Shop'),(23,'admin','123','hospital'),(24,'admin','123','Shop'),(26,'admin','123','hospital'),(27,'admin','123','hospital'),(28,'admin','123','hospital'),(29,'admin','123','hospital'),(30,'admin','123','Shop'),(31,'admin','123','Shop'),(32,'admin','123','Shop'),(33,'admin','123','restaurant'),(34,'admin','123','restaurant');
/*!40000 ALTER TABLE `login` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mall_details`
--

DROP TABLE IF EXISTS `mall_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mall_details` (
  `mall_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `place` varchar(50) NOT NULL,
  `post` varchar(50) NOT NULL,
  `contact` varchar(20) NOT NULL,
  `facility` varchar(255) NOT NULL,
  `opens` varchar(50) NOT NULL,
  `closes` varchar(50) NOT NULL,
  `image` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`mall_id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mall_details`
--

LOCK TABLES `mall_details` WRITE;
/*!40000 ALTER TABLE `mall_details` DISABLE KEYS */;
INSERT INTO `mall_details` VALUES (7,'HiLITE Mall','Palazhi, Kozhikode','673014','04952435000','play station,food court,Theatre,Hyper market','10:00 AM','10:00 PM','hilite_mall.webp'),(8,'Focus Mall','Mavoor Road, Kozhikode','673004','04952720011','play station,food court','10:00 AM','09:30 PM','focus-mall.webp');
/*!40000 ALTER TABLE `mall_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `railway_details`
--

DROP TABLE IF EXISTS `railway_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `railway_details` (
  `rail_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `about` text,
  `latitude` varchar(50) NOT NULL,
  `longitude` varchar(50) NOT NULL,
  PRIMARY KEY (`rail_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `railway_details`
--

LOCK TABLES `railway_details` WRITE;
/*!40000 ALTER TABLE `railway_details` DISABLE KEYS */;
INSERT INTO `railway_details` VALUES (5,'Kozhikode Railway Station','Kozhikode Railway Station (CLT) is the main railway station serving Kozhikode city. It is one of the busiest stations in Kerala and connects the city to major destinations including Kochi, Thiruvananthapuram, Bengaluru, Chennai, Mumbai, and Delhi.','11.2588','75.7804'),(6,'West Hill Railway Station','West Hill Railway Station is a small railway station located in the northern part of Kozhikode city. It mainly serves local and passenger train services.','11.2898','75.7694'),(7,'Feroke Railway Station','Feroke Railway Station serves the southern part of Kozhikode district. It is an important stop on the ShoranurÔÇôMangalore railway line and provides access to nearby industrial and residential areas.','11.1792','75.8417');
/*!40000 ALTER TABLE `railway_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `registration`
--

DROP TABLE IF EXISTS `registration`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `registration` (
  `reg_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `email` varchar(50) NOT NULL,
  `login_id` int DEFAULT NULL,
  PRIMARY KEY (`reg_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `registration`
--

LOCK TABLES `registration` WRITE;
/*!40000 ALTER TABLE `registration` DISABLE KEYS */;
/*!40000 ALTER TABLE `registration` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `res_food`
--

DROP TABLE IF EXISTS `res_food`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `res_food` (
  `id` int NOT NULL AUTO_INCREMENT,
  `dish` varchar(50) NOT NULL,
  `category` varchar(50) NOT NULL,
  `veg` varchar(50) NOT NULL,
  `non_veg` varchar(50) NOT NULL,
  `price` int NOT NULL,
  `res_id` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `res_food`
--

LOCK TABLES `res_food` WRITE;
/*!40000 ALTER TABLE `res_food` DISABLE KEYS */;
INSERT INTO `res_food` VALUES (3,'chicken soup','Soup','Non-Veg','Non-Veg',330,17),(4,'chicken soup','Soup','Non-Veg','Non-Veg',200,17),(5,'chicken soup','Soup','Vegetarian','Vegetarian',200,17),(6,'chicken soup','Soup','Non-Veg','Non-Veg',500,17),(7,'chicken soup','Soup','Non-Veg','Non-Veg',500,17),(8,'chicken soup','Soup','Non-Veg','Non-Veg',330,17),(9,'chicken soup','Soup','Vegetarian','Vegetarian',500,17),(10,'chicken soup','Soup','Vegetarian','Vegetarian',500,17);
/*!40000 ALTER TABLE `res_food` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `res_room`
--

DROP TABLE IF EXISTS `res_room`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `res_room` (
  `id` int NOT NULL AUTO_INCREMENT,
  `room_details` varchar(50) NOT NULL,
  `occupancy` varchar(50) NOT NULL,
  `price` int NOT NULL,
  `room_des` text,
  `photo` varchar(255) NOT NULL,
  `res_id` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `res_room`
--

LOCK TABLES `res_room` WRITE;
/*!40000 ALTER TABLE `res_room` DISABLE KEYS */;
INSERT INTO `res_room` VALUES (4,'Suit Room','Single Occupancy',3500,'bhbhbkjbkj','im.avif',5),(6,'Executive Room','Double Occupancy',3500,' b nm nm nm nm ','bmh.jpg',5);
/*!40000 ALTER TABLE `res_room` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `res_workingtime`
--

DROP TABLE IF EXISTS `res_workingtime`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `res_workingtime` (
  `id` int NOT NULL AUTO_INCREMENT,
  `morning_hrs` varchar(50) NOT NULL,
  `evng_hrs` varchar(50) NOT NULL,
  `res_id` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `res_workingtime`
--

LOCK TABLES `res_workingtime` WRITE;
/*!40000 ALTER TABLE `res_workingtime` DISABLE KEYS */;
INSERT INTO `res_workingtime` VALUES (10,'14:21','17:19',18),(11,'15:32','13:34',18),(12,'14:35','15:35',18),(14,'23:03','20:02',17),(15,'23:03','20:02',17);
/*!40000 ALTER TABLE `res_workingtime` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `restaurant_details`
--

DROP TABLE IF EXISTS `restaurant_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `restaurant_details` (
  `res_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `place` varchar(50) NOT NULL,
  `post` varchar(50) NOT NULL,
  `nearby` varchar(50) NOT NULL,
  `contact` varchar(20) NOT NULL,
  `latitude` varchar(50) NOT NULL,
  `longitude` varchar(50) NOT NULL,
  `image` varchar(255) NOT NULL,
  `login_id` int NOT NULL,
  PRIMARY KEY (`res_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `restaurant_details`
--

LOCK TABLES `restaurant_details` WRITE;
/*!40000 ALTER TABLE `restaurant_details` DISABLE KEYS */;
INSERT INTO `restaurant_details` VALUES (8,'Paragon Restaurant','Mavoor Road','Kozhikode','KSRTC Bus Stand','04952702456','11.2588','75.7804','paragon.webp',33),(9,'Rahmath Hotel','Palayam','Kozhikode','SM Street','04952721402','11.2565','75.7800','rahmath_hotel.webp',34);
/*!40000 ALTER TABLE `restaurant_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `shop_details`
--

DROP TABLE IF EXISTS `shop_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shop_details` (
  `shop_id` int NOT NULL AUTO_INCREMENT,
  `shop_type` varchar(50) NOT NULL,
  `name` varchar(50) NOT NULL,
  `place` varchar(50) NOT NULL,
  `post` varchar(50) NOT NULL,
  `pincode` int NOT NULL,
  `contact` varchar(20) NOT NULL,
  `opens` varchar(50) NOT NULL,
  `closes` varchar(50) NOT NULL,
  `login_id` int NOT NULL,
  PRIMARY KEY (`shop_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shop_details`
--

LOCK TABLES `shop_details` WRITE;
/*!40000 ALTER TABLE `shop_details` DISABLE KEYS */;
INSERT INTO `shop_details` VALUES (5,'Hyper market','LuLu Hypermarket','Mankave','Kozhikode',673007,'04956631000','09:00 AM','11:00 PM',31),(6,'Fish market','Beypore Fish Market','Beypore','Kozhikode',673015,'04952415000','05:00 AM','07:00 PM',32);
/*!40000 ALTER TABLE `shop_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `taxi_details`
--

DROP TABLE IF EXISTS `taxi_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `taxi_details` (
  `taxi_id` int NOT NULL AUTO_INCREMENT,
  `type` varchar(50) NOT NULL,
  `place` varchar(50) NOT NULL,
  `contact_person` varchar(50) NOT NULL,
  `contact_no` varchar(20) NOT NULL,
  PRIMARY KEY (`taxi_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `taxi_details`
--

LOCK TABLES `taxi_details` WRITE;
/*!40000 ALTER TABLE `taxi_details` DISABLE KEYS */;
INSERT INTO `taxi_details` VALUES (6,'car','Tazhekkod','Smart Taxi Office','9895053565'),(7,'car','Govindapuram','Calicut Taxi Service','9497111019');
/*!40000 ALTER TABLE `taxi_details` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-13 19:19:15
