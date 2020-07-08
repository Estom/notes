## 1 使用原型archetype插件，创建项目。

```
mvn archetype:generate "-DgroupId=com.companyname.bank" "-DartifactId=consumerBanking" "-DarchetypeArtifactId=maven-archetype-quickstart" "-DinteractiveMode=false"
```

> 其目录结构是标准的java目录结构。

## 2 对maven项目进行编译
```
mvn clean package
```

## 3 生成项目文档

添加一下配置
```
<project>
  ...
<build>
<pluginManagement>
    <plugins>
        <plugin>
          <groupId>org.apache.maven.plugins</groupId>
          <artifactId>maven-site-plugin</artifactId>
          <version>3.3</version>
        </plugin>
        <plugin>
          <groupId>org.apache.maven.plugins</groupId>
          <artifactId>maven-project-info-reports-plugin</artifactId>
          <version>2.7</version>
        </plugin>
    </plugins>
    </pluginManagement>
</build>
 ...
</project>
```

运行文档生成
```
mvn site
```