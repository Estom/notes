kubectl port-forward 允许使用资源名称 （例如 Pod 名称）来选择匹配的 Pod 来进行端口转发

# 将 mongo-75f59d57f4-4nd6q 改为 Pod 的名称
kubectl port-forward mongo-75f59d57f4-4nd6q 28015:27017

这相当于

kubectl port-forward pods/mongo-75f59d57f4-4nd6q 28015:27017
或者

kubectl port-forward deployment/mongo 28015:27017
或者

kubectl port-forward replicaset/mongo-75f59d57f4 28015:27017
或者

kubectl port-forward service/mongo 28015:27017

以上所有命令都有效。输出类似于：

Forwarding from 127.0.0.1:28015 -> 27017
Forwarding from [::1]:28015 -> 27017


与本地 28015 端口建立的连接将被转发到运行 MongoDB 服务器的 Pod 的 27017 端口。 通过此连接，你可以使用本地工作站来调试在 Pod 中运行的数据库。

kubectl port-forward 仅实现了 TCP 端口 支持。 在 issue 47862 中跟踪了对 UDP 协议的支持。

