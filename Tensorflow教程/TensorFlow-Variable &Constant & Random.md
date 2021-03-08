## 类说明

### tf.variable

##### 创建

```
# Create two variables.
weights = tf.Variable(tf.random_normal([784, 200], stddev=0.35),
                      name="weights")
biases = tf.Variable(tf.zeros([200]), name="biases")
```
* 一个Variable操作存放变量的值。
* 一个初始化op将变量设置为初始值。这事实上是一个tf.assign操作.
* 初始值的操作，例如示例中对biases变量的zeros操作也被加入了graph。

##### 初始化
```
# Add an op to initialize the variables.
init_op = tf.initialize_all_variables()

# Later, when launching the model
with tf.Session() as sess:
  # Run the init operation.
  sess.run(init_op)
  ...
  # Use the model
  ...


# Create a variable with a random value.
weights = tf.Variable(tf.random_normal([784, 200], stddev=0.35),
                      name="weights")
# Create another variable with the same value as 'weights'.
w2 = tf.Variable(weights.initialized_value(), name="w2")
# Create another variable with twice the value of 'weights'
w_twice = tf.Variable(weights.initialized_value() * 0.2, name="w_twice")
```

* 可以直接指明初始化的值，使用sess.run运行。也可以用一个张量的initialized_value来初始化另外一个variable

### 常量tf.Constant

##### 创建

```
tf.Constant("Hello world",dtype=tf.string)
```

##### 数据类型

```
tf.int
tf.intl
tf.int32
tf.int64
tf.uint8
tf.uint16
tf.float16
tf.float32
tf.string
tf.bool
tf.complex64
tf.complex128
tf.float32
```

### 随机数Random

##### 生成

```
tf.random_normal(shape,mean=0,stddev=1.0,dtype=tf.float32,seed=None,name=None)

tf.truncate_normal(shape,mean=0.0,stddev=1.0,dtype=tf.float32,seed=None,name=None)

tf.random_uniform(shape,minval=0,maxval=None,dtype=tf.float32,seed=None,name=None)
```




