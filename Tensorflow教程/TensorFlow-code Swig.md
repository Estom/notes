前端多语言编程环境与后端C++实现系统的通道归功于 Swig 的包装器

TensorFlow使用Bazel的构建工具，在系统编译之前启动Swig的代码生成过程，通过tensorflow.i自动生成了两个适配 (Wrapper)文件：


1. pywrap_tensorflow_internal.py: 负责对接上层 Python 调用；
2. pywrap_tensorflow_internal.cc: 负责对接下层 C API 调用。

pywrap_tensorflow_internal.py 模块被导入时，会加载_pywrap_tensorflow_internal.so动态链接库，它里面包含了所有运行时接口的符号。而pywrap_tensorflow_internal.cc中，则注册了一个函数符号表，实现Python接口和C接口的映射。运行时，就可以通过映射表，找到Python接口在C层的实现了。

![img](https://img.alicdn.com/tfs/TB1KiVFpH2pK1RjSZFsXXaNlXXa-1340-1440.png)

https://blog.csdn.net/u013510838/article/details/84103503

