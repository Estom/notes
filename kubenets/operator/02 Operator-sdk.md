## 使用实例

### 搭建go开发环境

1. 下载

```
brew install go
```
2. 配置环境变量

```
GOPATH=
GOROOT=
GOPROXY=
```

3. 安装operator-sdk工具

```
brew install operator-sdk
```

### 创建项目


```
$ operator-sdk new opdemo
......
# 该过程需要科学上网，需要花费很长时间，请耐心等待
......
$ cd opdemo && tree -L 2
.
├── Gopkg.lock
├── Gopkg.toml
├── build
│   ├── Dockerfile
│   ├── _output
│   └── bin
├── cmd
│   └── manager
├── deploy
│   ├── crds
│   ├── operator.yaml
│   ├── role.yaml
│   ├── role_binding.yaml
│   └── service_account.yaml
├── pkg
│   ├── apis
│   └── controller
├── vendor
│   ├── cloud.google.com
│   ├── contrib.go.opencensus.io
│   ├── github.com
│   ├── go.opencensus.io
│   ├── go.uber.org
│   ├── golang.org
│   ├── google.golang.org
│   ├── gopkg.in
│   ├── k8s.io
│   └── sigs.k8s.io
└── version
    └── version.go

23 directories, 8 files
```


