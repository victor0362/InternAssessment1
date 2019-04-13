CREATE DATABASE  IF NOT EXISTS `job_board` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `job_board`;
-- MySQL dump 10.13  Distrib 5.6.24, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: job_board
-- ------------------------------------------------------
-- Server version	5.6.26-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `employer`
--

DROP TABLE IF EXISTS `employer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `employer` (
  `EmployerID` int(11) NOT NULL AUTO_INCREMENT,
  `employer` varchar(100) NOT NULL,
  PRIMARY KEY (`EmployerID`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `function_nature`
--

DROP TABLE IF EXISTS `function_nature`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `function_nature` (
  `NatureID` int(11) NOT NULL AUTO_INCREMENT,
  `Nature` varchar(45) NOT NULL,
  PRIMARY KEY (`NatureID`),
  UNIQUE KEY `NatureID_UNIQUE` (`NatureID`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary view structure for view `job`
--

DROP TABLE IF EXISTS `job`;
/*!50001 DROP VIEW IF EXISTS `job`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `job` AS SELECT 
 1 AS `JobID`,
 1 AS `Date`,
 1 AS `YearOfExp`,
 1 AS `employer`,
 1 AS `JobTitle`,
 1 AS `Requirement`,
 1 AS `Vacancies`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `job_and_job_function`
--

DROP TABLE IF EXISTS `job_and_job_function`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `job_and_job_function` (
  `JobID` varchar(20) NOT NULL,
  `JobFunctionID` int(11) NOT NULL,
  PRIMARY KEY (`JobID`,`JobFunctionID`),
  KEY `job function_idx` (`JobFunctionID`),
  CONSTRAINT `Job function` FOREIGN KEY (`JobFunctionID`) REFERENCES `job_function` (`JobFunctionID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `job` FOREIGN KEY (`JobID`) REFERENCES `job_description` (`JobID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `job_description`
--

DROP TABLE IF EXISTS `job_description`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `job_description` (
  `JobID` varchar(20) NOT NULL,
  `Date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `JobTitleID` int(11) NOT NULL,
  `EmployerID` int(11) NOT NULL,
  `Requirement` text,
  `YearOfExp` int(11) DEFAULT '0',
  `Vacancies` int(11) DEFAULT '0',
  PRIMARY KEY (`JobID`),
  UNIQUE KEY `JobID_UNIQUE` (`JobID`),
  KEY `JobTitleID_idx` (`JobTitleID`),
  KEY `EmplyerID_idx` (`EmployerID`),
  CONSTRAINT `EmployerID` FOREIGN KEY (`EmployerID`) REFERENCES `employer` (`EmployerID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `JobTitleID` FOREIGN KEY (`JobTitleID`) REFERENCES `job_title` (`JobTitleID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='contains jobID, Date, JobTitleID, EmployerID, Requirement, YearOfExp';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `job_function`
--

DROP TABLE IF EXISTS `job_function`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `job_function` (
  `JobFunctionID` int(11) NOT NULL AUTO_INCREMENT,
  `FunctionNatureID` int(11) NOT NULL,
  `JobFunctionName` varchar(45) NOT NULL,
  PRIMARY KEY (`JobFunctionID`,`FunctionNatureID`),
  UNIQUE KEY `JobFunctionID_UNIQUE` (`JobFunctionID`),
  KEY `nature_idx` (`FunctionNatureID`),
  CONSTRAINT `nature` FOREIGN KEY (`FunctionNatureID`) REFERENCES `function_nature` (`NatureID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary view structure for view `job_function_list`
--

DROP TABLE IF EXISTS `job_function_list`;
/*!50001 DROP VIEW IF EXISTS `job_function_list`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `job_function_list` AS SELECT 
 1 AS `Nature`,
 1 AS `JobFunctionID`,
 1 AS `JobFunctionName`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `job_jobnature_jobfunction`
--

DROP TABLE IF EXISTS `job_jobnature_jobfunction`;
/*!50001 DROP VIEW IF EXISTS `job_jobnature_jobfunction`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `job_jobnature_jobfunction` AS SELECT 
 1 AS `JobID`,
 1 AS `Nature`,
 1 AS `JobFunctionName`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `job_title`
--

DROP TABLE IF EXISTS `job_title`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `job_title` (
  `JobTitleID` int(11) NOT NULL AUTO_INCREMENT,
  `JobTitle` varchar(100) NOT NULL,
  PRIMARY KEY (`JobTitleID`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Final view structure for view `job`
--

/*!50001 DROP VIEW IF EXISTS `job`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `job` AS select `job_description`.`JobID` AS `JobID`,`job_description`.`Date` AS `Date`,`job_description`.`YearOfExp` AS `YearOfExp`,`employer`.`employer` AS `employer`,`job_title`.`JobTitle` AS `JobTitle`,`job_description`.`Requirement` AS `Requirement`,`job_description`.`Vacancies` AS `Vacancies` from ((`job_description` join `employer` on((`employer`.`EmployerID` = `job_description`.`EmployerID`))) join `job_title` on((`job_title`.`JobTitleID` = `job_description`.`JobTitleID`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `job_function_list`
--

/*!50001 DROP VIEW IF EXISTS `job_function_list`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `job_function_list` AS select `function_nature`.`Nature` AS `Nature`,`job_function`.`JobFunctionID` AS `JobFunctionID`,`job_function`.`JobFunctionName` AS `JobFunctionName` from (`job_function` join `function_nature` on((`job_function`.`FunctionNatureID` = `function_nature`.`NatureID`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `job_jobnature_jobfunction`
--

/*!50001 DROP VIEW IF EXISTS `job_jobnature_jobfunction`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `job_jobnature_jobfunction` AS select `job_and_job_function`.`JobID` AS `JobID`,`function_nature`.`Nature` AS `Nature`,`job_function`.`JobFunctionName` AS `JobFunctionName` from ((`job_and_job_function` join `job_function` on((`job_function`.`JobFunctionID` = `job_and_job_function`.`JobFunctionID`))) join `function_nature` on((`function_nature`.`NatureID` = `job_function`.`FunctionNatureID`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-04-13 21:56:37
