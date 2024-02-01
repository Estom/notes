## 1 Values和templates

### 定义values

* `values.yaml` 的文件。这个文件包含了默认值。
* 在命令行使用 `helm install`命令时提供。当用户提供自定义value时，这些value会覆盖chart的 `values.yaml`文件中value。Helm安装命令允许用户使用附加的YAML values覆盖这个values：

```console
$ helm install --generate-name --values=myvals.yaml wordpress
```

### 子Chart的value值

```
title: "My WordPress Site" # Sent to the WordPress template

mysql:
  max_connections: 100 # Sent to MySQL
  password: "secret"

apache:
  port: 8080 # Passed to Apache
```

> 子chart不能访问父级chart，所以MySQL无法访问 `title`属性。同样也无法访问 `apache.port`。

支持特殊的"global"值,`.Values.global.app`在 *所有* chart中有效。

```
title: "My WordPress Site" # Sent to the WordPress template

global:
  app: MyWordPress

mysql:
  max_connections: 100 # Sent to MySQL
  password: "secret"

apache:
  port: 8080 # Passed to Apache
```

### DDL文件结构

```
{
  "$schema": "https://json-schema.org/draft-07/schema#",
  "properties": {
    "image": {
      "description": "Container Image",
      "properties": {
        "repo": {
          "type": "string"
        },
        "tag": {
          "type": "string"
        }
      },
      "type": "object"
    },
    "name": {
      "description": "Service name",
      "type": "string"
    },
    "port": {
      "description": "Port",
      "minimum": 0,
      "type": "integer"
    },
    "protocol": {
      "type": "string"
    }
  },
  "required": [
    "protocol",
    "port"
  ],
  "title": "Values",
  "type": "object"
}
```

这个架构会应用values值并验证它。一个满足要求的yaml如下

```
name: frontend
protocol: https
port: 443
```

### 用户自定义资源CRD

当Helm安装新chart时，会上传CRD，暂停安装直到CRD可以被API服务使用，然后启动模板引擎， 渲染chart其他部分，并上传到Kubernetes。

CRD YAML文件应被放置在chart的 `crds/`目录中。 多个CRD(用YAML的开始和结束符分隔)可以被放置在同一个文件中。Helm会尝试加载CRD目录中 *所有的* 文件到Kubernetes。

CRD 文件  *无法模板化* ，必须是普通的YAML文档。

CRD的生命周期：

* CRD从不重新安装。 如果Helm确定 `crds/`目录中的CRD已经存在（忽略版本），Helm不会安装或升级。
* CRD从不会在升级或回滚时安装。Helm只会在安装时创建CRD。
* CRD从不会被删除。自动删除CRD会删除集群中所有命名空间中的所有CRD内容。因此Helm不会删除CRD

### 渲染templates



* `.Files` 对象引用父chart的文件路径，而不是库chart的本地路径

### 默认变量

* `Release.Name`: 版本名称(非chart的)
* `Release.Namespace`: 发布的chart版本的命名空间
* `Release.Service`: 组织版本的服务
* `Release.IsUpgrade`: 如果当前操作是升级或回滚，设置为true
* `Release.IsInstall`: 如果当前操作是安装，设置为true
* `Chart`: `Chart.yaml`的内容。因此，chart的版本可以从 `Chart.Version` 获得， 并且维护者在 `Chart.Maintainers`里。
* `Files`: chart中的包含了非特殊文件的类图对象。这将不允许您访问模板， 但是可以访问现有的其他文件（除非被 `.helmignore`排除在外）。 使用 `{{ index .Files "file.name" }}`可以访问文件或者使用 `{{.Files.Get name }}`功能。 您也可以使用 `{{ .Files.GetBytes }}`作为 `[]byte`访问文件内容。
* `Capabilities`: 包含了Kubernetes版本信息的类图对象。(`{{ .Capabilities.KubeVersion }}`) 和支持的Kubernetes API 版本(`{{ .Capabilities.APIVersions.Has "batch/v1" }}`)

> 任何未知的 `Chart.yaml`字段会被抛弃。在 `Chart`对象中无法访问。因此， `Chart.yaml`不能用于将任意结构的数据传递到模板中。

## 1 技巧

### 自动滚动部署

当配置文件变更时，需要触发pod的滚动升级。执行helm update命令，如果只是configmap变化但是spec.template没有变化则不会触发pod的滚动升级。需要引入一个变量。

`sha256sum`方法保证在另一个文件发生更改时更新负载说明：

```yaml
kind:Deployment
spec:
  template:
    metadata:
      annotations:
        checksum/config:{{include (print $.Template.BasePath "/configmap.yaml") . | sha256sum }}
[...]
```

这个场景下你通常想滚动更新你的负载，可以使用类似的说明步骤，而不是使用随机字符串替换，因而经常更改并导致负载滚动更新：

```yaml
kind:Deployment
spec:
  template:
    metadata:
      annotations:
        rollme:{{randAlphaNum 5 | quote }}
[...]
```

每次调用模板方法会生成一个唯一的随机字符串。这意味着如果需要同步多种资源使用的随机字符串，所有的相对资源都要在同一个模板文件中。

### 保留资源

有时在执行 `helm uninstall`时有些资源不应该被卸载。Chart的开发者可以在资源中添加额外的说明避免被卸载。

```yaml
kind: Secret
metadata:
  annotations:
    "helm.sh/resource-policy": keep
[...]
```
