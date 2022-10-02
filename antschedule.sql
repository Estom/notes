-- MySQL dump 10.14  Distrib 5.5.68-MariaDB, for Linux (x86_64)
--
-- Host: rm-bp129eww26h32v81h.mysql.rds.aliyuncs.com    Database: antscheduler
-- ------------------------------------------------------
-- Server version       5.6.16-log

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
-- Table structure for table `activity`
--

DROP TABLE IF EXISTS `activity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `activity` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `process_id` int(11) DEFAULT NULL,
  `job_id` bigint(20) NOT NULL COMMENT '任务id',
  `type` varchar(32) DEFAULT NULL,
  `create_timestamp` varchar(20) DEFAULT NULL,
  `parallel_count` int(10) DEFAULT NULL COMMENT '网关并行执行数量',
  `disable` tinyint(2) DEFAULT '0' COMMENT '0表示可用，1表示删除',
  `gmt_create` datetime DEFAULT NULL COMMENT '创建时间',
  `gmt_modify` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`),
  KEY `idx_job_id` (`job_id`) USING BTREE,
  KEY `idx_process` (`process_id`) USING BTREE,
  KEY `idx_disable` (`disable`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `activity_event`
--

DROP TABLE IF EXISTS `activity_event`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `activity_event` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `activity_id` int(11) DEFAULT NULL COMMENT '关联拓扑任务节点id',
  `process_id` int(11) DEFAULT NULL,
  `type` varchar(128) DEFAULT NULL COMMENT '事件模型',
  `extra` varchar(128) DEFAULT NULL COMMENT '事件模型扩展',
  `disable` tinyint(2) DEFAULT '0' COMMENT '0表示可用，1表示删除',
  `gmt_create` datetime DEFAULT NULL COMMENT '创建时间',
  `gmt_modify` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unq_activity_event` (`activity_id`,`type`) USING BTREE,
  KEY `idx_process` (`process_id`) USING BTREE,
  KEY `idx_disable` (`disable`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `activity_event_instance`
--

DROP TABLE IF EXISTS `activity_event_instance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `activity_event_instance` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `event_id` int(11) DEFAULT NULL,
  `type` varchar(128) DEFAULT NULL,
  `activity_instance_id` int(11) DEFAULT NULL,
  `status` varchar(10) DEFAULT NULL,
  `wait_on_time` timestamp NULL DEFAULT NULL,
  `process_instance_id` int(11) DEFAULT NULL,
  `gmt_create` timestamp NULL DEFAULT NULL,
  `executions` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_activity_instance_type` (`activity_instance_id`,`type`) USING BTREE,
  KEY `idx_wait_on_time` (`wait_on_time`) USING BTREE,
  KEY `idx_process_instance` (`process_instance_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `activity_instance`
--

DROP TABLE IF EXISTS `activity_instance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `activity_instance` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `activity_id` int(11) DEFAULT NULL,
  `process_instance_id` int(11) DEFAULT NULL,
  `job_id` bigint(20) NOT NULL COMMENT '任务id',
  `status` varchar(16) DEFAULT NULL,
  `gmt_begin` timestamp NULL DEFAULT NULL,
  `gmt_end` timestamp NULL DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `comment` varchar(1024) DEFAULT '' COMMENT '操作备注',
  `cur_sharding` varchar(128) DEFAULT NULL COMMENT '当前分片',
  `is_need_confirm` tinyint(2) DEFAULT NULL,
  `parent_activity_instance_id` int(11) DEFAULT NULL,
  `queue_status` tinyint(2) DEFAULT '0' COMMENT '队列状态: 0-不在队列; 1-队列中; 2-出队待执行',
  `zone` varchar(60) DEFAULT NULL COMMENT '执行zone',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_process_activity_sharding` (`process_instance_id`,`activity_id`,`cur_sharding`,`parent_activity_instance_id`) USING BTREE,
  KEY `idx_gmt_begin` (`gmt_begin`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `activity_lock`
--

DROP TABLE IF EXISTS `activity_lock`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `activity_lock` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
  `process_instance_id` int(10) NOT NULL COMMENT '拓扑图执行实例id',
  `activity_id` int(10) NOT NULL COMMENT '节点id',
  `is_lock` tinyint(2) NOT NULL DEFAULT '0' COMMENT '是否加锁：0-否，1-是',
  `gmt_create` datetime NOT NULL COMMENT '创建时间',
  `cur_sharding` varchar(128) DEFAULT NULL,
  `parent_activity_instance_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_lock` (`process_instance_id`,`activity_id`,`cur_sharding`,`parent_activity_instance_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `batch_instance`
--

DROP TABLE IF EXISTS `batch_instance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `batch_instance` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `batch_id` varchar(64) NOT NULL COMMENT '请求id',
  `job_id` bigint(20) NOT NULL COMMENT '任务id',
  `status` varchar(20) NOT NULL COMMENT '状态',
  `trigger_type` varchar(20) NOT NULL COMMENT '触发类型: AUTO-自动，MANUAL-手动',
  `chunk_count` bigint(20) DEFAULT '0' COMMENT '数据库该批次的chunk总数',
  `start_time` datetime DEFAULT NULL COMMENT '开始执行时间',
  `end_time` datetime DEFAULT NULL COMMENT '结束运行时间',
  `alarm_time` datetime DEFAULT NULL COMMENT '告警时间',
  `gmt_create` datetime DEFAULT NULL COMMENT '创建时间',
  `gmt_modified` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_batch` (`start_time`,`end_time`,`job_id`) USING BTREE,
  KEY `idx_batch_id` (`batch_id`) USING BTREE,
  KEY `idx_job_id` (`job_id`,`trigger_type`) USING BTREE,
  KEY `idx_gmt_create` (`gmt_create`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `batch_item_instance`
--

DROP TABLE IF EXISTS `batch_item_instance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `batch_item_instance` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `batch_id` varchar(64) NOT NULL COMMENT '批次id',
  `request_id` varchar(64) NOT NULL COMMENT '请求id',
  `job_item_id` bigint(20) NOT NULL COMMENT 'jobItem id',
  `zone` varchar(60) NOT NULL COMMENT '执行zone',
  `success_count` bigint(20) DEFAULT '0' COMMENT '已处理的数量',
  `split_count` bigint(20) DEFAULT '0' COMMENT '总拆分数量',
  `gmt_create` datetime DEFAULT NULL COMMENT '创建时间',
  `gmt_modified` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_batch_item` (`batch_id`,`job_item_id`) USING BTREE,
  KEY `idx_request_id` (`request_id`) USING BTREE,
  KEY `idx_gmt_create` (`gmt_create`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chunk_item`
--

DROP TABLE IF EXISTS `chunk_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chunk_item` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `md5` varchar(32) DEFAULT NULL,
  `chunk_type` varchar(15) DEFAULT NULL,
  `data` text,
  `job_item_id` bigint(20) NOT NULL COMMENT '任务id',
  `request_id` varchar(64) DEFAULT NULL,
  `execute_id` varchar(64) DEFAULT NULL,
  `execute_handler` varchar(60) DEFAULT NULL,
  `generate_handler` varchar(60) DEFAULT NULL,
  `execute_client` varchar(20) DEFAULT NULL,
  `generate_client` varchar(20) DEFAULT NULL,
  `persistent_server` varchar(20) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `sharding_rule` varchar(200) DEFAULT NULL,
  `parent_id` int(32) DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `try_count` int(11) DEFAULT NULL,
  `gmt_begin` datetime DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `callback_id` varchar(100) DEFAULT NULL,
  `digest` varchar(30) DEFAULT NULL COMMENT '执行摘要',
  `extension` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`) USING BTREE,
  KEY `idx_persist_status` (`persistent_server`,`status`) USING BTREE,
  KEY `idx_request_status` (`request_id`,`status`) USING BTREE,
  KEY `idx_request_execute_sharding` (`request_id`,`execute_handler`,`sharding_rule`) USING BTREE,
  KEY `idx_request_execute_client` (`request_id`,`execute_client`,`callback_id`) USING BTREE,
  KEY `idx_execute_status` (`execute_id`,`status`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chunk_item_000`
--

DROP TABLE IF EXISTS `chunk_item_000`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chunk_item_000` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `md5` varchar(32) DEFAULT NULL,
  `chunk_type` varchar(15) DEFAULT NULL,
  `data` text,
  `job_item_id` int(11) DEFAULT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `execute_id` varchar(64) DEFAULT NULL,
  `execute_handler` varchar(60) DEFAULT NULL,
  `generate_handler` varchar(60) DEFAULT NULL,
  `execute_client` varchar(20) DEFAULT NULL,
  `generate_client` varchar(20) DEFAULT NULL,
  `persistent_server` varchar(20) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `sharding_rule` varchar(200) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `try_count` int(11) DEFAULT NULL,
  `gmt_begin` datetime DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `callback_id` varchar(100) DEFAULT NULL,
  `digest` varchar(128) DEFAULT NULL,
  `extension` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_persistent_server` (`persistent_server`),
  KEY `idx_request_status` (`request_id`,`status`),
  KEY `idx_request_execute_client` (`request_id`,`execute_client`,`callback_id`) USING BTREE,
  KEY `idx_execute_status` (`execute_id`,`status`),
  KEY `idx_request_execute_sharding` (`request_id`,`execute_handler`,`sharding_rule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chunk_item_001`
--

DROP TABLE IF EXISTS `chunk_item_001`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chunk_item_001` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `md5` varchar(32) DEFAULT NULL,
  `chunk_type` varchar(15) DEFAULT NULL,
  `data` text,
  `job_item_id` int(11) DEFAULT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `execute_id` varchar(64) DEFAULT NULL,
  `execute_handler` varchar(60) DEFAULT NULL,
  `generate_handler` varchar(60) DEFAULT NULL,
  `execute_client` varchar(20) DEFAULT NULL,
  `generate_client` varchar(20) DEFAULT NULL,
  `persistent_server` varchar(20) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `sharding_rule` varchar(200) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `try_count` int(11) DEFAULT NULL,
  `gmt_begin` datetime DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `callback_id` varchar(100) DEFAULT NULL,
  `digest` varchar(128) DEFAULT NULL,
  `extension` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_persistent_server` (`persistent_server`),
  KEY `idx_request_status` (`request_id`,`status`),
  KEY `idx_request_execute_client` (`request_id`,`execute_client`,`callback_id`) USING BTREE,
  KEY `idx_execute_status` (`execute_id`,`status`),
  KEY `idx_request_execute_sharding` (`request_id`,`execute_handler`,`sharding_rule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chunk_item_002`
--

DROP TABLE IF EXISTS `chunk_item_002`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chunk_item_002` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `md5` varchar(32) DEFAULT NULL,
  `chunk_type` varchar(15) DEFAULT NULL,
  `data` text,
  `job_item_id` int(11) DEFAULT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `execute_id` varchar(64) DEFAULT NULL,
  `execute_handler` varchar(60) DEFAULT NULL,
  `generate_handler` varchar(60) DEFAULT NULL,
  `execute_client` varchar(20) DEFAULT NULL,
  `generate_client` varchar(20) DEFAULT NULL,
  `persistent_server` varchar(20) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `sharding_rule` varchar(200) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `try_count` int(11) DEFAULT NULL,
  `gmt_begin` datetime DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `callback_id` varchar(100) DEFAULT NULL,
  `digest` varchar(128) DEFAULT NULL,
  `extension` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_persistent_server` (`persistent_server`),
  KEY `idx_request_status` (`request_id`,`status`),
  KEY `idx_request_execute_client` (`request_id`,`execute_client`,`callback_id`) USING BTREE,
  KEY `idx_execute_status` (`execute_id`,`status`),
  KEY `idx_request_execute_sharding` (`request_id`,`execute_handler`,`sharding_rule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chunk_item_003`
--

DROP TABLE IF EXISTS `chunk_item_003`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chunk_item_003` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `md5` varchar(32) DEFAULT NULL,
  `chunk_type` varchar(15) DEFAULT NULL,
  `data` text,
  `job_item_id` int(11) DEFAULT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `execute_id` varchar(64) DEFAULT NULL,
  `execute_handler` varchar(60) DEFAULT NULL,
  `generate_handler` varchar(60) DEFAULT NULL,
  `execute_client` varchar(20) DEFAULT NULL,
  `generate_client` varchar(20) DEFAULT NULL,
  `persistent_server` varchar(20) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `sharding_rule` varchar(200) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `try_count` int(11) DEFAULT NULL,
  `gmt_begin` datetime DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `callback_id` varchar(100) DEFAULT NULL,
  `digest` varchar(128) DEFAULT NULL,
  `extension` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_persistent_server` (`persistent_server`),
  KEY `idx_request_status` (`request_id`,`status`),
  KEY `idx_request_execute_client` (`request_id`,`execute_client`,`callback_id`) USING BTREE,
  KEY `idx_execute_status` (`execute_id`,`status`),
  KEY `idx_request_execute_sharding` (`request_id`,`execute_handler`,`sharding_rule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chunk_item_004`
--

DROP TABLE IF EXISTS `chunk_item_004`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chunk_item_004` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `md5` varchar(32) DEFAULT NULL,
  `chunk_type` varchar(15) DEFAULT NULL,
  `data` text,
  `job_item_id` int(11) DEFAULT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `execute_id` varchar(64) DEFAULT NULL,
  `execute_handler` varchar(60) DEFAULT NULL,
  `generate_handler` varchar(60) DEFAULT NULL,
  `execute_client` varchar(20) DEFAULT NULL,
  `generate_client` varchar(20) DEFAULT NULL,
  `persistent_server` varchar(20) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `sharding_rule` varchar(200) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `try_count` int(11) DEFAULT NULL,
  `gmt_begin` datetime DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `callback_id` varchar(100) DEFAULT NULL,
  `digest` varchar(128) DEFAULT NULL,
  `extension` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_persistent_server` (`persistent_server`),
  KEY `idx_request_status` (`request_id`,`status`),
  KEY `idx_request_execute_client` (`request_id`,`execute_client`,`callback_id`) USING BTREE,
  KEY `idx_execute_status` (`execute_id`,`status`),
  KEY `idx_request_execute_sharding` (`request_id`,`execute_handler`,`sharding_rule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chunk_item_005`
--

DROP TABLE IF EXISTS `chunk_item_005`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chunk_item_005` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `md5` varchar(32) DEFAULT NULL,
  `chunk_type` varchar(15) DEFAULT NULL,
  `data` text,
  `job_item_id` int(11) DEFAULT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `execute_id` varchar(64) DEFAULT NULL,
  `execute_handler` varchar(60) DEFAULT NULL,
  `generate_handler` varchar(60) DEFAULT NULL,
  `execute_client` varchar(20) DEFAULT NULL,
  `generate_client` varchar(20) DEFAULT NULL,
  `persistent_server` varchar(20) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `sharding_rule` varchar(200) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `try_count` int(11) DEFAULT NULL,
  `gmt_begin` datetime DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `callback_id` varchar(100) DEFAULT NULL,
  `digest` varchar(128) DEFAULT NULL,
  `extension` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_persistent_server` (`persistent_server`),
  KEY `idx_request_status` (`request_id`,`status`),
  KEY `idx_request_execute_client` (`request_id`,`execute_client`,`callback_id`) USING BTREE,
  KEY `idx_execute_status` (`execute_id`,`status`),
  KEY `idx_request_execute_sharding` (`request_id`,`execute_handler`,`sharding_rule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chunk_item_006`
--

DROP TABLE IF EXISTS `chunk_item_006`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chunk_item_006` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `md5` varchar(32) DEFAULT NULL,
  `chunk_type` varchar(15) DEFAULT NULL,
  `data` text,
  `job_item_id` int(11) DEFAULT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `execute_id` varchar(64) DEFAULT NULL,
  `execute_handler` varchar(60) DEFAULT NULL,
  `generate_handler` varchar(60) DEFAULT NULL,
  `execute_client` varchar(20) DEFAULT NULL,
  `generate_client` varchar(20) DEFAULT NULL,
  `persistent_server` varchar(20) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `sharding_rule` varchar(200) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `try_count` int(11) DEFAULT NULL,
  `gmt_begin` datetime DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `callback_id` varchar(100) DEFAULT NULL,
  `digest` varchar(128) DEFAULT NULL,
  `extension` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_persistent_server` (`persistent_server`),
  KEY `idx_request_status` (`request_id`,`status`),
  KEY `idx_request_execute_client` (`request_id`,`execute_client`,`callback_id`) USING BTREE,
  KEY `idx_execute_status` (`execute_id`,`status`),
  KEY `idx_request_execute_sharding` (`request_id`,`execute_handler`,`sharding_rule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chunk_item_007`
--

DROP TABLE IF EXISTS `chunk_item_007`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chunk_item_007` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `md5` varchar(32) DEFAULT NULL,
  `chunk_type` varchar(15) DEFAULT NULL,
  `data` text,
  `job_item_id` int(11) DEFAULT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `execute_id` varchar(64) DEFAULT NULL,
  `execute_handler` varchar(60) DEFAULT NULL,
  `generate_handler` varchar(60) DEFAULT NULL,
  `execute_client` varchar(20) DEFAULT NULL,
  `generate_client` varchar(20) DEFAULT NULL,
  `persistent_server` varchar(20) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `sharding_rule` varchar(200) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `try_count` int(11) DEFAULT NULL,
  `gmt_begin` datetime DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `callback_id` varchar(100) DEFAULT NULL,
  `digest` varchar(128) DEFAULT NULL,
  `extension` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_persistent_server` (`persistent_server`),
  KEY `idx_request_status` (`request_id`,`status`),
  KEY `idx_request_execute_client` (`request_id`,`execute_client`,`callback_id`) USING BTREE,
  KEY `idx_execute_status` (`execute_id`,`status`),
  KEY `idx_request_execute_sharding` (`request_id`,`execute_handler`,`sharding_rule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chunk_item_008`
--

DROP TABLE IF EXISTS `chunk_item_008`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chunk_item_008` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `md5` varchar(32) DEFAULT NULL,
  `chunk_type` varchar(15) DEFAULT NULL,
  `data` text,
  `job_item_id` int(11) DEFAULT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `execute_id` varchar(64) DEFAULT NULL,
  `execute_handler` varchar(60) DEFAULT NULL,
  `generate_handler` varchar(60) DEFAULT NULL,
  `execute_client` varchar(20) DEFAULT NULL,
  `generate_client` varchar(20) DEFAULT NULL,
  `persistent_server` varchar(20) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `sharding_rule` varchar(200) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `try_count` int(11) DEFAULT NULL,
  `gmt_begin` datetime DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `callback_id` varchar(100) DEFAULT NULL,
  `digest` varchar(128) DEFAULT NULL,
  `extension` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_persistent_server` (`persistent_server`),
  KEY `idx_request_status` (`request_id`,`status`),
  KEY `idx_request_execute_client` (`request_id`,`execute_client`,`callback_id`) USING BTREE,
  KEY `idx_execute_status` (`execute_id`,`status`),
  KEY `idx_request_execute_sharding` (`request_id`,`execute_handler`,`sharding_rule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chunk_item_009`
--

DROP TABLE IF EXISTS `chunk_item_009`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chunk_item_009` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `md5` varchar(32) DEFAULT NULL,
  `chunk_type` varchar(15) DEFAULT NULL,
  `data` text,
  `job_item_id` int(11) DEFAULT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `execute_id` varchar(64) DEFAULT NULL,
  `execute_handler` varchar(60) DEFAULT NULL,
  `generate_handler` varchar(60) DEFAULT NULL,
  `execute_client` varchar(20) DEFAULT NULL,
  `generate_client` varchar(20) DEFAULT NULL,
  `persistent_server` varchar(20) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `sharding_rule` varchar(200) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `try_count` int(11) DEFAULT NULL,
  `gmt_begin` datetime DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `callback_id` varchar(100) DEFAULT NULL,
  `digest` varchar(128) DEFAULT NULL,
  `extension` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_persistent_server` (`persistent_server`),
  KEY `idx_request_status` (`request_id`,`status`),
  KEY `idx_request_execute_client` (`request_id`,`execute_client`,`callback_id`) USING BTREE,
  KEY `idx_execute_status` (`execute_id`,`status`),
  KEY `idx_request_execute_sharding` (`request_id`,`execute_handler`,`sharding_rule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chunk_item_010`
--

DROP TABLE IF EXISTS `chunk_item_010`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chunk_item_010` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `md5` varchar(32) DEFAULT NULL,
  `chunk_type` varchar(15) DEFAULT NULL,
  `data` text,
  `job_item_id` int(11) DEFAULT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `execute_id` varchar(64) DEFAULT NULL,
  `execute_handler` varchar(60) DEFAULT NULL,
  `generate_handler` varchar(60) DEFAULT NULL,
  `execute_client` varchar(20) DEFAULT NULL,
  `generate_client` varchar(20) DEFAULT NULL,
  `persistent_server` varchar(20) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `sharding_rule` varchar(200) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `try_count` int(11) DEFAULT NULL,
  `gmt_begin` datetime DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `callback_id` varchar(100) DEFAULT NULL,
  `digest` varchar(128) DEFAULT NULL,
  `extension` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_persistent_server` (`persistent_server`),
  KEY `idx_request_status` (`request_id`,`status`),
  KEY `idx_request_execute_client` (`request_id`,`execute_client`,`callback_id`) USING BTREE,
  KEY `idx_execute_status` (`execute_id`,`status`),
  KEY `idx_request_execute_sharding` (`request_id`,`execute_handler`,`sharding_rule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chunk_item_011`
--

DROP TABLE IF EXISTS `chunk_item_011`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chunk_item_011` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `md5` varchar(32) DEFAULT NULL,
  `chunk_type` varchar(15) DEFAULT NULL,
  `data` text,
  `job_item_id` int(11) DEFAULT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `execute_id` varchar(64) DEFAULT NULL,
  `execute_handler` varchar(60) DEFAULT NULL,
  `generate_handler` varchar(60) DEFAULT NULL,
  `execute_client` varchar(20) DEFAULT NULL,
  `generate_client` varchar(20) DEFAULT NULL,
  `persistent_server` varchar(20) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `sharding_rule` varchar(200) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `try_count` int(11) DEFAULT NULL,
  `gmt_begin` datetime DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `callback_id` varchar(100) DEFAULT NULL,
  `digest` varchar(128) DEFAULT NULL,
  `extension` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_persistent_server` (`persistent_server`),
  KEY `idx_request_status` (`request_id`,`status`),
  KEY `idx_request_execute_client` (`request_id`,`execute_client`,`callback_id`) USING BTREE,
  KEY `idx_execute_status` (`execute_id`,`status`),
  KEY `idx_request_execute_sharding` (`request_id`,`execute_handler`,`sharding_rule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chunk_item_012`
--

DROP TABLE IF EXISTS `chunk_item_012`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chunk_item_012` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `md5` varchar(32) DEFAULT NULL,
  `chunk_type` varchar(15) DEFAULT NULL,
  `data` text,
  `job_item_id` int(11) DEFAULT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `execute_id` varchar(64) DEFAULT NULL,
  `execute_handler` varchar(60) DEFAULT NULL,
  `generate_handler` varchar(60) DEFAULT NULL,
  `execute_client` varchar(20) DEFAULT NULL,
  `generate_client` varchar(20) DEFAULT NULL,
  `persistent_server` varchar(20) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `sharding_rule` varchar(200) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `try_count` int(11) DEFAULT NULL,
  `gmt_begin` datetime DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `callback_id` varchar(100) DEFAULT NULL,
  `digest` varchar(128) DEFAULT NULL,
  `extension` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_persistent_server` (`persistent_server`),
  KEY `idx_request_status` (`request_id`,`status`),
  KEY `idx_request_execute_client` (`request_id`,`execute_client`,`callback_id`) USING BTREE,
  KEY `idx_execute_status` (`execute_id`,`status`),
  KEY `idx_request_execute_sharding` (`request_id`,`execute_handler`,`sharding_rule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chunk_item_013`
--

DROP TABLE IF EXISTS `chunk_item_013`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chunk_item_013` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `md5` varchar(32) DEFAULT NULL,
  `chunk_type` varchar(15) DEFAULT NULL,
  `data` text,
  `job_item_id` int(11) DEFAULT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `execute_id` varchar(64) DEFAULT NULL,
  `execute_handler` varchar(60) DEFAULT NULL,
  `generate_handler` varchar(60) DEFAULT NULL,
  `execute_client` varchar(20) DEFAULT NULL,
  `generate_client` varchar(20) DEFAULT NULL,
  `persistent_server` varchar(20) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `sharding_rule` varchar(200) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `try_count` int(11) DEFAULT NULL,
  `gmt_begin` datetime DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `callback_id` varchar(100) DEFAULT NULL,
  `digest` varchar(128) DEFAULT NULL,
  `extension` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_persistent_server` (`persistent_server`),
  KEY `idx_request_status` (`request_id`,`status`),
  KEY `idx_request_execute_client` (`request_id`,`execute_client`,`callback_id`) USING BTREE,
  KEY `idx_execute_status` (`execute_id`,`status`),
  KEY `idx_request_execute_sharding` (`request_id`,`execute_handler`,`sharding_rule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chunk_item_014`
--

DROP TABLE IF EXISTS `chunk_item_014`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chunk_item_014` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `md5` varchar(32) DEFAULT NULL,
  `chunk_type` varchar(15) DEFAULT NULL,
  `data` text,
  `job_item_id` int(11) DEFAULT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `execute_id` varchar(64) DEFAULT NULL,
  `execute_handler` varchar(60) DEFAULT NULL,
  `generate_handler` varchar(60) DEFAULT NULL,
  `execute_client` varchar(20) DEFAULT NULL,
  `generate_client` varchar(20) DEFAULT NULL,
  `persistent_server` varchar(20) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `sharding_rule` varchar(200) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `try_count` int(11) DEFAULT NULL,
  `gmt_begin` datetime DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `callback_id` varchar(100) DEFAULT NULL,
  `digest` varchar(128) DEFAULT NULL,
  `extension` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_persistent_server` (`persistent_server`),
  KEY `idx_request_status` (`request_id`,`status`),
  KEY `idx_request_execute_client` (`request_id`,`execute_client`,`callback_id`) USING BTREE,
  KEY `idx_execute_status` (`execute_id`,`status`),
  KEY `idx_request_execute_sharding` (`request_id`,`execute_handler`,`sharding_rule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chunk_item_015`
--

DROP TABLE IF EXISTS `chunk_item_015`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chunk_item_015` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `md5` varchar(32) DEFAULT NULL,
  `chunk_type` varchar(15) DEFAULT NULL,
  `data` text,
  `job_item_id` int(11) DEFAULT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `execute_id` varchar(64) DEFAULT NULL,
  `execute_handler` varchar(60) DEFAULT NULL,
  `generate_handler` varchar(60) DEFAULT NULL,
  `execute_client` varchar(20) DEFAULT NULL,
  `generate_client` varchar(20) DEFAULT NULL,
  `persistent_server` varchar(20) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `sharding_rule` varchar(200) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `try_count` int(11) DEFAULT NULL,
  `gmt_begin` datetime DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `callback_id` varchar(100) DEFAULT NULL,
  `digest` varchar(128) DEFAULT NULL,
  `extension` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_persistent_server` (`persistent_server`),
  KEY `idx_request_status` (`request_id`,`status`),
  KEY `idx_request_execute_client` (`request_id`,`execute_client`,`callback_id`) USING BTREE,
  KEY `idx_execute_status` (`execute_id`,`status`),
  KEY `idx_request_execute_sharding` (`request_id`,`execute_handler`,`sharding_rule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chunk_item_016`
--

DROP TABLE IF EXISTS `chunk_item_016`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chunk_item_016` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `md5` varchar(32) DEFAULT NULL,
  `chunk_type` varchar(15) DEFAULT NULL,
  `data` text,
  `job_item_id` int(11) DEFAULT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `execute_id` varchar(64) DEFAULT NULL,
  `execute_handler` varchar(60) DEFAULT NULL,
  `generate_handler` varchar(60) DEFAULT NULL,
  `execute_client` varchar(20) DEFAULT NULL,
  `generate_client` varchar(20) DEFAULT NULL,
  `persistent_server` varchar(20) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `sharding_rule` varchar(200) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `try_count` int(11) DEFAULT NULL,
  `gmt_begin` datetime DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `callback_id` varchar(100) DEFAULT NULL,
  `digest` varchar(128) DEFAULT NULL,
  `extension` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_persistent_server` (`persistent_server`),
  KEY `idx_request_status` (`request_id`,`status`),
  KEY `idx_request_execute_client` (`request_id`,`execute_client`,`callback_id`) USING BTREE,
  KEY `idx_execute_status` (`execute_id`,`status`),
  KEY `idx_request_execute_sharding` (`request_id`,`execute_handler`,`sharding_rule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chunk_item_017`
--

DROP TABLE IF EXISTS `chunk_item_017`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chunk_item_017` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `md5` varchar(32) DEFAULT NULL,
  `chunk_type` varchar(15) DEFAULT NULL,
  `data` text,
  `job_item_id` int(11) DEFAULT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `execute_id` varchar(64) DEFAULT NULL,
  `execute_handler` varchar(60) DEFAULT NULL,
  `generate_handler` varchar(60) DEFAULT NULL,
  `execute_client` varchar(20) DEFAULT NULL,
  `generate_client` varchar(20) DEFAULT NULL,
  `persistent_server` varchar(20) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `sharding_rule` varchar(200) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `try_count` int(11) DEFAULT NULL,
  `gmt_begin` datetime DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `callback_id` varchar(100) DEFAULT NULL,
  `digest` varchar(128) DEFAULT NULL,
  `extension` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_persistent_server` (`persistent_server`),
  KEY `idx_request_status` (`request_id`,`status`),
  KEY `idx_request_execute_client` (`request_id`,`execute_client`,`callback_id`) USING BTREE,
  KEY `idx_execute_status` (`execute_id`,`status`),
  KEY `idx_request_execute_sharding` (`request_id`,`execute_handler`,`sharding_rule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chunk_item_018`
--

DROP TABLE IF EXISTS `chunk_item_018`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chunk_item_018` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `md5` varchar(32) DEFAULT NULL,
  `chunk_type` varchar(15) DEFAULT NULL,
  `data` text,
  `job_item_id` int(11) DEFAULT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `execute_id` varchar(64) DEFAULT NULL,
  `execute_handler` varchar(60) DEFAULT NULL,
  `generate_handler` varchar(60) DEFAULT NULL,
  `execute_client` varchar(20) DEFAULT NULL,
  `generate_client` varchar(20) DEFAULT NULL,
  `persistent_server` varchar(20) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `sharding_rule` varchar(200) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `try_count` int(11) DEFAULT NULL,
  `gmt_begin` datetime DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `callback_id` varchar(100) DEFAULT NULL,
  `digest` varchar(128) DEFAULT NULL,
  `extension` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_persistent_server` (`persistent_server`),
  KEY `idx_request_status` (`request_id`,`status`),
  KEY `idx_request_execute_client` (`request_id`,`execute_client`,`callback_id`) USING BTREE,
  KEY `idx_execute_status` (`execute_id`,`status`),
  KEY `idx_request_execute_sharding` (`request_id`,`execute_handler`,`sharding_rule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chunk_item_019`
--

DROP TABLE IF EXISTS `chunk_item_019`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chunk_item_019` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `md5` varchar(32) DEFAULT NULL,
  `chunk_type` varchar(15) DEFAULT NULL,
  `data` text,
  `job_item_id` int(11) DEFAULT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `execute_id` varchar(64) DEFAULT NULL,
  `execute_handler` varchar(60) DEFAULT NULL,
  `generate_handler` varchar(60) DEFAULT NULL,
  `execute_client` varchar(20) DEFAULT NULL,
  `generate_client` varchar(20) DEFAULT NULL,
  `persistent_server` varchar(20) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `sharding_rule` varchar(200) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `try_count` int(11) DEFAULT NULL,
  `gmt_begin` datetime DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `callback_id` varchar(100) DEFAULT NULL,
  `digest` varchar(128) DEFAULT NULL,
  `extension` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_persistent_server` (`persistent_server`),
  KEY `idx_request_status` (`request_id`,`status`),
  KEY `idx_request_execute_client` (`request_id`,`execute_client`,`callback_id`) USING BTREE,
  KEY `idx_execute_status` (`execute_id`,`status`),
  KEY `idx_request_execute_sharding` (`request_id`,`execute_handler`,`sharding_rule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chunk_item_020`
--

DROP TABLE IF EXISTS `chunk_item_020`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chunk_item_020` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `md5` varchar(32) DEFAULT NULL,
  `chunk_type` varchar(15) DEFAULT NULL,
  `data` text,
  `job_item_id` int(11) DEFAULT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `execute_id` varchar(64) DEFAULT NULL,
  `execute_handler` varchar(60) DEFAULT NULL,
  `generate_handler` varchar(60) DEFAULT NULL,
  `execute_client` varchar(20) DEFAULT NULL,
  `generate_client` varchar(20) DEFAULT NULL,
  `persistent_server` varchar(20) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `sharding_rule` varchar(200) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `try_count` int(11) DEFAULT NULL,
  `gmt_begin` datetime DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `callback_id` varchar(100) DEFAULT NULL,
  `digest` varchar(128) DEFAULT NULL,
  `extension` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_persistent_server` (`persistent_server`),
  KEY `idx_request_status` (`request_id`,`status`),
  KEY `idx_request_execute_client` (`request_id`,`execute_client`,`callback_id`) USING BTREE,
  KEY `idx_execute_status` (`execute_id`,`status`),
  KEY `idx_request_execute_sharding` (`request_id`,`execute_handler`,`sharding_rule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chunk_item_021`
--

DROP TABLE IF EXISTS `chunk_item_021`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chunk_item_021` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `md5` varchar(32) DEFAULT NULL,
  `chunk_type` varchar(15) DEFAULT NULL,
  `data` text,
  `job_item_id` int(11) DEFAULT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `execute_id` varchar(64) DEFAULT NULL,
  `execute_handler` varchar(60) DEFAULT NULL,
  `generate_handler` varchar(60) DEFAULT NULL,
  `execute_client` varchar(20) DEFAULT NULL,
  `generate_client` varchar(20) DEFAULT NULL,
  `persistent_server` varchar(20) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `sharding_rule` varchar(200) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `try_count` int(11) DEFAULT NULL,
  `gmt_begin` datetime DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `callback_id` varchar(100) DEFAULT NULL,
  `digest` varchar(128) DEFAULT NULL,
  `extension` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_persistent_server` (`persistent_server`),
  KEY `idx_request_status` (`request_id`,`status`),
  KEY `idx_request_execute_client` (`request_id`,`execute_client`,`callback_id`) USING BTREE,
  KEY `idx_execute_status` (`execute_id`,`status`),
  KEY `idx_request_execute_sharding` (`request_id`,`execute_handler`,`sharding_rule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chunk_item_022`
--

DROP TABLE IF EXISTS `chunk_item_022`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chunk_item_022` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `md5` varchar(32) DEFAULT NULL,
  `chunk_type` varchar(15) DEFAULT NULL,
  `data` text,
  `job_item_id` int(11) DEFAULT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `execute_id` varchar(64) DEFAULT NULL,
  `execute_handler` varchar(60) DEFAULT NULL,
  `generate_handler` varchar(60) DEFAULT NULL,
  `execute_client` varchar(20) DEFAULT NULL,
  `generate_client` varchar(20) DEFAULT NULL,
  `persistent_server` varchar(20) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `sharding_rule` varchar(200) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `try_count` int(11) DEFAULT NULL,
  `gmt_begin` datetime DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `callback_id` varchar(100) DEFAULT NULL,
  `digest` varchar(128) DEFAULT NULL,
  `extension` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_persistent_server` (`persistent_server`),
  KEY `idx_request_status` (`request_id`,`status`),
  KEY `idx_request_execute_client` (`request_id`,`execute_client`,`callback_id`) USING BTREE,
  KEY `idx_execute_status` (`execute_id`,`status`),
  KEY `idx_request_execute_sharding` (`request_id`,`execute_handler`,`sharding_rule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chunk_item_023`
--

DROP TABLE IF EXISTS `chunk_item_023`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chunk_item_023` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `md5` varchar(32) DEFAULT NULL,
  `chunk_type` varchar(15) DEFAULT NULL,
  `data` text,
  `job_item_id` int(11) DEFAULT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `execute_id` varchar(64) DEFAULT NULL,
  `execute_handler` varchar(60) DEFAULT NULL,
  `generate_handler` varchar(60) DEFAULT NULL,
  `execute_client` varchar(20) DEFAULT NULL,
  `generate_client` varchar(20) DEFAULT NULL,
  `persistent_server` varchar(20) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `sharding_rule` varchar(200) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `try_count` int(11) DEFAULT NULL,
  `gmt_begin` datetime DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `callback_id` varchar(100) DEFAULT NULL,
  `digest` varchar(128) DEFAULT NULL,
  `extension` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_persistent_server` (`persistent_server`),
  KEY `idx_request_status` (`request_id`,`status`),
  KEY `idx_request_execute_client` (`request_id`,`execute_client`,`callback_id`) USING BTREE,
  KEY `idx_execute_status` (`execute_id`,`status`),
  KEY `idx_request_execute_sharding` (`request_id`,`execute_handler`,`sharding_rule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chunk_item_024`
--

DROP TABLE IF EXISTS `chunk_item_024`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chunk_item_024` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `md5` varchar(32) DEFAULT NULL,
  `chunk_type` varchar(15) DEFAULT NULL,
  `data` text,
  `job_item_id` int(11) DEFAULT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `execute_id` varchar(64) DEFAULT NULL,
  `execute_handler` varchar(60) DEFAULT NULL,
  `generate_handler` varchar(60) DEFAULT NULL,
  `execute_client` varchar(20) DEFAULT NULL,
  `generate_client` varchar(20) DEFAULT NULL,
  `persistent_server` varchar(20) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `sharding_rule` varchar(200) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `try_count` int(11) DEFAULT NULL,
  `gmt_begin` datetime DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `callback_id` varchar(100) DEFAULT NULL,
  `digest` varchar(128) DEFAULT NULL,
  `extension` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_persistent_server` (`persistent_server`),
  KEY `idx_request_status` (`request_id`,`status`),
  KEY `idx_request_execute_client` (`request_id`,`execute_client`,`callback_id`) USING BTREE,
  KEY `idx_execute_status` (`execute_id`,`status`),
  KEY `idx_request_execute_sharding` (`request_id`,`execute_handler`,`sharding_rule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chunk_item_025`
--

DROP TABLE IF EXISTS `chunk_item_025`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chunk_item_025` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `md5` varchar(32) DEFAULT NULL,
  `chunk_type` varchar(15) DEFAULT NULL,
  `data` text,
  `job_item_id` int(11) DEFAULT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `execute_id` varchar(64) DEFAULT NULL,
  `execute_handler` varchar(60) DEFAULT NULL,
  `generate_handler` varchar(60) DEFAULT NULL,
  `execute_client` varchar(20) DEFAULT NULL,
  `generate_client` varchar(20) DEFAULT NULL,
  `persistent_server` varchar(20) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `sharding_rule` varchar(200) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `try_count` int(11) DEFAULT NULL,
  `gmt_begin` datetime DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `callback_id` varchar(100) DEFAULT NULL,
  `digest` varchar(128) DEFAULT NULL,
  `extension` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_persistent_server` (`persistent_server`),
  KEY `idx_request_status` (`request_id`,`status`),
  KEY `idx_request_execute_client` (`request_id`,`execute_client`,`callback_id`) USING BTREE,
  KEY `idx_execute_status` (`execute_id`,`status`),
  KEY `idx_request_execute_sharding` (`request_id`,`execute_handler`,`sharding_rule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chunk_item_026`
--

DROP TABLE IF EXISTS `chunk_item_026`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chunk_item_026` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `md5` varchar(32) DEFAULT NULL,
  `chunk_type` varchar(15) DEFAULT NULL,
  `data` text,
  `job_item_id` int(11) DEFAULT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `execute_id` varchar(64) DEFAULT NULL,
  `execute_handler` varchar(60) DEFAULT NULL,
  `generate_handler` varchar(60) DEFAULT NULL,
  `execute_client` varchar(20) DEFAULT NULL,
  `generate_client` varchar(20) DEFAULT NULL,
  `persistent_server` varchar(20) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `sharding_rule` varchar(200) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `try_count` int(11) DEFAULT NULL,
  `gmt_begin` datetime DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `callback_id` varchar(100) DEFAULT NULL,
  `digest` varchar(128) DEFAULT NULL,
  `extension` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_persistent_server` (`persistent_server`),
  KEY `idx_request_status` (`request_id`,`status`),
  KEY `idx_request_execute_client` (`request_id`,`execute_client`,`callback_id`) USING BTREE,
  KEY `idx_execute_status` (`execute_id`,`status`),
  KEY `idx_request_execute_sharding` (`request_id`,`execute_handler`,`sharding_rule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chunk_item_027`
--

DROP TABLE IF EXISTS `chunk_item_027`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chunk_item_027` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `md5` varchar(32) DEFAULT NULL,
  `chunk_type` varchar(15) DEFAULT NULL,
  `data` text,
  `job_item_id` int(11) DEFAULT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `execute_id` varchar(64) DEFAULT NULL,
  `execute_handler` varchar(60) DEFAULT NULL,
  `generate_handler` varchar(60) DEFAULT NULL,
  `execute_client` varchar(20) DEFAULT NULL,
  `generate_client` varchar(20) DEFAULT NULL,
  `persistent_server` varchar(20) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `sharding_rule` varchar(200) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `try_count` int(11) DEFAULT NULL,
  `gmt_begin` datetime DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `callback_id` varchar(100) DEFAULT NULL,
  `digest` varchar(128) DEFAULT NULL,
  `extension` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_persistent_server` (`persistent_server`),
  KEY `idx_request_status` (`request_id`,`status`),
  KEY `idx_request_execute_client` (`request_id`,`execute_client`,`callback_id`) USING BTREE,
  KEY `idx_execute_status` (`execute_id`,`status`),
  KEY `idx_request_execute_sharding` (`request_id`,`execute_handler`,`sharding_rule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chunk_item_028`
--

DROP TABLE IF EXISTS `chunk_item_028`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chunk_item_028` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `md5` varchar(32) DEFAULT NULL,
  `chunk_type` varchar(15) DEFAULT NULL,
  `data` text,
  `job_item_id` int(11) DEFAULT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `execute_id` varchar(64) DEFAULT NULL,
  `execute_handler` varchar(60) DEFAULT NULL,
  `generate_handler` varchar(60) DEFAULT NULL,
  `execute_client` varchar(20) DEFAULT NULL,
  `generate_client` varchar(20) DEFAULT NULL,
  `persistent_server` varchar(20) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `sharding_rule` varchar(200) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `try_count` int(11) DEFAULT NULL,
  `gmt_begin` datetime DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `callback_id` varchar(100) DEFAULT NULL,
  `digest` varchar(128) DEFAULT NULL,
  `extension` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_persistent_server` (`persistent_server`),
  KEY `idx_request_status` (`request_id`,`status`),
  KEY `idx_request_execute_client` (`request_id`,`execute_client`,`callback_id`) USING BTREE,
  KEY `idx_execute_status` (`execute_id`,`status`),
  KEY `idx_request_execute_sharding` (`request_id`,`execute_handler`,`sharding_rule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chunk_item_029`
--

DROP TABLE IF EXISTS `chunk_item_029`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chunk_item_029` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `md5` varchar(32) DEFAULT NULL,
  `chunk_type` varchar(15) DEFAULT NULL,
  `data` text,
  `job_item_id` int(11) DEFAULT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `execute_id` varchar(64) DEFAULT NULL,
  `execute_handler` varchar(60) DEFAULT NULL,
  `generate_handler` varchar(60) DEFAULT NULL,
  `execute_client` varchar(20) DEFAULT NULL,
  `generate_client` varchar(20) DEFAULT NULL,
  `persistent_server` varchar(20) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `sharding_rule` varchar(200) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `try_count` int(11) DEFAULT NULL,
  `gmt_begin` datetime DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `callback_id` varchar(100) DEFAULT NULL,
  `digest` varchar(128) DEFAULT NULL,
  `extension` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_persistent_server` (`persistent_server`),
  KEY `idx_request_status` (`request_id`,`status`),
  KEY `idx_request_execute_client` (`request_id`,`execute_client`,`callback_id`) USING BTREE,
  KEY `idx_execute_status` (`execute_id`,`status`),
  KEY `idx_request_execute_sharding` (`request_id`,`execute_handler`,`sharding_rule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chunk_item_030`
--

DROP TABLE IF EXISTS `chunk_item_030`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chunk_item_030` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `md5` varchar(32) DEFAULT NULL,
  `chunk_type` varchar(15) DEFAULT NULL,
  `data` text,
  `job_item_id` int(11) DEFAULT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `execute_id` varchar(64) DEFAULT NULL,
  `execute_handler` varchar(60) DEFAULT NULL,
  `generate_handler` varchar(60) DEFAULT NULL,
  `execute_client` varchar(20) DEFAULT NULL,
  `generate_client` varchar(20) DEFAULT NULL,
  `persistent_server` varchar(20) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `sharding_rule` varchar(200) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `try_count` int(11) DEFAULT NULL,
  `gmt_begin` datetime DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `callback_id` varchar(100) DEFAULT NULL,
  `digest` varchar(128) DEFAULT NULL,
  `extension` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_persistent_server` (`persistent_server`),
  KEY `idx_request_status` (`request_id`,`status`),
  KEY `idx_request_execute_client` (`request_id`,`execute_client`,`callback_id`) USING BTREE,
  KEY `idx_execute_status` (`execute_id`,`status`),
  KEY `idx_request_execute_sharding` (`request_id`,`execute_handler`,`sharding_rule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chunk_item_031`
--

DROP TABLE IF EXISTS `chunk_item_031`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chunk_item_031` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `md5` varchar(32) DEFAULT NULL,
  `chunk_type` varchar(15) DEFAULT NULL,
  `data` text,
  `job_item_id` int(11) DEFAULT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `execute_id` varchar(64) DEFAULT NULL,
  `execute_handler` varchar(60) DEFAULT NULL,
  `generate_handler` varchar(60) DEFAULT NULL,
  `execute_client` varchar(20) DEFAULT NULL,
  `generate_client` varchar(20) DEFAULT NULL,
  `persistent_server` varchar(20) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `sharding_rule` varchar(200) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `try_count` int(11) DEFAULT NULL,
  `gmt_begin` datetime DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `callback_id` varchar(100) DEFAULT NULL,
  `digest` varchar(128) DEFAULT NULL,
  `extension` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_persistent_server` (`persistent_server`),
  KEY `idx_request_status` (`request_id`,`status`),
  KEY `idx_request_execute_client` (`request_id`,`execute_client`,`callback_id`) USING BTREE,
  KEY `idx_execute_status` (`execute_id`,`status`),
  KEY `idx_request_execute_sharding` (`request_id`,`execute_handler`,`sharding_rule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chunk_item_032`
--

DROP TABLE IF EXISTS `chunk_item_032`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chunk_item_032` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `md5` varchar(32) DEFAULT NULL,
  `chunk_type` varchar(15) DEFAULT NULL,
  `data` text,
  `job_item_id` int(11) DEFAULT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `execute_id` varchar(64) DEFAULT NULL,
  `execute_handler` varchar(60) DEFAULT NULL,
  `generate_handler` varchar(60) DEFAULT NULL,
  `execute_client` varchar(20) DEFAULT NULL,
  `generate_client` varchar(20) DEFAULT NULL,
  `persistent_server` varchar(20) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `sharding_rule` varchar(200) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `try_count` int(11) DEFAULT NULL,
  `gmt_begin` datetime DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `callback_id` varchar(100) DEFAULT NULL,
  `digest` varchar(128) DEFAULT NULL,
  `extension` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_persistent_server` (`persistent_server`),
  KEY `idx_request_status` (`request_id`,`status`),
  KEY `idx_request_execute_client` (`request_id`,`execute_client`,`callback_id`) USING BTREE,
  KEY `idx_execute_status` (`execute_id`,`status`),
  KEY `idx_request_execute_sharding` (`request_id`,`execute_handler`,`sharding_rule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chunk_item_033`
--

DROP TABLE IF EXISTS `chunk_item_033`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chunk_item_033` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `md5` varchar(32) DEFAULT NULL,
  `chunk_type` varchar(15) DEFAULT NULL,
  `data` text,
  `job_item_id` int(11) DEFAULT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `execute_id` varchar(64) DEFAULT NULL,
  `execute_handler` varchar(60) DEFAULT NULL,
  `generate_handler` varchar(60) DEFAULT NULL,
  `execute_client` varchar(20) DEFAULT NULL,
  `generate_client` varchar(20) DEFAULT NULL,
  `persistent_server` varchar(20) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `sharding_rule` varchar(200) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `try_count` int(11) DEFAULT NULL,
  `gmt_begin` datetime DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `callback_id` varchar(100) DEFAULT NULL,
  `digest` varchar(128) DEFAULT NULL,
  `extension` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_persistent_server` (`persistent_server`),
  KEY `idx_request_status` (`request_id`,`status`),
  KEY `idx_request_execute_client` (`request_id`,`execute_client`,`callback_id`) USING BTREE,
  KEY `idx_execute_status` (`execute_id`,`status`),
  KEY `idx_request_execute_sharding` (`request_id`,`execute_handler`,`sharding_rule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chunk_item_034`
--

DROP TABLE IF EXISTS `chunk_item_034`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chunk_item_034` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `md5` varchar(32) DEFAULT NULL,
  `chunk_type` varchar(15) DEFAULT NULL,
  `data` text,
  `job_item_id` int(11) DEFAULT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `execute_id` varchar(64) DEFAULT NULL,
  `execute_handler` varchar(60) DEFAULT NULL,
  `generate_handler` varchar(60) DEFAULT NULL,
  `execute_client` varchar(20) DEFAULT NULL,
  `generate_client` varchar(20) DEFAULT NULL,
  `persistent_server` varchar(20) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `sharding_rule` varchar(200) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `try_count` int(11) DEFAULT NULL,
  `gmt_begin` datetime DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `callback_id` varchar(100) DEFAULT NULL,
  `digest` varchar(128) DEFAULT NULL,
  `extension` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_persistent_server` (`persistent_server`),
  KEY `idx_request_status` (`request_id`,`status`),
  KEY `idx_request_execute_client` (`request_id`,`execute_client`,`callback_id`) USING BTREE,
  KEY `idx_execute_status` (`execute_id`,`status`),
  KEY `idx_request_execute_sharding` (`request_id`,`execute_handler`,`sharding_rule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chunk_item_035`
--

DROP TABLE IF EXISTS `chunk_item_035`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chunk_item_035` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `md5` varchar(32) DEFAULT NULL,
  `chunk_type` varchar(15) DEFAULT NULL,
  `data` text,
  `job_item_id` int(11) DEFAULT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `execute_id` varchar(64) DEFAULT NULL,
  `execute_handler` varchar(60) DEFAULT NULL,
  `generate_handler` varchar(60) DEFAULT NULL,
  `execute_client` varchar(20) DEFAULT NULL,
  `generate_client` varchar(20) DEFAULT NULL,
  `persistent_server` varchar(20) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `sharding_rule` varchar(200) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `try_count` int(11) DEFAULT NULL,
  `gmt_begin` datetime DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `callback_id` varchar(100) DEFAULT NULL,
  `digest` varchar(128) DEFAULT NULL,
  `extension` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_persistent_server` (`persistent_server`),
  KEY `idx_request_status` (`request_id`,`status`),
  KEY `idx_request_execute_client` (`request_id`,`execute_client`,`callback_id`) USING BTREE,
  KEY `idx_execute_status` (`execute_id`,`status`),
  KEY `idx_request_execute_sharding` (`request_id`,`execute_handler`,`sharding_rule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chunk_item_036`
--

DROP TABLE IF EXISTS `chunk_item_036`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chunk_item_036` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `md5` varchar(32) DEFAULT NULL,
  `chunk_type` varchar(15) DEFAULT NULL,
  `data` text,
  `job_item_id` int(11) DEFAULT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `execute_id` varchar(64) DEFAULT NULL,
  `execute_handler` varchar(60) DEFAULT NULL,
  `generate_handler` varchar(60) DEFAULT NULL,
  `execute_client` varchar(20) DEFAULT NULL,
  `generate_client` varchar(20) DEFAULT NULL,
  `persistent_server` varchar(20) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `sharding_rule` varchar(200) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `try_count` int(11) DEFAULT NULL,
  `gmt_begin` datetime DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `callback_id` varchar(100) DEFAULT NULL,
  `digest` varchar(128) DEFAULT NULL,
  `extension` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_persistent_server` (`persistent_server`),
  KEY `idx_request_status` (`request_id`,`status`),
  KEY `idx_request_execute_client` (`request_id`,`execute_client`,`callback_id`) USING BTREE,
  KEY `idx_execute_status` (`execute_id`,`status`),
  KEY `idx_request_execute_sharding` (`request_id`,`execute_handler`,`sharding_rule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chunk_item_037`
--

DROP TABLE IF EXISTS `chunk_item_037`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chunk_item_037` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `md5` varchar(32) DEFAULT NULL,
  `chunk_type` varchar(15) DEFAULT NULL,
  `data` text,
  `job_item_id` int(11) DEFAULT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `execute_id` varchar(64) DEFAULT NULL,
  `execute_handler` varchar(60) DEFAULT NULL,
  `generate_handler` varchar(60) DEFAULT NULL,
  `execute_client` varchar(20) DEFAULT NULL,
  `generate_client` varchar(20) DEFAULT NULL,
  `persistent_server` varchar(20) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `sharding_rule` varchar(200) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `try_count` int(11) DEFAULT NULL,
  `gmt_begin` datetime DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `callback_id` varchar(100) DEFAULT NULL,
  `digest` varchar(128) DEFAULT NULL,
  `extension` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_persistent_server` (`persistent_server`),
  KEY `idx_request_status` (`request_id`,`status`),
  KEY `idx_request_execute_client` (`request_id`,`execute_client`,`callback_id`) USING BTREE,
  KEY `idx_execute_status` (`execute_id`,`status`),
  KEY `idx_request_execute_sharding` (`request_id`,`execute_handler`,`sharding_rule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chunk_item_038`
--

DROP TABLE IF EXISTS `chunk_item_038`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chunk_item_038` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `md5` varchar(32) DEFAULT NULL,
  `chunk_type` varchar(15) DEFAULT NULL,
  `data` text,
  `job_item_id` int(11) DEFAULT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `execute_id` varchar(64) DEFAULT NULL,
  `execute_handler` varchar(60) DEFAULT NULL,
  `generate_handler` varchar(60) DEFAULT NULL,
  `execute_client` varchar(20) DEFAULT NULL,
  `generate_client` varchar(20) DEFAULT NULL,
  `persistent_server` varchar(20) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `sharding_rule` varchar(200) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `try_count` int(11) DEFAULT NULL,
  `gmt_begin` datetime DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `callback_id` varchar(100) DEFAULT NULL,
  `digest` varchar(128) DEFAULT NULL,
  `extension` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_persistent_server` (`persistent_server`),
  KEY `idx_request_status` (`request_id`,`status`),
  KEY `idx_request_execute_client` (`request_id`,`execute_client`,`callback_id`) USING BTREE,
  KEY `idx_execute_status` (`execute_id`,`status`),
  KEY `idx_request_execute_sharding` (`request_id`,`execute_handler`,`sharding_rule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chunk_item_039`
--

DROP TABLE IF EXISTS `chunk_item_039`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chunk_item_039` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `md5` varchar(32) DEFAULT NULL,
  `chunk_type` varchar(15) DEFAULT NULL,
  `data` text,
  `job_item_id` int(11) DEFAULT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `execute_id` varchar(64) DEFAULT NULL,
  `execute_handler` varchar(60) DEFAULT NULL,
  `generate_handler` varchar(60) DEFAULT NULL,
  `execute_client` varchar(20) DEFAULT NULL,
  `generate_client` varchar(20) DEFAULT NULL,
  `persistent_server` varchar(20) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `sharding_rule` varchar(200) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `try_count` int(11) DEFAULT NULL,
  `gmt_begin` datetime DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `callback_id` varchar(100) DEFAULT NULL,
  `digest` varchar(128) DEFAULT NULL,
  `extension` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_persistent_server` (`persistent_server`),
  KEY `idx_request_status` (`request_id`,`status`),
  KEY `idx_request_execute_client` (`request_id`,`execute_client`,`callback_id`) USING BTREE,
  KEY `idx_execute_status` (`execute_id`,`status`),
  KEY `idx_request_execute_sharding` (`request_id`,`execute_handler`,`sharding_rule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chunk_item_040`
--

DROP TABLE IF EXISTS `chunk_item_040`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chunk_item_040` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `md5` varchar(32) DEFAULT NULL,
  `chunk_type` varchar(15) DEFAULT NULL,
  `data` text,
  `job_item_id` int(11) DEFAULT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `execute_id` varchar(64) DEFAULT NULL,
  `execute_handler` varchar(60) DEFAULT NULL,
  `generate_handler` varchar(60) DEFAULT NULL,
  `execute_client` varchar(20) DEFAULT NULL,
  `generate_client` varchar(20) DEFAULT NULL,
  `persistent_server` varchar(20) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `sharding_rule` varchar(200) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `try_count` int(11) DEFAULT NULL,
  `gmt_begin` datetime DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `callback_id` varchar(100) DEFAULT NULL,
  `digest` varchar(128) DEFAULT NULL,
  `extension` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_persistent_server` (`persistent_server`),
  KEY `idx_request_status` (`request_id`,`status`),
  KEY `idx_request_execute_client` (`request_id`,`execute_client`,`callback_id`) USING BTREE,
  KEY `idx_execute_status` (`execute_id`,`status`),
  KEY `idx_request_execute_sharding` (`request_id`,`execute_handler`,`sharding_rule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chunk_item_041`
--

DROP TABLE IF EXISTS `chunk_item_041`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chunk_item_041` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `md5` varchar(32) DEFAULT NULL,
  `chunk_type` varchar(15) DEFAULT NULL,
  `data` text,
  `job_item_id` int(11) DEFAULT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `execute_id` varchar(64) DEFAULT NULL,
  `execute_handler` varchar(60) DEFAULT NULL,
  `generate_handler` varchar(60) DEFAULT NULL,
  `execute_client` varchar(20) DEFAULT NULL,
  `generate_client` varchar(20) DEFAULT NULL,
  `persistent_server` varchar(20) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `sharding_rule` varchar(200) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `try_count` int(11) DEFAULT NULL,
  `gmt_begin` datetime DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `callback_id` varchar(100) DEFAULT NULL,
  `digest` varchar(128) DEFAULT NULL,
  `extension` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_persistent_server` (`persistent_server`),
  KEY `idx_request_status` (`request_id`,`status`),
  KEY `idx_request_execute_client` (`request_id`,`execute_client`,`callback_id`) USING BTREE,
  KEY `idx_execute_status` (`execute_id`,`status`),
  KEY `idx_request_execute_sharding` (`request_id`,`execute_handler`,`sharding_rule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chunk_item_042`
--

DROP TABLE IF EXISTS `chunk_item_042`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chunk_item_042` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `md5` varchar(32) DEFAULT NULL,
  `chunk_type` varchar(15) DEFAULT NULL,
  `data` text,
  `job_item_id` int(11) DEFAULT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `execute_id` varchar(64) DEFAULT NULL,
  `execute_handler` varchar(60) DEFAULT NULL,
  `generate_handler` varchar(60) DEFAULT NULL,
  `execute_client` varchar(20) DEFAULT NULL,
  `generate_client` varchar(20) DEFAULT NULL,
  `persistent_server` varchar(20) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `sharding_rule` varchar(200) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `try_count` int(11) DEFAULT NULL,
  `gmt_begin` datetime DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `callback_id` varchar(100) DEFAULT NULL,
  `digest` varchar(128) DEFAULT NULL,
  `extension` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_persistent_server` (`persistent_server`),
  KEY `idx_request_status` (`request_id`,`status`),
  KEY `idx_request_execute_client` (`request_id`,`execute_client`,`callback_id`) USING BTREE,
  KEY `idx_execute_status` (`execute_id`,`status`),
  KEY `idx_request_execute_sharding` (`request_id`,`execute_handler`,`sharding_rule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chunk_item_043`
--

DROP TABLE IF EXISTS `chunk_item_043`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chunk_item_043` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `md5` varchar(32) DEFAULT NULL,
  `chunk_type` varchar(15) DEFAULT NULL,
  `data` text,
  `job_item_id` int(11) DEFAULT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `execute_id` varchar(64) DEFAULT NULL,
  `execute_handler` varchar(60) DEFAULT NULL,
  `generate_handler` varchar(60) DEFAULT NULL,
  `execute_client` varchar(20) DEFAULT NULL,
  `generate_client` varchar(20) DEFAULT NULL,
  `persistent_server` varchar(20) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `sharding_rule` varchar(200) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `try_count` int(11) DEFAULT NULL,
  `gmt_begin` datetime DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `callback_id` varchar(100) DEFAULT NULL,
  `digest` varchar(128) DEFAULT NULL,
  `extension` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_persistent_server` (`persistent_server`),
  KEY `idx_request_status` (`request_id`,`status`),
  KEY `idx_request_execute_client` (`request_id`,`execute_client`,`callback_id`) USING BTREE,
  KEY `idx_execute_status` (`execute_id`,`status`),
  KEY `idx_request_execute_sharding` (`request_id`,`execute_handler`,`sharding_rule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chunk_item_044`
--

DROP TABLE IF EXISTS `chunk_item_044`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chunk_item_044` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `md5` varchar(32) DEFAULT NULL,
  `chunk_type` varchar(15) DEFAULT NULL,
  `data` text,
  `job_item_id` int(11) DEFAULT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `execute_id` varchar(64) DEFAULT NULL,
  `execute_handler` varchar(60) DEFAULT NULL,
  `generate_handler` varchar(60) DEFAULT NULL,
  `execute_client` varchar(20) DEFAULT NULL,
  `generate_client` varchar(20) DEFAULT NULL,
  `persistent_server` varchar(20) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `sharding_rule` varchar(200) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `try_count` int(11) DEFAULT NULL,
  `gmt_begin` datetime DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `callback_id` varchar(100) DEFAULT NULL,
  `digest` varchar(128) DEFAULT NULL,
  `extension` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_persistent_server` (`persistent_server`),
  KEY `idx_request_status` (`request_id`,`status`),
  KEY `idx_request_execute_client` (`request_id`,`execute_client`,`callback_id`) USING BTREE,
  KEY `idx_execute_status` (`execute_id`,`status`),
  KEY `idx_request_execute_sharding` (`request_id`,`execute_handler`,`sharding_rule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chunk_item_045`
--

DROP TABLE IF EXISTS `chunk_item_045`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chunk_item_045` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `md5` varchar(32) DEFAULT NULL,
  `chunk_type` varchar(15) DEFAULT NULL,
  `data` text,
  `job_item_id` int(11) DEFAULT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `execute_id` varchar(64) DEFAULT NULL,
  `execute_handler` varchar(60) DEFAULT NULL,
  `generate_handler` varchar(60) DEFAULT NULL,
  `execute_client` varchar(20) DEFAULT NULL,
  `generate_client` varchar(20) DEFAULT NULL,
  `persistent_server` varchar(20) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `sharding_rule` varchar(200) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `try_count` int(11) DEFAULT NULL,
  `gmt_begin` datetime DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `callback_id` varchar(100) DEFAULT NULL,
  `digest` varchar(128) DEFAULT NULL,
  `extension` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_persistent_server` (`persistent_server`),
  KEY `idx_request_status` (`request_id`,`status`),
  KEY `idx_request_execute_client` (`request_id`,`execute_client`,`callback_id`) USING BTREE,
  KEY `idx_execute_status` (`execute_id`,`status`),
  KEY `idx_request_execute_sharding` (`request_id`,`execute_handler`,`sharding_rule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chunk_item_046`
--

DROP TABLE IF EXISTS `chunk_item_046`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chunk_item_046` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `md5` varchar(32) DEFAULT NULL,
  `chunk_type` varchar(15) DEFAULT NULL,
  `data` text,
  `job_item_id` int(11) DEFAULT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `execute_id` varchar(64) DEFAULT NULL,
  `execute_handler` varchar(60) DEFAULT NULL,
  `generate_handler` varchar(60) DEFAULT NULL,
  `execute_client` varchar(20) DEFAULT NULL,
  `generate_client` varchar(20) DEFAULT NULL,
  `persistent_server` varchar(20) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `sharding_rule` varchar(200) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `try_count` int(11) DEFAULT NULL,
  `gmt_begin` datetime DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `callback_id` varchar(100) DEFAULT NULL,
  `digest` varchar(128) DEFAULT NULL,
  `extension` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_persistent_server` (`persistent_server`),
  KEY `idx_request_status` (`request_id`,`status`),
  KEY `idx_request_execute_client` (`request_id`,`execute_client`,`callback_id`) USING BTREE,
  KEY `idx_execute_status` (`execute_id`,`status`),
  KEY `idx_request_execute_sharding` (`request_id`,`execute_handler`,`sharding_rule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chunk_item_047`
--

DROP TABLE IF EXISTS `chunk_item_047`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chunk_item_047` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `md5` varchar(32) DEFAULT NULL,
  `chunk_type` varchar(15) DEFAULT NULL,
  `data` text,
  `job_item_id` int(11) DEFAULT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `execute_id` varchar(64) DEFAULT NULL,
  `execute_handler` varchar(60) DEFAULT NULL,
  `generate_handler` varchar(60) DEFAULT NULL,
  `execute_client` varchar(20) DEFAULT NULL,
  `generate_client` varchar(20) DEFAULT NULL,
  `persistent_server` varchar(20) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `sharding_rule` varchar(200) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `try_count` int(11) DEFAULT NULL,
  `gmt_begin` datetime DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `callback_id` varchar(100) DEFAULT NULL,
  `digest` varchar(128) DEFAULT NULL,
  `extension` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_persistent_server` (`persistent_server`),
  KEY `idx_request_status` (`request_id`,`status`),
  KEY `idx_request_execute_client` (`request_id`,`execute_client`,`callback_id`) USING BTREE,
  KEY `idx_execute_status` (`execute_id`,`status`),
  KEY `idx_request_execute_sharding` (`request_id`,`execute_handler`,`sharding_rule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chunk_item_048`
--

DROP TABLE IF EXISTS `chunk_item_048`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chunk_item_048` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `md5` varchar(32) DEFAULT NULL,
  `chunk_type` varchar(15) DEFAULT NULL,
  `data` text,
  `job_item_id` int(11) DEFAULT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `execute_id` varchar(64) DEFAULT NULL,
  `execute_handler` varchar(60) DEFAULT NULL,
  `generate_handler` varchar(60) DEFAULT NULL,
  `execute_client` varchar(20) DEFAULT NULL,
  `generate_client` varchar(20) DEFAULT NULL,
  `persistent_server` varchar(20) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `sharding_rule` varchar(200) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `try_count` int(11) DEFAULT NULL,
  `gmt_begin` datetime DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `callback_id` varchar(100) DEFAULT NULL,
  `digest` varchar(128) DEFAULT NULL,
  `extension` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_persistent_server` (`persistent_server`),
  KEY `idx_request_status` (`request_id`,`status`),
  KEY `idx_request_execute_client` (`request_id`,`execute_client`,`callback_id`) USING BTREE,
  KEY `idx_execute_status` (`execute_id`,`status`),
  KEY `idx_request_execute_sharding` (`request_id`,`execute_handler`,`sharding_rule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chunk_item_049`
--

DROP TABLE IF EXISTS `chunk_item_049`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chunk_item_049` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `md5` varchar(32) DEFAULT NULL,
  `chunk_type` varchar(15) DEFAULT NULL,
  `data` text,
  `job_item_id` int(11) DEFAULT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `execute_id` varchar(64) DEFAULT NULL,
  `execute_handler` varchar(60) DEFAULT NULL,
  `generate_handler` varchar(60) DEFAULT NULL,
  `execute_client` varchar(20) DEFAULT NULL,
  `generate_client` varchar(20) DEFAULT NULL,
  `persistent_server` varchar(20) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `sharding_rule` varchar(200) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `try_count` int(11) DEFAULT NULL,
  `gmt_begin` datetime DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `callback_id` varchar(100) DEFAULT NULL,
  `digest` varchar(128) DEFAULT NULL,
  `extension` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_persistent_server` (`persistent_server`),
  KEY `idx_request_status` (`request_id`,`status`),
  KEY `idx_request_execute_client` (`request_id`,`execute_client`,`callback_id`) USING BTREE,
  KEY `idx_execute_status` (`execute_id`,`status`),
  KEY `idx_request_execute_sharding` (`request_id`,`execute_handler`,`sharding_rule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chunk_item_050`
--

DROP TABLE IF EXISTS `chunk_item_050`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chunk_item_050` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `md5` varchar(32) DEFAULT NULL,
  `chunk_type` varchar(15) DEFAULT NULL,
  `data` text,
  `job_item_id` int(11) DEFAULT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `execute_id` varchar(64) DEFAULT NULL,
  `execute_handler` varchar(60) DEFAULT NULL,
  `generate_handler` varchar(60) DEFAULT NULL,
  `execute_client` varchar(20) DEFAULT NULL,
  `generate_client` varchar(20) DEFAULT NULL,
  `persistent_server` varchar(20) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `sharding_rule` varchar(200) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `try_count` int(11) DEFAULT NULL,
  `gmt_begin` datetime DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `callback_id` varchar(100) DEFAULT NULL,
  `digest` varchar(128) DEFAULT NULL,
  `extension` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_persistent_server` (`persistent_server`),
  KEY `idx_request_status` (`request_id`,`status`),
  KEY `idx_request_execute_client` (`request_id`,`execute_client`,`callback_id`) USING BTREE,
  KEY `idx_execute_status` (`execute_id`,`status`),
  KEY `idx_request_execute_sharding` (`request_id`,`execute_handler`,`sharding_rule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chunk_item_051`
--

DROP TABLE IF EXISTS `chunk_item_051`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chunk_item_051` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `md5` varchar(32) DEFAULT NULL,
  `chunk_type` varchar(15) DEFAULT NULL,
  `data` text,
  `job_item_id` int(11) DEFAULT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `execute_id` varchar(64) DEFAULT NULL,
  `execute_handler` varchar(60) DEFAULT NULL,
  `generate_handler` varchar(60) DEFAULT NULL,
  `execute_client` varchar(20) DEFAULT NULL,
  `generate_client` varchar(20) DEFAULT NULL,
  `persistent_server` varchar(20) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `sharding_rule` varchar(200) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `try_count` int(11) DEFAULT NULL,
  `gmt_begin` datetime DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `callback_id` varchar(100) DEFAULT NULL,
  `digest` varchar(128) DEFAULT NULL,
  `extension` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_persistent_server` (`persistent_server`),
  KEY `idx_request_status` (`request_id`,`status`),
  KEY `idx_request_execute_client` (`request_id`,`execute_client`,`callback_id`) USING BTREE,
  KEY `idx_execute_status` (`execute_id`,`status`),
  KEY `idx_request_execute_sharding` (`request_id`,`execute_handler`,`sharding_rule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chunk_item_052`
--

DROP TABLE IF EXISTS `chunk_item_052`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chunk_item_052` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `md5` varchar(32) DEFAULT NULL,
  `chunk_type` varchar(15) DEFAULT NULL,
  `data` text,
  `job_item_id` int(11) DEFAULT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `execute_id` varchar(64) DEFAULT NULL,
  `execute_handler` varchar(60) DEFAULT NULL,
  `generate_handler` varchar(60) DEFAULT NULL,
  `execute_client` varchar(20) DEFAULT NULL,
  `generate_client` varchar(20) DEFAULT NULL,
  `persistent_server` varchar(20) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `sharding_rule` varchar(200) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `try_count` int(11) DEFAULT NULL,
  `gmt_begin` datetime DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `callback_id` varchar(100) DEFAULT NULL,
  `digest` varchar(128) DEFAULT NULL,
  `extension` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_persistent_server` (`persistent_server`),
  KEY `idx_request_status` (`request_id`,`status`),
  KEY `idx_request_execute_client` (`request_id`,`execute_client`,`callback_id`) USING BTREE,
  KEY `idx_execute_status` (`execute_id`,`status`),
  KEY `idx_request_execute_sharding` (`request_id`,`execute_handler`,`sharding_rule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chunk_item_053`
--

DROP TABLE IF EXISTS `chunk_item_053`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chunk_item_053` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `md5` varchar(32) DEFAULT NULL,
  `chunk_type` varchar(15) DEFAULT NULL,
  `data` text,
  `job_item_id` int(11) DEFAULT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `execute_id` varchar(64) DEFAULT NULL,
  `execute_handler` varchar(60) DEFAULT NULL,
  `generate_handler` varchar(60) DEFAULT NULL,
  `execute_client` varchar(20) DEFAULT NULL,
  `generate_client` varchar(20) DEFAULT NULL,
  `persistent_server` varchar(20) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `sharding_rule` varchar(200) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `try_count` int(11) DEFAULT NULL,
  `gmt_begin` datetime DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `callback_id` varchar(100) DEFAULT NULL,
  `digest` varchar(128) DEFAULT NULL,
  `extension` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_persistent_server` (`persistent_server`),
  KEY `idx_request_status` (`request_id`,`status`),
  KEY `idx_request_execute_client` (`request_id`,`execute_client`,`callback_id`) USING BTREE,
  KEY `idx_execute_status` (`execute_id`,`status`),
  KEY `idx_request_execute_sharding` (`request_id`,`execute_handler`,`sharding_rule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chunk_item_054`
--

DROP TABLE IF EXISTS `chunk_item_054`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chunk_item_054` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `md5` varchar(32) DEFAULT NULL,
  `chunk_type` varchar(15) DEFAULT NULL,
  `data` text,
  `job_item_id` int(11) DEFAULT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `execute_id` varchar(64) DEFAULT NULL,
  `execute_handler` varchar(60) DEFAULT NULL,
  `generate_handler` varchar(60) DEFAULT NULL,
  `execute_client` varchar(20) DEFAULT NULL,
  `generate_client` varchar(20) DEFAULT NULL,
  `persistent_server` varchar(20) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `sharding_rule` varchar(200) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `try_count` int(11) DEFAULT NULL,
  `gmt_begin` datetime DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `callback_id` varchar(100) DEFAULT NULL,
  `digest` varchar(128) DEFAULT NULL,
  `extension` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_persistent_server` (`persistent_server`),
  KEY `idx_request_status` (`request_id`,`status`),
  KEY `idx_request_execute_client` (`request_id`,`execute_client`,`callback_id`) USING BTREE,
  KEY `idx_execute_status` (`execute_id`,`status`),
  KEY `idx_request_execute_sharding` (`request_id`,`execute_handler`,`sharding_rule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chunk_item_055`
--

DROP TABLE IF EXISTS `chunk_item_055`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chunk_item_055` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `md5` varchar(32) DEFAULT NULL,
  `chunk_type` varchar(15) DEFAULT NULL,
  `data` text,
  `job_item_id` int(11) DEFAULT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `execute_id` varchar(64) DEFAULT NULL,
  `execute_handler` varchar(60) DEFAULT NULL,
  `generate_handler` varchar(60) DEFAULT NULL,
  `execute_client` varchar(20) DEFAULT NULL,
  `generate_client` varchar(20) DEFAULT NULL,
  `persistent_server` varchar(20) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `sharding_rule` varchar(200) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `try_count` int(11) DEFAULT NULL,
  `gmt_begin` datetime DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `callback_id` varchar(100) DEFAULT NULL,
  `digest` varchar(128) DEFAULT NULL,
  `extension` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_persistent_server` (`persistent_server`),
  KEY `idx_request_status` (`request_id`,`status`),
  KEY `idx_request_execute_client` (`request_id`,`execute_client`,`callback_id`) USING BTREE,
  KEY `idx_execute_status` (`execute_id`,`status`),
  KEY `idx_request_execute_sharding` (`request_id`,`execute_handler`,`sharding_rule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chunk_item_056`
--

DROP TABLE IF EXISTS `chunk_item_056`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chunk_item_056` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `md5` varchar(32) DEFAULT NULL,
  `chunk_type` varchar(15) DEFAULT NULL,
  `data` text,
  `job_item_id` int(11) DEFAULT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `execute_id` varchar(64) DEFAULT NULL,
  `execute_handler` varchar(60) DEFAULT NULL,
  `generate_handler` varchar(60) DEFAULT NULL,
  `execute_client` varchar(20) DEFAULT NULL,
  `generate_client` varchar(20) DEFAULT NULL,
  `persistent_server` varchar(20) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `sharding_rule` varchar(200) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `try_count` int(11) DEFAULT NULL,
  `gmt_begin` datetime DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `callback_id` varchar(100) DEFAULT NULL,
  `digest` varchar(128) DEFAULT NULL,
  `extension` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_persistent_server` (`persistent_server`),
  KEY `idx_request_status` (`request_id`,`status`),
  KEY `idx_request_execute_client` (`request_id`,`execute_client`,`callback_id`) USING BTREE,
  KEY `idx_execute_status` (`execute_id`,`status`),
  KEY `idx_request_execute_sharding` (`request_id`,`execute_handler`,`sharding_rule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chunk_item_057`
--

DROP TABLE IF EXISTS `chunk_item_057`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chunk_item_057` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `md5` varchar(32) DEFAULT NULL,
  `chunk_type` varchar(15) DEFAULT NULL,
  `data` text,
  `job_item_id` int(11) DEFAULT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `execute_id` varchar(64) DEFAULT NULL,
  `execute_handler` varchar(60) DEFAULT NULL,
  `generate_handler` varchar(60) DEFAULT NULL,
  `execute_client` varchar(20) DEFAULT NULL,
  `generate_client` varchar(20) DEFAULT NULL,
  `persistent_server` varchar(20) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `sharding_rule` varchar(200) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `try_count` int(11) DEFAULT NULL,
  `gmt_begin` datetime DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `callback_id` varchar(100) DEFAULT NULL,
  `digest` varchar(128) DEFAULT NULL,
  `extension` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_persistent_server` (`persistent_server`),
  KEY `idx_request_status` (`request_id`,`status`),
  KEY `idx_request_execute_client` (`request_id`,`execute_client`,`callback_id`) USING BTREE,
  KEY `idx_execute_status` (`execute_id`,`status`),
  KEY `idx_request_execute_sharding` (`request_id`,`execute_handler`,`sharding_rule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chunk_item_058`
--

DROP TABLE IF EXISTS `chunk_item_058`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chunk_item_058` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `md5` varchar(32) DEFAULT NULL,
  `chunk_type` varchar(15) DEFAULT NULL,
  `data` text,
  `job_item_id` int(11) DEFAULT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `execute_id` varchar(64) DEFAULT NULL,
  `execute_handler` varchar(60) DEFAULT NULL,
  `generate_handler` varchar(60) DEFAULT NULL,
  `execute_client` varchar(20) DEFAULT NULL,
  `generate_client` varchar(20) DEFAULT NULL,
  `persistent_server` varchar(20) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `sharding_rule` varchar(200) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `try_count` int(11) DEFAULT NULL,
  `gmt_begin` datetime DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `callback_id` varchar(100) DEFAULT NULL,
  `digest` varchar(128) DEFAULT NULL,
  `extension` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_persistent_server` (`persistent_server`),
  KEY `idx_request_status` (`request_id`,`status`),
  KEY `idx_request_execute_client` (`request_id`,`execute_client`,`callback_id`) USING BTREE,
  KEY `idx_execute_status` (`execute_id`,`status`),
  KEY `idx_request_execute_sharding` (`request_id`,`execute_handler`,`sharding_rule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chunk_item_059`
--

DROP TABLE IF EXISTS `chunk_item_059`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chunk_item_059` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `md5` varchar(32) DEFAULT NULL,
  `chunk_type` varchar(15) DEFAULT NULL,
  `data` text,
  `job_item_id` int(11) DEFAULT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `execute_id` varchar(64) DEFAULT NULL,
  `execute_handler` varchar(60) DEFAULT NULL,
  `generate_handler` varchar(60) DEFAULT NULL,
  `execute_client` varchar(20) DEFAULT NULL,
  `generate_client` varchar(20) DEFAULT NULL,
  `persistent_server` varchar(20) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `sharding_rule` varchar(200) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `try_count` int(11) DEFAULT NULL,
  `gmt_begin` datetime DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `callback_id` varchar(100) DEFAULT NULL,
  `digest` varchar(128) DEFAULT NULL,
  `extension` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_persistent_server` (`persistent_server`),
  KEY `idx_request_status` (`request_id`,`status`),
  KEY `idx_request_execute_client` (`request_id`,`execute_client`,`callback_id`) USING BTREE,
  KEY `idx_execute_status` (`execute_id`,`status`),
  KEY `idx_request_execute_sharding` (`request_id`,`execute_handler`,`sharding_rule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chunk_item_060`
--

DROP TABLE IF EXISTS `chunk_item_060`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chunk_item_060` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `md5` varchar(32) DEFAULT NULL,
  `chunk_type` varchar(15) DEFAULT NULL,
  `data` text,
  `job_item_id` int(11) DEFAULT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `execute_id` varchar(64) DEFAULT NULL,
  `execute_handler` varchar(60) DEFAULT NULL,
  `generate_handler` varchar(60) DEFAULT NULL,
  `execute_client` varchar(20) DEFAULT NULL,
  `generate_client` varchar(20) DEFAULT NULL,
  `persistent_server` varchar(20) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `sharding_rule` varchar(200) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `try_count` int(11) DEFAULT NULL,
  `gmt_begin` datetime DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `callback_id` varchar(100) DEFAULT NULL,
  `digest` varchar(128) DEFAULT NULL,
  `extension` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_persistent_server` (`persistent_server`),
  KEY `idx_request_status` (`request_id`,`status`),
  KEY `idx_request_execute_client` (`request_id`,`execute_client`,`callback_id`) USING BTREE,
  KEY `idx_execute_status` (`execute_id`,`status`),
  KEY `idx_request_execute_sharding` (`request_id`,`execute_handler`,`sharding_rule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chunk_item_061`
--

DROP TABLE IF EXISTS `chunk_item_061`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chunk_item_061` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `md5` varchar(32) DEFAULT NULL,
  `chunk_type` varchar(15) DEFAULT NULL,
  `data` text,
  `job_item_id` int(11) DEFAULT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `execute_id` varchar(64) DEFAULT NULL,
  `execute_handler` varchar(60) DEFAULT NULL,
  `generate_handler` varchar(60) DEFAULT NULL,
  `execute_client` varchar(20) DEFAULT NULL,
  `generate_client` varchar(20) DEFAULT NULL,
  `persistent_server` varchar(20) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `sharding_rule` varchar(200) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `try_count` int(11) DEFAULT NULL,
  `gmt_begin` datetime DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `callback_id` varchar(100) DEFAULT NULL,
  `digest` varchar(128) DEFAULT NULL,
  `extension` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_persistent_server` (`persistent_server`),
  KEY `idx_request_status` (`request_id`,`status`),
  KEY `idx_request_execute_client` (`request_id`,`execute_client`,`callback_id`) USING BTREE,
  KEY `idx_execute_status` (`execute_id`,`status`),
  KEY `idx_request_execute_sharding` (`request_id`,`execute_handler`,`sharding_rule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chunk_item_062`
--

DROP TABLE IF EXISTS `chunk_item_062`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chunk_item_062` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `md5` varchar(32) DEFAULT NULL,
  `chunk_type` varchar(15) DEFAULT NULL,
  `data` text,
  `job_item_id` int(11) DEFAULT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `execute_id` varchar(64) DEFAULT NULL,
  `execute_handler` varchar(60) DEFAULT NULL,
  `generate_handler` varchar(60) DEFAULT NULL,
  `execute_client` varchar(20) DEFAULT NULL,
  `generate_client` varchar(20) DEFAULT NULL,
  `persistent_server` varchar(20) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `sharding_rule` varchar(200) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `try_count` int(11) DEFAULT NULL,
  `gmt_begin` datetime DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `callback_id` varchar(100) DEFAULT NULL,
  `digest` varchar(128) DEFAULT NULL,
  `extension` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_persistent_server` (`persistent_server`),
  KEY `idx_request_status` (`request_id`,`status`),
  KEY `idx_request_execute_client` (`request_id`,`execute_client`,`callback_id`) USING BTREE,
  KEY `idx_execute_status` (`execute_id`,`status`),
  KEY `idx_request_execute_sharding` (`request_id`,`execute_handler`,`sharding_rule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chunk_item_063`
--

DROP TABLE IF EXISTS `chunk_item_063`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chunk_item_063` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `md5` varchar(32) DEFAULT NULL,
  `chunk_type` varchar(15) DEFAULT NULL,
  `data` text,
  `job_item_id` int(11) DEFAULT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `execute_id` varchar(64) DEFAULT NULL,
  `execute_handler` varchar(60) DEFAULT NULL,
  `generate_handler` varchar(60) DEFAULT NULL,
  `execute_client` varchar(20) DEFAULT NULL,
  `generate_client` varchar(20) DEFAULT NULL,
  `persistent_server` varchar(20) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `sharding_rule` varchar(200) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `try_count` int(11) DEFAULT NULL,
  `gmt_begin` datetime DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `callback_id` varchar(100) DEFAULT NULL,
  `digest` varchar(128) DEFAULT NULL,
  `extension` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_persistent_server` (`persistent_server`),
  KEY `idx_request_status` (`request_id`,`status`),
  KEY `idx_request_execute_client` (`request_id`,`execute_client`,`callback_id`) USING BTREE,
  KEY `idx_execute_status` (`execute_id`,`status`),
  KEY `idx_request_execute_sharding` (`request_id`,`execute_handler`,`sharding_rule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chunk_item_064`
--

DROP TABLE IF EXISTS `chunk_item_064`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chunk_item_064` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `md5` varchar(32) DEFAULT NULL,
  `chunk_type` varchar(15) DEFAULT NULL,
  `data` text,
  `job_item_id` int(11) DEFAULT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `execute_id` varchar(64) DEFAULT NULL,
  `execute_handler` varchar(60) DEFAULT NULL,
  `generate_handler` varchar(60) DEFAULT NULL,
  `execute_client` varchar(20) DEFAULT NULL,
  `generate_client` varchar(20) DEFAULT NULL,
  `persistent_server` varchar(20) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `sharding_rule` varchar(200) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `try_count` int(11) DEFAULT NULL,
  `gmt_begin` datetime DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `callback_id` varchar(100) DEFAULT NULL,
  `digest` varchar(128) DEFAULT NULL,
  `extension` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_persistent_server` (`persistent_server`),
  KEY `idx_request_status` (`request_id`,`status`),
  KEY `idx_request_execute_client` (`request_id`,`execute_client`,`callback_id`) USING BTREE,
  KEY `idx_execute_status` (`execute_id`,`status`),
  KEY `idx_request_execute_sharding` (`request_id`,`execute_handler`,`sharding_rule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chunk_item_065`
--

DROP TABLE IF EXISTS `chunk_item_065`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chunk_item_065` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `md5` varchar(32) DEFAULT NULL,
  `chunk_type` varchar(15) DEFAULT NULL,
  `data` text,
  `job_item_id` int(11) DEFAULT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `execute_id` varchar(64) DEFAULT NULL,
  `execute_handler` varchar(60) DEFAULT NULL,
  `generate_handler` varchar(60) DEFAULT NULL,
  `execute_client` varchar(20) DEFAULT NULL,
  `generate_client` varchar(20) DEFAULT NULL,
  `persistent_server` varchar(20) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `sharding_rule` varchar(200) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `try_count` int(11) DEFAULT NULL,
  `gmt_begin` datetime DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `callback_id` varchar(100) DEFAULT NULL,
  `digest` varchar(128) DEFAULT NULL,
  `extension` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_persistent_server` (`persistent_server`),
  KEY `idx_request_status` (`request_id`,`status`),
  KEY `idx_request_execute_client` (`request_id`,`execute_client`,`callback_id`) USING BTREE,
  KEY `idx_execute_status` (`execute_id`,`status`),
  KEY `idx_request_execute_sharding` (`request_id`,`execute_handler`,`sharding_rule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chunk_item_066`
--

DROP TABLE IF EXISTS `chunk_item_066`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chunk_item_066` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `md5` varchar(32) DEFAULT NULL,
  `chunk_type` varchar(15) DEFAULT NULL,
  `data` text,
  `job_item_id` int(11) DEFAULT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `execute_id` varchar(64) DEFAULT NULL,
  `execute_handler` varchar(60) DEFAULT NULL,
  `generate_handler` varchar(60) DEFAULT NULL,
  `execute_client` varchar(20) DEFAULT NULL,
  `generate_client` varchar(20) DEFAULT NULL,
  `persistent_server` varchar(20) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `sharding_rule` varchar(200) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `try_count` int(11) DEFAULT NULL,
  `gmt_begin` datetime DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `callback_id` varchar(100) DEFAULT NULL,
  `digest` varchar(128) DEFAULT NULL,
  `extension` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_persistent_server` (`persistent_server`),
  KEY `idx_request_status` (`request_id`,`status`),
  KEY `idx_request_execute_client` (`request_id`,`execute_client`,`callback_id`) USING BTREE,
  KEY `idx_execute_status` (`execute_id`,`status`),
  KEY `idx_request_execute_sharding` (`request_id`,`execute_handler`,`sharding_rule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chunk_item_067`
--

DROP TABLE IF EXISTS `chunk_item_067`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chunk_item_067` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `md5` varchar(32) DEFAULT NULL,
  `chunk_type` varchar(15) DEFAULT NULL,
  `data` text,
  `job_item_id` int(11) DEFAULT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `execute_id` varchar(64) DEFAULT NULL,
  `execute_handler` varchar(60) DEFAULT NULL,
  `generate_handler` varchar(60) DEFAULT NULL,
  `execute_client` varchar(20) DEFAULT NULL,
  `generate_client` varchar(20) DEFAULT NULL,
  `persistent_server` varchar(20) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `sharding_rule` varchar(200) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `try_count` int(11) DEFAULT NULL,
  `gmt_begin` datetime DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `callback_id` varchar(100) DEFAULT NULL,
  `digest` varchar(128) DEFAULT NULL,
  `extension` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_persistent_server` (`persistent_server`),
  KEY `idx_request_status` (`request_id`,`status`),
  KEY `idx_request_execute_client` (`request_id`,`execute_client`,`callback_id`) USING BTREE,
  KEY `idx_execute_status` (`execute_id`,`status`),
  KEY `idx_request_execute_sharding` (`request_id`,`execute_handler`,`sharding_rule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chunk_item_068`
--

DROP TABLE IF EXISTS `chunk_item_068`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chunk_item_068` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `md5` varchar(32) DEFAULT NULL,
  `chunk_type` varchar(15) DEFAULT NULL,
  `data` text,
  `job_item_id` int(11) DEFAULT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `execute_id` varchar(64) DEFAULT NULL,
  `execute_handler` varchar(60) DEFAULT NULL,
  `generate_handler` varchar(60) DEFAULT NULL,
  `execute_client` varchar(20) DEFAULT NULL,
  `generate_client` varchar(20) DEFAULT NULL,
  `persistent_server` varchar(20) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `sharding_rule` varchar(200) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `try_count` int(11) DEFAULT NULL,
  `gmt_begin` datetime DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `callback_id` varchar(100) DEFAULT NULL,
  `digest` varchar(128) DEFAULT NULL,
  `extension` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_persistent_server` (`persistent_server`),
  KEY `idx_request_status` (`request_id`,`status`),
  KEY `idx_request_execute_client` (`request_id`,`execute_client`,`callback_id`) USING BTREE,
  KEY `idx_execute_status` (`execute_id`,`status`),
  KEY `idx_request_execute_sharding` (`request_id`,`execute_handler`,`sharding_rule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chunk_item_069`
--

DROP TABLE IF EXISTS `chunk_item_069`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chunk_item_069` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `md5` varchar(32) DEFAULT NULL,
  `chunk_type` varchar(15) DEFAULT NULL,
  `data` text,
  `job_item_id` int(11) DEFAULT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `execute_id` varchar(64) DEFAULT NULL,
  `execute_handler` varchar(60) DEFAULT NULL,
  `generate_handler` varchar(60) DEFAULT NULL,
  `execute_client` varchar(20) DEFAULT NULL,
  `generate_client` varchar(20) DEFAULT NULL,
  `persistent_server` varchar(20) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `sharding_rule` varchar(200) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `try_count` int(11) DEFAULT NULL,
  `gmt_begin` datetime DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `callback_id` varchar(100) DEFAULT NULL,
  `digest` varchar(128) DEFAULT NULL,
  `extension` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_persistent_server` (`persistent_server`),
  KEY `idx_request_status` (`request_id`,`status`),
  KEY `idx_request_execute_client` (`request_id`,`execute_client`,`callback_id`) USING BTREE,
  KEY `idx_execute_status` (`execute_id`,`status`),
  KEY `idx_request_execute_sharding` (`request_id`,`execute_handler`,`sharding_rule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chunk_item_070`
--

DROP TABLE IF EXISTS `chunk_item_070`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chunk_item_070` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `md5` varchar(32) DEFAULT NULL,
  `chunk_type` varchar(15) DEFAULT NULL,
  `data` text,
  `job_item_id` int(11) DEFAULT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `execute_id` varchar(64) DEFAULT NULL,
  `execute_handler` varchar(60) DEFAULT NULL,
  `generate_handler` varchar(60) DEFAULT NULL,
  `execute_client` varchar(20) DEFAULT NULL,
  `generate_client` varchar(20) DEFAULT NULL,
  `persistent_server` varchar(20) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `sharding_rule` varchar(200) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `try_count` int(11) DEFAULT NULL,
  `gmt_begin` datetime DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `callback_id` varchar(100) DEFAULT NULL,
  `digest` varchar(128) DEFAULT NULL,
  `extension` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_persistent_server` (`persistent_server`),
  KEY `idx_request_status` (`request_id`,`status`),
  KEY `idx_request_execute_client` (`request_id`,`execute_client`,`callback_id`) USING BTREE,
  KEY `idx_execute_status` (`execute_id`,`status`),
  KEY `idx_request_execute_sharding` (`request_id`,`execute_handler`,`sharding_rule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chunk_item_071`
--

DROP TABLE IF EXISTS `chunk_item_071`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chunk_item_071` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `md5` varchar(32) DEFAULT NULL,
  `chunk_type` varchar(15) DEFAULT NULL,
  `data` text,
  `job_item_id` int(11) DEFAULT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `execute_id` varchar(64) DEFAULT NULL,
  `execute_handler` varchar(60) DEFAULT NULL,
  `generate_handler` varchar(60) DEFAULT NULL,
  `execute_client` varchar(20) DEFAULT NULL,
  `generate_client` varchar(20) DEFAULT NULL,
  `persistent_server` varchar(20) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `sharding_rule` varchar(200) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `try_count` int(11) DEFAULT NULL,
  `gmt_begin` datetime DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `callback_id` varchar(100) DEFAULT NULL,
  `digest` varchar(128) DEFAULT NULL,
  `extension` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_persistent_server` (`persistent_server`),
  KEY `idx_request_status` (`request_id`,`status`),
  KEY `idx_request_execute_client` (`request_id`,`execute_client`,`callback_id`) USING BTREE,
  KEY `idx_execute_status` (`execute_id`,`status`),
  KEY `idx_request_execute_sharding` (`request_id`,`execute_handler`,`sharding_rule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chunk_item_072`
--

DROP TABLE IF EXISTS `chunk_item_072`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chunk_item_072` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `md5` varchar(32) DEFAULT NULL,
  `chunk_type` varchar(15) DEFAULT NULL,
  `data` text,
  `job_item_id` int(11) DEFAULT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `execute_id` varchar(64) DEFAULT NULL,
  `execute_handler` varchar(60) DEFAULT NULL,
  `generate_handler` varchar(60) DEFAULT NULL,
  `execute_client` varchar(20) DEFAULT NULL,
  `generate_client` varchar(20) DEFAULT NULL,
  `persistent_server` varchar(20) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `sharding_rule` varchar(200) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `try_count` int(11) DEFAULT NULL,
  `gmt_begin` datetime DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `callback_id` varchar(100) DEFAULT NULL,
  `digest` varchar(128) DEFAULT NULL,
  `extension` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_persistent_server` (`persistent_server`),
  KEY `idx_request_status` (`request_id`,`status`),
  KEY `idx_request_execute_client` (`request_id`,`execute_client`,`callback_id`) USING BTREE,
  KEY `idx_execute_status` (`execute_id`,`status`),
  KEY `idx_request_execute_sharding` (`request_id`,`execute_handler`,`sharding_rule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chunk_item_073`
--

DROP TABLE IF EXISTS `chunk_item_073`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chunk_item_073` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `md5` varchar(32) DEFAULT NULL,
  `chunk_type` varchar(15) DEFAULT NULL,
  `data` text,
  `job_item_id` int(11) DEFAULT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `execute_id` varchar(64) DEFAULT NULL,
  `execute_handler` varchar(60) DEFAULT NULL,
  `generate_handler` varchar(60) DEFAULT NULL,
  `execute_client` varchar(20) DEFAULT NULL,
  `generate_client` varchar(20) DEFAULT NULL,
  `persistent_server` varchar(20) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `sharding_rule` varchar(200) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `try_count` int(11) DEFAULT NULL,
  `gmt_begin` datetime DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `callback_id` varchar(100) DEFAULT NULL,
  `digest` varchar(128) DEFAULT NULL,
  `extension` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_persistent_server` (`persistent_server`),
  KEY `idx_request_status` (`request_id`,`status`),
  KEY `idx_request_execute_client` (`request_id`,`execute_client`,`callback_id`) USING BTREE,
  KEY `idx_execute_status` (`execute_id`,`status`),
  KEY `idx_request_execute_sharding` (`request_id`,`execute_handler`,`sharding_rule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chunk_item_074`
--

DROP TABLE IF EXISTS `chunk_item_074`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chunk_item_074` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `md5` varchar(32) DEFAULT NULL,
  `chunk_type` varchar(15) DEFAULT NULL,
  `data` text,
  `job_item_id` int(11) DEFAULT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `execute_id` varchar(64) DEFAULT NULL,
  `execute_handler` varchar(60) DEFAULT NULL,
  `generate_handler` varchar(60) DEFAULT NULL,
  `execute_client` varchar(20) DEFAULT NULL,
  `generate_client` varchar(20) DEFAULT NULL,
  `persistent_server` varchar(20) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `sharding_rule` varchar(200) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `try_count` int(11) DEFAULT NULL,
  `gmt_begin` datetime DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `callback_id` varchar(100) DEFAULT NULL,
  `digest` varchar(128) DEFAULT NULL,
  `extension` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_persistent_server` (`persistent_server`),
  KEY `idx_request_status` (`request_id`,`status`),
  KEY `idx_request_execute_client` (`request_id`,`execute_client`,`callback_id`) USING BTREE,
  KEY `idx_execute_status` (`execute_id`,`status`),
  KEY `idx_request_execute_sharding` (`request_id`,`execute_handler`,`sharding_rule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chunk_item_075`
--

DROP TABLE IF EXISTS `chunk_item_075`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chunk_item_075` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `md5` varchar(32) DEFAULT NULL,
  `chunk_type` varchar(15) DEFAULT NULL,
  `data` text,
  `job_item_id` int(11) DEFAULT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `execute_id` varchar(64) DEFAULT NULL,
  `execute_handler` varchar(60) DEFAULT NULL,
  `generate_handler` varchar(60) DEFAULT NULL,
  `execute_client` varchar(20) DEFAULT NULL,
  `generate_client` varchar(20) DEFAULT NULL,
  `persistent_server` varchar(20) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `sharding_rule` varchar(200) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `try_count` int(11) DEFAULT NULL,
  `gmt_begin` datetime DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `callback_id` varchar(100) DEFAULT NULL,
  `digest` varchar(128) DEFAULT NULL,
  `extension` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_persistent_server` (`persistent_server`),
  KEY `idx_request_status` (`request_id`,`status`),
  KEY `idx_request_execute_client` (`request_id`,`execute_client`,`callback_id`) USING BTREE,
  KEY `idx_execute_status` (`execute_id`,`status`),
  KEY `idx_request_execute_sharding` (`request_id`,`execute_handler`,`sharding_rule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chunk_item_076`
--

DROP TABLE IF EXISTS `chunk_item_076`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chunk_item_076` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `md5` varchar(32) DEFAULT NULL,
  `chunk_type` varchar(15) DEFAULT NULL,
  `data` text,
  `job_item_id` int(11) DEFAULT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `execute_id` varchar(64) DEFAULT NULL,
  `execute_handler` varchar(60) DEFAULT NULL,
  `generate_handler` varchar(60) DEFAULT NULL,
  `execute_client` varchar(20) DEFAULT NULL,
  `generate_client` varchar(20) DEFAULT NULL,
  `persistent_server` varchar(20) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `sharding_rule` varchar(200) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `try_count` int(11) DEFAULT NULL,
  `gmt_begin` datetime DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `callback_id` varchar(100) DEFAULT NULL,
  `digest` varchar(128) DEFAULT NULL,
  `extension` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_persistent_server` (`persistent_server`),
  KEY `idx_request_status` (`request_id`,`status`),
  KEY `idx_request_execute_client` (`request_id`,`execute_client`,`callback_id`) USING BTREE,
  KEY `idx_execute_status` (`execute_id`,`status`),
  KEY `idx_request_execute_sharding` (`request_id`,`execute_handler`,`sharding_rule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chunk_item_077`
--

DROP TABLE IF EXISTS `chunk_item_077`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chunk_item_077` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `md5` varchar(32) DEFAULT NULL,
  `chunk_type` varchar(15) DEFAULT NULL,
  `data` text,
  `job_item_id` int(11) DEFAULT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `execute_id` varchar(64) DEFAULT NULL,
  `execute_handler` varchar(60) DEFAULT NULL,
  `generate_handler` varchar(60) DEFAULT NULL,
  `execute_client` varchar(20) DEFAULT NULL,
  `generate_client` varchar(20) DEFAULT NULL,
  `persistent_server` varchar(20) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `sharding_rule` varchar(200) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `try_count` int(11) DEFAULT NULL,
  `gmt_begin` datetime DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `callback_id` varchar(100) DEFAULT NULL,
  `digest` varchar(128) DEFAULT NULL,
  `extension` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_persistent_server` (`persistent_server`),
  KEY `idx_request_status` (`request_id`,`status`),
  KEY `idx_request_execute_client` (`request_id`,`execute_client`,`callback_id`) USING BTREE,
  KEY `idx_execute_status` (`execute_id`,`status`),
  KEY `idx_request_execute_sharding` (`request_id`,`execute_handler`,`sharding_rule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chunk_item_078`
--

DROP TABLE IF EXISTS `chunk_item_078`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chunk_item_078` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `md5` varchar(32) DEFAULT NULL,
  `chunk_type` varchar(15) DEFAULT NULL,
  `data` text,
  `job_item_id` int(11) DEFAULT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `execute_id` varchar(64) DEFAULT NULL,
  `execute_handler` varchar(60) DEFAULT NULL,
  `generate_handler` varchar(60) DEFAULT NULL,
  `execute_client` varchar(20) DEFAULT NULL,
  `generate_client` varchar(20) DEFAULT NULL,
  `persistent_server` varchar(20) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `sharding_rule` varchar(200) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `try_count` int(11) DEFAULT NULL,
  `gmt_begin` datetime DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `callback_id` varchar(100) DEFAULT NULL,
  `digest` varchar(128) DEFAULT NULL,
  `extension` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_persistent_server` (`persistent_server`),
  KEY `idx_request_status` (`request_id`,`status`),
  KEY `idx_request_execute_client` (`request_id`,`execute_client`,`callback_id`) USING BTREE,
  KEY `idx_execute_status` (`execute_id`,`status`),
  KEY `idx_request_execute_sharding` (`request_id`,`execute_handler`,`sharding_rule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chunk_item_079`
--

DROP TABLE IF EXISTS `chunk_item_079`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chunk_item_079` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `md5` varchar(32) DEFAULT NULL,
  `chunk_type` varchar(15) DEFAULT NULL,
  `data` text,
  `job_item_id` int(11) DEFAULT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `execute_id` varchar(64) DEFAULT NULL,
  `execute_handler` varchar(60) DEFAULT NULL,
  `generate_handler` varchar(60) DEFAULT NULL,
  `execute_client` varchar(20) DEFAULT NULL,
  `generate_client` varchar(20) DEFAULT NULL,
  `persistent_server` varchar(20) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `sharding_rule` varchar(200) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `try_count` int(11) DEFAULT NULL,
  `gmt_begin` datetime DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `callback_id` varchar(100) DEFAULT NULL,
  `digest` varchar(128) DEFAULT NULL,
  `extension` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_persistent_server` (`persistent_server`),
  KEY `idx_request_status` (`request_id`,`status`),
  KEY `idx_request_execute_client` (`request_id`,`execute_client`,`callback_id`) USING BTREE,
  KEY `idx_execute_status` (`execute_id`,`status`),
  KEY `idx_request_execute_sharding` (`request_id`,`execute_handler`,`sharding_rule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chunk_item_080`
--

DROP TABLE IF EXISTS `chunk_item_080`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chunk_item_080` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `md5` varchar(32) DEFAULT NULL,
  `chunk_type` varchar(15) DEFAULT NULL,
  `data` text,
  `job_item_id` int(11) DEFAULT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `execute_id` varchar(64) DEFAULT NULL,
  `execute_handler` varchar(60) DEFAULT NULL,
  `generate_handler` varchar(60) DEFAULT NULL,
  `execute_client` varchar(20) DEFAULT NULL,
  `generate_client` varchar(20) DEFAULT NULL,
  `persistent_server` varchar(20) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `sharding_rule` varchar(200) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `try_count` int(11) DEFAULT NULL,
  `gmt_begin` datetime DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `callback_id` varchar(100) DEFAULT NULL,
  `digest` varchar(128) DEFAULT NULL,
  `extension` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_persistent_server` (`persistent_server`),
  KEY `idx_request_status` (`request_id`,`status`),
  KEY `idx_request_execute_client` (`request_id`,`execute_client`,`callback_id`) USING BTREE,
  KEY `idx_execute_status` (`execute_id`,`status`),
  KEY `idx_request_execute_sharding` (`request_id`,`execute_handler`,`sharding_rule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chunk_item_081`
--

DROP TABLE IF EXISTS `chunk_item_081`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chunk_item_081` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `md5` varchar(32) DEFAULT NULL,
  `chunk_type` varchar(15) DEFAULT NULL,
  `data` text,
  `job_item_id` int(11) DEFAULT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `execute_id` varchar(64) DEFAULT NULL,
  `execute_handler` varchar(60) DEFAULT NULL,
  `generate_handler` varchar(60) DEFAULT NULL,
  `execute_client` varchar(20) DEFAULT NULL,
  `generate_client` varchar(20) DEFAULT NULL,
  `persistent_server` varchar(20) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `sharding_rule` varchar(200) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `try_count` int(11) DEFAULT NULL,
  `gmt_begin` datetime DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `callback_id` varchar(100) DEFAULT NULL,
  `digest` varchar(128) DEFAULT NULL,
  `extension` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_persistent_server` (`persistent_server`),
  KEY `idx_request_status` (`request_id`,`status`),
  KEY `idx_request_execute_client` (`request_id`,`execute_client`,`callback_id`) USING BTREE,
  KEY `idx_execute_status` (`execute_id`,`status`),
  KEY `idx_request_execute_sharding` (`request_id`,`execute_handler`,`sharding_rule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chunk_item_082`
--

DROP TABLE IF EXISTS `chunk_item_082`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chunk_item_082` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `md5` varchar(32) DEFAULT NULL,
  `chunk_type` varchar(15) DEFAULT NULL,
  `data` text,
  `job_item_id` int(11) DEFAULT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `execute_id` varchar(64) DEFAULT NULL,
  `execute_handler` varchar(60) DEFAULT NULL,
  `generate_handler` varchar(60) DEFAULT NULL,
  `execute_client` varchar(20) DEFAULT NULL,
  `generate_client` varchar(20) DEFAULT NULL,
  `persistent_server` varchar(20) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `sharding_rule` varchar(200) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `try_count` int(11) DEFAULT NULL,
  `gmt_begin` datetime DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `callback_id` varchar(100) DEFAULT NULL,
  `digest` varchar(128) DEFAULT NULL,
  `extension` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_persistent_server` (`persistent_server`),
  KEY `idx_request_status` (`request_id`,`status`),
  KEY `idx_request_execute_client` (`request_id`,`execute_client`,`callback_id`) USING BTREE,
  KEY `idx_execute_status` (`execute_id`,`status`),
  KEY `idx_request_execute_sharding` (`request_id`,`execute_handler`,`sharding_rule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chunk_item_083`
--

DROP TABLE IF EXISTS `chunk_item_083`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chunk_item_083` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `md5` varchar(32) DEFAULT NULL,
  `chunk_type` varchar(15) DEFAULT NULL,
  `data` text,
  `job_item_id` int(11) DEFAULT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `execute_id` varchar(64) DEFAULT NULL,
  `execute_handler` varchar(60) DEFAULT NULL,
  `generate_handler` varchar(60) DEFAULT NULL,
  `execute_client` varchar(20) DEFAULT NULL,
  `generate_client` varchar(20) DEFAULT NULL,
  `persistent_server` varchar(20) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `sharding_rule` varchar(200) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `try_count` int(11) DEFAULT NULL,
  `gmt_begin` datetime DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `callback_id` varchar(100) DEFAULT NULL,
  `digest` varchar(128) DEFAULT NULL,
  `extension` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_persistent_server` (`persistent_server`),
  KEY `idx_request_status` (`request_id`,`status`),
  KEY `idx_request_execute_client` (`request_id`,`execute_client`,`callback_id`) USING BTREE,
  KEY `idx_execute_status` (`execute_id`,`status`),
  KEY `idx_request_execute_sharding` (`request_id`,`execute_handler`,`sharding_rule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chunk_item_084`
--

DROP TABLE IF EXISTS `chunk_item_084`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chunk_item_084` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `md5` varchar(32) DEFAULT NULL,
  `chunk_type` varchar(15) DEFAULT NULL,
  `data` text,
  `job_item_id` int(11) DEFAULT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `execute_id` varchar(64) DEFAULT NULL,
  `execute_handler` varchar(60) DEFAULT NULL,
  `generate_handler` varchar(60) DEFAULT NULL,
  `execute_client` varchar(20) DEFAULT NULL,
  `generate_client` varchar(20) DEFAULT NULL,
  `persistent_server` varchar(20) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `sharding_rule` varchar(200) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `try_count` int(11) DEFAULT NULL,
  `gmt_begin` datetime DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `callback_id` varchar(100) DEFAULT NULL,
  `digest` varchar(128) DEFAULT NULL,
  `extension` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_persistent_server` (`persistent_server`),
  KEY `idx_request_status` (`request_id`,`status`),
  KEY `idx_request_execute_client` (`request_id`,`execute_client`,`callback_id`) USING BTREE,
  KEY `idx_execute_status` (`execute_id`,`status`),
  KEY `idx_request_execute_sharding` (`request_id`,`execute_handler`,`sharding_rule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chunk_item_085`
--

DROP TABLE IF EXISTS `chunk_item_085`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chunk_item_085` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `md5` varchar(32) DEFAULT NULL,
  `chunk_type` varchar(15) DEFAULT NULL,
  `data` text,
  `job_item_id` int(11) DEFAULT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `execute_id` varchar(64) DEFAULT NULL,
  `execute_handler` varchar(60) DEFAULT NULL,
  `generate_handler` varchar(60) DEFAULT NULL,
  `execute_client` varchar(20) DEFAULT NULL,
  `generate_client` varchar(20) DEFAULT NULL,
  `persistent_server` varchar(20) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `sharding_rule` varchar(200) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `try_count` int(11) DEFAULT NULL,
  `gmt_begin` datetime DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `callback_id` varchar(100) DEFAULT NULL,
  `digest` varchar(128) DEFAULT NULL,
  `extension` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_persistent_server` (`persistent_server`),
  KEY `idx_request_status` (`request_id`,`status`),
  KEY `idx_request_execute_client` (`request_id`,`execute_client`,`callback_id`) USING BTREE,
  KEY `idx_execute_status` (`execute_id`,`status`),
  KEY `idx_request_execute_sharding` (`request_id`,`execute_handler`,`sharding_rule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chunk_item_086`
--

DROP TABLE IF EXISTS `chunk_item_086`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chunk_item_086` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `md5` varchar(32) DEFAULT NULL,
  `chunk_type` varchar(15) DEFAULT NULL,
  `data` text,
  `job_item_id` int(11) DEFAULT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `execute_id` varchar(64) DEFAULT NULL,
  `execute_handler` varchar(60) DEFAULT NULL,
  `generate_handler` varchar(60) DEFAULT NULL,
  `execute_client` varchar(20) DEFAULT NULL,
  `generate_client` varchar(20) DEFAULT NULL,
  `persistent_server` varchar(20) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `sharding_rule` varchar(200) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `try_count` int(11) DEFAULT NULL,
  `gmt_begin` datetime DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `callback_id` varchar(100) DEFAULT NULL,
  `digest` varchar(128) DEFAULT NULL,
  `extension` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_persistent_server` (`persistent_server`),
  KEY `idx_request_status` (`request_id`,`status`),
  KEY `idx_request_execute_client` (`request_id`,`execute_client`,`callback_id`) USING BTREE,
  KEY `idx_execute_status` (`execute_id`,`status`),
  KEY `idx_request_execute_sharding` (`request_id`,`execute_handler`,`sharding_rule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chunk_item_087`
--

DROP TABLE IF EXISTS `chunk_item_087`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chunk_item_087` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `md5` varchar(32) DEFAULT NULL,
  `chunk_type` varchar(15) DEFAULT NULL,
  `data` text,
  `job_item_id` int(11) DEFAULT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `execute_id` varchar(64) DEFAULT NULL,
  `execute_handler` varchar(60) DEFAULT NULL,
  `generate_handler` varchar(60) DEFAULT NULL,
  `execute_client` varchar(20) DEFAULT NULL,
  `generate_client` varchar(20) DEFAULT NULL,
  `persistent_server` varchar(20) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `sharding_rule` varchar(200) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `try_count` int(11) DEFAULT NULL,
  `gmt_begin` datetime DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `callback_id` varchar(100) DEFAULT NULL,
  `digest` varchar(128) DEFAULT NULL,
  `extension` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_persistent_server` (`persistent_server`),
  KEY `idx_request_status` (`request_id`,`status`),
  KEY `idx_request_execute_client` (`request_id`,`execute_client`,`callback_id`) USING BTREE,
  KEY `idx_execute_status` (`execute_id`,`status`),
  KEY `idx_request_execute_sharding` (`request_id`,`execute_handler`,`sharding_rule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chunk_item_088`
--

DROP TABLE IF EXISTS `chunk_item_088`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chunk_item_088` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `md5` varchar(32) DEFAULT NULL,
  `chunk_type` varchar(15) DEFAULT NULL,
  `data` text,
  `job_item_id` int(11) DEFAULT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `execute_id` varchar(64) DEFAULT NULL,
  `execute_handler` varchar(60) DEFAULT NULL,
  `generate_handler` varchar(60) DEFAULT NULL,
  `execute_client` varchar(20) DEFAULT NULL,
  `generate_client` varchar(20) DEFAULT NULL,
  `persistent_server` varchar(20) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `sharding_rule` varchar(200) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `try_count` int(11) DEFAULT NULL,
  `gmt_begin` datetime DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `callback_id` varchar(100) DEFAULT NULL,
  `digest` varchar(128) DEFAULT NULL,
  `extension` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_persistent_server` (`persistent_server`),
  KEY `idx_request_status` (`request_id`,`status`),
  KEY `idx_request_execute_client` (`request_id`,`execute_client`,`callback_id`) USING BTREE,
  KEY `idx_execute_status` (`execute_id`,`status`),
  KEY `idx_request_execute_sharding` (`request_id`,`execute_handler`,`sharding_rule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chunk_item_089`
--

DROP TABLE IF EXISTS `chunk_item_089`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chunk_item_089` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `md5` varchar(32) DEFAULT NULL,
  `chunk_type` varchar(15) DEFAULT NULL,
  `data` text,
  `job_item_id` int(11) DEFAULT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `execute_id` varchar(64) DEFAULT NULL,
  `execute_handler` varchar(60) DEFAULT NULL,
  `generate_handler` varchar(60) DEFAULT NULL,
  `execute_client` varchar(20) DEFAULT NULL,
  `generate_client` varchar(20) DEFAULT NULL,
  `persistent_server` varchar(20) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `sharding_rule` varchar(200) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `try_count` int(11) DEFAULT NULL,
  `gmt_begin` datetime DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `callback_id` varchar(100) DEFAULT NULL,
  `digest` varchar(128) DEFAULT NULL,
  `extension` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_persistent_server` (`persistent_server`),
  KEY `idx_request_status` (`request_id`,`status`),
  KEY `idx_request_execute_client` (`request_id`,`execute_client`,`callback_id`) USING BTREE,
  KEY `idx_execute_status` (`execute_id`,`status`),
  KEY `idx_request_execute_sharding` (`request_id`,`execute_handler`,`sharding_rule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chunk_item_090`
--

DROP TABLE IF EXISTS `chunk_item_090`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chunk_item_090` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `md5` varchar(32) DEFAULT NULL,
  `chunk_type` varchar(15) DEFAULT NULL,
  `data` text,
  `job_item_id` int(11) DEFAULT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `execute_id` varchar(64) DEFAULT NULL,
  `execute_handler` varchar(60) DEFAULT NULL,
  `generate_handler` varchar(60) DEFAULT NULL,
  `execute_client` varchar(20) DEFAULT NULL,
  `generate_client` varchar(20) DEFAULT NULL,
  `persistent_server` varchar(20) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `sharding_rule` varchar(200) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `try_count` int(11) DEFAULT NULL,
  `gmt_begin` datetime DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `callback_id` varchar(100) DEFAULT NULL,
  `digest` varchar(128) DEFAULT NULL,
  `extension` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_persistent_server` (`persistent_server`),
  KEY `idx_request_status` (`request_id`,`status`),
  KEY `idx_request_execute_client` (`request_id`,`execute_client`,`callback_id`) USING BTREE,
  KEY `idx_execute_status` (`execute_id`,`status`),
  KEY `idx_request_execute_sharding` (`request_id`,`execute_handler`,`sharding_rule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chunk_item_091`
--

DROP TABLE IF EXISTS `chunk_item_091`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chunk_item_091` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `md5` varchar(32) DEFAULT NULL,
  `chunk_type` varchar(15) DEFAULT NULL,
  `data` text,
  `job_item_id` int(11) DEFAULT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `execute_id` varchar(64) DEFAULT NULL,
  `execute_handler` varchar(60) DEFAULT NULL,
  `generate_handler` varchar(60) DEFAULT NULL,
  `execute_client` varchar(20) DEFAULT NULL,
  `generate_client` varchar(20) DEFAULT NULL,
  `persistent_server` varchar(20) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `sharding_rule` varchar(200) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `try_count` int(11) DEFAULT NULL,
  `gmt_begin` datetime DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `callback_id` varchar(100) DEFAULT NULL,
  `digest` varchar(128) DEFAULT NULL,
  `extension` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_persistent_server` (`persistent_server`),
  KEY `idx_request_status` (`request_id`,`status`),
  KEY `idx_request_execute_client` (`request_id`,`execute_client`,`callback_id`) USING BTREE,
  KEY `idx_execute_status` (`execute_id`,`status`),
  KEY `idx_request_execute_sharding` (`request_id`,`execute_handler`,`sharding_rule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chunk_item_092`
--

DROP TABLE IF EXISTS `chunk_item_092`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chunk_item_092` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `md5` varchar(32) DEFAULT NULL,
  `chunk_type` varchar(15) DEFAULT NULL,
  `data` text,
  `job_item_id` int(11) DEFAULT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `execute_id` varchar(64) DEFAULT NULL,
  `execute_handler` varchar(60) DEFAULT NULL,
  `generate_handler` varchar(60) DEFAULT NULL,
  `execute_client` varchar(20) DEFAULT NULL,
  `generate_client` varchar(20) DEFAULT NULL,
  `persistent_server` varchar(20) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `sharding_rule` varchar(200) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `try_count` int(11) DEFAULT NULL,
  `gmt_begin` datetime DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `callback_id` varchar(100) DEFAULT NULL,
  `digest` varchar(128) DEFAULT NULL,
  `extension` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_persistent_server` (`persistent_server`),
  KEY `idx_request_status` (`request_id`,`status`),
  KEY `idx_request_execute_client` (`request_id`,`execute_client`,`callback_id`) USING BTREE,
  KEY `idx_execute_status` (`execute_id`,`status`),
  KEY `idx_request_execute_sharding` (`request_id`,`execute_handler`,`sharding_rule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chunk_item_093`
--

DROP TABLE IF EXISTS `chunk_item_093`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chunk_item_093` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `md5` varchar(32) DEFAULT NULL,
  `chunk_type` varchar(15) DEFAULT NULL,
  `data` text,
  `job_item_id` int(11) DEFAULT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `execute_id` varchar(64) DEFAULT NULL,
  `execute_handler` varchar(60) DEFAULT NULL,
  `generate_handler` varchar(60) DEFAULT NULL,
  `execute_client` varchar(20) DEFAULT NULL,
  `generate_client` varchar(20) DEFAULT NULL,
  `persistent_server` varchar(20) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `sharding_rule` varchar(200) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `try_count` int(11) DEFAULT NULL,
  `gmt_begin` datetime DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `callback_id` varchar(100) DEFAULT NULL,
  `digest` varchar(128) DEFAULT NULL,
  `extension` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_persistent_server` (`persistent_server`),
  KEY `idx_request_status` (`request_id`,`status`),
  KEY `idx_request_execute_client` (`request_id`,`execute_client`,`callback_id`) USING BTREE,
  KEY `idx_execute_status` (`execute_id`,`status`),
  KEY `idx_request_execute_sharding` (`request_id`,`execute_handler`,`sharding_rule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chunk_item_094`
--

DROP TABLE IF EXISTS `chunk_item_094`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chunk_item_094` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `md5` varchar(32) DEFAULT NULL,
  `chunk_type` varchar(15) DEFAULT NULL,
  `data` text,
  `job_item_id` int(11) DEFAULT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `execute_id` varchar(64) DEFAULT NULL,
  `execute_handler` varchar(60) DEFAULT NULL,
  `generate_handler` varchar(60) DEFAULT NULL,
  `execute_client` varchar(20) DEFAULT NULL,
  `generate_client` varchar(20) DEFAULT NULL,
  `persistent_server` varchar(20) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `sharding_rule` varchar(200) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `try_count` int(11) DEFAULT NULL,
  `gmt_begin` datetime DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `callback_id` varchar(100) DEFAULT NULL,
  `digest` varchar(128) DEFAULT NULL,
  `extension` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_persistent_server` (`persistent_server`),
  KEY `idx_request_status` (`request_id`,`status`),
  KEY `idx_request_execute_client` (`request_id`,`execute_client`,`callback_id`) USING BTREE,
  KEY `idx_execute_status` (`execute_id`,`status`),
  KEY `idx_request_execute_sharding` (`request_id`,`execute_handler`,`sharding_rule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chunk_item_095`
--

DROP TABLE IF EXISTS `chunk_item_095`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chunk_item_095` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `md5` varchar(32) DEFAULT NULL,
  `chunk_type` varchar(15) DEFAULT NULL,
  `data` text,
  `job_item_id` int(11) DEFAULT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `execute_id` varchar(64) DEFAULT NULL,
  `execute_handler` varchar(60) DEFAULT NULL,
  `generate_handler` varchar(60) DEFAULT NULL,
  `execute_client` varchar(20) DEFAULT NULL,
  `generate_client` varchar(20) DEFAULT NULL,
  `persistent_server` varchar(20) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `sharding_rule` varchar(200) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `try_count` int(11) DEFAULT NULL,
  `gmt_begin` datetime DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `callback_id` varchar(100) DEFAULT NULL,
  `digest` varchar(128) DEFAULT NULL,
  `extension` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_persistent_server` (`persistent_server`),
  KEY `idx_request_status` (`request_id`,`status`),
  KEY `idx_request_execute_client` (`request_id`,`execute_client`,`callback_id`) USING BTREE,
  KEY `idx_execute_status` (`execute_id`,`status`),
  KEY `idx_request_execute_sharding` (`request_id`,`execute_handler`,`sharding_rule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chunk_item_096`
--

DROP TABLE IF EXISTS `chunk_item_096`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chunk_item_096` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `md5` varchar(32) DEFAULT NULL,
  `chunk_type` varchar(15) DEFAULT NULL,
  `data` text,
  `job_item_id` int(11) DEFAULT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `execute_id` varchar(64) DEFAULT NULL,
  `execute_handler` varchar(60) DEFAULT NULL,
  `generate_handler` varchar(60) DEFAULT NULL,
  `execute_client` varchar(20) DEFAULT NULL,
  `generate_client` varchar(20) DEFAULT NULL,
  `persistent_server` varchar(20) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `sharding_rule` varchar(200) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `try_count` int(11) DEFAULT NULL,
  `gmt_begin` datetime DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `callback_id` varchar(100) DEFAULT NULL,
  `digest` varchar(128) DEFAULT NULL,
  `extension` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_persistent_server` (`persistent_server`),
  KEY `idx_request_status` (`request_id`,`status`),
  KEY `idx_request_execute_client` (`request_id`,`execute_client`,`callback_id`) USING BTREE,
  KEY `idx_execute_status` (`execute_id`,`status`),
  KEY `idx_request_execute_sharding` (`request_id`,`execute_handler`,`sharding_rule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chunk_item_097`
--

DROP TABLE IF EXISTS `chunk_item_097`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chunk_item_097` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `md5` varchar(32) DEFAULT NULL,
  `chunk_type` varchar(15) DEFAULT NULL,
  `data` text,
  `job_item_id` int(11) DEFAULT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `execute_id` varchar(64) DEFAULT NULL,
  `execute_handler` varchar(60) DEFAULT NULL,
  `generate_handler` varchar(60) DEFAULT NULL,
  `execute_client` varchar(20) DEFAULT NULL,
  `generate_client` varchar(20) DEFAULT NULL,
  `persistent_server` varchar(20) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `sharding_rule` varchar(200) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `try_count` int(11) DEFAULT NULL,
  `gmt_begin` datetime DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `callback_id` varchar(100) DEFAULT NULL,
  `digest` varchar(128) DEFAULT NULL,
  `extension` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_persistent_server` (`persistent_server`),
  KEY `idx_request_status` (`request_id`,`status`),
  KEY `idx_request_execute_client` (`request_id`,`execute_client`,`callback_id`) USING BTREE,
  KEY `idx_execute_status` (`execute_id`,`status`),
  KEY `idx_request_execute_sharding` (`request_id`,`execute_handler`,`sharding_rule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chunk_item_098`
--

DROP TABLE IF EXISTS `chunk_item_098`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chunk_item_098` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `md5` varchar(32) DEFAULT NULL,
  `chunk_type` varchar(15) DEFAULT NULL,
  `data` text,
  `job_item_id` int(11) DEFAULT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `execute_id` varchar(64) DEFAULT NULL,
  `execute_handler` varchar(60) DEFAULT NULL,
  `generate_handler` varchar(60) DEFAULT NULL,
  `execute_client` varchar(20) DEFAULT NULL,
  `generate_client` varchar(20) DEFAULT NULL,
  `persistent_server` varchar(20) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `sharding_rule` varchar(200) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `try_count` int(11) DEFAULT NULL,
  `gmt_begin` datetime DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `callback_id` varchar(100) DEFAULT NULL,
  `digest` varchar(128) DEFAULT NULL,
  `extension` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_persistent_server` (`persistent_server`),
  KEY `idx_request_status` (`request_id`,`status`),
  KEY `idx_request_execute_client` (`request_id`,`execute_client`,`callback_id`) USING BTREE,
  KEY `idx_execute_status` (`execute_id`,`status`),
  KEY `idx_request_execute_sharding` (`request_id`,`execute_handler`,`sharding_rule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chunk_item_099`
--

DROP TABLE IF EXISTS `chunk_item_099`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chunk_item_099` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `md5` varchar(32) DEFAULT NULL,
  `chunk_type` varchar(15) DEFAULT NULL,
  `data` text,
  `job_item_id` int(11) DEFAULT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `execute_id` varchar(64) DEFAULT NULL,
  `execute_handler` varchar(60) DEFAULT NULL,
  `generate_handler` varchar(60) DEFAULT NULL,
  `execute_client` varchar(20) DEFAULT NULL,
  `generate_client` varchar(20) DEFAULT NULL,
  `persistent_server` varchar(20) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `sharding_rule` varchar(200) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `try_count` int(11) DEFAULT NULL,
  `gmt_begin` datetime DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `callback_id` varchar(100) DEFAULT NULL,
  `digest` varchar(128) DEFAULT NULL,
  `extension` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_persistent_server` (`persistent_server`),
  KEY `idx_request_status` (`request_id`,`status`),
  KEY `idx_request_execute_client` (`request_id`,`execute_client`,`callback_id`) USING BTREE,
  KEY `idx_execute_status` (`execute_id`,`status`),
  KEY `idx_request_execute_sharding` (`request_id`,`execute_handler`,`sharding_rule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `config`
--

DROP TABLE IF EXISTS `config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `config` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `instance_id` varchar(20) DEFAULT NULL,
  `config_key` varchar(50) DEFAULT NULL,
  `config_value` varchar(2048) DEFAULT NULL COMMENT '配置值',
  `gmt_modify` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `INSTANCE_KEY` (`instance_id`,`config_key`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `instance`
--

DROP TABLE IF EXISTS `instance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `instance` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `instance_id` varchar(20) DEFAULT NULL,
  `status` varchar(10) DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL,
  `tenant_id` varchar(128) DEFAULT NULL COMMENT '租户标志',
  `workspace_id` varchar(128) DEFAULT NULL COMMENT '工作空间标志',
  `ant_uid` varchar(128) DEFAULT NULL COMMENT '阿里云uid',
  `business_owner_id` varchar(128) DEFAULT NULL COMMENT '阿里云ownerId',
  `ant_account` varchar(128) DEFAULT NULL COMMENT 'ant_account',
  `customer` varchar(128) DEFAULT NULL COMMENT 'customer',
  `internal_id` varchar(128) DEFAULT NULL COMMENT 'internal_id',
  `account_name` varchar(128) DEFAULT NULL COMMENT 'account_name',
  `description` varchar(512) DEFAULT NULL COMMENT '描述',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=103 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `job`
--

DROP TABLE IF EXISTS `job`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `job` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(60) DEFAULT NULL,
  `cron` varchar(128) DEFAULT NULL,
  `app` varchar(50) DEFAULT NULL,
  `fail_handle_strategy` varchar(25) DEFAULT NULL,
  `route_strategy` varchar(15) DEFAULT NULL,
  `invoke_type` varchar(15) DEFAULT NULL,
  `handlers` varchar(1024) DEFAULT NULL,
  `type` varchar(32) DEFAULT NULL,
  `instance_id` varchar(20) DEFAULT NULL,
  `timeout` int(11) DEFAULT NULL,
  `time_unit` varchar(15) DEFAULT NULL,
  `hashcode` int(11) DEFAULT NULL,
  `des` varchar(1024) DEFAULT NULL,
  `trigger_mode` varchar(10) DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `sharding_count` int(11) DEFAULT NULL,
  `trigger_type` varchar(15) DEFAULT NULL,
  `context` varchar(2048) DEFAULT NULL,
  `gray_ratio` int(11) DEFAULT NULL,
  `misfire_strategy` varchar(20) DEFAULT NULL,
  `pre_auto_trigger` tinyint(4) DEFAULT NULL COMMENT '预发是否自动触发',
  `priority` varchar(20) NOT NULL DEFAULT 'M' COMMENT 'job 优先级:VH,H,M,L,VL',
  `group_id` int(10) DEFAULT '0' COMMENT '任务分组id',
  `operator` varchar(50) DEFAULT NULL COMMENT '操作人',
  `exclusive` tinyint(3) DEFAULT '0' COMMENT '是否开启任务互斥：0-否，1-是',
  `timeout_strategy` varchar(20) DEFAULT NULL COMMENT '超时处理策略',
  `enable_forward` tinyint(4) DEFAULT '1',
  `secret_key` varchar(60) DEFAULT NULL,
  `retry_count` int(11) DEFAULT '0',
  `gmt_effective` datetime DEFAULT NULL,
  `effective` tinyint(4) DEFAULT '1' COMMENT '是否迁移生效',
  `time_zone` varchar(64) DEFAULT NULL COMMENT '触发时区',
  `extension_info` varchar(1024) DEFAULT NULL COMMENT '扩展字段',
  `job_run_mode` varchar(32) DEFAULT NULL,
  `dry_run` varchar(32) DEFAULT NULL COMMENT 'dry run 的类型或模式',
  `env` varchar(64) DEFAULT NULL COMMENT '任务所属环境',
  `future_job_type_str` varchar(15) DEFAULT NULL COMMENT '新增任务类型存储字段',
  `disable` tinyint(2) DEFAULT '0' COMMENT '0表示可用，1表示删除',
  `gmt_modify` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`),
  KEY `idx_group` (`group_id`) USING BTREE,
  KEY `idx_disable` (`disable`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `job_execute_record`
--

DROP TABLE IF EXISTS `job_execute_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `job_execute_record` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `request_id` varchar(64) DEFAULT NULL,
  `job_id` bigint(20) NOT NULL COMMENT '任务id',
  `target_server` varchar(16) DEFAULT NULL,
  `trigger_server` varchar(16) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `gmt_begin` timestamp(6) NULL DEFAULT NULL,
  `gmt_end` timestamp(6) NULL DEFAULT NULL,
  `gmt_create` timestamp(6) NULL DEFAULT NULL,
  `sharding` int(11) DEFAULT NULL,
  `job_item_id` bigint(20) NOT NULL COMMENT '任务id',
  `type` varchar(15) DEFAULT NULL,
  `execute_id` varchar(64) DEFAULT NULL,
  `handler` varchar(256) DEFAULT NULL,
  `context` varbinary(2048) DEFAULT NULL,
  `try_count` int(11) DEFAULT '0' COMMENT '重试次数',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_execute_hander` (`execute_id`,`handler`(190)) USING BTREE,
  KEY `idx_target_server` (`target_server`) USING BTREE,
  KEY `idx_request` (`request_id`) USING BTREE,
  KEY `idx_status` (`status`) USING BTREE,
  KEY `idx_gmt_create` (`gmt_create`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `job_group`
--

DROP TABLE IF EXISTS `job_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `job_group` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
  `name` varchar(64) NOT NULL DEFAULT '' COMMENT 'group 名字',
  `instance_id` varchar(20) NOT NULL DEFAULT '' COMMENT '实例id',
  `description` varchar(1024) DEFAULT NULL COMMENT '描述',
  `operator` varchar(100) DEFAULT NULL COMMENT '创建人',
  `gmt_create` datetime DEFAULT NULL COMMENT '创建时间',
  `gmt_modify` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_name` (`instance_id`,`name`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `job_item`
--

DROP TABLE IF EXISTS `job_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `job_item` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `job_id` bigint(20) NOT NULL COMMENT '任务id',
  `zone` varchar(60) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `load_server` varchar(20) DEFAULT NULL,
  `ops_type` varchar(15) DEFAULT NULL,
  `gmt_modify` timestamp NULL DEFAULT NULL,
  `gmt_load` timestamp NULL DEFAULT NULL,
  `sofarouter_group` varchar(100) DEFAULT NULL,
  `origin_status` varchar(15) DEFAULT NULL,
  `job_zone` varchar(60) DEFAULT NULL,
  `origin_job_zone` varchar(60) DEFAULT NULL,
  `gmt_start` datetime DEFAULT NULL,
  `gmt_end` datetime DEFAULT NULL,
  `pre_job_zone` varchar(60) DEFAULT NULL COMMENT '容灾切换前的job_zone',
  `gmt_create` datetime DEFAULT NULL COMMENT '创建时间',
  `disable` tinyint(2) DEFAULT '0' COMMENT '0表示可用，1表示删除',
  `load_server_slave` varchar(16) DEFAULT NULL COMMENT '加载任务的slave机器',
  `slave_ops_type` varchar(15) DEFAULT NULL COMMENT '加载任务的slave机器',
  PRIMARY KEY (`id`),
  KEY `idx_job` (`job_id`) USING BTREE,
  KEY `idx_load_server` (`load_server`) USING BTREE,
  KEY `idx_disable` (`disable`),
  KEY `idx_load_server_slave` (`load_server_slave`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `job_trigger_record`
--

DROP TABLE IF EXISTS `job_trigger_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `job_trigger_record` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `request_id` varchar(64) DEFAULT NULL,
  `job_id` bigint(20) NOT NULL COMMENT '任务id',
  `zone` varchar(60) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `trigger_server` varchar(16) DEFAULT NULL,
  `gmt_trigger` timestamp(6) NULL DEFAULT NULL,
  `gmt_end` timestamp(6) NULL DEFAULT NULL,
  `trigger_type` varchar(15) DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `gmt_expect_trigger` timestamp(6) NULL DEFAULT NULL,
  `sharding_count` int(11) DEFAULT NULL,
  `handlers` varchar(1024) DEFAULT NULL,
  `job_item_id` int(11) DEFAULT NULL,
  `context` varbinary(2048) DEFAULT NULL,
  `operator` varchar(100) DEFAULT NULL,
  `activity_instance_id` int(11) DEFAULT NULL,
  `instance_id` varchar(20) DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL COMMENT '修改时间',
  `activity_sharding` varchar(50) DEFAULT NULL COMMENT '节点实例分片',
  `job_name` varchar(60) DEFAULT NULL,
  `job_type` varchar(32) DEFAULT NULL,
  `is_retring` tinyint(4) DEFAULT '0',
  `extension` varchar(1024) DEFAULT NULL COMMENT '扩展字段',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_job_item_expect_type_activity` (`job_item_id`,`gmt_expect_trigger`,`trigger_type`,`activity_instance_id`) USING BTREE,
  KEY `idx_job` (`job_id`) USING BTREE,
  KEY `idx_status` (`status`) USING BTREE,
  KEY `idx_request` (`request_id`) USING BTREE,
  KEY `idx_activity` (`activity_instance_id`) USING BTREE,
  KEY `idx_status_zone` (`status`,`zone`),
  KEY `idx_gmt_expect_trigger` (`gmt_expect_trigger`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `operation_record`
--

DROP TABLE IF EXISTS `operation_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `operation_record` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `instance_id` varchar(20) DEFAULT NULL,
  `operator` varchar(100) DEFAULT NULL,
  `operation` varchar(64) DEFAULT NULL,
  `operation_result` tinyint(4) DEFAULT NULL,
  `gmt_operate` datetime DEFAULT NULL,
  `operation_target` varchar(32) NOT NULL DEFAULT '' COMMENT '操作对象',
  `name` varchar(64) NOT NULL DEFAULT '' COMMENT '任务名字',
  `operation_value` text,
  PRIMARY KEY (`id`),
  KEY `INSTANCE_IDX` (`instance_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pipeline`
--

DROP TABLE IF EXISTS `pipeline`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pipeline` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `process_id` int(11) DEFAULT NULL,
  `expression` varchar(128) DEFAULT NULL,
  `pre_activity_id` int(11) DEFAULT NULL,
  `post_activity_id` int(11) DEFAULT NULL,
  `disable` tinyint(2) DEFAULT '0' COMMENT '0表示可用，1表示删除',
  `gmt_modify` datetime DEFAULT NULL COMMENT '修改时间',
  `gmt_create` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_process_id_pre_activity` (`process_id`,`pre_activity_id`) USING BTREE,
  KEY `idx_process_id_post_activity` (`process_id`,`post_activity_id`) USING BTREE,
  KEY `idx_disable` (`disable`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `process`
--

DROP TABLE IF EXISTS `process`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `process` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `job_id` bigint(20) NOT NULL COMMENT '任务id',
  `version` int(11) DEFAULT NULL,
  `gmt_create` timestamp NULL DEFAULT NULL,
  `base_version` int(11) DEFAULT NULL,
  `status` varchar(16) DEFAULT NULL,
  `operator` varchar(256) DEFAULT NULL,
  `gmt_effective` timestamp NULL DEFAULT NULL,
  `remark` varchar(1024) DEFAULT NULL,
  `disable` tinyint(2) DEFAULT '0' COMMENT '0表示可用，1表示删除',
  `gmt_modify` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unq_job_id_version` (`job_id`,`version`) USING BTREE,
  KEY `idx_disable` (`disable`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `process_instance`
--

DROP TABLE IF EXISTS `process_instance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `process_instance` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `process_id` int(11) DEFAULT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `job_item_id` bigint(20) NOT NULL COMMENT 'jobItem id',
  `gmt_create` timestamp(6) NULL DEFAULT NULL,
  `context` varbinary(2048) DEFAULT NULL,
  `is_beta` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_request_id` (`request_id`) USING BTREE,
  KEY `idx_create` (`gmt_create`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_info`
--

DROP TABLE IF EXISTS `product_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_info` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `ant_uid` varchar(128) NOT NULL COMMENT '阿里云uid',
  `status` varchar(128) DEFAULT NULL COMMENT '产品状态',
  `gmt_create` datetime DEFAULT NULL COMMENT '创建时间',
  `gmt_modified` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_ant_uid` (`ant_uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sequence`
--

DROP TABLE IF EXISTS `sequence`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sequence` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `value` bigint(20) DEFAULT '0' COMMENT '当前值',
  `min_value` int(11) DEFAULT NULL,
  `max_value` bigint(20) DEFAULT '0' COMMENT '最大值',
  `step` int(11) DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `gmt_modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_name` (`name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `server`
--

DROP TABLE IF EXISTS `server`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `server` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `hostname` varchar(100) DEFAULT NULL,
  `ip` varchar(20) DEFAULT NULL,
  `is_master` tinyint(4) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `zone` varchar(60) DEFAULT NULL,
  `master_lock` varchar(160) DEFAULT NULL,
  `heartbeat` timestamp NULL DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `master_lock` (`zone`,`master_lock`,`status`) USING BTREE,
  KEY `idx_hostname` (`hostname`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `stream_execute_record`
--

DROP TABLE IF EXISTS `stream_execute_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `stream_execute_record` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `request_id` varchar(64) DEFAULT NULL,
  `job_id` bigint(20) NOT NULL COMMENT '任务id',
  `target_server` varchar(16) DEFAULT NULL,
  `trigger_server` varchar(16) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `msg` varchar(1024) DEFAULT NULL,
  `gmt_begin` timestamp(6) NULL DEFAULT NULL,
  `gmt_end` timestamp(6) NULL DEFAULT NULL,
  `gmt_create` timestamp(6) NULL DEFAULT NULL,
  `sharding` int(11) DEFAULT NULL,
  `job_item_id` bigint(20) NOT NULL COMMENT '任务id',
  `type` varchar(15) DEFAULT NULL,
  `execute_id` varchar(64) DEFAULT NULL,
  `handler` varchar(256) DEFAULT NULL,
  `context` varbinary(2048) DEFAULT NULL,
  `try_count` int(11) DEFAULT '0' COMMENT '重试次数',
  `zone` varchar(50) DEFAULT NULL COMMENT 'zone',
  PRIMARY KEY (`id`),
  KEY `idx_request` (`request_id`) USING BTREE,
  KEY `idx_jobid_zone` (`job_id`,`zone`) USING BTREE,
  KEY `idx_zone_gmtcreate` (`zone`,`gmt_create`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `trigger_log`
--

DROP TABLE IF EXISTS `trigger_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `trigger_log` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `job_name` varchar(60) DEFAULT NULL COMMENT '任务名',
  `zone` varchar(60) DEFAULT NULL COMMENT '逻辑机房',
  `trigger_time` timestamp NULL DEFAULT NULL COMMENT '触发时间',
  `custom_param` text COMMENT '自定义参数',
  `extra` varchar(2048) DEFAULT NULL COMMENT '扩展',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unq_job_name_zone` (`job_name`,`zone`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `zone`
--

DROP TABLE IF EXISTS `zone`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `zone` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(60) DEFAULT NULL,
  `type` varchar(15) DEFAULT NULL,
  `switch_zone` varchar(60) DEFAULT NULL,
  `gmt_modify` datetime DEFAULT NULL,
  `forward_zone` varchar(60) DEFAULT NULL,
  `forward_status` varchar(20) DEFAULT NULL,
  `gray_forward_zone` varchar(60) DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `pre_switch_zone` varchar(60) DEFAULT NULL COMMENT '恢复前的目标zone',
  `ldc_type` varchar(60) DEFAULT NULL COMMENT '逻辑zone类型，如RZone/GZone/CZone',
  PRIMARY KEY (`id`),
  KEY `name` (`name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `zone_migrate_log`
--

DROP TABLE IF EXISTS `zone_migrate_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `zone_migrate_log` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `instance_id` varchar(20) NOT NULL COMMENT '金融云的instanceId',
  `job_id` bigint(20) NOT NULL COMMENT '任务id',
  `name` varchar(64) DEFAULT NULL COMMENT '任务名字',
  `app` varchar(64) DEFAULT NULL COMMENT '应用名字',
  `zone` varchar(64) DEFAULT NULL COMMENT '原zone',
  `target_zone` varchar(64) DEFAULT NULL COMMENT '目标zone',
  `status` varchar(20) DEFAULT NULL COMMENT '状态',
  `version` varchar(20) DEFAULT NULL COMMENT '版本，采用时间戳',
  `gmt_create` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modify` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '修改时间',
  PRIMARY KEY (`id`),
  KEY `idx_instanceid_jobid_zone_status_version` (`instance_id`,`zone`,`job_id`,`status`,`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-09-07 19:35:49