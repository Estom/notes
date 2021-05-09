# Torch Script 简介

## 1 为什么

* TorchScript是PyTorch模型（的子类nn.Module）的中间表示，可以在高性能环境（例如C ++）中运行。

* TorchScript是一种从PyTorch代码创建可序列化和可优化模型的方法。任何TorchScript程序都可以从Python进程中保存，并在没有Python依赖项的进程中加载​​。

* 我们提供了将模型从纯Python程序逐步过渡到可以 **独立于Python运行的TorchScript程序** 的工具，例如在独立的C ++程序中。这样就可以使用Python中熟悉的工具在PyTorch中训练模型，然后通过TorchScript将模型导出到生产环境中。

## 2 怎样做-trace

### 实现一个模型

1. 构造函数，为调用准备模块
2. 一组Parameters和Modules。这些由构造函数初始化，并且可以在调用期间由模块使用。
3. 一个forward功能。这是调用模块时运行的代码。

```py
class MyCell(torch.nn.Module):
    def __init__(self):
        super(MyCell, self).__init__()
        self.linear = torch.nn.Linear(4, 4)

    def forward(self, x, h):
        new_h = torch.tanh(self.linear(x) + h)
        return new_h, new_h


x = torch.rand(3, 4)
h = torch.rand(3, 4)

my_cell = MyCell()
print(my_cell)
print(my_cell(x, h))
```


### 对模型序列化

```py
traced_cell = torch.jit.trace(my_cell, (x, h))
print(traced_cell)
traced_cell(x, h)

print(traced_cell.graph)
print(traced_cell.code)
```

1. TorchScript代码可以在其自己的解释器中调用，该解释器基本上是受限制的Python解释器。该解释器不获取全局解释器锁定，因此可以在同一实例上同时处理许多请求。
2. 这种格式允许我们将整个模型保存到磁盘上，并将其加载到另一个环境中，例如在以Python以外的语言编写的服务器中
3. TorchScript为我们提供了一种表示形式，其中我们可以对代码进行编译器优化以提供更有效的执行
4. TorchScript允许我们与许多后端/设备运行时进行接口，这些运行时比单个操作员需要更广泛的程序视图。


## 3 怎样做-script

1. 将模型转换为trace格式
```
class MyDecisionGate(torch.nn.Module):
    def forward(self, x):
        if x.sum() > 0:
            return x
        else:
            return -x

class MyCell(torch.nn.Module):
    def __init__(self, dg):
        super(MyCell, self).__init__()
        self.dg = dg
        self.linear = torch.nn.Linear(4, 4)

    def forward(self, x, h):
        new_h = torch.tanh(self.dg(self.linear(x)) + h)
        return new_h, new_h

my_cell = MyCell(MyDecisionGate())
traced_cell = torch.jit.trace(my_cell, (x, h))

print(traced_cell.dg.code)
print(traced_cell.code)
```

2. 提供了一个 脚本编译器，它可以直接分析您的Python源代码以将其转换为TorchScript。让我们MyDecisionGate 使用脚本编译器进行转换：

```
scripted_gate = torch.jit.script(MyDecisionGate())

my_cell = MyCell(scripted_gate)
scripted_cell = torch.jit.script(my_cell)

print(scripted_gate.code)
print(scripted_cell.code)
```

## 4 保存和加载模型

```
traced.save('wrapped_rnn.pt')

loaded = torch.jit.load('wrapped_rnn.pt')

print(loaded)
print(loaded.code)
```