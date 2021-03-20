1、python里import tensorflow时报
```
“ImportError: /lib64/libc.so.6: version 'GLIBC_2.17' not found (required by /usr/local/lib/python2.7/site-packages/tensorflow/python/_pywrap_tensorflow.so)”
```
##### 原因
> 主要是glibc的版本太低，默认的CentOS 6.5 glibc版本最高为2.12

##### 解决
执行： strings /lib64/libc.so.6|grep GLIBC

查看目前系统支持的glibc的版本
```
[root@zhx-tserver2 build-2.17]# strings /lib64/libc.so.6|grep GLIBC
GLIBC_2.2.5
GLIBC_2.2.6
GLIBC_2.3
GLIBC_2.3.2
GLIBC_2.3.3
GLIBC_2.3.4
GLIBC_2.4
GLIBC_2.5
GLIBC_2.6
GLIBC_2.7
GLIBC_2.8
GLIBC_2.9
GLIBC_2.10
GLIBC_2.11
GLIBC_2.12
GLIBC_PRIVATE
```

tensorflow需要glibc-2.17，需要升级glibc

1. 下载glibc2.17：
```
wget http://ftp.gnu.org/gnu/glibc/glibc-2.17.tar.gz
```
2. 解压：
```
tar -xzf glibc-2.17.tar.gz
```
3. 创建build目录：
```
mkdir build
```
4. 进入build目录编译glibc:
```
cd build
../glibc-2.17/configure --prefix=/usr --disable-profile --enable-add-ons --with-headers=/usr/include --with-binutils=/usr/bin
make -j4
make install
```

> 注：如果执行configure的时候报configure: error: support for --no-whole-archive is needed，则把configure命令改成
../glibc-2.17/configure --prefix=/usr --disable-profile --enable-add-ons --with-headers=/usr/include


5. 查看GLIBC版本执行 strings /lib64/libc.so.6|grep GLIBC查看版本已经支持 GLIBC_2.17
```
[root@zhx-tserver2 build-2.17]# strings /lib64/libc.so.6|grep GLIBC
GLIBC_2.2.5
GLIBC_2.2.6
GLIBC_2.3
GLIBC_2.3.2
GLIBC_2.3.3
GLIBC_2.3.4
GLIBC_2.4
GLIBC_2.5
GLIBC_2.6
GLIBC_2.7
GLIBC_2.8
GLIBC_2.9
GLIBC_2.10
GLIBC_2.11
GLIBC_2.12
GLIBC_2.13
GLIBC_2.14
GLIBC_2.15
GLIBC_2.16
GLIBC_2.17
GLIBC_PRIVATE
```


2、python里import tensorflow时
```
ImportError: /usr/lib64/libstdc++.so.6: version `GLIBCXX_3.4.18' not found (required by /opt/jmr/anaconda2/lib/python2.7/site-packages/tensorflow/python/_pywrap_tensorflow.so)
```

##### 原因

GLIBCXX的版本太低，也需要更新。

##### 解决

拷贝一个libstdc++.so.6.0.18到/usr/lib64/目录，做个软连接即可
```
cp libstdc++.so.6.0.18 /usr/lib64/
cd /usr/lib64/
ln -sf libstdc++.so.6.0.18 libstdc++.so.6
```


3、python里import tensorflow时
```
ImportError: /usr/local/python27/lib/python2.7/site-packages/tensorflow/python/_pywrap_tensorflow_internal.so: undefined symbol: PyUnicodeUCS4_FromString
```

##### 原因
如果自己单独升级了python,或者有多个版本的python时,便有可能出现此问题.

问题表象为:
```
undefined symbol: PyUnicodeUCS2_AsUTF8String
```
或者
```
undefined symbol: PyUnicodeUCS4_AsUTF8String.
```

根本原因时python和某个你用的库编译时指定的UCS编码方式不对.
编译python时,可以通过指定--enable-unicode[=ucs[24]]来选择使用UCS2或者UCS4.

如果你的错误是undefined symbol: PyUnicodeUCS2_AsUTF8String,说明你的python编译时使用的是UCS4,反之依然.
##### 解决

1. 重新编译python2或者重新编译库.选择一般是重新编译库.

我这重新编译python,因为报错是PyUnicodeUCS4_FromString，说明tensorflow是用UCS4编译的，而python是UCS2编译的:  
重新编译时设置unicode为ucs4
```
./configure --prefix=/usr/local/python27 --enable-unicode=ucs4
```

> python2.7.默认是使用UCS2.

> linux比windows好用好多啊，python2与python3可以完美共存，而别只需要建立不同的软连接就能实现不同的调用，太完美了。而且所有的软件也都是文件，不会有后缀名不同的各种文件混淆，只要文件内容是正确的就能完整使用。

--------------------- 
作者：[黑色外套](https://blog.csdn.net/qq708986022/article/details/77896791) 