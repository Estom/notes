## 使用


为了能使用公共代码，我们需要添加一个 `common`依赖。在 `demo/Chart.yaml`文件最后啊添加以下内容：

```yaml
dependencies:
- name:common
version:"^0.0.5"
repository:"https://charts.helm.sh/incubator/"
```


使用辅助chart中的公共代码。首先编辑负载文件 `demo/templates/deployment.yaml`如下：

```yaml
{{- template "common.deployment" (list . "demo.deployment") -}}
{{- define "demo.deployment" -}}
## Define overrides for your Deployment resource here, e.g.
apiVersion: apps/v1
spec:
  replicas: {{ .Values.replicaCount }}
  selector:
    matchLabels:
      {{- include "demo.selectorLabels" . | nindent 6 }}
  template:
    metadata:
      labels:
        {{- include "demo.selectorLabels" . | nindent 8 }}

{{- end -}}
```





`demo/templates/service.yaml`变成了下面这样：

```yaml
{{- template "common.service" (list . "demo.service") -}}
{{- define "demo.service" -}}
## Define overrides for your Service resource here, e.g.
# metadata:
#   labels:
#     custom: label
# spec:
#   ports:
#   - port: 8080
{{- end -}}
```




* 模板文件的名称应该反映名称中的资源类型。比如：`foo-pod.yaml`， `bar-svc.yaml`
* yaml注释中的模板字符串仍然会被解析
* 镜像使用固定版本或者范围版本。
* define是全局的模板，需要给不同的模板添加命名空间
