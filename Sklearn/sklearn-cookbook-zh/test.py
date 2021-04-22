#%% 加载数据

from sklearn import datasets
boston = datasets.load_boston()
X,y = boston.data,boston.target

X.shape
# %% 标准归一化
print(X[:,:3].mean(axis=0))
print(X[:,:3].std(axis=0))


from sklearn import preprocessing

my_scaler = preprocessing.StandardScaler()
my_scaler.fit(X[:,:3])
result = my_scaler.transform(X[:,:3])
# 值特别小，近似为0
print(result[:,:3].mean(axis=0))
