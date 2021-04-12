# gcc

> 当前会这一种调试就行了。cmake编译构建工具以后再学。msvc编译构建工具为啥不直接使用vscode呢。


## 1 条件

* vscode
* MinGW-gcc/g++
* addon-C/C++

## 2 创建helloworld

```C
#include <iostream>
#include <vector>
#include <string>

using namespace std;

int main()
{
    vector<string> msg {"Hello", "C++", "World", "from", "VS Code", "and the C++ extension!"};

    for (const string& word : msg)
    {
        cout << word << " ";
    }
    cout << endl;
}
```

## 3 编译helloworld
> tasks.json

* tasks负责执行一些任务。主要由vscode的脚本提供支持。是vscode用来运行操作系统脚本的工具。
* tasks可以在`命令列表>tasks:`中找到， **其中C/C++插件提供了默认的内容** 。
```json
{
  "version": "2.0.0",
  "tasks": [
    {
      "type": "shell",
      "label": "C/C++: g++.exe build active file",
      "command": "C:\\Program Files\\mingw-w64\\x86_64-8.1.0-posix-seh-rt_v6-rev0\\mingw64\\bin\\g++.exe",
      "args": ["-g", "${file}", "-o", "${fileDirname}\\${fileBasenameNoExtension}.exe"],
      "options": {
        "cwd": "${workspaceFolder}"
      },
      "problemMatcher": ["$gcc"],
      "group": {
        "kind": "build",
        "isDefault": true
      }
    }
  ]
}
```

## 4 运行helloworld
> launch.json

* launch负责运行和调试任务。主要由vscode脚本提供支持。也是vscode用来兼容系统调试工具的。
* launch有可视化的界面，`运行`栏目和左侧的`Debug`栏目都能生成launch文件，配置运行和调试任务。其中 **c/c++插件提供了默认的运行和调试内容** 。

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "g++.exe - Build and debug active file",
      "type": "cppdbg",
      "request": "launch",
      "program": "${fileDirname}\\${fileBasenameNoExtension}.exe",
      "args": [],
      "stopAtEntry": false,
      "cwd": "${workspaceFolder}",
      "environment": [],
      "externalConsole": false,
      "MIMode": "gdb",
      "miDebuggerPath": "C:\\Program Files\\mingw-w64\\x86_64-8.1.0-posix-seh-rt_v6-rev0\\mingw64\\bin\\gdb.exe",
      "setupCommands": [
        {
          "description": "Enable pretty-printing for gdb",
          "text": "-enable-pretty-printing",
          "ignoreFailures": true
        }
      ],
      "preLaunchTask": "C/C++: g++.exe build active file"
    }
  ]
}
```

## 5 调试helloworld

1. 启用调试会话。启动调试会话的方式主要有三种：菜单栏-运行。侧边栏-调试。C/C++命令行：生成和调试任务。
2. 设置调试断点
3. 选择调试步骤：跳过过程、进入过程、跳出过程
4. 选择调试变量

## 6 环境配置
> c_cpp_properties.json

* c_cpp_properties.json提供了继承环境的配置功能。主要用来配置c/c++插件
* c_cpp_properties可以在 **C/C++插件的命令列表** 里选择配置。
* includePath 仅当程序包含工作空间或标准库路径中没有的头文件时，才需要添加到“包含路径数组”设置中。
* compilerPath设置来推断C ++标准库头文件的路径。当扩展知道在哪里可以找到那些文件时，它可以提供诸如智能补全和“转到定义”导航之类的功能。

```json
{
  "configurations": [
    {
      "name": "GCC",
      "includePath": ["${workspaceFolder}/**"],
      "defines": ["_DEBUG", "UNICODE", "_UNICODE"],
      "windowsSdkVersion": "10.0.18362.0",
      "compilerPath": "C:/Program Files/mingw-w64/x86_64-8.1.0-posix-seh-rt_v6-rev0/mingw64/bin/g++.exe",
      "cStandard": "c11",
      "intelliSenseMode": "gcc-x64"
    }
  ],
  "version": 4
}
```