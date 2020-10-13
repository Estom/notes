import numpy as np
import matplotlib.pylab as plt
import scipy.optimize as op

# Load Data
data = np.loadtxt('ex2data1.txt', delimiter=',')
X = data[:, 0:2]
Y = data[:, 2]

# ==================== Part 1: Plotting ====================
print('Plotting data with + indicating (y = 1) examples and o indicating (y = 0) examples.')

# 绘制散点图像
def plotData(x, y):
    pos = np.where(y == 1)
    neg = np.where(y == 0)
    p1 = plt.scatter(x[pos, 0], x[pos, 1], marker='+', s=30, color='b')
    p2 = plt.scatter(x[neg, 0], x[neg, 1], marker='o', s=30, color='y')
    plt.legend((p1, p2), ('Admitted', 'Not admitted'), loc='upper right', fontsize=8)
    plt.xlabel('Exam 1 score')
    plt.ylabel('Exam 2 score')
    plt.show()

plotData(X, Y)
_ = input('Press [Enter] to continue.')

# ============ Part 2: Compute Cost and Gradient ============
m, n = np.shape(X)
X = np.concatenate((np.ones((m, 1)), X), axis=1)
init_theta = np.zeros((n+1,))

# sigmoid函数
def sigmoid(z):
    g = 1/(1+np.exp(-1*z))
    return g

# 计算损失函数和梯度函数
def costFunction(theta, x, y):
    m = np.size(y, 0)
    h = sigmoid(x.dot(theta))
    if np.sum(1-h < 1e-10) != 0:
        return np.inf
    j = -1/m*(y.dot(np.log(h))+(1-y).dot(np.log(1-h)))
    return j

def gradFunction(theta, x, y):
    m = np.size(y, 0)
    grad = 1 / m * (x.T.dot(sigmoid(x.dot(theta)) - y))
    return grad

cost = costFunction(init_theta, X, Y)
grad = gradFunction(init_theta, X, Y)
print('Cost at initial theta (zeros): ', cost)
print('Gradient at initial theta (zeros): ', grad)
_ = input('Press [Enter] to continue.')

# ============= Part 3: Optimizing using fmin_bfgs  =============
# 注：此处与原始的情况有些出入
result = op.minimize(costFunction, x0=init_theta, method='BFGS', jac=gradFunction, args=(X, Y))
theta = result.x
print('Cost at theta found by fmin_bfgs: ', result.fun)
print('theta: ', theta)

# 绘制图像
def plotDecisionBoundary(theta, x, y):
    pos = np.where(y == 1)
    neg = np.where(y == 0)
    p1 = plt.scatter(x[pos, 1], x[pos, 2], marker='+', s=60, color='r')
    p2 = plt.scatter(x[neg, 1], x[neg, 2], marker='o', s=60, color='y')
    plot_x = np.array([np.min(x[:, 1])-2, np.max(x[:, 1]+2)])
    plot_y = -1/theta[2]*(theta[1]*plot_x+theta[0])
    plt.plot(plot_x, plot_y)
    plt.legend((p1, p2), ('Admitted', 'Not admitted'), loc='upper right', fontsize=8)
    plt.xlabel('Exam 1 score')
    plt.ylabel('Exam 2 score')
    plt.show()

plotDecisionBoundary(theta, X, Y)
_ = input('Press [Enter] to continue.')

# ============== Part 4: Predict and Accuracies ==============
prob = sigmoid(np.array([1, 45, 85]).dot(theta))
print('For a student with scores 45 and 85, we predict an admission probability of: ', prob)

# 预测给定值
def predict(theta, x):
    m = np.size(X, 0)
    p = np.zeros((m,))
    pos = np.where(x.dot(theta) >= 0)
    neg = np.where(x.dot(theta) < 0)
    p[pos] = 1
    p[neg] = 0
    return p
p = predict(theta, X)
print('Train Accuracy: ', np.sum(p == Y)/np.size(Y, 0))
_ = input('Press [Enter] to continue.')


p=predict(theta, X)
