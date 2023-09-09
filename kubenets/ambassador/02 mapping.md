
## 简介

### 作用
mapping 通过rest 资源与k8s 的service进行关联，ambassador 必须有一个或者多个提供访问servide 的mapping定义




## 用法

### mapping字段详解

1. rewrite rule。修改URL 对于k8s service 的访问
2. weight指定流量路由的权重
3. host指定请求的host header


### mapping 排序

ambassador 对于mappings 会进行排序
1. 较多约束的会优先于较低的约束，
2. 请求前缀的长度，请求的方法，以及约束的header 都会有影响，
3. 如果有必须可以使用precedence 进行修改，但是通常来说没有必要，除非使用了regex_headers 以及host_regex的mapping 特性


## 示例


### mapping实例
最简单的例子
```yaml
---
apiVersion: ambassador/v0
kind:  Mapping
name:  qotm_mapping
prefix: /qotm/
service: http://qotm
一个cqrs 的例子
---
apiVersion: ambassador/v0
kind: Mapping
name: cqrs_get_mapping
prefix: /cqrs/
method: GET
service: getcqrs
---
apiVersion: ambassador/v0
kind: Mapping
name: cqrs_put_mapping
prefix: /cqrs/
method: PUT
service: putcqrs
```


### 基于host的mapping实例
基于http header HOST 的mapping
```yaml
---
apiVersion: ambassador/v0
kind:  Mapping
name:  qotm_mapping
prefix: /qotm/
service: qotm1
---
apiVersion: ambassador/v0
kind:  Mapping
name:  qotm_mapping
prefix: /qotm/
host: qotm.datawire.io
service: qotm2
---
apiVersion: ambassador/v0
kind:  Mapping
name:  qotm_mapping
prefix: /qotm/
host: "^qotm[2-9]\\.datawire\\.io$"
host_regex: true
service: qotm3
---
apiVersion: ambassador/v0
kind: Mapping
name: httpbin_mapping
prefix: /httpbin/
service: httpbin.org:80
host_rewrite: httpbin.org
```

### 基于header的mapping示例

```yaml
apiVersion: ambassador/v0
kind:  Mapping
name:  qotm_mapping
prefix: /qotm/
headers:
  x-qotm-mode: canary
  x-random-header: datawire
service: qotm
```

### 进行跨域处理

```java
apiVersion: ambassador/v0
kind:  Mapping
name:  cors_mapping
prefix: /cors/
service: cors-example
cors:
  origins: http://foo.example,http://bar.example
  methods: POST, GET, OPTIONS
  headers: Content-Type
  credentials: true
  exposed_headers: X-Custom-Header
  max_age: "86400"
```