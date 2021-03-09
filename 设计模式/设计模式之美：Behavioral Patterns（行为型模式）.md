行为型模式涉及到算法和对象间职责的分配。

行为模式不仅描述对象或类的模式，还描述它们之间的通信模式。

这些模式刻划了在运行时难以跟踪的复杂的控制流。它们将你的注意力从控制流转移到对象间的联系方式上来。

-   行为类模式使用继承机制在类间分派行为。

-   行为对象模式使用对象复合而不是继承。描述一组对等的对象怎样相互协作以完成任一个对象都无法完成的任务。

**行为型模式**

-   **Chain of Responsibility（职责链）**

    -   使多个对象都有机会处理请求，从而避免请求的发送者和接收者之间的耦合关系。

    -   将这些对象连成一条链，并沿着这条链传递该请求，直到有一个对象处理它位置。

    -   Avoid coupling the sender of a request to its receiver by giving more
        than one object a chance to handle the request.

    -   Chain the receiving objects and pass the request along the chain until
        an object handles it.

-   **Command（命令）**

    -   将一个请求封装为一个对象，从而使你可用不同的请求对客户进行参数化；对请求排队或记录请求日志，以及支持可撤销的操作。

    -   Encapsulate a request as an object, thereby letting you parameterize
        clients with different requests, queue or log requests, and support
        undoable operations.

-   **Interpreter（解释器）**

    -   给定一个语言，定义它的文法的一种表示，并定义一个解释器，这个解释器使用该表示来解释语言中的句子。

    -   Given a language, define a represention for its grammar along with an
        interpreter that uses the representation to interpret sentences in the
        language.

-   **Iterator（迭代器）**

    -   提供一种方法顺序访问一个聚合对象中各个元素，而又不需暴露该对象的内部表示。

    -   Provide a way to access the elements of an aggregate object sequentially
        without exposing its underlying representation.

-   **Observer（观察者）**

    -   定义对象间的一种一对多的依赖关系，当一个对象的状态发生改变时，所有依赖于它的对象都得到通知并被自动更新。

    -   Define a one-to-many dependency between objects so that when one object
        changes state, all its dependents are notified and updated
        automatically.

-   **Mediator（中介者）**

    -   用一个中介对象来封装一系列的对象交互。

    -   中介者使各对象不需要显式地相互引用，从而使其耦合松散，而且可以独立地改变它们之间的交互。

    -   Define an object that encapsulates how a set of objects interact.

    -   Mediator promotes loose coupling by keeping objects from referring to
        each other explicitly, and it lets you vary their interaction
        independently.

-   **Memento（备忘录）**

    -   在不破坏封装性的前提下，捕获一个对象的内部状态，并在该对象之外保存这个状态。这样以后就可将该对象恢复到原先保存的状态。

    -   Without violating encapsulation, capture and externalize an object's
        internal state so that the object can be restored to this state later.

-   **State（状态）**

    -   允许一个对象在其内部状态改变时改变它的行为。对象看起来似乎修改了它的类。

    -   Allow an object to alter its behavior when its internal state changes.
        The object will appear to change its class.

-   **Strategy（策略）**

    -   定义一系列的算法，把它们一个个封装起来，并且使它们可以相互替换。使得算法可独立于使用它的客户而变化。

    -   Define a family of algorithms, encapsulate each one, and make them
        interchangeable.

    -   Strategy lets the algorithm vary independently from clients that use it.

-   **Template Method（模板方法）**

    -   定义一个操作中的算法的骨架，而将一些步骤延迟到子类中。

    -   Template Method
        使得子类可以不改变一个算法的结构即可重定义该算法的某些特定步骤。

    -   Define the skeleton of an algorithm in an operation, deferring some
        steps to subclasses.

    -   Template Method lets subclasses redefine certain steps of an algorithm
        without changing the algorithm's structure.

-   **Visitor（访问者）**

    -   表示一个作用于某对象结构中的各元素的操作。

    -   Visitor 使你可以在不改变各元素的类的前提下定义作用于这些元素的新操作。

    -   Represent an operation to be performed on the elements of an object
        structure.

    -   Visitor lets you define a new operation without changing the classes of
        the elements on which it operates.

**封装变化**

当一个程序的某些方面的特征经常发生改变时，行为型模式就定义一个封装这个方面的对象。

这样当该程序的其他部分依赖于这个方面时，它们都可以与此对象协作。

这些模式通常定义一个抽象类来描述这些封装变化的对象，并且通常该模式依赖这个对象来命名。

-   一个 Strategy 对象封装一个 Algorithm。

-   一个 State 对象封装一个与状态相关的行为。

-   一个 Mediator 对象封装对象间的协议。

-   一个 Iterator 对象封装访问和遍历一个聚合对象中的各个构件的方法。

大多数模式有两种对象：封装该方面特征的新对象，和使用这些新的对象的已有对象。

**对象作为参数**

一些模式引入总是被用作参数的对象。例如一个 Visitor 对象是一个多态的 Accept
操作的参数。

一些模式定义一些可作为令牌到处传递的对象。例如 Command 代表一个请求，Memento
代表一个对象在某个时刻的内部状态。
