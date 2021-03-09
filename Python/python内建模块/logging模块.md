logging 模块
在代码中使用 print() 打印输出是临时性的调试用途的方案。如果希望在线上记录应用日志或者错误日志等, 可以使用 Python 自带的日志模块 logging。
常用的日志记录类型有两种, 一种是写到文件里面, 另外一种是终端输出。日志文件存储下来是为了未来回溯的方便, 终端输出是以便于实时查看。
logging 模块自带了 6 种级别的日志类型。级别如下(变量值越高说明级别越高):



日志级别
变量值




CRITICAL
50


ERROR
40


WARNING
30


INFO
20


DEBUG
10


NOTSET
0



In: import logging


In: logging.warning('Watch out!')
Out: WARNING:root:Watch out!


In: logging.debug("This message won't be printed")
# 无输出


In: logging.basicConfig(level=logging.WARNING) # 使用 basicConfig() 指定默认的日志级别


# getLogger() 自定义 logger 实例, 不同的项目会有自己固定的 logger, 如果能找到 logger 的名字, 就能拿到对应日志的实例
In: logger1 = logging.getLogger('package1.module1')
In: logger2 = logging.getLogger('package1.module2')

In: logger1.warning('This message comes from module1')
Out: WARNING:package1.module1:This message comes from module1
In: logger2.warning('This message comes from module2')
Out: WARNING:package1.module2:This message comes from module2

In: logger2.debug("This message won't be printed")
# 无输出

把日志写入文件
import logging

logging.basicConfig(filename='myapp.log',
level=logging.INFO) # 日志文件为 myapp.log, 级别是 INFO
logging.info('Started') # 写入一行 INFO 的日志 Started
print(logging.root.handlers) # 日志的处理器。root 是默认的一个 logger, 也就是日志实例, 否则得使用 getLogger() 的方式去获得一个 Logger 实例

> python loging_to_file.py
[<FileHandler /home/jiangyanglinlan/myapp.log (NOTSET)>]

> cat myapp.log
INFO:root:Started

最佳使用 logging 的方案
In : import logging
...:
...: logger = logging.getLogger() # 获得一个 logger 的实例
...: handler = logging.StreamHandler() # 实例化 logging 模块自带的 handler
...: formatter = logging.Formatter('%(asctime)s %(name)-12s %(levelname)-8s %(message)s') # 定制日志格式, name 为 logger 的名字(默认是 root), levelname 为日志的级别, message 是对应的日志内容
...: handler.setFormatter(formatter) # 设置 formatter
...: logger.addHandler(handler) # 给 logger 添加 handler
...: logger.setLevel(logging.DEBUG) # 设置 logger 的级别
...: logger.debug('This is a %s', 'test')
...:
DEBUG:root:This is a test
2018-04-02 18:34:08,443 root DEBUG this is a tes

logging 模块内置日志格式



格式
说明




%(name)s
生成日志的Logger名称。


%(levelno)s
数字形式的日志级别，包括DEBUG, INFO, WARNING, ERROR和CRITICAL。


%(levelname)s
文本形式的日志级别，包括’DEBUG’、 ‘INFO’、 ‘WARNING’、 ‘ERROR’ 和’CRITICAL’。


%(pathname)s
输出该日志的语句所在源文件的完整路径(如果可用)。


%(filename)s
文件名。


%(module)s
输出该日志的语句所在的模块名。


%(funcName)s
调用日志输出函数的函数名。


%(lineno)d
调用日志输出函数的语句所在的代码行(如果可用)。


%(created)f
日志被创建的时间，UNIX标准时间格式，表示从1970-1-1 00:00:00 UTC计算起的秒数。


%(relativeCreated)d
日志被创建时间与日志模块被加载时间的时间差，单位为毫秒。


%(asctime)s
日志创建时间。默认格式是 “2003-07-08 16:49:45,896”，逗号后为毫秒数。


%(msecs)d
毫秒级别的日志创建时间。


%(thread)d
线程ID(如果可用)。


%(threadName)s
线程名称(如果可用)。


%(process)d
进程ID(如果可用)。


%(message)s
日志信息。

作者：江洋林澜
链接：https://www.jianshu.com/p/87a40fbac17f
來源：简书
简书著作权归作者所有，任何形式的转载都请联系作者获得授权并注明出处。