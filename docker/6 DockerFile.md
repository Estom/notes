## 概念

### 简介

* Docker：将应用和环境打包成一个镜像
* 数据？如果数据在容器中，那么我们容器删除，数据就会丢失。需求：数据持久化。
* 所以：Mysql的数据可以存储在本地。
* 所以：容器间可以有一个数据共享的技术。 Docker容器中产生的数据，同步到本地。
* 这就是：卷技术，目录挂载，将容器内的目录，挂载到Linux上。

![](image/2022-10-07-22-09-15.png)
**总结：容器的持久化和同步操作**

### 使用

* -v 实现文件映射
```
docker run -it -v 目录映射 -p 端口映射

➜  ~ docker run -it -v /Users/yinkanglong/ceshi:/home centos /bin/bash
```

* 使用docker inspect 查看挂载情况mount
  * 同步的过程，是一种双向绑定的过程。

![](image/2022-10-07-22-09-28.png)

> 是同步的过程，还是目录挂载到磁盘的同一个位置了？

### 实战：安装Mysql

```
# 获取镜像
docker pull mysql 5.7

# 运行容器，需要做数据挂载
-d 后台运行
-p 端口映射
-v 卷挂载
--name 容器名字
➜  ~ docker run -d -p 3310:3306 -v /Users/yinkanglong/mysql/conf:/etc/mysql/conf.d -v /Users/yinkanglong/mysql/data:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=123456 --name mysql01 mysql:5.7

# 启动之后链接数据库服务器进行测试
➜  data mysql -h 127.0.0.1 -P 3310 -uroot -p123456

# 在本地测试创建数据库，查看映射路径是否可以
create table
```

![](image/2022-10-07-22-43-49.png)


## 概念原理


### docker volume数据卷操作

```
 create      Create a volume
  inspect     Display detailed information on one or more volumes
  ls          List volumes
  prune       Remove all unused local volumes
  rm          Remove one or more volumes

```
* 查看所有的卷的情况
```
➜  data docker volume ls    
DRIVER    VOLUME NAME
local     635d632e8d79ad10168a6bd6b65ba5b67de68c38c63b619915b6d00db2bd1b4a
local     0704fe09fca1d196b4d4f1cc14141ba05bae986d03ac1209f63ed1cca3d7bd7c
local     924b3cbb61444c73191a11200c727b52f9ccc17dd27024bce61ba63a33577663

# 这里发现的，就是匿名挂载。
```
### 匿名挂载

```
# 匿名挂载

```