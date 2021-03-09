# DAO模式的原理说明

DAO(Data Access
Object)是一个数据访问接口，数据访问：顾名思义就是与数据库打交道，夹在业务逻辑与数据库资源中间。

在核心J2EE模式中DAO的定义是：为了建立一个健壮的J2EE应用，应该将所有对数据源的访问操作抽象封装在一个公共API中。用程序设计的语言来说，就是建立一个接口，接口中定义了此应用程序中将会用到的所有事务方法。在这个应用程序中，当需要和数据源进行交互的时候则使用这个接口，并且编写一个单独的类来实现这个接口在逻辑上对应这个特定的数据存储。

DAO层本质上就是MVC中的Model部分的具体实现。相当于整个工程的javabean，实现了对数据库的增删查改。

![dao.jpg](media/896ddc649ace2c4d5b318d11c887ece9.jpeg)

# DAO模式的具体实现

\-VO类：提供javabean，表示数据库中的一条记录，主要有getter和setter方法

\-DAO类：提供了DAOmodel的接口，供控制器调用

\-DAOimplement：实现了DAO类提供的外部接口，主要是通过jdbc链接数据库，实现了数据库的增删查改操作。

\-DAOFactory：通过工厂类，获取一个DAO的实例化对象。

在当前的工程中分别对应一下包：

.domain

.dao

.dao.impl

.service.impl

这四个类分别代daobean,dao接口,dao的jdbc实现,dao的工厂类，在这里实现工程需要的所有的数据库的操作，提供给其他部分调用。

最根本的事通过jdbcUtils提供了访问数据库的链接

逻辑结构非常清晰明显

# 最后说明dao的工作原理

![dao2.jpg](media/0df06acb323561f7014fed6f60125206.jpeg)

关于到的层级在此说明

数据库数据存储

\|-jdbc提供数据库的链接

\|-daoBean数据保存

\|-daoImpl的具体实现

\|-dao提供数据库访问的接口

\|-daoFactory实例化数据库的接口提供具体的数据操作

控制器数据操作需求
