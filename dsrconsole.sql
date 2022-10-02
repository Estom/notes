-- MySQL dump 10.14  Distrib 5.5.68-MariaDB, for Linux (x86_64)
--
-- Host: rm-bp1ad041qdb1sl5n9.mysql.rds.aliyuncs.com    Database: dsrconsole
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
-- Table structure for table `app_info`
--

DROP TABLE IF EXISTS `app_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `app_info` (
  `id` bigint(11) unsigned NOT NULL AUTO_INCREMENT,
  `instance_id` varchar(128) NOT NULL DEFAULT '',
  `cluster_name` varchar(255) DEFAULT '' COMMENT 'mesh_cluster表的name,多个以","分隔',
  `app_name` varchar(255) NOT NULL COMMENT '应用名称',
  `sources` varchar(10) DEFAULT '0' COMMENT '添加方式(1-手动添加,0-自动添加)',
  `content` varchar(10240) DEFAULT NULL COMMENT '附加字段',
  `gmt_create` datetime DEFAULT NULL,
  `gmt_modified` datetime DEFAULT NULL,
  `workloads` varchar(10240) DEFAULT NULL COMMENT '手动添加应用的workload信息',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_instance_id_app_name_cluster_name` (`instance_id`,`app_name`,`cluster_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `audit_log`
--

DROP TABLE IF EXISTS `audit_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `audit_log` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `instance_id` varchar(128) NOT NULL DEFAULT '' COMMENT '租户信息',
  `operate_type` varchar(64) NOT NULL DEFAULT '' COMMENT '操作类型',
  `object_type` varchar(128) NOT NULL DEFAULT '' COMMENT '实体类型',
  `object_id` varchar(255) NOT NULL DEFAULT '' COMMENT '实体ID',
  `content` mediumtext NOT NULL COMMENT '操作内容',
  `status` tinyint(4) NOT NULL COMMENT '状态',
  `response` mediumtext COMMENT '响应内容（成功时不填写，返回错误时有错误信息）',
  `operator` varchar(64) DEFAULT NULL COMMENT '操作人',
  `gmt_create` datetime DEFAULT NULL COMMENT '创建时间',
  `gmt_modified` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='审计日志表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `auth_rule`
--

DROP TABLE IF EXISTS `auth_rule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_rule` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `auth_rule_group_id` int(11) NOT NULL COMMENT '外键，从属的分组 id',
  `name` varchar(1024) NOT NULL COMMENT '规则名',
  `mode` varchar(64) NOT NULL DEFAULT 'REJECT' COMMENT '模式',
  `enabled` tinyint(4) DEFAULT '0' COMMENT '是否生效，1 生效，0 未生效。默认未生效',
  `gmt_create` datetime DEFAULT NULL,
  `gmt_modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_groupid` (`auth_rule_group_id`)
) ENGINE=InnoDB AUTO_INCREMENT=87 DEFAULT CHARSET=utf8 COMMENT='规则';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `auth_rule_group`
--

DROP TABLE IF EXISTS `auth_rule_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_rule_group` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `instance_id` varchar(128) DEFAULT '' COMMENT 'instanceId',
  `data_id` varchar(255) NOT NULL DEFAULT '' COMMENT '服务id',
  `type` varchar(32) NOT NULL COMMENT 'whitelist/blacklist',
  `enabled` tinyint(4) DEFAULT '0' COMMENT '是否生效，1 生效，0 未生效。默认未生效',
  `gmt_create` datetime DEFAULT NULL,
  `gmt_modified` datetime DEFAULT NULL,
  `status` tinyint(4) DEFAULT '1' COMMENT '下发是否成功, 0 失败, 1 成功, 2 部分失败',
  `scope` varchar(32) NOT NULL DEFAULT 'service' COMMENT '规则组作用域：应用级鉴权规则（app）/服务级鉴权规则（service）',
  `app_name` varchar(255) DEFAULT '' COMMENT '应用名称',
  `service_id` varchar(255) DEFAULT NULL COMMENT '原始服务ID',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_instance_id_app_name_data_id_scope_type` (`instance_id`,`app_name`,`data_id`,`scope`,`type`),
  KEY `uk_groupid` (`instance_id`,`data_id`,`type`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8 COMMENT='规则组';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `auth_rule_item`
--

DROP TABLE IF EXISTS `auth_rule_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_rule_item` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `auth_rule_id` int(11) NOT NULL COMMENT '外键，从属的 auth rule id',
  `type` varchar(16) NOT NULL COMMENT '系统内置或者用户自定义 SYSTEM/CUSTOM',
  `field` varchar(256) NOT NULL COMMENT '规则字段',
  `operation` varchar(64) NOT NULL COMMENT '操作类型(EQUAL,NOT_EQUAL,IN,NOT_INT,REGEX)',
  `value` varchar(4096) NOT NULL COMMENT '规则项的值',
  `operator` varchar(32) DEFAULT NULL COMMENT '编辑人',
  `gmt_create` datetime DEFAULT NULL,
  `gmt_modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_ruleid` (`auth_rule_id`)
) ENGINE=InnoDB AUTO_INCREMENT=87 DEFAULT CHARSET=utf8 COMMENT='规则项';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `backstage_config`
--

DROP TABLE IF EXISTS `backstage_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `backstage_config` (
  `id` bigint(11) NOT NULL AUTO_INCREMENT,
  `config_key` varchar(128) COLLATE utf8_bin DEFAULT NULL,
  `config_value` varchar(1024) COLLATE utf8_bin DEFAULT NULL,
  `operator` varchar(32) COLLATE utf8_bin DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `gmt_modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_key` (`config_key`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='后台配置表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `change_plan`
--

DROP TABLE IF EXISTS `change_plan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `change_plan` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `instance_id` varchar(128) NOT NULL DEFAULT '' COMMENT '租户信息',
  `app_name` varchar(512) NOT NULL DEFAULT '' COMMENT '应用名称',
  `data_id` varchar(255) NOT NULL DEFAULT '' COMMENT '服务注册ID',
  `name` varchar(512) NOT NULL DEFAULT '' COMMENT '变更单名',
  `type` varchar(128) NOT NULL DEFAULT '' COMMENT '变更类型,熔断、鉴权等',
  `current_config` longtext NOT NULL COMMENT '当前DRM已推送值',
  `push_config` longtext NOT NULL COMMENT 'DRM需要推送值',
  `change_id` varchar(256) DEFAULT '' COMMENT '变更平台变更单ID',
  `change_platform` varchar(255) DEFAULT '' COMMENT '变更平台',
  `change_type` varchar(32) NOT NULL COMMENT '变更单类型',
  `change_status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '变更单状态',
  `change_content` varchar(10240) DEFAULT '' COMMENT '保留字段',
  `operator` varchar(64) DEFAULT NULL COMMENT '操作人',
  `gmt_create` datetime DEFAULT NULL COMMENT '创建时间',
  `gmt_modified` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`),
  KEY `idx_instance_id_type_data_id_status` (`instance_id`,`type`,`data_id`,`change_status`),
  KEY `idx_type_change_platform_id_status` (`type`,`change_platform`,`change_id`(255),`change_status`),
  KEY `idx_type_change_platform_status` (`type`,`change_platform`,`change_status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `circuit_breaker_rule`
--

DROP TABLE IF EXISTS `circuit_breaker_rule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `circuit_breaker_rule` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `instance_id` varchar(128) NOT NULL DEFAULT '' COMMENT '租户信息',
  `data_id` varchar(255) NOT NULL DEFAULT '' COMMENT '服务注册ID',
  `app_name` varchar(255) NOT NULL DEFAULT '' COMMENT '应用名称',
  `service_type` varchar(32) NOT NULL DEFAULT '' COMMENT '服务类型',
  `rule_name` varchar(255) NOT NULL DEFAULT '' COMMENT '熔断规则名称',
  `enabled` tinyint(4) unsigned NOT NULL DEFAULT '0' COMMENT '该规则的状态，0表示未生效，1表示全部生效，2表示部分生效',
  `mode` varchar(32) NOT NULL DEFAULT '' COMMENT '运行的模式',
  `content` varchar(10240) NOT NULL COMMENT '熔断规则内容',
  `operator` varchar(64) DEFAULT NULL COMMENT '操作人',
  `gmt_create` datetime DEFAULT NULL COMMENT '创建时间',
  `gmt_modified` datetime DEFAULT NULL COMMENT '修改时间',
  `resource_id` varchar(500) DEFAULT NULL COMMENT 'instance_id+|+app_name+|+data_id+|+traffic_type+|+method(httpMethod+|+httpPath)',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_resource_id` (`resource_id`(255)),
  KEY `idx_instance_id_data_id_app_name` (`instance_id`,`data_id`,`app_name`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `config_dispatch_log`
--

DROP TABLE IF EXISTS `config_dispatch_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `config_dispatch_log` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `instance_id` varchar(128) NOT NULL DEFAULT '' COMMENT '租户的工作空间隔离',
  `key` varchar(1024) NOT NULL DEFAULT '' COMMENT '配置的key',
  `type` varchar(128) NOT NULL DEFAULT '' COMMENT '配置的类型',
  `value` longtext COMMENT '配置下发的信息',
  `operator` varchar(32) DEFAULT '' COMMENT '操作人',
  `gmt_create` datetime DEFAULT NULL COMMENT '创建时间',
  `gmt_modified` datetime DEFAULT NULL COMMENT '修改时间',
  `status` tinyint(4) unsigned NOT NULL DEFAULT '0' COMMENT '状态',
  PRIMARY KEY (`id`),
  KEY `idx_instance_id_type_key` (`instance_id`,`type`,`key`(255)),
  KEY `idx_gmt_modified` (`gmt_modified`)
) ENGINE=InnoDB AUTO_INCREMENT=1404 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `config_snapshot`
--

DROP TABLE IF EXISTS `config_snapshot`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `config_snapshot` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `instance_id` varchar(128) NOT NULL COMMENT 'instanceId',
  `key` varchar(1024) NOT NULL COMMENT '配置的key，例如在服务鉴权里是dataId',
  `type` varchar(16) NOT NULL COMMENT '配置类型：例如 auth、lb 等',
  `value` text NOT NULL COMMENT '配置值',
  `operator` varchar(32) DEFAULT NULL COMMENT '操作人',
  `gmt_create` datetime DEFAULT NULL,
  `gmt_modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_key` (`instance_id`,`key`(255),`type`)
) ENGINE=InnoDB AUTO_INCREMENT=1097 DEFAULT CHARSET=utf8 COMMENT='服务配置快照表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `confreg_instance`
--

DROP TABLE IF EXISTS `confreg_instance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `confreg_instance` (
  `id` bigint(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `instance_id` varchar(128) DEFAULT NULL COMMENT '实例标识',
  `instance_name` varchar(32) DEFAULT NULL COMMENT '实例名字',
  `instance_status` varchar(32) DEFAULT NULL COMMENT '实例状态',
  `logic_instance_id` varchar(64) DEFAULT NULL COMMENT '逻辑实例ID',
  `product_instance_id` varchar(64) DEFAULT NULL COMMENT '产品实例ID',
  `tenant_id` varchar(32) DEFAULT NULL COMMENT '实例所属租户标识',
  `tenant_name` varchar(32) DEFAULT NULL COMMENT '实例所属租户',
  `workspace` varchar(64) DEFAULT NULL,
  `owner_id` varchar(32) DEFAULT NULL COMMENT '实例所属owner标识',
  `owner_name` varchar(32) DEFAULT NULL COMMENT '实例所属owner名字',
  `access_key` varchar(32) DEFAULT NULL COMMENT '实例授权访问key',
  `req_biz_id` varchar(32) DEFAULT NULL COMMENT '业务号',
  `operator` varchar(32) DEFAULT NULL COMMENT '操作人',
  `gmt_create` datetime DEFAULT NULL,
  `gmt_modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='记录共享版逻辑实例';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `confreg_server`
--

DROP TABLE IF EXISTS `confreg_server`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `confreg_server` (
  `id` bigint(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `server_type` varchar(256) DEFAULT '' COMMENT '记录类型',
  `host` varchar(256) DEFAULT NULL,
  `ip` varchar(256) DEFAULT NULL,
  `url` varchar(128) DEFAULT '' COMMENT 'url',
  `group_id` bigint(11) NOT NULL DEFAULT '0' COMMENT '映射confreg_server_group.id',
  `index_num` int(11) DEFAULT '0' COMMENT '组内顺序',
  `is_failover` varchar(2) DEFAULT 'N' COMMENT 'failover标示',
  `is_valid` varchar(2) DEFAULT 'Y' COMMENT 'valid标示',
  `gmt_create` datetime DEFAULT NULL,
  `gmt_modified` datetime DEFAULT NULL,
  `operator` varchar(128) DEFAULT NULL,
  `server_status` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='confreg服务器配置信息';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `confreg_server_group`
--

DROP TABLE IF EXISTS `confreg_server_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `confreg_server_group` (
  `id` bigint(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `group_name` varchar(32) DEFAULT '' COMMENT '组名称',
  `group_type` varchar(32) DEFAULT '' COMMENT '类型',
  `group_status` varchar(11) DEFAULT NULL COMMENT '集群状态',
  `idc_group_id` bigint(11) DEFAULT '0' COMMENT '映射confreg_server_group.id',
  `idc_name` varchar(50) DEFAULT '' COMMENT '所属机房',
  `env` varchar(50) DEFAULT '' COMMENT '所属环境',
  `domain_name` varchar(255) DEFAULT '' COMMENT 'session vip',
  `gmt_create` datetime DEFAULT NULL,
  `gmt_modified` datetime DEFAULT NULL,
  `operator` varchar(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='confreg服务器组配置信息';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `confreg_service_info`
--

DROP TABLE IF EXISTS `confreg_service_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `confreg_service_info` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `instance_id` varchar(256) DEFAULT NULL,
  `data_id` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `confreg_session`
--

DROP TABLE IF EXISTS `confreg_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `confreg_session` (
  `id` bigint(11) unsigned NOT NULL AUTO_INCREMENT,
  `session_id` varchar(64) DEFAULT NULL,
  `user_id` varchar(64) DEFAULT NULL,
  `account` varchar(64) DEFAULT NULL,
  `realname` varchar(64) DEFAULT NULL,
  `nickname` varchar(64) DEFAULT NULL,
  `customer` varchar(64) DEFAULT NULL,
  `mode` varchar(64) DEFAULT NULL,
  `usertype` varchar(64) DEFAULT NULL,
  `tenant_id` varchar(64) DEFAULT NULL,
  `tenant_name` varchar(64) DEFAULT NULL,
  `policy` varchar(64) DEFAULT NULL,
  `access_expired_time` varchar(64) DEFAULT NULL,
  `refresh_expired_time` varchar(64) DEFAULT NULL,
  `access_token` varchar(64) DEFAULT NULL,
  `refresh_token` varchar(64) DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `gmt_modified` datetime DEFAULT NULL,
  `operator` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `confreg_tenant`
--

DROP TABLE IF EXISTS `confreg_tenant`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `confreg_tenant` (
  `id` bigint(11) unsigned NOT NULL AUTO_INCREMENT,
  `tenant_id` varchar(64) DEFAULT NULL COMMENT '租户ID',
  `tenant_name` varchar(64) DEFAULT NULL COMMENT '租户名字',
  `tenant_status` varchar(64) DEFAULT NULL COMMENT '租住状态',
  `order_no` varchar(64) DEFAULT NULL COMMENT '订单号用于业务串联，以及幂等',
  `product_code` varchar(64) DEFAULT NULL COMMENT '产品码全局唯一',
  `product_instance_id` varchar(64) DEFAULT NULL COMMENT '产品实例ID开通会生成产品实例Id，作为后续生命周期SPI管理资源的标识',
  `gmt_create` datetime DEFAULT NULL,
  `gmt_modified` datetime DEFAULT NULL,
  `operator` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `downgrade_rule`
--

DROP TABLE IF EXISTS `downgrade_rule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `downgrade_rule` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `group_id` bigint(20) NOT NULL COMMENT 'downgrade_rule_group逻辑外键',
  `instance_id` varchar(128) NOT NULL DEFAULT '' COMMENT '租户信息',
  `data_id` varchar(255) NOT NULL DEFAULT '' COMMENT '服务注册ID',
  `description` varchar(255) NOT NULL DEFAULT '' COMMENT '降级规则描述',
  `mode` varchar(32) NOT NULL DEFAULT '' COMMENT '运行的模式',
  `rule_body` text NOT NULL COMMENT '降级规则',
  `operator` varchar(64) DEFAULT NULL COMMENT '操作人',
  `gmt_create` datetime DEFAULT NULL COMMENT '创建时间',
  `gmt_modified` datetime DEFAULT NULL COMMENT '修改时间',
  `enabled` tinyint(4) unsigned NOT NULL DEFAULT '0' COMMENT '该规则的状态，0表示未生效，1表示全部生效，2表示部分生效',
  `resource_id` varchar(600) DEFAULT NULL COMMENT 'instance_id|app_name|data_id|method',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_resource_id` (`resource_id`(255)),
  KEY `idx_instanceid_dataid` (`instance_id`,`data_id`),
  KEY `idx_group_id` (`group_id`),
  KEY `IDX_GMT_CREATE` (`gmt_create`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `downgrade_rule_group`
--

DROP TABLE IF EXISTS `downgrade_rule_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `downgrade_rule_group` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `instance_id` varchar(128) NOT NULL DEFAULT '' COMMENT '租户信息',
  `app_name` varchar(255) NOT NULL DEFAULT '' COMMENT '应用名称',
  `type` varchar(32) NOT NULL DEFAULT '' COMMENT '服务类型 SOFA/DUBBO/SPRINGCLOUD',
  `enabled` tinyint(4) unsigned NOT NULL DEFAULT '0' COMMENT '该规则的状态，0表示未生效，1表示全部生效',
  `operator` varchar(64) DEFAULT NULL COMMENT '操作人',
  `gmt_create` datetime DEFAULT NULL COMMENT '创建时间',
  `gmt_modified` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_instance_id_app_name` (`instance_id`,`app_name`,`type`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `expense`
--

DROP TABLE IF EXISTS `expense`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `expense` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `instance_id` varchar(128) NOT NULL DEFAULT '',
  `charge_hour` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `client_number` int(11) DEFAULT '0',
  `biz_no` varchar(128) NOT NULL DEFAULT '',
  `retry` int(11) DEFAULT '0',
  `gmt_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `result` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_instance_charge` (`instance_id`,`charge_hour`)
) ENGINE=InnoDB AUTO_INCREMENT=39750 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `expense_failure`
--

DROP TABLE IF EXISTS `expense_failure`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `expense_failure` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `instance_id` varchar(128) NOT NULL DEFAULT '',
  `charge_hour` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `client_number` int(11) DEFAULT '0',
  `biz_no` varchar(128) NOT NULL DEFAULT '',
  `result` varchar(128) DEFAULT NULL,
  `retry` int(11) DEFAULT '0',
  `gmt_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_instance_charge` (`instance_id`,`charge_hour`)
) ENGINE=InnoDB AUTO_INCREMENT=5111 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `fault_inject_rule`
--

DROP TABLE IF EXISTS `fault_inject_rule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fault_inject_rule` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `instance_id` varchar(128) NOT NULL DEFAULT '' COMMENT '租户信息',
  `data_id` varchar(255) NOT NULL DEFAULT '' COMMENT '服务注册ID',
  `app_name` varchar(255) NOT NULL DEFAULT '' COMMENT '应用名称',
  `service_type` varchar(32) NOT NULL DEFAULT '' COMMENT '服务类型',
  `rule_name` varchar(255) NOT NULL DEFAULT '' COMMENT '规则名称',
  `enabled` tinyint(4) unsigned NOT NULL DEFAULT '0' COMMENT '该规则的状态，0表示未生效，1表示全部生效，2表示部分生效',
  `rule_config` mediumtext NOT NULL COMMENT '故障注入规则配置',
  `operator` varchar(64) DEFAULT NULL COMMENT '操作人',
  `gmt_create` datetime DEFAULT NULL COMMENT '创建时间',
  `gmt_modified` datetime DEFAULT NULL COMMENT '修改时间',
  `traffic_type` varchar(100) DEFAULT NULL COMMENT 'traffic_type的值(o:客户端生效/ i:服务端生效)',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_instance_id_data_id_app_name` (`instance_id`,`data_id`,`app_name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='故障注入规则表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `fault_tolerance_rule`
--

DROP TABLE IF EXISTS `fault_tolerance_rule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fault_tolerance_rule` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `instance_id` varchar(128) NOT NULL DEFAULT '' COMMENT '租户信息',
  `app_name` varchar(255) NOT NULL DEFAULT '' COMMENT '应用名称',
  `rule_name` varchar(255) NOT NULL DEFAULT '' COMMENT '规则名称',
  `enabled` tinyint(4) unsigned NOT NULL DEFAULT '0' COMMENT '该规则的状态，0表示未生效，1表示全部生效，2表示部分生效',
  `rule_config` mediumtext NOT NULL COMMENT '故障隔离规则配置',
  `operator` varchar(64) DEFAULT NULL COMMENT '操作人',
  `gmt_create` datetime DEFAULT NULL COMMENT '创建时间',
  `gmt_modified` datetime DEFAULT NULL COMMENT '修改时间',
  `direction` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_instance_id_app_name_direction_index` (`instance_id`,`app_name`,`direction`),
  KEY `k_instance_id_app_name` (`instance_id`,`app_name`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COMMENT='故障隔离规则表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `function_plugin`
--

DROP TABLE IF EXISTS `function_plugin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `function_plugin` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `instance_id` varchar(128) NOT NULL DEFAULT '' COMMENT '租户信息',
  `function_plugin_name` varchar(128) NOT NULL COMMENT '功能插件名',
  `function_plugin_type` tinyint(4) NOT NULL COMMENT '插件类型',
  `description` varchar(10240) DEFAULT NULL COMMENT '备注',
  `operator` varchar(64) DEFAULT NULL COMMENT '操作人',
  `gmt_create` datetime DEFAULT NULL COMMENT '创建时间',
  `gmt_modified` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='功能插件';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `guardian_app`
--

DROP TABLE IF EXISTS `guardian_app`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `guardian_app` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(256) NOT NULL,
  `enable` tinyint(4) NOT NULL,
  `run_mode` varchar(50) NOT NULL,
  `instance_id` varchar(50) NOT NULL,
  `operator` varchar(256) DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `gmt_modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name_instance` (`name`(255),`instance_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `guardian_push_history`
--

DROP TABLE IF EXISTS `guardian_push_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `guardian_push_history` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `app_name` varchar(256) NOT NULL,
  `rule_ids` varchar(2048) DEFAULT '',
  `target` varchar(2048) DEFAULT '',
  `push_content` mediumtext,
  `success` tinyint(4) NOT NULL,
  `instance_id` varchar(50) NOT NULL,
  `operator` varchar(255) DEFAULT NULL,
  `gmt_create` datetime NOT NULL,
  `gmt_modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `guardian_rule`
--

DROP TABLE IF EXISTS `guardian_rule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `guardian_rule` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `app_name` varchar(256) NOT NULL,
  `name` varchar(256) NOT NULL,
  `enable` tinyint(4) NOT NULL,
  `run_mode` varchar(50) NOT NULL,
  `resource_type` varchar(50) NOT NULL,
  `rule_config` mediumtext NOT NULL,
  `instance_id` varchar(50) NOT NULL,
  `operator` varchar(256) DEFAULT NULL,
  `gmt_create` datetime NOT NULL,
  `gmt_modified` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `instance_info`
--

DROP TABLE IF EXISTS `instance_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `instance_info` (
  `id` bigint(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `instance_id` varchar(128) DEFAULT NULL COMMENT '实例标识',
  `status` varchar(32) DEFAULT NULL COMMENT '实例状态',
  `gmt_create` datetime DEFAULT NULL,
  `gmt_modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_instance_id` (`instance_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=556 DEFAULT CHARSET=utf8 COMMENT='逻辑实例';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `instance_meta`
--

DROP TABLE IF EXISTS `instance_meta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `instance_meta` (
  `id` bigint(11) unsigned NOT NULL AUTO_INCREMENT,
  `instance_id` varchar(128) NOT NULL DEFAULT '' COMMENT '实例标识',
  `tenant_id` varchar(128) DEFAULT NULL COMMENT '租户标志',
  `workspace_id` varchar(128) DEFAULT NULL COMMENT '工作空间标志',
  `ant_uid` varchar(128) DEFAULT NULL COMMENT '阿里云uid',
  `business_owner_id` varchar(128) DEFAULT NULL COMMENT '阿里云ownerId',
  `description` varchar(512) DEFAULT NULL COMMENT '描述',
  `gmt_create` date DEFAULT NULL COMMENT '创建时间',
  `gmt_modified` date DEFAULT NULL COMMENT '修改时间',
  `ant_account` varchar(128) DEFAULT NULL COMMENT 'ant_account',
  `customer` varchar(128) DEFAULT NULL COMMENT 'customer',
  `internal_id` varchar(128) DEFAULT NULL COMMENT 'internal_id',
  `account_name` varchar(128) DEFAULT NULL COMMENT 'account_name',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_instance_id` (`instance_id`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `job`
--

DROP TABLE IF EXISTS `job`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `job` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `name` varchar(60) DEFAULT NULL COMMENT '任务名称',
  `cron` varchar(128) DEFAULT NULL COMMENT 'cron表达式',
  `app` varchar(50) DEFAULT NULL COMMENT '所属系统',
  `fail_handle_strategy` varchar(25) DEFAULT NULL COMMENT '失败处理策略',
  `route_strategy` varchar(15) DEFAULT NULL COMMENT '路由策略',
  `invoke_type` varchar(15) DEFAULT NULL COMMENT '执行类型',
  `handlers` varchar(1024) DEFAULT NULL COMMENT '处理器',
  `type` varchar(15) DEFAULT NULL COMMENT '任务类型',
  `instance_id` varchar(20) DEFAULT NULL COMMENT '实例id',
  `timeout` int(11) DEFAULT NULL COMMENT '超时时间',
  `time_unit` varchar(15) DEFAULT NULL COMMENT '超时时间单位',
  `hashcode` int(11) DEFAULT NULL COMMENT 'hashcode',
  `des` varchar(1024) DEFAULT NULL COMMENT '描述',
  `trigger_mode` varchar(10) DEFAULT NULL COMMENT '触发模式',
  `gmt_create` datetime DEFAULT NULL COMMENT '创建时间',
  `sharding_count` int(11) DEFAULT NULL COMMENT '分片数',
  `trigger_type` varchar(15) DEFAULT NULL COMMENT '触发类型',
  `gray_ratio` int(11) DEFAULT NULL COMMENT '灰度转发比例',
  `thread_count` int(11) DEFAULT NULL COMMENT '集群任务处理线程数',
  `misfire_strategy` varchar(20) DEFAULT NULL COMMENT '漏触发策略',
  `pre_auto_trigger` tinyint(1) DEFAULT NULL COMMENT '预发是否自动触发',
  `operator` varchar(256) DEFAULT NULL COMMENT '任务创建人',
  `priority` varchar(20) DEFAULT NULL COMMENT 'job 优先级:VH,H,M,L,VL',
  `group_id` int(11) DEFAULT NULL COMMENT '任务分组id',
  `exclusive` tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否开启任务互斥：0-否，1-是',
  `timeout_strategy` varchar(20) DEFAULT NULL COMMENT '超时处理策略',
  `context` varchar(2048) DEFAULT NULL COMMENT '自定义参数',
  `enable_forward` tinyint(4) DEFAULT '1' COMMENT '是否允许转发',
  `secret_key` varchar(60) DEFAULT NULL COMMENT 'http 鉴权key',
  `gmt_effective` timestamp NULL DEFAULT NULL COMMENT '任务生效时间',
  `retry_count` int(11) DEFAULT '0' COMMENT '重试次数',
  `origin_type` varchar(15) DEFAULT NULL COMMENT '原始类型',
  `time_zone` varchar(64) DEFAULT NULL COMMENT '时区',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_name_instance` (`name`,`instance_id`),
  KEY `idx_group` (`group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `job_lock`
--

DROP TABLE IF EXISTS `job_lock`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `job_lock` (
  `id` bigint(11) unsigned NOT NULL AUTO_INCREMENT,
  `job_key` varchar(128) NOT NULL DEFAULT '' COMMENT '任务唯一标识，由 group 和 name 组成',
  `trigger_key` varchar(128) NOT NULL DEFAULT '' COMMENT '触发器唯一标识，由 group 和 name 组成',
  `exp_run_time` varchar(32) NOT NULL DEFAULT '' COMMENT '执行时间，yyyy-MM-dd hh:mm:ss 格式的时间字符串',
  `run_ip` varchar(64) NOT NULL DEFAULT '' COMMENT '机器实例ip',
  `run_time` datetime DEFAULT NULL COMMENT '实际执行时间',
  `state` tinyint(2) NOT NULL DEFAULT '0' COMMENT '任务执行状态，0-锁定，1-执行完成',
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_job_trigger_key` (`job_key`,`trigger_key`,`exp_run_time`)
) ENGINE=InnoDB AUTO_INCREMENT=7639415 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `mesh_cluster`
--

DROP TABLE IF EXISTS `mesh_cluster`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mesh_cluster` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `instance_id` varchar(128) NOT NULL DEFAULT '' COMMENT '租户信息',
  `cluster_name` varchar(255) NOT NULL DEFAULT '' COMMENT '集群名称',
  `status` tinyint(4) unsigned NOT NULL DEFAULT '0' COMMENT '集群状态，0表示关闭状态，1表示开通状态',
  `cluster_config` mediumtext NOT NULL COMMENT '集群配置文件',
  `operator` varchar(64) DEFAULT NULL COMMENT '操作人',
  `gmt_create` datetime DEFAULT NULL COMMENT '创建时间',
  `gmt_modified` datetime DEFAULT NULL COMMENT '修改时间',
  `extension` text COMMENT '集群拓展信息（dc，zone等）',
  `cluster_remarks` varchar(255) DEFAULT '' COMMENT '备注',
  `cluster_server` varchar(255) DEFAULT '' COMMENT '集群ip',
  `type` varchar(4) DEFAULT '' COMMENT '集群类型',
  `gateway_status` varchar(4) DEFAULT '' COMMENT '是否开启网关',
  `gateway_config` text COMMENT '开通网关的配置信息',
  `mesh_config` text COMMENT '开通mesh的配置信息',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_cluster_name` (`instance_id`,`cluster_name`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='集群信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `mesh_cluster_with_sidecar_inject_rule`
--

DROP TABLE IF EXISTS `mesh_cluster_with_sidecar_inject_rule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mesh_cluster_with_sidecar_inject_rule` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `instance_id` varchar(128) NOT NULL DEFAULT '' COMMENT '租户信息',
  `cluster_name` varchar(128) NOT NULL COMMENT '集群名称',
  `sidecar_inject_rule_id` bigint(20) NOT NULL COMMENT 'sidecar注入规则规则表id',
  `operator` varchar(64) DEFAULT NULL COMMENT '操作人',
  `gmt_create` datetime DEFAULT NULL COMMENT '创建时间',
  `gmt_modified` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=86 DEFAULT CHARSET=utf8 COMMENT='集群与sidecar注入规则多对多关联关系记录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `out_ca_certs`
--

DROP TABLE IF EXISTS `out_ca_certs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `out_ca_certs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `instance_id` varchar(128) NOT NULL COMMENT '租户信息',
  `cert_id` varchar(128) NOT NULL COMMENT '证书ID，唯一，IssuerName+Serial',
  `serial_num` varchar(128) NOT NULL COMMENT '证书序列号',
  `issuer` varchar(128) NOT NULL COMMENT 'CA名称',
  `subject` varchar(128) NOT NULL COMMENT '应用名称',
  `private_key` varchar(4096) NOT NULL COMMENT '私钥',
  `public_key` varchar(4096) NOT NULL COMMENT '公钥',
  `cert_content` text NOT NULL COMMENT '证书内容',
  `cert_create_time` datetime NOT NULL COMMENT '证书签发时间',
  `cert_expired_time` datetime NOT NULL COMMENT '证书过期时间',
  `cert_ttl` bigint(20) NOT NULL COMMENT '证书有效期, 单位为秒',
  `ca_cert_id` varchar(128) DEFAULT NULL COMMENT 'CA证书ID',
  `cert_type` varchar(64) NOT NULL DEFAULT 'default' COMMENT 'default应用证书,ROOTCA根证书',
  `status_active` tinyint(4) unsigned DEFAULT NULL COMMENT '激活1,非激活NULL',
  `status_expired` tinyint(4) unsigned DEFAULT NULL COMMENT '过期1,非过期NULL',
  `status_revoke` tinyint(4) unsigned DEFAULT NULL COMMENT '吊销1,非吊销NULL',
  `gmt_create` datetime DEFAULT NULL COMMENT '创建时间',
  `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `remark` varchar(2048) DEFAULT NULL COMMENT '备注',
  `operator` varchar(64) DEFAULT NULL COMMENT '操作人',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_cert_id_instance_Id` (`cert_id`,`instance_id`),
  UNIQUE KEY `idx_subject_status_active_instance_id` (`subject`,`status_active`,`instance_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='MeshOutCA证书';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `plugin_edition`
--

DROP TABLE IF EXISTS `plugin_edition`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `plugin_edition` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `instance_id` varchar(128) NOT NULL DEFAULT '' COMMENT '租户信息',
  `plugin_id` bigint(20) DEFAULT NULL COMMENT '功能插件id',
  `plugin_version` varchar(128) NOT NULL DEFAULT '' COMMENT '功能插件版本号',
  `plugin_file_id` bigint(20) unsigned NOT NULL COMMENT '功能插件主体文件id',
  `plugin_type` tinyint(4) NOT NULL COMMENT '插件类型',
  `description` varchar(10240) DEFAULT NULL COMMENT '备注',
  `operator` varchar(64) DEFAULT NULL COMMENT '操作人',
  `gmt_create` datetime DEFAULT NULL COMMENT '创建时间',
  `gmt_modified` datetime DEFAULT NULL COMMENT '修改时间',
  `dependences` varchar(512) DEFAULT NULL COMMENT '插件依赖包',
  `dependences_md5` varchar(64) DEFAULT NULL COMMENT '插件依赖包MD5',
  `name` varchar(128) NOT NULL DEFAULT '' COMMENT '插件名',
  `metadata_json` varchar(1024) DEFAULT NULL COMMENT 'metadatajson',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='功能插件';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `plugin_file`
--

DROP TABLE IF EXISTS `plugin_file`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `plugin_file` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `instance_id` varchar(128) NOT NULL DEFAULT '' COMMENT '租户信息',
  `file_path` varchar(512) DEFAULT NULL COMMENT '文件路径',
  `save_type` tinyint(4) NOT NULL COMMENT '存储类型：0-未知，1-db，2-external-url',
  `function_plugin_file` longblob COMMENT '插件主体',
  `zip_file_name` varchar(128) NOT NULL COMMENT '插件名字/协议名字',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='功能插件文件表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `process_state_info`
--

DROP TABLE IF EXISTS `process_state_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `process_state_info` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `instance_id` varchar(128) NOT NULL COMMENT '租户id',
  `business_id` varchar(255) NOT NULL COMMENT '业务id',
  `business_type` varchar(64) NOT NULL COMMENT '业务类型',
  `status` varchar(32) NOT NULL COMMENT '状态（NORMAL,UPDATED,CHANGING,FAILED）',
  `description` varchar(255) DEFAULT NULL COMMENT '状态描述信息',
  `operator` varchar(64) DEFAULT NULL COMMENT '操作人',
  `gmt_create` datetime DEFAULT NULL COMMENT '创建时间',
  `gmt_modified` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_business_id_business_type` (`instance_id`,`business_id`,`business_type`),
  KEY `key_business_type_status` (`business_type`,`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='流程状态信息表，记录业务的执行流程';
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `protocol`
--

DROP TABLE IF EXISTS `protocol`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `protocol` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `instance_id` varchar(128) NOT NULL DEFAULT '' COMMENT '租户信息',
  `name` varchar(128) NOT NULL DEFAULT '' COMMENT '协议名',
  `protocol` varchar(64) NOT NULL DEFAULT '' COMMENT '协议',
  `protocol_type` tinyint(4) NOT NULL COMMENT '协议类型',
  `description` varchar(10240) DEFAULT NULL COMMENT '备注',
  `operator` varchar(64) DEFAULT NULL COMMENT '操作人',
  `gmt_create` datetime DEFAULT NULL COMMENT '创建时间',
  `gmt_modified` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='协议表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `protocol_inst`
--

DROP TABLE IF EXISTS `protocol_inst`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `protocol_inst` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `instance_id` varchar(128) NOT NULL DEFAULT '' COMMENT '租户信息',
  `proto_id` bigint(20) NOT NULL COMMENT '协议id；关联协议表主键',
  `version` varchar(128) NOT NULL DEFAULT '' COMMENT '协议版本',
  `func_plugin_ids` varchar(512) DEFAULT '' COMMENT '功能插件ids',
  `description` varchar(10240) DEFAULT NULL COMMENT '备注',
  `operator` varchar(64) DEFAULT NULL COMMENT '操作人',
  `gmt_create` datetime DEFAULT NULL COMMENT '创建时间',
  `gmt_modified` datetime DEFAULT NULL COMMENT '修改时间',
  `transcoder_config` varchar(512) DEFAULT NULL COMMENT '协议转换配置',
  `proto_codec_id` bigint(20) DEFAULT NULL COMMENT '内置协议/自定义协议id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='协议版本';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `protocol_inst_with_plugin_edition`
--

DROP TABLE IF EXISTS `protocol_inst_with_plugin_edition`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `protocol_inst_with_plugin_edition` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `instance_id` varchar(128) NOT NULL DEFAULT '' COMMENT '租户信息',
  `protoInst_id` bigint(20) NOT NULL COMMENT '协议插件版本id；关联协议插件版本表主键',
  `plugin_edition_id` varchar(512) DEFAULT '' COMMENT '功能插件版本id；关联功能插件版本表id',
  `operator` varchar(64) DEFAULT NULL COMMENT '操作人',
  `gmt_create` datetime DEFAULT NULL COMMENT '创建时间',
  `gmt_modified` datetime DEFAULT NULL COMMENT '修改时间',
  `sort` bigint(20) DEFAULT NULL COMMENT '排序顺序字段',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='功能插件版本与协议插件版本多对多关联关系记录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `protocol_inst_with_sidecar_inject_rule`
--

DROP TABLE IF EXISTS `protocol_inst_with_sidecar_inject_rule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `protocol_inst_with_sidecar_inject_rule` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `instance_id` varchar(128) NOT NULL DEFAULT '' COMMENT '租户信息',
  `protoInst_id` bigint(20) NOT NULL COMMENT '协议插件版本id；关联协议插件版本表主键',
  `sidecar_inject_rule_id` varchar(512) DEFAULT '' COMMENT 'sidecar注入规则规则表id',
  `operator` varchar(64) DEFAULT NULL COMMENT '操作人',
  `gmt_create` datetime DEFAULT NULL COMMENT '创建时间',
  `gmt_modified` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='协议插件版本表与sidecar注入规则多对多关联关系记录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pub_registry_infor_with_sidecar_inject_rule`
--

DROP TABLE IF EXISTS `pub_registry_infor_with_sidecar_inject_rule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pub_registry_infor_with_sidecar_inject_rule` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `instance_id` varchar(128) NOT NULL DEFAULT '' COMMENT '租户信息',
  `pub_registry_info_id` bigint(20) NOT NULL COMMENT '注册中心id',
  `sidecar_inject_rule_id` bigint(20) NOT NULL COMMENT 'sidecar注入规则规则表id',
  `operator` varchar(64) DEFAULT NULL COMMENT '操作人',
  `gmt_create` datetime DEFAULT NULL COMMENT '创建时间',
  `gmt_modified` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=86 DEFAULT CHARSET=utf8 COMMENT='注册中心与sidecar注入规则多对多关联关系记录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `qrtz_blob_triggers`
--

DROP TABLE IF EXISTS `qrtz_blob_triggers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `qrtz_blob_triggers` (
  `SCHED_NAME` varchar(120) NOT NULL,
  `TRIGGER_NAME` varchar(200) NOT NULL,
  `TRIGGER_GROUP` varchar(200) NOT NULL,
  `BLOB_DATA` blob,
  PRIMARY KEY (`SCHED_NAME`,`TRIGGER_NAME`,`TRIGGER_GROUP`),
  KEY `SCHED_NAME` (`SCHED_NAME`,`TRIGGER_NAME`,`TRIGGER_GROUP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `qrtz_cron_triggers`
--

DROP TABLE IF EXISTS `qrtz_cron_triggers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `qrtz_cron_triggers` (
  `SCHED_NAME` varchar(120) NOT NULL,
  `TRIGGER_NAME` varchar(200) NOT NULL,
  `TRIGGER_GROUP` varchar(200) NOT NULL,
  `CRON_EXPRESSION` varchar(120) NOT NULL,
  `TIME_ZONE_ID` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`SCHED_NAME`,`TRIGGER_NAME`,`TRIGGER_GROUP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `qrtz_fired_triggers`
--

DROP TABLE IF EXISTS `qrtz_fired_triggers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `qrtz_fired_triggers` (
  `SCHED_NAME` varchar(120) NOT NULL,
  `ENTRY_ID` varchar(95) NOT NULL,
  `TRIGGER_NAME` varchar(200) NOT NULL,
  `TRIGGER_GROUP` varchar(200) NOT NULL,
  `INSTANCE_NAME` varchar(200) NOT NULL,
  `FIRED_TIME` bigint(13) NOT NULL,
  `SCHED_TIME` bigint(13) NOT NULL,
  `PRIORITY` int(11) NOT NULL,
  `STATE` varchar(16) NOT NULL,
  `JOB_NAME` varchar(200) DEFAULT NULL,
  `JOB_GROUP` varchar(200) DEFAULT NULL,
  `IS_NONCONCURRENT` varchar(1) DEFAULT NULL,
  `REQUESTS_RECOVERY` varchar(1) DEFAULT NULL,
  PRIMARY KEY (`SCHED_NAME`,`ENTRY_ID`),
  KEY `IDX_QRTZ_FT_TRIG_INST_NAME` (`SCHED_NAME`,`INSTANCE_NAME`),
  KEY `IDX_QRTZ_FT_INST_JOB_REQ_RCVRY` (`SCHED_NAME`,`INSTANCE_NAME`,`REQUESTS_RECOVERY`),
  KEY `IDX_QRTZ_FT_J_G` (`SCHED_NAME`,`JOB_NAME`,`JOB_GROUP`),
  KEY `IDX_QRTZ_FT_JG` (`SCHED_NAME`,`JOB_GROUP`),
  KEY `IDX_QRTZ_FT_T_G` (`SCHED_NAME`,`TRIGGER_NAME`,`TRIGGER_GROUP`),
  KEY `IDX_QRTZ_FT_TG` (`SCHED_NAME`,`TRIGGER_GROUP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `qrtz_job_details`
--

DROP TABLE IF EXISTS `qrtz_job_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `qrtz_job_details` (
  `SCHED_NAME` varchar(120) NOT NULL,
  `JOB_NAME` varchar(200) NOT NULL,
  `JOB_GROUP` varchar(200) NOT NULL,
  `DESCRIPTION` varchar(250) DEFAULT NULL,
  `JOB_CLASS_NAME` varchar(250) NOT NULL,
  `IS_DURABLE` varchar(1) NOT NULL,
  `IS_NONCONCURRENT` varchar(1) NOT NULL,
  `IS_UPDATE_DATA` varchar(1) NOT NULL,
  `REQUESTS_RECOVERY` varchar(1) NOT NULL,
  `JOB_DATA` blob,
  PRIMARY KEY (`SCHED_NAME`,`JOB_NAME`,`JOB_GROUP`),
  KEY `IDX_QRTZ_J_REQ_RECOVERY` (`SCHED_NAME`,`REQUESTS_RECOVERY`),
  KEY `IDX_QRTZ_J_GRP` (`SCHED_NAME`,`JOB_GROUP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `qrtz_locks`
--

DROP TABLE IF EXISTS `qrtz_locks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `qrtz_locks` (
  `SCHED_NAME` varchar(120) NOT NULL,
  `LOCK_NAME` varchar(40) NOT NULL,
  PRIMARY KEY (`SCHED_NAME`,`LOCK_NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `qrtz_paused_trigger_grps`
--

DROP TABLE IF EXISTS `qrtz_paused_trigger_grps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `qrtz_paused_trigger_grps` (
  `SCHED_NAME` varchar(120) NOT NULL,
  `TRIGGER_GROUP` varchar(200) NOT NULL,
  PRIMARY KEY (`SCHED_NAME`,`TRIGGER_GROUP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `qrtz_scheduler_state`
--

DROP TABLE IF EXISTS `qrtz_scheduler_state`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `qrtz_scheduler_state` (
  `SCHED_NAME` varchar(120) NOT NULL,
  `INSTANCE_NAME` varchar(200) NOT NULL,
  `LAST_CHECKIN_TIME` bigint(13) NOT NULL,
  `CHECKIN_INTERVAL` bigint(13) NOT NULL,
  PRIMARY KEY (`SCHED_NAME`,`INSTANCE_NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `qrtz_simple_triggers`
--

DROP TABLE IF EXISTS `qrtz_simple_triggers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `qrtz_simple_triggers` (
  `SCHED_NAME` varchar(120) NOT NULL,
  `TRIGGER_NAME` varchar(200) NOT NULL,
  `TRIGGER_GROUP` varchar(200) NOT NULL,
  `REPEAT_COUNT` bigint(7) NOT NULL,
  `REPEAT_INTERVAL` bigint(12) NOT NULL,
  `TIMES_TRIGGERED` bigint(10) NOT NULL,
  PRIMARY KEY (`SCHED_NAME`,`TRIGGER_NAME`,`TRIGGER_GROUP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `qrtz_simprop_triggers`
--

DROP TABLE IF EXISTS `qrtz_simprop_triggers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `qrtz_simprop_triggers` (
  `SCHED_NAME` varchar(120) NOT NULL,
  `TRIGGER_NAME` varchar(200) NOT NULL,
  `TRIGGER_GROUP` varchar(200) NOT NULL,
  `STR_PROP_1` varchar(512) DEFAULT NULL,
  `STR_PROP_2` varchar(512) DEFAULT NULL,
  `STR_PROP_3` varchar(512) DEFAULT NULL,
  `INT_PROP_1` int(11) DEFAULT NULL,
  `INT_PROP_2` int(11) DEFAULT NULL,
  `LONG_PROP_1` bigint(20) DEFAULT NULL,
  `LONG_PROP_2` bigint(20) DEFAULT NULL,
  `DEC_PROP_1` decimal(13,4) DEFAULT NULL,
  `DEC_PROP_2` decimal(13,4) DEFAULT NULL,
  `BOOL_PROP_1` varchar(1) DEFAULT NULL,
  `BOOL_PROP_2` varchar(1) DEFAULT NULL,
  PRIMARY KEY (`SCHED_NAME`,`TRIGGER_NAME`,`TRIGGER_GROUP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `qrtz_triggers`
--

DROP TABLE IF EXISTS `qrtz_triggers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `qrtz_triggers` (
  `SCHED_NAME` varchar(120) NOT NULL,
  `TRIGGER_NAME` varchar(200) NOT NULL,
  `TRIGGER_GROUP` varchar(200) NOT NULL,
  `JOB_NAME` varchar(200) NOT NULL,
  `JOB_GROUP` varchar(200) NOT NULL,
  `DESCRIPTION` varchar(250) DEFAULT NULL,
  `NEXT_FIRE_TIME` bigint(13) DEFAULT NULL,
  `PREV_FIRE_TIME` bigint(13) DEFAULT NULL,
  `PRIORITY` int(11) DEFAULT NULL,
  `TRIGGER_STATE` varchar(16) NOT NULL,
  `TRIGGER_TYPE` varchar(8) NOT NULL,
  `START_TIME` bigint(13) NOT NULL,
  `END_TIME` bigint(13) DEFAULT NULL,
  `CALENDAR_NAME` varchar(200) DEFAULT NULL,
  `MISFIRE_INSTR` smallint(2) DEFAULT NULL,
  `JOB_DATA` blob,
  PRIMARY KEY (`SCHED_NAME`,`TRIGGER_NAME`,`TRIGGER_GROUP`),
  KEY `IDX_QRTZ_T_J` (`SCHED_NAME`,`JOB_NAME`,`JOB_GROUP`),
  KEY `IDX_QRTZ_T_JG` (`SCHED_NAME`,`JOB_GROUP`),
  KEY `IDX_QRTZ_T_C` (`SCHED_NAME`,`CALENDAR_NAME`),
  KEY `IDX_QRTZ_T_G` (`SCHED_NAME`,`TRIGGER_GROUP`),
  KEY `IDX_QRTZ_T_STATE` (`SCHED_NAME`,`TRIGGER_STATE`),
  KEY `IDX_QRTZ_T_N_STATE` (`SCHED_NAME`,`TRIGGER_NAME`,`TRIGGER_GROUP`,`TRIGGER_STATE`),
  KEY `IDX_QRTZ_T_N_G_STATE` (`SCHED_NAME`,`TRIGGER_GROUP`,`TRIGGER_STATE`),
  KEY `IDX_QRTZ_T_NEXT_FIRE_TIME` (`SCHED_NAME`,`NEXT_FIRE_TIME`),
  KEY `IDX_QRTZ_T_NFT_ST` (`SCHED_NAME`,`TRIGGER_STATE`,`NEXT_FIRE_TIME`),
  KEY `IDX_QRTZ_T_NFT_MISFIRE` (`SCHED_NAME`,`MISFIRE_INSTR`,`NEXT_FIRE_TIME`),
  KEY `IDX_QRTZ_T_NFT_ST_MISFIRE` (`SCHED_NAME`,`MISFIRE_INSTR`,`NEXT_FIRE_TIME`,`TRIGGER_STATE`),
  KEY `IDX_QRTZ_T_NFT_ST_MISFIRE_GRP` (`SCHED_NAME`,`MISFIRE_INSTR`,`NEXT_FIRE_TIME`,`TRIGGER_GROUP`,`TRIGGER_STATE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `registry_info`
--

DROP TABLE IF EXISTS `registry_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `registry_info` (
  `id` bigint(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `instance_id` varchar(128) NOT NULL DEFAULT '' COMMENT '租户信息',
  `registry_name` varchar(255) NOT NULL DEFAULT '' COMMENT '注册中心名称',
  `registry_type` varchar(128) NOT NULL DEFAULT '' COMMENT '注册中心类型',
  `ip_list` varchar(255) NOT NULL DEFAULT '' COMMENT 'ip地址，多个以","分隔',
  `cluster_id` varchar(255) NOT NULL DEFAULT '' COMMENT '所属集群，多个以","分割',
  `operator` varchar(64) DEFAULT NULL COMMENT '操作人',
  `gmt_create` datetime DEFAULT NULL COMMENT '创建时间',
  `gmt_modified` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_instance_id_registry_name` (`instance_id`,`registry_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='多注册中心表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `resource_lock`
--

DROP TABLE IF EXISTS `resource_lock`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `resource_lock` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `instance_id` varchar(128) NOT NULL COMMENT 'instanceId',
  `token` varchar(4096) NOT NULL COMMENT '第三方应用token',
  `resource_id` bigint(20) unsigned NOT NULL COMMENT '资源id',
  `resource_type` varchar(128) NOT NULL COMMENT '资源类型',
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_lock` (`instance_id`,`resource_id`,`resource_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='资源锁表,目前灰度场景下会锁住路由规则';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `resource_object`
--

DROP TABLE IF EXISTS `resource_object`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `resource_object` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `instance_id` varchar(128) DEFAULT NULL,
  `resource_name` varchar(255) DEFAULT NULL,
  `resource_type` varchar(255) DEFAULT NULL,
  `resource` mediumtext,
  `status` tinyint(4) DEFAULT NULL,
  `report_cluster` varchar(255) DEFAULT NULL,
  `workspace` varchar(255) DEFAULT NULL,
  `tenant` varchar(255) DEFAULT NULL,
  `namespace` varchar(255) DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `gmt_modified` datetime DEFAULT NULL,
  `operator` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_instanceId_resourceName_namespace_resourceType` (`instance_id`,`resource_name`,`namespace`,`resource_type`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `resource_recover`
--

DROP TABLE IF EXISTS `resource_recover`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `resource_recover` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `cluster_name` varchar(255) NOT NULL,
  `last_time` datetime NOT NULL,
  `running` varchar(10240) DEFAULT NULL,
  `failed` mediumtext,
  `operator` varchar(64) DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `gmt_modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_cluster_name` (`cluster_name`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `router_app_rule_relation`
--

DROP TABLE IF EXISTS `router_app_rule_relation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `router_app_rule_relation` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `object_id` bigint(255) NOT NULL COMMENT '实体id',
  `instance_id` varchar(128) NOT NULL COMMENT '实例id',
  `token` varchar(4096) NOT NULL COMMENT '应用token',
  `router_rule_id` varchar(128) NOT NULL COMMENT '路由规则id',
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_object_id_token_router_rule_id` (`instance_id`,`object_id`,`token`(128),`router_rule_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='应用和路由规则关联表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `router_object`
--

DROP TABLE IF EXISTS `router_object`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `router_object` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `instance_id` varchar(128) NOT NULL COMMENT 'instanceId',
  `object_id` varchar(255) NOT NULL DEFAULT '' COMMENT '资源ID，按照objectId下发规则',
  `type` tinyint(4) NOT NULL DEFAULT '0' COMMENT '资源类型，规则下发维度，0是调用端服务级；1是调用端应用级；10是接收端服务级; 11是接收端应用级',
  `operator` varchar(32) NOT NULL COMMENT '操作人',
  `gmt_create` datetime DEFAULT NULL COMMENT '创建时间',
  `gmt_modified` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_object_id_type` (`instance_id`,`object_id`,`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='规则下发对象';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `router_open_token`
--

DROP TABLE IF EXISTS `router_open_token`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `router_open_token` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `token` varchar(4096) NOT NULL COMMENT '第三方应用token',
  `instance_id` varchar(128) NOT NULL COMMENT 'instanceId',
  `scope` varchar(32) NOT NULL COMMENT '作用域(eg: 0-10000 10000-20000)',
  `owner` varchar(32) NOT NULL COMMENT '所拥有者',
  `comment` varchar(4096) DEFAULT NULL COMMENT '备注',
  `operator` varchar(32) NOT NULL COMMENT '操作人',
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_instance_id_token` (`instance_id`,`token`(128))
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='token信息表,用户可在drm上申请token用于调用服务路由api';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `router_rule`
--

DROP TABLE IF EXISTS `router_rule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `router_rule` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `instance_id` varchar(128) NOT NULL COMMENT 'instanceId',
  `app_name` varchar(256) NOT NULL COMMENT '应用名称',
  `dispatch_object_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT 'dispatch_object的主键',
  `content` text NOT NULL COMMENT '规则的内容，json格式',
  `version` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '路由规则的版本',
  `priority` int(11) NOT NULL DEFAULT '1' COMMENT '路由规则优先级，数字越小优先级越高',
  `gray_condition` varchar(2048) DEFAULT NULL COMMENT '控制规则下发范围',
  `enabled` tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否生效，1 生效，0 未生效。默认未生效',
  `name` varchar(1024) NOT NULL DEFAULT '' COMMENT '规则组的说明',
  `operator` varchar(32) NOT NULL DEFAULT '' COMMENT '操作人',
  `gmt_create` datetime DEFAULT NULL COMMENT '创建时间',
  `gmt_modified` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_dispatch_object_id` (`instance_id`,`dispatch_object_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='路由规则信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `router_rule_group`
--

DROP TABLE IF EXISTS `router_rule_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `router_rule_group` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `type` tinyint(4) unsigned NOT NULL DEFAULT '0' COMMENT 'dataID的类型，应用/服务；默认为0，服务级。',
  `data_id` varchar(255) NOT NULL DEFAULT '' COMMENT '服务注册的dataId',
  `instance_id` varchar(128) NOT NULL DEFAULT '' COMMENT '一个组合的一个workspace的标示',
  `enabled` tinyint(4) unsigned NOT NULL DEFAULT '0' COMMENT '该规则的状态，0表示未生效，1表示全部生效，2表示部分生效',
  `version` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '该配置的版本',
  `content` text COMMENT '路由规则的具体内容',
  `gmt_create` datetime DEFAULT NULL COMMENT '创建时间',
  `gmt_modified` datetime DEFAULT NULL COMMENT '修改时间',
  `operator` varchar(64) DEFAULT NULL COMMENT '操作人',
  `app_name` varchar(256) DEFAULT NULL COMMENT '应用名称',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_instance_id_data_id_type` (`instance_id`,`data_id`,`type`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `secure_communication_label`
--

DROP TABLE IF EXISTS `secure_communication_label`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `secure_communication_label` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `rule_id` bigint(20) NOT NULL COMMENT '对应secure_communication_rule表的id',
  `key` varchar(255) NOT NULL COMMENT 'key',
  `value` varchar(255) NOT NULL COMMENT 'value',
  `type` tinyint(4) NOT NULL COMMENT '类型(0-应用,1-label)',
  `operator` varchar(64) DEFAULT NULL COMMENT '操作人',
  `gmt_create` datetime DEFAULT NULL COMMENT '创建时间',
  `gmt_modified` datetime DEFAULT NULL COMMENT '修改时间',
  `feature` varchar(128) DEFAULT 'securityEncrypt' COMMENT '当前label所属功能',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='通信加密label表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `secure_communication_rule`
--

DROP TABLE IF EXISTS `secure_communication_rule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `secure_communication_rule` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `instance_id` varchar(128) NOT NULL DEFAULT '' COMMENT '租户信息',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT '规则名称',
  `direction` tinyint(4) NOT NULL COMMENT '加密方向(0-client,1-server)',
  `mode` tinyint(4) NOT NULL COMMENT '加密模式(0-tls,1-mtls)',
  `strategy` varchar(255) NOT NULL COMMENT '加密策略(0-普通,1-国密,其他)',
  `enabled` tinyint(4) unsigned NOT NULL DEFAULT '0' COMMENT '该规则的状态，0表示未生效，1表示全部生效',
  `scope` tinyint(4) NOT NULL COMMENT '下发粒度(0-应用,1-label)',
  `label_code` varchar(255) DEFAULT NULL COMMENT 'label的md5值',
  `operator` varchar(64) DEFAULT NULL COMMENT '操作人',
  `gmt_create` datetime DEFAULT NULL COMMENT '创建时间',
  `gmt_modified` datetime DEFAULT NULL COMMENT '修改时间',
  `protocols` varchar(128) DEFAULT '' COMMENT '协议',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_instance_id_direction_label_code` (`instance_id`,`direction`,`label_code`),
  KEY `k_instance_id_name` (`instance_id`,`name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='通信加密规则表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `server`
--

DROP TABLE IF EXISTS `server`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `server` (
  `id` bigint(11) unsigned NOT NULL AUTO_INCREMENT,
  `type` varchar(50) NOT NULL DEFAULT '' COMMENT '服务类型',
  `data_center` varchar(100) NOT NULL DEFAULT '' COMMENT '机房',
  `ip_list` varchar(1000) NOT NULL DEFAULT '' COMMENT 'ip 列表',
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_idx` (`data_center`,`type`),
  KEY `IDX_GMT_CREATE` (`gmt_create`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `service_config`
--

DROP TABLE IF EXISTS `service_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `service_config` (
  `id` bigint(11) unsigned NOT NULL AUTO_INCREMENT,
  `instance_id` varchar(128) NOT NULL DEFAULT '',
  `data_id` varchar(1024) NOT NULL DEFAULT '',
  `service_ip` varchar(15) NOT NULL DEFAULT '' COMMENT '服务发布时，发布内容中解析出来的 ip',
  `service_port` int(11) NOT NULL COMMENT '服务发布时，发布内容中解析出来的端口 port',
  `app_name` varchar(256) DEFAULT NULL,
  `weight` int(11) DEFAULT NULL COMMENT '通过服务参数修改的权重，覆盖 service_pub_info 中的权重',
  `status` int(11) DEFAULT NULL COMMENT '通过服务参数修改的启用1/禁用0，覆盖 service_pub_info 中的启用/禁用',
  `gmt_create` datetime DEFAULT NULL,
  `gmt_modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `service_info`
--

DROP TABLE IF EXISTS `service_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `service_info` (
  `id` bigint(11) unsigned NOT NULL AUTO_INCREMENT,
  `instance_id` varchar(128) NOT NULL DEFAULT '',
  `data_id` varchar(512) NOT NULL DEFAULT '' COMMENT ' 配置中心 dataid，与 instanceId 一起构成逻辑主键',
  `service` varchar(256) DEFAULT NULL COMMENT '服务接口全称',
  `version` varchar(128) DEFAULT NULL COMMENT '服务版本',
  `unique_id` varchar(128) DEFAULT NULL COMMENT '服务唯一值，可用于区分相同服务下的不同分组',
  `protocol` varchar(32) DEFAULT NULL COMMENT '服务协议，目前有DEFAULT、XFIRE、DUBBO',
  `app_name` varchar(257) DEFAULT NULL,
  `check_sum` varchar(50) DEFAULT NULL COMMENT '校验值',
  `gmt_create` datetime DEFAULT NULL,
  `gmt_modified` datetime DEFAULT NULL,
  `service_type` varchar(32) DEFAULT 'SOFA' COMMENT '服务类型',
  `sources` varchar(10) DEFAULT NULL COMMENT '添加方式(1-手动添加,0-自动添加)',
  `service_sources` varchar(255) DEFAULT NULL COMMENT '服务信息来源',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_check_sum` (`check_sum`),
  UNIQUE KEY `uk_instance_id_data_id_app_name` (`instance_id`,`data_id`(255),`app_name`(255)),
  KEY `idx_app_name` (`instance_id`,`app_name`(255))
) ENGINE=InnoDB AUTO_INCREMENT=112721 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `service_process_info`
--

DROP TABLE IF EXISTS `service_process_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `service_process_info` (
  `id` bigint(11) unsigned NOT NULL AUTO_INCREMENT,
  `process_id` varchar(128) NOT NULL DEFAULT '' COMMENT '配置中心客户端进程 id',
  `instance_id` varchar(128) DEFAULT NULL COMMENT '实例ID',
  `heartbeat` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '配置中心心跳时间戳，每次收到心跳更新此时间戳为心跳时间',
  `alive` int(11) NOT NULL COMMENT '进程存活状态，存活1，下线0，长时间未心跳，更新为0；配置中心推送下线，更新为0',
  `app_name` varchar(256) DEFAULT NULL,
  `host_ip` varchar(15) DEFAULT NULL,
  `gmt_create` datetime DEFAULT NULL,
  `gmt_modified` datetime DEFAULT NULL,
  `origin` varchar(128) DEFAULT 'sofa_registry' COMMENT '上报进程信息来源',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_process` (`process_id`),
  KEY `idx_heartbeat` (`heartbeat`)
) ENGINE=InnoDB AUTO_INCREMENT=1456351 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `service_pub_info`
--

DROP TABLE IF EXISTS `service_pub_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `service_pub_info` (
  `id` bigint(11) unsigned NOT NULL AUTO_INCREMENT,
  `instance_id` varchar(128) NOT NULL DEFAULT '',
  `data_id` varchar(1024) NOT NULL DEFAULT '',
  `process_id` varchar(128) NOT NULL DEFAULT '',
  `service_ip` varchar(15) NOT NULL DEFAULT '' COMMENT '服务发布时，发布内容中发布出来的 ip',
  `service_port` int(11) NOT NULL COMMENT '服务发布时，发布内容中发布出来的端口 port',
  `app_name` varchar(256) DEFAULT NULL,
  `zone` varchar(128) DEFAULT '' COMMENT '服务发布时，发布内容中发布出来的 zone',
  `timeout` int(11) unsigned DEFAULT NULL COMMENT '服务发布时，发布内容中发布出来的 timeout',
  `weight` int(11) unsigned DEFAULT NULL COMMENT '服务发布时，发布内容中发布出来的权重',
  `status` int(11) NOT NULL DEFAULT '1' COMMENT '服务发布时，发布内容中发布出来的状态，不同于 alive，这个状态标识当前服务''启用''/''禁用''，默认1',
  `alive` int(11) NOT NULL DEFAULT '1' COMMENT '由配置中心心跳等同步机制来判断的服务是否存活，存活1，已下线0，默认存活1',
  `host_ip` varchar(15) DEFAULT NULL COMMENT '发布这个服务的主机的 ip，不同于 service_ip',
  `content` varchar(10240) DEFAULT NULL COMMENT '注册的内容',
  `check_sum` varchar(50) DEFAULT NULL COMMENT '校验值',
  `gmt_create` datetime DEFAULT NULL,
  `gmt_modified` datetime DEFAULT NULL,
  `app_version` varchar(50) DEFAULT NULL COMMENT '应用版本',
  `protocol` varchar(16) DEFAULT NULL COMMENT '协议',
  `register_id` varchar(256) DEFAULT NULL COMMENT '服务注册的registerId',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_check_sum` (`check_sum`),
  KEY `process_id_alive` (`process_id`,`alive`),
  KEY `key_instance_data_app` (`instance_id`,`data_id`(255),`app_name`(255))
) ENGINE=InnoDB AUTO_INCREMENT=151705 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `service_rate_limit_rule`
--

DROP TABLE IF EXISTS `service_rate_limit_rule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `service_rate_limit_rule` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `data_id` varchar(256) NOT NULL,
  `service_type` varchar(50) NOT NULL,
  `app_name` varchar(256) NOT NULL,
  `name` varchar(256) NOT NULL,
  `enable` tinyint(4) NOT NULL,
  `run_mode` varchar(50) NOT NULL,
  `resource_type` varchar(50) NOT NULL,
  `rule_config` mediumtext NOT NULL,
  `instance_id` varchar(50) NOT NULL,
  `operator` varchar(256) DEFAULT NULL,
  `gmt_create` datetime NOT NULL,
  `gmt_modified` datetime NOT NULL,
  `resource_id` varchar(500) DEFAULT NULL COMMENT 'instance_id+|+app_name+|+data_id+|+traffic_type+|+method(httpMethod+|+httpPath)',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_resource_id` (`resource_id`(255)),
  KEY `IDX_DATA_ID` (`data_id`(255))
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `service_sub_info`
--

DROP TABLE IF EXISTS `service_sub_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `service_sub_info` (
  `id` bigint(11) unsigned NOT NULL AUTO_INCREMENT,
  `instance_id` varchar(128) NOT NULL DEFAULT '',
  `data_id` varchar(1024) NOT NULL DEFAULT '',
  `process_id` varchar(128) NOT NULL DEFAULT '' COMMENT '配置中心的进程 id',
  `host_ip` varchar(15) NOT NULL DEFAULT '' COMMENT '订阅端的主机 ip',
  `app_name` varchar(256) DEFAULT NULL,
  `zone` varchar(128) DEFAULT '' COMMENT '服务发布时，发布内容中发布出来的 zone',
  `scope` varchar(10) DEFAULT NULL COMMENT '订阅者的订阅维度',
  `alive` int(1) NOT NULL DEFAULT '1' COMMENT '订阅端是否存活，默认1-存活，订阅端下线标记为0，默认1',
  `check_sum` varchar(50) DEFAULT NULL COMMENT '校验值',
  `gmt_create` datetime DEFAULT NULL,
  `gmt_modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_check_sum` (`check_sum`),
  KEY `process_id_alive` (`process_id`,`alive`),
  KEY `key_instance_data_app` (`instance_id`,`data_id`(255),`app_name`(255))
) ENGINE=InnoDB AUTO_INCREMENT=375268 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sidecar_info`
--

DROP TABLE IF EXISTS `sidecar_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sidecar_info` (
  `id` bigint(11) unsigned NOT NULL AUTO_INCREMENT,
  `instance_id` varchar(128) NOT NULL DEFAULT '',
  `app_name` varchar(256) NOT NULL COMMENT '应用名称',
  `cluster_name` varchar(255) DEFAULT '' COMMENT '集群名称',
  `cluster_type` varchar(15) DEFAULT NULL COMMENT '集群类型',
  `pod_ip` varchar(15) DEFAULT NULL COMMENT 'pod的ip',
  `host_ip` varchar(15) DEFAULT NULL COMMENT 'host的ip',
  `inject_status` varchar(15) DEFAULT NULL COMMENT '注入状态 0-未注入1-已注入2-注入中',
  `status` varchar(15) DEFAULT NULL COMMENT 'pod运行状态 1-正常0-异常',
  `pod_name` varchar(255) NOT NULL COMMENT 'pod名称',
  `namespace` varchar(255) NOT NULL COMMENT 'pod所在namespace',
  `owner_references` varchar(1024) DEFAULT NULL COMMENT 'pod的ownerReferencecs',
  `template_name` varchar(255) DEFAULT NULL COMMENT '注入sidecar的模板名',
  `sidecar_create_time` datetime DEFAULT NULL,
  `app_name_source` varchar(15) NOT NULL COMMENT '应用名来源，0-自动渲染，1-手动添加，2-deploy/sts名',
  `alive` int(11) NOT NULL COMMENT '存活信息, pod存在1，被delete了是0',
  `event` varchar(10240) DEFAULT NULL COMMENT 'sidecar状态信息流转',
  `gmt_create` datetime DEFAULT NULL,
  `gmt_modified` datetime DEFAULT NULL,
  `resource_type` varchar(255) DEFAULT NULL COMMENT '父级资源类型',
  `resource_name` varchar(255) DEFAULT NULL COMMENT '父级资源名',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_pod_name_instance_id_namespace_cluster_name` (`pod_name`,`instance_id`,`namespace`,`cluster_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sidecar_inject`
--

DROP TABLE IF EXISTS `sidecar_inject`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sidecar_inject` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `instance_id` varchar(128) NOT NULL DEFAULT '' COMMENT '租户信息',
  `sidecar_name` varchar(128) NOT NULL DEFAULT '' COMMENT 'sidecar名称',
  `status` tinyint(4) unsigned NOT NULL DEFAULT '0' COMMENT 'sidecar配置状态（0关闭，1开启）',
  `config` mediumtext NOT NULL COMMENT '配置信息，格式和类型绑定',
  `operator` varchar(64) DEFAULT NULL COMMENT '操作人',
  `gmt_create` datetime DEFAULT NULL COMMENT '创建时间',
  `gmt_modified` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_sidecar_name` (`sidecar_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='sidecar注入配置表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sidecar_inject_rule`
--

DROP TABLE IF EXISTS `sidecar_inject_rule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sidecar_inject_rule` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `instance_id` varchar(128) NOT NULL DEFAULT '' COMMENT '租户信息',
  `name` varchar(128) NOT NULL DEFAULT '' COMMENT '版本配置名称',
  `sidecar_name` varchar(128) NOT NULL DEFAULT '' COMMENT 'sidecar名称',
  `sidecar_type` varchar(32) DEFAULT '' COMMENT '类型（容器 CONTAINERT /虚拟机 VM）',
  `sidecar_version_id` varchar(128) NOT NULL DEFAULT '' COMMENT '版本号',
  `content` text NOT NULL COMMENT '渲染后的内容，一般为yaml格式',
  `param_values` varchar(10240) DEFAULT NULL COMMENT '参数配置',
  `rules` varchar(4096) DEFAULT NULL COMMENT '规则配置',
  `status` tinyint(4) unsigned NOT NULL DEFAULT '0' COMMENT '状态（0关闭，1开启）',
  `remark` varchar(2048) DEFAULT NULL COMMENT '备注',
  `operator` varchar(64) DEFAULT NULL COMMENT '操作人',
  `gmt_create` datetime DEFAULT NULL COMMENT '创建时间',
  `gmt_modified` datetime DEFAULT NULL COMMENT '修改时间',
  `sidecar_inject_rule_config_json_string` varchar(3072) DEFAULT NULL COMMENT 'sidecar注入规则配置结构化json',
  `cluster_config_ids` varchar(512) DEFAULT NULL COMMENT '所属集群ids',
  `cluster_config_names` varchar(512) DEFAULT NULL COMMENT '所属集群名称',
  `iteration_type` tinyint(4) unsigned NOT NULL DEFAULT '0' COMMENT '10为旧版本（迭代前版本），11为使用中版本（迭代后版本）',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='sidecar注入规则表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sidecar_template`
--

DROP TABLE IF EXISTS `sidecar_template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sidecar_template` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `instance_id` varchar(128) NOT NULL DEFAULT '' COMMENT '租户信息',
  `template_name` varchar(128) NOT NULL DEFAULT '' COMMENT '模版名称',
  `sidecar_name` varchar(128) NOT NULL DEFAULT '' COMMENT 'sidecar名称',
  `sidecar_type` varchar(32) NOT NULL DEFAULT '' COMMENT '类型（容器 CONTAINERT /虚拟机 VM）',
  `version` varchar(128) NOT NULL DEFAULT '' COMMENT '版本号',
  `content` mediumtext NOT NULL COMMENT '模版内容',
  `param_values` varchar(10240) NOT NULL COMMENT '模版配置',
  `remark` varchar(2048) DEFAULT NULL COMMENT '备注',
  `status` tinyint(4) unsigned NOT NULL DEFAULT '0' COMMENT '状态（0关闭，1开启）',
  `operator` varchar(64) DEFAULT NULL COMMENT '操作人',
  `gmt_create` datetime DEFAULT NULL COMMENT '创建时间',
  `gmt_modified` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_instance_id_sidecar_name_sidecar_type_version` (`instance_id`,`sidecar_name`,`sidecar_type`,`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='sidecar模版表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sidecar_total_plugins`
--

DROP TABLE IF EXISTS `sidecar_total_plugins`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sidecar_total_plugins` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `instance_id` varchar(128) NOT NULL DEFAULT '' COMMENT '租户信息',
  `file_path` varchar(512) DEFAULT NULL COMMENT '文件路径',
  `save_type` varchar(512) DEFAULT NULL COMMENT '存储方式',
  `function_plugin_file` longblob COMMENT '插件主体',
  `zip_file_name` varchar(128) DEFAULT NULL COMMENT '插件包名称',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=110032 DEFAULT CHARSET=utf8 COMMENT='sidecar插件集合表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sidecar_version`
--

DROP TABLE IF EXISTS `sidecar_version`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sidecar_version` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `instance_id` varchar(128) NOT NULL DEFAULT '' COMMENT '租户信息',
  `sidecar_name` varchar(128) DEFAULT '' COMMENT 'sidecar名称',
  `sidecar_type` varchar(128) DEFAULT '' COMMENT 'sidecar类型',
  `name` varchar(128) DEFAULT NULL COMMENT '版本配置名称',
  `version` varchar(128) NOT NULL DEFAULT '' COMMENT '版本号',
  `template_id` bigint(20) unsigned DEFAULT NULL COMMENT '模版主键',
  `parent_version_id` bigint(20) unsigned DEFAULT NULL COMMENT '上级版本配置主键',
  `content` mediumtext COMMENT '渲染后的内容，一般为yaml格式',
  `param_values` varchar(10240) DEFAULT NULL COMMENT '规则配置',
  `status` tinyint(4) unsigned NOT NULL DEFAULT '0' COMMENT '可见状态，管理员操作（0对用户不可见，1对用户可见）',
  `default_flag` tinyint(4) unsigned DEFAULT '0' COMMENT '是否默认 0:否 1:是',
  `remark` varchar(10240) DEFAULT NULL COMMENT '备注',
  `operator` varchar(64) DEFAULT NULL COMMENT '操作人',
  `gmt_create` datetime DEFAULT NULL COMMENT '创建时间',
  `gmt_modified` datetime DEFAULT NULL COMMENT '修改时间',
  `iteration_type` tinyint(4) unsigned NOT NULL DEFAULT '0' COMMENT '10为旧版本（迭代前版本）11为使用中版本（迭代后版本）',
  `image_address` varchar(128) DEFAULT '' COMMENT 'mosn image',
  `tar_address` varchar(128) DEFAULT '' COMMENT 'mosn tar',
  `dependencies` varchar(128) DEFAULT '' COMMENT 'sidecar 依赖',
  `dependences_md5` varchar(128) DEFAULT NULL COMMENT 'sidecar 依赖md5',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='sidecar版本配置表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sign_rule`
--

DROP TABLE IF EXISTS `sign_rule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sign_rule` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `instance_id` varchar(128) NOT NULL DEFAULT '' COMMENT '租户信息',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT '规则名称',
  `app_name` varchar(255) NOT NULL DEFAULT '' COMMENT '应用名称',
  `data_id` varchar(255) NOT NULL DEFAULT '' COMMENT '服务ID',
  `direction` tinyint(4) NOT NULL COMMENT '签名方向(0-client,1-server)',
  `rule_body` text NOT NULL COMMENT '防篡改规则',
  `enabled` tinyint(4) unsigned NOT NULL DEFAULT '0' COMMENT '该规则的状态，0表示未生效，1表示全部生效',
  `label_code` varchar(255) DEFAULT NULL COMMENT 'label的md5值',
  `operator` varchar(64) DEFAULT NULL COMMENT '操作人',
  `gmt_create` datetime DEFAULT NULL COMMENT '创建时间',
  `gmt_modified` datetime DEFAULT NULL COMMENT '修改时间',
  `scope` tinyint(4) NOT NULL COMMENT '生效范围 0 应用 1 label',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_instance_id_app_name_data_id_direction` (`instance_id`,`app_name`,`data_id`,`direction`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='防篡改规则表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sub_registry_infor_with_sidecar_inject_rule`
--

DROP TABLE IF EXISTS `sub_registry_infor_with_sidecar_inject_rule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sub_registry_infor_with_sidecar_inject_rule` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `instance_id` varchar(128) NOT NULL DEFAULT '' COMMENT '租户信息',
  `sub_registry_info_id` bigint(20) NOT NULL COMMENT '订阅中心id',
  `sidecar_inject_rule_id` bigint(20) NOT NULL COMMENT 'sidecar注入规则规则表id',
  `operator` varchar(64) DEFAULT NULL COMMENT '操作人',
  `gmt_create` datetime DEFAULT NULL COMMENT '创建时间',
  `gmt_modified` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='订阅中心与sidecar注入规则多对多关联关系记录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tenant`
--

DROP TABLE IF EXISTS `tenant`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tenant` (
  `id` bigint(11) unsigned NOT NULL AUTO_INCREMENT,
  `tenant_id` varchar(64) DEFAULT NULL COMMENT '租户ID',
  `tenant_name` varchar(64) DEFAULT NULL COMMENT '租户名字',
  `tenant_status` varchar(64) DEFAULT NULL COMMENT '租住状态',
  `order_no` varchar(64) DEFAULT NULL COMMENT '订单号用于业务串联，以及幂等',
  `product_code` varchar(64) DEFAULT NULL COMMENT '产品码全局唯一',
  `product_instance_id` varchar(64) DEFAULT NULL COMMENT '产品实例ID开通会生成产品实例Id，作为后续生命周期SPI管理资源的标识',
  `gmt_create` datetime DEFAULT NULL,
  `gmt_modified` datetime DEFAULT NULL,
  `operator` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='租户信息';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `traffic_mirror_rule`
--

DROP TABLE IF EXISTS `traffic_mirror_rule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `traffic_mirror_rule` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `instance_id` varchar(128) NOT NULL DEFAULT '' COMMENT '租户信息',
  `source_app` varchar(255) NOT NULL DEFAULT '' COMMENT '应用名称',
  `source_data_id` varchar(255) NOT NULL DEFAULT '' COMMENT '服务注册ID',
  `target_app` varchar(255) NOT NULL DEFAULT '' COMMENT '目标应用名称',
  `target_data_id` varchar(255) NOT NULL DEFAULT '' COMMENT '目标服务名称',
  `rule_name` varchar(255) NOT NULL DEFAULT '' COMMENT '规则名称',
  `enabled` tinyint(4) unsigned NOT NULL DEFAULT '0' COMMENT '该规则的状态，0表示未生效，1表示全部生效，2表示部分生效',
  `rule_config` mediumtext NOT NULL COMMENT '流量镜像规则配置',
  `operator` varchar(64) DEFAULT NULL COMMENT '操作人',
  `gmt_create` datetime DEFAULT NULL COMMENT '创建时间',
  `gmt_modified` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='流量镜像规则表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `transparent_proxy_app`
--

DROP TABLE IF EXISTS `transparent_proxy_app`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `transparent_proxy_app` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `instance_id` varchar(128) NOT NULL DEFAULT '' COMMENT '租户信息',
  `app_name` varchar(256) NOT NULL DEFAULT '' COMMENT '应用名',
  `app_config` text COMMENT '应用劫持配置',
  `operator` varchar(64) DEFAULT NULL COMMENT '操作人',
  `gmt_create` datetime DEFAULT NULL COMMENT '创建时间',
  `gmt_modified` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_instance_id_app_name` (`instance_id`,`app_name`(255))
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='透明劫持应用表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `transparent_proxy_node`
--

DROP TABLE IF EXISTS `transparent_proxy_node`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `transparent_proxy_node` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `instance_id` varchar(128) NOT NULL DEFAULT '' COMMENT '租户信息',
  `app_name` varchar(256) NOT NULL DEFAULT '' COMMENT '应用名',
  `ip` varchar(64) NOT NULL DEFAULT '' COMMENT '节点IP',
  `node_type` varchar(32) NOT NULL DEFAULT '' COMMENT '集群类型',
  `transparent_proxy_switch` tinyint(4) NOT NULL DEFAULT '0' COMMENT '劫持开关 0关 1开',
  `operator` varchar(64) DEFAULT NULL COMMENT '操作人',
  `gmt_create` datetime DEFAULT NULL COMMENT '创建时间',
  `gmt_modified` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_instance_id_app_name_ip` (`instance_id`,`ip`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='透明劫持应用节点表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `transparent_proxy_operator_log`
--

DROP TABLE IF EXISTS `transparent_proxy_operator_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `transparent_proxy_operator_log` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `instance_id` varchar(128) NOT NULL DEFAULT '' COMMENT '租户信息',
  `app_name` varchar(256) NOT NULL DEFAULT '' COMMENT '应用名',
  `log_type` varchar(32) NOT NULL DEFAULT '' COMMENT '日志类型',
  `port` int(11) NOT NULL DEFAULT '0' COMMENT '端口',
  `node_ip` varchar(64) NOT NULL DEFAULT '' COMMENT '节点IP',
  `operator_log` text COMMENT '操作记录',
  `remark` varchar(512) NOT NULL DEFAULT '' COMMENT '备注',
  `operator` varchar(64) DEFAULT NULL COMMENT '操作人',
  `gmt_create` datetime DEFAULT NULL COMMENT '创建时间',
  `gmt_modified` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`),
  KEY `idx_gmt_create` (`gmt_create`),
  KEY `idx_instance_id_app_name_log_type` (`instance_id`,`app_name`(64),`log_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='透明劫持操作日志表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `transparent_proxy_protocol`
--

DROP TABLE IF EXISTS `transparent_proxy_protocol`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `transparent_proxy_protocol` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `instance_id` varchar(128) NOT NULL DEFAULT '' COMMENT '租户信息',
  `app_name` varchar(256) NOT NULL DEFAULT '' COMMENT '应用名',
  `protocol` varchar(64) NOT NULL COMMENT '协议',
  `port` int(11) NOT NULL COMMENT '端口',
  `protocol_config` text COMMENT '协议治理配置',
  `gmt_create` datetime DEFAULT NULL COMMENT '创建时间',
  `gmt_modified` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_instance_id_app_name_port` (`instance_id`,`app_name`(64),`port`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='透明劫持应用协议表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `usage`
--

DROP TABLE IF EXISTS `usage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `usage` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `instance_id` varchar(128) NOT NULL DEFAULT '',
  `server_address` varchar(128) NOT NULL DEFAULT '',
  `client_address` varchar(128) NOT NULL DEFAULT '',
  `product_name` varchar(128) NOT NULL DEFAULT '',
  `report_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `gmt_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_report_time_instance_id_client_address` (`report_time`,`instance_id`,`client_address`),
  KEY `IDX_REPORT_TIME` (`report_time`)
) ENGINE=InnoDB AUTO_INCREMENT=96382395 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `usage_stat`
--

DROP TABLE IF EXISTS `usage_stat`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `usage_stat` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `instance_id` varchar(128) NOT NULL DEFAULT '',
  `client_address` varchar(128) NOT NULL DEFAULT '',
  `charge_hour` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `uses` int(11) NOT NULL DEFAULT '0',
  `gmt_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_instance_client_charge` (`instance_id`,`client_address`,`charge_hour`),
  KEY `idx_chargehour_instanceid` (`charge_hour`,`instance_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2055183 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_info`
--

DROP TABLE IF EXISTS `user_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_info` (
  `id` bigint(13) NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `user_name` varchar(100) NOT NULL COMMENT '用户名称',
  `real_name` varchar(300) DEFAULT NULL COMMENT '真实姓名',
  `gmt_create` datetime DEFAULT NULL COMMENT '创建时间',
  `gmt_modified` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) COMMENT '主键',
  UNIQUE KEY `user_name` (`user_name`) COMMENT '唯一键约束'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `vm_details`
--

DROP TABLE IF EXISTS `vm_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `vm_details` (
  `id` bigint(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `instance_id` varchar(128) NOT NULL DEFAULT '' COMMENT '租户信息',
  `cluster_name` varchar(255) NOT NULL DEFAULT '' COMMENT '集群name',
  `ip` varchar(32) DEFAULT NULL COMMENT 'IP地址',
  `port` varchar(32) DEFAULT NULL COMMENT '端口',
  `ssh_name` varchar(32) DEFAULT NULL COMMENT 'ssh用户名',
  `ssh_password` varchar(32) DEFAULT NULL COMMENT 'ssh密码',
  `status` tinyint(4) unsigned DEFAULT NULL COMMENT '开启服务网格1，未开启0',
  `actual_ip` varchar(32) DEFAULT NULL COMMENT '真实ip地址',
  `gmt_create` datetime DEFAULT NULL,
  `gmt_modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='vm详情';
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-09-07 19:32:19