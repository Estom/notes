
## 16 Springboot JPA注解
### @Entity
### @Table(name=”“)
表明这是一个实体类。一般用于jpa这两个注解一般一块使用，但是如果表名和实体类名相同的话，@Table可以省略

### @MappedSuperClass

用在确定是父类的entity上。父类的属性子类可以继承。

### @NoRepositoryBean
一般用作父类的repository，有这个注解，spring不会去实例化该repository。

### @Column
如果字段名与列名相同，则可以省略。

### @Id
表示该属性为主键。

### @GeneratedValue

@GeneratedValue(strategy = GenerationType.SEQUENCE,generator = “repair_seq”)
表示主键生成策略是sequence（可以为Auto、IDENTITY、native等，Auto表示可在多个数据库间切换），指定sequence的名字是repair_seq。

### @SequenceGeneretor

@SequenceGeneretor(name = “repair_seq”, sequenceName = “seq_repair”, allocationSize = 1)
name为sequence的名称，以便使用，sequenceName为数据库的sequence名称，两个名称可以一致。

### @Transient
表示该属性并非一个到数据库表的字段的映射,ORM框架将忽略该属性。如果一个属性并非数据库表的字段映射,就务必将其标示为@Transient,否则,ORM框架默认其注解为@Basic。@Basic(fetch=FetchType.LAZY)：标记可以指定实体属性的加载方[cnblogs.com/GoCircle]式

### @JsonIgnore
作用是json序列化时将Java bean中的一些属性忽略掉,序列化和反序列化都受影响。

### @JoinColumn（name=”loginId”）
[欢迎转载听雨的人博客cnblogs.com/GoCircle]一对一：本表中指向另一个表的外键。一对多：另一个表指向本表的外键。

### @OneToOne、@OneToMany、@ManyToOne


对应hibernate配置文件中的一对一，一对多，多对一。

