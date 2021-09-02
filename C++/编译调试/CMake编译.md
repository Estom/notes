## 1 基本信息
### Cmake最低版本号要求
cmake_minimum_reqired(VERSION 2.8)

### 项目信息
project(Demo1)

## 2 变量配置

### 使用mmm变量保存当前目录下所有文件
aux_source_directory(.  mmm)
add_executable(Demo ${mmm})

### 将hello.cpp 赋值给SOURCE 变量
SET(SOURCE ${PROJECT_SOURCE_DIR}/src/hello.cpp)

### 收集c/c++文件并赋值给变量SRC_LIST_CPP  ${PROJECT_SOURCE_DIR}代表区当前项目录
FILE(GLOB SRC_LIST_CPP ${PROJECT_SOURCE_DIR}/src/*.cpp)
FILE(GLOB SRC_LIST_C ${PROJECT_SOURCE_DIR}/src/*.c)

## 3 引入配置



### 添加子文件
add_subdirectory(math)

### 指定头文件目录
INCLUDE_DIRECTORIES(${PROJECT_SOURCE_DIR}/include)
### 指定链接库文件目录
LINK_DIRECTORIES(${PROJECT_SOURCE_DIR}/lib)

## 4 生成配置


### 指定生成目标
add_executable(Demo main.cc a.cc b.cc)

#去变量SRC_LIST_CPP 与SRC_LIST_C 指定生成libmyprint 动态库   默认生成静态库  SHARED指定生成库类型为动态库
ADD_LIBRARY(myprint SHARED ${SRC_LIST_CPP} ${SRC_LIST_C})
## 5 链接配置

#指定hello 链接库myprint
TARGET_LINK_LIBRARIES(hello myprint)


## 6 示例
### Cmake添加静态链接库
```
CMAKE_MINIMUM_REQUIRED(VERSION 3.14)
#指定项目名称
PROJECT(HELLO)

#将hello.cpp 赋值给SOURCE 变量
SET(SOURCE ${PROJECT_SOURCE_DIR}/src/hello.cpp)

#指定头文件目录
INCLUDE_DIRECTORIES(${PROJECT_SOURCE_DIR}/include)
#指定链接库文件目录
LINK_DIRECTORIES(${PROJECT_SOURCE_DIR}/lib)

#将hello.cpp生成可执行文件hello 
ADD_EXECUTABLE(hello ${SOURCE})

#指定hello 链接库myprint
TARGET_LINK_LIBRARIES(hello myprint)
```
### Cmake使用动态链接库
```
#指定CMake编译最低要求版本
CMAKE_MINIMUM_REQUIRED(VERSION 3.14)
#给项目命名
PROJECT(MYPRINT)
#收集c/c++文件并赋值给变量SRC_LIST_CPP  ${PROJECT_SOURCE_DIR}代表区当前项目录
FILE(GLOB SRC_LIST_CPP ${PROJECT_SOURCE_DIR}/src/*.cpp)
FILE(GLOB SRC_LIST_C ${PROJECT_SOURCE_DIR}/src/*.c)
#指定头文件目录
INCLUDE_DIRECTORIES(${PROJECT_SOURCE_DIR}/include)
#指定生成库文件的目录
SET(LIBRARY_OUTPUT_PATH ${PROJECT_SOURCE_DIR}/lib)
#去变量SRC_LIST_CPP 与SRC_LIST_C 指定生成libmyprint 动态库   默认生成静态库  SHARED指定生成库类型为动态库
ADD_LIBRARY(myprint SHARED ${SRC_LIST_CPP} ${SRC_LIST_C})
```

设置变量：set file aux_source_directory
指定目录：include_directories link_directories
生成文件 add_executable add_library
链接库 target_link_libraries