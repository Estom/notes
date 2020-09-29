# changshi 
import numpy as np
import matplotlib.pyplot as plt

# 定义数据集
x = np.linspace(-3,3,50)
y1 = 2*x+1
y2 = x**2


# 绘制图像
plt.figure(num=3,figsize=(10,10))
plt.plot(x,y1)
plt.plot(x,y2,color='red',linewidth=1,linestyle='--')

# 定义坐标轴的范围及名称
plt.xlim((-5,5))
plt.ylim((0,10))

plt.xlabel('i am x')
plt.ylabel('i am y')

# 刻度
ticks = np.linspace(-1,2,5)
plt.xticks(ticks)
plt.yticks([-2,-1.8,-1,1.22,3],[r'$really\ bad$', r'$bad$', r'$normal$', r'$good$', r'$really\ good$'])

# 设置边框颜色
ax = plt.gca()
ax.spines['right'].set_color('none')
ax.spines['top'].set_color('none')

# 调整刻度及边框位置
ax.xaxis.set_ticks_position('top')
ax.spines['bottom'].set_position(('data',10))
ax.yaxis.set_ticks_position('left')
ax.spines['left'].set_position(('data',0))
# 展示图像
plt.show()