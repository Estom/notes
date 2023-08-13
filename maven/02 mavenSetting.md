# Maven的settings.xml配置详解


1 基本介绍
maven的两大配置文件：settings.xml和pom.xml。其中settings.xml是maven的全局配置文件，pom.xml则是文件所在项目的局部配置。

1.1 settings.xml文件位置
①全局配置文件：${M2_HOME}/conf/settings.xml，对操作系统所有者生效

②用户配置：user.home/.m2/settings.xml，只对当前操作系统的使用者生效

1.2 配置文件优先级
局部配置优先于全局配置。

配置优先级从高到低：pom.xml> user settings > global settings

如果这些文件同时存在，在应用配置时，会合并它们的内容，如果有重复的配置，优先级高的配置会覆盖优先级低的。如果全局配置和用户配置都存在，它们的内容将被合并，并且用户范围的settings.xml会覆盖全局的settings.xml。

1.3 注意事项
note1: Maven安装后，用户目录下不会自动生成settings.xml，只有全局配置文件。如果需要创建用户范围的settings.xml，可以将安装路径下的settings复制到目录${user.home}/.m2/。Maven默认的settings.xml是一个包含了注释和例子的模板，可以快速的修改它来达到你的要求。
note2: 全局配置一旦更改，所有的用户都会受到影响，而且如果maven进行升级，所有的配置都会被清除，所以要提前复制和备份${M2_HOME}/conf/settings.xml文件，一般情况下不推荐配置全局的settings.xml。
2 标签详解
2.1 顶级元素概览
<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0
                          https://maven.apache.org/xsd/settings-1.0.0.xsd">
	
    <!-- 该值表示构建系统本地仓库的路径，默认值：~/.m2/repository -->
  	<localRepository/>
    
    <!--
		作用：表示maven是否需要和用户交互以获得输入
		如果maven需要和用户交互以获得输入，则设置成true，反之则应为false。默认为true。
	-->
  	<interactiveMode/>
    
    <!--
		作用：maven是否需要使用plugin-registry.xml文件来管理插件版本。
		如果需要让maven使用文件~/.m2/plugin-registry.xml来管理插件版本，则设为true。默认为false。
	-->
  	<usePluginRegistry/>
    
    <!--
		作用：表示maven是否需要在离线模式下运行。
		如果构建系统需要在离线模式下运行，则为true，默认为false。
		当由于网络设置原因或者安全因素，构建服务器不能连接远程仓库的时候，该配置就十分有用。
	-->
  	<offline/>
    
    <!--
		作用：当插件的组织id（groupId）没有显式提供时，供搜寻插件组织Id（groupId）的列表。
		该元素包含一个pluginGroup元素列表，每个子元素包含了一个组织Id（groupId）。
		当我们使用某个插件，并且没有在命令行为其提供组织Id（groupId）的时候，Maven就会使用该列表。
		默认情况下该列表包含了org.apache.maven.plugins和org.codehaus.mojo。
	<pluginGroups>
    	<pluginGroup>plugin的组织Id（groupId）:org.codehaus.mojo</pluginGroup>
  	</pluginGroups>
	-->    
  	<pluginGroups/>

    <!-- 下面几个标签详细介绍 -->
  	<servers/>
  	<mirrors/>
  	<proxies/>
  	<profiles/>
  	<activeProfiles/>
</settings>
1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
20
21
22
23
24
25
26
27
28
29
30
31
32
33
34
35
36
37
38
39
40
41
42
43
44
45
2.2 标签servers
作用：一般，仓库的下载和部署是在pom.xml文件中的repositories和distributionManagement元素中定义的。

然而，一般类似用户名、密码（有些仓库访问是需要安全认证的）等信息不应该在pom.xml文件中配置，

这些信息可以配置在settings.xml中。

<servers>
    <server>
        <!-- server的id，不是用户登录的id，该id与distributionManagement中repository元素的id相匹配 -->
        <id>serverId</id>
        
        <!-- 鉴权用户名和鉴权密码表示服务器认证所需要的登录名和密码 -->
        <username>username</username>
        <password>password</password>
        
        <!-- 鉴权时使用的私钥位置 -->
        <privateKey>${usr.home}/.ssh/id_dsa</privateKey>
        <!-- 鉴权时使用的私钥密码 -->
      	<passphrase>passphrase</passphrase>
        
        <!-- 文件被创建时的权限 -->
      	<filePermissions>664</filePermissions>
      	<!-- 目录被创建时的权限 -->
      	<directoryPermissions>775</directoryPermissions>
    </server>
</servers>
1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
20
2.3 标签mirrors
<mirrors>
    <mirror>
        <!-- 该镜像的唯一标识符 -->
        <id>mirrorId</id>
        
        <!-- 镜像名称 -->
        <name>name</name>
        
        <!-- 该镜像的URL，构建系统会优先考虑使用该URL，而非使用默认的服务器URL -->
        <url>url</url>
        
      	<!-- 被镜像的服务器的id。例如，如果我们要设置了一个Maven中央仓库（http://repo.maven.apache.org/maven2/）的镜像，就需要将该元素设置成central。这必须和中央仓库的id central完全一致。 -->
      	<mirrorOf>central</mirrorOf>
    </mirror>
</mirrors>
1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
2.4 标签profiles
作用：根据环境参数来调整构建配置的列表。

settings.xml中的profile元素是pom.xml中profile元素的裁剪版本。

它包含了id、activation、repositories、pluginRepositories和 properties元素。这里的profile元素只包含这五个子元素是因为这里只关心构建系统这个整体（这正是settings.xml文件的角色定位），而非单独的项目对象模型设置。如果一个settings.xml中的profile被激活，它的值会覆盖任何其它定义在pom.xml中带有相同id的profile。

<profiles>
    <profile>
      	<id>test</id> <!-- profile的唯一标识 -->
      	<activation /> <!-- 自动触发profile的条件逻辑 -->      
      	<properties /> <!-- 扩展属性列表 -->      
      	<repositories /> <!-- 远程仓库列表 -->      
      	<pluginRepositories /> <!-- 插件仓库列表 -->
    </profile>
</profiles>
1
2
3
4
5
6
7
8
9
2.4.1 activation
作用：自动触发profile的条件逻辑。

如pom.xml中的profile一样，profile的作用在于它能够在某些特定的环境中自动使用某些特定的值；这些环境通过activation元素指定。

activation元素并不是激活profile的唯一方式。settings.xml文件中的activeProfile元素可以包含profile的id。profile也可以通过在命令行，使用-P标记和逗号分隔的列表来显式的激活（如，-P test）。

<activation>
  	<!--profile默认是否激活的标识 -->
  	<activeByDefault>false</activeByDefault>
    
  	<!--当匹配的jdk被检测到，profile被激活。例如，1.4激活JDK1.4，1.4.0_2，而!1.4激活所有版本不是以1.4开头的JDK。 -->
  	<jdk>1.5</jdk>
    
  	<!--当匹配的操作系统属性被检测到，profile被激活。os元素可以定义一些操作系统相关的属性。 -->
  	<os>
    	<!--激活profile的操作系统的名字 -->
    	<name>Windows XP</name>
    	<!--激活profile的操作系统所属家族(如 'windows') -->
    	<family>Windows</family>
    	<!--激活profile的操作系统体系结构 -->
    	<arch>x86</arch>
    	<!--激活profile的操作系统版本 -->
    	<version>5.1.2600</version>
  	</os>
    
  	<!--如果Maven检测到某一个属性（其值可以在POM中通过${name}引用），其拥有对应的name = 值，Profile就会被激活。如果值字段是空的，那么存在属性名称字段就会激活profile，否则按区分大小写方式匹配属性值字段 -->
  	<property>
    	<!--激活profile的属性的名称 -->
    	<name>mavenVersion</name>
    	<!--激活profile的属性的值 -->
    	<value>2.0.3</value>
  	</property>
    
  	<!--提供一个文件名，通过检测该文件的存在或不存在来激活profile。missing检查文件是否存在，如果不存在则激活profile。另一方面，exists则会检查文件是否存在，如果存在则激活profile。 -->
  	<file>
    	<!--如果指定的文件存在，则激活profile。 -->
    	<exists>${basedir}/file2.properties</exists>
    	<!--如果指定的文件不存在，则激活profile。 -->
    	<missing>${basedir}/file1.properties</missing>
  	</file>
</activation>
1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
20
21
22
23
24
25
26
27
28
29
30
31
32
33
34
35
注：在maven工程的pom.xml所在目录下执行mvn help:active-profiles命令可以查看中央仓储的profile是否在工程中生效。

2.4.2 properties
作用：对应profile的扩展属性列表。

maven属性和ant中的属性一样，可以用来存放一些值。这些值可以在pom.xml中的任何地方使用标记${X}来使用，这里X是指属性的名称。属性有五种不同的形式，并且都能在settings.xml文件中访问。

<!-- 
1. env.X: 在一个变量前加上"env."的前缀，会返回一个shell环境变量。例如,"env.PATH"指代了$path环境变量（在Windows上是%PATH%）。 
2. project.x：指代了POM中对应的元素值。例如: <project><version>1.0</version></project>通过${project.version}获得version的值。 
3. settings.x: 指代了settings.xml中对应元素的值。例如：<settings><offline>false</offline></settings>通过 ${settings.offline}获得offline的值。 
4. Java System Properties: 所有可通过java.lang.System.getProperties()访问的属性都能在POM中使用该形式访问，例如 ${java.home}。 
5. x: 在<properties/>元素中，或者外部文件中设置，以${someVar}的形式使用。
-->
<properties>
  <user.install>${user.home}/our-project</user.install>
</properties>
1
2
3
4
5
6
7
8
9
10
注：如果该profile被激活，则可以在pom.xml中使用${user.install}。

2.4.3 repositories
作用：远程仓库列表，它是maven用来填充构建系统本地仓库所使用的一组远程仓库。

<repositories>
  	<!--包含需要连接到远程仓库的信息 -->
  	<repository>
    	<!--远程仓库唯一标识 -->
    	<id>codehausSnapshots</id>
    	<!--远程仓库名称 -->
        <name>Codehaus Snapshots</name>
    	
        <!--远程仓库URL，按protocol://hostname/path形式 -->
    	<url>http://snapshots.maven.codehaus.org/maven2</url>
        
        <!--如何处理远程仓库里发布版本的下载 -->
    	<releases>
      		<!--true或者false表示该仓库是否为下载某种类型构件（发布版，快照版）开启。 -->
      		<enabled>false</enabled>
      		<!--该元素指定更新发生的频率。Maven会比较本地POM和远程POM的时间戳。这里的选项是：always（一直），daily（默认，每日），interval：X（这里X是以分钟为单位的时间间隔），或者never（从不）。 -->
      		<updatePolicy>always</updatePolicy>
      		<!--当Maven验证构件校验文件失败时该怎么做-ignore（忽略），fail（失败），或者warn（警告）。 -->
      		<checksumPolicy>warn</checksumPolicy>
    	</releases>
        
    	<!--如何处理远程仓库里快照版本的下载。有了releases和snapshots这两组配置，POM就可以在每个单独的仓库中，为每种类型的构件采取不同的策略。例如，可能有人会决定只为开发目的开启对快照版本下载的支持。参见repositories/repository/releases元素 -->
    	<snapshots>
      		<enabled />
      		<updatePolicy />
      		<checksumPolicy />
    	</snapshots>
    
    	<!--用于定位和排序构件的仓库布局类型-可以是default（默认）或者legacy（遗留）。Maven 2为其仓库提供了一个默认的布局；然而，Maven 1.x有一种不同的布局。我们可以使用该元素指定布局是default（默认）还是legacy（遗留）。 -->
    	<layout>default</layout>
  	</repository>
</repositories>
1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
20
21
22
23
24
25
26
27
28
29
30
31
32
2.4.4 pluginRepositories
作用：发现插件的远程仓库列表。

和repository类似，只是repository是管理jar包依赖的仓库，pluginRepositories则是管理插件的仓库。

maven插件是一种特殊类型的构件。由于这个原因，插件仓库独立于其它仓库。pluginRepositories元素的结构和repositories元素的结构类似。每个pluginRepository元素指定一个Maven可以用来寻找新插件的远程地址。

<pluginRepositories>
  	<!-- 包含需要连接到远程插件仓库的信息 -->
	<!-- 参见profiles/profile/repositories/repository元素的说明 -->
  	<pluginRepository>
      	<id />
    	<name />
    	<url />
        
    	<releases>
      		<enabled />
      		<updatePolicy />
      		<checksumPolicy />
    	</releases>
      
        <snapshots>
            <enabled />
            <updatePolicy />
            <checksumPolicy />
        </snapshots>
    
    	<layout />
  	</pluginRepository>
</pluginRepositories>
1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
20
21
22
23
2.5 activeProfiles
作用：手动激活profiles的列表，按照profile被应用的顺序定义activeProfile。

该元素包含了一组activeProfile元素，每个activeProfile都含有一个profile id。任何在activeProfile中定义的profile id，不论环境设置如何，其对应的 profile都会被激活。如果没有匹配的profile，则什么都不会发生。 例如，env-test是一个activeProfile，则在pom.xml（或者profile.xml）中对应id的profile会被激活。如果运行过程中找不到这样一个profile，Maven则会像往常一样运行。

<activeProfiles>
    <!-- 要激活的profile id -->
    <activeProfile>env</activeProfile>
</activeProfiles>
1
2
3
4
3 番外篇：mirror和repository区别
简单点来说，repository就是个仓库。maven里有两种仓库，本地仓库和远程仓库。远程仓库相当于公共的仓库，大家都能看到。本地仓库是你本地的一个山寨版，只有你看的到，主要起缓存作用。当你向仓库请求插件或依赖的时候，会先检查本地仓库里是否有。如果有则直接返回，否则会向远程仓库请求，并做缓存。你也可以把你做的东西上传到本地仓库给你本地自己用，或上传到远程仓库，供大家使用。 internal repository是指在局域网内部搭建的repository，它跟central repository, jboss repository等的区别仅仅在于其URL是一个内部网址。

远程仓库可以在工程的pom.xml文件里指定。如果没指定，默认就会把下面这地方做远程仓库，即默认会到 http://repo1.maven.org/maven2 这个地方去请求插件和依赖包。

<repository>  
	<snapshots>  
        <enabled>false</enabled>  
    </snapshots>  
    <id>central</id>  
    <name>Maven Repository Switchboard</name>  
    <url>http://repo1.maven.org/maven2</url>  
</repository>
1
2
3
4
5
6
7
8
镜像是仓库的镜子，保存了被镜像仓库的所有的内容,主要针对远程仓库而言。配置mirror的目的一般是出于网速考虑。如果仓库X可以提供仓库Y存储的所有内容，那么就可以认为X是Y的一个镜像。换句话说，任何一个可以从仓库Y获得的构件，都能够从它的镜像中获取。举个例子，http://maven.NET.cn/content/groups/public/ 是中央仓库 http://repo1.maven.org/maven2/ 在中国的镜像，由于地理位置的因素，该镜像往往能够提供比中央仓库更快的服务。

id的值为central，表示该配置为中央仓库的镜像，任何对于中央仓库的请求都会转至该镜像，用户也可以使用同样的方法配置其他仓库的镜像。

关于镜像的一个更为常见的用法是结合私服。由于私服可以代理任何外部的公共仓库(包括中央仓库)，因此，对于组织内部的Maven用户来说，使用一个私服地址就等于使用了所有需要的外部仓库，这可以将配置集中到私服，从而简化Maven本身的配置。在这种情况下，任何需要的构件都可以从私服获得，私服就是所有仓库的镜像。这时，可以配置这样的一个镜像，如例：

<settings>
    ...
    <mirrors>
        <mirror>
            <id>internal-repository</id>
            <name>Internal Repository Manager</name>
            <url>http://192.168.1.100/maven2</url>
            <mirrorOf>*</mirrorOf>
        </mirror>
    </mirrors>
    ...
</settings>
1
2
3
4
5
6
7
8
9
10
11
12
该例中的值为星号，表示该配置是所有Maven仓库的镜像，任何对于远程仓库的请求都会被转至http://192.168.1.100/maven2/。

如果该镜像仓库需要认证，则配置一个Id为internal-repository的即可。

为了满足一些复杂的需求，Maven还支持更高级的镜像配置：

*\

匹配所有远程仓库。

\external:*\

匹配所有远程仓库，使用localhost的除外，使用file://协议的除外。也就是说，匹配所有不在本机上的远程仓库。

\repo1,repo2\

匹配仓库repo1和repo2，使用逗号分隔多个远程仓库。

*,!repo1\

匹配所有远程仓库，repo1除外，使用感叹号将仓库从匹配中排除。

需要注意的是，由于镜像仓库完全屏蔽了被镜像仓库，当镜像仓库不稳定或者停止服务的时候，Maven仍将无法访问被镜像仓库，因而将无法下载构件

一般远程仓库的镜像配置为阿里云的镜像：

<mirrors>
    <mirror>
        <id>alimaven</id>
        <name>aliyun maven</name>
        <url>http://maven.aliyun.com/nexus/content/groups/public/</url>
        <mirrorOf>central</mirrorOf>
    </mirror>
 </mirrors>


 ### 多版本

 由于在多maven版本，多仓库环境下，某些项目开发的时候需要特殊指定对应的仓库地址。

```sh
mvn package install -DskipTests docker:build -s /home/xxx/.m2/settings.xml -Dmaven.repo.local=/home/xxx/.m2/repository
```

命令说明：
* package：打包
* install：保存到本地仓库
* -DskipTests：忽略测试类
* docker:build：生成docker镜像
* -s：指定settings文件
* -Dmaven.repo.local：指定本地仓库地址