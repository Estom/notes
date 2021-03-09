sys 模块
sys 模块提供了特定系统的配置和操作。



方法
说明




sys.platform
用来构建解释器的操作系统平台


sys.version
构建时的版本信息, 包含完整的版本号和构建日期、编译器、平台信息等


sys.version_info
同样是版本信息, 但不是字符串, 可以直接获得对应类型版本的信息


sys.path[0]
搜索模块的路径列表


sys.modules.get()
已经导入的模块列表


sys.getrefcount()
查看对象的引用计数


sys.getsizeof()
以字节（byte）为单位返回对象大小。这个对象可以是任何类型的对象。 所以内置对象都能返回正确的结果 但不保证对第三方扩展有效，因为和具体实现相关。

作者：江洋林澜
链接：https://www.jianshu.com/p/87a40fbac17f
來源：简书
简书著作权归作者所有，任何形式的转载都请联系作者获得授权并注明出处。


sys.getrefcount
Python 使用引用计数和垃圾回收来完成字段的内存管理, 当一个对象的引用数降为 0, 就会自动标记为回收。在实际开发中, 可能因为 debug 或者调试的需要, 需要了解引用计数, 就可以使用 sys.getrefcount()。
import sys

d = []

print(sys.getrefcount(d))
# 输出 2

x = d

print(sys.getrefcount(d))
# 输出 3

del x

print(sys.getrefcount(d))
# 输出 2

上面的计数比预期多一个, 是因为 getrefcount() 本身也会维护一个临时引用。
sys.getsizeof
了解对象的引用计数不足以发现内存泄漏, 可以使用 sys.getsizeof 辅助, 这样可以确定对象消耗内存的情况。
# 打印 Python 内置数据结构占用的字节数
for obj in ({}, [], (), 'string', 1, 12.3):
    print(obj.__class__.__name__, sys.getsizeof(obj))

# 输出:
dict 240
list 64
tuple 48
str 55
int 28
float 24


命令行参数 sys.argv
在命令行下运行一个 Python 程序, 可以通过 sys.argv 获取脚本的名字和参数。有个 argv.py, 代码如下:
import sys

script_name, *args = sys.argv

print(f'Script: {script_name}')
print(f'Arguments: {args}')

> python argv.py
Script: argv.py
Arguments: []

> python argv.py -v
Script: argv.py
Arguments: ['-v']

> python argv.py -v -v -e 'foo'
Script: argv.py
Arguments: ['-v', '-v', '-e', "'foo'"]

作者：江洋林澜
链接：https://www.jianshu.com/p/87a40fbac17f
來源：简书
简书著作权归作者所有，任何形式的转载都请联系作者获得授权并注明出处。