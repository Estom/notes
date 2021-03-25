# PyTorch 深度学习：60分钟快速入门

> 原文：<https://pytorch.org/tutorials/beginner/deep_learning_60min_blitz.html>



## 1 目录

* [02Pytorch](02Pytorch.md)
* [03Tensor张量](03Tensor.md)
* [04autograd](04Autograd.md)
* [05神经网络](05NN.md)
* [06图像分类器](06Classification.md)

## 2 概述

### 什么是 PyTorch？

PyTorch 是基于以下两个目的而打造的python科学计算框架：

*   无缝替换NumPy，并且通过利用GPU的算力来实现神经网络的加速。
*   通过自动微分机制，来让神经网络的实现变得更加容易。

### 本次教程的目标：

*   深入了解PyTorch的张量单元以及如何使用Pytorch来搭建神经网络。
*   自己动手训练一个小型神经网络来实现图像的分类。

## 3 模块

> 当前需要了解的模块
1. torch
2. torch.Tensor
3. torch.nn.*
4. torch.nn.Function
5. torch.optim
6. torch.util.data
7. torch.util.tensorboard


## 1.1 torch模块
```
import torch
torch.randn()
torch.from_numpy()
torch.linspace()
torch.ones()
torch.eye()
```
包含了多维张量的数据结构以及基于其上的多种数学操作。另外，它也提供了多种工具，其中一些可以更有效地对张量和任意类型进行序列化。具体包括pytorch张量的生成，以及运算、切片、连接等操作，还包括神经网络中经常使用的激活函数，比如sigmoid、relu、tanh，还提供了与numpy的交互操作
* 该模块定义了大量对tensor操作的**方法**，能够返回tensor

## 1.2 torch.Tensor模块类
```
import torch
a = torch.tensor()

# 返回操作和自操作
a.exp()
a.exp_()
```
numpy作为Python中数据分析的专业第三方库，比Python自带的Math库速度更快。同样的，在PyTorch中，有一个类似于numpy的库，称为Tensor。Tensor可谓是神经网络界的numpy

* 定义了**tensor对象**的一系列操作。自己的操作。

## 1.3 torch.sparse
在做nlp任务时，有个特点就是特征矩阵是稀疏矩阵。torch.sparse模块定义了稀疏张量，采用的是COO格式，主要方法是用一个长整型定义非零元素的位置，用浮点数张量定义对应非零元素的值。稀疏张量之间可以做加减乘除和矩阵乘法。从而有效地存储和处理大多数元素为零的张量。

## 1.4 torch.cuda
该模块定义了与cuda运算的一系列函数，比如检查系统的cuda是否可用，在多GPU情况下，查看显示当前进程对应的GPU序号，清除GPU上的缓存，设置GPU的计算流，同步GPU上执行的所有核函数等。

## 1.5 torch.nn.*模块
torch.nn是pytorch神经网络模块化的核心，这个模块下面有很多子模块，包括卷积层nn.ConvNd和线性层（全连接层）nn.Linear等。当构建深度学习模型的时候，可以通过继承nn.Module类并重写forward方法来实现一个新的神经网络。另外，torch.nn中也定义了一系列的损失函数，包括平方损失函数torch.nn.MSELoss、交叉熵损失函数torch.nn.CrossEntropyLoss等。

* 定义了一系列对象化的算子层。包含各种tensor表示的参数。包含一系列子模块。对象化后，一个算子表示一层的输入输出和操作。而函数化的时候，指标是单个路径上的输入输出操作。
  * **nn.Module** 表示神经网络对象。包含forward()/parameters()/modules()/zero_grad()
  * **nn.Sequential**处理序列化的module
  * **nn.Conv1d/nn.Conv2d/nn.Conv3d**卷积层模块
  * **nn.MaxPool1d/nn.MaxPool2d/nn.MaxPool3d**最大池化层模块
  * **nn.AvgPool1d/nn.AvgPool2d/nn.AvgPool3d**平均池化层
  * **nn.ReLU/nn.ELU/nn.Sigmod/nn.Tanh/nn.LogSigmod**线性全连接层
  * **nn.Softmin/nn.Softmax/nn.Softshrink/nn.Softsign/nn.Softplus**全连接层
  * **nn.BatchNomal1d/nn.BatchNoraml2d/nn.BatchNoraml3d**归一化层
  * **nn.RNN**循环神经元层
  * **nn.Function**函数化的各种算子。参考下一个

## 1.6 torch.nn.Functional函数模块
该模块定义了一些与神经网络相关的函数，包括卷积函数和池化函数等，torch.nn中定义的模块一般会调用torch.nn.functional里的函数，比如，nn.ConvNd会调用torch.nn.functional.convNd函数。另外，torch.nn.functional里面还定义了一些不常用的激活函数，包括torch.nn.functional.relu6和torch.nn.functional.elu等。

* 定义了一系列函数化的算子。包含各种tensor表示的参数。可以把它看做nn的一个子模块。而且提供更加精细快速的神经网络构建过程

## 1.7 torch.nn.init模块
该模块定义了神经网络权重的初始化，包括均匀初始化torch.nn.init.uniform_和正太分布归一化torch.nn.init.normal_等。值得注意得是，在pytorch中函数或者方法如果以下划线结尾，则这个方法会直接改变作用张量的值，因此，这些方法会直接改变传入张量的值，同时会返回改变后的张量。

## 1.8 torch.optim模块
torch.optim模块定义了一系列的优化器，比如**torch.optim.SGD、torch.optim.AdaGrad、torch.optim.RMSProp、torch.optim.Adam**等。还包含学习率衰减的算法的模块torch.optim.lr_scheduler，这个模块包含了学习率阶梯下降算法torch.optim.lr_scheduler.StepLR和余弦退火算法torch.optim.lr_scheduler.CosineAnnealingLR

* torch.optim.SGD、
* torch.optim.AdaGrad、
* torch.optim.RMSProp、
* torch.optim.Adam

## 1.9 torch.autograd模块
该模块是pytorch的自动微分算法模块，定义了一系列自动微分函数，包括torch.autograd.backward函数，主要用于在求得损失函数后进行反向梯度传播。torch.autograd.grad函数用于一个标量张量（即只有一个分量的张量）对另一个张量求导，以及在代码中设置不参与求导的部分。另外，这个模块还内置了数值梯度功能和检查自动微分引擎是否输出正确结果的功能。

## 1.10 torch.distributed模块
torch.distributed是pytorch的分布式计算模块，主要功能是提供pytorch的并行运行环境，其主要支持的后端有MPI、Gloo和NCCL三种。pytorch的分布式工作原理主要是启动多个并行的进程，每个进程都拥有一个模型的备份，然后输入不同的训练数据到多个并行的进程，计算损失函数，每个进行独立地做反向传播，最后对所有进程权重张量的梯度做归约（Redue）。用到后端的部分主要是数据的广播（Broadcast）和数据的收集（Gather），其中，前者是把数据从一个节点（进程）传播到另一个节点（进程），比如归约后梯度张量的传播，后者则把数据从其它节点转移到当前节点，比如把梯度张量从其它节点转移到某个特定的节点，然后对所有的张量求平均。pytorch的分布式计算模块不但提供了后端的一个包装，还提供了一些启动方式来启动多个进程，包括但不限于通过网络（TCP）、环境变量、共享文件等。

## 1.11 torch.distributions模块
该模块提供了一系列类，使得pytorch能够对不同的分布进行采样，并且生成概率采样过程的计算图。在一些应用过程中，比如强化学习，经常会使用一个深度学习模型来模拟在不同环境条件下采取的策略，其最后的输出是不同动作的概率。当深度学习模型输出概率之后，需要根据概率对策略进行采样来模拟当前的策略概率分布，最后用梯度下降方法来让最优策略的概率最大（这个算法称为策略梯度算法，Policy Gradient）。实际上，因为采样的输出结果是离散的，无法直接求导，所以不能使用反keh.distributions.Categorical类，pytorch还支持其它分布。比如torch.distributions.Normal类支持连续的正太分布的采样，可以用于连续的强化学习的策略。

## 1.12 torch.hub模块
该模块提供了一系列预训练的模型供用户使用。比如，可以通过torch.hub.list函数来获取某个模型镜像站点的模型信息。通过torch.hub.load来载入预训练的模型，载入后的模型可以保存到本地，并可以看到这些模型对应类支持的方法。

## 1.13 torch.jit模块
该模块是pytorch的即时编译器模块。这个模块存在的意义是把pytorch的动态图转换成可以优化和序列化的静态图，其主要工作原理是通过预先定义好的张量，追踪整个动态图的构建过程，得到最终构建出来的动态图，然后转换为静态图。通过JIT得到的静态图可以被保存，并且被pytorch其它前端（如C++语言的前端）支持。另外，JIT也可以用来生成其它格式的神经网络描述文件，如ONNX。torch.jit支持两种模式，即脚本模式（ScriptModule）和追踪模式（Tracing）。两者都能构建静态图，区别在于前者支持控制流，后者不支持，但是前者支持的神经网络模块比后者少。

## 1.14 torch.multiprocessing模块
该模块定义了pytorch中的多进程API，可以启动不同的进程，每个进程运行不同的深度学习模型，并且能够在进程间共享张量。共享的张量可以在CPU上，也可以在GPU上，多进程API还提供了与python原生的多进程API（即multiprocessing库）相同的一系列函数，包括锁（Lock）和队列（Queue）等。

## 1.15 torch.random模块
该模块提供了一系列的方法来保存和设置随机数生成器的状态，包括使用get_rng_state函数获取当前随机数生成器的状态，set_rng_state函数设置当前随机数生成器状态，并且可以使用manual_seed函数来设置随机种子，也可以使用initial_seed函数来得到程序初始的随机种子。因为神经网络的训练是一个随机的过程，包括数据的输入、权重的初始化都具有一定的随机性。设置一个统一的随机种子可以有效地帮助我们测试不同神经网络地表现，有助于调试神经网络地结构。

## 1.16 torch.onnx模块
该模块定义了pytorch导出和载入ONNX格式地深度学习模型描述文件。ONNX格式地存在是为了方便不同深度学习框架之间交换模型。引入这个模块可以方便pytorch导出模型给其它深度学习框架使用，或者让pytorch载入其它深度学习框架构建地深度学习模型。

## 1.17 torch.utils模块
该模块提供了一系列地工具来帮助神经网络地训练、测试和结构优化。这个模块主要包含以下6个子模块：

### 1 torch.utils.bottleneck模块
该模块可以用来检查深度学习模型中模块地运行时间，从而可以找到性能瓶颈的那些模块，通过优化那些模块的运行时间，从而优化整个深度学习的模型的性能。

### 2 torch.utils.checkpoint模块
该模块可以用来节约深度学习使用的内存。通过前面的介绍我们知道，因为要进行梯度反向传播，在构建计算图的时候需要保存中间的数据，而这些数据大大增加了深度学习的内存消耗。为了减少内存消耗，让迷你批次的大小得到提高，从而提升深度学习模型的性能和优化时的稳定性，我们可以通过这个模块记录中间数据的计算过程，然后丢弃这些中间数据，等需要用到的时候再重新计算这些数据。这个模块设计的核心思想是以计算时间换内存空间，如果使用得当，深度学习模型的性能可以有很大的提升。

### 3 torch.utils.cpp_extension模块
该模块定义了pytorch的C++扩展，其主要包含两个类：CppExtension定义了使用C++来编写的扩展模块的源代码相关信息，CUDAExtension则定义了C++/CUDA编写的扩展模块的源代码相关信息。再某些情况下，用户可能使用C++实现某些张量运算和神经网络结构（比如pytorch没有类似功能的模块或者类似功能的模块性能比较低），该模块就提供了一个方法能够让python来调用C++/CUDA编写的深度学习扩展模块。在底层上，这个扩展模块使用了pybind11,保持了接口的轻量性并使得pytorch易于被扩展。

### 4 torch.utils.data模块
该模块引入了 **数据集（Dataset）和数据载入器（DataLoader）** 的概念，前者代表包含了所有数据的数据集，通过索引能够得到某一条特定的数据，后者通过对数据集的包装，可以对数据集进行 **随机排列（Shuffle）和采样（Sample）** ,得到一系列打乱数据的迷你批次。

### 5 torch.util.dlpacl模块
该模块定义了pytorch张量和DLPackz张量存储格式之间的转换，用于不同框架之间张量数据的交换。

### 6 torch.utils.tensorboard模块
该模块是pytorch对TensorBoard数据可视化工具的支持。TensorBoard原来是TensorFlow自带的数据可视化工具，能够显示深度学习模型在训练过程中损失函数、张量权重的直方图，以及模型训练过程中输出的文本、图像和视频等。TensorBoard的功能非常强大，而且是基于可交互的动态网页设计的，使用者可以通过预先提供的一系列功能来输出特定的训练过程的细节（如某一神经网络层的权重的直方图，以及训练过程中某一段时间的损失函数等）pytorch支持TensorBoard可视化后，在训练过程中，可以很方便地观察中间输出地张量，也可以方便地调试深度学习模型。