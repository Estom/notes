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
  KEY `idx_instance_zone` (`instance_id`,`zone`),
  KEY `idx_gmt_modified` (`gmt_modified`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=216 DEFAULT CHARSET=utf8mb4 COMMENT='动态资源推送数据表'

--查看数据库索引长度设置
show variables like 'innodb_large_prefix'; 
show variables like 'innodb_file_format';
-- 数据库设置
set global innodb_large_prefix=ON;//开启不限制索引长度 
set global innodb_file_format=BARRACUDA;//这个不知道

-- 表字段设置为动态格式
alter table drm_data row_format=dynamic;
alter table drm_log row_format=dynamic;
alter table drm_rollback_context row_format=dynamic;

-- 修改数据库的编码
alter table drm_data convert to character SET utf8mb4;
alter table drm_log convert to character SET utf8mb4;
alter table drm_rollback_context convert to character SET utf8mb4;



