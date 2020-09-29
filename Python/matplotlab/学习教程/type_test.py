import matplotlib.pyplot as plt 
import numpy as np 


# 生成数据
x = np.random.normal(0,1,1024)
y = np.random.normal(0,1,1024)
t = np.arctan2(x,y)

# 绘制散点图
plt.subplot(2,2,1)
plt.scatter(x,y,s = 75,c = t,alpha=0.5)

# 生成数据
X = np.arange(12)
Y1 = (1 - X / float(12)) * np.random.uniform(0.5, 1.0, 12)
Y2 = (1 - X / float(12)) * np.random.uniform(0.5, 1.0, 12)

# 绘制柱状图
plt.subplot(2,2,2)
plt.bar(X, +Y1, facecolor='#FFCCCC', edgecolor='white')
plt.bar(X, -Y2, facecolor='#6699CC', edgecolor='white')

# zip()函数将两个可迭代对象打包成可迭代元组。
for x, y in zip(X, Y1):
    # ha: horizontal alignment
    # va: vertical alignment
    plt.text(x, y , '%.2f' % y, ha='center', va='bottom')

for x, y in zip(X, Y2):
    # ha: horizontal alignment
    # va: vertical alignment
    plt.text(x, -y , '%.2f' % y, ha='center', va='top')

# 生成数据
def f(x,y):
    # the height function
    return (1 - x / 2 + x**5 + y**3) * np.exp(-x**2 -y**2)

n = 256
x = np.linspace(-3, 3, n)
y = np.linspace(-3, 3, n)
# meshgrid，由x，y打包成矩阵
X,Y = np.meshgrid(x, y)
# 绘制等高线地图
plt.subplot(2,2,3)
plt.contourf(X, Y, f(X, Y),10, alpha=.75, cmap=plt.cm.RdBu)
c = plt.contour(X, Y, f(X, Y), 8, colors='black', linewidth=.5)
plt.clabel(c, inline=True, fontsize=10)

# 生成数据
a = np.array([0.313660827978, 0.365348418405, 0.423733120134,
              0.365348418405, 0.439599930621, 0.525083754405,
              0.423733120134, 0.525083754405, 0.651536351379]).reshape(3,3)
plt.subplot(2,2,4)
plt.imshow(a, interpolation='nearest', cmap='RdBu', origin='lower')
plt.colorbar(shrink=.92)

# 展示
plt.show()