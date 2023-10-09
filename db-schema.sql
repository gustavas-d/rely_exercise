-- MySQL dump 10.13  Distrib 8.0.34, for Win64 (x86_64)
--
-- Host: localhost    Database: apotek_rely1
-- ------------------------------------------------------
-- Server version	8.0.34

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
-- Table structure for table `business_units`
--

DROP TABLE IF EXISTS `business_units`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `business_units` (
  `unit_id` smallint NOT NULL,
  `unit_name` varchar(28) NOT NULL,
  `unit_type_code` varchar(28) NOT NULL,
  `address_type_code` varchar(20) DEFAULT NULL,
  `address_line` varchar(100) DEFAULT NULL,
  `city` varchar(80) DEFAULT NULL,
  `territory` varchar(50) DEFAULT NULL,
  `postal_code` varchar(12) DEFAULT NULL,
  `country` varchar(56) DEFAULT NULL,
  `phone_area_code` varchar(3) DEFAULT NULL,
  `local_no` varchar(16) DEFAULT NULL,
  `extension_no` varchar(16) DEFAULT NULL,
  `itu_country_code` varchar(4) DEFAULT NULL,
  `website` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`unit_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `business_units`
--

LOCK TABLES `business_units` WRITE;
/*!40000 ALTER TABLE `business_units` DISABLE KEYS */;
INSERT INTO `business_units` VALUES (3000,'lalala','lalala',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(3004,'lalala','lalala',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `business_units` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `currencies`
--

DROP TABLE IF EXISTS `currencies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `currencies` (
  `currency_code` varchar(3) NOT NULL,
  `currency_name` tinytext NOT NULL,
  `foreign_currency` tinyint(1) NOT NULL,
  `currency_rate` decimal(10,5) DEFAULT NULL,
  PRIMARY KEY (`currency_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `currencies`
--

LOCK TABLES `currencies` WRITE;
/*!40000 ALTER TABLE `currencies` DISABLE KEYS */;
INSERT INTO `currencies` VALUES ('SEK','SEK',0,NULL);
/*!40000 ALTER TABLE `currencies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `items`
--

DROP TABLE IF EXISTS `items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `items` (
  `rsid` varchar(16) NOT NULL,
  `gtin` varchar(16) NOT NULL,
  `unit_cost` decimal(10,5) DEFAULT NULL,
  `suggested_price` decimal(10,5) DEFAULT NULL,
  `extended_ammount` decimal(10,5) DEFAULT NULL,
  `short_desc` varchar(16) NOT NULL,
  `in_stock` tinyint(1) NOT NULL,
  `quantity` smallint DEFAULT NULL,
  PRIMARY KEY (`rsid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `items`
--

LOCK TABLES `items` WRITE;
/*!40000 ALTER TABLE `items` DISABLE KEYS */;
INSERT INTO `items` VALUES ('100000','100000',NULL,NULL,NULL,'stuff',1,NULL),('100060','100060',NULL,NULL,NULL,'stuff',1,NULL),('12302','7046265478027',NULL,NULL,NULL,'stuff',1,NULL);
/*!40000 ALTER TABLE `items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `operators`
--

DROP TABLE IF EXISTS `operators`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `operators` (
  `operator_id` varchar(20) NOT NULL,
  `associate_id` varchar(20) DEFAULT NULL,
  `operator_type` varchar(20) DEFAULT NULL,
  `operator_name` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`operator_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `operators`
--

LOCK TABLES `operators` WRITE;
/*!40000 ALTER TABLE `operators` DISABLE KEYS */;
INSERT INTO `operators` VALUES ('1234',NULL,NULL,NULL),('cashierid',NULL,NULL,NULL),('xstse04',NULL,NULL,NULL);
/*!40000 ALTER TABLE `operators` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `receipts`
--

DROP TABLE IF EXISTS `receipts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `receipts` (
  `transaction_id` char(28) NOT NULL,
  `receipt_text` mediumtext,
  `receipt_image` mediumblob,
  PRIMARY KEY (`transaction_id`),
  CONSTRAINT `receipts_ibfk_1` FOREIGN KEY (`transaction_id`) REFERENCES `transactions` (`transaction_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `receipts`
--

LOCK TABLES `receipts` WRITE;
/*!40000 ALTER TABLE `receipts` DISABLE KEYS */;
INSERT INTO `receipts` VALUES ('1907220000300049014037042000','\n\rApotek Rely\n\r\n\rSvetsarvägen 16, 171 93 Solna\n\rwww.relyits.se\n\r\n\r------------------------------------------\n\rKvitto:   037-00004      2019-07-22 13:36:54\n\rKassör:   xstse04\n\rOrg Nr:   5566196704 kr\n\r------------------------------------------\n\r\n\r\n\r   *** Makulerat ***\n\r\n\r\n\r12302 OVESTERIN, VAGITOR  33,48\n\r\n\r   *** Makulerat ***\n\r ===========\n\r  TOTALT MAKULERAT 33,48\n\r\n\r  Moms       Belopp   Netto      Brutto   \n\r   0%                 33,48      33,48    \n\r------------------------------------------\n\rKVITTENS AV MAKULERING\n\r\n\r__________________________________________\n\rKundens signatur\n\r__________________________________________\n\rKassörens signatur\n\r\n\r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GZIP',_binary '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GZIP'),('1907220000300061020010362000','\n\rApotek Rely\n\r\n\rSvetsarvägen 16, 171 93 Solna\n\rwww.relyits.se\n\r------------------------------------------\n\rKvitto:   010-02536    2019-07-22 16:57:00\n\rKassör:   cashierid\n\rOrg Nr:   556619-6704 kr\n\r------------------------------------------\n\r\n\r\n\r\n\rVaror:  99880400003157\n\r100060 FÖRSKOTTSBETALNING  384,15\n\r  ===========\n\r  ATT BETALA ( 1 ARTIKEL ) 384,15\n\r\n\r  AVRUNDNING -0,15\n\r  KONTANT 384,00\n\r\n\r  TILLBAKA 0,00\n\r\n\r\n\r  Moms       Belopp   Netto      Brutto   \n\r   0%                 384,15     384,15   \n\r\n\r\n\rÖPPETTIDER:\n\rALLA DAGAR 7-22\n\rÖppet köp i 14 dagar mot kvitto.\n\rReceptvaror, receptfria läkemedel,\n\rkylvaror och bruten frp återköpes ej.\n\rTACK OCH VÄLKOMMEN ÅTER!\n\rAPOTEK Rely KUNDKONTAKT: 0771-405 405\n\r\n\r9000030000010025369272\n\r\n\r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',_binary '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'),('1907220000300062098010412000','\n\rApotek Rely\n\r\n\rSvetsarvägen 16, 171 93 Solna\n\rwww.relyits.se\n\r------------------------------------------\n\rKvitto:   010-02541    2019-07-22 17:14:58\n\rKassör:   cashierid\n\rOrg Nr:   556619-6704 kr\n\r------------------------------------------\n\r\n\r\n\r\n\rVaror:  99880400003158\n\r100060 FÖRSKOTTSBETALNING  79,00\n\r  ===========\n\r  ATT BETALA ( 1 ARTIKEL ) 79,00\n\r\n\r  KONTANT 79,00\n\r\n\r  TILLBAKA 0,00\n\r\n\r\n\r  Moms       Belopp   Netto      Brutto   \n\r   0%                 79,00      79,00    \n\r\n\r\n\rÖPPETTIDER:\n\rALLA DAGAR 7-22\n\rÖppet köp i 14 dagar mot kvitto.\n\rReceptvaror, receptfria läkemedel,\n\rkylvaror och bruten frp återköpes ej.\n\rTACK OCH VÄLKOMMEN ÅTER!\n\rAPOTEK Rely KUNDKONTAKT: 0771-405 405\n\r\n\r9000030000010025419272\n\r\n\r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GZIP',_binary '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GZIP'),('1907220000300457201001192000','\n\rApotek Rely\n\r\n\r\n\rSvetsarvägen 16, 171 93 Solna\n\rwww.relyits.se\n\r------------------------------------------\n\rKvitto:   001-03619    2019-07-22 15:53:21\n\rKassör:   1234\n\rOrg Nr:   556619-6704 kr\n\r------------------------------------------\n\r\n\r\n\r\n\rVaror:  998803100000233\n\r100000 RECEPTVAROR 0%      22 041,88\n\r  ===========\n\r  ATT BETALA ( 1 ARTIKEL ) 22 041,88\n\r\n\r  AVRUNDNING 0,12\n\r  KONTANT 22 042,00\n\r\n\r  TILLBAKA 0,00\n\r\n\r\n\r  Moms       Belopp   Netto      Brutto   \n\r   0%                 22 041,88  22 041,88\n\r\n\r\n\rÖPPETTIDER: MÅ-FR: 10.00-19.00\n\rLÖ: 10-17 SÖ: 11-17\n\rÖppet köp i 14 dagar mot kvitto.\n\rReceptvaror, receptfria läkemedel,\n\rkylvaror och bruten frp återköpes ej.\n\rTACK OCH VÄLKOMMEN ÅTER!\n\rAPOTEK Rely KUNDKONTAKT: 0771-405 405\n\r\n\r9000030040001036199272\n\r\n\r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',_binary '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'),('1907220000300459942001222000','\n\rApotek Rely\n\r\n\r\n\rSvetsarvägen 16, 171 93 Solna\n\rwww.relyits.se\n\r------------------------------------------\n\rKvitto:   001-03622    2019-07-22 16:39:02\n\rKassör:   1234\n\rOrg Nr:   556619-6704 kr\n\r------------------------------------------\n\r\n\r\n\r\n\rVaror:  998803100000234\n\r100000 RECEPTVAROR 0%      196,89\n\r  ===========\n\r  ATT BETALA ( 1 ARTIKEL ) 196,89\n\r\n\r  AVRUNDNING 0,11\n\r  KONTANT 197,00\n\r\n\r  TILLBAKA 0,00\n\r\n\r\n\r  Moms       Belopp   Netto      Brutto   \n\r   0%                 196,89     196,89   \n\r\n\r\n\rÖPPETTIDER: MÅ-FR: 10.00-19.00\n\rLÖ: 10-17 SÖ: 11-17\n\rÖppet köp i 14 dagar mot kvitto.\n\rReceptvaror, receptfria läkemedel,\n\rkylvaror och bruten frp återköpes ej.\n\rTACK OCH VÄLKOMMEN ÅTER!\n\rAPOTEK Rely KUNDKONTAKT: 0771-405 405\n\r\n\r9000030040001036229272\n\r\n\r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GZIP',_binary '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GZIP');
/*!40000 ALTER TABLE `receipts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tax_groups`
--

DROP TABLE IF EXISTS `tax_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tax_groups` (
  `tax_group_id` varchar(12) NOT NULL,
  `tax_subtype` varchar(12) DEFAULT NULL,
  `amount` decimal(8,5) NOT NULL,
  `percent` decimal(5,2) NOT NULL,
  PRIMARY KEY (`tax_group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tax_groups`
--

LOCK TABLES `tax_groups` WRITE;
/*!40000 ALTER TABLE `tax_groups` DISABLE KEYS */;
INSERT INTO `tax_groups` VALUES ('04999',NULL,10.00000,10.00),('4999',NULL,10.00000,10.00);
/*!40000 ALTER TABLE `tax_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tenders`
--

DROP TABLE IF EXISTS `tenders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tenders` (
  `tender_id` smallint NOT NULL,
  `type_code` varchar(10) NOT NULL,
  `tender_type` varchar(20) NOT NULL,
  `rounding_direction` varchar(4) DEFAULT NULL,
  `rounding_multiple` decimal(10,5) DEFAULT NULL,
  `rounding_threshold` decimal(10,5) DEFAULT NULL,
  PRIMARY KEY (`tender_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tenders`
--

LOCK TABLES `tenders` WRITE;
/*!40000 ALTER TABLE `tenders` DISABLE KEYS */;
INSERT INTO `tenders` VALUES (1,'stuff','stuff',NULL,NULL,NULL);
/*!40000 ALTER TABLE `tenders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `transaction_sale_items`
--

DROP TABLE IF EXISTS `transaction_sale_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `transaction_sale_items` (
  `transaction_id` char(28) NOT NULL,
  `cancel_flag` tinyint(1) NOT NULL,
  `entry_method` varchar(8) DEFAULT NULL,
  `item_subtype` varchar(10) DEFAULT NULL,
  `item_type` varchar(16) NOT NULL,
  `gtin` varchar(16) NOT NULL,
  `rsid` varchar(16) NOT NULL,
  `merchandise_group` smallint DEFAULT NULL,
  `special_order_no` varchar(16) DEFAULT NULL,
  `short_description` varchar(32) DEFAULT NULL,
  `unit_cost_price` decimal(10,2) DEFAULT NULL,
  `suggested_price` decimal(10,2) DEFAULT NULL,
  `extended_amount` decimal(10,2) DEFAULT NULL,
  `quantity` decimal(10,5) DEFAULT NULL,
  `units` decimal(10,2) DEFAULT NULL,
  `unit_of_measure` char(2) DEFAULT NULL,
  `tax_group_id` varchar(12) DEFAULT NULL,
  `loyalty_type` varchar(28) DEFAULT NULL,
  `loyalty_points` smallint DEFAULT NULL,
  `price_type` smallint DEFAULT NULL,
  `sequence_no` smallint NOT NULL,
  `dt` datetime NOT NULL,
  PRIMARY KEY (`transaction_id`,`sequence_no`),
  KEY `tax_group_id` (`tax_group_id`),
  KEY `rsid` (`rsid`),
  CONSTRAINT `transaction_sale_items_ibfk_1` FOREIGN KEY (`transaction_id`) REFERENCES `transactions` (`transaction_id`),
  CONSTRAINT `transaction_sale_items_ibfk_2` FOREIGN KEY (`tax_group_id`) REFERENCES `tax_groups` (`tax_group_id`),
  CONSTRAINT `transaction_sale_items_ibfk_3` FOREIGN KEY (`rsid`) REFERENCES `items` (`rsid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transaction_sale_items`
--

LOCK TABLES `transaction_sale_items` WRITE;
/*!40000 ALTER TABLE `transaction_sale_items` DISABLE KEYS */;
INSERT INTO `transaction_sale_items` VALUES ('1907220000300049014037042000',0,'Keyed','Normal','Stock','7046265478027','12302',271,NULL,'OVESTERIN, VAGITORIUM 0',33.48,33.48,33.48,1.00000,0.00,'EA','4999','VRExt:LoyaltyEligible',0,1001,1,'2019-07-22 13:35:38'),('1907220000300061020010362000',0,'Keyed','Normal','VRExt:RXBag','100060','100060',651,'99880400003157','FÖRSKOTTSBETALNING',384.15,384.15,384.15,1.00000,0.00,'EA','4999','VRExt:LoyaltyEligible',0,1002,1,'2019-07-22 16:55:40'),('1907220000300062098010412000',0,'Keyed','Normal','VRExt:RXBag','100060','100060',651,'99880400003158','FÖRSKOTTSBETALNING',79.00,79.00,79.00,1.00000,0.00,'EA','4999','VRExt:LoyaltyEligible',0,1002,1,'2019-07-22 17:14:26'),('1907220000300457201001192000',0,'Keyed','Normal','VRExt:RXBag','100000','100000',610,'998803100000233','RECEPTVAROR 0%',22041.88,22041.88,22041.88,1.00000,0.00,'EA','4999','VRExt:LoyaltyEligible',0,0,1,'2019-07-22 15:53:11'),('1907220000300459942001222000',0,'Keyed','Normal','VRExt:RXBag','100000','100000',610,'998803100000234','RECEPTVAROR 0%',196.89,196.89,196.89,1.00000,0.00,'EA','4999','VRExt:LoyaltyEligible',0,0,1,'2019-07-22 16:38:57');
/*!40000 ALTER TABLE `transaction_sale_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `transactions`
--

DROP TABLE IF EXISTS `transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `transactions` (
  `transaction_id` char(28) NOT NULL,
  `zero_sales` tinyint(1) DEFAULT NULL,
  `unit_id` smallint NOT NULL,
  `workstation_id` smallint NOT NULL,
  `operator_id` varchar(20) NOT NULL,
  `sequence_no` smallint DEFAULT NULL,
  `currency_code` varchar(3) NOT NULL,
  `transaction_status` varchar(8) NOT NULL,
  `tender_id` smallint DEFAULT NULL,
  `sale_amount` decimal(20,5) DEFAULT NULL,
  `rounding` decimal(10,5) DEFAULT NULL,
  `net_amount` decimal(20,5) NOT NULL,
  `tax_amount` decimal(20,5) DEFAULT NULL,
  `vat_rate` decimal(5,2) DEFAULT NULL,
  `vat_amount` decimal(20,5) DEFAULT NULL,
  `begin_dt` datetime NOT NULL,
  `end_dt` datetime NOT NULL,
  PRIMARY KEY (`transaction_id`),
  KEY `unit_id` (`unit_id`),
  KEY `workstation_id` (`workstation_id`),
  KEY `operator_id` (`operator_id`),
  KEY `currency_code` (`currency_code`),
  KEY `tender_id` (`tender_id`),
  CONSTRAINT `transactions_ibfk_1` FOREIGN KEY (`unit_id`) REFERENCES `business_units` (`unit_id`),
  CONSTRAINT `transactions_ibfk_2` FOREIGN KEY (`workstation_id`) REFERENCES `workstations` (`workstation_id`),
  CONSTRAINT `transactions_ibfk_3` FOREIGN KEY (`operator_id`) REFERENCES `operators` (`operator_id`),
  CONSTRAINT `transactions_ibfk_4` FOREIGN KEY (`currency_code`) REFERENCES `currencies` (`currency_code`),
  CONSTRAINT `transactions_ibfk_5` FOREIGN KEY (`tender_id`) REFERENCES `tenders` (`tender_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transactions`
--

LOCK TABLES `transactions` WRITE;
/*!40000 ALTER TABLE `transactions` DISABLE KEYS */;
INSERT INTO `transactions` VALUES ('1907220000300049014037042000',1,3000,37,'xstse04',4,'SEK','Canceled',NULL,NULL,NULL,0.00000,NULL,NULL,NULL,'2019-07-22 13:35:38','2019-07-22 13:36:54'),('1907220000300061020010362000',0,3000,10,'cashierid',2536,'SEK','Finished',NULL,NULL,0.15000,384.15000,0.00000,0.00,0.00000,'2019-07-22 16:55:40','2019-07-22 16:57:00'),('1907220000300062098010412000',0,3000,10,'cashierid',2541,'SEK','Finished',NULL,NULL,NULL,79.00000,0.00000,0.00,0.00000,'2019-07-22 17:14:26','2019-07-22 17:14:58'),('1907220000300457201001192000',0,3004,1,'1234',3619,'SEK','Finished',NULL,NULL,0.12000,22041.88000,0.00000,0.00,0.00000,'2019-07-22 15:53:11','2019-07-22 15:53:21'),('1907220000300459942001222000',0,3004,1,'1234',3622,'SEK','Finished',NULL,NULL,0.11000,196.89000,0.00000,0.00,0.00000,'2019-07-22 16:38:57','2019-07-22 16:39:02');
/*!40000 ALTER TABLE `transactions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `workstations`
--

DROP TABLE IF EXISTS `workstations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `workstations` (
  `workstation_id` smallint NOT NULL,
  `workstation_location` smallint DEFAULT NULL,
  `type_code` varchar(8) DEFAULT NULL,
  `workstation_mode` varchar(12) DEFAULT NULL,
  PRIMARY KEY (`workstation_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `workstations`
--

LOCK TABLES `workstations` WRITE;
/*!40000 ALTER TABLE `workstations` DISABLE KEYS */;
INSERT INTO `workstations` VALUES (1,NULL,NULL,NULL),(10,NULL,NULL,NULL),(37,NULL,NULL,NULL);
/*!40000 ALTER TABLE `workstations` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-10-09 18:07:43
