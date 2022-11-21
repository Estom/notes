https://blog.csdn.net/qq_43842093/article/details/122810961

### appender

* ConsoleAppender: 日志输出到控制台； FileAppender：输出到文件；
* RollingFileAppender：输出到文件，文件达到一定阈值时，自动备份日志文件;
* DailyRollingFileAppender：可定期备份日志文件，默认一天一个文件，也可设置为每分钟一个、每小时一个；
* WriterAppender：可自定义日志输出位置。



### 日志级别

一般日志级别包括：ALL，DEBUG， INFO， WARN， ERROR，FATAL，OFF

### 输出格式

1. org.apache.log4j.HTMLLayout（以HTML表格形式布局），
2. org.apache.log4j.PatternLayout（可以灵活地指定布局模式），
3. org.apache.log4j.SimpleLayout（包含日志信息的级别和信息字符串），
4. org.apache.log4j.TTCCLayout（包含日志产生的时间、线程、类别等等信息）

```
-X号: X信息输出时左对齐；  
%p: 输出日志信息优先级，即DEBUG，INFO，WARN，ERROR，FATAL,  
%d: 输出日志时间点的日期或时间，默认格式为ISO8601，也可以在其后指定格式，比如：%d{yyy MMM dd HH:mm:ss,SSS}，输出类似：2002年10月18日 22：10：28，921  
%r: 输出自应用启动到输出该log信息耗费的毫秒数  
%c: 输出日志信息所属的类目，通常就是所在类的全名  
%t: 输出产生该日志事件的线程名  
%l: 输出日志事件的发生位置，相当于%C.%M(%F:%L)的组合,包括类目名、发生的线程，以及在代码中的行数。举例：Testlog4.main (TestLog4.java:10)  
%x: 输出和当前线程相关联的NDC(嵌套诊断环境),尤其用到像java servlets这样的多客户多线程的应用中。  
%%: 输出一个"%"字符  
%F: 输出日志消息产生时所在的文件名称  
%L: 输出代码中的行号  
%m: 输出代码中指定的消息,产生的日志具体信息  
%n: 输出一个回车换行符，Windows平台为"/r/n"，Unix平台为"/n"输出日志信息换行  
可以在%与模式字符之间加上修饰符来控制其最小宽度、最大宽度、和文本的对齐方式。如：  
1)%20c：指定输出category的名称，最小的宽度是20，如果category的名称小于20的话，默认的情况下右对齐。  
2)%-20c:指定输出category的名称，最小的宽度是20，如果category的名称小于20的话，"-"号指定左对齐。  
3)%.30c:指定输出category的名称，最大的宽度是30，如果category的名称大于30的话，就会将左边多出的字符截掉，但小于30的话也不会有空格。  
4)%20.30c:如果category的名称小于20就补空格，并且右对齐，如果其名称长于30字符，就从左边较远输出的字符截掉。
```

### 配置文件头

```
<?xml version="1.0" encoding="UTF-8"?>   

//这行修改
<!DOCTYPE log4j:configuration SYSTEM "log4j.dtd">

<log4j:configuration xmlns:log4j='http://jakarta.apache.org/log4j/'>

或者

<?xml version="1.0" encoding="UTF-8"?>   

//改为这个
<!DOCTYPE log4j:configuration PUBLIC
  "-//APACHE//DTD LOG4J 1.2//EN" "http://logging.apache.org/log4j/1.2/apidocs/org/apache/log4j/xml/doc-files/log4j.dtd">

<log4j:configuration xmlns:log4j="http://jakarta.apache.org/log4j/">
```

### XML配置文件实例
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!--<!DOCTYPE log4j:configuration SYSTEM "http://logging.apache.org/log4j/1.2/apidocs/org/apache/log4j/xml/doc-files/log4j.dtd">-->

<!DOCTYPE log4j:configuration PUBLIC "-//APACHE//DTD LOG4J 1.2//EN" "log4j.dtd">
<log4j:configuration xmlns:log4j="http://jakarta.apache.org/log4j/">


    <!-- 日志输出到控制台 -->
    <appender name="console" class="org.apache.log4j.ConsoleAppender">
        <!-- 日志输出格式 -->
        <layout class="org.apache.log4j.PatternLayout">
            <param name="ConversionPattern" value="[日志信息优先级：%p][输出自应用启动到输出该log信息耗费的毫秒数：%r][%d{yyyy-MM-dd HH:mm:ss SSS}][日志信息所属的类目，通常就是所在类的全名：%c]-[产生该日志事件的线程名:%t]-[代码中指定的消息,产生的日志具体信息:%m]%n-[日志事件的发生位置:%l]"/>
        </layout>

        <!--过滤器设置输出的级别-->
        <filter class="org.apache.log4j.varia.LevelRangeFilter">
            <!-- 设置日志输出的最小级别 -->
            <param name="levelMin" value="INFO"/>
            <!-- 设置日志输出的最大级别 -->
            <param name="levelMax" value="ERROR"/>
        </filter>
    </appender>

    <!-- 输出日志到文件 -->
    <appender name="fileAppender" class="org.apache.log4j.FileAppender">
        <!-- 输出文件全路径名-->
        <param name="File" value="/logs/fileAppender.log"/>
        <!--是否在已存在的文件追加写：默认时true，若为false则每次启动都会删除并重新新建文件-->
        <param name="Append" value="false"/>
        <param name="Threshold" value="INFO"/>
        <!--是否启用缓存，默认false-->
        <param name="BufferedIO" value="false"/>
        <!--缓存大小，依赖上一个参数(bufferedIO), 默认缓存大小8K  -->
        <param name="BufferSize" value="512"/>
        <!-- 日志输出格式 -->
        <layout class="org.apache.log4j.PatternLayout">
            <param name="ConversionPattern" value="[日志信息优先级：%p][输出自应用启动到输出该log信息耗费的毫秒数：%r][%d{yyyy-MM-dd HH:mm:ss SSS}][日志信息所属的类目，通常就是所在类的全名：%c]-[产生该日志事件的线程名:%t]-[代码中指定的消息,产生的日志具体信息:%m]%n-[日志事件的发生位置:%l]"/>
        </layout>
    </appender>


    <!-- 输出日志到文件，当文件大小达到一定阈值时，自动备份 -->
    <!-- FileAppender子类 -->
    <appender name="rollingAppender" class="org.apache.log4j.RollingFileAppender">
        <!-- 日志文件全路径名 -->
        <param name="File" value="/logs/RollingFileAppender.log" />
        <!--是否在已存在的文件追加写：默认时true，若为false则每次启动都会删除并重新新建文件-->
        <param name="Append" value="true" />
        <!-- 保存备份日志的最大个数，默认值是：1  -->
        <param name="MaxBackupIndex" value="10" />
        <!-- 设置当日志文件达到此阈值的时候自动回滚，单位可以是KB，MB，GB，默认单位是KB，默认值是：10MB -->
            <param name="MaxFileSize" value="10MB" />
        <!-- 设置日志输出的样式 -->`
        <layout class="org.apache.log4j.PatternLayout">
            <!-- 日志输出格式 -->
            <param name="ConversionPattern" value="[日志信息优先级：%p][输出自应用启动到输出该log信息耗费的毫秒数：%r][%d{yyyy-MM-dd HH:mm:ss SSS}][日志信息所属的类目，通常就是所在类的全名：%c]-[产生该日志事件的线程名:%t]-[代码中指定的消息,产生的日志具体信息:%m]%n-[日志事件的发生位置:%l]" />
        </layout>
    </appender>


    <!-- 日志输出到文件，可以配置多久产生一个新的日志信息文件 -->
    <appender name="dailyRollingAppender" class="org.apache.log4j.DailyRollingFileAppender">
        <!-- 文件文件全路径名 -->
        <param name="File" value="/logs/dailyRollingAppender.log"/>
        <param name="Append" value="true" />
        <!-- 设置日志备份频率，默认：为每天一个日志文件 -->
        <param name="DatePattern" value="'.'yyyy-MM-dd'.log'" />

        <!--每分钟一个备份-->
        <!--<param name="DatePattern" value="'.'yyyy-MM-dd-HH-mm'.log'" />-->
        <layout class="org.apache.log4j.PatternLayout">
            <param name="ConversionPattern" value="[日志信息优先级：%p][输出自应用启动到输出该log信息耗费的毫秒数：%r][%d{yyyy-MM-dd HH:mm:ss SSS}][日志信息所属的类目，通常就是所在类的全名：%c]-[产生该日志事件的线程名:%t]-[代码中指定的消息,产生的日志具体信息:%m]%n-[日志事件的发生位置:%l]"/>
        </layout>
    </appender>


    <!--
       1. 指定logger的设置，additivity是否遵循缺省的继承机制
       2. 当additivity="false"时，root中的配置就失灵了，不遵循缺省的继承机制
   -->
    <logger name="logTest" additivity="false">
        <level value ="debug"/>
        <appender-ref ref="dailyRollingAppender"/>
    </logger>

    <!-- 根logger的设置，若代码中未找到指定的logger，则会根据继承机制，使用根logger-->
    <root>
        <level value ="debug"/>
        <appender-ref ref="console"/>
        <appender-ref ref="fileAppender"/>
        <appender-ref ref="rollingAppender"/>
        <appender-ref ref="dailyRollingAppender"/>
    </root>

</log4j:configuration>
```


### properties配置文件


* 配置根Logger，Log4j建议只使用四个级别，优 先级从高到低分别是ERROR、WARN、INFO、DEBUG。

```
log4j.rootLogger = [ level ] , appenderName, appenderName, …
```

* 配置appender

```
org.apache.log4j.ConsoleAppender（控制台），  
org.apache.log4j.FileAppender（文件），  
org.apache.log4j.DailyRollingFileAppender（每天产生一个日志文件），  
org.apache.log4j.RollingFileAppender（文件大小到达指定尺寸的时候产生一个新的文件），  
org.apache.log4j.WriterAppender（将日志信息以流格式发送到任意指定的地方）
```

* 配置日志信息的格式

```
log4j.appender.appenderName.layout = fully.qualified.name.of.layout.class  
log4j.appender.appenderName.layout.option1 = value1  
…  log4j.appender.appenderName.layout.option = valueN

org.apache.log4j.HTMLLayout（以HTML表格形式布局），  
org.apache.log4j.PatternLayout（可以灵活地指定布局模式），  
org.apache.log4j.SimpleLayout（包含日志信息的级别和信息字符串），  
org.apache.log4j.TTCCLayout（包含日志产生的时间、线程、类别等等信息）

%p 输出优先级，即DEBUG，INFO，WARN，ERROR，FATAL  
%r 输出自应用启动到输出该log信息耗费的毫秒数  
%c 输出所属的类目，通常就是所在类的全名  
%t 输出产生该日志事件的线程名  
%n 输出一个回车换行符，Windows平台为“rn”，Unix平台为“n”  
%d 输出日志时间点的日期或时间，默认格式为ISO8601，也可以在其后指定格式，比如：%d{yyy MMM dd HH:mm:ss,SSS}，输出类似：2002年10月18日 22：10：28，921  
%l 输出日志事件的发生位置，包括类目名、发生的线程，以及在代码中的行数。举例：Testlog4.main(TestLog4.java:10)
```

```properties
log4j.rootLogger=DEBUG,console,dailyFile,im
log4j.additivity.org.apache=true

# 控制台(console)
log4j.appender.console=org.apache.log4j.ConsoleAppender
log4j.appender.console.Threshold=DEBUG
log4j.appender.console.ImmediateFlush=true
log4j.appender.console.Target=System.err
log4j.appender.console.layout=org.apache.log4j.PatternLayout
log4j.appender.console.layout.ConversionPattern=[%-5p] %d(%r) --> [%t] %l: %m %x %n
# 日志文件(logFile)
log4j.appender.logFile=org.apache.log4j.FileAppender
log4j.appender.logFile.Threshold=DEBUG
log4j.appender.logFile.ImmediateFlush=true
log4j.appender.logFile.Append=true
log4j.appender.logFile.File=D:/logs/log.log4j
log4j.appender.logFile.layout=org.apache.log4j.PatternLayout
log4j.appender.logFile.layout.ConversionPattern=[%-5p] %d(%r) --> [%t] %l: %m %x %n
# 回滚文件(rollingFile)
log4j.appender.rollingFile=org.apache.log4j.RollingFileAppender
log4j.appender.rollingFile.Threshold=DEBUG
log4j.appender.rollingFile.ImmediateFlush=true
log4j.appender.rollingFile.Append=true
log4j.appender.rollingFile.File=D:/logs/log.log4j
log4j.appender.rollingFile.MaxFileSize=200KB
log4j.appender.rollingFile.MaxBackupIndex=50
log4j.appender.rollingFile.layout=org.apache.log4j.PatternLayout
log4j.appender.rollingFile.layout.ConversionPattern=[%-5p] %d(%r) --> [%t] %l: %m %x %n
# 定期回滚日志文件(dailyFile)
log4j.appender.dailyFile=org.apache.log4j.DailyRollingFileAppender
log4j.appender.dailyFile.Threshold=DEBUG
log4j.appender.dailyFile.ImmediateFlush=true
log4j.appender.dailyFile.Append=true
log4j.appender.dailyFile.File=D:/logs/log.log4j
log4j.appender.dailyFile.DatePattern='.'yyyy-MM-dd
log4j.appender.dailyFile.layout=org.apache.log4j.PatternLayout
log4j.appender.dailyFile.layout.ConversionPattern=[%-5p] %d(%r) --> [%t] %l: %m %x %n
# 应用于socket
log4j.appender.socket=org.apache.log4j.RollingFileAppender
log4j.appender.socket.RemoteHost=localhost
log4j.appender.socket.Port=5001
log4j.appender.socket.LocationInfo=true
# Set up for Log Factor 5
log4j.appender.socket.layout=org.apache.log4j.PatternLayout
log4j.appender.socket.layout.ConversionPattern=[%-5p] %d(%r) --> [%t] %l: %m %x %n
# Log Factor 5 Appender
log4j.appender.LF5_APPENDER=org.apache.log4j.lf5.LF5Appender
log4j.appender.LF5_APPENDER.MaxNumberOfRecords=2000
# 发送日志到指定邮件
log4j.appender.mail=org.apache.log4j.net.SMTPAppender
log4j.appender.mail.Threshold=FATAL
log4j.appender.mail.BufferSize=10
log4j.appender.mail.From = xxx@mail.com
log4j.appender.mail.SMTPHost=mail.com
log4j.appender.mail.Subject=Log4J Message
log4j.appender.mail.To= xxx@mail.com
log4j.appender.mail.layout=org.apache.log4j.PatternLayout
log4j.appender.mail.layout.ConversionPattern=[%-5p] %d(%r) --> [%t] %l: %m %x %n
# 应用于数据库
log4j.appender.database=org.apache.log4j.jdbc.JDBCAppender
log4j.appender.database.URL=jdbc:mysql://localhost:3306/test
log4j.appender.database.driver=com.mysql.jdbc.Driver
log4j.appender.database.user=root
log4j.appender.database.password=
log4j.appender.database.sql=INSERT INTO LOG4J (Message) VALUES('=[%-5p] %d(%r) --> [%t] %l: %m %x %n')
log4j.appender.database.layout=org.apache.log4j.PatternLayout
log4j.appender.database.layout.ConversionPattern=[%-5p] %d(%r) --> [%t] %l: %m %x %n

# 自定义Appender
log4j.appender.im = net.cybercorlin.util.logger.appender.IMAppender
log4j.appender.im.host = mail.cybercorlin.net
log4j.appender.im.username = username
log4j.appender.im.password = password
log4j.appender.im.recipient = corlin@cybercorlin.net
log4j.appender.im.layout=org.apache.log4j.PatternLayout
log4j.appender.im.layout.ConversionPattern=[%-5p] %d(%r) --> [%t] %l: %m %x %n
```


### 使用log4j

* 获取日志记录器
```
static Logger logger = Logger.getLogger ( ServerWithLog4j.class.getName () )
```
* 读取配置文件

```java
BasicConfigurator.configure ()： 自动快速地使用缺省Log4j环境。  
PropertyConfigurator.configure ( String configFilename) ：读取使用Java的特性文件编写的配置文件。  
DOMConfigurator.configure ( String filename ) ：读取XML形式的配置文件。

```
* 插入日志记录

```java
Logger.debug ( Object message ) ;  
Logger.info ( Object message ) ;  
Logger.warn ( Object message ) ;  
Logger.error ( Object message ) ;
```
