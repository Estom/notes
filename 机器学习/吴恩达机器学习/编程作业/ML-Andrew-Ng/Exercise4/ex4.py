import numpy as np
import matplotlib.pylab as plt
import scipy.io as sio
import math
import scipy.linalg as slin
import scipy.optimize as op

input_layer_size = 400
hidden_layer_size = 25
num_labels = 10

# =========== Part 1: Loading and Visualizing Data =============
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


print('Loading and Visualizing Data ...')
datainfo = sio.loadmat('ex4data1.mat')
X = datainfo['X']
Y = datainfo['y'][:, 0]
m = np.size(X, 0)
rand_indices = np.random.permutation(m)
sel = X[rand_indices[0:100], :]
displayData(sel)
_ = input('Press [Enter] to continue.')

# ================ Part 2: Loading Parameters ================
print('Loading Saved Neural Network Parameters ...')
thetainfo = sio.loadmat('ex4weights.mat')
theta1 = thetainfo['Theta1']
theta2 = thetainfo['Theta2']
nn_params = np.concatenate((theta1.flatten(), theta2.flatten()))


# ================ Part 3: Compute Cost (Feedforward) ================
# sigmoid函数
def sigmoid(z):
    g = 1/(1+np.exp(-1*z))
    return g

# sigmoid函数导数
def sigmoidGradient(z):
    g = sigmoid(z)*(1-sigmoid(z))
    return g

# 损失函数计算
def nnCostFunc(params, input_layer_size, hidden_layer_size, num_labels, x, y, lamb):
    theta1 = params[0:hidden_layer_size*(input_layer_size+1)].reshape((hidden_layer_size, input_layer_size+1))
    theta2 = params[(hidden_layer_size*(input_layer_size+1)):].reshape((num_labels, hidden_layer_size+1))
    m = np.size(x, 0)


    # 前向传播 --- 下标：0代表1， 9代表10
    a1 = np.concatenate((np.ones((m, 1)), x), axis=1)
    z2 = a1.dot(theta1.T); l2 = np.size(z2, 0)
    a2 = np.concatenate((np.ones((l2, 1)), sigmoid(z2)), axis=1)
    z3 = a2.dot(theta2.T)
    a3 = sigmoid(z3)
    yt = np.zeros((m, num_labels))
    yt[np.arange(m), y-1] = 1
    j = np.sum(-yt*np.log(a3)-(1-yt)*np.log(1-a3))

    # 向后传播
    delta3 = a3-yt
    delta2 = delta3.dot(theta2)*sigmoidGradient(np.concatenate((np.ones((l2, 1)), z2), axis=1))
    theta2_grad = delta3.T.dot(a2)
    theta1_grad = delta2[:, 1:].T.dot(a1)

    j = j/m
    theta2_grad = theta2_grad/m
    theta2_grad[:, 1:] = theta2_grad[:, 1:]+lamb/m*theta2[:, 1:]
    theta1_grad = theta1_grad/m
    theta1_grad[:, 1:] = theta1_grad[:, 1:]+lamb/m*theta1[:, 1:]
    reg_cost = np.sum(np.power(theta1[:, 1:], 2)) + np.sum(np.power(theta2[:, 1:], 2))
    j = j+1/(2*m)*lamb*reg_cost

    grad = np.concatenate((theta1_grad.flatten(), theta2_grad.flatten()))
    return j, grad


print('Feedforward Using Neural Network ...')
lamb = 0
j, _ = nnCostFunc(nn_params, input_layer_size, hidden_layer_size, num_labels, X, Y, lamb)
print('Cost at parameters (loaded from ex4weights): %f \n(this value should be about 0.287629)' % j)
_ = input('Press [Enter] to continue.')

# =============== Part 4: Implement Regularization ===============
print('Checking Cost Function (w/ Regularization) ...')
lamb = 1

j, _ = nnCostFunc(nn_params, input_layer_size, hidden_layer_size, num_labels, X, Y, lamb)
print('Cost at parameters (loaded from ex4weights): %f \n(this value should be about 0.383770)' % j)
_ = input('Press [Enter] to continue.')

# ================ Part 5: Sigmoid Gradient  ================
print('Evaluating sigmoid gradient...')
g = sigmoidGradient(np.array([1, -0.5, 0, 0.5, 1]))
print(g)
_ = input('Press [Enter] to continue.')

# ================ Part 6: Initializing Pameters ================
# 随机确定初始theta参数
def randInitializeWeight(lin, lout):
    epsilon_init = 0.12
    w = np.random.rand(lout, lin+1)*2*epsilon_init-epsilon_init;
    return w

print('Initializing Neural Network Parameters ...')
init_theta1 = randInitializeWeight(input_layer_size, hidden_layer_size)
init_theta2 = randInitializeWeight(hidden_layer_size, num_labels)

init_nn_params = np.concatenate((init_theta1.flatten(), init_theta2.flatten()))

# =============== Part 7: Implement Backpropagation ===============
# 调试时的参数初始化
def debugInitWeights(fout, fin):
    w = np.sin(np.arange(fout*(fin+1))+1).reshape(fout, fin+1)/10
    return w

# 数值法计算梯度
def computeNumericalGradient(J, theta, args):
    numgrad = np.zeros(np.size(theta))
    perturb = np.zeros(np.size(theta))
    epsilon = 1e-4
    for i in range(np.size(theta)):
        perturb[i] = epsilon
        loss1, _ = J(theta-perturb, *args)
        loss2, _ = J(theta+perturb, *args)
        numgrad[i] = (loss2-loss1)/(2*epsilon)
        perturb[i] = 0
    return numgrad


# 检查神经网络的梯度
def checkNNGradients(lamb):
    input_layer_size = 3
    hidden_layer_size = 5
    num_labels = 3
    m = 5

    theta1 = debugInitWeights(hidden_layer_size, input_layer_size)
    theta2 = debugInitWeights(num_labels, hidden_layer_size)

    x = debugInitWeights(m, input_layer_size-1)
    y = 1+(np.arange(m)+1) % num_labels

    nn_params = np.concatenate((theta1.flatten(), theta2.flatten()))

    cost, grad = nnCostFunc(nn_params, input_layer_size, hidden_layer_size, num_labels, x, y, lamb)
    numgrad = computeNumericalGradient(nnCostFunc, nn_params,\
                                       (input_layer_size, hidden_layer_size, num_labels, x, y, lamb))
    print(numgrad, '\n', grad)
    print('The above two columns you get should be very similar.\n \
    (Left-Your Numerical Gradient, Right-Analytical Gradient)')
    diff = slin.norm(numgrad-grad)/slin.norm(numgrad+grad)
    print('If your backpropagation implementation is correct, then \n\
         the relative difference will be small (less than 1e-9). \n\
         \nRelative Difference: ', diff)

print('Checking Backpropagation...')
checkNNGradients(0)
_ = input('Press [Enter] to continue.')

# =============== Part 8: Implement Regularization ===============
print('Checking Backpropagation (w/ Regularization) ...')

lamb = 3
checkNNGradients(lamb)

debug_j, _ =nnCostFunc(nn_params, input_layer_size, hidden_layer_size, num_labels, X, Y, lamb)
print('Cost at (fixed) debugging parameters (w/ lambda = 10): %f \n(this value should be about 0.576051)' % debug_j)
_ = input('Press [Enter] to continue.')

# =================== Part 8: Training NN ===================
# 损失函数
def nnCost(params, input_layer_size, hidden_layer_size, num_labels, x, y, lamb):
    theta1 = params[0:hidden_layer_size * (input_layer_size + 1)].reshape(hidden_layer_size, input_layer_size + 1)
    theta2 = params[hidden_layer_size * (input_layer_size + 1):].reshape(num_labels, hidden_layer_size + 1)
    m = np.size(x, 0)

    # 前向传播 --- 下标：0代表1， 9代表10
    a1 = np.concatenate((np.ones((m, 1)), x), axis=1)
    z2 = a1.dot(theta1.T);
    l2 = np.size(z2, 0)
    a2 = np.concatenate((np.ones((l2, 1)), sigmoid(z2)), axis=1)
    z3 = a2.dot(theta2.T)
    a3 = sigmoid(z3)
    yt = np.zeros((m, num_labels))
    yt[np.arange(m), y - 1] = 1
    j = np.sum(-yt * np.log(a3) - (1 - yt) * np.log(1 - a3))
    # 向后传播
    j = j / m
    reg_cost = np.sum(np.power(theta1[:, 1:], 2)) + np.sum(np.power(theta2[:, 1:], 2))
    j = j + 1 / (2 * m) * lamb * reg_cost
    return j

# 梯度函数
def nnGrad(params, input_layer_size, hidden_layer_size, num_labels, x, y, lamb):
    theta1 = params[0:hidden_layer_size * (input_layer_size + 1)].reshape(hidden_layer_size, input_layer_size + 1)
    theta2 = params[(hidden_layer_size * (input_layer_size + 1)):].reshape(num_labels, hidden_layer_size + 1)
    m = np.size(x, 0)
    # 前向传播 --- 下标：0代表1， 9代表10
    a1 = np.concatenate((np.ones((m, 1)), x), axis=1)
    z2 = a1.dot(theta1.T);
    l2 = np.size(z2, 0)
    a2 = np.concatenate((np.ones((l2, 1)), sigmoid(z2)), axis=1)
    z3 = a2.dot(theta2.T)
    a3 = sigmoid(z3)
    yt = np.zeros((m, num_labels))
    yt[np.arange(m), y - 1] = 1
    # 向后传播
    delta3 = a3 - yt
    delta2 = delta3.dot(theta2) * sigmoidGradient(np.concatenate((np.ones((l2, 1)), z2), axis=1))
    theta2_grad = delta3.T.dot(a2)
    theta1_grad = delta2[:, 1:].T.dot(a1)

    theta2_grad = theta2_grad / m
    theta2_grad[:, 1:] = theta2_grad[:, 1:] + lamb / m * theta2[:, 1:]
    theta1_grad = theta1_grad / m
    theta1_grad[:, 1:] = theta1_grad[:, 1:] + lamb / m * theta1[:, 1:]

    grad = np.concatenate((theta1_grad.flatten(), theta2_grad.flatten()))
    return grad

print('Training Neural Network...')
lamb = 1
param = op.fmin_cg(nnCost, init_nn_params, fprime=nnGrad, \
                    args=(input_layer_size, hidden_layer_size, num_labels, X, Y, lamb), maxiter=50)

theta1 = param[0: hidden_layer_size*(input_layer_size+1)].reshape(hidden_layer_size, input_layer_size+1)
theta2 = param[hidden_layer_size*(input_layer_size+1):].reshape(num_labels, hidden_layer_size+1)
_ = input('Press [Enter] to continue.')

# ================= Part 9: Visualize Weights =================
print('Visualizing Neural Network...')
displayData(theta1[:, 1:])
_ = input('Press [Enter] to continue.')

# ================= Part 10: Implement Predict =================
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

