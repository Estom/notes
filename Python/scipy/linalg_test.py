from scipy import linalg
import numpy as np

#Declaring the numpy arrays
a = np.array([[3, 2, 0], [1, -1, 0], [0, 5, 1]])
b = np.array([2, 4, -1])

# 求矩阵的行列式
print(np.linalg.det(a))
print(linalg.det(a))

# 求矩阵的特征值和特征向量

print('eig:')
print(np.linalg.eig(a))
print(linalg.eig(a))

# 奇异值分解svd
print('svd:')
m = np.array([[3,2,4],[1,3,2]])
print(np.linalg.svd(a))
print(linalg.svd(a))

# 利用矩阵的逆求解方程组
a_ = np.linalg.inv(a)
x = np.matmul(a_,b)
print(x)

# 使用numpy的线性代数部分求解矩阵的逆
x = np.linalg.solve(a,b)
print(x)

#Passing the values to the solve function
x = linalg.solve(a, b)

#printing the result array
print(x)