-- MySQL dump 10.13  Distrib 5.6.16, for debian-linux-gnu (x86_64)
--
-- Host: 127.0.0.1    Database: ambra
-- ------------------------------------------------------
-- Server version	5.6.16-1~exp1

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
-- Table structure for table `article`
--

DROP TABLE IF EXISTS `article`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `article` (
  `articleId` bigint(20) NOT NULL AUTO_INCREMENT,
  `doi` varchar(150) NOT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`articleId`),
  UNIQUE KEY `doi` (`doi`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `category`
--

DROP TABLE IF EXISTS `category`;
CREATE TABLE `category` (
  `categoryId` bigint(20) NOT NULL AUTO_INCREMENT,
  `path` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `lastModified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`categoryId`),
  UNIQUE KEY `path` (`path`)
) ENGINE=InnoDB AUTO_INCREMENT=58400 DEFAULT CHARSET=utf8;


--
-- Table structure for table `articleCategoryAssignment`
--

DROP TABLE IF EXISTS `articleCategoryAssignment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `articleCategoryAssignment` (
  `articleId` bigint(20) NOT NULL,
  `categoryId` bigint(20) NOT NULL,
  `weight` int(11) NOT NULL,
  PRIMARY KEY (`articleId`,`categoryId`),
  KEY `articleId` (`articleId`),
  KEY `categoryId` (`categoryId`),
  CONSTRAINT `fk_articleCategoryAssignment_1` FOREIGN KEY (`articleId`) REFERENCES `article` (`articleId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_articleCategoryAssignment_2` FOREIGN KEY (`categoryId`) REFERENCES `category` (`categoryID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `articleCategoryAssignmentFlag`
--

DROP TABLE IF EXISTS `articleCategoryAssignmentFlag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `articleCategoryAssignmentFlag` (
  `flagId` bigint(20) NOT NULL AUTO_INCREMENT,
  `articleId` bigint(20) NOT NULL,
  `categoryId` bigint(20) NOT NULL,
  `userProfileId` bigint(20) DEFAULT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`flagId`),
  KEY `articleId` (`articleId`),
  KEY `categoryId` (`categoryId`),
  KEY `fk_articleCategoryAssignmentFlag_1` (`articleId`,`categoryId`),
  CONSTRAINT `fk_articleCategoryAssignmentFlag_1` FOREIGN KEY (`articleId`, `categoryId`) REFERENCES `articleCategoryAssignment` (`articleId`, `categoryId`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `articleFile`
--

DROP TABLE IF EXISTS `articleFile`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `articleFile` (
  `fileId` bigint(20) NOT NULL AUTO_INCREMENT,
  `ingestionId` bigint(20) NOT NULL,
  `itemId` bigint(20) DEFAULT NULL,
  `fileType` varchar(128) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `bucketName` varchar(255) NOT NULL,
  `crepoKey` varchar(255) NOT NULL,
  `crepoUuid` varchar(36) NOT NULL,
  `fileSize` bigint(20) NOT NULL,
  `ingestedFileName` varchar(255) NOT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`fileId`),
  UNIQUE KEY `ingest_ingestedFileName` (`ingestionId`,`ingestedFileName`),
  UNIQUE KEY `crepoUuid_UNIQUE` (`crepoUuid`),
  UNIQUE KEY `ingest_item_filetype` (`ingestionId`,`itemId`,`fileType`),
  KEY `fk_articleFile_2` (`itemId`),
  CONSTRAINT `fk_articleFile_1` FOREIGN KEY (`ingestionId`) REFERENCES `articleIngestion` (`ingestionId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_articleFile_2` FOREIGN KEY (`itemId`) REFERENCES `articleItem` (`itemId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `articleIngestion`
--

DROP TABLE IF EXISTS `articleIngestion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `articleIngestion` (
  `ingestionId` bigint(20) NOT NULL AUTO_INCREMENT,
  `articleId` bigint(20) NOT NULL,
  `journalId` bigint(20) NOT NULL,
  `ingestionNumber` int(11) NOT NULL,
  `title` text NOT NULL,
  `publicationDate` date NOT NULL,
  `revisionDate` date DEFAULT NULL,
  `publicationStage` varchar(100) DEFAULT NULL,
  `articleType` varchar(100) DEFAULT NULL,
  `strikingImageItemId` bigint(20) DEFAULT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `lastModified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ingestionId`),
  UNIQUE KEY `article_ingestnum` (`articleId`,`ingestionNumber`),
  KEY `fk_articleIngestion_2` (`journalId`),
  KEY `fk_articleIngestion_3` (`strikingImageItemId`),
  CONSTRAINT `fk_articleIngestion_1` FOREIGN KEY (`articleId`) REFERENCES `article` (`articleId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_articleIngestion_2` FOREIGN KEY (`journalId`) REFERENCES `journal` (`journalId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_articleIngestion_3` FOREIGN KEY (`strikingImageItemId`) REFERENCES `articleItem` (`itemId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `articleItem`
--

DROP TABLE IF EXISTS `articleItem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `articleItem` (
  `itemId` bigint(20) NOT NULL AUTO_INCREMENT,
  `ingestionId` bigint(20) NOT NULL,
  `doi` varchar(150) NOT NULL,
  `articleItemType` varchar(128) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`itemId`),
  KEY `doi` (`doi`),
  KEY `fk_articleItem_1` (`ingestionId`),
  CONSTRAINT `fk_articleItem_1` FOREIGN KEY (`ingestionId`) REFERENCES `articleIngestion` (`ingestionId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `articleList`
--

DROP TABLE IF EXISTS `articleList`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `articleList` (
  `articleListId` bigint(20) NOT NULL AUTO_INCREMENT,
  `listKey` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `displayName` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `journalId` bigint(20) NOT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `lastModified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `listType` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`articleListId`),
  UNIQUE KEY `listIdentity` (`journalId`,`listType`,`listKey`),
  KEY `journalId` (`journalId`),
  CONSTRAINT `fk_articleList_1` FOREIGN KEY (`journalId`) REFERENCES `journal` (`journalId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `articleListJoinTable`
--

DROP TABLE IF EXISTS `articleListJoinTable`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `articleListJoinTable` (
  `articleListId` bigint(20) NOT NULL,
  `sortOrder` int(11) NOT NULL,
  `articleId` bigint(20) NOT NULL,
  PRIMARY KEY (`articleListId`,`sortOrder`),
  KEY `articleId` (`articleId`),
  CONSTRAINT `fk_articleListJoinTable_1` FOREIGN KEY (`articleListId`) REFERENCES `articleList` (`articleListId`),
  CONSTRAINT `fk_articleListJoinTable_2` FOREIGN KEY (`articleId`) REFERENCES `article` (`articleId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `articleRelationship`
--

DROP TABLE IF EXISTS `articleRelationship`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `articleRelationship` (
  `articleRelationshipId` bigint(20) NOT NULL AUTO_INCREMENT,
  `sourceArticleId` bigint(20) NOT NULL,
  `targetArticleId` bigint(20) NOT NULL,
  `type` varchar(50) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `lastModified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`articleRelationshipId`),
  KEY `sourceArticleId` (`sourceArticleId`),
  KEY `targetArticleId` (`targetArticleId`),
  CONSTRAINT `fk_articleRelationship_1` FOREIGN KEY (`sourceArticleId`) REFERENCES `article` (`articleId`),
  CONSTRAINT `fk_articleRelationship_2` FOREIGN KEY (`targetArticleId`) REFERENCES `article` (`articleId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `articleRevision`
--

DROP TABLE IF EXISTS `articleRevision`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `articleRevision` (
  `revisionId` bigint(20) NOT NULL AUTO_INCREMENT,
  `ingestionId` bigint(20) NOT NULL,
  `revisionNumber` int(11) NOT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`revisionId`),
  KEY `fk_articleRevision_1` (`ingestionId`),
  CONSTRAINT `fk_articleRevision_1` FOREIGN KEY (`ingestionId`) REFERENCES `articleIngestion` (`ingestionId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `comment`
--

DROP TABLE IF EXISTS `comment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `comment` (
  `commentId` bigint(20) NOT NULL AUTO_INCREMENT,
  `commentURI` varchar(250) CHARACTER SET utf8 NOT NULL,
  `articleId` bigint(20) NOT NULL,
  `parentId` bigint(20) DEFAULT NULL,
  `userProfileId` bigint(20) NOT NULL,
  `title` mediumtext COLLATE utf8_unicode_ci,
  `body` mediumtext COLLATE utf8_unicode_ci,
  `competingInterestBody` mediumtext COLLATE utf8_unicode_ci,
  `highlightedText` mediumtext COLLATE utf8_unicode_ci,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `lastModified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `isRemoved` bit(1) DEFAULT b'0',
  PRIMARY KEY (`commentId`),
  UNIQUE KEY `commentURI` (`commentURI`),
  KEY `fk_comment_1` (`articleId`),
  KEY `fk_comment_2` (`parentId`),
  KEY `userProfileID` (`userProfileId`),
  CONSTRAINT `fk_comment_1` FOREIGN KEY (`articleId`) REFERENCES `article` (`articleId`),
  CONSTRAINT `fk_comment_2` FOREIGN KEY (`parentId`) REFERENCES `comment` (`commentId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `commentFlag`
--

DROP TABLE IF EXISTS `commentFlag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `commentFlag` (
  `commentFlagId` bigint(20) NOT NULL AUTO_INCREMENT,
  `commentId` bigint(20) NOT NULL,
  `userProfileId` bigint(20) NOT NULL,
  `reason` varchar(25) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `comment` text CHARACTER SET utf8 COLLATE utf8_bin,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `lastModified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`commentFlagId`),
  KEY `commentId` (`commentId`),
  KEY `userProfileId` (`userProfileId`),
  CONSTRAINT `fk_commentFlag_1` FOREIGN KEY (`commentId`) REFERENCES `comment` (`commentId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `issue`
--

DROP TABLE IF EXISTS `issue`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `issue` (
  `issueId` bigint(20) NOT NULL AUTO_INCREMENT,
  `doi` varchar(150) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `volumeId` bigint(20) NOT NULL,
  `volumeSortOrder` int(11) NOT NULL,
  `displayName` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `imageArticleId` bigint(20) DEFAULT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `lastModified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`issueId`),
  UNIQUE KEY `doi` (`doi`),
  KEY `volumeId` (`volumeId`),
  KEY `fk_issue_2` (`imageArticleId`),
  CONSTRAINT `fk_issue_1` FOREIGN KEY (`volumeId`) REFERENCES `volume` (`volumeId`),
  CONSTRAINT `fk_issue_2` FOREIGN KEY (`imageArticleId`) REFERENCES `article` (`articleId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `issueArticleList`
--

DROP TABLE IF EXISTS `issueArticleList`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `issueArticleList` (
  `issueId` bigint(20) NOT NULL,
  `sortOrder` int(11) NOT NULL,
  `articleId` bigint(20) NOT NULL,
  PRIMARY KEY (`issueId`,`articleId`),
  KEY `fk_issueArticleList_2` (`articleId`),
  CONSTRAINT `fk_issueArticleList_1` FOREIGN KEY (`issueId`) REFERENCES `issue` (`issueId`),
  CONSTRAINT `fk_issueArticleList_2` FOREIGN KEY (`articleId`) REFERENCES `article` (`articleId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `journal`
--

DROP TABLE IF EXISTS `journal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `journal` (
  `journalId` bigint(20) NOT NULL AUTO_INCREMENT,
  `currentIssueId` bigint(20) DEFAULT NULL,
  `journalKey` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `eIssn` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `title` varchar(500) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `lastModified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`journalId`),
  KEY `journal_ibfk_1_idx` (`currentIssueId`),
  CONSTRAINT `fk_journal_1` FOREIGN KEY (`currentIssueId`) REFERENCES `issue` (`issueId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `syndication`
--

DROP TABLE IF EXISTS `syndication`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `syndication` (
  `syndicationId` bigint(20) NOT NULL AUTO_INCREMENT,
  `revisionId` bigint(20) NOT NULL,
  `targetQueue` varchar(50) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `status` varchar(50) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `submissionCount` int(11) DEFAULT NULL,
  `errorMessage` longtext CHARACTER SET utf8 COLLATE utf8_bin,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `lastSubmitTimestamp` timestamp NULL DEFAULT NULL,
  `lastModified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`syndicationId`),
  UNIQUE KEY `revisionId` (`revisionId`,`targetQueue`),
  CONSTRAINT `fk_syndication_1` FOREIGN KEY (`revisionId`) REFERENCES `articleRevision` (`revisionId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `version`
--

DROP TABLE IF EXISTS `version`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `version` (
  `versionID` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(25) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `version` int(11) NOT NULL,
  `updateInProcess` bit(1) NOT NULL,
  `created` datetime NOT NULL,
  `lastModified` datetime DEFAULT NULL,
  PRIMARY KEY (`versionID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `volume`
--

DROP TABLE IF EXISTS `volume`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `volume` (
  `volumeId` bigint(20) NOT NULL AUTO_INCREMENT,
  `doi` varchar(150) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `journalId` bigint(20) NOT NULL,
  `journalSortOrder` int(11) NOT NULL,
  `displayName` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `lastModified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`volumeId`),
  UNIQUE KEY `doi` (`doi`),
  KEY `journalID` (`journalId`),
  CONSTRAINT `fk_volume_1` FOREIGN KEY (`journalId`) REFERENCES `journal` (`journalId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2017-01-25 11:16:02
