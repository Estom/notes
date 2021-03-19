当你创建了一个列表，你可以逐项地读取这个列表。这个过程就是迭代

**[python]** [view
plain](http://blog.csdn.net/a168861888m/article/details/78293251)
[copy](http://blog.csdn.net/a168861888m/article/details/78293251)

1.  \<span style="font-family:'Times New Roman';font-size:14px;"\>\>\>\> mylist
    = [1, 2, 3]

2.  \>\>\> **for** i **in** mylist:

3.  ... **print**(i)

4.  1

5.  2

6.  3\</span\>

mylist是一个可迭代对象。当你使用一个列表生成式的时候，你创建了一个列表，也就是一个可迭代对象

**[python]** [view
plain](http://blog.csdn.net/a168861888m/article/details/78293251)
[copy](http://blog.csdn.net/a168861888m/article/details/78293251)

1.  \<span style="font-family:'Times New Roman';font-size:14px;"\>\>\>\> mylist
    = [x\*x **for** x **in** range(3)]

2.  \>\>\> **for** i **in** mylist:

3.  ... **print**(i)

4.  0

5.  1

6.  4\</span\>

所有你可以使用 "for...in..."的都是可迭代对象：列表，字符串，文件等等

你经常使用它们因为你可以如你所愿的读取其中的元素，但是你把所有的数据都存贮在内存里，如果你有许多数据的话，这种做法不会是你想要的

生成器

生成器都是可以迭代的，但是你只可以迭代它们一次，因为他们并不是把所有的数据存贮在内存中，它是实时的生成数据

**[python]** [view
plain](http://blog.csdn.net/a168861888m/article/details/78293251)
[copy](http://blog.csdn.net/a168861888m/article/details/78293251)

1.  \<span style="font-family:'Times New Roman';font-size:14px;"\>\>\>\>
    mygenerator = (x\*x **for** x **in** range(3))

2.  \>\>\> **for** i **in** mygenerator:

3.  ... **print**(i)

4.  0

5.  1

6.  4\</span\>

看上去都是一样的，除了使用（）而不是 []。但是你不可以再次使用 for i in
mygenerator
因为生成器只能被逆代一次：他们先计算出0，然后就丢掉了0，然后再继续逐项计算1，计算4

Yield

yield是一个类似 return的关键字，不同的是这个函数返回的是一个生成器

**[python]** [view
plain](http://blog.csdn.net/a168861888m/article/details/78293251)
[copy](http://blog.csdn.net/a168861888m/article/details/78293251)

1.  \<span style="font-family:'Times New Roman';font-size:14px;"\>\>\>\> **def**
    createGenerator():

2.  ... mylist = range(3)

3.  ... **for** i **in** mylist:

4.  ... **yield** i\*i

5.  ...

6.  \>\>\> mygenerator = createGenerator() \# create a generator

7.  \>\>\> **print**(mygenerator) \# mygenerator is an object!

8.  \<generator object createGenerator at 0xb7555c34\>

9.  \>\>\> **for** i **in** mygenerator:

10. ... **print**(i)

11. 0

12. 1

13. 4\</span\>

这个例子没什么用途，但如果你的函数会返回一大批你只需要阅读一次的数据的时候，这是很方便的。

为了精通
yield，你必须理解：当你调用这个函数的时候，函数里的代码是不会马上执行的。这个函数只是返回生成器对象，这有点蹊跷不是吗？

那么，函数的代码什么时候开始执行呢？使用for迭代的时候

现在到了比较的难的一部分：

第一次迭代的时候，你的函数开始执行，从开始到达yield关键字，然后返回第一次迭代的值。然后，每次执行这个函数都会继续执行你在函数内部定义的那个循环的下一次，再返回那个值，直到没有可以返回的值。如果生成器内部没有定义yield
关键词，这个生成器被认为是空的。也有可能是因为循环已经结束或者没有满足“If/else”条件

\----------------------------------------------------------------------------------------------------------------------------------------（我是分割线）

更深入聊一下：什么时候使用 field 而不是 return？

yield语句暂停函数的执行，并向调用者发送一个值，但保留足够的状态以使函数能够在其被关闭的位置恢复。
恢复后，该功能在最后一次产量运行后立即继续执行。
**这允许其代码随时间产生一系列值，而不是一次计算它们，并将其像列表一样发送回来。**

我们来看一个例子：

**[python]** [view
plain](http://blog.csdn.net/a168861888m/article/details/78293251)
[copy](http://blog.csdn.net/a168861888m/article/details/78293251)

1.  \<span style="font-family:'Times New Roman';font-size:14px;"\>**def**
    simpleGeneratorFun():

2.  **yield** 1

3.  **yield** 2

4.  **yield** 3

5.  

6.  \# Driver code to check above generator function

7.  **for** value **in** simpleGeneratorFun():

8.  **print**(value)\</span\>

输出：

1 2 3

return返回一个指定的值给它的调用者，而yield可以产生一个值序列。当要遍历一个序列但又不想将整个序列存储在内存中的时候，我们应该使用yield

yield用于Python生成器中。
一个生成器函数被定义为一个正常的函数，但是只要它需要生成一个值，就应该使用 yield
关键字而不是return。 如果 def 的 body 包含 yield，则该函数自动成为生成器函数。

写博客也参考了一些资料（学习一般都是看英文的）：

（1）https://stackoverflow.com/questions/231767/what-does-the-yield-keyword-do?page=1&tab=votes\#tab-top

（2）http://www.geeksforgeeks.org/use-yield-keyword-instead-return-keyword-python/
