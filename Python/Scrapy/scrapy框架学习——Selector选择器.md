爬取网站最常见的任务是从HTML源代码中提取数据。常用的库有BeautifulSoup。lxml库，Xpath。

Selector 中Xpath和CSS的使用

标签是节点 ，可以有层级

属性使用@来调用

内容要用text()来调用

条件要在[ ]写明白，也可以是contains[]

//表示获得所有的某一个标签

./表示下一级的方法

可以使用正则表达式最原始的过滤。

response**.**xpath('//a[contains(@href,
"image")]/text()')**.**re(r'Name:\\s\*(.\*)')
