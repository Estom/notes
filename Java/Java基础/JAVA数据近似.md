下面来介绍将小数值舍入为整数的几个方法：Math.ceil()、Math.floor()和Math.round()。
这三个方法分别遵循下列舍入规则：

Math.ceil()执行向上舍入，即它总是将数值向上舍入为最接近的整数；

Math.floor()执行向下舍入，即它总是将数值向下舍入为最接近的整数；

Math.round()执行标准舍入，即它总是将数值四舍五入为最接近的整数(这也是我们在数学课上学到的舍入规则)。

下面来看几个例子：

Math.ceil(25.9) //26

Math.ceil(25.5) //26

Math.ceil(25.1) //26

Math.ceil(25.0) //25

Math.round(25.9) //26

Math.round(25.5) //26

Math.round(25.1) //25

Math.floor(25.9) //25

Math.floor(25.5) //25

Math.floor(25.1) //25
