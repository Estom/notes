import numpy as np
import matplotlib.pylab as plt
import scipy.io as sio
import scipy.linalg as la
import scipy.optimize as op

# =============== Part 1: Loading movie ratings dataset ================
print('Loading movie ratings dataset.')
datainfo = sio.loadmat('ex8_movies.mat')
Y = datainfo['Y']
R = datainfo['R'].astype('bool')  # 1682x943
print('Average rating for movie 1 (Toy Story): %f / 5' % np.mean(Y[0, R[0, :]], 0))
plt.imshow(Y, extent=[0, 1000, 0, 1700], aspect='auto')
plt.xlabel('Movies')
plt.ylabel('Users')
plt.show()
_ = input('Press [Enter] to continue.')

# ============ Part 2: Collaborative Filtering Cost Function ===========
# 计算损失函数
def cofiCostFunc(params, Y, R, num_users, num_movies, num_features, lam):
    X = np.reshape(params[0: num_movies*num_features], (num_movies, num_features))
    Theta = np.reshape(params[num_movies*num_features:], (num_users, num_features))
    J = 1/2*np.sum(R*(X.dot(Theta.T)-Y)**2)+lam/2*(np.sum(Theta**2)+np.sum(X**2))
    return J

# 计算梯度函数
def cofiGradFunc(params, Y, R, num_users, num_movies, num_features, lam):
    X = np.reshape(params[0: num_movies * num_features], (num_movies, num_features))
    Theta = np.reshape(params[num_movies * num_features:], (num_users, num_features))

    X_grad = np.zeros(X.shape)
    Theta_grad = np.zeros(Theta.shape)
    for i in range(np.size(X, 0)):
        idx = R[i, :] == 1
        X_grad[i, :] = (X[i, :].dot(Theta[idx, :].T)-Y[i, idx]).dot(Theta[idx, :])+lam*X[i, :]
    for j in range(np.size(Theta, 0)):
        jdx = R[:, j] == 1
        Theta_grad[j, :] = (Theta[j, :].dot(X[jdx, :].T)-Y[jdx, j].T).dot(X[jdx, :])+lam*Theta[j, :]
    grad = np.hstack((X_grad.flatten(), Theta_grad.flatten()))
    return grad

datainfo2 = sio.loadmat('ex8_movieParams.mat')
X = datainfo2['X']
Theta = datainfo2['Theta']
num_users = datainfo2['num_users']
num_movies = datainfo2['num_movies']
num_features = datainfo2['num_features']

# 以少数据量实验
num_users = 4; num_movies = 5; num_features = 3
X = X[0:num_movies, 0:num_features]
Theta = Theta[0:num_users, 0:num_features]
Y = Y[0:num_movies, 0:num_users]
R = R[0:num_movies, 0:num_users]

params = np.hstack((X.flatten(), Theta.flatten()))
J = cofiCostFunc(params, Y, R, num_users, num_movies, num_features, 0)
Grad = cofiGradFunc(params, Y, R, num_users, num_movies, num_features, 0)
print('Cost at loaded parameters: %f \n(this value should be about 22.22)' % J)
_ = input('Press [Enter] to continue.')

# ============== Part 3: Collaborative Filtering Gradient ==============
# 计算数值梯度
def computeNumericalGradient(func, extraArgs, theta):
    numgrad = np.zeros(theta.shape)
    perturb = np.zeros(theta.shape)
    episilon = 1e-4
    for p in range(np.size(theta, 0)):
        perturb[p] = episilon
        loss1 = func(theta-perturb, *extraArgs)
        loss2 = func(theta+perturb, *extraArgs)
        numgrad[p] = (loss2-loss1)/(2*episilon)
        perturb[p] = 0
    return numgrad

# 检查梯度
def checkCostFunc(lamb=0):
    X_t = np.random.random((4, 3))
    Theta_t = np.random.random((5, 3))
    Y = X_t.dot(Theta_t.T)
    Y[np.random.random(Y.shape) > 0.5] = 0
    R = np.zeros(Y.shape)
    R[Y != 0] = 1

    X = np.random.randn(X_t.shape[0], X_t.shape[1])
    Theta = np.random.randn(Theta_t.shape[0], Theta_t.shape[1])
    num_users = np.size(Y, 1)
    num_movies = np.size(Y, 0)
    num_features = np.size(Theta_t, 1)

    params = np.hstack((X.flatten(), Theta.flatten()))
    numgrad = computeNumericalGradient(cofiCostFunc, (Y, R, num_users, num_movies, num_features, lamb), params)
    grad = cofiGradFunc(params, Y, R, num_users, num_movies, num_features, lamb)

    print('Numerical: ', numgrad)
    print('Analytical: ', grad)
    print('The above two columns you get should be very similar.')
    print('(Left-Your Numerical Gradient, Right-Analytical Gradient)')
    diff = la.norm(numgrad-grad)/la.norm(numgrad+grad)
    print('If your backpropagation implementation is correct, ')
    print('then the relative difference will be small (less than 1e-9).')
    print('Relative Difference: ', diff)

print('Checking Gradients (without regularization) ...')
checkCostFunc()
_ = input('Press [Enter] to continue.')

# ========= Part 4: Collaborative Filtering Cost Regularization ========
params = np.hstack((X.flatten(), Theta.flatten()))
J = cofiCostFunc(params, Y, R, num_users, num_movies, num_features, 1.5)
print('Cost at loaded parameters (lambda = 1.5): %f\n(this value should be about 31.34)' %J)
_ = input('Press [Enter] to continue.')

# ======= Part 5: Collaborative Filtering Gradient Regularization ======
print('Checking Gradients (with regularization) ...')
checkCostFunc(1.5)
_ = input('Press [Enter] to continue.')

# ============== Part 6: Entering ratings for a new user ===============
# 加载电影数据
def loadMovieList():
    movieList = [line.split(' ', 1)[1] for line in open('movie_ids.txt', encoding='utf8')]
    return movieList

movieList = loadMovieList()
my_ratings = np.zeros((1682,))
# For example, Toy Story (1995) has ID 1, so to rate it "4", you can set
my_ratings[0] = 4
my_ratings[97] = 2
my_ratings[6] = 3
my_ratings[11] = 5
my_ratings[53] = 4
my_ratings[63] = 5
my_ratings[65] = 3
my_ratings[68] = 5
my_ratings[182] = 4
my_ratings[225] = 5
my_ratings[354] = 5

print('New user ratings:')
for i in range(np.size(my_ratings, 0)):
    if my_ratings[i] > 0:
        print('Rated %d for %s' %(my_ratings[i], movieList[i]))

_ = input('Press [Enter] to continue.')

# ================== Part 7: Learning Movie Ratings ====================
# 归一化
def normalizeRating(Y, R):
    m, n = Y.shape
    Ymean = np.zeros((m,))
    Ynorm = np.zeros(Y.shape)
    for i in range(m):
        idx = R[i, :] == 1
        Ymean[i] = np.mean(Y[i, idx])
        Ynorm[i, idx] = Y[i, idx]-Ymean[i]
    return Ynorm, Ymean
print('Training collaborative filtering...')
datainfo3 = sio.loadmat('ex8_movies.mat')
Y = datainfo3['Y']
R = datainfo3['R']
Y = np.c_[my_ratings.reshape((np.size(my_ratings, 0), 1)), Y]
R = np.c_[(my_ratings!=0).reshape((np.size(my_ratings, 0), 1)), R]

Y_norm, Ymean = normalizeRating(Y, R)

num_users = np.size(Y, 1)
num_movies = np.size(Y, 0)
num_features = 10

X = np.random.randn(num_movies, num_features)
Theta = np.random.randn(num_users, num_features)

init_params = np.hstack((X.flatten(), Theta.flatten()))
lamb = 10
theta = op.fmin_cg(cofiCostFunc, init_params, fprime=cofiGradFunc, \
                   args=(Y, R, num_users, num_movies, num_features, lamb), maxiter=100)

X = np.reshape(theta[0: num_movies*num_features], (num_movies, num_features))
Theta = np.reshape(theta[num_movies*num_features:], (num_users, num_features))

print('Recommender system learning completed.')
_ = input('Press [Enter] to continue.')

# ================== Part 8: Recommendation for you ====================

p = X.dot(Theta.T)
my_pred = p[:, 0]+Ymean
ix = np.argsort(my_pred)[::-1]
print('Top recommendations for you:')
for i in range(10):
    j = ix[i]
    print('Predicting rating %.1f for movie %s' %(my_pred[j], movieList[j]))

print('Original ratings provided:')
for i in range(np.size(my_ratings, 0)):
    if my_ratings[i] > 0:
        print('Rated %d for %s' %(my_ratings[i], movieList[i]))







