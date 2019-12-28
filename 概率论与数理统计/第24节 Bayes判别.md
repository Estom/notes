# Bayes判别

## 1 错判风险ECM最小准则

### 定义：Bayes判别规则

* 条件
$$
m个正太总体G_1,\cdots,G_m;\\
密度函数f_1(x),\cdots,f_m(x)\\
m个个体各自发生的先验概率q_1,\cdots,q_m\\
错判损失C(j|i),错判矩阵C(R)\\
错判概率P(j|i,R)=\int_{R_j}f_i(x)d(x)\\
总平均错判损失:ECM(R)=\sum_{i=1}^mq_i\sum_{j=1}^mC(j|i)P(j|i,R)
$$
* 结论
$$
ECM(R^*)=min_R\{EMC(R)\}
$$
错判损失最小的划分方法称为bayes判别。

## 2 两个总体的bayes判别

### 定理1：损失最小判别

* 声明
$$
总体G_1,G_2\\
密度函数f_1(x),f_2(x)\\
先验概率q_1,q_2\\
错判损失C(2|1)和C(1|2)
$$
* 结论

使得EMC(R)达到最小的判别区域$R^*=(R_1^*,R_2^*)$
$$
R_1^*={x:q_1C(2|1)f_1(x)\geq q_2C(1|2)f_2(x)}\\
R_2^*={x:q_1C(2|1)f_1(x)< q_2C(1|2)f_2(x)}
$$

### 定理2：正太总体

* 条件
$$
G_1,G_2分别服从正太分布N_p(\mu_1,\Sigma_1)和N_p(\mu_2,\Sigma_2)
$$
* 结论
$$
R_1^*=\{x:g(x)\geq \ln \frac{|\Sigma|}{\Sigma_2}+2\ln d\}\\
g(x)=d^2(x,G_2)-d^2(x,G_1)\\
d^2(x,G_i)=(x-\mu_i)'\Sigma_i^{-1}(x-\mu_i)
$$


### 定理3：正太总体

* 条件
$$
G_1,G_2分别服从正太分布N_p(\mu_1,\Sigma_1)和N_p(\mu_2,\Sigma_2)
$$
* 结论
$$
R_1^*=\{x:\varphi(x)\geq \ln d\}\\
\varphi(x)=a'(x-\overline{\mu})\\
a'=\Sigma^{-1}(\mu_1-\mu_2),\overline{\mu}=\frac{\mu_1+\mu_2}{2}
$$
## 3 多个总体的bayes判别

### 定理1：Bayes判别
* 条件
$$
m个总体G_1,\cdots,G_m\\
密度函数f_1(x),\cdots,f_m(x)\\
先验概率q_1,\cdots,q_m\\
错误损失C(j|i)
$$
* 结论
$$
取平均损失最小l时G_l为目标类R_l^*=\{x:h_l(x)=\min_{1\leq j\leq m}h_j(x)\}\\
将样本x归为G_j的平均损失h_j(x)=\sum_{i=1}^mq_iC(j|i)f_i(x)\\
$$

> 对于给定的样品x，计算将样品x归为G_j的平均损失$h_j(x)$，比较h_j(x)的大小。若h_l(x)最小，则判断$x\in G_l$。显然这是最直观的解释。对

### 定理2：Bayes判别-损失相同
* 条件加强
$$
m个总体G_1,\cdots,G_m\\
密度函数f_1(x),\cdots,f_m(x)\\
先验概率q_1,\cdots,q_m\\
错判损失都相同C(j|i)=1,C(i|i)=0
$$
* 结论
$$
R_l^*=\{x:q_lf_l(x)=\max_{1\leq j\leq m}q_jf_j(x)\}
$$

### 定理3：Bayes判别-正太总体

* 条件加强
$$
m个\underline{正太}总体G_1,\cdots,G_m\sim N_p(\mu_i,\Sigma_i)\\
密度函数f_1(x),\cdots,f_m(x)\\
先验概率q_1,\cdots,q_m\\
错判损失都相同C(j|i)=1,C(i|i)=0
$$
* 结论
$$
R_l^*=\{x:g_l(x)=\min_{1\leq j\leq m}g_j(x)\}\\
g_j(x)=(x-\mu_j)'\Sigma_j^{-1}(x-\mu_j)-2\ln q_j+\ln |\Sigma_j|
$$

### 定理4：Bayes判别-协方差矩阵相同正太总体
* 条件加强
$$
m个\underline{协方差相同正太}总体G_1,\cdots,G_m\sim N_p(\mu_i,\Sigma)\\
密度函数f_1(x),\cdots,f_m(x)\\
先验概率q_1,\cdots,q_m\\
错判损失都相同C(j|i)=1,C(i|i)=0
$$
* 结论
$$
R_l^*=\{x:\varphi(x)=\max_{1\leq j\leq m}\varphi_j(x)\}\\
\varphi_j(x)=\mu_j'\Sigma^{-1}x-\frac{1}{2}\mu'_j\Sigma^{-1}\mu_j+\ln q_j
$$




