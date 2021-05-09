# API torch

## 1 张量

> 张量判断

## 2 张量创建


tensor
用构造一个张量data。

from_numpy
Tensor从创建一个numpy.ndarray。

zeros
返回一个由标量值0填充的张量，其形状由变量参数定义size。

zeros_like
返回一个填充有标量值0的张量，其大小与相同input。

ones
返回一个由标量值1填充的张量，其形状由变量参数定义size。

ones_like
返回用标量值1填充的张量，其大小与相同input。

arange
返回大小的一维张量

range
返回大小的一维张量

linspace
创建大小为一维的张量，steps其值从start到end，包括两端均等间隔。

logspace
创建尺寸的一维张量

eye
返回一个二维张量，对角线上有一个，其他位置为零。

empty
返回填充有未初始化数据的张量。

empty_like
返回与相同大小的未初始化张量input。

empty_strided
返回填充有未初始化数据的张量。

full
创建一个size用填充的大小的张量fill_value。

full_like
返回与input填充大小相同的张量fill_value。


## 3 张量拼接

cat
在给seq定维度上连接给定张量序列。

stack
沿着新维度连接一系列张量。

row_stack
的别名torch.vstack()。

column_stack
通过在中水平堆叠张量来创建新的张量tensors。

dstack
沿深度方向（沿第三轴）按顺序堆叠张量。


hstack
按水平顺序（列方向）堆叠张量。


vstack
垂直（行方向）按顺序堆叠张量。


reshape
返回具有与相同的数据和元素数量input但具有指定形状的张量。


tile

通过重复元素构造张量input。

transpose
返回一个张量，该张量是的转置版本input。

unsqueeze
返回在指定位置插入的尺寸为1的新张量。


## 4 张量随机

bernoulli
从伯努利分布中提取二进制随机数（0或1）。

multinomial
返回一个张量，其中每一行都包含num_samples从位于张量对应行中的多项式概率分布中采样的索引input。

normal
返回从单独的正态分布中得出均值和标准差的随机数张量。

poisson
返回input与从Poisson分布中采样的每个元素具有相同大小的张量，其中速率参数由相应元素中的给定，input即

rand
返回一个张量，该张量由区间上的均匀分布的随机数填充 [0，1）[ 0 ，1 ）

rand_like
返回一个张量，其大小input与间隔上的均匀分布的随机数填充的张量相同[0，1）[ 0 ，1 ） 。

randint
返回一个张量，该张量填充在low（含）和high（不含）之间均匀生成的随机整数。

randint_like
返回具有与Tensor相同形状的张量，其中input填充了在low（包含）和high（包含）之间统一生成的随机整数。

randn
从平均值为0且方差为1的正态分布（也称为标准正态分布）中返回一个填充有随机数的张量。

randn_like
返回一个张量，其大小input与正态分布中均值为0和方差为1的随机数填充的张量相同。

## 5 序列化

save
将对象保存到磁盘文件。

load
加载torch.save()从文件中保存的对象。

## 6 局部梯度计算

上下文管理器torch.no_grad()，torch.enable_grad()和 torch.set_grad_enabled()有助于局部禁用和启用梯度计算。有关其用法的更多详细信息，请参见本地禁用梯度计算。这些上下文管理器是线程本地的，因此如果您使用threading模块等将工作发送到另一个线程，它们将无法工作。

no_grad
禁用梯度计算的上下文管理器。

enable_grad
启用梯度计算的上下文管理器。

set_grad_enabled
将渐变计算设置为开或关的上下文管理器。

## 7.1 数学运算——逐点操作

三角函数

指数函数

幂函数

对数函数

## 7.2 数学运算——统计操作

argmax
返回input张量中所有元素的最大值的索引。

argmin
返回展平张量或沿着维度的最小值的索引

amax
返回input给定维度中张量的每个切片的最大值dim。

amin
返回input给定维度上张量的每个切片的最小值dim。

all
测试中的所有元素的input评估结果是否为True。

any
测试中的存在元素的input评估结果是否为True。

max
返回input张量中所有元素的最大值。

min
返回input张量中所有元素的最小值。

mean
返回input张量中所有元素的平均值。

median
返回中的值的中位数input。

norm
返回给定张量的矩阵范数或向量范数。

prod
返回input张量中所有元素的乘积。

std
返回input张量中所有元素的标准偏差。

sum
返回input张量中所有元素的总和。

var
返回input张量中所有元素的方差。

var_mean
返回input张量中所有元素的方差和均值。

## 7.3 数学运算——比较操作

eq
计算按元素相等

equal
True如果两个张量具有相同的大小和元素，False否则。

ge
计算 \ text {input} \ geq \ text {other}输入≥其他 在元素方面。

greater_equal
的别名torch.ge()。

gt
计算 \ text {input}> \ text {other}输入>其他 在元素方面。

greater
的别名torch.gt()。

le
计算 \ text {input} \ leq \ text {other}输入≤其他 在元素方面。

less_equal
的别名torch.le()。

lt
计算 \ text {input} <\ text {other}输入<其他 在元素方面。

less
的别名torch.lt()。

ne
计算 \ text {input} \ neq \ text {other}输入=其他 在元素方面。

not_equal
的别名torch.ne()。

sort
input沿给定维度按值升序对张量的元素进行排序。

msort
input沿张量的第一个维度按值升序对元素进行排序。


## 7.4 数学运算——光谱操作

傅里叶变换


## 8 其他操作

broadcast_to
广播input到形状shape。

broadcast_shapes
与broadcast_tensors()形状相似。

clone
返回的副本input。