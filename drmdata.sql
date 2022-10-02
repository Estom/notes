-- MySQL dump 10.14  Distrib 5.5.68-MariaDB, for Linux (x86_64)
--
-- Host: rm-bp146b8k0w6bko38e.mysql.rds.aliyuncs.com    Database: drmdata
-- ------------------------------------------------------
-- Server version       5.7.30-log

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
-- Table structure for table `drm_attribute`
--

DROP TABLE IF EXISTS `drm_attribute`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `drm_attribute` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '属性ID主键',
  `name` varchar(500) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL COMMENT '资源ID',
  `attribute_name` varchar(50) DEFAULT NULL COMMENT '属性名称',
  `instance_id` varchar(50) DEFAULT NULL COMMENT '实例ID',
  `gmt_create` datetime DEFAULT NULL COMMENT '创建时间',
  `gmt_modified` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_attr` (`parent_id`,`instance_id`,`attribute_name`)
) ENGINE=InnoDB AUTO_INCREMENT=62 DEFAULT CHARSET=utf8 COMMENT='动态资源属性表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `drm_data`
--

DROP TABLE IF EXISTS `drm_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `drm_data` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `data_id` varchar(255) NOT NULL DEFAULT '' COMMENT '资源ID',
  `zone` varchar(20) NOT NULL DEFAULT '' COMMENT '逻辑zone',
  `instance_id` varchar(50) NOT NULL DEFAULT '' COMMENT '实例ID',
  `data` longtext NOT NULL COMMENT '推送数据',
  `version` bigint(20) NOT NULL COMMENT '数据版本',
  `temp` tinyint(1) DEFAULT NULL COMMENT '是否是临时推送',
  `type` smallint(6) DEFAULT NULL COMMENT '数据类型 0: 正常数据需推送，1: 静态数据无需推送',
  `gmt_create` datetime NOT NULL COMMENT '创建时间',
  `gmt_modified` datetime NOT NULL COMMENT '修改时间',
  `operator` varchar(64) DEFAULT NULL COMMENT '创建人',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_key` (`data_id`,`zone`,`instance_id`),
  KEY `idx_instance_zone` (`instance_id`,`zone`)
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='动态资源推送数据表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `drm_log`
--

DROP TABLE IF EXISTS `drm_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `drm_log` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `data_id` varchar(255) DEFAULT NULL COMMENT '资源标识',
  `instance_id` varchar(50) DEFAULT NULL COMMENT '实例ID',
  `value` longtext COMMENT '推送值',
  `operator` varchar(50) DEFAULT NULL COMMENT '操作人',
  `client_ip` varchar(255) DEFAULT NULL COMMENT '操作者IP',
  `push_mode` varchar(20) DEFAULT NULL COMMENT '推送类型',
  `target` varchar(500) DEFAULT NULL COMMENT '推送目标',
  `result` varchar(10) DEFAULT NULL COMMENT '推送结果',
  `source_app` varchar(50) DEFAULT NULL COMMENT '发起操作的系统',
  `fail_target` varchar(500) DEFAULT NULL COMMENT '失败的推送目标',
  `gmt_create` datetime DEFAULT NULL COMMENT '创建时间',
  `gmt_modified` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`),
  KEY `idx_data` (`data_id`(191),`instance_id`),
  KEY `idx_create` (`gmt_create`)
) ENGINE=InnoDB AUTO_INCREMENT=28945 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='动态资源推送日志表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `drm_resource`
--

DROP TABLE IF EXISTS `drm_resource`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `drm_resource` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(500) DEFAULT NULL,
  `region` varchar(20) DEFAULT NULL COMMENT '资源域',
  `app_name` varchar(30) DEFAULT NULL,
  `resource_domain` varchar(41) DEFAULT NULL COMMENT '资源域和应用名',
  `resource_id` varchar(150) DEFAULT NULL COMMENT '资源类路径',
  `resource_version` varchar(10) DEFAULT NULL COMMENT '资源版本',
  `instance_id` varchar(50) DEFAULT NULL COMMENT '实例ID',
  `type` varchar(32) NOT NULL DEFAULT 'normal' COMMENT '资源类型。Normal：正常资源类。tpl:模板类型',
  `gmt_create` datetime DEFAULT NULL COMMENT '创建时间',
  `gmt_modified` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_key` (`region`,`app_name`,`resource_id`,`resource_version`,`instance_id`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8 COMMENT='动态资源表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `drm_resource_tpl_instance`
--

DROP TABLE IF EXISTS `drm_resource_tpl_instance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `drm_resource_tpl_instance` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `tpl_id` bigint(20) unsigned NOT NULL COMMENT '模板id',
  `resource_id` bigint(20) unsigned NOT NULL COMMENT '通过模板创建出来的资源id',
  `params` varchar(2048) DEFAULT NULL COMMENT '模板填充的参数值',
  `instance_id` varchar(50) DEFAULT NULL COMMENT '实例ID',
  `gmt_create` datetime DEFAULT NULL COMMENT '创建时间',
  `gmt_modified` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`),
  KEY `idx_tpl_instance` (`instance_id`,`tpl_id`,`resource_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='资源模板实例表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `drm_rollback_context`
--

DROP TABLE IF EXISTS `drm_rollback_context`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `drm_rollback_context` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `instance_id` varchar(50) NOT NULL DEFAULT '' COMMENT '实例ID',
  `data_id` varchar(255) NOT NULL,
  `unique_id` varchar(128) NOT NULL DEFAULT '',
  `biz_no` varchar(128) DEFAULT NULL,
  `backup_data` longtext,
  `context` varchar(4096) DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `gmt_modified` datetime DEFAULT NULL,
  PRIMARY KEY (`Id`),
  UNIQUE KEY `uk_dataid` (`instance_id`,`data_id`,`unique_id`),
  KEY `idx_uniqueid` (`unique_id`),
  KEY `instance_dataid_modified` (`instance_id`,`data_id`,`gmt_modified`)
) ENGINE=InnoDB AUTO_INCREMENT=28961 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='存储回滚上下文';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `object_map`
--

DROP TABLE IF EXISTS `object_map`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `object_map` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `left_id` bigint(20) NOT NULL COMMENT '左边id',
  `left_object_type` varchar(128) DEFAULT NULL COMMENT '左边对象类型',
  `right_id` bigint(20) NOT NULL COMMENT '右边id',
  `right_object_type` varchar(128) DEFAULT NULL COMMENT '右边对象类型',
  `operate` varchar(64) DEFAULT NULL COMMENT '操作类型',
  `context` varchar(2048) DEFAULT NULL COMMENT '其它信息',
  `instance_id` varchar(50) DEFAULT NULL COMMENT '实例ID',
  `gmt_create` datetime DEFAULT NULL COMMENT '创建时间',
  `gmt_modified` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`),
  KEY `idx_left` (`left_id`,`left_object_type`),
  KEY `idx_right` (`right_id`,`right_object_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='对象映射表，用于独占迁移共享';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `service_discovery`
--

DROP TABLE IF EXISTS `service_discovery`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `service_discovery` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `service_name` varchar(255) NOT NULL DEFAULT '' COMMENT '服务名称',
  `ip` varchar(64) NOT NULL DEFAULT '' COMMENT '服务提供者IP',
  `port` int(11) NOT NULL COMMENT '服务提供者端口号',
  `status` varchar(11) DEFAULT 'ONLINE' COMMENT '服务状态',
  `context` varchar(2048) DEFAULT NULL COMMENT '额外的上下文信息',
  `gmt_create` datetime NOT NULL COMMENT '创建时间',
  `gmt_modified` datetime NOT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_provider` (`service_name`,`ip`,`port`),
  KEY `idx_modifiedtime` (`gmt_modified`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8 COMMENT='服务注册表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `system_config`
--

DROP TABLE IF EXISTS `system_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `system_config` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `key` varchar(128) NOT NULL DEFAULT '' COMMENT '配置key',
  `value` varchar(4096) NOT NULL DEFAULT '' COMMENT '配置值',
  `gray_ips` varchar(1024) DEFAULT NULL,
  `gmt_create` datetime NOT NULL COMMENT '创建时间',
  `gmt_modified` datetime NOT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_key` (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='系统配置表';
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-09-07 19:33:57