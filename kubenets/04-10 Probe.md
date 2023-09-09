
## 1 概述

### 概念
探针:是由 kubelet 对容器执行的定期诊断。kubelet 调用由容器实现 Handler执行诊断。探针有三种类型的处理程序:

* ExecAction：在容器内执行指定命令。如果命令退出时返回码为 0 则认为诊断成功。
* CPSocketAction：对指定端口上的容器的 IP 地址进行 TCP 检查。如果端口打开，则诊断被认为是成功的。
* HTTPGetAction：对指定的端口和路径上的容器的 IP 地址执行 HTTP Get 请求。如果响应的状态码大于等于200 且小于 400，则诊断被认为是成功的。和微服务的心跳检测类似，每隔一段时间，检测这个容器是否还正常工作，检测状态分为三种,每次检测，都会得到其中一种，k8s会根据检测到的不同状态，对容器进行不同的处理：
  * 成功：容器通过了诊断。
  * 失败：容器未通过诊断。
  * 未知：诊断失败，因此不会采取任何行动。

### 分类
探针主要有以下三种类型：

livenessProbe 
readinessProbe
startupProbe

### 容器重启策略

容器重启策略 
PodSpec 中有一个 restartPolicy 字段，其值可以设置为
```
Always
OnFailure
Never
```

默认为 Always

* Always：表示一旦不管以何种方式终止运行，kubelet都将重启

* OnFailure：表示只有Pod以非0退出码退出才重启

* Nerver：表示不再重启该Pod

restartPolicy 适用于 Pod 中的所有容器。restartPolicy 仅指通过同一节点上的 kubelet 重新启动容器。失败的容器由 kubelet 以五分钟为上限的指数退避延迟（10秒，20秒，40秒…）重新启动，并在成功执行十分钟后重置。如 Pod 官方文档中所说，一旦pod绑定到一个节点，Pod 将永远不会重新绑定到另一个节点。


## 2 探针类型

### livenessProbe：存活性探针

指检测容器是否正在运行。

* 如果存活探测失败，则 kubelet 会杀死容器（需要注意：杀死的是container不是pod），并且容器将受到其重启策略（Always,OnFailure,Never）的影响。

* 如果容器不提供存活探针，则默认状态为 Success。

### readinessProbe：就绪性探针

指示容器是否准备好服务请求【对外接受请求访问】。

* 如果就绪探测失败，端点控制器将从与 Pod 匹配的所有 Service 的端点中删除该 Pod 的 IP 地址IP:Port。
* 初始延迟之前的就绪状态默认为 Failure。
* 如果容器不提供就绪探针，则默认状态为 Success。 

> 如果容器未通过准备检查，则不会被终止或重新启动。

### startupProbe：启动探针

k8s1.16新增加的一种类型指检测容器中的应用是否已经启动。

* 如果提供了启动探测(startup probe)，则禁用所有其他探测，直到它成功为止。
* 如果启动探测失败，kubelet 将杀死容器，容器服从其重启策略进行重启。
* 如果容器没有提供启动探测，则默认状态为成功Success。

主要解决在慢启动程序或复杂程序中readinessProbe、livenessProbe探针无法较好的判断程序是否启动、是否存活。执行顺序：

* 如果三个探针同时存在，则先执行startupProbe探针，其他两个探针将会被暂时禁用，直到startupProbe一次探测成功，其他2个探针才启动
* 如果startupProbe探测失败，kubelet 将杀死容器，并根据restartPolicy重启策略来判断容器是否要进行重启操作。

### 对比

1. 就绪探针与存活探针之间的重要区别：就绪探针如果容器未通过准备检查，则不会被终止或重新启动。
2. 存活探针：通过杀死异常的容器，并用新的正常容器替代他们来保持Pod正常工作
3. 就绪探针：确保只有准备好处理请求的Pod才可以接收探针请求

## 3 配置

### 示例

```

spec:
	containers:
		# 就绪探针
		readinessProbe:
			# 检测方式
			httpGet: 
			# 超时时间
			timeoutSeconds: 
			# 延迟时间
			initialDelaySeconds:
			# 失败次数限制
			failureThreshold:
			# 每多少秒检测一次
			periodSeconds:
		# 存活探针
		livenessProbe:
            # 检测方式
			httpGet: 
			# 超时时间
			timeoutSeconds: 
			# 延迟时间
			initialDelaySeconds:
			# 失败次数限制
			failureThreshold:
			# 每多少秒检测一次
			periodSeconds:
```

### 配置说明

* initialDelaySeconds：容器启动后要等待多少秒后存活和就绪探测器才被初始化
  * 默认是 0 秒，最小值是 0

* periodSeconds：执行探测的时间间隔（单位是秒）
  * 默认是 10 秒。最小值是 1。

* timeoutSeconds：探测的超时时间
  * 默认值是 1 秒。最小值是 1。 

* successThreshold：探测器在失败后，被视为成功的最小连续成功数。
  * 默认值是 1。存活探测的这个值必须是 1。最小值是 1。 

* failureThreshold：当探测失败时，重试次数+1。存活探测失败就意味着重新启动容器。就绪探测失败Pod 会被打上未就绪的标签。
  * 默认值是 3。最小值是 1。

*  在 httpGet 上配置额外的字段： 
   *  host：连接使用的主机名，默认是 Pod 的 IP。也可以在 HTTP 头中设置 “Host” 来代替。
   *  scheme ：用于设置连接主机的方式（HTTP 还是 HTTPS）。默认是 HTTP。
   *  path：访问 HTTP 服务的路径。 
   *  httpHeaders：请求中自定义的 HTTP 头。HTTP 头字段允许重复。 
   *  port：访问容器的端口号或者端口名。如果数字必须在 1 ～ 65535 之间。 



## 4 探活机制

就绪探针/存活探针，都有这三种探测机制。
* HTTP GET探针
* TCP套接字探针
* Exec探针


### HTTP GET探针
该探针，是针对容器的IP地址(或者是指定的端口和地址)执行HTTP GET请求，状态码：

如果返回状态码是2xx或者3xx,则探测成功。
如果服务器返回错误的状态码或者根本没有反应，那么认定探测失败，容器会被重新启动。

### TCP套接字探针
TCP套接字探针：尝试与容器指定的端口建立连接，

如果连接成功，则探测成功，
如果连接失败，则认定为探测失败，容器将被重新启动。


### Exec探针
Exec探针：在容器内执行任意命令，并检查命令的退出状态码，

如果返回的状态码为0，则探测成功，
如果返回状态码不为0，则探测失败，容器将被重新启动。


> 如果是java应用，建议用HTTP GET探针、不推荐使用Exec探针，因为java应用程序会消耗大量的计算资源


