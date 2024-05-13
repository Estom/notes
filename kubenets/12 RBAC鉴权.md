## 鉴权说明

### 简介

启用RBAC，需要在 apiserver 中添加参数--authorization-mode=RBAC

API Server目前支持以下几种授权策略：

* AlwaysDeny：表示拒绝所有请求，一般用于测试。
* AlwaysAllow：允许接收所有请求。
* 如果集群不需要授权流程，则可以采用该策略，这也是Kubernetes的默认配置。
* ABAC（Attribute-Based Access Control）：基于属性的访问控制。
* 表示使用用户配置的授权规则对用户请求进行匹配和控制。
* Webhook：通过调用外部REST服务对用户进行授权。
* RBAC：Role-Based Access Control，基于角色的访问控制（本章讲解）。
* Node：是一种专用模式，用于对kubelet发出的请求进行访问控制。

### 概念

K8s的用户分两种，一种是普通用户，一种是ServiceAccount（服务账户）。

普通用户

普通用户是假定被外部或独立服务管理的。管理员分配私钥。平时常用的kubectl命令都是普通用户执行的。
如果是用户需求权限，则将Role与User(或Group)绑定(这需要创建User/Group)，是给用户使用的。

ServiceAccount（服务账户）

ServiceAccount（服务帐户）是由Kubernetes API管理的用户。它们绑定到特定的命名空间，并由API服务器自动创建或通过API调用手动创建。服务帐户与存储为Secrets的一组证书相关联，这些凭据被挂载到pod中，以便集群进程与Kubernetes API通信。
如果是程序需求权限，将Role与ServiceAccount指定(这需要创建ServiceAccount并且在deployment中指定ServiceAccount)，是给程序使用的。

![](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/153b25a1b8eb42d08aec5f2dd4dec54e~tplv-k3u1fbpfcp-zoom-in-crop-mark:1512:0:0:0.awebp)


## 操作步骤

### 步骤

在RABC API中，通过如下的步骤进行授权：

1. **定义角色** ：在定义角色时会指定此角色对于资源的访问控制的规则。
2. **绑定角色** ：将主体与角色进行绑定，对用户进行访问授权。

![](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/23d5ec88321243e1b7546d6736736fd3~tplv-k3u1fbpfcp-zoom-in-crop-mark:1512:0:0:0.awebp)

**角色**

* Role：授权特定命名空间的访问权限
* ClusterRole：授权所有命名空间的访问权限

**角色绑定**

* RoleBinding：将角色绑定到主体（即subject）
* ClusterRoleBinding：将集群角色绑定到主体

**主体（subject）**

* User：用户
* Group：用户组
* ServiceAccount：服务账号

### 核心资源

#### Role

1. Role关联资源、操作的权限

```
kind: Role
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  namespace: default
  name: pod-role
rules:
- apiGroups: [""] # "" indicates the core API group
  resources: ["pods"]
  verbs: ["get", "watch", "list"]
```

2. clusterRole关联集群资源的资源、操作权限

```
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: pod-clusterrole
rules:
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["get", "watch", "list"]
```

常用的资源类型有

```
"services", "endpoints", "pods","secrets","configmaps","crontabs","deployments","jobs","nodes","rolebindings","clusterroles","daemonsets","replicasets","statefulsets","horizontalpodautoscalers","replicationcontrollers","cronjobs"
```

常用的操作语义有

```
"get", "list", "watch", "create", "update", "patch", "delete", "exec"
```

#### 角色绑定

RoleBinding

```
kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: rb
  namespace: default
subjects:
- kind: ServiceAccount
  name: zhangsan
  namespace: default
roleRef:
  kind: Role
  name: pod-role
  apiGroup: rbac.authorization.k8s.io
```

ClusterRoleBinding

```
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: crb
subjects:
- kind: ServiceAccount
  name: mark
  namespace: default
roleRef:
  kind: ClusterRole
  name: pod-clusterrole
  apiGroup: rbac.authorization.k8s.io
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: mark
  namespace: default
```

### User&Group


```
kind: Role  
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  namespace: dev
  name: devuser-role
rules:
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["get", "list", "watch", "create", "update", "patch", "delete"]
---
kind: RoleBinding 绑定
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: devuser-rolebinding
  namespace: dev
subjects:
- kind: User
  name: devuser   
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: Role
  name: devuser-role 
  apiGroup: rbac.authorization.k8s.io
```

## 3 具体实例

### 创建用户

1. 创建k8s用户，首先使用ssl生成本地证书的私钥*.key和整数签名请求*.csr

```
#　创建私钥
$ openssl genrsa -out devuser.key 2048
 
#　用此私钥创建一个csr(证书签名请求)文件
$ openssl req -new -key devuser.key -subj "/CN=devuser" -out devuser.csr
```

2. 然后使用k8s的证书ca.crt和私钥ca.key对客户端的证书签名请求*.csr进行签名，颁发客户端证书*.crt

```

#　拿着私钥和请求文件生成证书
$ openssl x509 -req -in devuser.csr -CA /etc/kubernetes/pki/ca.crt -CAkey /etc/kubernetes/pki/ca.key -CAcreateserial -out devuser.crt -days 365
```

3. 生成账号

```
$ kubectl config set-credentials devuser --client-certificate=./devuser.crt --client-key=./devuser.key --embed-certs=true

```

4. 设置用户的上下文参数

```
# # 设置上下文， 默认会保存在 $HOME/.kube/config
$ kubectl config set-context devuser@kubernetes --cluster=kubernetes --user=devuser --namespace=dev

# 查看
$ kubectl config get-contexts

```

5. 切换用户上下文。可以看到新建的用户还没有授权访问nodes资源鉴权失败。

```
$ kubectl config use-context devuser@kubernetes
# 查看
$ kubectl config get-contexts
$ kubectl get nodes


Error from server (Forbidden): nodes is forbidden: User "devuser" cannot list resource "nodes" in API group "" at the cluster scope
```

#### 对用户授权

1. 接下来就是对账号进行授权。这里需要先把用切回来，要不然就无法进行下一步授权了。

```
$ kubectl config use-context kubernetes-admin@kubernetes
$ kubectl get nodes
```

2. 部署下列文件。创建一个角色devuser-role具有dev命名空间的pods的所有权限。并绑定devuser用户。

```
kind: Role  # 角色
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  namespace: dev
  name: devuser-role
rules:
- apiGroups: [""] # ""代表核心api组
  resources: ["pods"]
  verbs: ["get", "list", "watch", "create", "update", "patch", "delete"]
---
kind: RoleBinding # 角色绑定
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: devuser-rolebinding
  namespace: dev
subjects:
- kind: User
  name: devuser   # 目标用户
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: Role
  name: devuser-role  # 角色信息
  apiGroup: rbac.authorization.k8s.io
```

3. 进行验证。用devuser，已经可以管理dev命名空间下的pod资源了，也只能管理dev命名空间下的pod资源，无法管理dev以外的资源类型，验证ok。ClusterRoleBinding绑定类似，这里就不重复了。有兴趣的小伙伴可以试试。

```
$ kubectl apply -f devuser-role-bind
$ kubectl config use-context devuser@kubernetes
$ kubectl get pods # 不带命名空间，这里默认dev，也只能查看dev上面限制的命名空间的pods资源，从而也验证了role是针对命名空间的权限限制
#查看其它命名空间的资源
$ kubectl get pods -n default
$ kubectl get pods -n kube-system
$ kubectl get nodes
```

#### 为ServiceAccount授权

1. 创建serviceAccount并绑定到ClusterRole

```
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: admin
  annotations:
    rbac.authorization.kubernetes.io/autoupdate: "true"
roleRef:
  kind: ClusterRole
  name: cluster-admin
  apiGroup: rbac.authorization.k8s.io
subjects:
- kind: ServiceAccount
  name: sa001
  namespace: kube-system
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: sa001
  namespace: kube-system
```

2. 创建授权后就可以通过k8s的serviceAccount的token访问集群了。

```
$ kubectl -n kube-system get secret|grep sa001
$ kubectl -n kube-system describe secret sa001-token-c2klg
# 也可以使用 jsonpath 的方式直接获取 token 的值，如：
$ kubectl -n kube-system get secret sa001-token-c2klg -o jsonpath={.data.token}|base64 -d
```


## 总结


 **RoleBinding 和 ClusterRoleBinding** ：角色绑定和集群角色绑定，简单来说就是把声明的 Subject 和我们的 Role 进行绑定的过程(给某个用户绑定上操作的权限)，二者的区别也是作用范围的区别：RoleBinding 只会影响到当前namespace 下面的资源操作权限，而 ClusterRoleBinding 会影响到所有的namespace。

* **Rule** ：规则，规则是一组属于不同 API Group 资源上的一组操作的集合
* **Role 和 ClusterRole** ：角色和集群角色，这两个对象都包含上面的 Rules 元素，二者的区别在于，在 Role 中，定义的规则只适用于单个命名空间，也就是和namespace 关联的，而 ClusterRole 是集群范围内的，因此定义的规则不受命名空间的约束。另外 Role 和 ClusterRole 在Kubernetes中都被定义为集群内部的 API 资源，和我们前面学习过的 Pod、ConfigMap 这些类似，都是我们集群的资源对象，所以同样的可以使用我们前面的kubectl相关的命令来进行操作
* **Subject** ：主题，对应在集群中尝试操作的对象，集群中定义了3种类型的主题资源：

1. **User** ：用户，这是有外部独立服务进行管理的，管理员进行私钥的分配，用户可以使用 KeyStone或者 Goolge 帐号，甚至一个用户名和密码的文件列表也可以。对于用户的管理集群内部没有一个关联的资源对象，所以用户不能通过集群内部的 API 来进行管理
2. **Group** ：组，这是用来关联多个账户的，集群中有一些默认创建的组，比如cluster-admin
3. **ServiceAccount** ：服务帐号，通过Kubernetes API 来管理的一些用户帐号，和namespace 进行关联的，适用于集群内部运行的应用程序，需要通过 API 来完成权限认证，所以在集群内部进行权限操作，我们都需要使用到 ServiceAccount，这也是我们这节课的重点
