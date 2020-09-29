import numpy as np
import matplotlib.pyplot as plt

x = np.linspace(-3,3,50)
y1 = 2*x+1
y2 = x**2

plt.figure()

# 坐标轴范围
plt.xlim((-4,5))
plt.ylim((-2,10))

# 坐标
ticks = np.linspace(-1,2,5)
plt.xticks(ticks)

plt.yticks([-2, -1.8, -1, 1.22, 3],[r'$really\ bad$', r'$bad$', r'$normal$', r'$good$', r'$really\ good$'])

# 线条
plt.plot(x,y1,label='linear line')
plt.plot(x,y2,label='quick line',color='red',linewidth=1,linestyle='--')

# 图例
plt.legend(loc='upper right')

# 设置x轴位置
ax = plt.gca()
ax.spines['bottom'].set_position(('data', 0))

# 标注

x0 = 1
y0 = 2*x0 + 1
plt.plot([x0, x0,], [0, y0,], 'k--', linewidth=2.5)
plt.scatter([x0, ], [y0, ], s=50, color='b')


# 注释annotate
plt.annotate(r'$2x+1=%s$' % y0, xy=(x0, y0), xycoords='data', xytext=(+30, -30),textcoords='offset points', fontsize=16,arrowprops=dict(arrowstyle='->', connectionstyle="arc3,rad=.2"))

# 注释 text
plt.text(-3.7, 3, r'$This\ is\ the\ some\ text. \mu\ \sigma_i\ \alpha_t$',fontdict={'size': 16, 'color': 'r'})
# 展示
plt.show()
