# AndroidStudio使用教程

## 1 开发体系

### 开发体系
* Android Studio编辑器（是一个编辑编译调试发布的图形界面工具，相当于前端）
* SDK集成开发环境。提供了编译调试发布的环境和命令行脚本。（没有界面的集成环境，相当于后端）
* gradle编译工具。使用SDK完成编译工作。编译脚本。可以与SDK命令行工具结合，在命令行中使用。也可以与Android Studio结合，在界面工具中使用。
* 各种其他的插件、工具。包括
  * SDK插件（cmake、ndk）
  * Androidstudio插件。

### SDK工具

* SDK命令行工具
  * apkanalyzer
  * avdmanager
  * lint
  * retrace
  * sdkmanager
* SDK构建工具
  * aapt2
  * apksigner
  * zipalign
* SDK平台工具
  * adb
  * etc1tool
  * fastboot
  * logcat

## 2 gradle使用教程

### gradle项目结构（Android studio 项目结构）
* MyApplictaion项目根节点
* .gradle 本项目中的gradle编译工具。一般是系统gradle的copy。
* app 模块文件
* build 编译过程中的生成文件
* gradle gradle_wrapper配置文件，用来配置gradle。
-----
* gradlew 本想目中的gradle编译脚本，用来本地执行gradle命令。
* build.gradle 项目的编译控制文件
* setting.gradle 项目中的模块配置
* gradle.properties 项目的gradle配置

### 修改国内镜像的方法有两个：
* 在工程中，build.gradle 添加阿里云的镜像。用来下载工程依赖。gradle用来下载dependency
* 在电脑上的gradle工具中，gradle.properties修改添加国内镜像地址。gradle-wrapper用来下载gradle


### gradle说明
* gradle_wrapper用来配置、下载gradle
* gradle用来配置、编译Android项目，下载dependency
* gradle for Android studio 用来配置gradle的Android编译环境。

## 3 Android studio 界面工具

### 新学到的快捷键

* ctrl+q，显示快捷文档
* ctrl+shift+v,多次黏贴
* ctrl+shift+space，智能匹配、补全
* 双击shift，搜索菜单
* alt+enter,智能修改错误
### File（工程项目操作）
* setting软件配置
* project setting工程配置

### Edit（文本操作）
* 编辑选项：选择、复制、剪切、黏贴

### Navigator（代码内容操作）
* 导航到制定位置
  * 接口、实现、调用、继承、层级

### Code
* 用来方便编写代码，generate生成等。

