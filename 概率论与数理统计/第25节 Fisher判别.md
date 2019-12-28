# Fisher判别

## 1 原理
### 概念

Fisher 利用投影，将n为的向量特征投射到一维或者其他几个维度。借助方差分析的思想导出判别函数。

### 定义：Fisher投影

* 条件
$$
m个正太总体G_1,\cdots,G_m\\
均值\mu_1,\cdots,\mu_m\\
协方差阵\Sigma_1,\cdots,\Sigma_m\\
$$
* 结论
$$
线性变换y=a'x\\
m个1维总体G_1^*,\cdots,G_m^*\\
均值a'\mu_1,\cdots,a'\mu_m\\
协方差阵a'\Sigma_1a,\cdots,a'\Sigma_ma\\
$$

### 定义：方差分析

* 条件

$$
组间方差，各个向量之间的方差B_0=\sum_{i=1}^m(a'\mu_i-a'\overline{\mu})^2=a'Ba\\
组内方差，向量各维度间的方差E_0=\sum_{i=1}^ma'\Sigma_ia=a'Ea\\
\overline{\mu}=\frac{1}{m}\sum_{i=1}^m\mu_i\\
B=\sum_{i=1}^m(\mu_i-\overline{\mu})(\mu_i-\overline{\mu})'\\
E=\sum_{i=1}^m\Sigma_i
$$
* 结论
$$
\varphi(a)=\frac{B_0}{E_0}=\frac{a'Ba}{a'Ea}
$$
这个值越大，表示组间方差越大，表示通过a的投影，区分度越高。取$a'Ea=1的情况下，求a使得\varphi(a)=a'Ba$取最大值。

### 定理：Lagrange乘数法
* 条件
$$
矩阵E是正定的\\
\lambda是E^{-1}B最大特征值，所对应的特征向量a
$$
* 结论

$$
a'Ea=1\\
\max_{a'Ea=1}a'Ba=\lambda\\
$$

### 定义：Fisher判别优化
可以将多维向量投射到多维当中，依次选择$E^{-1}B$特征值最大的特征向量$a_i$作为投影向量。最终压缩为r维指标进行判别。
$$
y_i=a'_ix
$$
## 2 例题