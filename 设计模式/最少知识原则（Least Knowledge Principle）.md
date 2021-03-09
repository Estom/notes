**最少知识原则（Least Knowledge Principle），或者称迪米特法则（Law of
Demeter），是一种面向对象程序设计的指导原则，它描述了一种保持代码松耦合的策略。**其可简单的归纳为：

>   Each unit should have only limited knowledge about other units: only units
>   "closely" related to the current unit.

>   每个单元对其他单元只拥有有限的知识，只了解与当前单元紧密联系的单元；

再简洁些：

>   Each unit should only talk to its friends; don't talk to strangers.

>   每个单元只能和它的 "朋友" 交谈，不能和 "陌生人" 交谈；

更简洁些：

>   **Only talk to your immediate friends.**

>   只和自己直接的 "朋友" 交谈。

应用到面向对象的程序设计中时，可描述为
"类应该与其协作类进行交互但无需了解它们的内部结构"。

>   A class should interact directly with its collaborators and be shielded from
>   understanding their internal structure.

迪米特法则（Law of Demeter）由 [Northeastern
University](http://www.northeastern.edu/) 的 [Ian
Holland](http://www.ccs.neu.edu/research/demeter/holland/) 在 1987 年提出，"Law
of Demeter" 名称是来自当时正在进行的一项研究 "[The Demeter
Project](http://www.ccs.neu.edu/research/demeter/)"。

>   Demeter = Greek Goddess of Agriculture; grow software in small steps.

在 2004 年，Karl Lieberherr 在其论文 "[Controlling the Complexity of Software
Designs](http://www.ccs.neu.edu/research/demeter/papers/icse-04-keynote/ICSE2004.pdf)"
中将 LoD 的定义由 "Only talk to your friends" 改进为：

>   **Only talk to your friends who share your concerns.**

改进后的原则称为 LoDC（Law of Demeter for
Concerns），它为软件设计带来了两个主要的益处：

>   It leads to better information hiding.

>   It leads to less information overload.

即，**更好的信息隐藏和更少的信息重载**。LoDC
原则在面向方面的软件开发（AOSD：Aspect-Oriented Software
Development）中有着良好的应用。

**最少知识原则在面向对象编程中的应用**

在 "Law of Demeter" 应用于面向对象编程中时，可以简称为 "LoD-F：Law of Demeter
for Functions/Methods"。

对于对象 O 中的一个方法 m ，m 方法仅能访问如下这些类型的对象：

1.  O 对象自身；

2.  m 方法的参数对象；

3.  任何在 m 方法内创建的对象；

4.  O 对象直接依赖的对象；

具体点儿就是，对象应尽可能地避免调用由另一个方法返回的对象的方法。

现代面向对象程序设计语言通常使用 "." 作为访问标识，LoD 可以被简化为
"仅使用一个点（use only one dot）"。也就是说，代码 a.b.Method() 违反了 LoD，而
a.Method() 则符合
LoD。打个比方，人可以命令一条狗行走，但是不应该直接指挥狗的腿行走，应该由狗去指挥它的腿行走。

你是否见过类似下面这样儿的代码？

1 public Emailer(Server server) {…} // taking a server in the constructor2
public void sendSupportEmail(String message, String toAddress) { 3 EmailSystem
emailSystem = server.getEmailSystem(); 4 String fromAddress =
emailSystem.getFromAddress(); 5
emailSystem.getSenderSubsystem().send(fromAddress, toAddress, message); 6 }

上面这个设计有几点问题：

1.  复杂而且看起来不必要。Emailer 与多个它可能不是真的需要的 API 进行交互，例如
    EmailSystem。

2.  依赖于 Server 和 EmailSystem 的内部结构，如果两者之一进行了修改，则 Emailer
    有可能被破坏。

3.  不能重用。任何其他的 Server 实现也必须包含一个能返回 EmailSystem 的 API。

除了上面这几个问题之外，还有一个问题是这段代码是可测试的吗？你可能会说肯定可测啊，因为这个类使用了依赖注入（Dependency
Injection），我们可以模拟 Server、EmailSystem 和 Sender
类。但真正的问题是，除了多出了这些模拟代码，任何对 API
的修改都将破坏所有的测试用例，使得设计和测试都变得非常脆弱。

解决上述问题的办法就是应用最少知识原则，仅通过构造函数注入直接依赖的对象。Emailer
无需了解是否 Server 类包含了一个 EmailSystem，也不知道 EmailSystem 包含了一个
Sender。

1 public Emailer(Sender sender, String fromAddress) {…} 2 public void
sendSupportEmail(String message, String toAddress) { 3 sender.send(fromAddress,
toAddress, message); 4 }

这个设计较为合理些。现在 Emailer 不再依赖 Server 和
EmailSystem，而是通过构造函数得到了所有的依赖项。同时 Emailer
也变得更容易理解，因为所有与其交互的对象都显式的呈现出来。

Emailer 与 Server 和 EmailSystem 也达到了解耦合的效果。Emailer 不再需要了解
Server 和 EmailSystem 的内部结构，任何对 Server 和 EmailSystem
的修改都不再会影响 Emailer。

而且，Emailer 的变得更易被复用。如果切换到另外一个环境中时，仅需实现一个不同的
Sender 即可。

对于测试而言，现在我们仅需模拟 Sender 依赖即可。

**应用最少知识原则优点和缺点**

优点：遵守 Law of Demeter 将降低模块间的耦合，提升了软件的可维护性和可重用性。

缺点：应用 Law of Demeter
可能会导致不得不在类中设计出很多用于中转的包装方法（Wrapper
Method），这会提升类设计的复杂度。

**面向对象设计的原则**

|  SRP |  [单一职责原则](http://www.cnblogs.com/gaochundong/p/single_responsibility_principle.html) |  [Single Responsibility Principle](http://www.cnblogs.com/gaochundong/p/single_responsibility_principle.html) |
|------|--------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------|
|  OCP |  [开放封闭原则](http://www.cnblogs.com/gaochundong/p/open_closed_principle.html)           |  [Open Closed Principle](http://www.cnblogs.com/gaochundong/p/open_closed_principle.html)                     |
|  LSP |  [里氏替换原则](http://www.cnblogs.com/gaochundong/p/liskov_substitution_principle.html)   |  Liskov Substitution Principle                                                                                |
|  ISP |  [接口分离原则](http://www.cnblogs.com/gaochundong/p/interface_segregation_principle.html) |  [Interface Segregation Principle](http://www.cnblogs.com/gaochundong/p/interface_segregation_principle.html) |
|  DIP |  [依赖倒置原则](http://www.cnblogs.com/gaochundong/p/dependency_inversion_principle.html)  |  [Dependency Inversion Principle](http://www.cnblogs.com/gaochundong/p/dependency_inversion_principle.html)   |
|  LKP |  [最少知识原则](http://www.cnblogs.com/gaochundong/p/least_knowledge_principle.html)       |  [Least Knowledge Principle](http://www.cnblogs.com/gaochundong/p/least_knowledge_principle.html)             |
