# torch.optim


## 1 使用优化器


### 构造优化器

要构造一个，Optimizer您必须为其提供一个包含参数的可迭代项（所有参数都应为Variables）以进行优化。然后，您可以指定优化器特定的选项，例如学习率，权重衰减等。

```py
optimizer = optim.SGD(model.parameters(), lr=0.01, momentum=0.9)
optimizer = optim.Adam([var1, var2], lr=0.0001)
```

### 使用优化器
所有优化器都实现一种step()更新参数的方法。它可以以两种方式使用：optimizer.step()

这是大多数优化程序支持的简化版本。一旦使用例如来计算梯度，就可以调用该函数 backward()。
```py
for input, target in dataset:
    optimizer.zero_grad()
    output = model(input)
    loss = loss_fn(output, target)
    loss.backward()
    optimizer.step()
```

## 2 优化器方法
torch.optim.Optimizer（参数，默认值）是所有优化器的基类，主要有一下方法。


add_param_group（param_group ）
将参数组添加到Optimizers param_groups。

load_state_dict（state_dict ）
加载优化器状态。

state_dict（）
以形式返回优化器的状态dict。


step（关闭）
执行单个优化步骤（参数更新）。

zero_grad（set_to_none = False ）
将所有已优化torch.Tensors的梯度设置为零。

## 3 常见优化器


torch.optim.Adadelta（参数，lr = 1.0，rho = 0.9，eps = 1e-06，weight_decay = 0 ）
实现Adadelta算法。它已在ADADELTA中提出：一种自适应学习率方法。

torch.optim.Adagrad（参数，lr = 0.01，lr_decay = 0，weight_decay = 0，initial_accumulator_value = 0，eps = 1e-10 
实现Adagrad算法。在在线学习和随机优化的自适应次梯度方法中提出了该方法。

torch.optim.Adam（PARAMS，LR = 0.001，贝塔=（0.9，0.999） ，EPS = 1E-08，weight_decay = 0，amsgrad =假）
实现亚当算法。它已在《亚当：一种随机优化方法》中提出。L2惩罚的实现遵循“去耦权重衰减正则化”中提出的更改 。

torch.optim.AdamW（PARAMS，LR = 0.001，贝塔=（0.9，0.999） ，EPS = 1E-08，weight_decay = 0.01，amsgrad =假）[来源]
实现AdamW算法。最初的Adam算法是在Adam：一种随机优化方法中提出的。AdamW变体在去耦权重衰减正则化中提出。

torch.optim.SparseAdam（PARAMS，LR = 0.001，贝塔=（0.9，0.999） ，EPS = 1E-08 ）
实现适合稀疏张量的懒惰版本的Adam算法。在此变体中，仅显示出现在渐变中的力矩，并且仅将渐变的那些部分应用于参数。


torch.optim.ASGD（参数，lr = 0.01，lambd = 0.0001，alpha = 0.75，t0 = 1000000.0，weight_decay = 0 ）
实施平均随机梯度下降。已经提出了通过平均来加速随机逼近。

torch.optim.RMSprop（参数，lr = 0.01，alpha = 0.99，eps = 1e-08，weight_decay = 0，动量= 0，居中= False ）[来源]
实现RMSprop算法。G. Hinton在他的课程中提出的建议 。

torch.optim.SGD（参数，lr = <必需参数>，动量= 0，阻尼= 0，weight_decay = 0，nesterov = False ）[来源]
实现随机梯度下降（可选带动量）。Nesterov动量基于“深度学习中初始化和动量的重要性”中的公式 。