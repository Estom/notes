

### mybatis-configuration.xml

|  设置名 |  描述 |  有效值 |  默认值 |
|---|---|---|---|
|  ​cacheEnabled​ |  全局性地开启或关闭所有映射器配置文件中已配置的任何缓存 |  true | false |  true |
|  ​lazyLoadingEnabled​ |  延迟加载的全局开关。当开启时，所有关联对象都会延迟加载。特定关联关系中可通过设置​fetchType​属性来覆盖该项的开关状态 |  true | false |  false |
|  ​aggressiveLazyLoading​ |  开启时，任一方法的调用都会加载该对象的所有延迟加载属性。否则，每个延迟加载属性会按需加载 |  true | false |  false(在 3.4.1 及之前的版本中默认为 true) |
|  ​multipleResultSetsEnabled​ |  是否允许单个语句返回多结果集(需要数据库驱动支持) |  true | false |  true |
|  ​useColumnLabel​ |  使用列标签代替列明。实际表现依赖于数据库驱动，具体可参考数据库驱动的相关文档，或通过对比测试来观察 |  true | false |  true |
|  ​useGeneratedKeys​ |  允许​JDBC​支持自动生成主键，需要数据库驱动支持。如果设置为true，将强制使用自动生成主键。尽管一些数据库驱动不支持此特性，但仍可正常工作(如​Derby​) |  true | false |  false |
|  ​autoMappingBehavior​ |  指定 MyBatis 应如何自动映射列到字段或属性。 ​NONE ​表示关闭自动映射；​PARTIAL ​只会自动映射没有定义嵌套结果映射的字段。 ​FULL ​会自动映射任何复杂的结果集（无论是否嵌套）。 |  NONE, PARTIAL, FULL |  PARTIAL |
|  ​autoMappingUnknownColumnBehavior​ |  指定发现自动映射目标未知列（或未知属性类型）的行为。 ​NONE​: 不做任何反应
 ​WARNING​: 输出警告日志（'org.apache.ibatis.session.AutoMappingUnknownColumnBehavior' 的日志等级必须设置为 WARN） ​FAILING​: 映射失败 (抛出 SqlSessionException) |  NONE, WARNING, FAILING |  NONE |
|  ​defaultExecutorType​ |  配置默认的执行器。​SIMPLE ​就是普通的执行器；​REUSE ​执行器会重用预处理语句（PreparedStatement）； ​BATCH ​执行器不仅重用语句还会执行批量更新。 |  SIMPLE REUSE BATCH |  SIMPLE |
|  ​defaultStatementTimeout​ |  设置超时时间，它决定数据库驱动等待数据库响应的秒数。 |  任意正整数 |  未设置 (null) |
|  ​defaultFetchSize​ |  为驱动的结果集获取数量（​fetchSize​）设置一个建议值。此参数只可以在查询设置中被覆盖。 |  任意正整数 |  未设置 (null) |
|  ​defaultResultSetType​ |  指定语句默认的滚动策略。（新增于 3.5.2） |  FORWARD_ONLY | SCROLL_SENSITIVE | SCROLL_INSENSITIVE | DEFAULT（等同于未设置） |  未设置 (null) |
|  ​safeRowBoundsEnabled​ |  是否允许在嵌套语句中使用分页（​RowBounds​）。如果允许使用则设置为 false。 |  true | false |  False |
|  ​safeResultHandlerEnabled​ |  是否允许在嵌套语句中使用结果处理器（​ResultHandler​）。如果允许使用则设置为 false。 |  true | false |  True |
|  ​mapUnderscoreToCamelCase​ |  是否开启驼峰命名自动映射，即从经典数据库列名 ​A_COLUMN ​映射到经典 Java 属性名 ​aColumn​。 |  true | false |  False |
|  ​localCacheScope​ |  MyBatis 利用本地缓存机制（Local Cache）防止循环引用和加速重复的嵌套查询。 默认值为 ​SESSION​，会缓存一个会话中执行的所有查询。 若设置值为 ​STATEMENT​，本地缓存将仅用于执行语句，对相同 ​SqlSession ​的不同查询将不会进行缓存。 |  SESSION | STATEMENT |  SESSION |
|  ​jdbcTypeForNull​ |  当没有为参数指定特定的 ​JDBC类型时，空值的默认 ​JDBC类型。 某些数据库驱动需要指定列的 ​JDBC类型，多数情况直接用一般类型即可，比如 ​NULL​、​VARCHAR ​或 ​OTHER​。 |  JdbcType 常量，常用值：NULL、VARCHAR 或 OTHER。 |  OTHER |
|  ​lazyLoadTriggerMethods​ |  指定对象的哪些方法触发一次延迟加载。 |  用逗号分隔的方法列表。 |  equals,clone,hashCode,toString |
|  ​defaultScriptingLanguage​ |  指定动态 SQL 生成使用的默认脚本语言。 |  一个类型别名或全限定类名。 |  org.apache.ibatis.scripting.xmltags.XMLLanguageDriver |
|  ​defaultEnumTypeHandler​ |  指定​Enum​使用的默认​TypeHandler​。（新增于 3.4.5） |  一个类型别名或全限定类名。 |  org.apache.ibatis.type.EnumTypeHandler |
|  ​callSettersOnNulls​ |  指定当结果集中值为 ​null ​的时候是否调用映射对象的 ​setter​（map 对象时为 ​put​）方法，这在依赖于 ​Map.keySet()​ 或 null 值进行初始化时比较有用。注意基本类型（int、boolean 等）是不能设置成 null 的。 |  true | false |  false |
|  ​returnInstanceForEmptyRow​ |  当返回行的所有列都是空时，MyBatis默认返回 null。 当开启这个设置时，MyBatis会返回一个空实例。 请注意，它也适用于嵌套的结果集（如集合或关联）。（新增于 3.4.2） |  true | false |  false |
|  ​logPrefix​ |  指定 MyBatis 增加到日志名称的前缀。 |  任何字符串 |  未设置 |
|  ​logImpl​ |  指定 MyBatis 所用日志的具体实现，未指定时将自动查找。 |  SLF4J | LOG4J(deprecated since 3.5.9) | LOG4J2 | JDK_LOGGING | COMMONS_LOGGING | STDOUT_LOGGING | NO_LOGGING |  未设置 |
|  ​proxyFactory​ |  指定 Mybatis 创建可延迟加载对象所用到的代理工具。 |  CGLIB | JAVASSIST |  JAVASSIST （MyBatis 3.3 以上） |
|  ​vfsImpl​ |  指定 VFS 的实现 |  自定义 VFS 的实现的类全限定名，以逗号分隔。 |  未设置 |
|  ​useActualParamName​ |  允许使用方法签名中的名称作为语句参数名称。 为了使用该特性，你的项目必须采用 Java 8 编译，并且加上 ​-parameters​ 选项。（新增于 3.4.1） |  true | false |  true |
|  ​configurationFactory​ |  指定一个提供 ​Configuration实例的类。 这个被返回的 ​Configuration ​实例用来加载被反序列化对象的延迟加载属性值。 这个类必须包含一个签名为​static Configuration getConfiguration()​ 的方法。（新增于 3.2.3） |  一个类型别名或完全限定类名。 |  未设置 |
|  ​shrinkWhitespacesInSql​ |  从SQL中删除多余的空格字符。请注意，这也会影响SQL中的文字字符串。 (新增于 3.5.5) |  true | false |  false |
|  ​defaultSqlProviderType​ |  指定一个包含提供程序方法的 sql 提供程序类（自 3.5.6 起）。 当省略这些属性时，此类适用于 sql 提供程序注释（例如 ​@SelectProvider​）上的类型（或值）属性。 |  类型别名或完全限定的类名 |  未设置 |
|  ​nullableOnForEach​ |  指定'​foreach​'标记上的'​nullable​'属性的默认值。（自 3.5.9 起） |  true | false |  false |



### 配置多数据源——独立数据源
1）两个或多个数据库没有相关性，各自独立，其实这种可以作为两个项目来开发。比如在游戏开发中一个数据库是平台数据库，其它还有平台下的游戏对应的数据库；

2）两个或多个数据库是master-slave的关系，比如有mysql搭建一个 master-master，其后又带有多个slave；或者采用MHA搭建的master-slave复制；

目前我所知道的 Spring 多数据源的搭建大概有两种方式，可以根据多数据源的情况进行选择。

采用spring配置文件直接配置多个数据源.比如针对两个数据库没有相关性的情况，可以采用直接在spring的配置文件中配置多个数据源，然后分别进行事务的配置，如下所示：


```
    <context:component-scan base-package="net.aazj.service,net.aazj.aop" />
    <context:component-scan base-package="net.aazj.aop" />
    <!-- 引入属性文件 -->
    <context:property-placeholder location="classpath:config/db.properties" />

    <!-- 配置数据源 -->
    <bean name="dataSource" class="com.alibaba.druid.pool.DruidDataSource" init-method="init" destroy-method="close">
        <property name="url" value="${jdbc_url}" />
        <property name="username" value="${jdbc_username}" />
        <property name="password" value="${jdbc_password}" />
        <!-- 初始化连接大小 -->
        <property name="initialSize" value="0" />
        <!-- 连接池最大使用连接数量 -->
        <property name="maxActive" value="20" />
        <!-- 连接池最大空闲 -->
        <property name="maxIdle" value="20" />
        <!-- 连接池最小空闲 -->
        <property name="minIdle" value="0" />
        <!-- 获取连接最大等待时间 -->
        <property name="maxWait" value="60000" />
    </bean>
    
    <bean id="sqlSessionFactory" class="org.mybatis.spring.SqlSessionFactoryBean">
      <property name="dataSource" ref="dataSource" />
      <property name="configLocation" value="classpath:config/mybatis-config.xml" />
      <property name="mapperLocations" value="classpath*:config/mappers/**/*.xml" />
    </bean>
    
    <!-- Transaction manager for a single JDBC DataSource -->
    <bean id="transactionManager" class="org.springframework.jdbc.datasource.DataSourceTransactionManager">
        <property name="dataSource" ref="dataSource" />
    </bean>
    
    <!-- 使用annotation定义事务 -->
    <tx:annotation-driven transaction-manager="transactionManager" /> 
    
    <bean class="org.mybatis.spring.mapper.MapperScannerConfigurer">
      <property name="basePackage" value="net.aazj.mapper" />
      <property name="sqlSessionFactoryBeanName" value="sqlSessionFactory"/>
    </bean>

    <!-- Enables the use of the @AspectJ style of Spring AOP -->
    <aop:aspectj-autoproxy/>
    
    <!-- ===============第二个数据源的配置=============== -->
    <bean name="dataSource_2" class="com.alibaba.druid.pool.DruidDataSource" init-method="init" destroy-method="close">
        <property name="url" value="${jdbc_url_2}" />
        <property name="username" value="${jdbc_username_2}" />
        <property name="password" value="${jdbc_password_2}" />
        <!-- 初始化连接大小 -->
        <property name="initialSize" value="0" />
        <!-- 连接池最大使用连接数量 -->
        <property name="maxActive" value="20" />
        <!-- 连接池最大空闲 -->
        <property name="maxIdle" value="20" />
        <!-- 连接池最小空闲 -->
        <property name="minIdle" value="0" />
        <!-- 获取连接最大等待时间 -->
        <property name="maxWait" value="60000" />
    </bean>
    
    <bean id="sqlSessionFactory_slave" class="org.mybatis.spring.SqlSessionFactoryBean">
      <property name="dataSource" ref="dataSource_2" />
      <property name="configLocation" value="classpath:config/mybatis-config-2.xml" />
      <property name="mapperLocations" value="classpath*:config/mappers2/**/*.xml" />
    </bean>
    
    <!-- Transaction manager for a single JDBC DataSource -->
    <bean id="transactionManager_2" class="org.springframework.jdbc.datasource.DataSourceTransactionManager">
        <property name="dataSource" ref="dataSource_2" />
    </bean>
    
    <!-- 使用annotation定义事务 -->
    <tx:annotation-driven transaction-manager="transactionManager_2" /> 
    
    <bean class="org.mybatis.spring.mapper.MapperScannerConfigurer">
      <property name="basePackage" value="net.aazj.mapper2" />
      <property name="sqlSessionFactoryBeanName" value="sqlSessionFactory_2"/>
    </bean>
```


### 配置数据源——主从数据源