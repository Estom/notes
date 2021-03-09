os 模块
os 模块中主要包含创建和管理进程或者文件系统内容(比如文件和目录)的函数, os 模块为平台特定的一些模块做了包装, 使得所有平台访问的函数接口相同, 这样就具备了可移植性。下面是 os 模块下一些常用的函数:



方法
说明
用法举例




os.getcwd()
获取当前所在的目录
os.getcwd()


os.chdir()
切换目录
os.chdir('..') (.. 为父级目录, 这里表示切换到上一级目录, 相当于命令行的 cd ..)


os.getenv()
获取系统变量的值(若变量不存在返回 None)
os.getenv('SHELL')


os.environ.getenv()
获取系统变量的值(若变量不存在会引发异常)
os.environ.getenv('SHELL')


os.listdir()
列出目录下的全部文件
os.listdir('dir'), 列出 dir 目录下的全部文件


os.walk()
递归地遍历指定的目录, 对于每个目录都会生成一个元组, 其中包含了目录的路径、该目录下所有的子目录以及该目录下所有文件的列表。它是一个生成器, 可以用 list() 转换成一个列表
os.walk('dir'), list(os.walk('dir'))


os.makedir()
创建一个目录, 只能创建单层目录, 若创建多层目录会报错
os.makedir('dir'), 创建一个名为 dir 的目录


os.makedirs()
创建多层目录
os.makedirs('/dir2/dir3')


os.remove()
删除指定文件
os.remove('1.txt'), 删除当前目录下的 1.txt 文件


os.rmdir()
删除目录
os.rmdir('dir1'), 删除当前目录下的 dir 目录


os.rename()
重命名文件或者目录
os.rename('dir2', 'dir1'), 将 dir2 目录重命名为 dir1

作者：江洋林澜
链接：https://www.jianshu.com/p/87a40fbac17f
來源：简书
简书著作权归作者所有，任何形式的转载都请联系作者获得授权并注明出处。



os.path 模块、
os 模块下有一个独有的 path 子模块, 可以使用 os.path.函数名字 的方式调用, 也可以 import os.path。os.path 模块是和路径有关的。下面是此模块下一些常用的函数:



方法
说明




os.path.basename()
获得指定文件路径的文件名字


os.path.dirname()
获得文件路径的目录名字


os.path.exists()
判断文件或者目录是否存在


os.path.isdir()
判断指定路径是否是目录


os.path.isfile()
判断指定路径是否是文件


os.path.join()
拼接路径


os.path.split()
路径拆分


os.path.splitext()
获得路径的后缀



In: import os

In: p = '/home/jiangyang/a.txt'

In: os.path.basename(p) # 获得指定文件路径的文件名字
Out:
a.txt

In: os.path.dirname(p) # 获得文件路径的目录名字
Out:
/home/ubuntu

In: os.path.join('\\Users', 'jiangyang', 'flask\\app.py') # windows 下
Out:
\Users\jiangyang\flask\app.py

In: os.path.join('/Users', 'jiangyang', 'flask/app.py') # Ubuntu 下
Out:
/Users/jiangyang/flask/app.py

In: os.path.split(p) # 路径拆分
Out:
('/home/ubuntu', 'a.txt')

In: os.path.splitext(p) # 获得路径的后缀
Out:
('/home/ubuntu/a', '.txt')

作者：江洋林澜
链接：https://www.jianshu.com/p/87a40fbac17f
來源：简书
简书著作权归作者所有，任何形式的转载都请联系作者获得授权并注明出处。