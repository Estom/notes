# pysyft
> 对pytorch框架和TensorFlow框架的federated框架进行了研究。
> * tensorflow federated 框架只提供了本地的仿真。
> * pysyft 框架提供了websocket worker初步实现了基于websocket网络通信的多进程仿真，是当前最接近于实践的一种仿真方式，能够实现多个linux/python环境下的仿真与多个进程下的仿真。只在0.2.4中有，可以尝试在此基础进行改进和训练。

> 参考文献
> * [A generic framework for privacy preserving deep learning](https://zhuanlan.zhihu.com/p/114774133)
> * [FedAvg 的 Pytorch 实现](https://zhuanlan.zhihu.com/p/259806876?utm_source=wechat_session)
> * [安全深度学习框架PySyft](https://blog.csdn.net/u011602557/article/details/103661581/)


## 1 论文阅读

### pysyft的特点

PySyft是用于安全和隐私深度学习的Python库，它在主流深度学习框架（例如PyTorch和TensorFlow）中使用联邦学习，差分隐私和加密计算（例如多方计算（MPC）和同态加密（HE））将隐私数据与模型训练分离。


1. 基于PyTorch，只支持深度学习建模，不支持LR、GBDT等传统方法？

2. 支持联邦学习、安全多方计算（实现了SPDZ协议）、差分隐私，可扩展，贡献者可接入新的FL，MPC或DP方法；

3. 训练过程介绍比较粗略，看起来只支持不同样本相同特征的联邦学习，不支持相同样本不同特征？不过既然支持安全多方计算，也许可以实现吧？

4. Virtual Workers在同一台计算机上，不通过网络通信，只是复制命令链，并暴露与实际worker完全相同的接口来彼此通信（方便用一台机器模拟联邦学习）；

5. 支持简单network sockets和Web Sockets，Web Sockets workers允许从浏览器中实例化多个worker，每个worker都在自己的标签页中（Web Sockets workers对应于上面的Virtual Workers？“从浏览器中实例化多个worker”是什么意思？）

6. 运算时间是纯PyTorch的约46～70倍；

7. 主要待解决问题：减少训练时间；确保检测并击败破坏数据或模型的恶意尝试。

### pysyft的贡献

1. 实现了worker之间通信的标准化协议。包括三种实现方式
   1. Virtual Workers都在同一台计算机上，并且不通过网络进行通信。它们只是复制命令链，并暴露与实际worker完全相同的接口，来彼此通信。
   2. network sockets
   3. Web Sockets。Web Sockets workers允许从浏览器中实例化多个worker，每个worker都在自己的标签页中。这为我们提供了在实际解决不同机器上的远程worker问题之前构建联邦学习应用的另一个级别的粒度。Web Socket workers也非常适合围绕基于浏览器的notebook的数据科学生态。
2. 开发了基于张量的-----抽象模型。（用于张量的共享）
   1. 
3. 实现了差分隐私和多方计算协议MPC。
   1. 创建MPCTensor。可以使用一系列PointerTensors来拆分和发送各个部分。我们框架中提供的MPC工具箱实现了文献3，2中的SPDZ协议。
   2. MPC工具箱不仅包含基本运算（例如加法和乘法），还包含预处理工具，用于生成例如用于乘法的三元组，还包含针对神经网络的更具体的运算，包括矩阵乘法。由于MPC的特殊性，对卷积网络的传统元素进行了一些调整：如文献2中所述，我们用average pooling代替max pooling，并近似了higher-degree sigmoid来代替relu作为激活函数。
   3. SPDZ协议假定数据是以整数形式给出的，因此我们在链中添加了一个FixedPrecisionTensor节点，该节点将浮点数转换为固定精度数字。该节点将值编码为一个整数，并存储小数点的位置。 图3总结了实现SPDZ的张量的完整结构。![](image/2021-04-28-15-48-37.png)
   4. 与文献2提出的MPC协议不同，参与者在我们的框架中并不平等，因为有一方是模型的所有者（称为本地worker）。他通过控制所有其他方（远程worker）的训练过程来充当领导者。为了减轻处理数据时的这种集中化偏差，本地worker可以在他不拥有且看不到的数据上创建远程共享张量。

## 2 fedavg算法实现过程

### fedavg算法原理

在 Fedrated Learning 中，每个客户数据都分散地在本地训练其模型，仅将学习到的模型参数发送到受信任的 Server，通过差分隐私加密和安全聚合等技术得到主模型。然后，受信任的 Server 将聚合的主模型发回给这些客户端，并重复此过程。

在这种情况下，准备了一个具有 IID（独立同分布）数据的简单实现，以演示如何将在不同节点上运行的数百个不同模型的参数与 FedAvg 方法结合使用，以及该模型是否会给出合理的结果。此实现是在 MNIST 数据集上执行的。MNIST 数据集包含数量为 0 到 9 的 28 * 28 像素灰度图像。

### 训练过程
1. 由于主模型的参数和节点中所有局部模型的参数都是随机初始化的，所有这些参数将彼此不同。因此，在对节点中的本地模型进行训练之前，主模型会将模型参数发送给节点。
2. 节点使用这些参数在其自身的数据上训练本地模型。
3. 每个节点在训练自己的模型时都会更新其参数。训练过程完成后，每个节点会将其参数发送到主模型。
4. 主模型采用这些参数的平均值并将其设置为新的权重参数，并将其传递回节点以进行下一次迭代。

## 3 Pysyft简介

### 环境简介

* pysyft==0.2.4
* pytorch==1.4.0

### 安装

```
git clone https://github.com/OpenMined/PySyft.git
cd PySyft
pip install -r pip-dep/requirements.txt
pip install -r pip-dep/requirements_udacity.txt
python setup.py install
python setup.py test

pip install scipy
pip install nbformat
pip install pandas
pip install pyOpenSSL
pip install papermill
pip install scikit-learn

pip install jupyter_latex_envs --upgrade [--user|sys-prefix]
jupyter nbextension install --py latex_envs --user
jupyter nbextension enable latex_envs --user --py
```


## 4 设计思路

提供了不同级别的联邦学习技术

1. 本地单线程仿真virtual_worker：move模型，依次训练。
2. 本地单线程仿真virtual_worker：集中数据分离，训练模型聚合。
3. 本地单线程仿真virtual_worker：分散数据，训练模型聚合。
4. 本地多线程仿真websocket_worker：多线程通信，训练模型聚合
5. 远程多线程仿真websocket_worker：多线程通信，训练模型聚合


主要的设计思想

1. 使用“张量指针”来记录对远程张量的操作。
2. 使用“worker”的send和get方法封装不同的通信过程（虚拟通信和websocket远程通信）
   1. 张量通信
   2. plan&protocol通信


主要包含以下五个模块


1. 张量指针：tensor_ptr指针模块。
2. 工作机器：worker通信原理和websocket实现（send、receive、client、server）、
3. 远程计算：远程计算的实现（plan，protocol）、
4. 加密计算：加密算法的实现（MFC同态加密）、
5. 联邦平均：联邦平均算法的实现（util.fed_avg(models))
