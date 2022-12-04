alter table resource_lock 
	drop index uk_lock,
	ADD UNIQUE INDEX `uk_lock` (`instance_id`, `resource_id`, `resource_type`);


ALTER TABLE `mesh_cluster`
	ADD COLUMN `type` VARCHAR(4) DEFAULT '' COMMENT '集群类型',
	ADD COLUMN `gateway_status` VARCHAR(4) DEFAULT '' COMMENT '是否开启网关',
	ADD COLUMN `gateway_config` TEXT COMMENT '开通网关的配置信息',
	ADD COLUMN `mesh_config` TEXT COMMENT '开通mesh的配置信息',
	DROP INDEX uk_cluster_name,
	ADD UNIQUE INDEX `uk_cluster_name` (`instance_id`, `cluster_name`);



CREATE TABLE `registry_info` (
	`id` BIGINT(11) UNSIGNED AUTO_INCREMENT NOT NULL COMMENT '主键', 
	`instance_id` VARCHAR(128) DEFAULT '' NOT NULL COMMENT '租户信息', 
	`registry_name` VARCHAR(255) DEFAULT '' NOT NULL COMMENT '注册中心名称', 
	`registry_type` VARCHAR(128) DEFAULT '' NOT NULL COMMENT '注册中心类型', 
	`ip_list` VARCHAR(255) DEFAULT '' NOT NULL COMMENT 'ip地址，多个以","分隔', 
	`cluster_id` VARCHAR(255) DEFAULT '' NOT NULL COMMENT '所属集群，多个以","分割', 
	`operator` VARCHAR(64) NULL COMMENT '操作人', 
	`gmt_create` DATETIME NULL COMMENT '创建时间', 
	`gmt_modified` DATETIME NULL COMMENT '修改时间', 
	PRIMARY KEY (`id`), 
	UNIQUE `uk_instance_id_registry_name` (`instance_id`, `registry_name`)
) COMMENT = '多注册中心表';



ALTER TABLE `service_info`
	ADD COLUMN `sources` varchar(10) NULL COMMENT '添加方式(1-手动添加,0-自动添加)',
	ADD COLUMN `service_sources` varchar(255) NULL COMMENT '服务信息来源';


CREATE TABLE `sidecar_info` (
	`id` bigint(11) UNSIGNED AUTO_INCREMENT NOT NULL, 
	`instance_id` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT '' NOT NULL, 
	`app_name` varchar(256) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '应用名称', 
	`cluster_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT '' COMMENT '集群名称', 
	`cluster_type` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '集群类型', 
	`pod_ip` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT 'pod的ip', 
	`host_ip` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT 'host的ip', 
	`inject_status` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '注入状态 0-未注入1-已注入2-注入中', 
	`status` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT 'pod运行状态 1-正常0-异常', 
	`pod_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'pod名称', 
	`namespace` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'pod所在namespace', 
	`owner_references` varchar(1024) CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT 'pod的ownerReferencecs', 
	`template_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '注入sidecar的模板名', 
	`sidecar_create_time` datetime NULL, 
	`app_name_source` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '应用名来源，0-自动渲染，1-手动添加，2-deploy/sts名', 
	`alive` int(11) NOT NULL COMMENT '存活信息, pod存在1，被delete了是0', 
	`event` varchar(10240) CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT 'sidecar状态信息流转', 
	`gmt_create` datetime NULL, 
	`gmt_modified` datetime NULL, 
	`resource_type` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '父级资源类型', 
	`resource_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '父级资源名', 
	PRIMARY KEY (`id`), 
	UNIQUE `uk_pod_name_instance_id_namespace_cluster_name` (`pod_name`, `instance_id`, `namespace`, `cluster_name`)
) AUTO_INCREMENT = 0 CHARACTER SET = utf8;



CREATE TABLE `app_info` (
	`id` bigint(11) UNSIGNED AUTO_INCREMENT NOT NULL, 
	`instance_id` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT '' NOT NULL, 
	`cluster_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT '' COMMENT 'mesh_cluster表的name,多个以","分隔', 
	`app_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '应用名称', 
	`sources` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT '0' COMMENT '添加方式(1-手动添加,0-自动添加)', 
	`content` varchar(10240) CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '附加字段', 
	`gmt_create` datetime NULL, 
	`gmt_modified` datetime NULL, 
	PRIMARY KEY (`id`), 
	UNIQUE `uk_instance_id_app_name_cluster_name` (`instance_id`, `app_name`, `cluster_name`)
) AUTO_INCREMENT = 0 CHARACTER SET = utf8;



CREATE TABLE IF NOT EXISTS `protocol` (
	`id` bigint(20) UNSIGNED AUTO_INCREMENT NOT NULL COMMENT '主键', 
	`instance_id` varchar(128) DEFAULT '' NOT NULL COMMENT '租户信息', 
	`name` varchar(128) DEFAULT '' NOT NULL COMMENT '协议名', 
	`protocol` varchar(64) DEFAULT '' NOT NULL COMMENT '协议', 
	`protocol_type` tinyint(4) NOT NULL COMMENT '协议类型', 
	`description` varchar(10240) NULL COMMENT '备注', 
	`operator` varchar(64) NULL COMMENT '操作人', 
	`gmt_create` datetime NULL COMMENT '创建时间', 
	`gmt_modified` datetime NULL COMMENT '修改时间', 
	PRIMARY KEY (`id`)
) ENGINE = InnoDB AUTO_INCREMENT = 0 CHARSET = utf8 COMMENT = '协议表';



CREATE TABLE IF NOT EXISTS `protocol_inst` (
	`id` bigint(20) UNSIGNED AUTO_INCREMENT NOT NULL COMMENT '主键', 
	`instance_id` varchar(128) DEFAULT '' NOT NULL COMMENT '租户信息', 
	`proto_id` bigint(20) NOT NULL COMMENT '协议id；关联协议表主键', 
	`version` varchar(128) DEFAULT '' NOT NULL COMMENT '协议版本', 
	`func_plugin_ids` varchar(512) DEFAULT '' COMMENT '功能插件ids', 
	`description` varchar(10240) NULL COMMENT '备注', 
	`operator` varchar(64) NULL COMMENT '操作人', 
	`gmt_create` datetime NULL COMMENT '创建时间', 
	`gmt_modified` datetime NULL COMMENT '修改时间', 
	`transcoder_config` varchar(512) NULL COMMENT '协议转换配置', 
	`proto_codec_id` bigint(20) NULL COMMENT '内置协议/自定义协议id', 
	PRIMARY KEY (`id`)
) ENGINE = InnoDB AUTO_INCREMENT = 0 CHARSET = utf8 COMMENT = '协议版本';



CREATE TABLE IF NOT EXISTS `function_plugin` (
	`id` bigint(20) UNSIGNED AUTO_INCREMENT NOT NULL COMMENT '主键', 
	`instance_id` varchar(128) DEFAULT '' NOT NULL COMMENT '租户信息', 
	`function_plugin_name` varchar(128) NOT NULL COMMENT '功能插件名', 
	`function_plugin_type` tinyint(4) NOT NULL COMMENT '插件类型', 
	`description` varchar(10240) NULL COMMENT '备注', 
	`operator` varchar(64) NULL COMMENT '操作人', 
	`gmt_create` datetime NULL COMMENT '创建时间', 
	`gmt_modified` datetime NULL COMMENT '修改时间', 
	PRIMARY KEY (`id`)
) ENGINE = InnoDB AUTO_INCREMENT = 0 CHARSET = utf8 COMMENT = '功能插件';



CREATE TABLE IF NOT EXISTS `plugin_file` (
	`id` bigint(20) AUTO_INCREMENT NOT NULL, 
	`instance_id` varchar(128) DEFAULT '' NOT NULL COMMENT '租户信息', 
	`file_path` varchar(512) NULL COMMENT '文件路径', 
	`save_type` tinyint(4) NOT NULL COMMENT '存储类型：0-未知，1-db，2-external-url', 
	`function_plugin_file` longblob COMMENT '插件主体', 
	`zip_file_name` varchar(128) NOT NULL COMMENT '插件名字/协议名字', 
	PRIMARY KEY (`id`)
) ENGINE = InnoDB AUTO_INCREMENT = 0 CHARSET = utf8 COMMENT = '功能插件文件表';

CREATE TABLE IF NOT EXISTS `plugin_edition` (
	`id` bigint(20) UNSIGNED AUTO_INCREMENT NOT NULL COMMENT '主键', 
	`instance_id` varchar(128) DEFAULT '' NOT NULL COMMENT '租户信息', 
	`plugin_id` bigint(20) NULL COMMENT '功能插件id', 
	`plugin_version` varchar(128) DEFAULT '' NOT NULL COMMENT '功能插件版本号', 
	`plugin_file_id` bigint(20) UNSIGNED NOT NULL COMMENT '功能插件主体文件id', 
	`plugin_type` tinyint(4) NOT NULL COMMENT '插件类型', 
	`description` varchar(10240) NULL COMMENT '备注', 
	`operator` varchar(64) NULL COMMENT '操作人', 
	`gmt_create` datetime NULL COMMENT '创建时间', 
	`gmt_modified` datetime NULL COMMENT '修改时间', 
	`dependences` varchar(512) NULL COMMENT '插件依赖包', 
	`dependences_md5` varchar(64) NULL COMMENT '插件依赖包MD5', 
	`name` varchar(128) DEFAULT '' NOT NULL COMMENT '插件名', 
	`metadata_json` varchar(1024) NULL COMMENT 'metadatajson', 
	PRIMARY KEY (`id`)
) ENGINE = InnoDB AUTO_INCREMENT = 0 CHARSET = utf8 COMMENT = '功能插件';


CREATE TABLE `sidecar_total_plugins` (
	`id` int(11) AUTO_INCREMENT NOT NULL, 
	`instance_id` varchar(128) DEFAULT '' NOT NULL COMMENT '租户信息', 
	`file_path` varchar(512) NULL COMMENT '文件路径', 
	`save_type` varchar(512) NULL COMMENT '存储方式', 
	`function_plugin_file` longblob COMMENT '插件主体', 
	`zip_file_name` varchar(128) NULL COMMENT '插件包名称', 
	PRIMARY KEY (`id`)
) ENGINE = InnoDB AUTO_INCREMENT = 110032 CHARSET = utf8 COMMENT = 'sidecar插件集合表';


CREATE TABLE IF NOT EXISTS `protocol_inst_with_plugin_edition` (
	`id` bigint(20) UNSIGNED AUTO_INCREMENT NOT NULL COMMENT '主键', 
	`instance_id` varchar(128) DEFAULT '' NOT NULL COMMENT '租户信息', 
	`protoInst_id` bigint(20) NOT NULL COMMENT '协议插件版本id；关联协议插件版本表主键', 
	`plugin_edition_id` varchar(512) DEFAULT '' COMMENT '功能插件版本id；关联功能插件版本表id', 
	`operator` varchar(64) NULL COMMENT '操作人', 
	`gmt_create` datetime NULL COMMENT '创建时间', 
	`gmt_modified` datetime NULL COMMENT '修改时间', 
	`sort` bigint(20) NULL COMMENT '排序顺序字段', 
	PRIMARY KEY (`id`)
) ENGINE = InnoDB AUTO_INCREMENT = 0 CHARSET = utf8 COMMENT = '功能插件版本与协议插件版本多对多关联关系记录表';


CREATE TABLE `protocol_inst_with_sidecar_inject_rule` (
	`id` bigint(20) UNSIGNED AUTO_INCREMENT NOT NULL COMMENT '主键', 
	`instance_id` varchar(128) DEFAULT '' NOT NULL COMMENT '租户信息', 
	`protoInst_id` bigint(20) NOT NULL COMMENT '协议插件版本id；关联协议插件版本表主键', 
	`sidecar_inject_rule_id` varchar(512) DEFAULT '' COMMENT 'sidecar注入规则规则表id', 
	`operator` varchar(64) NULL COMMENT '操作人', 
	`gmt_create` datetime NULL COMMENT '创建时间', 
	`gmt_modified` datetime NULL COMMENT '修改时间', 
	PRIMARY KEY (`id`)
) ENGINE = InnoDB AUTO_INCREMENT = 0 CHARSET = utf8 COMMENT = '协议插件版本表与sidecar注入规则多对多关联关系记录表';



CREATE TABLE `sub_registry_infor_with_sidecar_inject_rule` (
	`id` bigint(20) UNSIGNED AUTO_INCREMENT NOT NULL COMMENT '主键', 
	`instance_id` varchar(128) DEFAULT '' NOT NULL COMMENT '租户信息', 
	`sub_registry_info_id` bigint(20) NOT NULL COMMENT '订阅中心id', 
	`sidecar_inject_rule_id` bigint(20) NOT NULL COMMENT 'sidecar注入规则规则表id', 
	`operator` varchar(64) NULL COMMENT '操作人', 
	`gmt_create` datetime NULL COMMENT '创建时间', 
	`gmt_modified` datetime NULL COMMENT '修改时间', 
	PRIMARY KEY (`id`)
) ENGINE = InnoDB AUTO_INCREMENT = 0 CHARSET = utf8 COMMENT = '订阅中心与sidecar注入规则多对多关联关系记录表';

CREATE TABLE `pub_registry_infor_with_sidecar_inject_rule` (
	`id` bigint(20) UNSIGNED AUTO_INCREMENT NOT NULL COMMENT '主键', 
	`instance_id` varchar(128) DEFAULT '' NOT NULL COMMENT '租户信息', 
	`pub_registry_info_id` bigint(20) NOT NULL COMMENT '注册中心id', 
	`sidecar_inject_rule_id` bigint(20) NOT NULL COMMENT 'sidecar注入规则规则表id', 
	`operator` varchar(64) NULL COMMENT '操作人', 
	`gmt_create` datetime NULL COMMENT '创建时间', 
	`gmt_modified` datetime NULL COMMENT '修改时间', 
	PRIMARY KEY (`id`)
) ENGINE = InnoDB AUTO_INCREMENT = 86 CHARSET = utf8 COMMENT = '注册中心与sidecar注入规则多对多关联关系记录表';


CREATE TABLE `mesh_cluster_with_sidecar_inject_rule` (
	`id` bigint(20) UNSIGNED AUTO_INCREMENT NOT NULL COMMENT '主键', 
	`instance_id` varchar(128) DEFAULT '' NOT NULL COMMENT '租户信息', 
	`cluster_name` varchar(128) NOT NULL COMMENT '集群名称', 
	`sidecar_inject_rule_id` bigint(20) NOT NULL COMMENT 'sidecar注入规则规则表id', 
	`operator` varchar(64) NULL COMMENT '操作人', 
	`gmt_create` datetime NULL COMMENT '创建时间', 
	`gmt_modified` datetime NULL COMMENT '修改时间', 
	PRIMARY KEY (`id`)
) ENGINE = InnoDB AUTO_INCREMENT = 86 CHARSET = utf8 COMMENT = '集群与sidecar注入规则多对多关联关系记录表';



CREATE TABLE `vm_details` (
	`id` bigint(11) UNSIGNED AUTO_INCREMENT NOT NULL COMMENT '自增ID', 
	`instance_id` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT '' NOT NULL COMMENT '租户信息', 
	`cluster_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT '' NOT NULL COMMENT '集群name', 
	`ip` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT 'IP地址', 
	`port` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '端口', 
	`ssh_name` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT 'ssh用户名', 
	`ssh_password` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT 'ssh密码', 
	`status` tinyint(4) UNSIGNED NULL COMMENT '开启服务网格1，未开启0', 
	`actual_ip` VARCHAR(32) NULL COMMENT '真实ip地址', 
	`gmt_create` datetime NULL, 
	`gmt_modified` datetime NULL, 
	PRIMARY KEY (`id`)
) AUTO_INCREMENT = 0 CHARACTER SET = utf8 COMMENT = 'vm详情';



ALTER TABLE sidecar_version
	DROP INDEX uk_instance_id_template_id_version,
	ADD COLUMN `iteration_type` tinyint(4) UNSIGNED DEFAULT '0' NOT NULL COMMENT '10为旧版本（迭代前版本）11为使用中版本（迭代后版本）',
	ADD COLUMN `image_address` varchar(128) DEFAULT '' COMMENT 'mosn image',
	ADD COLUMN `tar_address` varchar(128) DEFAULT '' COMMENT 'mosn tar',
	ADD COLUMN `dependencies` varchar(128) DEFAULT '' COMMENT 'sidecar 依赖',
	ADD COLUMN `dependences_md5` varchar(128) NULL COMMENT 'sidecar 依赖md5',
	MODIFY COLUMN `template_id` bigint(20) UNSIGNED NULL COMMENT '模版主键',
	MODIFY COLUMN `content` mediumtext NULL COMMENT '渲染后的内容，一般为yaml格式',
	MODIFY COLUMN `default_flag` tinyint(4) UNSIGNED DEFAULT '0' COMMENT '是否默认 0:否 1:是',
	MODIFY COLUMN `param_values` varchar(10240) NULL COMMENT '规则配置',
	MODIFY COLUMN `name` varchar(128) NULL COMMENT '版本配置名称',
	MODIFY COLUMN `sidecar_type` varchar(128) DEFAULT '' COMMENT 'sidecar类型',
	MODIFY COLUMN `sidecar_name` varchar(128) DEFAULT '' COMMENT 'sidecar名称';



ALTER TABLE sidecar_inject_rule
	ADD COLUMN `sidecar_inject_rule_config_json_string` varchar(3072) NULL COMMENT 'sidecar注入规则配置结构化json',
	ADD COLUMN `cluster_config_ids` varchar(512) NULL COMMENT '所属集群ids',
	ADD COLUMN `cluster_config_names` varchar(512) NULL COMMENT '所属集群名称',
	ADD COLUMN iteration_type tinyint(4) UNSIGNED DEFAULT '0' NOT NULL COMMENT '10为旧版本（迭代前版本），11为使用中版本（迭代后版本）',
	MODIFY COLUMN `sidecar_type` varchar(32) DEFAULT '' COMMENT '类型（容器 CONTAINERT /虚拟机 VM）';



ALTER TABLE `mesh_cluster`
	MODIFY COLUMN `extension` text NULL COMMENT '集群拓展信息（dc，zone等）';



ALTER TABLE `app_info`
	ADD COLUMN `workloads` varchar(10240) NULL COMMENT '手动添加应用的workload信息';



## 软删除
select true;



ALTER TABLE `service_pub_info`
	CHANGE COLUMN `zone` `zone` varchar(128) NULL DEFAULT '' COMMENT '服务发布时，发布内容中发布出来的 zone';



ALTER TABLE `service_sub_info`
	CHANGE COLUMN `zone` `zone` varchar(128) NULL DEFAULT '' COMMENT '服务发布时，发布内容中发布出来的 zone';



# Dump of table sidecar_dynamic_config

# ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `sidecar_dynamic_config` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `instance_id` varchar(128) NOT NULL DEFAULT '' COMMENT '租户信息',
  `app_name` varchar(50) NOT NULL COMMENT '应用名称',
  `config_key` varchar(128) NOT NULL COMMENT '配置名称',
  `config_value` text COMMENT '配置值',
  `description` varchar(250) DEFAULT NULL,
  `operator` varchar(64) DEFAULT NULL COMMENT '操作人',
  `gmt_create` datetime DEFAULT NULL COMMENT '创建时间',
  `gmt_modified` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8 COMMENT='sidecar动态配置';



CREATE TABLE IF NOT EXISTS `transcoder_config_rule` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `app_name` varchar(256) NOT NULL COMMENT '应用名称',
  `name` varchar(256) NOT NULL COMMENT '规则名称',
  `enable` tinyint(4) NOT NULL COMMENT '规则开关',
  `plugin_edition_id` bigint(20) NOT NULL COMMENT '协议转换插件Id',
  `config` text DEFAULT NULL COMMENT '协议转换配置',
  `config_md5` varchar(50) DEFAULT NULL COMMENT '协议转换配置md5值',
  `instance_id` varchar(50) NOT NULL COMMENT '租户信息',
  `operator` varchar(256) DEFAULT NULL COMMENT '操作人',
  `gmt_create` datetime NOT NULL COMMENT '修改时间',
  `gmt_modified` datetime NOT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



## 软删除
select true;



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
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;



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
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;



## 软删除
select true;



## 软删除
select true;



ALTER TABLE `sidecar_info`
	ADD COLUMN `containers` VARCHAR(1024) NULL COMMENT '容器列表';



ALTER TABLE `vm_details`
	ADD COLUMN `metadata` VARCHAR(10240) NULL COMMENT '元数据';



#license表
CREATE TABLE `licenses`(
    `id`              bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
    `instance_id`     varchar(128)   NOT NULL DEFAULT '' COMMENT '租户信息',
    `license_content` varchar(10240) NOT NULL DEFAULT '' COMMENT '规格',
    `notes`           varchar(10240)          DEFAULT NULL COMMENT '备注',
    `operator`        varchar(64)             DEFAULT NULL COMMENT '操作人',
    `gmt_create`      datetime                DEFAULT NULL COMMENT '创建时间',
    `gmt_modified`    datetime                DEFAULT NULL COMMENT '修改时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_instance_id` (`instance_id`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8 COMMENT='规格表';



## 软删除
select true;



## 软删除
select true;



#下拉框展示枚举功能用表
CREATE TABLE `enum_config` (
       `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
       `type` varchar(64) NOT NULL COMMENT '枚举类',
       `key` varchar(128) NOT NULL COMMENT '枚举项',
       `i18n` varchar(16) NOT NULL COMMENT '默认zh_CN',
       `value` varchar(128) NOT NULL COMMENT '枚举值',
       `gmt_create` datetime NOT NULL COMMENT '创建时间',
       `gmt_modified` datetime NOT NULL COMMENT '修改时间',
       PRIMARY KEY (`id`),
       UNIQUE KEY `uk_type_key` (`type`,`key`,`i18n`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='下拉框展示枚举表';



## 软删除
select true;



#角色表
CREATE TABLE `role`  (
                              `id` bigint(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '自增ID',
                              `instance_id` varchar(128) NOT NULL DEFAULT '' COMMENT '租户信息',
                              `name` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL  COMMENT '角色名',
                              `type` tinyint(4) unsigned NOT NULL DEFAULT '0' COMMENT '角色类型0 普通，1 管理，3 其他',
                              `description` varchar(225) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '描述',
                              `gmt_create` datetime NULL DEFAULT NULL,
                              `gmt_modified` datetime NULL DEFAULT NULL,
                              PRIMARY KEY (`id`)
) ENGINE = InnoDB AUTO_INCREMENT = 0 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '角色';



#分类
CREATE TABLE `category` (
                            `id` varchar(32) NOT NULL COMMENT '分类ID',
                            `instance_id` varchar(128) NOT NULL DEFAULT '' COMMENT '租户信息',
                            `name` varchar(64) NOT NULL COMMENT '分类名称',
                            `type` tinyint(4) unsigned NOT NULL DEFAULT '0' COMMENT '类型0 普通，1 管理，3 其他',
                            `description` text COMMENT '备注描述',
                            `gmt_create` datetime NULL DEFAULT NULL,
                            `gmt_modified` datetime NULL DEFAULT NULL,
                            PRIMARY KEY (`id`),
                            UNIQUE `uk_name_type` (`name`, `type`)
) ENGINE = InnoDB CHARSET = utf8 COMMENT '分类';



## 软删除
select true;



## 软删除
select true;



#功能表
CREATE TABLE `action` (
                          `id` varchar(32) NOT NULL COMMENT '功能ID',
                          `instance_id` varchar(128) NOT NULL DEFAULT '' COMMENT '租户信息',
                          `name` varchar(64) NOT NULL COMMENT '操作点名称',
                          `alias` varchar(64) NOT NULL COMMENT '操作点显示名',
                          `status` varchar(64) NOT NULL COMMENT '状态',
                          `type` tinyint(4) unsigned NOT NULL DEFAULT '0' COMMENT '类型0 普通，1 数据类型权限',
                          `category_id` varchar(32) NOT NULL COMMENT '分类ID',
                          `description` text COMMENT '备注描述',
                          `gmt_create` datetime NULL DEFAULT NULL,
                          `gmt_modified` datetime NULL DEFAULT NULL,
                          PRIMARY KEY (`id`),
                          UNIQUE `uk_name` (`name`)
) ENGINE = InnoDB CHARSET = utf8 COMMENT '操作点';



#角色应用关联表
CREATE TABLE `role_app_merge`  (
                           `id` bigint(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '自增ID',
                           `role_id` bigint(20) NOT NULL COMMENT '角色id',
                           `instance_id` varchar(128) NOT NULL DEFAULT '' COMMENT '租户信息',
                           `app_name` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL  COMMENT '应用名',
                           `type` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL  COMMENT '权限类型',
                           `gmt_create` datetime NULL DEFAULT NULL,
                           `gmt_modified` datetime NULL DEFAULT NULL,
                           PRIMARY KEY (`id`)
) ENGINE = InnoDB AUTO_INCREMENT = 0 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '角色应用关联表';



#角色用户关联表
CREATE TABLE `user_role_merge`  (
                                   `id` bigint(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '自增ID',
                                   `instance_id` varchar(128) NOT NULL DEFAULT '' COMMENT '租户信息',
                                   `role_id` bigint(20) NOT NULL COMMENT '角色id',
                                   `user_id` bigint(20) NOT NULL COMMENT '用户id',
                                   `role_name` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL  COMMENT '角色名',
                                   `type` tinyint(4) unsigned NOT NULL DEFAULT '0' COMMENT '角色类型0 普通，1 管理，3 其他',
                                   `gmt_create` datetime NULL DEFAULT NULL,
                                   `gmt_modified` datetime NULL DEFAULT NULL,
                                   PRIMARY KEY (`id`)
) ENGINE = InnoDB AUTO_INCREMENT = 0 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '角色用户关联表';



#角色用功能联表
CREATE TABLE `role_action_merge`  (
                                    `id` bigint(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '自增ID',
                                    `instance_id` varchar(128) NOT NULL DEFAULT '' COMMENT '租户信息',
                                    `role_id` bigint(20) NOT NULL COMMENT '角色id',
                                    `action_id` varchar(32) NOT NULL COMMENT '功能ID',
                                    `gmt_create` datetime NULL DEFAULT NULL,
                                    `gmt_modified` datetime NULL DEFAULT NULL,
                                    PRIMARY KEY (`id`)
) ENGINE = InnoDB AUTO_INCREMENT = 0 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '角色功能关联表';



## 软删除
select true;



INSERT INTO enum_config (type,`key`,i18n,value,gmt_create,gmt_modified) VALUES ('microserviceType','dubbo','zh_CN','Dubbo',now(),now()), 
  ('microserviceType','sofa','zh_CN','Sofa',now(),now()),
  ('microserviceType','springcloud','zh_CN','SpringCloud',now(),now()),
  ('headerMappingKey','x-mosn-data-id','zh_CN','x-mosn-data-id',now(),now()),
  ('headerMappingKey','x-mosn-trace-id','zh_CN','x-mosn-trace-id',now(),now()),
  ('headerMappingKey','x-mosn-span-id','zh_CN','x-mosn-span-id',now(),now()),
  ('headerMappingKey','x-mosn-method','zh_CN','x-mosn-method',now(),now()),
  ('headerMappingKey','x-mosn-traffic-type','zh_CN','x-mosn-traffic-type',now(),now()),
  ('headerMappingKey','x-mosn-caller-app','zh_CN','x-mosn-caller-app',now(),now()),
  ('headerMappingKey','x-mosn-target-app','zh_CN','x-mosn-target-app',now(),now()),
  ('mosnRegistryPort','zookeeper','zh_CN','12181',now(),now()), 
  ('mosnRegistryPort','eureka','zh_CN','18088',now(),now()), 
  ('mosnRegistryPort','nacos','zh_CN','18848',now(),now()), 
  ('mosnRegistryPort','consul','zh_CN','18500',now(),now()),
  ('webShellCmdWhiteList','openTamperproofingMock','zh_CN','curl -v -XPOST -d "modifyLastByte" 127.0.0.1:34901/api/v1/tamperproofing_setting\?mock=true',now(),now()), 
  ('webShellCmdWhiteList','closeTamperproofingMock','zh_CN','curl -v -XDELETE 127.0.0.1:34901/api/v1/tamperproofing_setting\?mock=false',now(),now());



#用户表
CREATE TABLE `account_info`  (
                               `id` bigint(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '自增ID',
                               `instance_id` varchar(128) NOT NULL DEFAULT '' COMMENT '租户信息',
                               `user_name` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL  COMMENT '用户名',
                               `user_nick` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '别名',
                               `password` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '密码',
                               `token` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '',
                               `type` varchar(32) NOT NULL COMMENT '用户类型',
                               `login_time` datetime NULL DEFAULT NULL COMMENT '登陆时间',
                               `gmt_create` datetime NULL DEFAULT NULL,
                               `gmt_modified` datetime NULL DEFAULT NULL,
                               PRIMARY KEY (`id`)
) ENGINE = InnoDB AUTO_INCREMENT = 0 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '用户详情';



## 软删除
select true;



## 软删除
select true;



INSERT INTO dsrconsole.role (id,instance_id,name,`type`,description,gmt_create,gmt_modified) VALUES
(1,'000001','管理员',1,'管理员可以对应用、服务组件进行购买、删除、更新等配置管理操作',NOW(),NOW()),
(2,'000001','开发者',1,'开发者不能对用户授权操作',NOW(),NOW()),
(3,'000001','观察者',1,'观察者只有查询权限',NOW(),NOW());



INSERT INTO dsrconsole.account_info (id,instance_id,user_name,user_nick,password,token,`type`,login_time,gmt_create,gmt_modified) VALUES
(1,'000001','admin','admin','$apr1$4S9$Y7mwO0VXgjUhS47TRD/iR.',NULL,'ss',NULL,NOW(),NOW());



INSERT INTO dsrconsole.user_role_merge (instance_id,role_id,user_id,role_name,`type`,gmt_create,gmt_modified) VALUES
('000001',1,1,'管理员',0,NOW(),NOW()),
('001001',1,1,'管理员',0,NOW(),NOW()),
('002001',1,1,'管理员',0,NOW(),NOW());



INSERT INTO `category` (`id`, instance_id, `name`, `type`, `description`, `gmt_create`, `gmt_modified`)
VALUES
("MS00001", '000001','服务网格-集群管理', 0, 'MS相关产品权限', NOW(), NOW()),
("MS00002", '000001','服务网格-服务目录', 0, 'MS相关产品权限', NOW(), NOW()),
("MS00003", '000001','服务网格-服务治理', 0, 'MS相关产品权限', NOW(), NOW()),
("MS00004", '000001','服务网格-sidecar注入规则', 0, 'MS相关产品权限', NOW(), NOW()),
("MS00005", '000001','服务网格-sidecar版本管理', 0, 'MS相关产品权限', NOW(), NOW()),
("MS00006", '000001','服务网格-安全管理', 0, 'MS相关产品权限', NOW(), NOW()),
("MS00007", '000001','服务网格-协议插件', 0, 'MS相关产品权限', NOW(), NOW()),
("MS00008", '000001','服务网格-功能插件', 0, 'MS相关产品权限', NOW(), NOW()),
("MS00009", '000001','服务网格-多注册中心', 0, 'MS相关产品权限', NOW(), NOW()),
("MS00010", '000001','服务网格-动态配置', 0, 'MS相关产品权限', NOW(), NOW()),
("MS00011", '000001','服务网格-审计目录', 0, 'MS相关产品权限', NOW(), NOW()),
("MS00012", '000001','服务网格-元数据', 0, 'MS相关产品权限', NOW(), NOW()),
("MS00013", '000001','服务网格-账号管理', 0, 'MS相关产品权限', NOW(), NOW()),
("MS00014", '000001','服务网格-角色管理', 0, 'MS相关产品权限', NOW(), NOW()),
("MS00015", '000001','服务网格-协议转换配置', 0, 'MS相关产品权限', NOW(), NOW()),
("MS00016", '000001','服务网格-sidecar动态配置', 0, 'MS相关产品权限', NOW(), NOW());



INSERT INTO `action` (`id`, `instance_id`,`name`, `alias`, `status`, `type`,  `category_id`,  `description`,  `gmt_create`, `gmt_modified`)
VALUES
('MD00001','000001','sofa.ms.middleware.instance.get', '元数据-查询instanceId', 'SELECT', 0, 'MS00012', '查询instanceId',  NOW(), NOW()),
('MD00002','000001','sofa.ms.sg.envconfig.get', '元数据-获取环境配置', 'SELECT', 0, 'MS00012', '获取环境配置', NOW(), NOW()),
('MD00003','000001','sofa.ms.undisplay.components.list', '元数据-未展开组件列表', 'SELECT', 0, 'MS00012', '未展开组件列表', NOW(), NOW()),
('MD00004','000001','sofa.ms.sg.formconfig.query', '元数据-身份验证规则配置', 'SELECT', 0, 'MS00012',  '身份验证规则配置', NOW(), NOW()),
('MD00005','000001','sofa.ms.sg.apps.list', '元数据-查询应用列表', 'SELECT', 1, 'MS00012',  '查询应用列表',  NOW(), NOW()),
('CS00001','000001', 'sofa.ms.sg.meshcluster.list', '集群管理-查询集群列表', 'SELECT', 0, 'MS00001',  '集群查询权限',  NOW(), NOW()),
('CS00002','000001', 'sofa.ms.sg.meshclusterenable.list', '集群管理-查询开通集群列表', 'SELECT', 0, 'MS00001',  '集群查询权限',  NOW(), NOW()),
('CS00003','000001', 'sofa.ms.sg.meshcluster.get', '集群管理-查询集群详情', 'SELECT', 0, 'MS00001',  '集群查询权限',  NOW(), NOW()),
('CS00004', '000001','sofa.ms.sg.meshcluster.add', '集群管理-添加集群', 'ADD', 0,  'MS00001',  '集群add权限',  NOW(), NOW()),
('CS00005', '000001','sofa.ms.sg.meshcluster.update', '集群管理-更新集群', 'UPDATE', 0,  'MS00001',  '集群add权限',  NOW(), NOW()),
('CS00006', '000001','sofa.ms.sg.meshclusterstatus.update', '集群管理-开通集群', 'UPDATE', 0,  'MS00001',  '集群开通权限',   NOW(), NOW()),
('CS00007','000001', 'sofa.ms.sg.meshcluster.delete', '集群管理-删除集群', 'DELETE', 0,  'MS00001',  '集群delete权限',   NOW(), NOW()),
('CS00008','000001', 'sofa.ms.sg.meshclusternamespace.delete', '集群管理-删除集群namespace', 'DELETE', 0,  'MS00001',  '集群delete权限',   NOW(), NOW()),
('CS00009','000001', 'sofa.ms.sg.meshclusternamespacestatus.update', '集群管理-修改集群namespace状态', 'DELETE', 0,  'MS00001',  '修改集群namespace状态',   NOW(), NOW()),
('CS00010','000001', 'sofa.ms.sg.meshacvipaddress.get', '集群管理-获取acvip地址', 'SELECT', 0,  'MS00001',  '获取acvip地址',   NOW(), NOW()),
('SC00001','000001', 'sofa.ms.sg.service.list', '服务目录-查询服务列表', 'SELECT', 0, 'MS00002',  '查询服务权限',  NOW(), NOW()),
('SC00002','000001', 'sofa.ms.sg.app.list', '服务目录-查询应用列表', 'SELECT', 1, 'MS00002',  '查询应用权限',  NOW(), NOW()),
('SC00003','000001', 'sofa.ms.sg.serviceapps.list', '服务目录-查询应用名称列表', 'SELECT', 1, 'MS00002',  '查询应用权限',  NOW(), NOW()),
('SC00004', '000001','sofa.ms.sg.sidecar.list', '服务目录-查询sidecar列表', 'SELECT', 0,  'MS00002',  '查询应用权限',  NOW(), NOW()),
('SC00005', '000001','sofa.ms.sg.sidecar.operate', '服务目录-重启sidecar', 'UPDATE', 0,  'MS00002',  '服务目录修改权限',  NOW(), NOW()),
('SC00006', '000001','sofa.ms.sg.sidecartemplate.match', '服务目录-注入sidecar', 'UPDATE', 0,  'MS00002',  '服务目录修改权限',   NOW(), NOW()),
('SC00007','000001', 'sofa.ms.sg.servicepubsub.list', '服务目录-服务提供者列表', 'SELECT', 0,  'MS00002',  '服务目录查询权限',   NOW(), NOW()),
('SC00009','000001', 'sofa.ms.sg.governrulecount.get', '服务目录-统计服务治理规则', 'SELECT', 0,  'MS00002',  '服务目录查询权限',   NOW(), NOW()),
('SC00010','000001', 'sofa.ms.sg.governrule.list', '服务目录-查询服务治理列表', 'SELECT', 0,  'MS00002',  '服务目录查询权限',   NOW(), NOW()),
('SC00011','000001', 'sofa.ms.sg.app.update', '服务目录-编辑应用', 'UPDATE', 1,  'MS00002',  '服务目录编辑权限',   NOW(), NOW()),
('SC00012','000001', 'sofa.ms.sg.app.delete', '服务目录-删除应用', 'DELETE', 1,  'MS00002',  '服务目录删除权限',   NOW(), NOW()),
('SC00013','000001', 'sofa.ms.sg.services.query', '服务目录-查询服务', 'SELECT', 1,  'MS00002',  '服务目录删除权限',   NOW(), NOW()),
('SC00014','000001', 'sofa.ms.sg.appworkloads.match', '服务目录-应用工作负载匹配', 'SELECT', 1,  'MS00002',  '应用工作负载匹配',   NOW(), NOW()),
('SG00002','000001', 'sofa.ms.sg.serviceratelimitrules.list', '服务治理-查询限流列表', 'SELECT', 1, 'MS00003',  '查询应用权限',  NOW(), NOW()),
('SG00003','000001', 'sofa.ms.sg.servicesubrelations.query', '服务治理-根据应用查询服务提供者', 'SELECT', 0, 'MS00003',  '查询应用权限',  NOW(), NOW()),
('SG00004', '000001','sofa.ms.sg.serviceratelimitrules.add', '服务治理-新增限流规则', 'ADD', 1,  'MS00003',  '新增限流规则',  NOW(), NOW()),
('SG00005', '000001','sofa.ms.sg.serviceratelimitrules.update', '服务治理-更新限流规则', 'UPDATE', 1,  'MS00003',  '更新限流规则',  NOW(), NOW()),
('SG00006', '000001','sofa.ms.sg.serviceratelimitrules.delete', '服务治理-删除限流规则', 'DELETE', 1,  'MS00003',  '删除限流规则',   NOW(), NOW()),
('SG00007', '000001','sofa.ms.sg.serviceratelimitrulestatus.update', '服务治理-开关限流规则', 'UPDATE', 1,  'MS00003',  '开关限流规则',   NOW(), NOW()),
('SG00008','000001', 'sofa.ms.sg.routerruleallapps.list', '服务治理-查询路由应用列表', 'SELECT', 1,  'MS00003',  '查询应用',   NOW(), NOW()),
('SG00009','000001', 'sofa.ms.sg.routerruleallservices.list', '服务治理-查询路由服务列表', 'SELECT', 0,  'MS00003',  '查询应用',   NOW(), NOW()),
('SG00010','000001', 'sofa.ms.sg.routerrulegroupapps.list', '服务治理-查询路由规则应用列表', 'SELECT', 1,  'MS00003',  '查询应用',   NOW(), NOW()),
('SG00011','000001', 'sofa.ms.sg.routerrulegroups.list', '服务治理-查询应用路由列表', 'SELECT', 0,  'MS00003',  '查询路由',   NOW(), NOW()),
('SG00012','000001', 'sofa.ms.sg.servicepubrelations.query', '服务治理-根据应用查询服务消费者', 'SELECT', 0,  'MS00003',  '查询服务',   NOW(), NOW()),
('SG00013','000001', 'sofa.ms.sg.routerrulegroups.add', '服务治理-新增路由规则', 'ADD', 1,  'MS00003',  '新增路由规则',   NOW(), NOW()),
('SG00014','000001', 'sofa.ms.sg.routerrulegroups.update', '服务治理-编辑路由规则', 'UPDATE', 1,  'MS00003',  '编辑路由规则',   NOW(), NOW()),
('SG00015','000001', 'sofa.ms.sg.routerrulegroupstatus.update', '服务治理-开关路由规则', 'UPDATE', 1,  'MS00003',  '开关路由规则',   NOW(), NOW()),
('SG00016','000001', 'sofa.ms.sg.routerrulegroup.delete', '服务治理-删除路由规则', 'DELETE', 1,  'MS00003',  '删除路由规则',   NOW(), NOW()),
('SG00017','000001', 'sofa.ms.sg.circuitbreakerrules.all', '服务治理-查询熔断应用列表', 'SELECT', 1,  'MS00003',  '查询熔断应用',   NOW(), NOW()),
('SG00018','000001', 'sofa.ms.sg.circuitbreakerrules.get', '服务治理-查询熔断规则', 'SELECT', 0,  'MS00003',  '查询熔断规则',   NOW(), NOW()),
('SG00019','000001', 'sofa.ms.sg.circuitbreakerrules.add', '服务治理-新增熔断规则', 'ADD', 1,  'MS00003',  '新增熔断规则',   NOW(), NOW()),
('SG00020','000001', 'sofa.ms.sg.circuitbreakerrules.update', '服务治理-编辑熔断规则', 'UPDATE', 1,  'MS00003',  '编辑熔断规则',   NOW(), NOW()),
('SG00021','000001', 'sofa.ms.sg.circuitbreakerrules.enable', '服务治理-熔断开关', 'UPDATE', 1,  'MS00003',  '熔断开关',   NOW(), NOW()),
('SG00022','000001', 'sofa.ms.sg.circuitbreakerrules.delete', '服务治理-删除熔断规则', 'DELETE', 1,  'MS00003',  '删除熔断规则',   NOW(), NOW()),
('SG00023','000001', 'sofa.ms.sg.downgradegroups.query', '服务治理-查询降级规则', 'SELECT', 1,  'MS00003',  '查询降级规则',   NOW(), NOW()),
('SG00024','000001', 'sofa.ms.sg.downgrades.add', '服务治理-新增降级规则', 'ADD', 1,  'MS00003',  '新增降级规则',   NOW(), NOW()),
('SG00025','000001', 'sofa.ms.sg.downgrades.update', '服务治理-编辑降级规则', 'UPDATE', 1,  'MS00003',  '编辑降级规则',   NOW(), NOW()),
('SG00026','000001', 'sofa.ms.sg.downgrades.disable', '服务治理-关闭降级规则', 'UPDATE', 1,  'MS00003',  '关闭降级规则',   NOW(), NOW()),
('SG00027','000001', 'sofa.ms.sg.downgrades.enable', '服务治理-开启降级规则', 'UPDATE', 1,  'MS00003',  '开启降级规则',   NOW(), NOW()),
('SG00028','000001', 'sofa.ms.sg.downgrades.delete', '服务治理-删除降级规则', 'DELETE', 1,  'MS00003',  '删除降级规则',   NOW(), NOW()),
('SG00029','000001', 'sofa.ms.sg.faultinjectallapps.list', '服务治理-查询故障注入应用', 'SELECT', 1,  'MS00003',  '查询故障注入应用',   NOW(), NOW()),
('SG00030','000001', 'sofa.ms.sg.faultinjectallservices.list', '服务治理-查询故障注入服务', 'SELECT', 0,  'MS00003',  '查询故障注入服务',   NOW(), NOW()),
('SG00031','000001', 'sofa.ms.sg.faultinjectapps.list', '服务治理-统计应用故障注入数', 'SELECT', 1,  'MS00003',  '统计应用故障注入数',   NOW(), NOW()),
('SG00032','000001', 'sofa.ms.sg.faultinjectrules.list', '服务治理-根据应用查询故障注入规则', 'SELECT', 0,  'MS00003',  '根据应用查询故障注入规则',   NOW(), NOW()),
('SG00033','000001', 'sofa.ms.sg.faultinjectrule.add', '服务治理-新增故障注入规则', 'ADD', 1,  'MS00003',  '新增故障注入规则',   NOW(), NOW()),
('SG00034','000001', 'sofa.ms.sg.faultinjectrule.update', '服务治理-编辑故障注入规则', 'UPDATE', 1,  'MS00003',  '编辑故障注入规则',   NOW(), NOW()),
('SG00035','000001', 'sofa.ms.sg.faultinjectrulestatus.update', '服务治理-开关故障注入规则', 'UPDATE', 1,  'MS00003',  '开关故障注入规则',   NOW(), NOW()),
('SG00036','000001', 'sofa.ms.sg.faultinjectrule.delete', '服务治理-删除故障注入规则', 'DELETE', 1,  'MS00003',  '删除故障注入规则',   NOW(), NOW()),
('SG00037','000001', 'sofa.ms.sg.faulttoleranceapps.list', '服务治理-查询故障隔离应用', 'SELECT', 1,  'MS00003',  '查询故障隔离应用',   NOW(), NOW()),
('SG00038','000001', 'sofa.ms.sg.faulttolerancerules.list', '服务治理-根据应用查询故障隔离规则', 'SELECT', 0,  'MS00003',  '根据应用查询故障隔离规则',   NOW(), NOW()),
('SG00039','000001', 'sofa.ms.sg.faulttolerancerule.add', '服务治理-新增故障隔离规则', 'ADD', 1,  'MS00003',  '新增故障隔离规则',   NOW(), NOW()),
('SG00040','000001', 'sofa.ms.sg.faulttolerancerule.update', '服务治理-更新故障隔离规则', 'UPDATE', 1,  'MS00003',  '更新故障隔离规则',   NOW(), NOW()),
('SG00041','000001', 'sofa.ms.sg.faulttolerancerule.enable', '服务治理-开关故障隔离规则', 'UPDATE', 1,  'MS00003',  '开关故障隔离规则',   NOW(), NOW()),
('SG00042','000001', 'sofa.ms.sg.faulttolerancerule.delete', '服务治理-删除故障隔离规则', 'DELETE', 1,  'MS00003',  '删除故障隔离规则',   NOW(), NOW()),
('SG00043','000001', 'sofa.ms.sg.trafficmirrorallapps.list', '服务治理-查询流量镜像应用', 'SELECT', 1,  'MS00003',  '查询流量镜像应用',   NOW(), NOW()),
('SG00044','000001', 'sofa.ms.sg.trafficmirrorapps.list', '服务治理-统计流量镜像应用规则数', 'SELECT', 1,  'MS00003',  '统计流量镜像应用规则数',   NOW(), NOW()),
('SG00045','000001', 'sofa.ms.sg.trafficmirrorservices.list', '服务治理-查询流量镜像服务', 'SELECT', 0,  'MS00003',  '查询流量镜像服务',   NOW(), NOW()),
('SG00046','000001', 'sofa.ms.sg.trafficmirrorrules.list', '服务治理-根据应用查询流量镜像规则', 'SELECT', 0,  'MS00003',  '根据应用查询流量镜像规则',   NOW(), NOW()),
('SG00047','000001', 'sofa.ms.sg.trafficmirrorrule.add', '服务治理-新增流量镜像规则', 'ADD', 1,  'MS00003',  '新增流量镜像规则',   NOW(), NOW()),
('SG00048','000001', 'sofa.ms.sg.trafficmirrorrule.update', '服务治理-更新流量镜像规则', 'UPDATE', 1,  'MS00003',  '更新流量镜像规则',   NOW(), NOW()),
('SG00049','000001', 'sofa.ms.sg.trafficmirrorrulestatus.update', '服务治理-开关流量镜像规则', 'UPDATE', 1,  'MS00003',  '开关流量镜像规则',   NOW(), NOW()),
('SG00050','000001', 'sofa.ms.sg.trafficmirrorrule.delete', '服务治理-删除流量镜像规则', 'DELETE', 1,  'MS00003',  '删除流量镜像规则',   NOW(), NOW()),
('SG00051','000001', 'sofa.ms.sg.routerrulegroup.export', '服务治理-导出规则', 'SELECT', 0,  'MS00003',  '导出规则',   NOW(), NOW()),
('SG00052','000001', 'sofa.ms.sg.routerrulegroup.import', '服务治理-导入规则', 'UPDATE', 0,  'MS00003',  '删除流量镜像规则',   NOW(), NOW()),
('SG00053','000001', 'sofa.ms.sg.routerruleversions.list', '服务治理-查询路由版本', 'SELECT', 0,  'MS00003',  '查询路由版本',   NOW(), NOW()),
('SI00001','000001', 'sofa.ms.sg.registry.all', 'sidecar注入规则-查询注册中心列表', 'SELECT', 0, 'MS00004',  '查询注册中心列表',  NOW(), NOW()),
('SI00002','000001', 'sofa.ms.sg.sidecarinjectrules.list', 'sidecar注入规则-查询注入规则列表', 'SELECT', 0, 'MS00004',  '查询注入规则列表',  NOW(), NOW()),
('SI00003','000001', 'sofa.ms.sg.sidecarversionsdropdown.list', 'sidecar注入规则-查询sidecar版本', 'SELECT', 0, 'MS00004',  '查询sidecar版本',  NOW(), NOW()),
('SI00004', '000001','sofa.ms.sg.protocoldropdown.list', 'sidecar注入规则-查询协议列表', 'SELECT', 0,  'MS00004',  '查询协议列表',  NOW(), NOW()),
('SI00005', '000001','sofa.ms.sg.sidecarinjectrule.add', 'sidecar注入规则-新增注入规则', 'ADD', 0,  'MS00004',  '新增注入规则',  NOW(), NOW()),
('SI00006', '000001','sofa.ms.sg.sidecarinjectrule.update', 'sidecar注入规则-更新注入规则', 'UPDATE', 0,  'MS00004',  '更新注入规则',   NOW(), NOW()),
('SI00007','000001', 'sofa.ms.sg.sidecarinjectrulestatus.update', 'sidecar注入规则-开关注入规则', 'UPDATE', 0,  'MS00004',  '开关注入规则',   NOW(), NOW()),
('SI00008','000001', 'sofa.ms.sg.sidecarinjectrule.delete', 'sidecar注入规则-删除注入规则', 'DELETE', 0,  'MS00004',  '删除注入规则',   NOW(), NOW()),
('SV00001','000001', 'sofa.ms.sg.sidecarversions.list', 'sidecar版本管理-查询sidecar版本', 'SELECT', 0, 'MS00005',  '查询sidecar版本',  NOW(), NOW()),
('SV00002','000001', 'sofa.ms.sg.sidecarversion.add', 'sidecar版本管理-新增sidecar版本', 'ADD', 0, 'MS00005',  '新增sidecar版本',  NOW(), NOW()),
('SV00003','000001', 'sofa.ms.sg.sidecarversion.update', 'sidecar版本管理-编辑sidecar版本', 'UPDATE', 0, 'MS00005',  '编辑sidecar版本',  NOW(), NOW()),
('SV00004', '000001','sofa.ms.sg.sidecarversion.delete', 'sidecar版本管理-删除sidecar版本', 'DELETE', 0,  'MS00005',  '删除sidecar版本',  NOW(), NOW()),
('SY00002','000001', 'sofa.ms.safe.communicationrules.list', '安全管理-查询通信加密列表', 'SELECT', 0, 'MS00006',  '查询通信加密列表',  NOW(), NOW()),
('SY00003','000001', 'sofa.ms.safe.communicationrule.get', '安全管理-查询通信加密详情', 'SELECT', 0, 'MS00006',  '查询通信加密列表',  NOW(), NOW()),
('SY00004','000001', 'sofa.ms.safe.communicationrule.add', '安全管理-新增通信加密规则', 'ADD', 0, 'MS00006',  '新增通信加密规则',  NOW(), NOW()),
('SY00005', '000001','sofa.ms.safe.communicationrule.update', '安全管理-更新通信加密规则', 'UPDATE', 0,  'MS00006',  '更新通信加密规则',  NOW(), NOW()),
('SY00006', '000001','sofa.ms.safe.communicationrule.enable', '安全管理-开关通信加密规则', 'UPDATE', 0,  'MS00006',  '开关通信加密规则',   NOW(), NOW()),
('SY00007','000001', 'sofa.ms.safe.communicationrule.delete', '安全管理-删除通信加密规则', 'DELETE', 0,  'MS00006',  '服务目录查询权限',   NOW(), NOW()),
('SY00008','000001', 'sofa.ms.sg.signruleexistservices.list', '安全管理-查询防篡改服务', 'SELECT', 0,  'MS00006',  '查询防篡改服务',   NOW(), NOW()),
('SY00009','000001', 'sofa.ms.sg.signruleexistapps.list', '安全管理-查询防篡改应用', 'SELECT', 1,  'MS00006',  '查询防篡改应用',   NOW(), NOW()),
('SY00010','000001', 'sofa.ms.sg.signruleapps.list', '安全管理-统计防篡改应用', 'SELECT', 1,  'MS00006',  '统计防篡改应用',   NOW(), NOW()),
('SY00011','000001', 'sofa.ms.sg.signrules.list', '安全管理-根据应用查询防篡改规则', 'SELECT', 0,  'MS00006',  '根据应用查询防篡改规则',   NOW(), NOW()),
('SY00012','000001', 'sofa.ms.sg.signaturerrule.add', '安全管理-新增防篡改规则', 'ADD', 1,  'MS00006',  '新增防篡改规则',   NOW(), NOW()),
('SY00013','000001', 'sofa.ms.sg.signaturerrule.update', '安全管理-更新防篡改规则', 'UPDATE', 1,  'MS00006',  '更新防篡改规则',   NOW(), NOW()),
('SY00014','000001', 'sofa.ms.sg.signaturerrulestatus.update', '安全管理-开关防篡改规则', 'UPDATE', 1,  'MS00006',  '开关防篡改规则(缺少appName)',   NOW(), NOW()),
('SY00015','000001', 'sofa.ms.sg.signaturerrule.delete', '安全管理-删除防篡改规则', 'DELETE', 1,  'MS00006',  '删除防篡改规则(缺少appName)',   NOW(), NOW()),
('SY00016','000001', 'sofa.ms.sg.authrulegroupservices.list', '安全管理-查询鉴权服务', 'SELECT', 1,  'MS00006',  '查询防篡改服务',   NOW(), NOW()),
('SY00017','000001', 'sofa.ms.sg.authrulegroupapps.list', '安全管理-查询鉴权规则', 'SELECT', 1,  'MS00006',  '查询鉴权规则',   NOW(), NOW()),
('SY00018','000001', 'sofa.ms.sg.authruledataids.list', '安全管理-查询鉴权dataIds', 'SELECT', 0,  'MS00006',  '查询鉴权dataIds',   NOW(), NOW()),
('SY00019','000001', 'sofa.ms.sg.authruleappnames.list', '安全管理-查询鉴权应用', 'SELECT', 1,  'MS00006',  '查询鉴权应用',   NOW(), NOW()),
('SY00020','000001', 'sofa.ms.sg.authrulegroupsbatch.add', '安全管理-新增鉴权规则组', 'ADD', 1,  'MS00006',  '新增鉴权规则组',   NOW(), NOW()),
('SY00021','000001', 'sofa.ms.sg.authrules.add', '安全管理-新增鉴权规则', 'ADD', 1,  'MS00006',  '新增鉴权规则',   NOW(), NOW()),
('SY00022','000001', 'sofa.ms.sg.listauthrules.update', '安全管理-更新鉴权规则', 'UPDATE', 1,  'MS00006',  '更新鉴权规则',   NOW(), NOW()),
('SY00023','000001', 'sofa.ms.sg.authrulegroups.enable', '安全管理-开启鉴权规则组', 'UPDATE', 1,  'MS00006',  '开启鉴权规则组(缺少appName)', NOW(), NOW()),
('SY00024','000001', 'sofa.ms.sg.authrulegroups.disable', '安全管理-关闭鉴权规则组', 'UPDATE', 1,  'MS00006',  '关闭鉴权规则组(缺少appName)', NOW(), NOW()),
('SY00025','000001', 'sofa.ms.sg.authrules.enable', '安全管理-开启鉴权规则', 'UPDATE', 1,  'MS00006',  '开启鉴权规则(缺少appName)', NOW(), NOW()),
('SY00026','000001', 'sofa.ms.sg.authrules.disable', '安全管理-关闭鉴权规则', 'UPDATE', 1,  'MS00006',  '关闭鉴权规则(缺少appName)', NOW(), NOW()),
('SY00027','000001', 'sofa.ms.sg.authrules.delete', '安全管理-删除鉴权规则', 'DELETE', 1,  'MS00006',  '关闭鉴权规则组(缺少appName)', NOW(), NOW()),
('PP00001','000001', 'sofa.ms.sg.protocolname.list', '协议插件-查询协议列表', 'SELECT', 0, 'MS00007',  '查询协议列表',  NOW(), NOW()),
('PP00002','000001', 'sofa.ms.sg.protocol.list', '协议插件-查询协议插件列表', 'SELECT', 0, 'MS00007',  '查询协议插件列表',  NOW(), NOW()),
('PP00003','000001', 'sofa.ms.sg.protocolinst.list', '协议插件-查询协议插件inst列表', 'SELECT', 0, 'MS00007',  '集群查询权限',  NOW(), NOW()),
('PP00004', '000001','sofa.ms.sg.functionpluginedition.all', '协议插件-查询功能插件列表', 'SELECT', 0,  'MS00007',  '查询功能插件列表',  NOW(), NOW()),
('PP00006', '000001','sofa.ms.sg.functionplugineditiondropdown.list', '协议插件-查询协议版本列表', 'SELECT', 0,  'MS00007',  '集群开通权限',   NOW(), NOW()),
('PP00005', '000001','sofa.ms.sg.protocol.add', '协议插件-新增协议插件', 'ADD', 0,  'MS00007',  '新增协议插件',  NOW(), NOW()),
('PP00007','000001', 'sofa.ms.sg.protocolinstfile.add', '协议插件-新增协议插件版本', 'ADD', 0,  'MS00007',  '新增协议插件版本',   NOW(), NOW()),
('PP00008','000001', 'sofa.ms.sg.protocol.update', '协议插件-编辑协议插件', 'UPDATE', 0,  'MS00007',  '编辑协议插件',   NOW(), NOW()),
('PP00009','000001', 'sofa.ms.sg.protocolinst.update', '协议插件-编辑协议插件版本', 'UPDATE', 0,  'MS00007',  '编辑协议插件版本',   NOW(), NOW()),
('PP00010','000001', 'sofa.ms.sg.protocolinst.delete', '协议插件-删除协议插件版本', 'DELETE', 0,  'MS00007',  '删除协议插件版本',   NOW(), NOW()),
('PP00011','000001', 'sofa.ms.sg.protocol.delete', '协议插件-删除协议插件', 'DELETE', 0,  'MS00007',  '删除协议插件',   NOW(), NOW()),
('PP00012','000001', 'sofa.ms.sg.protocolinst.upload', '协议插件-上传协议文件', 'ADD', 0,  'MS00007',  '上传协议文件',   NOW(), NOW()),
('FP00001','000001', 'sofa.ms.sg.functionplugin.list', '功能插件-查询功能插件列表', 'SELECT', 0, 'MS00008',  '查询功能插件列表',  NOW(), NOW()),
('FP00002','000001', 'sofa.ms.sg.functionpluginedition.list', '功能插件-查询功能插件版本', 'SELECT', 0, 'MS00008',  '查询功能插件版本',  NOW(), NOW()),
('FP00003','000001', 'sofa.ms.sg.functionplugin.add', '功能插件-新增功能插件', 'ADD', 0, 'MS00008',  '新增功能插件',  NOW(), NOW()),
('FP00004', '000001','sofa.ms.sg.functionpluginedition.add', '功能插件-新增功能插件版本', 'ADD', 0,  'MS00008',  '查询功能插件列表',  NOW(), NOW()),
('FP00006', '000001','sofa.ms.sg.functionplugin.update', '功能插件-编辑功能插件', 'UPDATE', 0,  'MS00008',  '编辑功能插件',   NOW(), NOW()),
('FP00005', '000001','sofa.ms.sg.functionpluginedition.update', '功能插件-编辑功能插件版本', 'ADD', 0,  'MS00008',  '编辑功能插件版本',  NOW(), NOW()),
('FP00007','000001', 'sofa.ms.sg.functionpluginedition.delete', '功能插件-删除功能插件版本', 'DELETE', 0,  'MS00008',  '删除功能插件版本',   NOW(), NOW()),
('FP00008','000001', 'sofa.ms.sg.functionplugin.delete', '功能插件-删除功能插件', 'DELETE', 0,  'MS00008',  '删除功能插件',   NOW(), NOW()),
('MR00001','000001', 'sofa.ms.sg.registry.list', '多注册中心-查询注册中心列表', 'SELECT', 0, 'MS00009',  '查询注册中心列表',  NOW(), NOW()),
('MR00002','000001', 'sofa.ms.sg.registry.add', '多注册中心-新增注册中心', 'ADD', 0, 'MS00009',  '新增注册中心',  NOW(), NOW()),
('MR00003','000001', 'sofa.ms.sg.registry.update', '多注册中心-编辑注册中心', 'UPDATE', 0, 'MS00009',  '编辑注册中心',  NOW(), NOW()),
('MR00004', '000001','sofa.ms.sg.registry.delete', '多注册中心-删除注册中心', 'DELETE', 0,  'MS00009',  '删除注册中心',  NOW(), NOW()),
('DC00001','000001', 'sofa.ms.drm.drmresources.query', '动态配置-查询动态配置列表', 'SELECT', 0, 'MS00010',  '查询动态配置列表',  NOW(), NOW()),
('DC00002','000001', 'sofa.ms.drm.drmapps.all', '动态配置-查询动态配置应用列表', 'SELECT', 0, 'MS00010',  '查询动态配置应用列表',  NOW(), NOW()),
('DC00003','000001', 'sofa.ms.drm.drmresources.add', '动态配置-新增动态配置', 'ADD', 0, 'MS00010',  '新增动态配置',  NOW(), NOW()),
('DC00004', '000001','sofa.ms.drm.drmattributes.add', '动态配置-新增动态配置属性', 'ADD', 0,  'MS00010',  '新增动态配置属性',  NOW(), NOW()),
('DC00005', '000001','sofa.ms.drm.drmresources.update', '动态配置-修改动态配置', 'UPDATE', 0,  'MS00010',  '修改动态配置',  NOW(), NOW()),
('DC00006', '000001','sofa.ms.drm.drmattributes.update', '动态配置-修改动态配置属性', 'UPDATE', 0,  'MS00010',  '修改动态配置属性',  NOW(), NOW()),
('DC00007', '000001','sofa.ms.drm.drmattributes.get', '动态配置-查询动态配置详情', 'SELECT', 0,  'MS00010',  '查询动态配置详情',  NOW(), NOW()),
('DC00008', '000001','sofa.ms.drm.drmdata.add', '动态配置-推送动态配置', 'ADD', 0,  'MS00010',  '推送动态配置',  NOW(), NOW()),
('DC00009', '000001','sofa.ms.drm.drmclients.query', '动态配置-查询动态配置客户端值', 'SELECT', 0,  'MS00010',  '查询动态配置客户端值',  NOW(), NOW()),
('DC00010', '000001','sofa.ms.drm.drmpushlogs.query', '动态配置-查询动态配置推送记录', 'SELECT', 0,  'MS00010',  '查询动态配置推送记录',  NOW(), NOW()),
('DC00011', '000001','sofa.ms.drm.drmdatacells.list', '动态配置-查询动态配置推送值', 'SELECT', 0,  'MS00010',  '查询动态配置推送值',  NOW(), NOW()),
('DC00012', '000001','sofa.ms.drm.drmgraydata.add', '动态配置-灰度推送动态配置', 'ADD', 0,  'MS00010',  '灰度推送动态配置',  NOW(), NOW()),
('DC00013', '000001','sofa.ms.drm.drmresourcetpls.query', '动态配置-查询动态配置模版', 'SELECT', 0,  'MS00010',  '查询动态配置模版',  NOW(), NOW()),
('DC00014', '000001','sofa.ms.drm.drmresourcetpls.add', '动态配置-新增动态配置模版', 'ADD', 0,  'MS00010',  '新增动态配置模版',  NOW(), NOW()),
('DC00015', '000001','sofa.ms.drm.drmresourcetpls.update', '动态配置-编辑动态配置模版', 'UPDATE', 0,  'MS00010',  '编辑动态配置模版',  NOW(), NOW()),
('DC00016', '000001','sofa.ms.drm.drmresourcetpls.delete', '动态配置-删除动态配置模版', 'DELETE', 0,  'MS00010',  '删除动态配置模版',  NOW(), NOW()),
('DC00017', '000001','sofa.ms.drm.drmattributes.delete', '动态配置-删除动态配置属性', 'DELETE', 0,  'MS00010',  '删除动态配置属性',  NOW(), NOW()),
('DC00018', '000001','sofa.ms.drm.drmresources.delete', '动态配置-删除动态配置', 'DELETE', 0,  'MS00010',  '删除动态配置',  NOW(), NOW()),
('DC00019', '000001','sofa.ms.drm.drmldccells.all', '动态配置-获取实例的ldc单元格', 'SELECT', 0,  'MS00010',  '获取实例的ldc单元格',  NOW(), NOW()),
('AT00001','000001', 'sofa.ms.sg.auditlogs.list', '审计目录-查询审计目录列表', 'SELECT', 0, 'MS00011',  '查询审计目录列表',  NOW(), NOW()),
('RE00001','000001', 'sofa.ms.sg.role.list', '角色管理-查询角色列表', 'SELECT', 0, 'MS00014',  '查询角色列表',  NOW(), NOW()),
('RE00002','000001', 'sofa.ms.sg.roleapp.list', '角色管理-查询数据权限列表', 'SELECT', 0, 'MS00014',  '查询数据权限列表',  NOW(), NOW()),
('RE00003','000001', 'sofa.ms.sg.action.list', '角色管理-查询功能权限列表', 'SELECT', 0, 'MS00014',  '查询功能权限列表',  NOW(), NOW()),
('RE00004','000001', 'sofa.ms.sg.userlistbyrole.list', '角色管理-查询成员列表', 'SELECT', 0, 'MS00014',  '查询成员列表',  NOW(), NOW()),
('RE00005','000001', 'sofa.ms.sg.role.add', '角色管理-新增角色', 'ADD', 0, 'MS00014',  '新增角色',  NOW(), NOW()),
('RE00006','000001', 'sofa.ms.sg.role.update', '角色管理-更新角色', 'UPDATE', 0, 'MS00014',  '更新角色',  NOW(), NOW()),
('RE00007','000001', 'sofa.ms.sg.roleaction.add', '角色管理-为角色添加功能权限', 'ADD', 0, 'MS00014',  '为角色添加功能权限',  NOW(), NOW()),
('RE00008','000001', 'sofa.ms.sg.roleapp.add', '角色管理-为角色添加数据权限', 'ADD', 0, 'MS00014',  '为角色添加数据权限',  NOW(), NOW()),
('RE00009','000001', 'sofa.ms.sg.role.delete', '角色管理-删除角色', 'DELETE', 0, 'MS00014',  '删除角色',  NOW(), NOW()),
('RE00010','000001', 'sofa.ms.sg.rolemember.delete', '角色管理-删除角色的成员', 'ADD', 0, 'MS00014',  '删除角色成员',  NOW(), NOW()),
('US00001','000001', 'sofa.ms.sg.user.list', '账号管理-查询账号列表', 'SELECT', 0, 'MS00013',  '查询账号列表',  NOW(), NOW()),
('US00002','000001', 'sofa.ms.sg.rolelist.list', '账号管理-查询账号角色列表', 'SELECT', 0, 'MS00013',  '查询账号角色列表',  NOW(), NOW()),
('US00003','000001', 'sofa.ms.sg.user.search', '账号管理-查询成员列表', 'SELECT', 0, 'MS00013',  '查询成员列表',  NOW(), NOW()),
('US00004','000001', 'sofa.ms.sg.user.add', '账号管理-新增账号', 'ADD', 0, 'MS00013',  '新增账号',  NOW(), NOW()),
('US00005','000001', 'sofa.ms.sg.user.update', '账号管理-编辑账号', 'UPDATE', 0, 'MS00013',  '编辑账号',  NOW(), NOW()),
('US00006','000001', 'sofa.ms.sg.user.delete', '账号管理-删除账号', 'DELETE', 0, 'MS00013',  '删除账号',  NOW(), NOW()),
('US00007','000001', 'sofa.ms.sg.userrole.bind', '账号管理-授权角色', 'ADD', 0, 'MS00013',  '授权角色',  NOW(), NOW()),
('PT00001','000001', 'sofa.ms.sg.transcoderconfigrule.add', '协议转换配置-新增配置', 'SELECT', 0, 'MS00015',  '新增配置',  NOW(), NOW()),
('PT00002','000001', 'sofa.ms.sg.transcoderconfigrule.list', '协议转换配置-查询配置列表', 'SELECT', 0, 'MS00015',  '查询配置列表',  NOW(), NOW()),
('PT00003','000001', 'sofa.ms.sg.transcoderconfigrule.query', '协议转换配置-查询配置', 'SELECT', 0, 'MS00015',  '查询配置',  NOW(), NOW()),
('PT00004','000001', 'sofa.ms.sg.transcoderconfigrule.enable', '协议转换配置-配置开关', 'ADD', 0, 'MS00015',  '配置开关',  NOW(), NOW()),
('PT00005','000001', 'sofa.ms.sg.transcoderconfigrule.update', '协议转换配置-更新配置', 'UPDATE', 0, 'MS00015',  '更新配置',  NOW(), NOW()),
('PT00006','000001', 'sofa.ms.sg.transcoderconfigrule.delete', '协议转换配置-删除配置', 'DELETE', 0, 'MS00015',  '删除配置',  NOW(), NOW()),
('SD00001','000001', 'sofa.ms.sg.sidecardynamicconfig.list', 'sidecar动态配置-查询配置列表', 'SELECT', 0, 'MS00016',  '查询配置列表',  NOW(), NOW()),
('SD00002','000001', 'sofa.ms.sg.sidecardynamicconfig.add', 'sidecar动态配置-新增配置', 'SELECT', 0, 'MS00016',  '新增配置',  NOW(), NOW()),
('SD00003','000001', 'sofa.ms.sg.sidecardynamicconfig.update', 'sidecar动态配置-更新配置', 'SELECT', 0, 'MS00016',  '更新配置',  NOW(), NOW()),
('SD00004','000001', 'sofa.ms.sg.sidecardynamicconfigapp.delete', 'sidecar动态配置-删除应用', 'ADD', 0, 'MS00016',  '删除应用',  NOW(), NOW()),
('SD00005','000001', 'sofa.ms.sg.sidecardynamicconfig.delete', 'sidecar动态配置-删除配置', 'UPDATE', 0, 'MS00016',  '删除配置',  NOW(), NOW()),
('FP00009','000001', 'sofa.ms.sg.functionplugindropdown.list', '功能插件-功能插件下拉列表', 'SELECT', 0,  'MS00009',  '查询功能插件下拉列表',   NOW(), NOW()),
('SI00009','000001', 'sofa.ms.sg.enumlist.get', 'sidecar注入规则-展示枚举内容', 'SELECT', 0, 'MS00004',  '下拉框展示枚举内容',  NOW(), NOW()),
('SI00010','000001', 'sofa.ms.sg.sidecarinjectrule.preview', 'sidecar注入规则-预览sidecar注入规则模版', 'SELECT', 0, 'MS00004',  '预览sidecar注入规则模版',  NOW(), NOW()),
('CS00011','000001', 'sofa.ms.sg.describemeshgatewayinfo.get', '集群管理-查询网关信息', 'SELECT', 0,  'MS00001',  '查询网关信息',   NOW(), NOW()),
('CS00012','000001', 'sofa.ms.sg.updatemeshgatewaystatus.update', '集群管理-开通网关', 'UPDATE', 0,  'MS00001',  '开通网关',   NOW(), NOW()),
('SC00015','000001', 'sofa.ms.sg.sidecarevents.list', '服务目录-查询sidecar注入状态', 'SELECT', 0, 'MS00002',  '查询服务权限',  NOW(), NOW()),
('SC00016','000001', 'sofa.ms.sg.apprelations.query', '服务目录-查询应用依赖', 'SELECT', 0, 'MS00002',  '查询服务权限',  NOW(), NOW()),
('SC00017','000001', 'sofa.ms.sg.servicepubs.query', '服务目录-根据服务查询服务提供者', 'SELECT', 0, 'MS00002',  '查询服务权限',  NOW(), NOW()),
('SC00018','000001', 'sofa.ms.sg.servicesubs.query', '服务目录-根据服务查询服务消费者', 'SELECT', 0, 'MS00002',  '查询服务权限',  NOW(), NOW()),
('SC00019','000001', 'sofa.ms.sg.servicesubs.list', '服务目录-搜索服务消费者', 'SELECT', 0, 'MS00002',  '查询服务权限',  NOW(), NOW()),
('SC00020','000001', 'sofa.ms.sg.servicepubs.list', '服务目录-搜索服务提供者', 'SELECT', 0, 'MS00002',  '查询服务权限',  NOW(), NOW()),
('MD00006','000001', 'sofa.ms.sg.license.query', '元数据-查询license信息', 'SELECT', 0, 'MS00012',  '查询license信息',  NOW(), NOW()),
('MD00007','000001', 'sofa.ms.sg.license.active', '元数据-激活license', 'ADD', 0, 'MS00012',  '激活license',  NOW(), NOW()),
('MD00008','000001', 'sofa.ms.sg.license.verify', '元数据-校验license', 'ADD', 0, 'MS00012',  '校验license',  NOW(), NOW());



INSERT INTO dsrconsole.role_action_merge (instance_id,role_id,action_id,gmt_create,gmt_modified) VALUES
('000001',1,'US00001','2022-04-07 14:11:24','2022-04-07 14:11:24'),
('000001',1,'US00002','2022-04-07 14:11:24','2022-04-07 14:11:24'),
('000001',1,'US00003','2022-04-07 14:11:24','2022-04-07 14:11:24'),
('000001',1,'US00004','2022-04-07 14:11:24','2022-04-07 14:11:24'),
('000001',1,'US00005','2022-04-07 14:11:24','2022-04-07 14:11:24'),
('000001',1,'US00006','2022-04-07 14:11:24','2022-04-07 14:11:24'),
('000001',1,'US00007','2022-04-07 14:11:24','2022-04-07 14:11:24'),
('000001',1,'RE00001','2022-04-07 14:11:24','2022-04-07 14:11:24'),
('000001',1,'RE00002','2022-04-07 14:11:24','2022-04-07 14:11:24'),
('000001',1,'RE00003','2022-04-07 14:11:24','2022-04-07 14:11:24'),
('000001',1,'RE00004','2022-04-07 14:11:24','2022-04-07 14:11:24'),
('000001',1,'RE00005','2022-04-07 14:11:24','2022-04-07 14:11:24'),
('000001',1,'RE00006','2022-04-07 14:11:24','2022-04-07 14:11:24'),
('000001',1,'RE00007','2022-04-07 14:11:24','2022-04-07 14:11:24'),
('000001',1,'RE00008','2022-04-07 14:11:24','2022-04-07 14:11:24'),
('000001',1,'RE00009','2022-04-07 14:11:24','2022-04-07 14:11:24'),
('000001',1,'RE00010','2022-04-07 14:11:24','2022-04-07 14:11:24'),
('000001',1,'AT00001','2022-04-07 14:11:24','2022-04-07 14:11:24'),
('000001',1,'DC00001','2022-04-07 14:11:24','2022-04-07 14:11:24'),
('000001',1,'DC00002','2022-04-07 14:11:24','2022-04-07 14:11:24'),
('000001',1,'DC00003','2022-04-07 14:11:24','2022-04-07 14:11:24'),
('000001',1,'DC00004','2022-04-07 14:11:24','2022-04-07 14:11:24'),
('000001',1,'DC00005','2022-04-07 14:11:25','2022-04-07 14:11:25'),
('000001',1,'DC00006','2022-04-07 14:11:25','2022-04-07 14:11:25'),
('000001',1,'DC00007','2022-04-07 14:11:25','2022-04-07 14:11:25'),
('000001',1,'DC00008','2022-04-07 14:11:25','2022-04-07 14:11:25'),
('000001',1,'DC00009','2022-04-07 14:11:25','2022-04-07 14:11:25'),
('000001',1,'DC00010','2022-04-07 14:11:25','2022-04-07 14:11:25'),
('000001',1,'DC00011','2022-04-07 14:11:25','2022-04-07 14:11:25'),
('000001',1,'DC00012','2022-04-07 14:11:25','2022-04-07 14:11:25'),
('000001',1,'DC00013','2022-04-07 14:11:25','2022-04-07 14:11:25'),
('000001',1,'DC00014','2022-04-07 14:11:25','2022-04-07 14:11:25'),
('000001',1,'DC00015','2022-04-07 14:11:25','2022-04-07 14:11:25'),
('000001',1,'DC00016','2022-04-07 14:11:25','2022-04-07 14:11:25'),
('000001',1,'DC00017','2022-04-07 14:11:25','2022-04-07 14:11:25'),
('000001',1,'DC00018','2022-04-07 14:11:25','2022-04-07 14:11:25'),
('000001',1,'DC00019','2022-04-07 14:11:25','2022-04-07 14:11:25'),
('000001',1,'MR00001','2022-04-07 14:11:25','2022-04-07 14:11:25'),
('000001',1,'MR00002','2022-04-07 14:11:25','2022-04-07 14:11:25'),
('000001',1,'MR00003','2022-04-07 14:11:25','2022-04-07 14:11:25'),
('000001',1,'MR00004','2022-04-07 14:11:25','2022-04-07 14:11:25'),
('000001',1,'FP00001','2022-04-07 14:11:25','2022-04-07 14:11:25'),
('000001',1,'FP00002','2022-04-07 14:11:25','2022-04-07 14:11:25'),
('000001',1,'FP00003','2022-04-07 14:11:25','2022-04-07 14:11:25'),
('000001',1,'FP00004','2022-04-07 14:11:25','2022-04-07 14:11:25'),
('000001',1,'FP00005','2022-04-07 14:11:25','2022-04-07 14:11:25'),
('000001',1,'FP00006','2022-04-07 14:11:25','2022-04-07 14:11:25'),
('000001',1,'FP00007','2022-04-07 14:11:25','2022-04-07 14:11:25'),
('000001',1,'FP00008','2022-04-07 14:11:25','2022-04-07 14:11:25'),
('000001',1,'PP00001','2022-04-07 14:11:25','2022-04-07 14:11:25'),
('000001',1,'PP00002','2022-04-07 14:11:26','2022-04-07 14:11:26'),
('000001',1,'PP00003','2022-04-07 14:11:26','2022-04-07 14:11:26'),
('000001',1,'PP00004','2022-04-07 14:11:26','2022-04-07 14:11:26'),
('000001',1,'PP00005','2022-04-07 14:11:26','2022-04-07 14:11:26'),
('000001',1,'PP00006','2022-04-07 14:11:26','2022-04-07 14:11:26'),
('000001',1,'PP00007','2022-04-07 14:11:26','2022-04-07 14:11:26'),
('000001',1,'PP00008','2022-04-07 14:11:26','2022-04-07 14:11:26'),
('000001',1,'PP00009','2022-04-07 14:11:26','2022-04-07 14:11:26'),
('000001',1,'PP00010','2022-04-07 14:11:26','2022-04-07 14:11:26'),
('000001',1,'PP00011','2022-04-07 14:11:26','2022-04-07 14:11:26'),
('000001',1,'PP00012','2022-04-07 14:11:26','2022-04-07 14:11:26'),
('000001',1,'SY00002','2022-04-07 14:11:26','2022-04-07 14:11:26'),
('000001',1,'SY00003','2022-04-07 14:11:26','2022-04-07 14:11:26'),
('000001',1,'SY00004','2022-04-07 14:11:26','2022-04-07 14:11:26'),
('000001',1,'SY00005','2022-04-07 14:11:26','2022-04-07 14:11:26'),
('000001',1,'SY00006','2022-04-07 14:11:26','2022-04-07 14:11:26'),
('000001',1,'SY00007','2022-04-07 14:11:26','2022-04-07 14:11:26'),
('000001',1,'SY00008','2022-04-07 14:11:26','2022-04-07 14:11:26'),
('000001',1,'SY00009','2022-04-07 14:11:26','2022-04-07 14:11:26'),
('000001',1,'SY00010','2022-04-07 14:11:26','2022-04-07 14:11:26'),
('000001',1,'SY00011','2022-04-07 14:11:26','2022-04-07 14:11:26'),
('000001',1,'SY00012','2022-04-07 14:11:26','2022-04-07 14:11:26'),
('000001',1,'SY00013','2022-04-07 14:11:26','2022-04-07 14:11:26'),
('000001',1,'SY00014','2022-04-07 14:11:26','2022-04-07 14:11:26'),
('000001',1,'SY00015','2022-04-07 14:11:26','2022-04-07 14:11:26'),
('000001',1,'SY00016','2022-04-07 14:11:26','2022-04-07 14:11:26'),
('000001',1,'SY00017','2022-04-07 14:11:26','2022-04-07 14:11:26'),
('000001',1,'SY00018','2022-04-07 14:11:26','2022-04-07 14:11:26'),
('000001',1,'SY00019','2022-04-07 14:11:26','2022-04-07 14:11:26'),
('000001',1,'SY00020','2022-04-07 14:11:27','2022-04-07 14:11:27'),
('000001',1,'SY00021','2022-04-07 14:11:27','2022-04-07 14:11:27'),
('000001',1,'SY00022','2022-04-07 14:11:27','2022-04-07 14:11:27'),
('000001',1,'SY00023','2022-04-07 14:11:27','2022-04-07 14:11:27'),
('000001',1,'SY00024','2022-04-07 14:11:27','2022-04-07 14:11:27'),
('000001',1,'SY00025','2022-04-07 14:11:27','2022-04-07 14:11:27'),
('000001',1,'SY00026','2022-04-07 14:11:27','2022-04-07 14:11:27'),
('000001',1,'SY00027','2022-04-07 14:11:27','2022-04-07 14:11:27'),
('000001',1,'SV00001','2022-04-07 14:11:27','2022-04-07 14:11:27'),
('000001',1,'SV00002','2022-04-07 14:11:27','2022-04-07 14:11:27'),
('000001',1,'SV00003','2022-04-07 14:11:27','2022-04-07 14:11:27'),
('000001',1,'SV00004','2022-04-07 14:11:27','2022-04-07 14:11:27'),
('000001',1,'SI00001','2022-04-07 14:11:27','2022-04-07 14:11:27'),
('000001',1,'SI00002','2022-04-07 14:11:27','2022-04-07 14:11:27'),
('000001',1,'SI00003','2022-04-07 14:11:27','2022-04-07 14:11:27'),
('000001',1,'SI00004','2022-04-07 14:11:27','2022-04-07 14:11:27'),
('000001',1,'SI00005','2022-04-07 14:11:27','2022-04-07 14:11:27'),
('000001',1,'SI00006','2022-04-07 14:11:27','2022-04-07 14:11:27'),
('000001',1,'SI00007','2022-04-07 14:11:27','2022-04-07 14:11:27'),
('000001',1,'SI00008','2022-04-07 14:11:27','2022-04-07 14:11:27'),
('000001',1,'SG00002','2022-04-07 14:11:27','2022-04-07 14:11:27'),
('000001',1,'SG00003','2022-04-07 14:11:27','2022-04-07 14:11:27'),
('000001',1,'SG00004','2022-04-07 14:11:27','2022-04-07 14:11:27'),
('000001',1,'SG00005','2022-04-07 14:11:27','2022-04-07 14:11:27'),
('000001',1,'SG00006','2022-04-07 14:11:27','2022-04-07 14:11:27'),
('000001',1,'SG00007','2022-04-07 14:11:27','2022-04-07 14:11:27'),
('000001',1,'SG00008','2022-04-07 14:11:27','2022-04-07 14:11:27'),
('000001',1,'SG00009','2022-04-07 14:11:27','2022-04-07 14:11:27'),
('000001',1,'SG00011','2022-04-07 14:11:27','2022-04-07 14:11:27'),
('000001',1,'SG00012','2022-04-07 14:11:27','2022-04-07 14:11:27'),
('000001',1,'SG00013','2022-04-07 14:11:27','2022-04-07 14:11:27'),
('000001',1,'SG00014','2022-04-07 14:11:27','2022-04-07 14:11:27'),
('000001',1,'SG00015','2022-04-07 14:11:27','2022-04-07 14:11:27'),
('000001',1,'SG00016','2022-04-07 14:11:27','2022-04-07 14:11:27'),
('000001',1,'SG00017','2022-04-07 14:11:28','2022-04-07 14:11:28'),
('000001',1,'SG00018','2022-04-07 14:11:28','2022-04-07 14:11:28'),
('000001',1,'SG00019','2022-04-07 14:11:28','2022-04-07 14:11:28'),
('000001',1,'SG00020','2022-04-07 14:11:28','2022-04-07 14:11:28'),
('000001',1,'SG00021','2022-04-07 14:11:28','2022-04-07 14:11:28'),
('000001',1,'SG00022','2022-04-07 14:11:28','2022-04-07 14:11:28'),
('000001',1,'SG00023','2022-04-07 14:11:28','2022-04-07 14:11:28'),
('000001',1,'SG00024','2022-04-07 14:11:28','2022-04-07 14:11:28'),
('000001',1,'SG00025','2022-04-07 14:11:28','2022-04-07 14:11:28'),
('000001',1,'SG00026','2022-04-07 14:11:28','2022-04-07 14:11:28'),
('000001',1,'SG00027','2022-04-07 14:11:28','2022-04-07 14:11:28'),
('000001',1,'SG00028','2022-04-07 14:11:28','2022-04-07 14:11:28'),
('000001',1,'SG00029','2022-04-07 14:11:28','2022-04-07 14:11:28'),
('000001',1,'SG00030','2022-04-07 14:11:28','2022-04-07 14:11:28'),
('000001',1,'SG00031','2022-04-07 14:11:28','2022-04-07 14:11:28'),
('000001',1,'SG00032','2022-04-07 14:11:28','2022-04-07 14:11:28'),
('000001',1,'SG00033','2022-04-07 14:11:28','2022-04-07 14:11:28'),
('000001',1,'SG00034','2022-04-07 14:11:28','2022-04-07 14:11:28'),
('000001',1,'SG00035','2022-04-07 14:11:28','2022-04-07 14:11:28'),
('000001',1,'SG00036','2022-04-07 14:11:28','2022-04-07 14:11:28'),
('000001',1,'SG00037','2022-04-07 14:11:28','2022-04-07 14:11:28'),
('000001',1,'SG00038','2022-04-07 14:11:28','2022-04-07 14:11:28'),
('000001',1,'SG00039','2022-04-07 14:11:28','2022-04-07 14:11:28'),
('000001',1,'SG00040','2022-04-07 14:11:28','2022-04-07 14:11:28'),
('000001',1,'SG00041','2022-04-07 14:11:28','2022-04-07 14:11:28'),
('000001',1,'SG00042','2022-04-07 14:11:28','2022-04-07 14:11:28'),
('000001',1,'SG00043','2022-04-07 14:11:28','2022-04-07 14:11:28'),
('000001',1,'SG00044','2022-04-07 14:11:28','2022-04-07 14:11:28'),
('000001',1,'SG00045','2022-04-07 14:11:28','2022-04-07 14:11:28'),
('000001',1,'SG00046','2022-04-07 14:11:28','2022-04-07 14:11:28'),
('000001',1,'SG00047','2022-04-07 14:11:28','2022-04-07 14:11:28'),
('000001',1,'SG00048','2022-04-07 14:11:28','2022-04-07 14:11:28'),
('000001',1,'SG00049','2022-04-07 14:11:28','2022-04-07 14:11:28'),
('000001',1,'SG00050','2022-04-07 14:11:28','2022-04-07 14:11:28'),
('000001',1,'SG00051','2022-04-07 14:11:28','2022-04-07 14:11:28'),
('000001',1,'SG00052','2022-04-07 14:11:29','2022-04-07 14:11:29'),
('000001',1,'SG00053','2022-04-07 14:11:29','2022-04-07 14:11:29'),
('000001',1,'SG00010','2022-04-07 14:11:29','2022-04-07 14:11:29'),
('000001',1,'SC00001','2022-04-07 14:11:29','2022-04-07 14:11:29'),
('000001',1,'SC00002','2022-04-07 14:11:29','2022-04-07 14:11:29'),
('000001',1,'SC00003','2022-04-07 14:11:29','2022-04-07 14:11:29'),
('000001',1,'SC00004','2022-04-07 14:11:29','2022-04-07 14:11:29'),
('000001',1,'SC00005','2022-04-07 14:11:29','2022-04-07 14:11:29'),
('000001',1,'SC00006','2022-04-07 14:11:29','2022-04-07 14:11:29'),
('000001',1,'SC00007','2022-04-07 14:11:29','2022-04-07 14:11:29'),
('000001',1,'SC00009','2022-04-07 14:11:29','2022-04-07 14:11:29'),
('000001',1,'SC00010','2022-04-07 14:11:29','2022-04-07 14:11:29'),
('000001',1,'SC00011','2022-04-07 14:11:29','2022-04-07 14:11:29'),
('000001',1,'SC00012','2022-04-07 14:11:29','2022-04-07 14:11:29'),
('000001',1,'SC00013','2022-04-07 14:11:29','2022-04-07 14:11:29'),
('000001',1,'SC00014','2022-04-07 14:11:29','2022-04-07 14:11:29'),
('000001',1,'CS00001','2022-04-07 14:11:29','2022-04-07 14:11:29'),
('000001',1,'CS00002','2022-04-07 14:11:29','2022-04-07 14:11:29'),
('000001',1,'CS00003','2022-04-07 14:11:29','2022-04-07 14:11:29'),
('000001',1,'CS00004','2022-04-07 14:11:29','2022-04-07 14:11:29'),
('000001',1,'CS00005','2022-04-07 14:11:29','2022-04-07 14:11:29'),
('000001',1,'CS00006','2022-04-07 14:11:29','2022-04-07 14:11:29'),
('000001',1,'CS00007','2022-04-07 14:11:29','2022-04-07 14:11:29'),
('000001',1,'CS00008','2022-04-07 14:11:29','2022-04-07 14:11:29'),
('000001',1,'CS00009','2022-04-07 14:11:29','2022-04-07 14:11:29'),
('000001',1,'CS00010','2022-04-07 14:11:29','2022-04-07 14:11:29'),
('000001',1,'MD00001','2022-04-07 14:11:29','2022-04-07 14:11:29'),
('000001',1,'MD00002','2022-04-07 14:11:29','2022-04-07 14:11:29'),
('000001',1,'MD00003','2022-04-07 14:11:29','2022-04-07 14:11:29'),
('000001',1,'MD00004','2022-04-07 14:11:29','2022-04-07 14:11:29'),
('000001',1,'MD00005','2022-04-07 14:11:29','2022-04-07 14:11:29'),
('000001',2,'AT00001','2022-04-07 14:11:51','2022-04-07 14:11:51'),
('000001',2,'DC00001','2022-04-07 14:11:51','2022-04-07 14:11:51'),
('000001',2,'DC00002','2022-04-07 14:11:51','2022-04-07 14:11:51'),
('000001',2,'DC00003','2022-04-07 14:11:51','2022-04-07 14:11:51'),
('000001',2,'DC00004','2022-04-07 14:11:51','2022-04-07 14:11:51'),
('000001',2,'DC00005','2022-04-07 14:11:51','2022-04-07 14:11:51'),
('000001',2,'DC00006','2022-04-07 14:11:51','2022-04-07 14:11:51'),
('000001',2,'DC00007','2022-04-07 14:11:51','2022-04-07 14:11:51'),
('000001',2,'DC00008','2022-04-07 14:11:51','2022-04-07 14:11:51'),
('000001',2,'DC00009','2022-04-07 14:11:51','2022-04-07 14:11:51'),
('000001',2,'DC00010','2022-04-07 14:11:51','2022-04-07 14:11:51'),
('000001',2,'DC00011','2022-04-07 14:11:51','2022-04-07 14:11:51'),
('000001',2,'DC00012','2022-04-07 14:11:52','2022-04-07 14:11:52'),
('000001',2,'DC00013','2022-04-07 14:11:52','2022-04-07 14:11:52'),
('000001',2,'DC00014','2022-04-07 14:11:52','2022-04-07 14:11:52'),
('000001',2,'DC00015','2022-04-07 14:11:52','2022-04-07 14:11:52'),
('000001',2,'DC00016','2022-04-07 14:11:52','2022-04-07 14:11:52'),
('000001',2,'DC00017','2022-04-07 14:11:52','2022-04-07 14:11:52'),
('000001',2,'DC00018','2022-04-07 14:11:52','2022-04-07 14:11:52'),
('000001',2,'DC00019','2022-04-07 14:11:52','2022-04-07 14:11:52'),
('000001',2,'MR00001','2022-04-07 14:11:52','2022-04-07 14:11:52'),
('000001',2,'MR00002','2022-04-07 14:11:52','2022-04-07 14:11:52'),
('000001',2,'MR00003','2022-04-07 14:11:52','2022-04-07 14:11:52'),
('000001',2,'MR00004','2022-04-07 14:11:52','2022-04-07 14:11:52'),
('000001',2,'FP00001','2022-04-07 14:11:52','2022-04-07 14:11:52'),
('000001',2,'FP00002','2022-04-07 14:11:52','2022-04-07 14:11:52'),
('000001',2,'FP00003','2022-04-07 14:11:52','2022-04-07 14:11:52'),
('000001',2,'FP00004','2022-04-07 14:11:52','2022-04-07 14:11:52'),
('000001',2,'FP00005','2022-04-07 14:11:52','2022-04-07 14:11:52'),
('000001',2,'FP00006','2022-04-07 14:11:52','2022-04-07 14:11:52'),
('000001',2,'FP00007','2022-04-07 14:11:52','2022-04-07 14:11:52'),
('000001',2,'FP00008','2022-04-07 14:11:52','2022-04-07 14:11:52'),
('000001',2,'PP00001','2022-04-07 14:11:52','2022-04-07 14:11:52'),
('000001',2,'PP00002','2022-04-07 14:11:52','2022-04-07 14:11:52'),
('000001',2,'PP00003','2022-04-07 14:11:52','2022-04-07 14:11:52'),
('000001',2,'PP00004','2022-04-07 14:11:52','2022-04-07 14:11:52'),
('000001',2,'PP00005','2022-04-07 14:11:52','2022-04-07 14:11:52'),
('000001',2,'PP00006','2022-04-07 14:11:52','2022-04-07 14:11:52'),
('000001',2,'PP00007','2022-04-07 14:11:52','2022-04-07 14:11:52'),
('000001',2,'PP00008','2022-04-07 14:11:52','2022-04-07 14:11:52'),
('000001',2,'PP00009','2022-04-07 14:11:52','2022-04-07 14:11:52'),
('000001',2,'PP00010','2022-04-07 14:11:52','2022-04-07 14:11:52'),
('000001',2,'PP00011','2022-04-07 14:11:52','2022-04-07 14:11:52'),
('000001',2,'PP00012','2022-04-07 14:11:52','2022-04-07 14:11:52'),
('000001',2,'SY00002','2022-04-07 14:11:52','2022-04-07 14:11:52'),
('000001',2,'SY00003','2022-04-07 14:11:52','2022-04-07 14:11:52'),
('000001',2,'SY00004','2022-04-07 14:11:52','2022-04-07 14:11:52'),
('000001',2,'SY00005','2022-04-07 14:11:52','2022-04-07 14:11:52'),
('000001',2,'SY00006','2022-04-07 14:11:52','2022-04-07 14:11:52'),
('000001',2,'SY00007','2022-04-07 14:11:52','2022-04-07 14:11:52'),
('000001',2,'SY00008','2022-04-07 14:11:52','2022-04-07 14:11:52'),
('000001',2,'SY00009','2022-04-07 14:11:52','2022-04-07 14:11:52'),
('000001',2,'SY00010','2022-04-07 14:11:52','2022-04-07 14:11:52'),
('000001',2,'SY00011','2022-04-07 14:11:52','2022-04-07 14:11:52'),
('000001',2,'SY00012','2022-04-07 14:11:52','2022-04-07 14:11:52'),
('000001',2,'SY00013','2022-04-07 14:11:53','2022-04-07 14:11:53'),
('000001',2,'SY00014','2022-04-07 14:11:53','2022-04-07 14:11:53'),
('000001',2,'SY00015','2022-04-07 14:11:53','2022-04-07 14:11:53'),
('000001',2,'SY00016','2022-04-07 14:11:53','2022-04-07 14:11:53'),
('000001',2,'SY00017','2022-04-07 14:11:53','2022-04-07 14:11:53'),
('000001',2,'SY00018','2022-04-07 14:11:53','2022-04-07 14:11:53'),
('000001',2,'SY00019','2022-04-07 14:11:53','2022-04-07 14:11:53'),
('000001',2,'SY00020','2022-04-07 14:11:53','2022-04-07 14:11:53'),
('000001',2,'SY00021','2022-04-07 14:11:53','2022-04-07 14:11:53'),
('000001',2,'SY00022','2022-04-07 14:11:53','2022-04-07 14:11:53'),
('000001',2,'SY00023','2022-04-07 14:11:53','2022-04-07 14:11:53'),
('000001',2,'SY00024','2022-04-07 14:11:53','2022-04-07 14:11:53'),
('000001',2,'SY00025','2022-04-07 14:11:53','2022-04-07 14:11:53'),
('000001',2,'SY00026','2022-04-07 14:11:53','2022-04-07 14:11:53'),
('000001',2,'SY00027','2022-04-07 14:11:53','2022-04-07 14:11:53'),
('000001',2,'SV00001','2022-04-07 14:11:53','2022-04-07 14:11:53'),
('000001',2,'SV00002','2022-04-07 14:11:53','2022-04-07 14:11:53'),
('000001',2,'SV00003','2022-04-07 14:11:53','2022-04-07 14:11:53'),
('000001',2,'SV00004','2022-04-07 14:11:53','2022-04-07 14:11:53'),
('000001',2,'SI00001','2022-04-07 14:11:53','2022-04-07 14:11:53'),
('000001',2,'SI00002','2022-04-07 14:11:53','2022-04-07 14:11:53'),
('000001',2,'SI00003','2022-04-07 14:11:53','2022-04-07 14:11:53'),
('000001',2,'SI00004','2022-04-07 14:11:53','2022-04-07 14:11:53'),
('000001',2,'SI00005','2022-04-07 14:11:53','2022-04-07 14:11:53'),
('000001',2,'SI00006','2022-04-07 14:11:53','2022-04-07 14:11:53'),
('000001',2,'SI00007','2022-04-07 14:11:53','2022-04-07 14:11:53'),
('000001',2,'SI00008','2022-04-07 14:11:53','2022-04-07 14:11:53'),
('000001',2,'SG00002','2022-04-07 14:11:53','2022-04-07 14:11:53'),
('000001',2,'SG00003','2022-04-07 14:11:53','2022-04-07 14:11:53'),
('000001',2,'SG00004','2022-04-07 14:11:53','2022-04-07 14:11:53'),
('000001',2,'SG00005','2022-04-07 14:11:53','2022-04-07 14:11:53'),
('000001',2,'SG00006','2022-04-07 14:11:53','2022-04-07 14:11:53'),
('000001',2,'SG00007','2022-04-07 14:11:53','2022-04-07 14:11:53'),
('000001',2,'SG00008','2022-04-07 14:11:53','2022-04-07 14:11:53'),
('000001',2,'SG00009','2022-04-07 14:11:53','2022-04-07 14:11:53'),
('000001',2,'SG00011','2022-04-07 14:11:53','2022-04-07 14:11:53'),
('000001',2,'SG00012','2022-04-07 14:11:53','2022-04-07 14:11:53'),
('000001',2,'SG00013','2022-04-07 14:11:53','2022-04-07 14:11:53'),
('000001',2,'SG00014','2022-04-07 14:11:53','2022-04-07 14:11:53'),
('000001',2,'SG00015','2022-04-07 14:11:53','2022-04-07 14:11:53'),
('000001',2,'SG00016','2022-04-07 14:11:53','2022-04-07 14:11:53'),
('000001',2,'SG00017','2022-04-07 14:11:53','2022-04-07 14:11:53'),
('000001',2,'SG00018','2022-04-07 14:11:53','2022-04-07 14:11:53'),
('000001',2,'SG00019','2022-04-07 14:11:53','2022-04-07 14:11:53'),
('000001',2,'SG00020','2022-04-07 14:11:53','2022-04-07 14:11:53'),
('000001',2,'SG00021','2022-04-07 14:11:53','2022-04-07 14:11:53'),
('000001',2,'SG00022','2022-04-07 14:11:54','2022-04-07 14:11:54'),
('000001',2,'SG00023','2022-04-07 14:11:54','2022-04-07 14:11:54'),
('000001',2,'SG00024','2022-04-07 14:11:54','2022-04-07 14:11:54'),
('000001',2,'SG00025','2022-04-07 14:11:54','2022-04-07 14:11:54'),
('000001',2,'SG00026','2022-04-07 14:11:54','2022-04-07 14:11:54'),
('000001',2,'SG00027','2022-04-07 14:11:54','2022-04-07 14:11:54'),
('000001',2,'SG00028','2022-04-07 14:11:54','2022-04-07 14:11:54'),
('000001',2,'SG00029','2022-04-07 14:11:54','2022-04-07 14:11:54'),
('000001',2,'SG00030','2022-04-07 14:11:54','2022-04-07 14:11:54'),
('000001',2,'SG00031','2022-04-07 14:11:54','2022-04-07 14:11:54'),
('000001',2,'SG00032','2022-04-07 14:11:54','2022-04-07 14:11:54'),
('000001',2,'SG00033','2022-04-07 14:11:54','2022-04-07 14:11:54'),
('000001',2,'SG00034','2022-04-07 14:11:54','2022-04-07 14:11:54'),
('000001',2,'SG00035','2022-04-07 14:11:54','2022-04-07 14:11:54'),
('000001',2,'SG00036','2022-04-07 14:11:54','2022-04-07 14:11:54'),
('000001',2,'SG00037','2022-04-07 14:11:54','2022-04-07 14:11:54'),
('000001',2,'SG00038','2022-04-07 14:11:54','2022-04-07 14:11:54'),
('000001',2,'SG00039','2022-04-07 14:11:54','2022-04-07 14:11:54'),
('000001',2,'SG00040','2022-04-07 14:11:54','2022-04-07 14:11:54'),
('000001',2,'SG00041','2022-04-07 14:11:54','2022-04-07 14:11:54'),
('000001',2,'SG00042','2022-04-07 14:11:54','2022-04-07 14:11:54'),
('000001',2,'SG00043','2022-04-07 14:11:54','2022-04-07 14:11:54'),
('000001',2,'SG00044','2022-04-07 14:11:54','2022-04-07 14:11:54'),
('000001',2,'SG00045','2022-04-07 14:11:54','2022-04-07 14:11:54'),
('000001',2,'SG00046','2022-04-07 14:11:54','2022-04-07 14:11:54'),
('000001',2,'SG00047','2022-04-07 14:11:54','2022-04-07 14:11:54'),
('000001',2,'SG00048','2022-04-07 14:11:54','2022-04-07 14:11:54'),
('000001',2,'SG00049','2022-04-07 14:11:54','2022-04-07 14:11:54'),
('000001',2,'SG00050','2022-04-07 14:11:54','2022-04-07 14:11:54'),
('000001',2,'SG00051','2022-04-07 14:11:54','2022-04-07 14:11:54'),
('000001',2,'SG00052','2022-04-07 14:11:54','2022-04-07 14:11:54'),
('000001',2,'SG00053','2022-04-07 14:11:54','2022-04-07 14:11:54'),
('000001',2,'SG00010','2022-04-07 14:11:54','2022-04-07 14:11:54'),
('000001',2,'SC00001','2022-04-07 14:11:54','2022-04-07 14:11:54'),
('000001',2,'SC00002','2022-04-07 14:11:54','2022-04-07 14:11:54'),
('000001',2,'SC00003','2022-04-07 14:11:54','2022-04-07 14:11:54'),
('000001',2,'SC00004','2022-04-07 14:11:54','2022-04-07 14:11:54'),
('000001',2,'SC00005','2022-04-07 14:11:54','2022-04-07 14:11:54'),
('000001',2,'SC00006','2022-04-07 14:11:54','2022-04-07 14:11:54'),
('000001',2,'SC00007','2022-04-07 14:11:54','2022-04-07 14:11:54'),
('000001',2,'SC00009','2022-04-07 14:11:54','2022-04-07 14:11:54'),
('000001',2,'SC00010','2022-04-07 14:11:54','2022-04-07 14:11:54'),
('000001',2,'SC00011','2022-04-07 14:11:54','2022-04-07 14:11:54'),
('000001',2,'SC00012','2022-04-07 14:11:54','2022-04-07 14:11:54'),
('000001',2,'SC00013','2022-04-07 14:11:54','2022-04-07 14:11:54'),
('000001',2,'SC00014','2022-04-07 14:11:55','2022-04-07 14:11:55'),
('000001',2,'CS00001','2022-04-07 14:11:55','2022-04-07 14:11:55'),
('000001',2,'CS00002','2022-04-07 14:11:55','2022-04-07 14:11:55'),
('000001',2,'CS00003','2022-04-07 14:11:55','2022-04-07 14:11:55'),
('000001',2,'CS00004','2022-04-07 14:11:55','2022-04-07 14:11:55'),
('000001',2,'CS00005','2022-04-07 14:11:55','2022-04-07 14:11:55'),
('000001',2,'CS00006','2022-04-07 14:11:55','2022-04-07 14:11:55'),
('000001',2,'CS00007','2022-04-07 14:11:55','2022-04-07 14:11:55'),
('000001',2,'CS00008','2022-04-07 14:11:55','2022-04-07 14:11:55'),
('000001',2,'CS00009','2022-04-07 14:11:55','2022-04-07 14:11:55'),
('000001',2,'CS00010','2022-04-07 14:11:55','2022-04-07 14:11:55'),
('000001',2,'MD00001','2022-04-07 14:11:55','2022-04-07 14:11:55'),
('000001',2,'MD00002','2022-04-07 14:11:55','2022-04-07 14:11:55'),
('000001',2,'MD00003','2022-04-07 14:11:55','2022-04-07 14:11:55'),
('000001',2,'MD00004','2022-04-07 14:11:55','2022-04-07 14:11:55'),
('000001',2,'MD00005','2022-04-07 14:11:55','2022-04-07 14:11:55'),
('000001',3,'AT00001','2022-04-07 14:11:55','2022-04-07 14:11:55'),
('000001',3,'DC00001','2022-04-07 14:11:55','2022-04-07 14:11:55'),
('000001',3,'DC00002','2022-04-07 14:11:55','2022-04-07 14:11:55'),
('000001',3,'DC00007','2022-04-07 14:11:55','2022-04-07 14:11:55'),
('000001',3,'DC00009','2022-04-07 14:11:55','2022-04-07 14:11:55'),
('000001',3,'DC00010','2022-04-07 14:11:55','2022-04-07 14:11:55'),
('000001',3,'DC00011','2022-04-07 14:11:55','2022-04-07 14:11:55'),
('000001',3,'DC00013','2022-04-07 14:11:55','2022-04-07 14:11:55'),
('000001',3,'DC00019','2022-04-07 14:11:55','2022-04-07 14:11:55'),
('000001',3,'MR00001','2022-04-07 14:11:55','2022-04-07 14:11:55'),
('000001',3,'FP00001','2022-04-07 14:11:55','2022-04-07 14:11:55'),
('000001',3,'FP00002','2022-04-07 14:11:55','2022-04-07 14:11:55'),
('000001',3,'PP00001','2022-04-07 14:11:55','2022-04-07 14:11:55'),
('000001',3,'PP00002','2022-04-07 14:11:55','2022-04-07 14:11:55'),
('000001',3,'PP00003','2022-04-07 14:11:55','2022-04-07 14:11:55'),
('000001',3,'PP00004','2022-04-07 14:11:55','2022-04-07 14:11:55'),
('000001',3,'PP00006','2022-04-07 14:11:55','2022-04-07 14:11:55'),
('000001',3,'SY00002','2022-04-07 14:11:55','2022-04-07 14:11:55'),
('000001',3,'SY00003','2022-04-07 14:11:55','2022-04-07 14:11:55'),
('000001',3,'SY00008','2022-04-07 14:11:55','2022-04-07 14:11:55'),
('000001',3,'SY00009','2022-04-07 14:11:55','2022-04-07 14:11:55'),
('000001',3,'SY00010','2022-04-07 14:11:55','2022-04-07 14:11:55'),
('000001',3,'SY00011','2022-04-07 14:11:55','2022-04-07 14:11:55'),
('000001',3,'SY00016','2022-04-07 14:11:55','2022-04-07 14:11:55'),
('000001',3,'SY00017','2022-04-07 14:11:55','2022-04-07 14:11:55'),
('000001',3,'SY00018','2022-04-07 14:11:55','2022-04-07 14:11:55'),
('000001',3,'SY00019','2022-04-07 14:11:55','2022-04-07 14:11:55'),
('000001',3,'SV00001','2022-04-07 14:11:55','2022-04-07 14:11:55'),
('000001',3,'SI00001','2022-04-07 14:11:55','2022-04-07 14:11:55'),
('000001',3,'SI00002','2022-04-07 14:11:56','2022-04-07 14:11:56'),
('000001',3,'SI00003','2022-04-07 14:11:56','2022-04-07 14:11:56'),
('000001',3,'SI00004','2022-04-07 14:11:56','2022-04-07 14:11:56'),
('000001',3,'SG00002','2022-04-07 14:11:56','2022-04-07 14:11:56'),
('000001',3,'SG00003','2022-04-07 14:11:56','2022-04-07 14:11:56'),
('000001',3,'SG00008','2022-04-07 14:11:56','2022-04-07 14:11:56'),
('000001',3,'SG00009','2022-04-07 14:11:56','2022-04-07 14:11:56'),
('000001',3,'SG00011','2022-04-07 14:11:56','2022-04-07 14:11:56'),
('000001',3,'SG00012','2022-04-07 14:11:56','2022-04-07 14:11:56'),
('000001',3,'SG00017','2022-04-07 14:11:56','2022-04-07 14:11:56'),
('000001',3,'SG00018','2022-04-07 14:11:56','2022-04-07 14:11:56'),
('000001',3,'SG00023','2022-04-07 14:11:56','2022-04-07 14:11:56'),
('000001',3,'SG00029','2022-04-07 14:11:56','2022-04-07 14:11:56'),
('000001',3,'SG00030','2022-04-07 14:11:56','2022-04-07 14:11:56'),
('000001',3,'SG00031','2022-04-07 14:11:56','2022-04-07 14:11:56'),
('000001',3,'SG00032','2022-04-07 14:11:56','2022-04-07 14:11:56'),
('000001',3,'SG00037','2022-04-07 14:11:56','2022-04-07 14:11:56'),
('000001',3,'SG00038','2022-04-07 14:11:56','2022-04-07 14:11:56'),
('000001',3,'SG00043','2022-04-07 14:11:56','2022-04-07 14:11:56'),
('000001',3,'SG00044','2022-04-07 14:11:56','2022-04-07 14:11:56'),
('000001',3,'SG00045','2022-04-07 14:11:56','2022-04-07 14:11:56'),
('000001',3,'SG00046','2022-04-07 14:11:56','2022-04-07 14:11:56'),
('000001',3,'SG00051','2022-04-07 14:11:56','2022-04-07 14:11:56'),
('000001',3,'SG00053','2022-04-07 14:11:56','2022-04-07 14:11:56'),
('000001',3,'SG00010','2022-04-07 14:11:56','2022-04-07 14:11:56'),
('000001',3,'SC00001','2022-04-07 14:11:56','2022-04-07 14:11:56'),
('000001',3,'SC00002','2022-04-07 14:11:56','2022-04-07 14:11:56'),
('000001',3,'SC00003','2022-04-07 14:11:56','2022-04-07 14:11:56'),
('000001',3,'SC00004','2022-04-07 14:11:56','2022-04-07 14:11:56'),
('000001',3,'SC00007','2022-04-07 14:11:56','2022-04-07 14:11:56'),
('000001',3,'SC00009','2022-04-07 14:11:56','2022-04-07 14:11:56'),
('000001',3,'SC00010','2022-04-07 14:11:56','2022-04-07 14:11:56'),
('000001',3,'SC00013','2022-04-07 14:11:56','2022-04-07 14:11:56'),
('000001',3,'SC00014','2022-04-07 14:11:56','2022-04-07 14:11:56'),
('000001',3,'CS00001','2022-04-07 14:11:56','2022-04-07 14:11:56'),
('000001',3,'CS00002','2022-04-07 14:11:56','2022-04-07 14:11:56'),
('000001',3,'CS00003','2022-04-07 14:11:56','2022-04-07 14:11:56'),
('000001',3,'CS00010','2022-04-07 14:11:56','2022-04-07 14:11:56'),
('000001',3,'MD00001','2022-04-07 14:11:56','2022-04-07 14:11:56'),
('000001',3,'MD00002','2022-04-07 14:11:56','2022-04-07 14:11:56'),
('000001',3,'MD00003','2022-04-07 14:11:56','2022-04-07 14:11:56'),
('000001',3,'MD00004','2022-04-07 14:11:56','2022-04-07 14:11:56'),
('000001',3,'MD00005','2022-04-07 14:11:56','2022-04-07 14:11:56'),
('000001',1,'PT00001','2022-04-07 14:11:51','2022-04-07 14:11:51'),
('000001',1,'PT00002','2022-04-07 14:11:51','2022-04-07 14:11:51'),
('000001',1,'PT00003','2022-04-07 14:11:51','2022-04-07 14:11:51'),
('000001',1,'PT00004','2022-04-07 14:11:51','2022-04-07 14:11:51'),
('000001',1,'PT00005','2022-04-07 14:11:51','2022-04-07 14:11:51'),
('000001',1,'PT00006','2022-04-07 14:11:51','2022-04-07 14:11:51'),
('000001',1,'SD00001','2022-04-07 14:11:51','2022-04-07 14:11:51'),
('000001',1,'SD00002','2022-04-07 14:11:51','2022-04-07 14:11:51'),
('000001',1,'SD00003','2022-04-07 14:11:51','2022-04-07 14:11:51'),
('000001',1,'SD00004','2022-04-07 14:11:51','2022-04-07 14:11:51'),
('000001',1,'SD00005','2022-04-07 14:11:51','2022-04-07 14:11:51'),
('000001',1,'FP00009','2022-04-07 14:11:51','2022-04-07 14:11:51'),
('000001',2,'PT00001','2022-04-07 14:11:51','2022-04-07 14:11:51'),
('000001',2,'PT00002','2022-04-07 14:11:51','2022-04-07 14:11:51'),
('000001',2,'PT00003','2022-04-07 14:11:51','2022-04-07 14:11:51'),
('000001',2,'PT00004','2022-04-07 14:11:51','2022-04-07 14:11:51'),
('000001',2,'PT00005','2022-04-07 14:11:51','2022-04-07 14:11:51'),
('000001',2,'PT00006','2022-04-07 14:11:51','2022-04-07 14:11:51'),
('000001',2,'SD00001','2022-04-07 14:11:51','2022-04-07 14:11:51'),
('000001',2,'SD00002','2022-04-07 14:11:51','2022-04-07 14:11:51'),
('000001',2,'SD00003','2022-04-07 14:11:51','2022-04-07 14:11:51'),
('000001',2,'SD00004','2022-04-07 14:11:51','2022-04-07 14:11:51'),
('000001',2,'SD00005','2022-04-07 14:11:51','2022-04-07 14:11:51'),
('000001',2,'FP00009','2022-04-07 14:11:51','2022-04-07 14:11:51'),
('000001',3,'PT00002','2022-04-07 14:11:51','2022-04-07 14:11:51'),
('000001',3,'PT00003','2022-04-07 14:11:51','2022-04-07 14:11:51'),
('000001',3,'SD00001','2022-04-07 14:11:51','2022-04-07 14:11:51'),
('000001',3,'FP00009','2022-04-07 14:11:51','2022-04-07 14:11:51'),
('000001',1,'SI00009','2022-04-07 14:11:51','2022-04-07 14:11:51'),
('000001',2,'SI00009','2022-04-07 14:11:51','2022-04-07 14:11:51'),
('000001',3,'SI00009','2022-04-07 14:11:51','2022-04-07 14:11:51'),
('000001',1,'SI00010','2022-04-07 14:11:51','2022-04-07 14:11:51'),
('000001',2,'SI00010','2022-04-07 14:11:51','2022-04-07 14:11:51'),
('000001',3,'SI00010','2022-04-07 14:11:51','2022-04-07 14:11:51'),
('000001',1,'CS00011','2022-04-07 14:11:51','2022-04-07 14:11:51'),
('000001',1,'CS00012','2022-04-07 14:11:51','2022-04-07 14:11:51'),
('000001',2,'CS00011','2022-04-07 14:11:51','2022-04-07 14:11:51'),
('000001',2,'CS00012','2022-04-07 14:11:51','2022-04-07 14:11:51'),
('000001',3,'CS00011','2022-04-07 14:11:51','2022-04-07 14:11:51'),
('000001',1,'SC00015','2022-04-07 14:11:51','2022-04-07 14:11:51'),
('000001',2,'SC00015','2022-04-07 14:11:51','2022-04-07 14:11:51'),
('000001',3,'SC00015','2022-04-07 14:11:51','2022-04-07 14:11:51'),
('000001',1,'SC00016','2022-04-07 14:11:51','2022-04-07 14:11:51'),
('000001',2,'SC00016','2022-04-07 14:11:51','2022-04-07 14:11:51'),
('000001',3,'SC00016','2022-04-07 14:11:51','2022-04-07 14:11:51'),
('000001',1,'SC00017','2022-04-07 14:11:51','2022-04-07 14:11:51'),
('000001',2,'SC00017','2022-04-07 14:11:51','2022-04-07 14:11:51'),
('000001',3,'SC00017','2022-04-07 14:11:51','2022-04-07 14:11:51'),
('000001',1,'SC00018','2022-04-07 14:11:51','2022-04-07 14:11:51'),
('000001',2,'SC00018','2022-04-07 14:11:51','2022-04-07 14:11:51'),
('000001',3,'SC00018','2022-04-07 14:11:51','2022-04-07 14:11:51'),
('000001',1,'SC00019','2022-04-07 14:11:51','2022-04-07 14:11:51'),
('000001',2,'SC00019','2022-04-07 14:11:51','2022-04-07 14:11:51'),
('000001',3,'SC00019','2022-04-07 14:11:51','2022-04-07 14:11:51'),
('000001',1,'SC00020','2022-04-07 14:11:51','2022-04-07 14:11:51'),
('000001',2,'SC00020','2022-04-07 14:11:51','2022-04-07 14:11:51'),
('000001',3,'SC00020','2022-04-07 14:11:51','2022-04-07 14:11:51'),
('000001',1,'MD00006','2022-04-07 14:11:51','2022-04-07 14:11:51'),
('000001',2,'MD00006','2022-04-07 14:11:51','2022-04-07 14:11:51'),
('000001',3,'MD00006','2022-04-07 14:11:51','2022-04-07 14:11:51'),
('000001',1,'MD00007','2022-04-07 14:11:51','2022-04-07 14:11:51'),
('000001',2,'MD00007','2022-04-07 14:11:51','2022-04-07 14:11:51'),
('000001',3,'MD00007','2022-04-07 14:11:51','2022-04-07 14:11:51'),
('000001',1,'MD00008','2022-04-07 14:11:51','2022-04-07 14:11:51'),
('000001',2,'MD00008','2022-04-07 14:11:51','2022-04-07 14:11:51'),
('000001',3,'MD00008','2022-04-07 14:11:51','2022-04-07 14:11:51');



create unique index uk_instance_id_role_id_user_id_user_role_merge
    on user_role_merge (instance_id, role_id, user_id);



create unique index uk_instance_id_role_id_action_id_role_action_merge
    on role_action_merge (instance_id, role_id, action_id);


CREATE TABLE `logo_info`
(
    `id`           BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
    `type`         VARCHAR(64)         NOT NULL DEFAULT 'navi' COMMENT '类型login;navi;icon;favi',
    `hidden`       tinyint(4)          NOT NULL DEFAULT '0' COMMENT '是否隐藏，1 隐藏，0 否',
    `text`         VARCHAR(128)        NULL     DEFAULT NULL COMMENT '文字',
    `imgData`      MEDIUMTEXT          NULL     DEFAULT NULL COMMENT '图片数据',
    `operator`     VARCHAR(64)         NULL     DEFAULT NULL COMMENT '操作人',
    `gmt_create`   DATETIME            NULL     DEFAULT NULL COMMENT '创建时间',
    `gmt_modified` DATETIME            NULL     DEFAULT NULL COMMENT '修改时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_company_name` (`id`)
) COMMENT ='logo信息';


CREATE TABLE `menu_settings`
(
    `id`           BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
    `menu_id`      VARCHAR(128)        NOT NULL DEFAULT '' COMMENT '菜单id',
    `menu_name`    VARCHAR(128)        NOT NULL DEFAULT '' COMMENT '菜单名称',
    `displayed`    tinyint(4)          NOT NULL DEFAULT '1' COMMENT '是否展示，1 是，0 否',
    `operator`     VARCHAR(64)         NULL     DEFAULT NULL COMMENT '操作人',
    `gmt_create`   DATETIME            NULL     DEFAULT NULL COMMENT '创建时间',
    `gmt_modified` DATETIME            NULL     DEFAULT NULL COMMENT '修改时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_menu` (`menu_id`)
) COMMENT ='菜单设置';