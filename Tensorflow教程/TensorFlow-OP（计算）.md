## TensorFlow-OP

### 元素op
* 求和
```
tf.add(x,y,name=None)
```
* 减法
```
tf.sub(x,y,name=None)
```

* 乘法
```
tf.mutipy(x,y,name=None)
```
* 除法
```
tf.div(x,y,name=None)
```
* 取模
```
tf.mod(x,y,name=None)
```
* 求绝对值
```
tf.abs(x,name=None)
```

* 取反
```
tf.neg(x,name=None)
```
* 赋值
```
tf.sign(x,name=None)
```
* 返回符号
```
tf.inv(x,name=None)
```
* 计算平方
```
tf.square(x,name=None)
```
* 开根号
```
tf.sqrt(x,name=None)
```
* 计算e的次方
```
tf.exp(x,name=None)
```
* 计算log
```
tf.log(x,name=None)
```
* 返回最大值
```
tf.maximum(x,y,name=None)
```
* 返回最小值
```
tf.minimum(x,y,name=None)
```
* 三角函数cos
```
tf.cos(x,name=None)
```

* 三角函数sin
```
tf.sin(x,name=None)
```
* 三角函数tan
```
tf.tan(x,name=None)
```
* 三角函数ctan
```
tf.atan(x,name=None)
```

### 向量op

### 矩阵op

```
tf.diag(diagnal,name=None)
tf.diag_par(input,name=None)
tf.trace(x,name=None)
tf.transpose(a,perm=None)
tf.matmul(a,b,transpose_a=False,transpose_b=False,a_is_sparse=False,name=None)
tf.matrix_determinant(input,name=None)
tf.matrix_inverse(input,adjoint=None,name=None)
tf.cholesky(input,name=None)
tf.matrix_solve(matrix,rhs,adjoint=None,name=None)
```