## 1 简单查询

### 直接查询
查询指标的所有时间序列。
```
http_requests_total
等价于
http_requests_total{}
```

### 标签匹配
PromQL支持使用=和!=两种标签完全匹配模式：
* 通过使用label=value可以选择那些标签满足表达式定义的时间序列；
* 反之使用label!=value则可以根据标签匹配排除时间序列；
```
http_requests_total{instance="localhost:9090"}
```

PromQL还可以支持使用正则表达式作为匹配条件，多个表达式之间使用|进行分离：
* 使用label=~regx表示选择那些标签符合正则表达式定义的时间序列；
* 反之使用label!~regx进行排除；
```
http_requests_total{environment=~"staging|testing|development",method!="GET"}
```

### 范围查询

* 返回值中只会包含该时间序列中的最新的一个样本值，这样的返回结果我们称之为瞬时向量。而相应的这样的表达式称之为瞬时向量表达式。
* 区间向量表达式和瞬时向量表达式之间的差异在于在区间向量表达式中我们需要定义时间选择的范围，时间范围通过时间范围选择器[]进行定义。例如，通过以下表达式可以选择最近5分钟内的所有样本数据。通过区间向量表达式查询到的结果我们称为区间向量。

```properties
http_requests_total{}[5m]
该表达式将会返回查询到的时间序列中最近5分钟的所有样本数据：

http_requests_total{code="200",handler="alerts",instance="localhost:9090",job="prometheus",method="get"}=[
    1@1518096812.326
    1@1518096817.326
    1@1518096822.326
    1@1518096827.326
    1@1518096832.326
    1@1518096837.325
]
http_requests_total{code="200",handler="graph",instance="localhost:9090",job="prometheus",method="get"}=[
    4@1518096812.326
    4@1518096817.326
    4@1518096822.326
    4@1518096827.326
    4@1518096832.326
    4@1518096837.325
]
```
除了使用m表示分钟以外，PromQL的时间范围选择器支持其它时间单位：
```
s - 秒
m - 分钟
h - 小时
d - 天
w - 周
y - 年
```

### 时间位移操作
在瞬时向量表达式或者区间向量表达式中，都是以当前时间为基准：
http_request_total{} # 瞬时向量表达式，选择当前最新的数据
```
http_request_total{}[5m] # 区间向量表达式，选择以当前时间为基准，5分钟内的数据
```
而如果我们想查询，5分钟前的瞬时样本数据，或昨天一天的区间内的样本数据呢? 这个时候我们就可以使用位移操作，位移操作的关键字为offset。
可以使用offset时间位移操作：
```
http_request_total{} offset 5m
http_request_total{}[1d] offset 1d
```

### 标量和字符串


标量只有一个数字，没有时序。
```
10
```
字符串（String）：一个简单的字符串值
```
"this is a string"
'these are unescaped: \n \\ \t'
`these are not unescaped: \n ' " \t`
```

## 2 操作符

### 数学运算

```
+ (加法)
- (减法)
* (乘法)
/ (除法)
% (求余)
^ (幂运算)
```

### 布尔运算
使用瞬时向量表达式能够获取到一个包含多个时间序列的集合，我们称为瞬时向量。 通过集合运算，可以在两个瞬时向量与瞬时向量之间进行相应的集合操作。
```
== (相等)
!= (不相等)
> (大于)
< (小于)
>= (大于等于)
<= (小于等于)
```

### 集合运算

```
and (并且)
or (或者)
unless (排除)
```
### 优先级

```
^
*, /, %
+, -
==, !=, <=, <, >=, >
and, unless
or
```
## 聚合查询

### 瞬时向量聚合运算
Prometheus还提供了下列内置的聚合操作符，这些操作符作用域瞬时向量。可以将瞬时表达式返回的样本数据进行聚合,，形成一个新的时间序列

```
sum (求和)
min (最小值)
max (最大值)
avg (平均值)
stddev (标准差)
stdvar (标准方差)
count (计数)
count_values (对value进行计数)
bottomk (后n条时序)
topk (前n条时序)
quantile (分位数)
```

### without by

without用于从计算结果中移除列举的标签，而保留其它标签。by则正好相反，结果向量中只保留列出的标签，其余标签则移除。通过without和by可以按照样本的问题对数据进行聚合。
例如：
```
sum(http_requests_total) without (instance)
等价于
sum(http_requests_total) by (code,handler,job,method)
```

一般来说，如果描述样本特征的标签(label)在并非唯一的情况下，通过PromQL查询数据，会返回多条满足这些特征维度的时间序列。而PromQL提供的聚合操作可以用来对这些时间序列进行处理，形成一条新的时间序列：

```
# 查询系统所有http请求的总量
sum(http_request_total)

# 按照mode计算主机CPU的平均使用时间
avg(node_cpu) by (mode)

# 按照主机查询各个主机的CPU使用率
sum(sum(irate(node_cpu{mode!='idle'}[5m]))  / sum(irate(node_cpu[5m]))) by (instance)
```

## 4 内置函数
https://prometheus.fuckcloudnative.io/di-san-zhang-prometheus/di-4-jie-cha-xun/functions
### Counter的增长率

increase(v range-vector)函数是PromQL中提供的众多内置函数之一。其中参数v是一个区间向量，increase函数获取区间向量中的第一个后最后一个样本并返回其增长量。因此，可以通过以下表达式Counter类型指标的增长率：

```
increase(node_cpu[2m]) / 120
```

这里通过node_cpu[2m]获取时间序列最近两分钟的所有样本，increase计算出最近两分钟的增长量，最后除以时间120秒得到node_cpu样本在最近两分钟的平均增长率。并且这个值也近似于主机节点最近两分钟内的平均CPU使用率。

PromQL中还直接内置了rate(v range-vector)函数，rate函数可以直接计算区间向量v在时间窗口内平均增长速率。因此，通过以下表达式可以得到与increase函数相同的结果：
```
rate(node_cpu[2m])
```

使用rate或者increase函数去计算样本的平均增长速率，容易陷入“长尾问题”当中.PromQL提供了另外一个灵敏度更高的函数irate(v range-vector)。irate同样用于计算区间向量的计算率，但是其反应出的是瞬时增长率。irate函数是通过区间向量中最后两个样本数据来计算区间向量的增长速率。这种方式可以避免在时间窗口范围内的“长尾问题”，并且体现出更好的灵敏度，通过irate函数绘制的图标能够更好的反应样本数据的瞬时变化状态。
```
irate(node_cpu[2m])
```

### Gauge变化趋势
PromQL中内置的predict_linear(v range-vector, t scalar) 函数可以帮助系统管理员更好的处理此类情况，predict_linear函数可以预测时间序列v在t秒后的值。它基于简单线性回归的方式，对时间窗口内的样本数据进行统计，从而可以对时间序列的变化趋势做出预测。例如，基于2小时的样本数据，来预测主机可用磁盘空间的是否在4个小时候被占满，可以使用如下表达式：
```
predict_linear(node_filesystem_free{job="node"}[2h], 4 * 3600) < 0
```

### Histogram指标的分位数
以指标http_request_duration_seconds_bucket为例：

```
# HELP http_request_duration_seconds request duration histogram
# TYPE http_request_duration_seconds histogram
http_request_duration_seconds_bucket{le="0.5"} 0
http_request_duration_seconds_bucket{le="1"} 1
http_request_duration_seconds_bucket{le="2"} 2
http_request_duration_seconds_bucket{le="3"} 3
http_request_duration_seconds_bucket{le="5"} 3
http_request_duration_seconds_bucket{le="+Inf"} 3
http_request_duration_seconds_sum 6
http_request_duration_seconds_count 3
```

当计算9分位数时，使用如下表达式：
```
histogram_quantile(0.5, http_request_duration_seconds_bucket)
```

### 标签替换

```
label_replace(v instant-vector, dst_label string, replacement string, src_label string, regex string)
```

该函数会依次对v中的每一条时间序列进行处理，通过regex匹配src_label的值，并将匹配部分relacement写入到dst_label标签中。如下所示：