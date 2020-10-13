import numpy as np
import matplotlib.pylab as plt
import scipy.io as sio
import math

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

input_layer_size = 400
hidden_layer_size = 25
num_labels = 10

# =========== Part 1: Loading and Visualizing Data =============
# LoadData
print('Loading and Visualizing Data ...')
datainfo = sio.loadmat('ex3data1.mat')
X = datainfo['X']
Y = datainfo['y'][:, 0]
m = np.size(X, 0)

rand_indices = np.random.permutation(m)
sel = X[rand_indices[0:100], :]
displayData(sel)
_ = input('Press [Enter] to continue.')

# ================ Part 2: Loading Pameters ================
print('Loading Saved Neural Network Parameters ...')
weightinfo = sio.loadmat('ex3weights.mat')
theta1 = weightinfo['Theta1']
theta2 = weightinfo['Theta2']

# ================= Part 3: Implement Predict =================
# sigmoid函数
def sigmoid(z):
    g = 1/(1+np.exp(-1*z))
    return g

# 预测函数
def predict(t1, t2, x):
    m = np.size(x, 0)
    x = np.concatenate((np.ones((m, 1)), x), axis=1)
    temp1 = sigmoid(x.dot(theta1.T))
    temp = np.concatenate((np.ones((m, 1)), temp1), axis=1)
    temp2 = sigmoid(temp.dot(theta2.T))
    p = np.argmax(temp2, axis=1)+1
    return p


pred = predict(theta1, theta2, X)
print('Training Set Accuracy: ', np.sum(pred == Y)/np.size(Y, 0))
_ = input('Press [Enter] to continue.')

# 随机展示图像
num = 10
rindex = np.random.permutation(m)
for i in range(num):
    print('Displaying Example Image')
    displayData(X[rindex[i]:rindex[i]+1, :])

    pred = predict(theta1, theta2, X[rindex[i]:rindex[i]+1, :])
    print('Neural Network Prediction: %d (digit %d)' % (pred, pred % 10))
    _ = input('Press [Enter] to continue.')




