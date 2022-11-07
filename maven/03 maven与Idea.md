# Idea的使用

## 1 创建工程

1. 创建maven工程。可以选择archetype创建模板工程，也可以不选，创建标准工程。
2. 配置项目。基本配置包括groupId、artifactId、version
3. maven的配置。在setting/preference自定义maven的位置，加载maven的仓库位置，而不是使用Idea集成的maven。可以通过maven工具窗口。
4. 创建Java模块工程。在父工程中自动添加modules和package


## 2 侧边栏使用


1. 扳手：配置maven
2. 打开关闭目录
3. M：表示执行maven命令


## 3 工程导入

### 导入整个工程
IDEA直接打开目录就能识别。含有parent-pom的目录

### 导入单个模块

project-structures Import module导入基本组件。

project-structures Import facets导入Web组件


## 4 生命周期
提高构件过程的自动化程度。