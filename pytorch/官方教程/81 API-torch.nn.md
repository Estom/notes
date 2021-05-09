# torch.nn

## 1 Containers

## 2 Convolution Layers

## 3 Pooling layers

## 4 Padding Layers

## 5 Non-linear Activations (weighted sum, nonlinearity)

## 6 Non-linear Activations (other)

## 7 Normalization Layers

## 8 Recurrent Layers

## 9 Transformer Layers

## 10 Linear Layers

## 11 Dropout Layers

## 12 Sparse Layers

## 13 Distance Functions

## 14 Loss Functions损失函数


nn.L1Loss
创建一个标准来测量输入中每个元素之间的平均绝对误差（MAE） XX 和目标 ÿÿ 。

nn.MSELoss
创建一个标准来测量输入中每个元素之间的均方误差（L2平方的平方） XX 和目标 ÿÿ 。

nn.CrossEntropyLoss
这一标准联合收割机LogSoftmax，并NLLLoss在一个单独的类。

nn.CTCLoss
连接主义者的时间分类损失。

nn.NLLLoss
负对数似然损失。

nn.PoissonNLLLoss
带有目标泊松分布的负对数似然损失。

nn.GaussianNLLLoss
高斯负对数似然损失。

nn.KLDivLoss
Kullback-Leibler散度损失测度

nn.BCELoss
创建一个衡量目标和输出之间的二进制交叉熵的标准：

nn.BCEWithLogitsLoss
这种损耗将Sigmoid层和BCELoss合并为一个类别。

nn.MarginRankingLoss
创建一个标准来衡量给定输入的损失 11x 1 ， 2倍X 2 ，两个1D迷你批量张量和一个标签1D迷你批量张量ÿÿ （包含1或-1）。

nn.HingeEmbeddingLoss
测量输入张量下的损耗 XX 和标签张量 ÿÿ （包含1或-1）。

nn.MultiLabelMarginLoss
创建一个标准，以优化输入之间的多类多分类铰链损耗（基于边距的损耗） XX （2D迷你批量张量）和输出ÿÿ （这是目标类别索引的2D张量）。

nn.SmoothL1Loss
创建一个使用平方项的条件，如果逐元素的绝对误差低于beta，则使用平方项；否则，则使用L1项。

nn.SoftMarginLoss
创建一个标准来优化输入张量之间的两类分类逻辑损失 XX 和目标张量 ÿÿ （包含1或-1）。

nn.MultiLabelSoftMarginLoss
创建一个标准，基于输入之间的最大熵优化多标签“一对所有”损失 XX 和目标 ÿÿ 大小 （N，C）（N ，C ） 。

nn.CosineEmbeddingLoss
创建一个标准来测量给定输入张量的损耗 x_1X 
1个， x_2X 2个和张量标签ÿÿ 值为1或-1。

nn.MultiMarginLoss
创建一个标准，以优化输入之间的多类分类铰链损耗（基于边距的损耗） XX （2D迷你批量张量）和输出ÿÿ （这是目标类别索引的一维张量， 0 \ leq y \ leq \ text {x.size}（1）-10≤ÿ≤尺寸（1 ）-1个 ）：


nn.TripletMarginLoss
创建一个标准来衡量给定输入张量的三重态损失 11x 1 ， 2倍X 2 ， 3倍X 3 且边距值大于 00 。

nn.TripletMarginWithDistanceLoss
创建一个标准来测量给定输入张量的三重态损失 一种一种 ， pp ， 和 ññ （分别表示锚点，正例和负例），以及用于计算锚点和正例（“正距离”）与锚点和负例之间的关系的非负实值函数（“距离函数”） （“负距离”）。
## 15 Vision Layers

## 16 Shuffle Layers

## 17 DataParallel Layers (multi-GPU, distributed)

## 18 Utilities

## 19 Quantized Functions

## 20 Lazy Modules Initialization