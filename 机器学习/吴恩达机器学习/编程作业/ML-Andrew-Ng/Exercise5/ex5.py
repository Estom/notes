import numpy as np
import scipy.io as sio
import matplotlib.pylab as plt
import scipy.optimize as op
from numpy import linalg as la

# =========== Part 1: Loading and Visualizing Data =============
print('Loading and Visualizing Data ...')
datainfo = sio.loadmat('ex5data1.mat')
X = datainfo['X'][:, 0]
Y = datainfo['y'][:, 0]
Xtest = datainfo['Xtest'][:, 0]
Ytest = datainfo['ytest'][:, 0]
Xval = datainfo['Xval'][:, 0]
Yval = datainfo['yval'][:, 0]

m = np.size(X, 0)
plt.plot(X, Y, 'rx', ms=10, mew=1.5)
plt.xlabel('Change in water level (x)')
plt.ylabel('Water flowing out of the dam (y)')
plt.show()
_ = input('Press [Enter] to continue.')

# =========== Part 2 & 3: Regularized Linear Regression Cost and Gradient=============
# 线性回归损失函数
def linRegCostFunc(theta, x, y, lamb):
    m = np.size(y, 0)
    j = 1/(2*m)*(x.dot(theta)-y).T.dot(x.dot(theta)-y)+lamb/(2*m)*(theta[1:].dot(theta[1:]))
    return j

# 线性回归梯度函数
def linRegGradFunc(theta, x, y, lamb):
    m = np.size(y, 0)
    grad = np.zeros(np.shape(theta))
    grad[0] = 1/m*(x.dot(theta)-y).dot(x[:, 0])
    grad[1:] = 1/m*(x[:, 1:]).T.dot(x.dot(theta)-y)+lamb/m*theta[1:]
    return grad

theta = np.array([1.0, 1.0])
j = linRegCostFunc(theta, np.vstack((np.ones((m,)), X)).T, Y, 1)
grad = linRegGradFunc(theta, np.vstack((np.ones((m,)), X)).T, Y, 1)
print('Cost at theta = [1 ; 1]: %f \
      \n(this value should be about 303.993192)' % j)
print('Gradient at theta = [1 ; 1]:  [%f; %f] \
\n(this value should be about [-15.303016; 598.250744])' % (grad[0], grad[1]))

# =========== Part 4: Train Linear Regression =============
# 训练线性回归
def trainLinReg(x, y, lamb):
    init_theta = np.zeros((np.size(x, 1),))
    theta = op.fmin_cg(linRegCostFunc, init_theta, fprime=linRegGradFunc, maxiter=200, args=(x, y, lamb))
    return theta

lamb = 0
theta = trainLinReg(np.vstack((np.ones((m,)), X)).T, Y, lamb)
# 绘制图像
plt.plot(X, Y, 'rx', ms=10, mew=1.5)
plt.plot(X, np.vstack((np.ones((m,)), X)).T.dot(theta), '--', lw=2)
plt.xlabel('Change in water level (x)')
plt.ylabel('Water flowing out of the dam (y)')
plt.show()

_ = input('Press [Enter] to continue.')

# =========== Part 5: Learning Curve for Linear Regression =============
# 学习曲线
def learningCurve(x, y, xval, yval, lamb):
    m = np.size(x, 0)
    err_train = np.zeros((m,))
    err_val = np.zeros((m,))
    for i in range(m):
        theta = trainLinReg(x[0:i+1, :], y[0:i+1], lamb)
        err_train[i] = linRegCostFunc(theta, x[0:i+1, :], y[0:i+1], 0)
        err_val[i] = linRegCostFunc(theta, xval, yval, 0)
    return err_train, err_val

mval = np.size(Xval, 0)
err_train, err_val = learningCurve(np.vstack((np.ones((m,)), X)).T, Y \
                      ,np.vstack((np.ones((mval,)), Xval)).T, Yval, lamb)
# 绘制图像
plt.plot(np.arange(m)+1, err_train, 'b-', label='Train')
plt.plot(np.arange(m)+1, err_val, 'r-', label='Cross Validation')
plt.axis([0, 13, 0, 150])
plt.legend(loc='upper right')
plt.title('Learning curve for linear regression')
plt.xlabel('Number of training examples')
plt.ylabel('Error')
plt.show()

print('Training Examples  Train Error  Cross Validation Error')
for i in range(m):
    print('\t%d\t\t\t\t%f\t\t\t%f' % (i+1, err_train[i], err_val[i]))

_ = input('Press [Enter] to continue.')

# =========== Part 6: Feature Mapping for Polynomial Regression =============
# 多项式映射
def polyFeature(x, p):
    m = np.size(x, 0)
    x_poly = np.zeros((m, p))
    for i in range(p):
        x_poly[:, i] = np.power(x, i+1)
    return x_poly

# 归一化处理
def featureNormalize(x):
    mu = np.mean(x, 0)
    sigma = np.std(x, 0, ddof=1)
    x_norm = (x-mu)/sigma
    return x_norm, mu, sigma

p = 8
X_p = polyFeature(X, p)
X_p, mu, sigma = featureNormalize(X_p)
X_poly = np.concatenate((np.ones((m, 1)), X_p), axis=1)

ltest= np.size(Xtest, 0)
X_p_test = polyFeature(Xtest, p)
X_p_test = (X_p_test-mu)/sigma
X_poly_test = np.concatenate((np.ones((ltest, 1)), X_p_test), axis=1)

lval = np.size(Xval, 0)
X_v_test = polyFeature(Xval, p)
X_v_test = (X_v_test-mu)/sigma
X_poly_val = np.concatenate((np.ones((lval, 1)), X_v_test), axis=1)

print('Normalized Training Example 1: \n', X_poly[0, :])
_ = input('Press [Enter] to continue.')

# =========== Part 7: Learning Curve for Polynomial Regression =============
# 曲线拟合
def plotFit(min_x, max_x, mu, sigma, p):
    x = np.arange(min_x-15, max_x+25, 0.05)
    x_p = polyFeature(x, p)
    x_p = (x_p-mu)/sigma
    l = np.size(x_p, 0)
    x_poly = np.concatenate((np.ones((l, 1)), x_p), axis=1)
    return x, x_poly.dot(theta)

lamb = 0
theta = trainLinReg(X_poly, Y, lamb)

x_simu, y_simu = plotFit(np.min(X), np.max(X), mu, sigma, p)
fig1 = plt.figure(1)
ax = fig1.add_subplot(111)
ax.plot(X, Y, 'rx', ms=10, mew=1.5)
ax.plot(x_simu, y_simu, '--', lw=2)
ax.set_xlabel('Change in water level (x)')
ax.set_ylabel('Water flowing out of the dam (y)')
fig1.suptitle('Polynomial Regression Fit (lambda = 0)')

err_train, err_val = learningCurve(X_poly, Y, X_poly_val, Yval, lamb)
fig2 = plt.figure(2)
ax2 = fig2.add_subplot(111)
ax2.plot(np.arange(m)+1, err_train, 'b', label='Train')
ax2.plot(np.arange(m)+1, err_val, 'r', label='Cross Validation')
ax2.set_xlabel('Number of training examples')
ax2.set_ylabel('Error')
handles2, labels2 = ax2.get_legend_handles_labels()
ax2.legend(handles2, labels2)
ax2.set_xlim([0, 13])
ax2.set_ylim([0, 100])
fig2.suptitle('PPolynomial Regression Learning Curve (lambda = 0)')
plt.show()
print('Polynomial Regression (lambda = 0)')
print('Training Examples\tTrain Error\tCross Validation Error')
for i in range(m):
    print('  \t%d\t\t%f\t%f' % (i+1, err_train[i], err_val[i]))

_ = input('Press [Enter] to continue.')

# =========== Part 8: Validation for Selecting Lambda =============
def validationCurve(x, y, xval, yval):
    lamb_vec = [0, 0.001, 0.003, 0.01, 0.03, 0.1, 0.3, 1, 3, 10]
    err_train = np.zeros((len(lamb_vec,)))
    err_val = np.zeros((len(lamb_vec,)))

    for i in range(len(lamb_vec)):
        lamb = lamb_vec[i]
        theta = trainLinReg(x, y, lamb)
        err_train[i] = linRegCostFunc(theta, x, y, 0)
        err_val[i] = linRegCostFunc(theta, xval, yval, 0)

    return lamb_vec, err_train, err_val

lambda_vec, err_train, err_val = validationCurve(X_poly, Y, X_poly_val, Yval)
plt.plot(lambda_vec, err_train, 'b', label='Train')
plt.plot(lambda_vec, err_val, 'r', label='Cross Validation')
plt.xlabel('lambda')
plt.ylabel('Error')
plt.legend(loc='upper right')
plt.show()

print('lambda\t\tTrain Error\tValidation Error')
for i in range(len(lambda_vec)):
    print(' %f\t%f\t%f' % (lambda_vec[i], err_train[i], err_val[i]))

_ = input('Press [Enter] to continue.')
