#!/usr/bin/python
# -*- coding: UTF-8 -*-

"""
Created on 2017-06-29
Updated on 2017-06-29
DecisionTree: 决策树
Author: 小瑶
GitHub: https://github.com/apachecn/AiLearning
"""
print(__doc__)

import numpy as np
import matplotlib.pyplot as plt

from sklearn.datasets import load_iris
from sklearn.tree import DecisionTreeClassifier



def createDataSet():
    """
    Desc:
        创建数据集
    Args:
        无需传入参数
    Returns:
        返回数据集和对应的label标签
    """
    # dataSet 前两列是特征，最后一列对应的是每条数据对应的分类标签
    dataSet = [[1, 1, 1],
               [1, 1, 1],
               [1, 0, 2],
               [0, 1, 2],
               [0, 1, 2]]
    # labels  露出水面   脚蹼，注意: 这里的labels是写的 dataSet 中特征的含义，并不是对应的分类标签或者说目标变量
    # 返回
    return dataSet
    
def test_dts_fish():
    datasets = np.array(createDataSet())
    dataset = datasets[:,[0,1]]
    labels = datasets[:,2]
    dt_classifer = DecisionTreeClassifier().fit(dataset,labels)
    Z = dt_classifer.predict(dataset)


def test_dts_iris():
    # 参数
    n_classes = 3
    plot_colors = "bry"
    plot_step = 0.02

    # 加载数据
    iris = load_iris()

    for pairidx, pair in enumerate([[0, 1], [0, 2], [0, 3], [1, 2], [1, 3], [2, 3]]):
        # 我们只用两个相应的features
        X = iris.data[:, pair]
        y = iris.target

        # 训练
        clf = DecisionTreeClassifier().fit(X, y)

        # 绘制决策边界
        plt.subplot(2, 3, pairidx + 1)

        x_min, x_max = X[:, 0].min() - 1, X[:, 0].max() + 1
        y_min, y_max = X[:, 1].min() - 1, X[:, 1].max() + 1
        xx, yy = np.meshgrid(np.arange(x_min, x_max, plot_step),
                            np.arange(y_min, y_max, plot_step))

        Z = clf.predict(np.c_[xx.ravel(), yy.ravel()])
        Z = Z.reshape(xx.shape)
        cs = plt.contourf(xx, yy, Z, cmap=plt.cm.Paired)

        plt.xlabel(iris.feature_names[pair[0]])
        plt.ylabel(iris.feature_names[pair[1]])
        plt.axis("tight")

        # 绘制训练点
        for i, color in zip(range(n_classes), plot_colors):
            idx = np.where(y == i)
            plt.scatter(X[idx, 0], X[idx, 1], c=color, label=iris.target_names[i],
                        cmap=plt.cm.Paired)

        plt.axis("tight")

    plt.suptitle("Decision surface of a decision tree using paired features")
    plt.legend()
    plt.show()
