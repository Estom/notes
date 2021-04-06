# MATLAB的矩阵处理基础

## &gt;特殊矩阵的建立 

***

* 零矩阵
* 1矩阵
* 单位矩阵eye(10) eye(m,n)
* 随机矩阵rand(m,n)randn(m,n)正态矩阵  获的(a,b)之间的随机矩阵A = a+(a-b)rand(m,n);  
获得均值为u，方差为s的随机矩阵y = u+sqrt(s)*randn;  

> mean()求均值  
> std（）求方差  

* 魔方矩阵magic(5)行列对角线和相同
* heilbert矩阵和toeplitz矩阵  
hilb(4)希尔伯特矩阵 每一个位置的元素为1/（i+j）  
toeplitz(1:6)左上到右下的斜线元素相同

* 矩阵之间的加法和数乘；
* 矩阵的行列式det()
* 矩阵的逆inv()
* 向量的内积b的共轭转置，乘以a  
conj(b)'*a
dot(a,b)直接求两个向量的内积。

## &gt;线性方程组的求解

****
方法一：
得到系数矩阵A = [1,2,3;1,4,9;1,8,27];
常数向量b = [5,-2,6]';
x = inv(A)*b  
方法二：x =A/b

* **矩阵的相似化简和分解**
	1. A = [1,2,3;4,5,6;7,8,9]jordan(A)获得A化简的jordan标准型  
	2. [V J] = jordan(A);获得的事相似矩阵和jordan标准型。
	3. 矩阵的特征值eig（）
	4. [E D]=eig(A)获得A的特征值和特征向量

* **向量和矩阵和范数**
	1. norm(A,1)
	2. norm(A,2)
	3. norm(A,inf)
	4. norm(A,'fro')
* **矩阵的分析**  
	1. 函数矩阵（有函数构成的矩阵）
   	>syms x  
	A = [sin(x) exp(x) 1;cos(x) x^2+1 log(x)];  
	diff(A);对矩阵求导  
* **矩阵函数**
	1. funm(A,@exp)通用矩阵函数
	2. expm(A)
	3. funm(A, @sin)
	4. funm(A, @cos)