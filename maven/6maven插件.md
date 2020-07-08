## 1 简介

maven项目包含三个生命周期，每个生命周期包含多个节点。每个节点都是由maven插件实现。例如maven-clean-plugin

maven实际上是一个依赖插件执行的框架。

插件提供了一个目标的集合。使用以下语法执行
```
mvn [plugin-name]:[goal-name]
mvn compiler:compile
```

## 2 常用插件

分为两类
* Build plugins
* Repoting plugins

常用插件列表

* clean	构建之后清理目标文件。删除目标目录。
* compiler	编译 Java 源文件。
* surefile	运行 JUnit 单元测试。创建测试报告。
* jar	从当前工程中构建 JAR 文件。
* war	从当前工程中构建 WAR 文件。
* javadoc	为工程生成 Javadoc。
* antrun	从构建过程的任意一个阶段中运行一个 ant 任务的集合。

## 3 插件修改方法

```
<project xmlns="http://maven.apache.org/POM/4.0.0"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://maven.apache.org/POM/4.0.0
    http://maven.apache.org/xsd/maven-4.0.0.xsd">
<modelVersion>4.0.0</modelVersion>
<groupId>com.companyname.projectgroup</groupId>
<artifactId>project</artifactId>
<version>1.0</version>
<build>
<plugins>
   <plugin>
   <groupId>org.apache.maven.plugins</groupId>
   <artifactId>maven-antrun-plugin</artifactId>
   <version>1.1</version>
   <executions>
      <execution>
         <id>id.clean</id>
         <phase>clean</phase>
         <goals>
            <goal>run</goal>
         </goals>
         <configuration>
            <tasks>
               <echo>clean phase</echo>
            </tasks>
         </configuration>
      </execution>     
   </executions>
   </plugin>
</plugins>
</build>
</project>
```