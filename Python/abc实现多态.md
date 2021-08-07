## 多态的含义
* 多态性是指具有不同功能的函数可以使用相同的函数名，这样就可以用一个函数名调用不同内容的函数。在面向对象方法中一般是这样表述多态性：向不同的对象发送同一条消息，不同的对象在接收时会产生不同的行为（即方法）。也就是说，每个对象可以用自己的方式去响应共同的消息。所谓消息，就是调用函数，不同的行为就是指不同的实现，即执行不同的函数。

```
# 动物类 都有名字这个属性   和吃这个方法
class Animal(object):
   def __init__(self,name):
      self.name=name
   def eat(self):
      print(self.name+"吃1111111111111111")
  
# 让定的猫这个属性去继承动这个方法

class Cat(Animal):
   def __init__(self, name):
      # self.name=name
      super(Cat, self).__init__(name)


# 让mouse去继承动物这个类  
class Mouse(Animal):
   def __init__(self,name):

      #self.name=name
      super(Mouse,self).__init__(name)
 
# 定义一个人类可以喂任何动物
tom=Cat("tom")
# 创建老鼠
jerry=Mouse("jerry")

tom.eat()
jerry.eat()
  

```


## 多态实现
```
import abc   ( metaclass=abc.ABCMeta)
```

* Python本身不提供抽象类和接口机制，要想实现抽象类，可以借助abc模块。ABC是Abstract Base Class的缩写

### @abc.abstractmethod装饰器

* 加上@abc.abstractmethod装饰器后严格控制子类必须实现这个方法
```
class C:
    __metaclass__ = ABCMeta
    @abstractmethod
    def my_abstract_method(self, ...):
```
```py
import abc
class Animal(metaclass=abc.ABCMeta):  # 同一类事物:动物
    @abc.abstractmethod                   # 上述代码子类是约定俗称的实现这个方法，加上@abc.abstractmethod装饰器后严格控制子类必须实现这个方法
    def talk(self):
        raise AttributeError('子类必须实现这个方法')


class People(Animal):  # 动物的形态之一:人
    def talk(self):
        print('say hello')


class Dog(Animal):  # 动物的形态之二:狗
    def talk(self):
        print('say wangwang')


class Pig(Animal):  # 动物的形态之三:猪
    def talk(self):
        print('say aoao')


peo2 = People()
pig2 = Pig()
d2 = Dog()

peo2.talk()
pig2.talk()
d2.talk()
```
### @abc.abstractproperty()

表明一个抽象属性

```py
class C:
    __metaclass__ = ABCMeta
    @abstractproperty
    def my_abstract_property(self):
```

### abc.ABCMeta

这是用来生成抽象基础类的元类。由它生成的类可以被直接继承。


```py
from abc import ABCMeta
 
class MyABC:
    __metaclass__ = ABCMeta
 
MyABC.register(tuple)
 
assert issubclass(tuple, MyABC)
assert isinstance((), MyABC)
```
上面这个例子中，首先生成了一个MyABC的抽象基础类，然后再将tuple变成它的虚拟子类。然后通过issubclass或者isinstance都可以判断出tuple是不是出于MyABC类。

也可以通过复写__subclasshook__(subclass)来实现相同功能，它必须是classmethod
```
class Foo(object):
    def __getitem__(self, index):
        ...
    def __len__(self):
        ...
    def get_iterator(self):
        return iter(self)
 
class MyIterable:
    __metaclass__ = ABCMeta
 
    @abstractmethod
    def __iter__(self):
        while False:
            yield None
 
    def get_iterator(self):
        return self.__iter__()
 
    @classmethod
    def __subclasshook__(cls, C):
        if cls is MyIterable:
            if any("__iter__" in B.__dict__ for B in C.__mro__):
                return True
        return NotImplemented
```