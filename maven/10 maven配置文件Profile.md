## 1 配置文件

### 配置文件概述

profile 可以让我们定义一系列的配置信息，然后指定其激活条件。这样我们就可以定义多个 profile，然后每个 profile 对应不同的激活条件和配置信息，从而达到不同环境使用不同配置信息的效果。

* profiles/profile 代表众多可选配置中的一个，所以使用profiles附属形式进行管理。
* 由于profile标签覆盖了pom.xml中的默认配置（能够覆盖任何之前的配置），所以profiles标签通常是pom.xml
```xml
     <profile>
            <id>test</id>
            <activation>
                <property>
                    <name>env</name>
                    <value>test</value>
                </property>
                <!-- <activeByDefault>true</activeByDefault> -->
            </activation>
            <repositories>
                <repository>
                    <id>central</id>
                    <url>http://mvn.test.alipay.net:8080/artifactory/repo</url>
                    <snapshots>
                        <enabled>true</enabled>
                    </snapshots>
                </repository>
                <repository>
                    <id>snapshots</id>
                    <url>http://mvn.test.alipay.net:8080/artifactory/repo</url>
                    <releases>
                        <enabled>true</enabled>
                        <updatePolicy>never</updatePolicy>
                    </releases>
                </repository>
                <repository>
                    <id>alibaba</id>
                    <url>http://mvnrepo.alibaba-inc.com/mvn/repository</url>
                </repository>
            </repositories>
            <pluginRepositories>
                <pluginRepository>
                    <id>central</id>
                    <url>http://mvn.test.alipay.net:8080/artifactory/repo</url>
                    <snapshots>
                        <enabled>false</enabled>
                        <updatePolicy>never</updatePolicy>
                    </snapshots>
                </pluginRepository>
                <pluginRepository>
                    <id>alibaba</id>
                    <url>http://mvnrepo.alibaba-inc.com/mvn/repository</url>
                </pluginRepository>
            </pluginRepositories>
        </profile>
    </profiles>
```


* activation标签：激活的方式
  * activeByDefault表示默认激活
  * properties表示一旦被激活后采纳的配置
* id是名字

## 2 maven配置文件的激活方式
### 通过maven设置激活配置文件

通过Maven设置激活配置文件
打开 %USER_HOME%/.m2 目录下的 settings.xml 文件，其中 %USER_HOME% 代表用户主目录。如果 setting.xml 文件不存在就直接拷贝 %M2_HOME%/conf/settings.xml 到 .m2 目录，其中 %M2_HOME% 代表 Maven 的安装目录。

配置 setting.xml 文件，增加 <activeProfiles>属性：
```
<settings xmlns="http://maven.apache.org/POM/4.0.0"
   xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
   xsi:schemaLocation="http://maven.apache.org/POM/4.0.0
   http://maven.apache.org/xsd/settings-1.0.0.xsd">
   ...
   <activeProfiles>
      <activeProfile>test</activeProfile>
   </activeProfiles>
</settings>
```

### 通过环境变量激活配置文件
 pom.xml 里面的 \<id> 为 test 的 \<profile> 节点，加入 \<activation> 节点：
```
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/maven-v4_0_0.xsd">
  <modelVersion>4.0.0</modelVersion>
  <groupId>com.jsoft.test</groupId>
  <artifactId>testproject</artifactId>
  <packaging>jar</packaging>
  <version>0.1-SNAPSHOT</version>
  <name>testproject</name>
  <url>http://maven.apache.org</url>
  <dependencies>
    <dependency>
      <groupId>junit</groupId>
      <artifactId>junit</artifactId>
      <version>3.8.1</version>
      <scope>test</scope>
    </dependency>
  </dependencies>
  <profiles>
      <profile>
          <id>test</id>
          <activation>
            <property>
               <name>env</name>
               <value>test</value>
            </property>
          </activation>
          <build>
              <plugins>
                 <plugin>
                    <groupId>org.apache.maven.plugins</groupId>
                    <artifactId>maven-antrun-plugin</artifactId>
                    <version>1.8</version>
                    <executions>
                       <execution>
                          <phase>test</phase>
                          <goals>
                             <goal>run</goal>
                          </goals>
                          <configuration>
                          <tasks>
                             <echo>Using env.test.properties</echo>
                             <copy file="src/main/resources/env.test.properties" tofile="${project.build.outputDirectory}/env.properties" overwrite="true"/>
                          </tasks>
                          </configuration>
                       </execution>
                    </executions>
                 </plugin>
              </plugins>
          </build>
      </profile>
      <profile>
          <id>normal</id>
          <build>
              <plugins>
                 <plugin>
                    <groupId>org.apache.maven.plugins</groupId>
                    <artifactId>maven-antrun-plugin</artifactId>
                    <version>1.8</version>
                    <executions>
                       <execution>
                          <phase>test</phase>
                          <goals>
                             <goal>run</goal>
                          </goals>
                          <configuration>
                          <tasks>
                             <echo>Using env.properties</echo>
                             <copy file="src/main/resources/env.properties" tofile="${project.build.outputDirectory}/env.properties" overwrite="true"/>
                          </tasks>
                          </configuration>
                       </execution>
                    </executions>
                 </plugin>
              </plugins>
          </build>
      </profile>
      <profile>
          <id>prod</id>
          <build>
              <plugins>
                 <plugin>
                    <groupId>org.apache.maven.plugins</groupId>
                    <artifactId>maven-antrun-plugin</artifactId>
                    <version>1.8</version>
                    <executions>
                       <execution>
                          <phase>test</phase>
                          <goals>
                             <goal>run</goal>
                          </goals>
                          <configuration>
                          <tasks>
                             <echo>Using env.prod.properties</echo>
                             <copy file="src/main/resources/env.prod.properties" tofile="${project.build.outputDirectory}/env.properties" overwrite="true"/>
                          </tasks>
                          </configuration>
                       </execution>
                    </executions>
                 </plugin>
              </plugins>
          </build>
      </profile>
   </profiles>
</project>
```

### 通过操作系统激活配置文件
activation 元素包含下面的操作系统信息。当系统为 windows XP 时，test Profile 将会被触发。
```
<profile>
   <id>test</id>
   <activation>
      <os>
         <name>Windows XP</name>
         <family>Windows</family>
         <arch>x86</arch>
         <version>5.1.2600</version>
      </os>
   </activation>
</profile>
```
### 通过文件的存在或者缺失激活配置文件
现在使用 activation 元素包含下面的操作系统信息。当 target/generated-sources/axistools/wsdl2java/com/companyname/group 缺失时，test Profile 将会被触发。
```
<profile>
   <id>test</id>
   <activation>
      <file>
         <missing>target/generated-sources/axistools/wsdl2java/
         com/companyname/group</missing>
      </file>
   </activation>
</profile>
```
### 使用命令进行激活

查看当前环境激活的profile
```
mvn help:active-profiles
```
激活某个指定id的profile
```
mvn compile -P <profile id>
```

## 3 实例

### 编写lambda表达式



## 4 资源属性过滤
> 一般不用

### 过滤资源
* 使用资源处理功能，处理解析指定目下的`${}`变量。