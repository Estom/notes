## 简介


Helm 提供了一个 *hook* 机制允许chart开发者在发布生命周期的某些点进行干预。


* 安装时在加载其他chart之前加载配置映射或密钥
* 安装新chart之前执行备份数据库的任务，然后在升级之后执行第二个任务用于存储数据。
* 在删除发布之前执行一个任务以便在删除服务之前退出滚动。

### 常用钩子


| 注释值            | 描述                                           |
| ----------------- | ---------------------------------------------- |
| `pre-install`   | 在模板渲染之后，Kubernetes资源创建之前执行     |
| `post-install`  | 在所有资源加载到Kubernetes之后执行             |
| `pre-delete`    | 在Kubernetes删除之前，执行删除请求             |
| `post-delete`   | 在所有的版本资源删除之后执行删除请求           |
| `pre-upgrade`   | 在模板渲染之后，资源更新之前执行一个升级请求   |
| `post-upgrade`  | 所有资源升级之后执行一个升级请求               |
| `pre-rollback`  | 在模板渲染之后，资源回滚之前，执行一个回滚请求 |
| `post-rollback` | 在所有资源被修改之后执行一个回滚请求           |
| `test`          | 调用Helm test子命令时执行                     |



### 生命周期


钩子允许你在发布生命周期的关键节点上有机会执行操作。比如，考虑 `helm install`的生命周期。默认的，生命周期看起来是这样：

1. 用户执行 `helm install foo`
2. Helm库调用安装API
3. 在一些验证之后，库会渲染 `foo`模板
4. 库会加载结果资源到Kubernetes
5. 库会返回发布对象（和其他数据）给客户端
6. 客户端退出

Helm 为 `install`周期定义了两个钩子：`pre-install`和 `post-install`。如果 `foo` chart的开发者两个钩子都执行， 周期会被修改为这样：

1. 用户返回 `helm install foo`
2. Helm库调用安装API
3. 在 `crds/`目录中的CRD会被安装
4. 在一些验证之后，库会渲染 `foo`模板
5. 库准备执行 `pre-install`钩子(将hook资源加载到Kubernetes中)
6. 库按照权重对钩子排序(默认将权重指定为0)，然后在资源种类排序，最后按名称正序排列。
7. 库先加载最小权重的钩子(从负到正)
8. 库会等到钩子是 "Ready"状态(CRD除外)
9. 库将生成的资源加载到Kubernetes中。注意如果设置了 `--wait`参数，库会等所有资源是ready状态， 且所有资源准备就绪后才会执行 `post-install`钩子。
10. 库执行 `post-install`钩子(加载钩子资源)。
11. 库会等到钩子是"Ready"状态
12. 库会返回发布对象(和其他数据)给客户端
13. 客户端退出


### 最佳实践

存储在 `templates/post-install-job.yaml`，声明了一个要运行在 `post-install`上的任务：

```yaml
apiVersion:batch/v1
kind:Job
metadata:
name:"{{ .Release.Name }}"
labels:
app.kubernetes.io/managed-by:{{.Release.Service | quote }}
app.kubernetes.io/instance:{{.Release.Name | quote }}
app.kubernetes.io/version:{{.Chart.AppVersion }}
helm.sh/chart:"{{ .Chart.Name }}-{{ .Chart.Version }}"
annotations:
# This is what defines this resource as a hook. Without this line, the
# job is considered part of the release.
"helm.sh/hook": post-install
"helm.sh/hook-weight": "-5"
"helm.sh/hook-delete-policy": hook-succeeded
spec:
template:
metadata:
name:"{{ .Release.Name }}"
labels:
app.kubernetes.io/managed-by:{{.Release.Service | quote }}
app.kubernetes.io/instance:{{.Release.Name | quote }}
helm.sh/chart:"{{ .Chart.Name }}-{{ .Chart.Version }}"
spec:
restartPolicy:Never
containers:
- name:post-install-job
image:"alpine:3.3"
command:["/bin/sleep","{{ default "10" .Values.sleepyTime }}"]
```

声明钩子：

```yaml
annotations:
  "helm.sh/hook": post-install,,post-upgrade
```

当子chart声明钩子时，这些也会被评估。顶级chart无法禁用子chart声明的钩子。

可以为钩子定义权重，这有助于建立一个确定性的执行顺序。权重使用以下注释定义：

```yaml
annotations:
  "helm.sh/hook-weight": "5"
```

钩子无法进行版本管理。即执行完对应的钩子后，对应的资源应该被回收（删除掉），如果upgrade过程中钩子内容发生变化，就会执行最新的钩子内容。执行完成后，对应的资源也会被删除掉。可以定义策略来决定何时删除对应的钩子资源。钩子的删除策略使用以下注释定义：

```yaml
annotations:
"helm.sh/hook-delete-policy": before-hook-creation,hook-succeeded
```

| 注释值                   | 描述                              |
| ------------------------ | --------------------------------- |
| `before-hook-creation` | 新钩子启动前删除之前的资源 (默认) |
| `hook-succeeded`       | 钩子成功执行之后删除资源          |
| `hook-failed`          | 如果钩子执行失败，删除资源        |

如果没有指定钩子删除策略的注释，默认使用 `before-hook-creation`
