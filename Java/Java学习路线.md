## Java 学习路线

> 生命的长度是有限的，但 Java 的知识是无限的！

总共包括六个主要的部分。学完就能毕业啦。开始吧。



对一个软件的了解程度

使用：快速搭建器软件，运行，实现基础的内容。（看quick start中的内容和视频即）
精通：了解每一个配置的细节，能够进行深度定制化。（看用户文档和API参考）
源码：掌握底层的原理，能进行破坏性的改进和学习。（看代码仓库源码）

### Java 的学习路线（视频打卡系列）

- [ ] 基础知识（学习方式——阅读书籍）
  - [ ] 数据库
  - [ ] 操作系统
  - [ ] 计算机网络
  - [ ] 数据结构与算法
  - [ ] 编译原理
- [ ] Java 基础教程（Java 的基本语法和使用及原理，分五个阶段完成）
  - [x] Java 语言基础。语言语法。
  - [ ] Java 高级操作。JDK 标准库/集合类/IO 操作/并发编程/网络编程
  - [ ] Javaweb 开发。Servlet 和 JSP 相关的老技术。知道就行
  - [ ] Java 基本原理。JVM 底层的原理和技术
  - [ ] Java 架构模式。面向对象和设计模式
- [ ] Java 网站开发（JavaWeb 相关的技术知识。）
  - [ ] MySQL
  - [x] JDBC
  - [x] lombak
  - [ ] mybatis
- [x] Java 工具教程（Java 使用的关键工具，白天学习一下）
  - [x] maven 教程
  - [x] idea 教程
- [ ] Java 框架教程（Spring 全家桶，白天自学）
  - [x] Spring
  - [x] Springboot
  - [ ] Spring MVC
  - [ ] SpringCloud
- [ ] Java云原生
  - [ ] docker
  - [ ] k8s
- [ ] Java 性能优化
  - [ ] 高可用
    - [ ] 双机架构
    - [ ] 异地多活
  - [ ] 高性能
    - [ ] 高性能缓存
    - [ ] PPC TPC
  - [ ] 高并发
    - [ ] 分库分表
    - [ ] 消息队列
- [ ] Java 分布式基础
  - [ ] 负载均衡和调度
  - [ ] 分布式缓存
  - [ ] 分布式算法
  - [ ] kfk 消息队列
- [ ] Java 数据库

  - [ ] mysql
  - [ ] redis


- [ ] 中间件
  - [ ] 微服务架构（经典和Mesh）：
    - [ ] 服务侧
      - [ ] 注册中心（Nacos/ZooKeeper/Etcd）
      - [ ] 服务治理，实现服务的限流、路由、熔断等功能(Seninel)
      - [ ] 配置中心，运行时配置推送下发(Nacos)
      - [ ] 网关
    - [ ] 客户侧
      - [ ] 服务框架，快速引入中间件的客户端(SpringCloud/SpringCloudAlibaba/Dubbo)
      - [ ] 通信协议，实现远程调用(Dubbo)
  - [ ] 通信中间件
    - [ ] 消息(RocketMQ)
    - [ ] 调度
    - [ ] 事务
  - [ ] 数据中间件
    - [ ] 数据代理
    - [ ] 数据缓存(Redis)
    - [ ] 数据同步
- [ ] PaaS 运维发布
  - [ ] 运维发布(Docker/K8s/Helm)：服务自愈、弹性伸缩
  - [ ] 应用管理、服务管理、节点管理、全链路灰度、灰度发布
- [ ] RaaS 监控告警
  - [ ] 日志
  - [ ] 监控、告警(Prometheus/Grafana)
  - [ ] 链路追踪
- [ ] 研发效能 CI/CD
  - [ ] 需求管理
  - [ ] 迭代管理和流水线(Jekeins)
  - [ ] 仓库：代码仓库(Gitee/Git)、镜像仓库(DockerHub)、依赖仓库(Maven)等

> 首先看完这些相关的课程，然后去看书重新学习一遍这些知识
> * 下三个内容：jdk -> jdbc -> javaweb -> springmvc -> mybatis -> ssm -> sprincloud
> * -> spring(spring->springboot->springmvc->springcloud)
> * -> java(jdk->javaweb->jvm) 
> * -> 网站开发(mysql->jdbc->lomback->mybatis)
> * -> 云计算(docker->k8s) 
> * -> 微服务(nacos->zookeeper->sentinel->dubbo->rocketeMQ->prometheus->grafana->git->jekens)

### Java 书籍打卡系列开始

第一阶段：向下探索五本

- [ ] Java 编程思想（4 版）
- [ ] Java 核心技术卷 1（12 版）
- [ ] Java 核心技术卷 2（12 版）
- [ ] Effective Java
- [ ] 深入理解 Java 虚拟机

第二阶段：向上进阶五本

- [ ] ON JAVA 基础卷
- [ ] ON JAVA 进阶卷
- [ ] Java 设计模式及实践（这些东西还是得自己手敲一遍）
- [ ] Java 并发编程的艺术、并发编程实践、高并发编程详解（机械工业出版三件套）
- [ ] Spring 官方文档。全套阅读。

第三阶段：云原生三本

- [ ] 云原生技术
- [ ] 服务网格

> 一份可以参考的文档。其中大数据、网络安全和扩展篇不学。
> ![](image/2022-10-27-20-26-36.png)

> 找到了两个很不得了的东西。如果有时间，可以把这两个文档全部重新看一遍。完全有书籍的质量的基础知识介绍。常看常新。自己接下来的笔记就从这上边找吧。
>
> 入门小站。https://rumenz.com/
> BestJavaer。https://github.com/crisxuan/bestJavaer
