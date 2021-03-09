设计模式之美：Structural Patterns（结构型模式）

结构型模式涉及到如何组合类和对象以获得更大的结构。

-   结构型类模式采用继承机制来组合接口实现。

-   结构型对象模式不是对接口和实现进行组合，而是描述了如何对一些对象进行组合，从而实现新功能的一些方法。

因为可以在运行时改变对象组合关系，所以对象组合方式具有更大的灵活性，而这种机制用静态组合是不可能实现的。

-   **Adapter（适配器）**

    -   将一个类的接口转换成客户希望的另外一个接口。

    -   Adapter 模式使得原本由于接口不兼容而不能一起工作的那些类可以一起工作。

    -   Convert the interface of a class into another interface clients expect.

    -   Adapter lets classes work together that couldn't otherwise because of
        incompatible interfaces.

-   **Bridge（桥接）**

    -   将抽象部分与它的实现部分分离，使它们都可以独立地变化。

    -   Decouple an abstraction from its implementation so that the two can vary
        independently.

-   **Composite（组合）**

    -   将对象组合成树形结构以表示 “部分-整体” 的层次结构。

    -   Composite 使得用户对于单个对象和组合对象的使用具有一致性。

    -   Compose objects into tree structures to represent part-whole
        hierarchies.

    -   Composite lets clients treat individual objects and compositions of
        objects uniformly.

-   **Decorator（装饰）**

    -   动态地给一个对象添加一些额外的职责。

    -   就增加功能来说，Decorator 模式相比生成子类更为灵活。

    -   Attach additional responsibilities to an object dynamically.

    -   Decorators provide a flexible alternative to subclassing for extending
        functionality.

-   **Facade（外观）**

    -   为子系统中的一组接口提供一个一致的界面。

    -   Facade 模式定义了一个高层接口，这个接口使得这一子系统更加容易使用。

    -   Provide a unified interface to a set of interfaces in a subsystem.

    -   Facade defines a higher-level interface that makes the subsystem easier
        to use.

-   **Flyweight（享元）**

    -   运用共享技术有效地支持大量细粒度的对象。

    -   Use sharing to support large numbers of fine-grained objects
        efficiently.

-   **Proxy（代理）**

    -   为其他对象提供一种代理以控制对这个对象的访问。

    -   Provide a surrogate or placeholder for another object to control access
        to it.

结构型模式之间存在很多相似性，尤其是它们的参与者和协作之间的相似性。

这是因为结构型模式依赖于同一个很小的语言机制集合构造代码和对象：

-   单继承和多重继承机制用于基于类的模式。

-   对象组合机制用于对象式模式。

**Adapter 和 Bridge 的相似性**

Adapter 模式和 Bridge
模式具有一些共同的特征。它们之间的不同之处主要在于它们各自的用途。

Adapter
模式主要是为了解决两个已有接口之间不匹配的问题。它不考虑这些接口时怎么实现的，也不考虑它们各自可能会如何演化。

Bridge 模式则对抽象接口和它的实现部分进行桥接。它为用户提供了一个稳定的接口。

Adapter 模式和 Bridge 模式通常被用于软件生命周期的不同阶段。

当你发现两个不兼容的类必须同时工作时，就有必要使用 Adapter
模式，以避免代码重复。此处耦合不可见。

相反，Bridge
的使用者必须事先知道：一个抽象将有多个实现部分，并且抽象和实现两者是独立演化得。

**Composite 和 Decorator 的相似性**

Composite 和 Decorator
模式具有类似的结构图，这说明它们都基于递归组合来组织可变数目的对象。

Decorator
旨在使你能够不需要生成子类即可给对象添加职责。这就避免了静态实现所有功能组合，从而导致子类急剧增加。

Composite
则有不同的目的，它旨在构造类，使多个相关的对象能够以统一的方式处理，而多重对象可以被当作一个对象来处理。它重点不在于修饰，而在于表示。

**Decorator 和 Proxy 的相似性**

Decorator 和 Proxy 模式描述了怎样为对象提供一定程度上的间接引用。

Decorator 和 Proxy
对象的实现部分都保留了指向另一个对象的指针，它们向这个对象发送请求。

同样，它们也具有不同的设计目的。

Proxy
不能动态地添加和分离性质，它也不是为递归组合而设计的。它的目的是，当直接访问一个实体不方便或不符合需要时，为这个实体提供一个替代者。

在 Proxy 中，实体定义了关键功能，而 Proxy 提供对它的访问。

在 Decorator 中，组件仅提供了部分功能，而 Decorator 负责完成其他功能。
