MFC 是一个框架。

它封装了主要的win32 接口。win32 接口以函数为主。

MFC Microsoft Foundation Class
Libraray，是一个面向对象的以类为主的框架。将库中各种类结合起来，构成了一个应用程序框架。是一种对windows
SDK的封装。MFC框架定义了应用程序的轮廓。他是C++的类库。

MFC中的封装：

用一个C++ 对象封装Windows 对象。class CWnd是一个C++ window object，它把Windows
window(HWND)和Windows window有关的API函数封装在C++ window
object的成员函数内，后者的成员变量m_hWnd就是前者的窗口句柄。

用C++的方式，重新定义相关的类。

MFC中继承：

MFC抽象出众多类的共同特性，设计出一些基类作为实现其他类的基础。这些类中，最重要的类是CObject和CCmdTarget。CObject是MFC的根类，绝大多数MFC类是其派生的，
包括CCmdTarget。CObject
实现了一些重要的特性，包括动态类信息、动态创建、对象序列化、对程序调试的支持，等等。所有从CObject派生的类都将具备或者可以具备CObject所拥有的特性。CCmdTarget通过封装一些属性和方法，提供了消息处理的架构。MFC中，任何可以处理消息的类都从CCmdTarget派生。

针对每种不同的对象，MFC都设计了一组类对这些对象进行封装，每一组类都有一个基类，从基类派生出众多更具体的类。这些对象包括以下种类：窗口对象，基类是CWnd；应用程序对象，基类是CwinThread；文档对象，基类是Cdocument，等等。
