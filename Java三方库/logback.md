## 1 简介

### 日志组件

logback 是一个开源的日志组件，是 log4j 的作者开发的用来替代 log4j 的。logback 由三个部分组成，logback-core, logback-classic, logback-access。

- 其中 logback-core 是其他两个模块的基础。
- logback-classic：它是 log4j 的一个改良版本，同时它完整实现了 slf4j API，使我们可以在其他日志系统，如 log4j 和 JDK14 Logging 中进行转换
- logback-access：访问模块和 Servlet 容器集成，提供通过 Http 来访问日志的功能

### 日志级别

级别包括：TRACE < DEBUG < INFO < WARN < ERROR

### 配置流程

1. 添加 maven 依赖
2. 查找配置文件。logback-spring.xml、logback.xml、BasicConfigurator。
3. 加载配置内容。configuration

```xml
<?xml version="1.0" encoding="UTF-8"?>
<configuration>
</configuration>
```

### maven 依赖

```xml
<!--log-->
<dependency>
  <groupId>org.slf4j</groupId>
  <artifactId>slf4j-api</artifactId>
  <version>1.7.21</version>
</dependency>

<dependency>
  <groupId>ch.qos.logback</groupId>
  <artifactId>logback-core</artifactId>
  <version>1.1.7</version>
</dependency>
<dependency>
  <groupId>ch.qos.logback</groupId>
  <artifactId>logback-classic</artifactId>
  <version>1.1.7</version>
</dependency>
```

## 2 配置内容

### configuration

日志配置的根节点

```
<configuration></configuration>
```

### contextName

<contextName>是<configuration>的子节点。各个 logger 都被关联到一个 loggerContext 中，loggerContext 负责制造 logger，也负责以树结构排列个 logger。

```
<contextName>atguiguSrb</contextName>
```

### property

<property>是<configuration>的子节点，用来定义变量。

<property> 有两个属性，name 和 value：name 的值是变量的名称，value 是变量的值。

通过<property>定义的值会被插入到 logger 上下文中。定义变量后，可以使“${}”来使用变量。

```xml
<!-- 日志的输出目录 -->
<property name="log.path" value="D:/project/finance/srb_log/core" />

<!--控制台日志格式：彩色日志-->
<!-- magenta:洋红 -->
<!-- boldMagenta:粗红-->
<!-- cyan:青色 -->
<!-- white:白色 -->
<!-- magenta:洋红 -->
<property name="CONSOLE_LOG_PATTERN"
          value="%yellow(%date{yyyy-MM-dd HH:mm:ss}) %highlight([%-5level]) %green(%logger) %msg%n"/>

<!--文件日志格式-->
<property name="FILE_LOG_PATTERN"
          value="%date{yyyy-MM-dd HH:mm:ss} [%-5level] %thread %file:%line %logger %msg%n" />

<!--编码-->
<property name="ENCODING"
          value="UTF-8" />
```

### appender

`<appender>`是`<configuration>`的子节点，是负责写日志的组件.主要用于指定日志输出的目的地，目的地可以是控制台、文件、远程套接字服务器、MySQL、PostreSQL、Oracle 和其他数据库、JMS 和远程 UNIX Syslog 守护进程等。

不同的 appender 有不同的属性可以配置

### ConsoleAppender

- `<appender>`有两个必要属性 name 和 class：name 指定 appender 名称，class 指定 appender 的全限定名
- `<encoder>`对日志进行格式化
  - `<pattern>`定义日志的具体输出格式
  - `<charset>`编码方式

```xml
<!-- 控制台日志 -->
<appender name="CONSOLE" class="ch.qos.logback.core.ConsoleAppender">
    <file>${log.path}/log.log</file>
    <append>true</append>
    <encoder>
        <pattern>${CONSOLE_LOG_PATTERN}</pattern>
        <charset>${ENCODING}</charset>
    </encoder>
    <filter class="ch.qos.logback.classic.filter.ThresholdFilter">
        <level>${logging.level}</level>
    </filter>
    <filter class="ch.qos.logback.classic.filter.LevelFilter">
        <level>ERROR</level>
        <onMatch>DENY</onMatch>
    </filter>
</appender>
```

输出模式说明

- 输出模式：%d{yyyy-MM-dd HH:mm:ss.SSS} [%thread] %-5level %logger{36} -%msg%n
- 输出模式解释：时间日期格式-调用的线程-日志界别-调用对象-日志信息-换行

```
%d{HH:mm:ss.SSS}：日志输出时间（red）
%thread：输出日志的进程名字，这在Web应用以及异步任务处理中很有用 （green）
%-5level：日志级别，并且使用5个字符靠左对齐 （highlight高亮蓝色）
%logger：日志输出类的名字 （boldMagenta粗体洋红色）
%msg：日志消息 （cyan蓝绿色）
%n：平台的换行符
```

过滤器说明
* filter可以过滤指定级别的日志进行打印

### FileAppender

- `<file>`表示日志文件的位置，如果上级目录不存在会自动创建，没有默认值。\
- `<append>`默认 true，日志被追加到文件结尾，如果是 false，服务重启后清空现存文件。

```xml
<!-- 文件日志 -->
<appender name="FILE" class="ch.qos.logback.core.FileAppender">
    <file>${log.path}/log.log</file>
    <append>true</append>
    <encoder>
        <pattern>${FILE_LOG_PATTERN}</pattern>
        <charset>${ENCODING}</charset>
    </encoder>
</appender>
```

### RollingFileAppender

表示滚动记录文件，先将日志记录到指定文件，当符合某个条件时，将旧日志备份到其他文件

- `<rollingPolicy>`是`<appender>`的子节点，用来定义滚动策略。

- TimeBasedRollingPolicy：最常用的滚动策略，根据时间来制定滚动策略。

- `<fileNamePattern>`：包含文件名及转换符， “%d”可以包含指定的时间格式，如：%d{yyyy-MM-dd}。如果直接使用 %d，默认格式是 yyyy-MM-dd。
- `<maxHistory>`：可选节点，控制保留的归档文件的最大数量，超出数量就删除旧文件。假设设置每个月滚动，且`<maxHistory>`是 6，则只保存最近 6 个月的文件，删除之前的旧文件。注意，删除旧文件是，那些为了归档而创建的目录也会被删除。

```xml
<appender name="ROLLING_FILE" class="ch.qos.logback.core.rolling.RollingFileAppender">
    <!--  要区别于其他的appender中的文件名字  -->
    <file>${log.path}/log-rolling.log</file>
    <encoder>
        <pattern>${FILE_LOG_PATTERN}</pattern>
        <charset>${ENCODING}</charset>
    </encoder>
    <!-- 设置滚动日志记录的滚动策略 -->
    <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
        <!-- 日志归档路径以及格式 -->
        <fileNamePattern>${log.path}/info/log-rolling-%d{yyyy-MM-dd}.log</fileNamePattern>
        <!--归档日志文件保留的最大数量-->
        <maxHistory>15</maxHistory>
    </rollingPolicy>

   <rollingPolicy class="ch.qos.logback.core.rolling.SizeAndTimeBasedRollingPolicy">
        <fileNamePattern>${log_path}/userlog-%d{yyyyMMddHHmm}-%i.log</fileNamePattern>
        <maxFileSize>300KB</maxFileSize>
        <maxHistory>60</maxHistory>
    </rollingPolicy>

</appender>
```

- 放在`<rollingPolicy>`的子节点的位置，基于实践策略的触发滚动策略`<maxFileSize>`设置触发滚动条件：单个文件大于 100M 时生成新的文件

### AsyncAppender

```
    <appender name="async" class="ch.qos.logback.classic.AsyncAppender">
        <!--指定某个具体的Appender实现-->
        <appender-ref ref="rolling"/>
    </appender>
```

### SiftingAppender
之前在介绍常用appender时已经记录过了，SiftingAppender可用于根据给定的运行时属性来分离(或筛选)日志记录。

比如：可以按照业务功能生成独立的日志文件、按照用户会话id为每个用户生成独立的日志文件等。

按照业务功能生成独立的日志文件
上面我们通过为每个业务类配置<logger>的方式，实现了按照业务功能生成独立的日志文件，下面我们使用SiftingAppender来实现此功能，代码如下：

修改下UserService：
```java
@Service
public class UserService {
 
    private static final Logger logger = LoggerFactory.getLogger(UserService.class);
 
    public void testLogger() throws InterruptedException {
        for (int i = 0; i < 10; i++) {
            Thread.sleep(2);
            MDC.put("logKey","userLog"); // logKey设置值后在logback.xml中使用
            logger.info("user logger!" + i);
        }
    }
```

```xml
 <property name="log_path" value="D:/logs"/>
 
    <appender name="SIFTING" class="ch.qos.logback.classic.sift.SiftingAppender">
        <discriminator>
            <key>logKey</key> <!-- logKey对应 MDC 中设置的值 -->
            <defaultValue>general</defaultValue><!-- 设置的默认值 -->
        </discriminator>
        <sift>
            <appender name="FILE-${logKey}"
                      class="ch.qos.logback.core.rolling.RollingFileAppender">
                <!-- ${logKey}取出 MDC 中设置的值 -->
                <file>${log_path}/db/${logKey}.log</file>
                <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
                    <fileNamePattern>${log_path}/db/${logKey}.%d{yyyyMMddHHmm}.log</fileNamePattern>
                    <maxHistory>60</maxHistory>
                </rollingPolicy>
                <encoder>
                    <pattern>%msg%n</pattern>
                </encoder>
            </appender>
        </sift>
    </appender>
 
    <root level="DEBUG">
        <appender-ref ref="SIFTING" />
    </root>
```

### logger

`<logger>`可以是`<configuration>`的子节点，用来设置日志打印级别、指定`<appender>`

- name：用来指定受此 logger 约束的某一个包或者具体的某一个.
- level：用来设置打印级别，大小写无关：TRACE, DEBUG, INFO, WARN, ERROR, ALL 和 OFF。默认继承上级的级别。logger 日志级别。级别包括：TRACE < DEBUG < INFO < WARN < ERROR，定义于 ch.qos.logback.classic.Level 类中。
- `<logger>`可以包含零个或多个`<appender-ref>`元素，标识这个 appender 将会添加到这个 logger


logger继承问题
* 根据name进行继承。name=com.ykl 继承了name=com继承了root
* 继承上级日志级别。logger 没有被分配级别，name 它将从有被分配级别的最近的父类那里继承级别，root logger 默认级别是 DEBUG。
* 向上传递日志信息。类似于拦截器，拦截到消息后是否会放回additivity="false"表示不放回。additivity="true"表示放回。root能够截取所有的消息。

```xml
<!-- 日志记录器  -->
<logger name="com.atguigu" level="INFO">
    <appender-ref ref="CONSOLE" />
    <appender-ref ref="FILE" />
</logger>
```

- logger 的取得：通过 org.slf4j.LoggerFactory 的 getLogger()方法取得。getLogger(Class obj)方式是通过传入一个类的形式来进行 logger 对象和类的绑定；getLogger(String name)方式是通过传入一个 contextName 的形式来指定一个 logger，用同一个名字调用该方法获取的永远都是同一个 logger 对象的引用。

### root

配置默认的日志打印

也是<loger>元素，但是它是根loger。只有一个level属性，应为已经被命名为"root".
level:用来设置打印级别，大小写无关：TRACE, DEBUG, INFO, WARN, ERROR, ALL 和 OFF，不能设置为INHERITED或者同义词NULL。默认是DEBUG。

* 没有设置addtivity，默认为true，将此loger的打印信息向上级传递；

```xml
    <root level="ALL">
        <appender-ref ref="async"></appender-ref>
    </root>
```

## 3 配置文件

### 配置文件实例

```xml
<?xml version="1.0" encoding="UTF-8"?>
<configuration>

    <contextName>atguiguSrb</contextName>

    <!-- 日志的输出目录 -->
    <property name="log.path" value="D:/project_log/srb_log/220608" />

    <!--控制台日志格式：彩色日志-->
    <!-- magenta:洋红 -->
    <!-- boldMagenta:粗红-->
    <!-- cyan:青色 -->
    <!-- white:白色 -->
    <!-- magenta:洋红 -->
    <property name="CONSOLE_LOG_PATTERN"
              value="%yellow(%date{yyyy-MM-dd HH:mm:ss}) %highlight([%-5level]) %green(%logger) %msg%n"/>

    <!--文件日志格式-->
    <property name="FILE_LOG_PATTERN"
              value="%date{yyyy-MM-dd HH:mm:ss} [%-5level] %thread %file:%line %logger %msg%n" />

    <!--编码-->
    <property name="ENCODING"
              value="UTF-8" />


    <!-- 控制台日志 -->
    <appender name="CONSOLE" class="ch.qos.logback.core.ConsoleAppender">
        <encoder>
            <pattern>${CONSOLE_LOG_PATTERN}</pattern>
            <charset>${ENCODING}</charset>
        </encoder>
    </appender>

    <!-- 文件日志 -->
    <appender name="FILE" class="ch.qos.logback.core.FileAppender">
        <file>${log.path}/log.log</file>
        <append>true</append>
        <encoder>
            <pattern>${FILE_LOG_PATTERN}</pattern>
            <charset>${ENCODING}</charset>
        </encoder>
    </appender>

    <appender name="ROLLING_FILE" class="ch.qos.logback.core.rolling.RollingFileAppender">

        <!--  要区别于其他的appender中的文件名字  -->
        <file>${log.path}/log-rolling.log</file>
        <encoder>
            <pattern>${FILE_LOG_PATTERN}</pattern>
            <charset>${ENCODING}</charset>
        </encoder>


        <!-- 设置滚动日志记录的滚动策略 -->
        <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
            <!-- 日志归档路径以及格式 -->
            <fileNamePattern>${log.path}/info/log-rolling-%d{yyyy-MM-dd}.%i.log</fileNamePattern>
            <!--归档日志文件保留的最大数量-->
            <maxHistory>15</maxHistory>

            <timeBasedFileNamingAndTriggeringPolicy class="ch.qos.logback.core.rolling.SizeAndTimeBasedFNATP">
                <maxFileSize>1KB</maxFileSize>
            </timeBasedFileNamingAndTriggeringPolicy>
        </rollingPolicy>

    </appender>

    <!-- 日志记录器  -->
    <!--    <logger name="com.atguigu" level="INFO">-->
    <!--        <appender-ref ref="CONSOLE" />-->
    <!--        <appender-ref ref="FILE" />-->
    <!--    </logger>-->

    <!-- 开发环境和测试环境 -->
    <springProfile name="dev,test">
        <logger name="com.atguigu" level="INFO">
            <appender-ref ref="CONSOLE" />
            <appender-ref ref="ROLLING_FILE" />
        </logger>
    </springProfile>

    <!-- 生产环境 -->
    <springProfile name="prod">
        <logger name="com.atguigu" level="ERROR">
            <appender-ref ref="CONSOLE" />
            <appender-ref ref="FILE" />
        </logger>
    </springProfile>
</configuration>
```

### 配置文件实例

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!-- scan属性未true时，如果配置文档发生改变将会进行重新加载 -->
<!-- scanPeriod属性设置监测配置文件修改的时间间隔，默认单位为毫秒，在scan为true时才生效 -->
<!-- debug属性如果为true时，会打印出logback内部的日志信息 -->
<configuration scan="true" scanPeriod="60 seconds" debug="false">
    <!-- 定义参数常量 -->
    <!-- 日志级别：TRACE<DEBUG<INFO<WARN<ERROR，其中常用的是DEBUG、INFO和ERROR -->
    <property name="log.level" value="debug" />
    <!-- 文件保留时间 -->
    <property name="log.maxHistory" value="30" />
    <!-- 日志存储路径 -->
    <property name="log.filePath" value="${catalina.base}/logs/webapps" />
    <!-- 日志的显式格式 -->
    <property name="log.pattern"
              value="%d{yyyy-MM-dd HH:mm:ss.SSS} [%thread] %-5level %logger{50}-%msg%n"></property>
    <!-- 用于说明输出介质，此处说明控制台输出 -->
    <appender name="consoleAppender"
              class="ch.qos.logback.core.ConsoleAppender">
        <!-- 类似于layout，除了将时间转化为数组，还会将转换后的数组输出到相应的文件中 -->
        <encoder>
            <!-- 定义日志的输出格式 -->
            <pattern>${log.pattern}</pattern>
        </encoder>
    </appender>
    <!-- DEBUG，表示文件随着时间的推移按时间生成日志文件 -->
    <appender name="debugAppender"
              class="ch.qos.logback.core.rolling.RollingFileAppender">
        <!-- 文件路径 -->
        <file>${log.filePath}/debug.log</file>
        <!-- 滚动策略 -->
        <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
            <!-- 设置文件名称 -->
            <fileNamePattern>
                ${log.filePath}/debug/debug.%d{yyyy-MM-dd}.log.gz
            </fileNamePattern>
            <!-- 设置最大保存周期 -->
            <MaxHistory>${log.maxHistory}</MaxHistory>
        </rollingPolicy>
        <encoder>
            <pattern>${log.pattern}</pattern>
        </encoder>
        <!-- 过滤器，过滤掉不是指定日志水平的日志 -->
        <filter class="ch.qos.logback.classic.filter.LevelFilter">
            <!-- 设置日志级别 -->
            <level>DEBUG</level>
            <!-- 如果跟该日志水平相匹配，则接受 -->
            <onMatch>ACCEPT</onMatch>
            <!-- 如果跟该日志水平不匹配，则过滤掉 -->
            <onMismatch>DENY</onMismatch>
        </filter>
    </appender>
    <!-- INFO，表示文件随着时间的推移按时间生成日志文件 -->
    <appender name="infoAppender"
              class="ch.qos.logback.core.rolling.RollingFileAppender">
        <!-- 文件路径 -->
        <file>${log.filePath}/info.log</file>
        <!-- 滚动策略 -->
        <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
            <!-- 设置文件名称 -->
            <fileNamePattern>
                ${log.filePath}/info/info.%d{yyyy-MM-dd}.log.gz
            </fileNamePattern>
            <!-- 设置最大保存周期 -->
            <MaxHistory>${log.maxHistory}</MaxHistory>
        </rollingPolicy>
        <encoder>
            <pattern>${log.pattern}</pattern>
        </encoder>
        <!-- 过滤器，过滤掉不是指定日志水平的日志 -->
        <filter class="ch.qos.logback.classic.filter.LevelFilter">
            <!-- 设置日志级别 -->
            <level>INFO</level>
            <!-- 如果跟该日志水平相匹配，则接受 -->
            <onMatch>ACCEPT</onMatch>
            <!-- 如果跟该日志水平不匹配，则过滤掉 -->
            <onMismatch>DENY</onMismatch>
        </filter>
    </appender>
    <!-- ERROR，表示文件随着时间的推移按时间生成日志文件 -->
    <appender name="errorAppender"
              class="ch.qos.logback.core.rolling.RollingFileAppender">
        <!-- 文件路径 -->
        <file>${log.filePath}/error.log</file>
        <!-- 滚动策略 -->
        <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
            <!-- 设置文件名称 -->
            <fileNamePattern>
                ${log.filePath}/error/error.%d{yyyy-MM-dd}.log.gz
            </fileNamePattern>
            <!-- 设置最大保存周期 -->
            <MaxHistory>${log.maxHistory}</MaxHistory>
        </rollingPolicy>
        <encoder>
            <pattern>${log.pattern}</pattern>
        </encoder>
        <!-- 过滤器，过滤掉不是指定日志水平的日志 -->
        <filter class="ch.qos.logback.classic.filter.LevelFilter">
            <!-- 设置日志级别 -->
            <level>ERROR</level>
            <!-- 如果跟该日志水平相匹配，则接受 -->
            <onMatch>ACCEPT</onMatch>
            <!-- 如果跟该日志水平不匹配，则过滤掉 -->
            <onMismatch>DENY</onMismatch>
        </filter>
    </appender>
    <!-- 用于存放日志对象，同时指定关联的package位置 -->
    <!-- name指定关联的package -->
    <!-- level表明指记录哪个日志级别以上的日志 -->
    <!-- appender-ref指定logger向哪个文件输出日志信息 -->
    <!-- additivity为true时，logger会把根logger的日志输出地址加入进来，但logger水平不依赖于根logger -->
    <logger name="com.campus.o2o" level="${log.level}" additivity="true">
        <appender-ref ref="debugAppender" />
        <appender-ref ref="infoAppender" />
        <appender-ref ref="errorAppender" />
    </logger>
    <!-- 特殊的logger，根logger -->
    <root lever="info">
        <!-- 指定默认的日志输出 -->
        <appender-ref ref="consoleAppender" />
    </root>
</configuration>
```
