## 1 异常处理语句


try 语句使您能够测试代码块中的错误。

catch 语句允许您处理错误。

throw 语句允许您创建自定义错误。

finally 使您能够执行代码，在 try 和 catch 之后，无论结果如何。

```
try {
     供测试的代码块
}
 catch(err) {
     处理错误的代码块
} 
finally {
     无论 try / catch 结果如何都执行的代码块
}
```