XPath使用路径表达式来选取XML文档中的节点或者节点集合。节点是通过path或者步来选取的。

1\. 通过已经有的表达式选取节点、元素、属性和内容

nodename 选取此节点的所有子节点

/ 从根节点开始选取

// 从匹配选择的当前节点选择文档中的节点

. 选取当前节点

.. 选取当前节点的父节点

@ 选取属性

2\. 带有位于的路径表达式，使用[ ]来表示当前节点被选取的一些条件

/bookstor/book[price\>35]/title

3\. 通配符来选取未知的元素（一般也用python的re表达式）

\* 匹配任何元素的节点

@\* 匹配带有任何属性节点（没有属性的节点不行）

node() 匹配任何类型的接待你。

对于CSS来说，选择器与HTML和CSS相关。

.class intro 查找类别下的元素

\#id \#firstname id=\*的所有用户

element p 选择所有的元素

element，element 并列选择

element element 父子选择

element\>element 父元素选择

element element
