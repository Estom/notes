http://www.wjhsh.net/zhangminghui-p-4889761.html


### POJO

POJO（Plain Ordinary Java Object）简单的Java对象，实际就是普通JavaBeans，是为了避免和EJB混淆所创造的简称。
使用POJO名称是为了避免和EJB混淆起来, 而且简称比较直接. 其中有一些属性及其getter setter方法的类,没有业务逻辑，有时可以作为VO(value -object)或dto(Data Transform Object)来使用.当然,如果你有一个简单的运算属性也是可以的,但不允许有业务方法,也不能携带有connection之类的方法。


### JPA
JPA是Java Persistence API的简称，中文名Java持久层API，是JDK 5.0注解或XML描述对象－关系表的映射关系，并将运行期的实体对象持久化到数据库中。 [1] 
Sun引入新的JPA ORM规范出于两个原因：其一，简化现有Java EE和Java SE应用开发工作；其二，Sun希望整合ORM技术，实现天下归一。

容器级特性的支持JPA框架中支持大数据集、事务、并发等容器级事务，这使得 JPA 超越了简单持久化框架的局限，在企业应用发挥更大的作用。


### Spring
Spring + Hibernate 常常被称为 Java Web 应用人气最旺的框架组合。而在 JCP 通过的 Web Beans JSR ，却欲将JSF + EJB + JPA 、来自 JBoss Seam（Spring 除外）的一些组件和EJB 3（能够提供有基本拦截和依赖注入功能的简化 Session Bean框架）的一个 Web 组合进行标准化。Spring 2.0 为 JPA 提供了完整的 EJB容器契约，允许 JPA在任何环境内可以在 Spring 管理的服务层使用（包括 Spring 的所有DI 和 AOP增强）。同时，关于下一个Web应用组合会是 EJB、Spring + Hibernate 还是 Spring + JPA 的论战，早已充斥于耳。


### JavaEE
JavaEE:Java Platform Enterprise Edition
JavaEE是一个分层架构，分布式的体系结构。

分层架构： JavaEE由四个层次构成，分别是客户层，Web层，业务层，持久层
* 客户层：页面展示层，运行在客户机上，可以访问Web层和业务层。Applet、客户应用程序
* 表示层：JSP和Servlet构成的Web页面。Web容器
* 业务层：处理程序的业务逻辑，主要是一些业务方法的集合。主要框架有Spring，SpringMVC，Struts，EJB框架等。EJB 构件　EJB容器
* 持久层：数据库层，JDBC，JNDI，DataSource等，主要一流框架有Mybatis,Hibernate框架等

### EJB
EJB:Enterprise Java Bean,一个重量级的业务层框架，重量级的意思在于其启动时开销大。

Enterprise Java Beans(EJB)称为Java 企业Bean，是Java的核心代码，分别是会话Bean（Session Bean），实体Bean（Entity Bean）和消息驱动Bean（MessageDriven Bean）

1.JavaBean
　　JavaBean(官方解释)是可复用的Java组件，严格遵循Sun定义的规范要求，JavaBean是一个标准，开发者可以直接复用别人写好软件组件而不必理解它内部的工作机制。简单来说一个JavaBean应该有下面几个特点，

　　>类应该是public的

　　>属性应该private的，对于属性值的访问应该是要通过getXX,setXX,isXXX方法，isXXX是用于检查元素的值是否是Boolean的。

　　>该类应该有一个无参的构造函数，元素值的初始化要通过setXXX方法。

　　>这个类应该是实现了Serializable 接口(java.io.Externalizable)，这个是为了持久化存储的需要。

　例如：

package com.example;
 
import java.io.Serializable;
 
public class Bar implements Serializable {
  
    private String name = null;
  
    private boolean flag = false;
  
 
    public Bar() {
    }
  
 
    public String getName() {
        return this.name;
    }
  
 
    public void setName(final String name) {
        this.name = name;
    }
  
 
    public boolean isFlag() {
        return this.flag;
    }
  
 
    public void setFlag(final boolean flag) {
        this.flag = flag;
    }
}

 
　2.EJB(Enterprise Java Bean)
　　EJB是运行在一个J2EE服务器上的Java类，它用于处理业务逻辑的，应该是这样的：

　　　>有状态（Stateful）

　　　>无状态的(Stateless)

　　   >实体(Entity)

　　　>消息驱动Bean（Message Driven Beans）

 举例（无状态Bean）：

　

@Stateless
public class EmployeeServiceBean {
    @PersistenceContext
    EntityManager em;
 
    public void addEmployee(Employee emp) {
        em.persist(emp);
    }
}


Read more: http://www.javaexperience.com/difference-between-pojo-javabean-ejb/#ixzz3otv2sKDE
　　说明：因为EJB2.0和EJB被要求是实现EJBobject 接口和指明EJB的部署类型，所以在EJB3.0中引入了注解来简化开发步骤。

3.POJO(Plain Old Java Object)
　　一个POJO没有要求去实现了一个接口或者继承一个类，也没有任何的指导信息。POJO最大的不同之处就是它和EJB无关。Java是一个简化的JavaBean，我们之所以叫它是是简化的bean是因为它只用于装载数据而不用业务逻辑的处理。一个持久化的POJO就是PO，如果用于展示层那么它就是VO .

4.1.PO(persistant object ):持久化对象
　　持久对象,可以看成是与数据库中的表相映射的java对象。最简单的PO就是对应数据库中某个表中的一条记录，多个记录可以用PO的集合。PO中应该不包含任何对数据库的操作。 

4.2.VO(Value Object)
　　一个值对象就是一个含有值的对象，比如java.lang.Integer.VO:通常用于业务层之间的数据传递，和PO一样也是仅仅包含数据而已。但应是抽象出的业务对象,可以和表对应,也可以不,这根据业务的需要.个人觉得同DTO(数据传输对象),在web上传递。

4.3.DAO:data access object
　　数据访问对象，是一个sun的一个标准j2ee设计模式 ．此对象用于访问数据库。通常和PO结合使用，DAO中包含了各种数据库的操作方法。通过它的方法,结合PO对数据库进行相关的操作。夹在业务逻辑与数据 库资源中间。配合VO, 提供数据库的CRUD操作。

4.4.DO（Domain Object）
　　领域对象，就是从现实世界中抽象出来的有形或无形的业务实体。

4.5.VO（View Object）
　　视图对象，用于展示层，它的作用是把某个指定页面（或组件）的所有数据封装起来。

4.6. BO( Business object)
　　用于调用DAO的业务逻辑类，并且将PO和VO联合起来进行业务操作。

4.7.DTO(Data Transfer Object)
　　主要用于远程调用中的传输对象。比如说，一个100个字段的表就对应于PO中的100个属性，但是我们的接口只需要10个字段。那么我们就可以将只含有十个字段的DTO传递给客户端使用。这不会向客户端暴露表结构，一旦它和接口关联起来，那么它就是VO了。