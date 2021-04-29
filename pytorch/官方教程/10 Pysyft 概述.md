# pysyft
> 对pytorch框架和TensorFlow框架的federated框架进行了研究。

> 参考文献
> * [A generic framework for privacy preserving deep learning](https://zhuanlan.zhihu.com/p/114774133)

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
