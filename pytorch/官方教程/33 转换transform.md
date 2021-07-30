# transform对数据集进行转换

## 1 torchvision数据集才有的转换


所有 TorchVision 数据集都有两个参数 -transform修改特征和 target_transform修改标签 - 接受包含转换逻辑的可调用对象。该torchvision.transforms模块提供几种常用的变换开箱

```py
import torch
from torchvision import datasets
from torchvision.transforms import ToTensor, Lambda

ds = datasets.FashionMNIST(
    root="data",
    train=True,
    download=True,
    transform=ToTensor(),
    target_transform=Lambda(lambda y: torch.zeros(10, dtype=torch.float).scatter_(0, torch.tensor(y), value=1))
)
```


### ToTensor()
ToTensor 将 PIL 图像或 NumPyndarray转换为FloatTensor. 并在 [0., 1.] 范围内缩放图像的像素强度值

### Lambda 变换
Lambda 转换适用于任何用户定义的 lambda 函数。在这里，我们定义了一个函数来将整数转换为单热编码的张量。它首先创建一个大小为 10（我们数据集中的标签数量）的零张量，并调用 scatter_，它value=1在标签给定的索引上分配 a y。
```py
target_transform = Lambda(lambda y: torch.zeros(
    10, dtype=torch.float).scatter_(dim=0, index=torch.tensor(y), value=1))
```