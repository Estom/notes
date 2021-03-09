## linux下gcc默认搜索头文件及库文件的路径

### 头文件

gcc 在编译时如何去寻找所需要的头文件：

1. 所有header file的搜寻会从-l开始
2. 然后找gcc的环境变量

C_INCLUDE_PATH，CPLUS_INCLUDE_PATH，OBJC_INCLUDE_PATH

3. 再找内定目录

```
/usr/include
/usr/local/include
/usr/lib/gcc-lib/i386-linux/2.95.2/include
/usr/lib/gcc-lib/i386-linux/2.95.2/……/……/……/……/include/g++-3
/usr/lib/gcc-lib/i386-linux/2.95.2/……/……/……/……/i386-linux/include
# 库文件但是如果装gcc的时候，是有给定的prefix的话，那么就是
/usr/include
prefix/include
prefix/xxx-xxx-xxx-gnulibc/include
prefix/lib/gcc-lib/xxxx-xxx-xxx-gnulibc/2.8.1/include
```

### 库文件
> cos（）等函式库的选项要多加 -lm

编译的时候：

1. gcc会去找-L
2. 再找gcc的环境变量LIBRARY_PATH
3. 再找内定目录 /lib /usr/lib /usr/local/lib这是当初compile gcc时写在程序内的


### 动态库的搜索路径
1. 在配置文件/etc/ld.so.conf中指定动态库搜索路径
2. 通过环境变量LD_LIBRARY_PATH指定动态库搜索路径（当通过该环境变量指定多个动态库搜索路径时，路径之间用冒号"："分隔）
3. 在编译目标代码时指定该程序的动态库搜索路径（还可以在编译目标代码时指定程序的动态库搜索路径。

    这是通过gcc 的参数"-Wl，-rpath，"指定（如例3所示）。当指定多个动态库搜索路径时，路径之间用冒号"："分隔）


4. 默认的动态库搜索路径/lib
5. 默认的动态库搜索路径/usr/lib


可以通过执行可执行文件pos得到的结果不同获知其搜索到了哪个动态库，从而获得第1个动态库搜索顺序，然后删除该动态库，再执行程序pos，获得第2个动态库搜索路径，再删除第2个被搜索到的动态库，如此往复，将可得到Linux搜索动态库的先后顺序。
程序pos执行的输出结果和搜索到的动态库的对应关系如表1所示
程序pos输出结果使用的动态库对应的动态库搜索路径指定方式
```
./ ./libpos.so 编译目标代码时指定的动态库搜索路径
/root/test/env/lib /root/test/env/lib/libpos.so环境变量LD_LIBRARY_PATH指定的动态库搜索路径
/root/test/conf/lib /root/test/conf/lib/libpos.so配置文件/etc/ld.so.conf中指定的动态库搜索路径
/lib /lib/libpos.so 默认的动态库搜索路径/lib
/usr/lib /usr/lib/libpos.so 默认的动态库搜索路径/usr/lib
```

综合以上结果可知，动态库的搜索路径搜索的先后顺序是：

1. 编译目标代码时指定的动态库搜索路径；
2. 环境变量LD_LIBRARY_PATH指定的动态库搜索路径；
3. 配置文件/etc/ld.so.conf中指定的动态库搜索路径；
4. 默认的动态库搜索路径/lib；
5. 默认的动态库搜索路径/usr/lib.

 

g++ -std=c++11  con_var.cpp -lpthread

## 链接过程
https://www.jianshu.com/p/4510b47ecd8a

https://blog.csdn.net/caikunbob/article/details/85550000


明白一件事。

C/C++ 经过编译汇编，生成二进制文件，只需要搜索头文件，找到函数的相关声明，即可正常编译。

C/C++ 经过链接，需要搜索头文件中指定的库文件，编译相关的函数，生成二进制文件，然后进行链接，生成目标文件。