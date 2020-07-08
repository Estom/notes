## 1 配置文件的类型

* 项目级：定义在项目的POM文件pom.xml中。
* 用户级：定义在maven的设置文件xml中（%USER_HOME%.m2/setting.xml)
* 全局：定义在Maven全局的设置xml文件中（%M2_HOME%/comf/settings.xml）

## 配置文件激活

### 配置文件激活

profile 可以让我们定义一系列的配置信息，然后指定其激活条件。这样我们就可以定义多个 profile，然后每个 profile 对应不同的激活条件和配置信息，从而达到不同环境使用不同配置信息的效果。

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
