## markdonw绘图

### 时序图
```sequence
A->B:因果关系

B->A:返回值
```

### 流程图

​```flow
st=>start: 第一步
op=>operation: 第二步
cond=>condition: Yes or No?
e=>end

st->op->cond
cond(yes)->e
cond(no)->op
​```

### 右向图
```mermaid
graph LR
A[第一步<br/>第二行] -->B(第二步<br/>第二行)
    B --> C{决策}
    C -->|原因1| D[结果1<br/>第二行]
    C -->|原因2| E[结果2<br/>第二行]
```

### 扇形图

```mermaid
pie
    title Pie Chart
    "原因一" : 99
    "原因二" : 666
    "原因三" : 188
```

