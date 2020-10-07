import numpy as np 
from scipy.cluster.vq import kmeans,vq,whiten

data = np.vstack((np.random.rand(100,3)+np.array([.5,.5,.5]),np.random.rand(100,3)))
data = whiten(data)

cent,_ = kmeans(data,3)

print(cent)

# assign each sample to a cluster
clx,_ = vq(data,centroids)
