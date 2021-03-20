# 机器学习超级复习笔记

> 原文：[Super Machine Learning Revision Notes](https://createmomo.github.io/2018/01/23/Super-Machine-Learning-Revision-Notes/#negative_sampling)
> 
> 译者：[飞龙](https://github.com/wizardforcel/)
> 
> 协议：[CC BY-NC-SA 4.0](http://creativecommons.org/licenses/by-nc-sa/4.0/)

### [最后更新：06/01/2019]

本文旨在概述：

*   **机器学习中的基本概念**（例如，梯度下降，反向传播等）
*   **不同的算法和各种流行的模型**
*   一些**实用技巧**和**示例**是从我自己的实践和一些在线课程（如[DeepLearningAI](https://www.deeplearning.ai/) ）中学习的。

**如果您是正在学习机器学习的学生**，希望本文可以帮助您缩短复习时间并给您带来有益的启发。 **如果您不是学生**，希望本文在您不记得某些模型或算法时会有所帮助。

此外，您也可以将其视为“**快速检查指南**”。 请随意使用`Ctrl + F`搜索您感兴趣的任何关键字。

任何意见和建议都非常欢迎！

* * *

### 激活函数

| 名称 | 函数 | 导数 |
| --- | --- | --- |
| Sigmoid | ![](img/tex-3feceb42b09ab51802cbddbad8fe6292.gif) | ![](img/tex-753f418e006c8d5e9738402ec1ad38fd.gif) |
| tanh | ![](img/tex-3e664a4e7ed9f7a596ba97eae7bcc2bd.gif) | ![](img/tex-ba586fbf9c1e470f8cbae6b6c3c89bc0.gif) |
|  |  | 如果为![](img/tex-5b1d73668c7d06ef39ed37636ee14898.gif)，则为 0 |
| ReLU | ![](img/tex-2e8b663420c79458ff788f7c8f198aa2.gif) | 如果 ![](img/tex-91762688ac092fdcbf5d131bf9043840.gif) 则为 1 |
|  |  | 如果 ![](img/tex-8fcd01a17ad602c542f98b916cba57f4.gif) 则未定义 |
|  |  | 如果 ![](img/tex-5b1d73668c7d06ef39ed37636ee14898.gif) 则 0.01 |
| LReLU | ![](img/tex-ea7bd380fdebb1ec3224c518a9bfa729.gif) | 如果 ![](img/tex-91762688ac092fdcbf5d131bf9043840.gif) 则为 1 |
|  |  | 如果 ![](img/tex-8fcd01a17ad602c542f98b916cba57f4.gif) 则未定义 |

### 梯度下降

梯度下降是找到目标函数（例如损失函数）的局部最小值的一种迭代方法。


```
Repeat{    W := W - learning_rate * dJ(W)/dW}
```



符号![](img/tex-90fbf10a26ef97a45938ba477c826655.gif)表示更新操作。 显然，我们正在更新参数![](img/tex-61e9c06ea9a85a5088a499df6458d276.gif)的值。

通常，我们用![](img/tex-7b7f9dbfea05c83784f8b85149852f08.gif)表示学习率。 训练神经网络时，它是超参数之一（我们将在另一部分介绍更多的超参数）。 ![](img/tex-4defef41b60185408425fa0ea63eac78.gif)是我们模型的损失函数。 ![](img/tex-dbdcdf39866d05fdbc9f8dec59fccf91.gif)是参数![](img/tex-61e9c06ea9a85a5088a499df6458d276.gif)的梯度。 如果![](img/tex-61e9c06ea9a85a5088a499df6458d276.gif)是参数（权重）的矩阵，则![](img/tex-dbdcdf39866d05fdbc9f8dec59fccf91.gif)将是每个参数（即![](img/tex-322b227441558f0ed48aba836d0caf6f.gif)）的梯度矩阵。

**问题**： **为什么在最小化损失函数时减去梯度而不加梯度？**

答案：

例如，我们的损失函数为![](img/tex-24e8d8f6411751ffb862e218425f6388.gif)，可能看起来像：

![gradient descent](img/421af2fd66e7963c232cfa3719d7024e.jpg)

当![](img/tex-c5a65f66777c1d50a48d7622ed480d11.gif)时，梯度为![](img/tex-32213aabf4676ffc1ee9dae494989217.gif)。 显然，如果我们要找到![](img/tex-4defef41b60185408425fa0ea63eac78.gif)的最小值，则梯度的相反方向（例如![](img/tex-258af587813565bc42b2be1dd0683237.gif)）是找到局部最低点（即![](img/tex-94137d3842b8e8d6027ef9d99c59c6f3.gif)）的正确方向。

但是有时，梯度下降法可能会遇到局部最优问题。



#### 计算图

该计算图示例是从[DeepLearningAI](https://www.deeplearning.ai/) 的第一门课程中学到的。

假设我们有 3 个可学习的参数![](img/tex-0cc175b9c0f1b6a831c399e269772661.gif)，![](img/tex-92eb5ffee6ae2fec3ad71c777531578f.gif)和![](img/tex-4a8a08f09d37b73795649038408b5f33.gif)。 成本函数为![](img/tex-2e42f7774d66008a22a41cae45d139f5.gif)。 接下来，我们需要计算参数的梯度：![](img/tex-580c0362e5e953e0724adbd8d5423604.gif)，![](img/tex-f9edac4cbb3fcd39611314703005ec52.gif)和![](img/tex-6a2d814ef8a3e987884a5f0256cf7d0b.gif)。 我们还定义：![](img/tex-9bd7a11933cc798a7dd2b4c474f2574e.gif)，![](img/tex-f65940b5a322251511f9570520c8796e.gif)和![](img/tex-fdcf1c4788da9258bb0f04abfeec7a02.gif)。 该计算可以转换成下面的计算图：

![forward computation](img/d274b4579721330841220f50c5b0bda7.jpg)



#### 反向传播

从上图可以明显看出，参数的梯度为：![](img/tex-23327b5cda66de85cecf97b7b44ed599.gif)，![](img/tex-3e61620a7062469797fdf9a5c9c87a9d.gif)和![](img/tex-ee64ffbfc03289770deb1ef8d90cf59a.gif)。

计算每个节点的梯度很容易，如下所示。 （提示：实际上，如果您正在实现自己的算法，则可以在正向过程中计算梯度以节省计算资源和训练时间。因此，在进行反向传播时，无需再次计算每个节点的梯度 。）

![gradient of each node](img/3907d35c854cfdeaa7c949d2d02cbd30.jpg)

现在，我们可以通过简单地组合节点梯度来计算每个参数的梯度：

![backpropagation](img/0faa55168ecfc132ba12ebf7ef304d52.jpg)

![](img/tex-aa20fcf51f359a7aa6c1ee4dfdabede2.gif)

![](img/tex-ac0ed3b7e036c0ab1bbbaed06a88514b.gif)

![](img/tex-3a5b8c68810f07dbc554c1b08da42a53.gif)

#### L2 正则化的梯度（权重衰减）

通过添加![](img/tex-40609564d6156f07f0c27d0903fadf83.gif)可以稍微改变梯度。


```
Repeat{    W := W - (lambda/m) * W - learning_rate * dJ(W)/dW}
```




#### 梯度消失/爆炸

如果我们有一个非常深的神经网络并且未正确初始化权重，则可能会遇到梯度消失或爆炸的问题。 （有关参数初始化的更多详细信息：[参数初始化](https://createmomo.github.io/2018/01/23/Super-Machine-Learning-Revision-Notes/#parameters_initialization)）

为了解释什么是消失或爆炸梯度问题，将以一个简单的深度神经网络架构为例。 （同样，很棒的例子来自在线课程[DeepLearningAI](https://www.deeplearning.ai/) ）

神经网络具有![](img/tex-d20caec3b48a1eef164cb4ca81ba2587.gif)层。 为简单起见，每层的参数![](img/tex-6068b89c24e866ceabe5e9ab634c0a6e.gif)为 0，所有激活函数均为![](img/tex-98d0cc4a1aab98e04dc00d0b798423c9.gif)。 此外，每个参数![](img/tex-9f9ef466310393ddad9e38c05d006871.gif)具有相同的值。

根据上面的简单模型，最终输出将是：
![](img/tex-7bc18b5033db6027612d164f5c11c268.gif)

因为权重值![](img/tex-92d0a30bdf3947be49585d62e4a3884a.gif)，我们将在某些易爆元素中获得![](img/tex-fa23ea8bb9ed7baa2f90b1a3920ce92f.gif)。 同样，如果权重值小于 1.0（例如 0.5），则某处会有一些消失的梯度（例如![](img/tex-eca2fd6ad14521cd370e5cd258344cf0.gif)）。

**这些消失/爆炸的梯度会使训练变得非常困难。 因此，仔细初始化深度神经网络的权重很重要。**



#### 小批量梯度下降

如果我们拥有庞大的训练数据集，那么在单个周期训练模型将花费很长时间。 对于我们而言，跟踪训练过程将非常困难。 在小批量梯度下降中，基于当前批量中的训练示例计算成本和梯度。

![](img/tex-02129bb861061d1a052c592e2dc6b383.gif)代表整个训练集，分为以下几批。 ![](img/tex-6f8f57715090da2632453988d9a1501b.gif)是训练示例的数量。

![mini-batches of training data X](img/dd79564b598f15cfc78a84bc0452d195.jpg)

小批量的过程如下：


```
For t= (1, ... , #Batches):  
    Do forward propagation on the t-th batch examples;  
    Compute the cost on the t-th batch examples;  
    Do backward propagation on the t-th batch examples to compute gradients and update parameters.
```

在训练过程中，当我们不应用小批量梯度下降时，与使用小批量训练模型相比，成本趋势更加平滑。

![cost trend of batch and mini-batch gradient Descent](img/2fcf4479786e9026682de8c8ac66450e.jpg)

#### 随机梯度下降

当批量大小为 1 时，称为随机梯度下降。

#### 选择小批量

批量大小：

1）如果大小为![](img/tex-69691c7bdcc3ce6d5d8a1361f22d04ac.gif)，即整个训练集中的示例数，则梯度下降就恰好是“批量梯度下降”。

2）如果大小为 1，则称为随机梯度下降。

实际上，大小是在 1 到 M 之间选择的。当![](img/tex-88914f3ddc98afcb84444299d86fef97.gif)时，该数据集应该是较小的数据集，使用“批量梯度下降”是可以接受的。 当![](img/tex-cabf540e7cc75f01020991e2bb935098.gif)时，可能小批量梯度下降是训练模型的更好方法。 通常，小批量大小可以是 64、128、256 等。

![training process with various batch sizes](img/368bc2ea201e80e849b7c9909c905f03.jpg)



#### 具有动量的梯度下降（总是比 SGD 更快）

在每个小批量迭代![](img/tex-e358efa489f58062f10dd7316b65649e.gif)上：

1）在当前小批量上计算![](img/tex-8ceb6623210b5b482cefa74271cde36f.gif)和![](img/tex-d77d5e503ad1439f585ac494268b351b.gif)

2）![](img/tex-f22fe2a7d88e51438a58d0c08491d7fd.gif)

3）![](img/tex-4651155988e1fdd15e649648c9c36ee7.gif)

4）![](img/tex-c810382a8ac85fa2dd6ebaf64ac52d36.gif)

5）![](img/tex-7da4fbb8886cfb4cb132500557026467.gif)

动量的超参数是![](img/tex-7b7f9dbfea05c83784f8b85149852f08.gif)（学习率）和![](img/tex-b0603860fcffe94e5b8eec59ed813421.gif)。 动量方面，![](img/tex-33365520fc7161b5a0e8924b3cf841f3.gif)是先前梯度的历史信息。 如果设置![](img/tex-0775a56d238029e41375f6c276990ace.gif)，则意味着我们要考虑最近 10 次迭代的梯度来更新参数。

原始的![](img/tex-b0603860fcffe94e5b8eec59ed813421.gif)来自[指数加权平均值](https://www.youtube.com/watch?v=NxTFlzBjS-4)的参数。例如 ![](img/tex-0775a56d238029e41375f6c276990ace.gif)表示我们要取最后 10 个值作为平均值。 ![](img/tex-acbe4813a070a93b4820980841624861.gif)表示考虑最后 1000 个值等。

#### RMSprop 的梯度下降

在每个小批量迭代![](img/tex-e358efa489f58062f10dd7316b65649e.gif)上：

1）在当前小批量上计算![](img/tex-8ceb6623210b5b482cefa74271cde36f.gif)和![](img/tex-d77d5e503ad1439f585ac494268b351b.gif) 

2）![](img/tex-4f190dafeac083bc319a339e986eae9b.gif)

3）![](img/tex-db138aef82ab076a3615caa1eed12ec2.gif)

4）![](img/tex-cfb0685dd9d2c7750b6f7e470e980d68.gif)

5）![](img/tex-2acdb4a69c8067a4378a0566ed6bc792.gif)

#### Adam（将动量和 RMSprop 放在一起）

![](img/tex-17b069f79cf8ce5adc13f32d7db99b32.gif)，![](img/tex-8093eae53dc1e829c7d753798a62f385.gif)，![](img/tex-9b1259abace211373243b44aaf4a36c3.gif)，![](img/tex-1a8874a987eda34399cf849b04d65f0b.gif)

在每个小批量迭代中![](img/tex-e358efa489f58062f10dd7316b65649e.gif)：

1）在当前小批量上计算![](img/tex-8ceb6623210b5b482cefa74271cde36f.gif)和![](img/tex-d77d5e503ad1439f585ac494268b351b.gif)。

2）![](img/tex-922af9cc345af5e54f0cd595b053bcce.gif)

3）![](img/tex-78aec4ade9bff570a511d37a16925e78.gif)

4）![](img/tex-610e7529493c0c7a8b25247495b31a65.gif)

5）![](img/tex-a3172c5736057baf1102cb4ba1fd0ec4.gif)

6）![](img/tex-e8cc103eadb7f153d0fb22c628b92cd3.gif)

7）![](img/tex-42c4f85396cc3e77df0477745c546901.gif) 

![](img/tex-42c4f85396cc3e77df0477745c546901.gif) 

![](img/tex-42c4f85396cc3e77df0477745c546901.gif) 

![](img/tex-42c4f85396cc3e77df0477745c546901.gif) 

![](img/tex-42c4f85396cc3e77df0477745c546901.gif) 

![](img/tex-42c4f85396cc3e77df0477745c546901.gif) 

![](img/tex-42c4f85396cc3e77df0477745c546901.gif) 

![](img/tex-f02676ceb92c11ff7dc9df6ad0eda1ad.gif)

![](img/tex-9ad8d6a5b8ec30f7aa8e665c105b708d.gif)

“校正”是指数加权平均值中的[“偏差校正”](https://www.youtube.com/watch?v=lWzo8CajF5s) 的概念。 该校正可以使平均值的计算更加准确。 ![](img/tex-e358efa489f58062f10dd7316b65649e.gif)是![](img/tex-b0603860fcffe94e5b8eec59ed813421.gif)的权重。

通常，默认的超参数值为：![](img/tex-f339282377572d7b390a8a36482aaf7d.gif)，![](img/tex-0f3e49f21ffda096a1fc333c33f356cb.gif)和![](img/tex-9aa2da2cf267aeb936cc0dbf5c9c3abc.gif)。

学习率![](img/tex-7b7f9dbfea05c83784f8b85149852f08.gif)需要调整。 或者，应用学习率衰减方法也可以很好地工作。



#### 学习速率衰减方法

如果在训练期间固定学习率，则损失/成本可能会波动，如下图所示。 寻找一种使学习速率具有适应性的方法可能是一个好主意。

![training with fix learning rate](img/a4c34e9308fdf06fd964ad16b1d51864.jpg)

##### 基于周期数的衰减

![train phrase](img/1c4945b5053561037eda73cd94e5a391.jpg)

根据周期数降低学习率是一种直接的方法。 以下是速率衰减公式。

例如，初始![](img/tex-87526aa5fefff3f11caff9cde7ea0383.gif)和衰减率是 1.0。 每个周期的学习率是：

| 周期 | ![](img/tex-7b7f9dbfea05c83784f8b85149852f08.gif) |
| --- | --- |
| 1 | 0.1 |
| 2 | 0.67 |
| 3 | 0.5 |
| 4 | 0.4 |
| 5 | … |

当然，还有其他一些学习率衰减方法。

| 其他方法 | 公式 |
| --- | --- |
| 指数衰减 | ![](img/tex-88fa6de3c3ceb7a210dc5b8d0583ae5c.gif) |
| 周期相关 | ![](img/tex-b64a89b6fd92e12aeb1bfd915f7fbf8c.gif) |
| 小批量相关 | ![](img/tex-51eb49ddfd93ea9a038bdd3b4a11a854.gif) |
| 离散阶梯 | ![](img/e0734d304dea50eb2bbc4bfeec2f8872.jpg) |
| 手动衰减 | 逐日手动或逐小时降低学习率等。 |



#### 批量规范化

##### 训练时的批量规范化

使用批量规范化可以加快训练速度。

步骤如下。

![Batch Normalization](img/c210239ab0a043ec260f89f9c246485b.jpg)

每层![](img/tex-2db95e8e1a9267b7a1188556b2013b33.gif)中的批量规范化的详细信息是：

![](img/tex-4121a98dea501099148e235e7c1b3267.gif)

![](img/tex-afe1939832cf82088c2a1d27f81f875d.gif)

![](img/tex-443ec804457703e73c1ec99f6cdf211e.gif)

![](img/tex-7b7f9dbfea05c83784f8b85149852f08.gif)和![](img/tex-b0603860fcffe94e5b8eec59ed813421.gif)是此处可学习的参数。

##### 测试时的批量规范化

在测试时，我们没有实例来计算![](img/tex-c9faf6ead2cd2c2187bd943488de1d0a.gif)
和![](img/tex-77a3b715842b45e440a5bee15357ad29.gif)，因为每次可能只有一个测试实例。

在这种情况下，最好使用跨小批量的指数加权平均值来估计![](img/tex-c9faf6ead2cd2c2187bd943488de1d0a.gif)和![](img/tex-63bcabf86a9a991864777c631c5b7617.gif)的合理值。



### 参数

#### 可学习的参数和超参数

| 可学习的参数 |
| --- |
| ![](img/tex-7dadb21bc19f02714a44cac513892475.gif) |

| 超参数 |
| --- |
| 学习率![](img/tex-7b7f9dbfea05c83784f8b85149852f08.gif) |
| 迭代次数 |
| 隐藏层数![](img/tex-d20caec3b48a1eef164cb4ca81ba2587.gif) |
| 每一层的隐藏单元的数量 |
| 选择激活函数 |
| 动量参数 |
| 小批量 |
| 正则化参数 |



#### 参数初始化

（**注意**：实际上，机器学习框架（例如 tensorflow，chainer 等）已经提供了强大的参数初始化功能。）

##### 小初始值

例如，当我们初始化参数![](img/tex-61e9c06ea9a85a5088a499df6458d276.gif)时，我们设置一个小的值（即 0.01）以确保初始参数很小：


```
W = numpy.random.randn(shape) * 0.01
```

这样做的原因是，如果您使用的是 Sigmoid 且初始参数较大，则梯度将非常小。

##### 隐藏单元更多，权重更小

同样，我们将使用伪代码来显示各种初始化方法的工作方式。 我们的想法是，如果隐藏单元的数量较大，我们更愿意为参数分配较小的值，以防止训练阶段的消失或爆炸。下图可能会为您提供一些了解该想法的见解。

![z](img/9c34a023a4b7ed91a88ca4b4a5e3d384.jpg)

基于上述思想，我们可以使用与隐藏单元数有关的项对权重进行设置。


```
W = numpy.random.randn(shape) * numpy.sqrt(1/n[l-1])
```


相乘项的公式为![](img/tex-6659bd1ae5eaa02739516f21d25104ba.gif)。 ![](img/tex-1e0171980e8553926996cf3391176ef1.gif)是上一层中隐藏单元的数量。

如果您正在使用 Relu 激活函数，则使用项![](img/tex-b0ae271adf4da4f84e6ec254dcc535bf.gif)可能会更好。

##### Xavier 初始化

如果您的激活函数是![](img/tex-040f4e6aad36a049d12ca18e6df07c24.gif)，那么 Xavier 初始化（![](img/tex-6659bd1ae5eaa02739516f21d25104ba.gif)或![](img/tex-6fbfaa59f11010b5fc0c12b709988389.gif)）将是一个不错的选择。



#### 超参数调整

调整超参数时，有必要尝试各种可能的值。 如果计算资源足够，最简单的方法是训练具有各种参数值的并行模型。 但是，最有可能的资源非常稀少。 在这种情况下，我们只能照顾一个模型，并在不同周期尝试不同的值。

![Babysitting one model vs. Traning models parallel](img/c53cc1b45b6db7dcb891069313fc9572.jpg)

除了上述方面，如何明智地选择超参数值也很重要。

如您所知，神经网络架构中有各种超参数：学习率![](img/tex-7b7f9dbfea05c83784f8b85149852f08.gif)，动量和 RMSprop 参数（![](img/tex-b4ceec2c4656f5c1e7fc76c59c4f80f3.gif)，![](img/tex-d9f51e864a6151f57e727294da7ac28c.gif)和![](img/tex-92e4da341fe8f4cd46192f21b6ff3aa7.gif)），层数，每层的单元数，学习速率衰减参数和小批量大小。

Ng 推荐以下超参数优先级：

| 优先级 | 超参数 |
| --- | --- |
| 1 | 学习率![](img/tex-7b7f9dbfea05c83784f8b85149852f08.gif) |
| 2 | ![](img/tex-b4ceec2c4656f5c1e7fc76c59c4f80f3.gif)，![](img/tex-d9f51e864a6151f57e727294da7ac28c.gif)和![](img/tex-92e4da341fe8f4cd46192f21b6ff3aa7.gif)（动量和 RMSprop 的参数） |
| 2 | 隐藏单元数 |
| 2 | 批量大小 |
| 3 | 层数 |
| 3 | 学习率衰减数 |

（通常，动量和 RMSprop 的默认值为：![](img/tex-f339282377572d7b390a8a36482aaf7d.gif)，![](img/tex-0f3e49f21ffda096a1fc333c33f356cb.gif)和![](img/tex-9aa2da2cf267aeb936cc0dbf5c9c3abc.gif)）

##### 隐藏单元和层的均匀样本

例如，如果层数的范围是 2-6，我们可以统一尝试使用 2、3、4、5、6 来训练模型。 同样，对于 50-100 的隐藏单元，在这种比例下选择值是一个很好的策略。

例：

![hidden units and layers](img/47142ccbd17940e0ed568fab835c72c8.jpg)

##### 对数刻度上的样本

您可能已经意识到，对于所有参数而言，均匀采样通常不是一个好主意。

例如，让我们说学习率![](img/tex-7b7f9dbfea05c83784f8b85149852f08.gif)的合适范围是![](img/tex-49f78527e906ad99114f016bd1587a5b.gif)。 显然，均匀选择值是不明智的。 更好的方法是在对数刻度![](img/tex-313f7876b6955ecaa8867b124705f8b2.gif)（![](img/tex-ac382d58b1125bb9aeaf1a83ebf5e9c6.gif)，![](img/tex-8f4e22c93710008b7ea050514a32ecdd.gif)，![](img/tex-04817efd11c15364a6ec239780038862.gif)，![](img/tex-cb5ae17636e975f9bf71ddf5bc542075.gif)和![](img/tex-c4ca4238a0b923820dcc509a6f75849b.gif)）上进行采样。

至于参数![](img/tex-b4ceec2c4656f5c1e7fc76c59c4f80f3.gif)和![](img/tex-d9f51e864a6151f57e727294da7ac28c.gif)，我们可以使用类似的策略。

例如
![](img/tex-7fda39311e7db58097594183923ab6ce.gif)
因此，![](img/tex-df7986ad9d262fe6e55595e84d074290.gif)
![](img/tex-7a018afecfe13c76d04bebe7a2a18b52.gif)

下表可能有助于您更好地了解该策略。

|  |  |  |  |
| --- | --- | --- | --- |
| ![](img/tex-b0603860fcffe94e5b8eec59ed813421.gif) | 0.9 | 0.99 | 0.999 |
| ![](img/tex-8a9829cc715ebd890d416d3e158daefe.gif) | 0.1 | 0.01 | 0.001 |
| ![](img/tex-4b43b0aee35624cd95b910189b3dc231.gif) | -1 | -2 | -3 |

例：

![learning rate alpha and beta](img/9e8dca38ce7fe93fa7e896dca869904d.jpg)



### 正则化

正则化是防止机器学习出现过拟合问题的一种方法。 附加的正则项将添加到损失函数中。

#### L2 正则化（权重衰减）

![](img/tex-532e4649bb50b5041b428ca5b4db6ccd.gif)

在新的损失函数中，![](img/tex-ede431e991e7d70154d9642eda14e2f7.gif)是正则项，![](img/tex-c6a6eb61fd9c6c913da73b3642ca147d.gif)是正则参数（超参数）。 L2 正则化也称为权重衰减。

对于逻辑回归模型，![](img/tex-61e9c06ea9a85a5088a499df6458d276.gif)是一个向量（即![](img/tex-61e9c06ea9a85a5088a499df6458d276.gif)的维数与特征向量相同），正则项应为：

![](img/tex-1f4feb2f9703563f24c55d6ca002dfec.gif)。

对于具有多层（例如![](img/tex-d20caec3b48a1eef164cb4ca81ba2587.gif)层）的神经网络模型，层之间存在多个参数矩阵。 每个矩阵![](img/tex-61e9c06ea9a85a5088a499df6458d276.gif)的形状是![](img/tex-a5490c7bf0ad3296ada5e539595a633a.gif)。 在等式中，![](img/tex-2db95e8e1a9267b7a1188556b2013b33.gif)是![](img/tex-aa2e85feba6197a03aae3e37bb3927bc.gif)层，![](img/tex-611f54a705adc68456fe1decbf962848.gif)是![](img/tex-2db95e8e1a9267b7a1188556b2013b33.gif)层中的隐藏单元数。 因此，L2 正则化项将是：

![](img/tex-1e70111153f5ddddfee6493eca2f1a0a.gif)

![](img/tex-97795bd4381490a6f7f0e16f19273233.gif)（也称为 Frobenius 范数）。

#### L1 正则化

![](img/tex-25683c056513fba0915f9e92a4a498f9.gif)

![](img/tex-3aa161148ec558064cffc9290ea56798.gif)。

如果我们使用 L1 正则化，则参数![](img/tex-61e9c06ea9a85a5088a499df6458d276.gif)将是稀疏的。



#### Dropout（反向 Dropout）

为了直观地了解 Dropout，Dropout 正则化的目的是使受监督的模型更加健壮。 在训练短语中，激活函数的某些输出值将被忽略。 因此，在进行预测时，模型将不依赖任何一项特征。

在 Dropout 正则化中，超参数“保持概率”描述了激活隐藏单元的几率。 因此，如果隐藏层具有![](img/tex-7b8b965ad4bca0e41ab51de7b31363a1.gif)个单元，并且概率为![](img/tex-83878c91171338902e0fe0fb97a8c47a.gif)，则将激活![](img/tex-6b9b0200ec71d987f83ff9ef61647f50.gif)左右的单元，并关闭![](img/tex-15759ee09f973553c9e5533ebd00215b.gif)左右的单元。

**示例**：
![dropout example](img/21cb3a48039ab84ebda8331da49fa20b.jpg)

如上所示，丢弃了第二层的 2 个单元。 因此，第三层的线性组合值（即![](img/tex-babca7ea11cb55200ed2d0f6c49049b3.gif)）将减小。 为了不降低![](img/tex-fbade9e36a3f36d3d676c1b808451dd7.gif)的期望值，应通过除以保持概率来调整![](img/tex-91262bc83ff35add8629010dd1d6ed0d.gif)的值。 也就是说：![](img/tex-5b3b83e8e3831d7ebadc1ad1021e6b62.gif)

**注意**：在测试时进行预测时，不需要进行 Dropout 正则化。



#### 提前停止

使用提前停止以防止模型过拟合。
![early stopping](img/ce608741593c48fda222334771d7574f.jpg)



### 模型

#### Logistic 回归

给定实例的特征向量![](img/tex-9dd4e461268c8034f5c8564e155c67a6.gif)，逻辑回归模型的输出为![](img/tex-15caf6e5bf502acdf048fa050fc2ad16.gif)。 因此，概率为![](img/tex-a7999a242c6970ff17577d615cdaa529.gif)。 在逻辑回归中，可学习的参数为![](img/tex-61e9c06ea9a85a5088a499df6458d276.gif)和![](img/tex-92eb5ffee6ae2fec3ad71c777531578f.gif)。

x 轴是![](img/tex-c723b4869079c11fecd882437c798bfd.gif)的值，y 轴是![](img/tex-15caf6e5bf502acdf048fa050fc2ad16.gif)。

（图片从[维基百科](https://en.wikipedia.org/wiki/Sigmoid_function)下载）

![logistic curve](img/ad42794031668d9e27c2367c31c60561.jpg)

**一个训练实例![](img/tex-b0ed6d63df3fc6a8176ded0cb5d8674a.gif)的损失函数**：

![](img/tex-ec565cc58baf9512cc892f4d65012394.gif)是预测，![](img/tex-6610e90a866df920aef970e64d297339.gif)是真实答案。 整个训练数据集的
**成本函数**（![](img/tex-6f8f57715090da2632453988d9a1501b.gif)是训练数据集中的示例数）：

**最小化成本函数实际上是最大化数据的似然。**

![](img/tex-8f9e617b3a25bfe0c59ca6a508496e67.gif)



#### 多类别分类（Softmax 回归）

![Softmax Regression](img/80f8b882203cdd4899ebf42e12130891.jpg)

softmax 回归将 logistic 回归（二元分类）概括为多个类（多类分类）。

如上图所示，它是 3 类分类神经网络。 在最后一层，使用 softmax 激活函数。 输出是每个类别的概率。

softmax 激活如下。

1）![](img/tex-7d7b7e529d4d3b5c9455640484b7f71b.gif)

2）![](img/tex-9adb2ad4eaf5a42babe8391e7bd0b520.gif)

![](img/tex-0bb4ef8e89ade3eb2f650a41aeaa8fc0.gif)

![](img/tex-62cf744974e047aa1ea675c97ef5ef4f.gif)

##### 损失函数

![](img/tex-3595e5aa15485bc35e32ee9c82740adf.gif)

![](img/tex-e680f0d21f27ba27274a00712c6fc965.gif)

![](img/tex-6f8f57715090da2632453988d9a1501b.gif)是训练实例的数量。 ![](img/tex-363b122c528f54df4a0446b6bab05515.gif)是第 j 类。



#### 迁移学习

如果我们有大量的训练数据或者我们的神经网络很大，那么训练这样的模型会很费时（例如几天或几周）。 幸运的是，有一些模型已发布并公开可用。 通常，这些模型是在大量数据上训练的。

迁移学习的思想是，我们可以下载这些经过预先训练的模型，并根据自己的问题调整模型，如下所示。

![transfer learning](img/5e3f518d926aace3b8eb6a13203a8c10.jpg)

如果我们有很多数据，我们可以重新训练整个神经网络。 另一方面，如果我们的训练小，则可以重新训练最后几层或最后几层（例如，最后两层）。

**在哪种情况下我们可以使用迁移学习？**

假设：

预先训练的模型用于任务 A，而我们自己的模型用于任务 B。

*   这两个任务应具有相同的输入格式
*   对于任务 A，我们有很多训练数据。 但是对于任务 B，数据的大小要小得多
*   从任务 A 中学到的低级特征可能有助于训练任务 B 的模型。



#### 多任务学习

在分类任务中，通常每个实例只有一个正确的标签，如下所示。 第 i 个实例仅对应于第二类。

但是，在多任务学习中，一个实例可能具有多个标签。

在任务中，损失函数为：

![](img/tex-4601739b486f2ce53da45d4f47612b06.gif)

![](img/tex-6381f1aa41c898a06853a7f67d226cd0.gif)

![](img/tex-6f8f57715090da2632453988d9a1501b.gif)是训练实例的数量。 ![](img/tex-363b122c528f54df4a0446b6bab05515.gif)是第 j 类。

**多任务学习提示**：

*   多任务学习模型可以共享较低级别的特征
*   我们可以尝试一个足够大的神经网络以在所有任务上正常工作
*   在训练集中，每个任务的实例数量相似



#### 卷积神经网络（CNN）

##### 滤波器/内核

例如，我们有一个![](img/tex-5793c51d91799e7fb044517074a59eb0.gif)滤波器（也称为内核），下图描述了滤波器/内核如何在 2D 输入上工作。 输入![](img/tex-9dd4e461268c8034f5c8564e155c67a6.gif)的大小为![](img/tex-ae6d7890da719e4ab1d1c0d107966422.gif)，应用滤波器/内核时的输出大小为![](img/tex-772ec2bb71069c519665a42b4df993c5.gif)。

滤波器/内核中的参数（例如![](img/tex-feb7c19cd6d883830f89418129dbaa2f.gif)）是可学习的。

![CNN on 2D data](img/9c2c49fd7235ae18c1f071b8310269d5.jpg)

而且，我们可以同时具有多个滤波器，如下所示。

![CNN on 2D data with 2 filters](img/c3d8ec289e63298d3b808eb7dbb12a09.jpg)

同样，如果输入是一个 3 维的体积，我们也可以使用 3D 滤波器。 在此滤波器中，有 27 个可学习的参数。

![CNN on 3D data](img/b77b7436d604637125d421a838d2f4c9.jpg)

通常，滤波器的宽度是奇数（例如![](img/tex-4d6ba9b460a81712eacde7738ad52dcb.gif)，![](img/tex-5793c51d91799e7fb044517074a59eb0.gif)，![](img/tex-f57cbc4e8ef8235bc15328cedf283f97.gif)…）

滤波器的想法是，如果它在输入的一部分中有用，那么也许对输入的另一部分也有用。 而且，卷积层输出值的每个输出值仅取决于少量的输入。



#### 步幅

步幅描述了滤波器的步长。 它将影响输出大小。

![stride](img/1b35941d545ec51f35347c083a6ecfea.jpg)

应当注意，一些输入元素被忽略。 这个问题可以通过填充来解决。


#### 填充（有效和相同卷积）

如上所述，有效卷积是我们不使用填充时的卷积。

相同卷积是我们可以使用填充通过填充零来扩展原始输入，以便输出大小与输入大小相同。

例如，输入大小为![](img/tex-ae6d7890da719e4ab1d1c0d107966422.gif)，滤波器为![](img/tex-5793c51d91799e7fb044517074a59eb0.gif)。 如果我们设置`stride = 1`和`padding = 1`，我们可以获得与输入相同大小的输出。

![padding](img/5e4ceb2fe18718dbc56d084c003e7b41.jpg)

通常，如果滤波器大小为`f * f`，输入为`n * n`，步幅为`s`，则最终输出大小为：
![](img/tex-bc90210efcbe3b91d68c3c1d4e53d64b.gif)



#### 卷积层

实际上，我们还在卷积层上应用了激活函数，例如 Relu 激活函数。

![one convolutional layer with relu activation functions](img/02f2499562a99c5e6ac3994253638835.jpg)

至于参数的数量，对于一个滤波器，总共有 27 个（滤波器的参数）+1（偏置）= 28 个参数。



#### `1 * 1`卷积

如果不使用 1X1 转换层，则计算成本存在问题：

![when not use 1*1 CONV](img/715d40440d78d5b1e21facc745c40fa8.jpg)

使用 1X1 转换层，参数数量大大减少：

![when use 1*1 CONV](img/d0579d7fa3dd105c79cc592c43d4bfa6.jpg)


#### 池化层（最大和平均池化）

池化层（例如最大池化层或平均池化层）可以被认为是一种特殊的滤波器。

最大池化层返回滤波器当前覆盖区域的最大值。 同样，平均池层将返回该区域中所有数字的平均值。

![max and average pooling layer](img/421d6a7d6f23678ce6f0f6e6d488c69a.jpg)

在图片中，![](img/tex-8fa14cdd754f91cc6554c9e71929cce7.gif)是滤波器的宽度，![](img/tex-03c7c0ace395d80182db07ae2c30f034.gif)是步长的值。

**注意：在池化层中，没有可学习的参数。**



#### LeNet-5

![LeNet-5](img/5803be278b1c5d9c1993f29675176e0b.jpg)

（模型中有约 60k 参数）

#### AlexNet

![AlexNet](img/0bd66690aa5d0d73796a74ce988a69cd.jpg)

（模型中有约 60m 的参数；使用 Relu 激活函数；）

#### VGG-16

![VGG-16](img/70065677a3527f465f8f82af0d21ca7b.jpg)

（模型中有大约 138m 的参数；所有滤波器中![](img/tex-4d6b51eb80bbd1b1ffc5964a2865c2e1.gif)，![](img/tex-73bbe012edfb61eca43444d61fefe937.gif)并使用相同的填充；在最大池化层中![](img/tex-12a3f108b86e94beb6ea93b18dc3384d.gif)和![](img/tex-23b583065f5b7336c728011ccd7375b2.gif)）


#### ResNet（功能更强大）

![ResNet](img/f21bb1341a73d21f246ca1edc37301f7.jpg)

![](img/tex-23b277e892dc8680fd2e7861bc9fc451.gif)



#### Inception

![Inception Network](img/313152f0481db96e18674bde890d1828.jpg)



#### 对象检测

##### 本地化分类

![Classification with Localisation](img/a28bc9646d6228e89605daccc4e31300.jpg)

**损失函数**：

![Classification with Localisation Loss Function](img/41b77f0687e596a85120540058d3b3e1.jpg)


##### 地标检测

![Landmark Detection](img/14a93bd8d0c34d6124e45fde1639015b.jpg)


##### 滑动窗口检测算法

![Classifier](img/d9e62ee0ccc94083416589fca0b24e7b.jpg)

首先，使用训练集来训练分类器。 然后将其逐步应用于目标图片：

![Classifier](img/61f3a7cf1eef9059af2c9c86514d7dca.jpg)

问题是计算成本（按顺序计算）。 为了解决这个问题，我们可以使用滑动窗口的卷积实现（即将最后的完全连接层变成卷积层）。

![Classifier (Convolutional Implementation)](img/5effaa025cb5fd22e6f009d1bed966f1.jpg)

使用卷积实现，我们不需要按顺序计算结果。 现在我们可以一次计算结果。

![Using Convolutional Implementation](img/9880d614a224b1c7b2a1c6bda0102a52.jpg)



##### 区域提议（R-CNN，仅在几个窗口上运行检测）

实际上，在某些图片中，只有几个窗口具有我们感兴趣的对象。在区域提议（R-CNN）方法中，我们仅在提出的区域上运行分类器。

**R-CNN** ：

*   使用一些算法来提出区域
*   一次对这些提出的区域进行分类
*   预测标签和边界框

**Fast R-CNN** ：

*   使用聚类方法提出区域
*   使用滑动窗口的卷积实现对提出的区域进行分类
*   预测标签和边界框

另一种更快的 R-CNN 使用卷积网络来提出区域。



##### YOLO 算法

###### 边界框预测（YOLO 的基础）

每张图片均分为多个单元。

![Label for Training](img/3240eade58a44b2adcf2b9c73c7fda00.jpg)

对于每个单元格：

*   ![](img/tex-8ad5f203212aab1878f7eebded21fc60.gif)指示单元格中是否存在对象
*   ![](img/tex-f8228e343e33b28208ba70bf6b969341.gif)和![](img/tex-9ee066a0b2387b6370b0aa68a42f93d1.gif)是中点（0 到 1 之间）
*   ![](img/tex-a901e336cf5addb7b6270c5889bc5001.gif)和![](img/tex-73a128f1fb102f2c510a69c64d275ddf.gif)是相对的高和宽（该值可以大于 1.0）。
*   ![](img/tex-576f1dacd615219d9f8bea06b26d5fdc.gif)，![](img/tex-71f0427a673c14326195285a092cc63a.gif)和![](img/tex-20b620923ab918a6f2b7a0eb419f8fc4.gif)表示对象所属的类别。

![Details of the Label](img/3c6f184a23c0c8402c00f71e135a5725.jpg)



###### IOU

![Details of the Label](img/89c3fea69e778061e75b440ba69a7795.jpg)

按照惯例，通常将 0.5 用作阈值，以判断预测的边界框是否正确。 例如，如果 IOU 大于 0.5，则可以说该预测是正确的答案。

![](img/tex-f73c709124099e497ad22ae14efb498b.gif)也可以用作一种方法来衡量两个边界框彼此之间的相似程度。



###### 非最大抑制

![Details of the Label](img/81b4a4993d1f7b3e049a38b489f62bb1.jpg)

该算法可以找到对同一物体的多次检测。 例如，在上图中，它为猫找到 2 个边界框，为狗找到 3 个边界框。 非最大抑制算法可确保每个对象仅被检测一次。

步骤：

1）丢弃所有带有![](img/tex-11f8f4da3f0cb3a5ec5756ad8b81a889.gif)的框

2）对于任何剩下的框：

a）选择具有最大![](img/tex-8ad5f203212aab1878f7eebded21fc60.gif)的框作为预测输出

b）在最后一步中，将所有带有![](img/tex-011310f4e5761898d60b776931cb9b01.gif)的剩余框与选中的框一起丢弃，然后从 a 开始重复。



##### 锚定框

先前的方法只能在一个单元格中检测到一个对象。 但是在某些情况下，一个单元中有多个对象。 为了解决这个问题，我们可以定义不同形状的边界框。

![Anchor Box](img/6897b82514349f07fbd39816a20b99e4.jpg)

因此，训练图像中的每个对象都分配给：

*   包含对象中点的网格单元
*   具有最高![](img/tex-f73c709124099e497ad22ae14efb498b.gif)的网格单元的锚定框

![Anchor Box](img/74152ba95cdc0888eaa3727b43e24b28.jpg)

**做出预测**：

*   对于每个网格单元，我们可以获得 2 个（锚定框的数量）预测边界框。
*   摆脱低概率预测
*   对于每个类别（![](img/tex-576f1dacd615219d9f8bea06b26d5fdc.gif)，![](img/tex-71f0427a673c14326195285a092cc63a.gif)和![](img/tex-20b620923ab918a6f2b7a0eb419f8fc4.gif)），都使用非最大抑制来生成最终预测。



#### 人脸验证

##### 一次性学习（学习“相似性”函数）

在这种情况下，一次性学习就是：从一个例子中学习以再次认识这个人。

函数![](img/tex-fc2beeb62375e002363c70c8c5f8e503.gif)表示 img1 和 img2 之间的差异程度。

![One-Shot Learning](img/905c10d11f62c77d7fa67b0927efb8da.jpg)



###### Siamese 网络（学习差异/相似程度）

![Siamese Network](img/f8f90484ed63faaee13ff1350f049bbb.jpg)

如果我们相信编码函数![](img/tex-50bbd36e1fd2333108437a2ca378be62.gif)可以很好地表示图片，则可以定义距离，如上图底部所示。

**学习**：

可学习的参数：定义编码![](img/tex-50bbd36e1fd2333108437a2ca378be62.gif)的神经网络参数

学习这些参数，以便：

*   如果![](img/tex-e8fa5b806940d1b4d0059fba40646506.gif)和![](img/tex-b7762ca6ebcdab26862a6cd2ff27ac16.gif)是同​​一个人，则![](img/tex-a88d774af5bcbea106ee5b3213070c58.gif)较小
*   如果![](img/tex-e8fa5b806940d1b4d0059fba40646506.gif)和![](img/tex-b7762ca6ebcdab26862a6cd2ff27ac16.gif)是不同的人，则![](img/tex-a88d774af5bcbea106ee5b3213070c58.gif)很大



###### 三重损失（一次查看三张图片）

![Triplet Loss](img/f97381938131c9e1a351b3d6df1e88e5.jpg)

这三张图片是：

*   锚图片
*   正图片：锚图片中同一个人的另一张图片
*   负图片：锚图片中另一张不同人的图片。

但是，仅学习上述损失函数将存在问题。 该损失函数可能导致学习![](img/tex-63eb919bd8178c1e90ac4c3c37a9ff6f.gif)。

为避免出现此问题，我们可以添加一个小于零的项，即![](img/tex-ae28947c21eeac2c7f5cd8b8138e2612.gif)。

要对其进行重组：

![Triplet Loss](img/8658064c94e551580dfc6fc40311f14e.jpg)

汇总**损失函数**：

![Triplet Loss](img/56e2ad826d1e1a3b136c3c9a557d83ae.jpg)

**选择 A，P，N 的三元组**：
在训练期间，如果随机选择 A，P，N，则很容易满足![](img/tex-b146114ae6c73f15901685e0c6ebc29e.gif)。 学习算法（即梯度下降）不会做任何事情。

我们应该选择难以训练的三元组。

!["Hard" Examples](img/8a381dcd6dcb4e62a4e969bf190f1db1.jpg)

当使用困难三元组进行训练时，梯度下降过程必须做一些工作以尝试将这些量推离。



##### 人脸识别/验证和二元分类

![Binary Classification](img/76625ba605b2decb60eb7764f7f0db84.jpg)

我们可以学习一个 Sigmoid 二元分类函数：

![Binary Classification](img/fbd0943156b4673e32b075214ae2f454.jpg)

我们还可以使用其他变量，例如卡方相似度：

![Binary Classification](img/edf420871dd74577dda7fd209f734fcb.jpg)



#### 神经风格转换

![Style Transfer](img/40a3d275da8195f4527bf7e9054d7660.jpg)

内容图像来自电影 Bolt。

样式图像是“百马图”的一部分，这是中国最著名的古代绘画之一。

[https://deepart.io](https://deepart.io) 支持生成的图像。

损失函数![](img/tex-ff44570aca8241914870afbc310cdb85.gif)包含两部分：![](img/tex-d73fb9efd9342bb229c7e790a88efeb7.gif)和![](img/tex-8e3aab6f84d150812695b8c6c726cdcb.gif)。 为了得到生成的图像![](img/tex-dfcf28d0734569a6a693bc8194de62bf.gif)：

1.  随机初始化图像![](img/tex-dfcf28d0734569a6a693bc8194de62bf.gif)
2.  使用梯度下降来最大程度地降低![](img/tex-4849f51690a59d99b4984bf63f46f35a.gif)

**内容成本函数，![](img/tex-d73fb9efd9342bb229c7e790a88efeb7.gif)** ：
内容成本函数可确保不会丢失原始图像的内容。

1）使用隐藏层（不太深也不太浅）![](img/tex-2db95e8e1a9267b7a1188556b2013b33.gif)来计算内容成本。 （我们可以使用来自预训练的卷积神经网络的![](img/tex-2db95e8e1a9267b7a1188556b2013b33.gif)层）

![Select a Hidden Layer](img/bd9276d671c23a19e1b1f03891b176c9.jpg)

2）

![Activation of Layer l](img/7d83297104da2f2842318354da75a29d.jpg)

3）

![Content Cost](img/f8823ee03270ba318dc5c4d082720f4f.jpg)

**样式成本函数，![](img/tex-8e3aab6f84d150812695b8c6c726cdcb.gif)** ：

1）假设我们正在使用![](img/tex-6cc8a2014081620295e35d23a3686735.gif)层激活来衡量样式。

![Select a Hidden Layer](img/1b7ada72fa9f30e2c95de8791e304065.jpg)

2）将图片样式定义为跨通道激活之间的相关性

![Channels of Layer l](img/698947ef69e5a22c0129e061853f52a3.jpg)

矩阵![](img/tex-dfcf28d0734569a6a693bc8194de62bf.gif)中的元素反映了跨不同通道的激活之间的相关性（例如，高级纹理成分是否倾向于同时出现或不出现）。

对于样式图片：

![Matrix of the Style Image](img/7a862f24762df4d490ade0544cd2099c.jpg)

对于生成的图像：

![Matrix G of the Generated Image](img/4b445d47336698613fb62ac067e9e55b.jpg)

**样式函数**：
![Style Function](img/3076cc9514d8b025a8620c9606d2e1ce.jpg)

您也可以考虑合并不同层的样式损失。

![Style Loss Function Combining Different Layers ](img/894e45c9d57f9bf3650b5afa871a2814.jpg)



#### 1D 和 3D 卷积概括

![1D and 3D Generalisations](img/6a9a5dfa7e936f5f315a8119a96e3e1a.jpg)



### 序列模型

#### 循环神经网络模型

**前向**：
![RNN](img/54e11fd6420aa2997cc8b0a6ee87fdcf.jpg)

在此图中，红色参数是可学习的变量![](img/tex-61e9c06ea9a85a5088a499df6458d276.gif)和![](img/tex-92eb5ffee6ae2fec3ad71c777531578f.gif)。 在每个步骤的最后，将计算该步骤的损失。

最后，将每个步骤的所有损失汇总为整个序列的总损失![](img/tex-d20caec3b48a1eef164cb4ca81ba2587.gif)。

这是每个步骤的公式：
![Backpropagation Through Time](img/01d33cfe02dc62c522ca8cfb515467df.jpg)

总损失：
![Total Loss](img/f3425400cc0e3bd1839fec53cea6436e.jpg)

**时间上的反向传播**：
![Backpropagation Through Time](img/d3ebbde1886376d977f009def80625c8.jpg)



#### 门控循环单元（GRU）

##### GRU（简化）

![GRU (Simplified)](img/bcb131ad91c496b7147e85a21c294fa6.jpg)

##### GRU（完整）

![GRU (full)](img/97c8520cbe98af43e3be0bed2d8003b0.jpg)


#### 长期短期记忆（LSTM）

![Long Short Term Memory (LSTM)](img/ead75971212805a0653d11df649f758a.jpg)

*   ![](img/tex-7b774effe4a349c6dd82ad4f4f21d34c.gif)：更新门
*   ![](img/tex-8fa14cdd754f91cc6554c9e71929cce7.gif)：遗忘门
*   ![](img/tex-d95679752134a2d9eb61dbd7b91c4bcc.gif)：输出门



#### 双向 RNN

![Bidirectional RNN](img/87f63e49e9588e4bcbd756179032b62c.jpg)


#### 深度 RNN 示例

![Deep RNN Example](img/52a42c849ea53355b8b51ef2a3621bf5.jpg)


#### 词嵌入

##### 单热

![One-Hot](img/27e5d6001909d4a52c1f48f721f81ae5.jpg)


##### 嵌入矩阵（![](img/tex-3a3ea00cfc35332cedf6e5e9a32e94da.gif)）

![Embedding Matrix](img/64e67905c59092b90ba6db2a8a4f6e41.jpg)

![](img/tex-0708dad23080f2c5981fceb97af02108.gif)是代表未知词的特殊符号。 所有未见过的单词将被强制转换为![](img/tex-0708dad23080f2c5981fceb97af02108.gif)。

矩阵由![](img/tex-3a3ea00cfc35332cedf6e5e9a32e94da.gif)表示。 如果我们想获取单词嵌入，可以按如下所示使用单词的单热向量：
![Get Word Embedding](img/70a4c82a7403d00630d387551d63122a.jpg)

通常，可以将其公式化为：
![Get Word Embedding Equation](img/6d7c4e08c388704aecbedd35ee60fb0a.jpg)


##### 学习单词嵌入

![Learning Word Embedding](img/f134a2b4626d0bd1f3657fc9fc20e6f0.jpg)

在该模型中，可以像其他参数（即![](img/tex-f1290186a5d0b1ceab27f4e77c0c5d68.gif)和![](img/tex-92eb5ffee6ae2fec3ad71c777531578f.gif)）一样学习嵌入矩阵（即![](img/tex-3a3ea00cfc35332cedf6e5e9a32e94da.gif)）。 所有可学习的参数均以蓝色突出显示。

该模型的总体思想是在给定上下文的情况下预测目标单词。 在上图中，上下文是最后 4 个单词（即 a，玻璃，of，橙色），目标单词是“ to”。

另外，有多种方法可以定义目标词的上下文，例如：

*   最后![](img/tex-7b8b965ad4bca0e41ab51de7b31363a1.gif)个字
*   目标词周围![](img/tex-7b8b965ad4bca0e41ab51de7b31363a1.gif)个
*   附近的一个字（Skip-gram 的思路）
*   …



##### Word2Vec & SkipGram

**句子**：

```
I want a glass of orange juice to go along with my cereal.
```

在此词嵌入学习模型中，**上下文**是从句子中随机选择的词。 **目标**是用上下文词的窗口随机拾取的词。

例如：

让我们说上下文词为`orange`，我们可能会得到以下训练示例。

![Context and Target](img/bea872bddef8aee7cdfe1eef5aa31649.jpg)

**模型**：

![Model](img/c3a5eb0a299f894c18f9c6ee3125501c.jpg)

softmax 函数定义为：

![Softmax](img/0d8a8f204d5d51facd5d10bea77796d3.jpg)

![](img/tex-2d2eca8e3c91543f842d75169a89dd0d.gif)是与输出关联的参数，![](img/tex-24ce8d751b27aafd08dca496d00a3fe3.gif)是上下文字的当前嵌入。

使用 softmax 函数的**问题**是分母的计算成本太大，因为我们的词汇量可能很大。 为了减少计算量，负采样是不错的解决方案。



##### 负采样

**句子**：

```
I want a glass of orange juice to go along with my cereal.
```

给定一对单词（即上下文单词和另一个单词）和标签（即第二个单词是否为目标单词）。 如下图所示，（`orange`）是一个正例，因为单词`juice`是橙色的真正目标单词。 由于所有其他单词都是从词典中随机选择的，因此这些单词被视为错误的目标单词。 因此，这些对是负例（如果偶然将真实的目标单词选作负例，也可以）。

![Negative Sampling](img/4f53fb3e54fdc0fb390657b6b27917fd.jpg)

至于每个上下文词的负面词数，如果数据集很小，则为![](img/tex-49a1b92941e9a863b564b15ca7eb3555.gif)；如果数据集很大，则为![](img/tex-9d7bcaadb49138661843e72fff117556.gif)。

**模型**：
![Negative Sampling Model](img/7cd9fc0a58990efef3468298026db3c3.jpg)

我们仅训练 softmax 函数的![](img/tex-730357b6d1c395a3c78503916858d2ba.gif) logistic 回归模型。 因此，计算量低得多且便宜。

**如何选择负例？** ：

![Sampling Distribution](img/3aaf11fa1debadf3c45ba5d627a4217e.jpg)

![](img/tex-e87e05556972ea521be2107e22587e14.gif)是单词频率。

如果使用第一个样本分布，则可能总是选择诸如`the, of`等之类的词。但是，如果使用第三个分布，则所选词将是非代表性的。 因此，第二分布可以被认为是用于采样的更好的分布。 这种分布在第一个和第三个之间。



##### GloVe 向量

**表示法**：![](img/tex-f7d9b2270c66f7c57b29aa847fbfbad7.gif)单词![](img/tex-865c0c0b4ab0e063e5caa3387c1a8741.gif)在单词![](img/tex-363b122c528f54df4a0446b6bab05515.gif)的上下文中出现的次数

**模型**：
![Objective Function](img/c4dba5ac92d36c2706819126e8bd60ed.jpg)

![](img/tex-293d0536b3311ee8663909034780258d.gif)测量这两个词之间的关联程度以及这两个词在一起出现的频率。 ![](img/tex-55e52827aaa9a24dbdd70c6de817ab29.gif)是权重项。 它给高频对带来了不太高的权重，也给了不太常见的对带来了不太小的权重。

如果我们检查![](img/tex-2554a2bb846cffd697389e5dc8912759.gif)和![](img/tex-e1671797c52e15f763380b45e841ec32.gif)的数学运算，实际上它们起着相同的作用。 因此，词的最终词嵌入为：

![Final Word Embedding](img/8fd088ed4f3547cec89e76e68b642b99.jpg)



##### 深度上下文化的词表示形式（ELMo，语言模型的嵌入）

预训练双向语言模型

正向语言模型：给定![](img/tex-8d9c307cb7f3c4a32822a51922d1ceaa.gif)个符号的序列![](img/tex-acb96b7daa1408d6d842a39ffb748b50.gif)，正向语言模型计算序列概率，通过建模给定历史的![](img/tex-b43943c21cee89e2a9628e2970bf83e5.gif)的概率，即，

![](img/0fbba036e08140bf0fa7e04d64d3e69b.jpg)

反向语言模型：类似地，

![](img/ab88920915a53affd485e518d4da10a6.jpg)

双向语言模型：它结合了正向和反向语言模型。 共同最大化正向和后向的似然：

![](img/f578523d433261f9927e7a797d3bccc0.jpg)

LSTM 用于建模前向和后向语言模型。

![bidirectional language model](img/aaa6aac5f6ef75574c5744557bd23d3a.jpg)

就输入嵌入而言，我们可以只初始化这些嵌入或使用预先训练的嵌入。 对于 ELMo，通过使用字符嵌入和卷积层，会更加复杂，如下所示。

![Input Embeddings](img/a0ecfb35333ed66edf7464d94518166d.jpg)

训练了语言模型之后，我们可以得到句子中单词的 ELMo 嵌入：

![ELMo](img/25d7b4760c8a1c565d1f162a46f7bbfc.jpg)

在 ELMo 中，![](img/tex-03c7c0ace395d80182db07ae2c30f034.gif)是 softmax 归一化的权重，而![](img/tex-ae539dfcc999c28e25a0f3ae65c1de79.gif)是标量参数，允许任务模型缩放整个 ELMo 向量。 可以在任务特定模型的训练过程中学习这些参数。

参考：

[1] [https://www.slideshare.net/shuntaroy/a-review-of-deep-contextualized-word-representations-peters-2018](https://www.slideshare.net/shuntaroy/a-review-of-deep-contextualized-word-representations-peters-2018)

[2] [http://jalammar.github.io/illustrated-bert/](http://jalammar.github.io/illustrated-bert/)

[3] [https://www.mihaileric.com/posts/deep-contextualized-word-representations-elmo/](https://www.mihaileric.com/posts/deep-contextualized-word-representations-elmo/)



#### 序列到序列模型示例：翻译

任务是将一个序列转换为另一个序列。 这两个序列可以具有不同的长度。

![Sequence to Sequence](img/af9339a9ae2cb9e6f83c65c773cab52e.jpg)

![Model](img/2fdc06ab9622f569d55a240a6f2c8a8a.jpg)



##### 选择最可能的句子（集束搜索）

###### 集束搜索

使用序列对模型进行序列化在机器翻译中很流行。 如图所示，翻译是逐个标记地生成的。 问题之一是如何挑选最可能的整个句子？ 贪婪搜索不起作用（即在每个步骤中选择最佳单词）。 集束搜索是一种更好的解决方案。

![Beam Search (Beam Width = 3)](img/7e8a0795a8728cd57dcb63e401284519.jpg)

让我们假设集束搜索宽度为 3。因此，在每一步中，我们只保留了前 3 个最佳预测序列。

例如（如上图所示），

*   在第 1 步中，我们保留` in, June, September`
*   在第 2 步中，我们保留以下顺序：` (in, September), (June is), (June visits)`
*   …

至于集束搜索宽度，如果我们有一个较大的宽度，我们可以获得更好的结果，但是这会使模型变慢。 另一方面，如果宽度较小，则模型会更快，但可能会损害其性能。 集束搜索宽度是一个超参数，最佳值可能是领域特定的。



###### 长度标准化

翻译模型的学习将最大化：

![Beam Search (Beam Width = 3)](img/11f65adc5299b44a1b33eb8d3283915b.jpg)

在对数空间中，即：

![Beam Search (Beam Width = 3)](img/9015bf98cde37867bed994713da2de11.jpg)

上述目标函数的问题在于对数空间中的分数为 始终为负，因此使用此函数将使模型偏向一个很短的句子。 我们不希望翻译实际上太短。

我们可以在开头添加一个长度标准化项：
![Beam Search (Beam Width = 3)](img/4ae4523746f121dd4cfc5072af784575.jpg)


###### 集束搜索中的错误分析（启发式搜索算法）

在调整模型的参数时，我们需要确定它们的优先级（即，更应该归咎于 RNN 或集束搜索部分）。 （通常增加集束搜索宽度不会损害性能）。

**示例**

从开发集中选择一个句子并检查我们的模型：

**句子**：`Jane visite l’Afrique en septembre.`

**来自人类的翻译**：`Jane visits Africa in September. `（![](img/tex-67c77cc00e83a60647d826334509d2b3.gif)）

**算法的输出（我们的模型）**：`Jane visited Africa last September. ` （![](img/tex-5d28a7ba1a44a73b8c2ed21321697c59.gif)）

为了弄清楚应该归咎于哪个，我们需要根据 RNN 神经网络计算并比较![](img/tex-603569df3719a6cc5c457323985a836d.gif)和![](img/tex-20057ca553bcc6aa6ecbfa45a054f11f.gif)。

如果![](img/tex-08a374edd701b759e50ffd97862937ff.gif)：

![](img/tex-89b3a69e7c4dd4ee4e7aaf09191ac8e1.gif)获得更高的概率，则可以得出结论，集束搜索存在故障。

如果 ![](img/tex-3864a10efa8df8cb498267e9429b3493.gif)：

RNN 预测![](img/tex-3864a10efa8df8cb498267e9429b3493.gif)，但实际上![](img/tex-67c77cc00e83a60647d826334509d2b3.gif)比![](img/tex-5d28a7ba1a44a73b8c2ed21321697c59.gif)更好，因为它来自真实的人。 因此，RNN 模型应该有问题。

通过在开发集中的多个实例上重复上述错误分析过程，我们可以得到下表：

![Beam Search (Beam Width = 3)](img/e8f365dc27ffb1321bade49b2e3570b5.jpg)

根据该表，我们可以找出是由于集束搜索/ RNN。

如果大多数错误是由于集束搜索造成的，请尝试增加集束搜索宽度。 否则，我们可能会尝试使 RNN 更深入/添加正则化/获取更多训练数据/尝试不同的架构。


##### Bleu 得分

如果一个句子有多个出色的答案/推荐，我们可以使用 Bleu 得分来衡量模型的准确性。

**示例（二元组的 Bleu 得分）**：

**法语**：` Le chat est sur le tapis.`

**参考 1**：`The cat is on the mat.`

**参考 2**：`There is a cat on the mat.`

**我们模型的输出**：`The cat the cat on the cat.`

![Bleu Score on Bigram Example](img/d4f52d3e06f69da44c0df114ec532d1c.jpg)

**计数**是输出中出现的当前二元组的数量。 **截断计数**是二元组出现在参考 1 或参考 2 中的最大次数。

然后可以将二元组的 Bleu 分数计算为：

![Bleu Score on Bigram](img/dee8ac08a6bda57a098bedc117e6060e.jpg)

上面的等式可以用来计算 unigram，bigram 或 any-gram Bleu 分数。



##### 组合 Bleu

合并的 Bleu 分数合并了不同 Gram 的分数。 ![](img/tex-6cbb60d59d04d1d7c9e64fd2a001c8c6.gif)仅表示 n-gram 的 Bleu 分数。 如果我们具有![](img/tex-20868fa29dfc38ac154b8ef762766b41.gif)，![](img/tex-2d70da379b3ffb56bd104b348ba21c55.gif)，![](img/tex-c0ac8b12bab590e951e0afb93938cdcb.gif)和![](img/tex-d94aa42e38e4ef613c5cb9a398883c3e.gif)，则可以组合为以下内容：

![Bleu Score on Bigram](img/198bb5e05cba5c05689777b90e7b93ef.jpg)

简短的惩罚会惩罚简短的翻译。 （我们不希望翻译得太短，因为简短的翻译会带来很高的精度。



##### 注意力模型

RNN（例如 lstm）的一个问题是很难记住超长句子。 模型翻译质量将随着原始句子长度的增加而降低。

![Attention Model](img/87316575589d3ae0b79af54f35eeb616.jpg)

有多种计算注意力的方法。 一种方法是：

![Attention Computation](img/d203575ed5c0c4e51f1e0d6f2ef026bb.jpg)

在这种方法中，我们使用小型神经网络将之前和当前的信息映射到注意力权重。

已经证明注意力模型可以很好地工作，例如归一化。

![Attention Model Example](img/c21a701bbfba2e64dec36e78b95501a8.jpg)



### 转换器（“Attention Is All You Need”）

**架构**：

![Transformer](img/278f986550f8ebffa960c97a0f8b8a90.jpg)

**详细信息**：

输入嵌入：

模型的输入嵌入是单词嵌入及其每个单词的位置编码的总和。 例如，对于输入句子![](img/tex-9b1ba72483bca5814ae840215acb813c.gif)。 ![](img/tex-70e59a996bd69a0c21878b4093375e92.gif)是句子中每个单词的单词嵌入（可以是预训练的嵌入）。 输入嵌入应为![](img/tex-7b1956b4b0b4a0114d5b45c131157ae7.gif)。

![](img/tex-220b8d39c582b274a5e41ed6fe21b3cb.gif)是每个单词的位置编码。 有许多方法可以对单词位置进行编码。 在本文中，使用的编码方法是：

![](img/tex-c8fba499f56f79f11a335d94617afd59.gif)

![](img/tex-875900adbdb7a4d55a296caa523a36d2.gif)

![](img/tex-4757fe07fd492a8be0ea6a760d683d6e.gif)是单词在句子中的位置。 ![](img/tex-865c0c0b4ab0e063e5caa3387c1a8741.gif)是位置编码的元素位置。 ![](img/tex-885bd82dfe3227a0f7315eb81a6f3acb.gif)是模型中编码器的输出尺寸大小。

解码器

*   顶部编码器的输出将转换为注意力向量![](img/tex-a5f3c6a11b03839d46af9fb43c97c188.gif)和![](img/tex-5206560a306a2e085a437fd258eb57ce.gif)。 这些用于多头注意力子层（也称为编解码器注意力）。 注意力向量可以帮助解码器专注于输入句子的有用位置。
*   掩码的自注意只允许专注于输出句子的较早位置。 因此，通过在 softmax 步骤之前将它们设置为-inf。
*   “多头注意”层类似于编码器中的“自注意”层，除了：
    *   它从顶部编码器的输出中获取![](img/tex-a5f3c6a11b03839d46af9fb43c97c188.gif)和![](img/tex-5206560a306a2e085a437fd258eb57ce.gif)
    *   它从其下一层创建![](img/tex-f09564c9ca56850d4cd6b3319e541aee.gif)

参考： [https://jalammar.github.io/illustrated-transformer/](https://jalammar.github.io/illustrated-transformer/)



### 转换器的双向编码器表示（BERT）

BERT 是通过堆叠转换器编码器构建的。

![BERT](img/ad5446e3f44bd8d4852aeb252ef13bbe.jpg)

对未标记的大文本进行预训练（预测被掩盖的单词）

![BERT Pretrain](img/0ecd731042d32164b7fce874557ecdc8.jpg)

“带掩码的语言模型会随机掩盖输入中的某些标记，目的是为了 仅根据上下文来预测被屏蔽单词的原始词汇 ID。” [2]

使用受监督的训练对特定任务（例如， 分类任务，NER 等

![BERT Classification](img/636673655f87b5d52596f2ec92d53177.jpg)

BERT 论文的下图显示了如何将模型用于不同的任务。

![BERT on different tasks](img/cd5c079735781e239d47d6e8733d6063.jpg)

如果特定任务不是分类任务，则可以忽略[CLS]。

参考：

[1] http://jalammar.github.io/illustrated-bert/

[2] Devlin, J., Chang, M.W., Lee, K. and Toutanova, K., 2018. Bert: Pre-training of deep bidirectional transformers for language understanding. arXiv preprint arXiv:1810.04805.



### 实用提示

#### 训练/开发/测试数据集

*   通常，我们将数据集的 **70%** 用作训练数据，将 30%用作测试集； 或 **60%**（训练）/ **20%**（开发）/ **20%**（测试）。 但是，如果我们有一个大数据集，则可以将大多数实例用作训练数据（例如 1,000,000， **98%**），并使开发和测试集的大小相等（例如 10,000（ **1% 用于开发**），测试集使用 10,000（ **1%**）。 由于我们的数据集很大，因此开发和测试集中的 10,000 个示例绰绰有余。
*   确保开发和测试集来自同一分布

**我们可能遇到的另一种情况**：

1）我们要为特定域构建系统，但是在该域中我们只有几个标记数据集（例如 10,000）

2）我们 可以从类似的任务中获得更大的数据集（例如 200,000 个实例）。

在这种情况下，如何构建训练，开发和测试集？

最简单的方法是将两个数据集组合在一起并对其进行随机排序。 然后，我们可以将合并的数据集分为三个部分（训练，开发和测试集）。 但是，这不是一个好主意。 因为我们的目标是为我们自己的特定领域构建系统。 将没有来自我们自己域的一些实例添加到开发/测试数据集中以评估我们的系统是没有意义的。

合理的方法是：

1）将所有更容易使用的实例（例如 200,000）添加到训练集中

2）从特定域数据集中选择一些实例并将它们添加到训练集中

3）将我们自己领域的其余实例分为开发和测试集

![dataset](img/82ba87dda9fab264206383db7052c862.jpg)



#### 过拟合/欠拟合，偏差/方差，与人类水平的表现比较，解决方案

##### 过拟合/欠拟合，偏差/方差

对于分类任务，人类分类误差应该在 0%左右。 监督模型在训练和开发集上的各种可能的表现分析如下所示。

|  |  |  |  |  |
| --- | --- | --- | --- | --- |
| 人为错误 | 0.9% | 0.9% | 0.9% | 0.9% |
| 训练集错误 | 1% | 15% | 15% | 0.5% |
| 测试集错误 | 11% | 16% | 30% | 1% |
| 评价 | 过拟合 | 欠拟合 | 欠拟合 | 良好 |
|  | 高方差 | 高偏差 | 高偏差和方差 | 低偏差和方差 |

**解决方案**：

![solutions for high bias and variance](img/3c933dedf3303f72861bfa114404f5ed.jpg)

##### 与人类水平的表现比较

您可能已经注意到，在上表中，人为水平的误差设置为 0.9%，如果人为水平的表现不同但训练/开发误差相同，该怎么办？

|  |  |  |
| --- | --- | --- |
| 人为错误 | **1%** | **7.5%** |
| 训练集错误 | 8% | 8% |
| 测试集错误 | 10% | 10% |
| 评价 | 高偏差 | 高方差 |

尽管模型误差相同，但在左图中人为误差为 1%时，我们有高偏差问题，而在右图中有高方差问题。

至于模型的性能，有时它可能比人类的模型更好。 但是只要模型的性能不如人类，我们就可以：

1）从人类获得更多的标记数据

2）从手动误差分析中获得见解

3）从偏差/方差分析中获得见解



#### 数据分布不匹配

当我们为自己的特定领域构建系统时，针对我们自己的问题，我们只有几个带标签的实例（例如 10,000 个）。 但是我们很容易从另一个类似的领域中收集很多实例（例如 200,000 个）。 此外，大量容易获得的实例可能有助于训练一个好的模型。 数据集可能看起来像这样：

![dataset](img/82ba87dda9fab264206383db7052c862.jpg)

但是在这种情况下，训练集的数据分布与开发/测试集不同。 这可能会导致副作用-数据不匹配问题。

为了检查我们是否存在数据不匹配问题，我们应该随机选择训练集的一个子集作为名为训练-开发数据集的验证集。 该集合具有相同的训练集分布，但不会用于训练。

![dataset](img/6853f1701cbde2eafc3080bda2c2caf0.jpg)

|  |  |  |  |  |
| --- | --- | --- | --- | --- |
| 人为误差 | 0% | 0% | 0% | 0% |
| 训练误差 | 1% | 1% | 10% | 10% |
| 训练-开发误差 | 9% | 1.5% | 11% | 11% |
| 开发误差 | 10% | 10% | 12% | 20% |
| 问题 | 高方差 | 数据不匹配 | 高偏差 | 高偏差+数据不匹配 |

总结一下：

![measure of different problems](img/8f740ae15c1928ebd34214f5675f6c20.jpg)

##### 解决了数据分布不匹配的问题

首先，进行手动错误分析以尝试了解我们的训练集和开发/测试集之间的区别。

其次，根据分析结果，我们可以尝试使训练实例与开发/测试实例更相似。 我们还可以尝试收集更多与开发/测试集的数据分布相似的训练数据。



#### 输入标准化

我们有一个包含![](img/tex-6f8f57715090da2632453988d9a1501b.gif)示例的训练集。 ![](img/tex-00a54cd5025f65c4f439dca9d8bb1912.gif)代表![](img/tex-97361f12a3555fc4fc4e2ffce1799ac3.gif)示例。 输入标准化如下。

![](img/tex-167ea861b2403a7d7bf8db9db9e89f13.gif)，
![](img/tex-ed79728da37e7f67566dd01ea5108e96.gif)，
![](img/tex-573e4264476c5baeac0a6398fbea2624.gif)

**注意**：必须使用相同的![](img/tex-c9faf6ead2cd2c2187bd943488de1d0a.gif)和![](img/tex-10e16c6a764d367ca5077a54bf156f7e.gif)训练数据来标准化测试数据集。

使用输入标准化可以使训练更快。

假设输入是二维![](img/tex-9eaecfed8f843923011652abc1b24521.gif)。 范围分别是![](img/tex-0d5fa3f335333b23d4aaf795d1336587.gif)和![](img/tex-e209e24a3d42a840c21481572570342f.gif)的[1-1000]和[1-10]。 损失函数可能看起来像这样（左）：

![left:non-normalized right: normalized](img/77223e53d8940a2a4ce83e0ba0b1a907.jpg)



#### 使用单一数字模型评估指标

如果我们不仅关心模型的表现（例如准确性，F 分数等），还关心运行时间，则可以设计一个数字评估指标来评估我们的模型。

例如，我们可以结合表现指标和运行时间，例如![](img/tex-935115e8fc9e3c2b5436ba6f18331427.gif)。

另外，我们还可以指定可以接受的最大运行时间：

![](img/tex-e3f18d64de4ad0c3ebd7562f5ce69d7e.gif)

![](img/tex-4449fd1e9d3820a31eb52f3f88226f66.gif)



#### 错误分析（优先考虑后续步骤）

进行错误分析对于确定改善模型性能的后续步骤的优先级非常有帮助。

##### 执行错误分析

例如，为了找出模型为什么错误标记某些实例的原因，我们可以从开发集中获取大约 100 个**错误标记的**示例并进行错误分析（手动逐个检查）。

| 图片 | 狗 | 猫 | 模糊 | 评价 |
| --- | --- | --- | --- | --- |
| 1 | ![](img/tex-b75a3fd9300479b267b98a50962b9eb8.gif) |  |  |  |
| 2 |  |  | ![](img/tex-b75a3fd9300479b267b98a50962b9eb8.gif) |  |
| 3 |  | ![](img/tex-b75a3fd9300479b267b98a50962b9eb8.gif) | ![](img/tex-b75a3fd9300479b267b98a50962b9eb8.gif) |  |
| … | … | … | … | … |
| 百分比 | 8% | 43% | 61% |  |

通过手动检查这些标签错误的实例，我们可以估计错误的出处。 例如，在上述表格中，我们发现 61%的图像模糊，因此在下一步中，我们可以集中精力改善模糊图像的识别性能。

##### 清除标签错误的数据

有时，我们的数据集很嘈杂。 换句话说，数据集中存在一些不正确的标签。 同样，我们可以从开发/测试集中选取约 100 个实例，然后手动逐个检查它们。

例如，当前开发/测试集上的模型错误为 10%。 然后，我们手动检查从开发/测试集中随机选择的 100 个实例。

| 图片 | 标签不正确 |
| --- | --- |
| 1 个 |  |
| 2 | ![](img/tex-b75a3fd9300479b267b98a50962b9eb8.gif) |
| 3 |  |
| 4 |  |
| 5 | ![](img/tex-b75a3fd9300479b267b98a50962b9eb8.gif) |
| … | … |
| 百分比 | 6% |

假设，最后我们发现 6%实例的标签错误。 基于此，我们可以猜测由于标签错误而导致的![](img/tex-cfa0e6791a40e9c0b82db894905f6578.gif)错误以及由于其他原因而导致的![](img/tex-ff03486bfd196f4425f6a72ac007be09.gif)错误。

因此，如果我们下一步专注于纠正标签，那么可能不是一个好主意。

