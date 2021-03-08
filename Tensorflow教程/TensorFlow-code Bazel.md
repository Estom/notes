## Bazel

> 对TensorFlow编译过程中bazel的行为解析。了解bazel构建TensorFlow的方法，有助于对源码和源码框架的理解。

## 结构概念：Workspace Packages  Targets

##### Workspace (根文件夹)
一个workspace就是一个project(项目)的根目录。workspace里包含构建这个项目所需的源文件，以及symboliclinks(符号链接)。每个workspace目录都必须有一个名为WORKSPACE的文件。这个WORKSPACE文件可能是空的。也可能包含构建项目所需的外部依赖。

##### Package (子文件夹)
在一个workspace中package是主要的代码组织单元。一个package就是一个相关文件的集合。也是一个这些相关文件之间的规范。一个package被定义为一个目录.这个目录里必须包含一个名为BUILD的文件。package目录必须在workspace目录下。package包含其目录中的所有文件.以及其下的所有子目录。但是不包含那些包含了BUILD文件的子目录.

##### Target
package是一个容器，即目录。他里面的元素被称为target。target可以分为三类: file(文件) rule(规则) package group(数量很少)
* file  
file进一步分类又可以分为两种:源文件和派生文件.
源文件通常就是程序员编写的类文件.会被上传到远程仓库.
派生文件是由编译器根据指定规则生成的文件.不会被上传到远程仓库.

* rule  
rule不是一个文件。他是被保存在BUILD文件里的一个函数或者叫方法。他是一个规则。
    1. rule指定输入和输出之间的关系.以及构建输出的步骤.rule的输出始终是派生文件.rule的输入可以是源文件.也可以是派生文件.也就是说.rule的输出也可能是另一个rule的输入.Bazel允许构建长链规则.
    2. rule的输入还可以包含其他rule.即A rule可能有另一个B rule作为输入.
    3.通过rule生成的文件始终属于该rule所属的package.不能将生成文件放到另一个package里.但是rule的输入却可以来自另一个package
    4.每个rule都有一个name.由name属性指定.类型为string.这个被你指定的名字将作为生成的文件的名称。所以推荐名称可以遵守一定的规则: 如: _binary和_test.让人看名字就知道你要生成的文件的作用.
    5.每个规则都有一组属性.每个属性都是rule类里的函数.每个属性都有一个名称和一个类型.类型可以是: 整数; label; label列表; 字符串; 字符串列表; 输出label; 输出label列表.在每个规则中不是每个属性都需要被实现的.即有的属性是可选的.

* package group  
    package group顾名思义就是一组package.他的目的是限制某些规则的可访问性.packagegroup由package_group函数定义.他有两个属性:他包含的包列表及其名称.唯一能决定他能否被引用的属性是:rule里的visibility属性或者package函数里的default_visibility属性.他不生成或者使用文件.仅仅是定义.


* label  
    所有的target属于一个package.target的名字被称为label.一个典型target的label如下所示:
    //src/business/GXPhone:GXPhone_binary
    每个label有两个部分
    src/business/GXPhone被称为package name.
    GXPhone_binary被称为target name