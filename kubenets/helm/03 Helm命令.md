## HelmChart命令


创建一个新chart：

```console
$ helm create mychart
Created mychart/
```


打包成一个chart存档：

```console
$ helm package mychart
Archived mychart-0.1.-.tgz
```


找到chart的格式或信息的问题：

```console
$ helm lint mychart
No issues found
```
