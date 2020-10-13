import numpy as np
import matplotlib.pylab as plt
import scipy.io as sio
import math
import scipy.optimize as op

input_layer_size = 400
num_labels = 10
# =========== Part 1: Loading and Visualizing Data =============
print('Loading and Visualizing Data ...')

matinfo = sio.loadmat('ex3data1.mat')
X = matinfo['X']
Y = matinfo['y'][:, 0]
m = np.size(X, 0)

rand_indices = np.random.permutation(m)
sel = X[rand_indices[0:100], :]

# 显示随机100个图像, 疑问：最后的数组需要转置才会显示正的图像
def displayData(x):
    width = round(math.sqrt(np.size(x, 1)))
    m, n = np.shape(x)
    height = int(n/width)
    # 显示图像的数量
    drows = math.floor(math.sqrt(m))
    dcols = math.ceil(m/drows)

    pad = 1
    # 建立一个空白“背景布”
    darray = -1*np.ones((pad+drows*(height+pad), pad+dcols*(width+pad)))

    curr_ex = 0
    for j in range(drows):
        for i in range(dcols):
            if curr_ex >= m:
                break
            max_val = np.max(np.abs(X[curr_ex, :]))
            darray[pad+j*(height+pad):pad+j*(height+pad)+height, pad+i*(width+pad):pad+i*(width+pad)+width]\
                = x[curr_ex, :].reshape((height, width))/max_val
            curr_ex += 1
        if curr_ex >= m:
            break

    plt.imshow(darray.T, cmap='gray')
    plt.show()


displayData(sel)
_ = input('Press [Enter] to continue.')

# ============ Part 2: Vectorize Logistic Regression ============
print('Training One-vs-All Logistic Regression...')

# sigmoid函数
def sigmoid(z):
    g = 1/(1+np.exp(-1*z))
    return g

# 损失函数
def lrCostFunc(theta, x, y, lam):
    m = np.size(y, 0)
    h = sigmoid(x.dot(theta))
    j = -1/m*(y.dot(np.log(h))+(1-y).dot(np.log(1-h)))+lamb*(theta[1:].dot(theta[1:]))/(2*m)
    return j

# 梯度函数
def lrGradFunc(theta, x, y, lam):
    m = np.size(y, 0)
    h = sigmoid(x.dot(theta))
    grad = np.zeros(np.size(theta))
    grad[0] = 1 / m * (x[:, 0].dot(h-y))
    grad[1:] = 1/m*(x[:, 1:].T.dot(h-y))+lam/m*theta[1:]
    return grad

# 获取多个分类器的theta值
def oneVsAll(x, y, num_labels, lam):
    m, n = np.shape(x)
    all_theta = np.zeros((num_labels, n+1))

    x = np.concatenate((np.ones((m, 1)), x), axis=1)
    for i in range(num_labels):
        num = 10 if i == 0 else i
        init_theta = np.zeros((n+1,))
        result = op.minimize(lrCostFunc, init_theta, method='BFGS'\
                 ,jac=lrGradFunc, args=(x, 1*(y == num), lam), options={'maxiter': 50})
        all_theta[i, :] = result.x
    return all_theta

lamb = 0.1
all_theta = oneVsAll(X, Y, num_labels, lamb)
_ = input('Press [Enter] to continue.')

# ================ Part 3: Predict for One-Vs-All ================
# 预测值函数
def predictOneVsAll(all_theta, x):
    m = np.size(x, 0)
    x = np.concatenate((np.ones((m, 1)), x), axis=1)
    p = np.argmax(x.dot(all_theta.T), axis=1)
    return p

pred = predictOneVsAll(all_theta, X)
print('Training Set Accuracy: ', np.sum(pred == (Y % 10))/np.size(Y, 0))