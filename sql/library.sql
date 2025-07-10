-- MySQL dump 10.13  Distrib 8.0.40, for Win64 (x86_64)
--
-- Host: localhost    Database: library
-- ------------------------------------------------------
-- Server version	8.4.3

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `books`
--

DROP TABLE IF EXISTS `books`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `books` (
                         `id` int NOT NULL AUTO_INCREMENT,
                         `title` varchar(255) NOT NULL,
                         `author` varchar(255) NOT NULL,
                         `type` varchar(50) NOT NULL,
                         `is_favorite` tinyint(1) DEFAULT '0',
                         `quantity` int DEFAULT '1',
                         PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=45 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `books`
--

LOCK TABLES `books` WRITE;
/*!40000 ALTER TABLE `books` DISABLE KEYS */;
INSERT INTO `books` VALUES (1,'Tôi thấy hoa vàng trên cỏ xanh','Nguyễn Nhật Ánh','Printed',1,1),(2,'Tuổi trẻ đáng giá bao nhiêu?','Rosie Nguyễn','Printed',0,1),(3,'Đắc nhân tâm','Dale Carnegie','Printed',0,2),(5,'Cho tôi xin một vé đi tuổi thơ','Nguyễn Nhật Ánh','Printed',0,1),(6,'Người Nam Châm - Bí mật của luật hấp dẫn','Jack Canfield','Printed',0,333),(7,'Quẳng gánh lo đi và vui sống','Dale Carnegie','Printed',0,6),(8,'Bên thắng cuộc','Huy Đức','Printed',0,1),(9,'Số đỏ','Vũ Trọng Phụng','Printed',0,5),(10,'Tắt đèn','Ngô Tất Tố','Printed',0,1),(11,'Lão Hạc','Nam Cao','Printed',0,1),(12,'Sách Mẫu Printed','Tác giả A','Printed',0,1),(13,'Clean Code: A Handbook of Agile Software Craftsmanship','Robert C. Martin','EBook',1,1),(15,'Spring Boot Guide','Craig Walls','EBook',1,1),(39,'3','3','Printed',0,3),(40,'31','312','Printed',0,3),(41,'3','1','Printed',0,1),(42,'3','1','Printed',0,1),(44,'3','12','Printed',1,3);
/*!40000 ALTER TABLE `books` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `loans`
--

DROP TABLE IF EXISTS `loans`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `loans` (
                         `id` int NOT NULL AUTO_INCREMENT,
                         `book_id` int NOT NULL,
                         `member_id` int NOT NULL,
                         `borrow_date` date NOT NULL,
                         `return_date` date DEFAULT NULL,
                         `due_date` date NOT NULL,
                         `overdue_fee` decimal(10,2) DEFAULT '0.00',
                         `fee_strategy` varchar(20) DEFAULT NULL,
                         PRIMARY KEY (`id`),
                         KEY `member_id` (`member_id`),
                         KEY `loans_ibfk_1` (`book_id`),
                         CONSTRAINT `loans_ibfk_1` FOREIGN KEY (`book_id`) REFERENCES `books` (`id`) ON DELETE CASCADE,
                         CONSTRAINT `loans_ibfk_2` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=118 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `loans`
--

LOCK TABLES `loans` WRITE;
/*!40000 ALTER TABLE `loans` DISABLE KEYS */;
INSERT INTO `loans` VALUES (1,9,2,'2025-04-20','2025-06-30','2025-05-26',4.00,'daily'),(2,10,2,'2025-05-20','2025-05-30','2025-05-26',5.00,'quantity'),(3,11,2,'2025-05-20','2025-05-30','2025-05-27',3.00,'daily'),(5,5,2,'2025-05-30','2025-05-30','2025-06-13',0.00,'daily'),(6,2,2,'2025-06-02','2025-06-02','2025-06-16',0.00,'daily'),(8,2,1,'2025-06-10','2025-06-10','2025-06-24',0.00,'daily'),(10,2,2,'2025-06-10','2025-06-10','2025-06-24',0.00,'daily'),(11,2,2,'2025-06-10','2025-06-10','2025-06-24',0.00,'daily'),(12,3,2,'2025-06-10','2025-06-10','2025-06-24',0.00,'daily'),(13,6,2,'2025-06-10','2025-06-10','2025-06-24',0.00,'daily'),(14,3,1,'2025-06-10','2025-06-10','2025-06-24',0.00,'daily'),(15,2,3,'2025-06-10','2025-06-10','2025-06-24',0.00,'daily'),(17,3,3,'2025-06-10','2025-06-10','2025-06-24',0.00,'daily'),(18,3,3,'2025-06-10','2025-06-10','2025-06-24',0.00,'daily'),(19,3,2,'2025-06-10','2025-06-10','2025-06-24',0.00,'daily'),(21,6,2,'2025-06-10','2025-06-10','2025-06-24',0.00,'daily'),(22,2,2,'2025-06-10','2025-06-10','2025-06-24',0.00,'daily'),(24,3,3,'2025-06-10','2025-06-10','2025-06-24',0.00,'daily'),(25,1,2,'2025-06-30','2025-06-30','2025-07-14',0.00,'daily'),(26,2,2,'2025-06-30','2025-06-30','2025-07-14',0.00,'quantity'),(27,1,2,'2025-06-30','2025-06-30','2025-07-14',0.00,'daily'),(28,1,1,'2025-06-30','2025-06-30','2025-07-14',0.00,'daily'),(29,1,2,'2025-06-30','2025-06-30','2025-07-14',0.00,'daily'),(30,2,1,'2025-06-30','2025-06-30','2025-07-14',0.00,'daily'),(31,2,1,'2025-06-30','2025-06-30','2025-07-14',0.00,'daily'),(32,3,1,'2025-06-30','2025-06-30','2025-07-14',0.00,'daily'),(33,3,1,'2025-06-30','2025-06-30','2025-07-14',0.00,'daily'),(34,2,1,'2025-06-30','2025-06-30','2025-07-14',0.00,'daily'),(35,1,1,'2025-06-30','2025-06-30','2025-07-14',0.00,'daily'),(36,2,1,'2025-06-30','2025-06-30','2025-07-14',0.00,'daily'),(37,3,1,'2025-06-30','2025-06-30','2025-07-14',0.00,'daily'),(38,2,2,'2025-06-30','2025-06-30','2025-07-14',0.00,'daily'),(39,2,1,'2025-06-30','2025-06-30','2025-07-14',0.00,'daily'),(40,3,3,'2025-06-30','2025-06-30','2025-07-14',0.00,'daily'),(41,1,3,'2025-06-30','2025-06-30','2025-07-14',0.00,'daily'),(42,3,3,'2025-06-30','2025-06-30','2025-07-14',0.00,'daily'),(43,2,2,'2025-06-30','2025-06-30','2025-07-14',0.00,'daily'),(44,2,2,'2025-06-30','2025-06-30','2025-07-14',0.00,'daily'),(45,2,1,'2025-06-30','2025-06-30','2025-07-14',5000.00,'daily'),(46,1,2,'2025-06-30','2025-06-30','2025-07-14',5000.00,'daily'),(47,1,2,'2025-06-30','2025-06-30','2025-07-14',5000.00,'daily'),(48,2,1,'2025-06-30','2025-06-30','2025-07-14',5000.00,'daily'),(49,2,1,'2025-06-30','2025-06-30','2025-07-14',5000.00,'daily'),(50,2,1,'2025-06-30','2025-06-30','2025-07-14',5000.00,'daily'),(51,3,1,'2025-06-30','2025-06-30','2025-07-14',5000.00,'daily'),(52,1,2,'2025-06-30','2025-06-30','2025-07-14',5000.00,'daily'),(53,6,3,'2025-06-30','2025-06-30','2025-07-14',5000.00,'daily'),(54,2,1,'2025-06-30','2025-06-30','2025-07-14',5000.00,'daily'),(55,2,1,'2025-06-30','2025-06-30','2025-07-14',5000.00,'daily'),(56,1,2,'2025-06-30','2025-12-20','2025-07-14',0.00,'daily'),(57,3,1,'2025-05-30','2025-06-30','2025-07-14',160000.00,'daily'),(58,1,2,'2025-06-30','2025-06-30','2025-07-14',5000.00,'daily'),(59,2,2,'2025-06-30','2025-06-30','2025-07-14',5000.00,'daily'),(60,2,1,'2025-06-30','2025-06-30','2025-07-14',30000.00,'quantity'),(61,2,1,'2025-06-30','2025-06-30','2025-07-14',30000.00,'quantity'),(62,1,3,'2025-06-30','2025-06-30','2025-07-14',30000.00,'quantity'),(63,2,2,'2025-06-30','2025-06-30','2025-07-14',5000.00,'daily'),(64,2,2,'2025-06-30','2025-06-30','2025-07-14',5000.00,'daily'),(65,1,2,'2025-06-30','2025-06-30','2025-07-14',5000.00,'daily'),(66,3,2,'2025-06-30','2025-06-30','2025-07-14',5000.00,'daily'),(67,3,2,'2025-06-30','2025-06-30','2025-07-14',5000.00,'daily'),(68,3,2,'2025-06-30','2025-06-30','2025-07-14',5000.00,'daily'),(69,3,2,'2025-06-30','2025-06-30','2025-07-14',5000.00,'daily'),(70,2,2,'2025-06-30','2025-06-30','2025-07-14',5000.00,'daily'),(71,2,2,'2025-06-30','2025-06-30','2025-07-14',5000.00,'daily'),(72,5,2,'2025-06-30','2025-06-30','2025-07-14',5000.00,'daily'),(73,1,2,'2025-06-30','2025-06-30','2025-07-14',5000.00,'daily'),(74,3,2,'2025-06-30','2025-06-30','2025-07-14',5000.00,'daily'),(75,3,2,'2025-06-30','2025-06-30','2025-07-14',5000.00,'daily'),(76,2,2,'2025-06-30','2025-06-30','2025-07-14',5000.00,'daily'),(77,2,1,'2025-05-01','2025-07-01','2025-07-15',310000.00,'daily'),(78,3,1,'2024-07-01','2025-07-01','2025-07-15',30000.00,'quantity'),(79,3,2,'2025-07-01','2025-07-01','2025-07-15',5000.00,'daily'),(80,8,2,'2024-07-01','2025-07-01','2025-07-15',5000.00,'daily'),(81,3,2,'2025-07-01','2025-07-01','2025-07-15',5000.00,'daily'),(82,2,2,'2025-07-01','2025-07-01','2025-07-15',5000.00,'daily'),(83,10,2,'2025-03-01','2025-07-01','2025-06-10',678000.00,'daily'),(84,3,1,'2025-07-01','2025-07-01','2025-07-15',5000.00,'daily'),(85,3,2,'2025-07-01','2025-07-01','2025-07-15',5000.00,'daily'),(86,5,2,'2025-07-01','2025-07-01','2025-07-15',5000.00,'daily'),(87,5,2,'2025-07-01','2025-07-01','2025-07-15',5000.00,'daily'),(88,3,2,'2025-07-01','2025-07-01','2025-07-15',5000.00,'daily'),(89,2,2,'2025-07-01','2025-07-01','2025-07-15',5000.00,'daily'),(90,2,3,'2025-07-01','2025-07-01','2025-07-15',5000.00,'daily'),(91,5,2,'2025-07-01','2025-07-01','2025-07-15',5000.00,'daily'),(92,3,2,'2025-07-01','2025-07-01','2025-07-15',5000.00,'daily'),(93,9,2,'2025-07-01','2025-07-01','2025-07-15',5000.00,'daily'),(94,3,2,'2025-07-01','2025-07-01','2025-07-15',5000.00,'daily'),(95,2,2,'2025-07-01','2025-07-01','2025-07-15',5000.00,'daily'),(96,6,2,'2025-07-01','2025-07-01','2025-07-15',5000.00,'daily'),(97,2,1,'2025-07-05','2025-07-05','2025-07-19',5000.00,'daily'),(98,2,2,'2025-07-06','2025-07-06','2025-07-20',5000.00,'daily'),(99,5,1,'2025-07-06','2025-07-06','2025-07-20',5000.00,'daily'),(100,2,3,'2025-07-06','2025-07-06','2025-07-20',5000.00,'daily'),(103,1,1,'2025-07-06','2025-07-06','2025-07-20',5000.00,'daily'),(104,1,3,'2025-07-06','2025-07-06','2025-07-20',5000.00,'daily'),(105,2,2,'2025-07-06','2025-07-06','2025-07-20',5000.00,'daily'),(106,2,1,'2025-07-06','2025-07-06','2025-07-20',5000.00,'daily'),(107,2,2,'2025-07-06','2025-07-06','2025-07-20',5000.00,'daily'),(108,2,2,'2025-07-06','2025-07-06','2025-07-20',5000.00,'daily'),(109,2,2,'2025-07-06','2025-07-06','2025-07-20',5000.00,'daily'),(110,2,1,'2025-07-06','2025-07-06','2025-07-20',5000.00,'daily'),(111,2,2,'2025-07-06','2025-07-06','2025-07-20',5000.00,'daily'),(112,1,2,'2025-07-06','2025-07-06','2025-07-20',5000.00,'daily'),(113,1,2,'2025-07-06','2025-07-06','2025-07-20',5000.00,'daily'),(114,1,2,'2025-07-06','2025-07-06','2025-07-20',5000.00,'daily'),(115,2,1,'2025-07-06','2025-07-06','2025-07-20',5000.00,'daily'),(116,2,2,'2025-07-06','2025-07-06','2025-07-20',5000.00,'daily'),(117,2,2,'2025-07-06','2025-07-06','2025-07-20',5000.00,'daily');
/*!40000 ALTER TABLE `loans` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `members`
--

DROP TABLE IF EXISTS `members`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `members` (
                           `id` int NOT NULL AUTO_INCREMENT,
                           `username` varchar(50) NOT NULL,
                           `password` varchar(255) NOT NULL,
                           `full_name` varchar(255) NOT NULL,
                           `role` enum('ADMIN','MEMBER') NOT NULL,
                           PRIMARY KEY (`id`),
                           UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `members`
--

LOCK TABLES `members` WRITE;
/*!40000 ALTER TABLE `members` DISABLE KEYS */;
INSERT INTO `members` VALUES (1,'admin','admin123','Administrator','ADMIN'),(2,'1','1','Huynh Le Cong Lap','MEMBER'),(3,'2','3','2','MEMBER');
/*!40000 ALTER TABLE `members` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-07-06 18:36:03
