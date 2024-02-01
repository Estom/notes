## 内置对象

* `Release`： `Release`对象描述了版本发布本身。包含了以下对象：
  * `Release.Name`： release名称
  * `Release.Namespace`： 版本中包含的命名空间(如果manifest没有覆盖的话)
  * `Release.IsUpgrade`： 如果当前操作是升级或回滚的话，该值将被设置为 `true`
  * `Release.IsInstall`： 如果当前操作是安装的话，该值将被设置为 `true`
  * `Release.Revision`： 此次修订的版本号。安装时是1，每次升级或回滚都会自增
  * `Release.Service`： 该service用来渲染当前模板。Helm里始终 `Helm`
* `Values`： `Values`对象是从 `values.yaml`文件和用户提供的文件传进模板的。默认为空
* `Chart`： `Chart.yaml`文件内容。 `Chart.yaml`里的所有数据在这里都可以可访问的。比如 `{{ .Chart.Name }}-{{ .Chart.Version }}` 会打印出 `mychart-0.1.0`
  * 在 [Chart 指南](https://helm.sh/zh/docs/topics/charts#Chart-yaml-%e6%96%87%e4%bb%b6) 中列出了可获得属性
* `Files`： 在chart中提供访问所有的非特殊文件的对象。你不能使用它访问 `Template`对象，只能访问其他文件。 请查看这个 [文件访问](https://helm.sh/zh/docs/chart_template_guide/accessing_files)部分了解更多信息
  * `Files.Get` 通过文件名获取文件的方法。 （`.Files.Getconfig.ini`）
  * `Files.GetBytes` 用字节数组代替字符串获取文件内容的方法。 对图片之类的文件很有用
  * `Files.Glob` 用给定的shell glob模式匹配文件名返回文件列表的方法
  * `Files.Lines` 逐行读取文件内容的方法。迭代文件中每一行时很有用
  * `Files.AsSecrets` 使用Base 64编码字符串返回文件体的方法
  * `Files.AsConfig` 使用YAML格式返回文件体的方法
* `Capabilities`： 提供关于Kubernetes集群支持功能的信息
  * `Capabilities.APIVersions` 是一个版本列表
  * `Capabilities.APIVersions.Has $version` 说明集群中的版本 (比如,`batch/v1`) 或是资源 (比如, `apps/v1/Deployment`) 是否可用
  * `Capabilities.KubeVersion` 和 `Capabilities.KubeVersion.Version` 是Kubernetes的版本号
  * `Capabilities.KubeVersion.Major` Kubernetes的主版本
  * `Capabilities.KubeVersion.Minor` Kubernetes的次版本
  * `Capabilities.HelmVersion` 包含Helm版本详细信息的对象，和 `helm version` 的输出一致
  * `Capabilities.HelmVersion.Version` 是当前Helm语义格式的版本
  * `Capabilities.HelmVersion.GitCommit` Helm的git sha1值
  * `Capabilities.HelmVersion.GitTreeState` 是Helm git树的状态
  * `Capabilities.HelmVersion.GoVersion` 是使用的Go编译器版本
* `Template`： 包含当前被执行的当前模板信息
  * `Template.Name`: 当前模板的命名空间文件路径 (e.g. `mychart/templates/mytemplate.yaml`)
  * `Template.BasePath`: 当前chart模板目录的路径 (e.g. `mychart/templates`)

## Values文件

其内容来自于多个位置：

* chart中的 `values.yaml`文件
* 如果是子chart，就是父chart中的 `values.yaml`文件
* 使用 `-f`参数(`helm install -f myvals.yaml ./mychart`)传递到 `helm install` 或 `helm upgrade`的values文件
* 使用 `--set` (比如 `helm install --set foo=bar ./mychart`)传递的单个参数

## 流程控制

控制结构(在模板语言中称为"actions")提供给你和模板作者控制模板迭代流的能力。 Helm的模板语言提供了以下控制结构：

* `if`/`else`， 用来创建条件语句
* `with`， 用来指定范围
* `range`， 提供"for each"类型的循环

除了这些之外，还提供了一些声明和使用命名模板的关键字：

* `define` 在模板中声明一个新的命名模板
* `template` 导入一个命名模板
* `block` 声明一种特殊的可填充的模板块

控制结构(在模板语言中称为"actions")提供给你和模板作者控制模板迭代流的能力。 Helm的模板语言提供了以下控制结构：

* `if`/`else`， 用来创建条件语句
* `with`， 用来指定范围
* `range`， 提供"for each"类型的循环

除了这些之外，还提供了一些声明和使用命名模板的关键字：

* `define` 在模板中声明一个新的命名模板
* `template` 导入一个命名模板
* `block` 声明一种特殊的可填充的模板块

如果是以下值时，管道会被设置为  *false* ：

* 布尔false
* 数字0
* 空字符串
* `nil` (空或null)
* 空集合(`map`, `slice`, `tuple`, `dict`, `array`)

## 最佳实践

### Key-Value

在java中配置文件可能需要从嵌套的yaml格式转换为扁平的properties格式。以下是在Heml场景下最常用的集中方式

1. value.yaml中使用yaml的嵌套格式。configmap中重写key,value引入对应的键值对

```
a:
  b:
   c:


{{ .Values.a.b.c }}
```

1. values.yaml中使用扁平格式、configmap中作为环境变量引入扁平格式。

```
configmap:
  a.b.c: abc
  d.e.f: def

{{ with .Values.configmap }}
.
{{end}}

```

1. values中使用扁平格式、configmap作为字符串引入震哥key=value。并将整个字符串作为configmap volumn挂载到容器中。

```
  custom.properties: |
    {{- range $key, $value := .Values.customProperties }}
    {{ $key }}={{ $value }}
    {{- end }}
```
