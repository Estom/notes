# Minimax估计和Bayes估计

## 1 一致占优
### 定义1：损失定义
损失，是一种距离。
$$
L(\theta,T(x))=(T(x)-\theta)^2
$$

> 损失函数，这只是鬼畜了风险函数的一种
### 定义2：风险函数
风险，平均损失
$$
R(\theta,T)=E_XL(\theta,T(x))=E_X(T(x)-\theta)^2
$$

> 均方误差是损失函数的期望，也是一种风险

### 定义3：一致占优

$$
R(\theta,T_1)\leq R(\theta,T_2),\forall \theta
$$

## 2 Minimax估计
### 定义1：Minimax
$$
\sup_\theta R(\theta,T_1)\leq \sup_\theta(\theta,T_2)
$$
先找到最大风险，再找到最大风险最小的策略

## 3 定义2：Bayes估计
> 把参数\theta当成随机变量处理
### 

$$
E_\theta(R(\theta,T_1))\leq E_\theta(R(\theta,T_2))
$$

$E_theta$与$E_X$不同，在bayes理论中，条件期望
$$

E_X(L(\theta,T(X)))=\sum L(theta,T(X))p(x|\theta)dx
$$

### 先验概率 后验概率
h(\theta|x)=p(x|\theta)\pi(\theta)

* 假设
$$
L(\theta,T(X))=(T(X)-q(\theta))
$$
* 结论


$$

$$