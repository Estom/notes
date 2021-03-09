设计模式之美：Creational Patterns（创建型模式）

创建型模式（Creational Patterns）抽象了对象实例化过程。

它们帮助一个系统独立于如何创建、组合和表示它的那些对象。

-   一个类创建型模式使用继承改变被实例化的类。

-   一个对象创建型模式将实例化委托给另一个对象。

随着系统演化得越来越依赖于对象复合而不是类的继承，创建型模式变得更为重要。

在这些模式中，有两个不断出现的主旋律：

1.  它们都将关于该系统使用那些具体的类的信息封装起来。

2.  它们隐藏了这些类的实例是如何被创建和放在一起的。

**因此，创建型模式在什么被创建，谁创建它，它是怎样被创建的，以及何时创建这些方面给予你很大的灵活性。**

**Consequently, the creational patterns give you a lot of flexibility in what
gets created, who creates it, how it gets created, and when.**

-   **Factory Method （工厂方法）**

    -   Define an interface for creating an object, but let subclasses decide
        which class to instantiate. Factory Method lets a class defer
        instantiation to subclasses.

    -   定义一个用于创建目标对象的接口，让子类决定实例化哪一个目标类。Factory
        Method 使一个类的实例化延迟到其子类。

-   **Prototype （原型）**

    -   Specify the kinds of objects to create using a prototypical instance,
        and create new objects by copying this prototype.

    -   用原型实例指定创建对象的种类，并且通过拷贝这些原型创建新的对象。

-   **Abstract Factory （抽象工厂）**

    -   Provide an interface for creating families of related or dependent
        objects without specifying their concrete classes.

    -   提供一个创建一系列相关或相互依赖对象的接口，而无需指定它们具体的类。

-   **Builder （生成器）**

    -   Separate the construction of a complex object from its representation so
        that the same construction process can create different representations.

    -   将一个复杂对象的构建与它的表示分离，使得同样的构建过程可以创建不同的表示。

-   **Singleton （单件）**

    -   Ensure a class only has one instance, and provide a global point of
        access to it.

    -   保证一个类仅有一个实例，并提供一个访问它的全局访问点。

用一个系统创建的那些对象的类对系统进行参数化有两种方法。

**方法一：生成创建对象的类的子类（Subclass）；这对应于使用 Factory Method
模式。**

这种方法的缺点是，仅为了改变产品类，就可能需要创建一个新的子类。这样的改变可能是级联的。

**方法二：对系统进行参数化的方法依赖于对象复合（Composition），定义一个对象负责明确产品对象的类，并将它作为该系统的参数。**

这是 Abstract Factory、Builder、Prototype 模式的关键特征。

这三种模式都涉及到创建一个新的负责创建产品对象的“工厂对象”。

-   Abstract Factory 由这个工厂对象产生多个类的对象。

-   Builder 由这个工厂对象使用一个相对复杂的协议，逐步创建一个复杂产品。

-   Prototype
    由该工厂对象通过拷贝原型对象来创建产品对象。在这种情况下，因为原型负责返回产品对象，所以工厂对象和原型是同一个对象。

Factory Method 使一个设计可以定制且只略微有一些复杂。其他设计模式需要新的类，而
Factory Method 只需要一个新的操作。

使用 Abstract Factory、Builder、Prototype 的设计比使用 Factory Method
的设计更灵活，但它们也更加复杂。

**通常，设计以使用 Factory Method
开始，并且当设计者发现需要更大的灵活性时，设计便会向其他创建型模式演化。**
