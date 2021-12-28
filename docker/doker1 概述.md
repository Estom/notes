## 学习路线

* doker概述
* doker安装
* doker命令
* doker镜像
* 容器数据卷
* dokerfile
* doker网络原理
* IDEA整合doker
* doker compose 集群
* doker swarm 部署
* CI/CD jenkins 部署流水线


## doker概述

### 背景
1. 产品人员（提出需求）
2. 开发人员（实现产品）
3. 运维人员（维护产品）

问题：从开发到运维，环境部署十分困难。每一个集群都需要部署环境。
方案：jar +(redis/mysql/jdk)项目+环境，一起打包发布。由开发人员完成开发、打包、部署、上线等一系列流程。

Android开发的完整流程：java开发----apk打包-----应用商店（发布）----下载安装apk（部署）----安装即可用（上线）
Java开发的完整流程：Java开发----jar+环境（打包，doker镜像）----docker仓库（发布）----下载镜像（部署）----直接运行（上线）

doker解决的问题？
1. jre多个应用端口冲突、环境冲突等。
2. doker打包装箱，隔离
