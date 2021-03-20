# TensorFlow 高效编程

> 原文：[vahidk/EffectiveTensorflow](https://github.com/vahidk/EffectiveTensorflow)

> 译者：[FesianXu](https://my.csdn.net/loseinvain)、[飞龙](https://github.com/wizardforcel)

> 协议：[CC BY-NC-SA 4.0](http://creativecommons.org/licenses/by-nc-sa/4.0/)

## 一、TensorFlow 基础

TensorFlow 和其他数字计算库（如 numpy）之间最明显的区别在于 TensorFlow 中操作的是符号。这是一个强大的功能，这保证了 TensorFlow 可以做很多其他库（例如 numpy）不能完成的事情（例如自动区分）。这可能也是它更复杂的原因。今天我们来一步步探秘 TensorFlow，并为更有效地使用 TensorFlow 提供了一些指导方针和最佳实践。

我们从一个简单的例子开始，我们要乘以两个随机矩阵。首先我们来看一下在 numpy 中如何实现：

```py
import numpy as np
x = np.random.normal(size=[10, 10])
y = np.random.normal(size=[10, 10])
z = np.dot(x, y)
print(z)

```

现在我们使用 TensorFlow 中执行完全相同的计算：  

```py
import TensorFlow as tf
x = tf.random_normal([10, 10])
y = tf.random_normal([10, 10])
z = tf.matmul(x, y)
sess = tf.Session()
z_val = sess.run(z)
print(z_val)

```

与立即执行计算并将结果复制给输出变量`z`的 numpy 不同，TensorFlow 只给我们一个可以操作的张量类型。如果我们尝试直接打印`z`的值，我们得到这样的东西：  

```py
Tensor("MatMul:0", shape=(10, 10), dtype=float32)
```

由于两个输入都是已经定义的类型，TensorFlow 能够推断张量的符号及其类型。为了计算张量的值，我们需要创建一个会话并使用`Session.run`方法进行评估。

要了解如此强大的符号计算到底是什么，我们可以看看另一个例子。假设我们有一个曲线的样本（例如`f(x)= 5x ^ 2 + 3`），并且我们要估计`f(x)`在不知道它的参数的前提下。我们定义参数函数为`g(x，w)= w0 x ^ 2 + w1 x + w2`，它是输入`x`和潜在参数`w`的函数，我们的目标是找到潜在参数，使得`g(x, w)≈f(x)`。这可以通过最小化损失函数来完成：`L(w)=(f(x)-g(x，w))^ 2`。虽然这问题有一个简单的封闭式的解决方案，但是我们选择使用一种更为通用的方法，可以应用于任何可以区分的任务，那就是使用随机梯度下降。我们在一组采样点上简单地计算相对于`w`的`L(w)`的平均梯度，并沿相反方向移动。

以下是在 TensorFlow 中如何完成：  

```py
import numpy as np
import TensorFlow as tf
x = tf.placeholder(tf.float32)
y = tf.placeholder(tf.float32)
w = tf.get_variable("w", shape=[3, 1])
f = tf.stack([tf.square(x), x, tf.ones_like(x)], 1)
yhat = tf.squeeze(tf.matmul(f, w), 1)
loss = tf.nn.l2_loss(yhat - y) + 0.1 * tf.nn.l2_loss(w)
train_op = tf.train.AdamOptimizer(0.1).minimize(loss)
def generate_data():
    x_val = np.random.uniform(-10.0, 10.0, size=100)
    y_val = 5 * np.square(x_val) + 3
    return x_val, y_val
sess = tf.Session()
sess.run(tf.global_variables_initializer())
for _ in range(1000):
    x_val, y_val = generate_data()
    _, loss_val = sess.run([train_op, loss], {x: x_val, y: y_val})
    print(loss_val)
print(sess.run([w]))

```

通过运行这段代码，我们可以看到下面这组数据：

```
[4.9924135, 0.00040895029, 3.4504161]
```

这与我们的参数已经相当接近。

这只是 TensorFlow 可以做的冰山一角。许多问题，如优化具有数百万个参数的大型神经网络，都可以在 TensorFlow 中使用短短的几行代码高效地实现。而且 TensorFlow 可以跨多个设备和线程进行扩展，并支持各种平台。

## 二、理解静态和动态形状

在 **TensorFlow** 中，`tensor`有一个在图构建过程中就被决定的**静态形状属性**， 这个静态形状可以是**未规定的**，比如，我们可以定一个具有形状`[None, 128]`大小的`tensor`。

```python
import TensorFlow as tf
a = tf.placeholder(tf.float32, [None, 128])
```

这意味着`tensor`的第一个维度可以是任何尺寸，这个将会在`Session.run()`中被动态定义。当然，你可以查询一个`tensor`的静态形状，如：

```python
static_shape = a.shape.as_list()  # returns [None, 128]
```

为了得到一个`tensor`的动态形状，你可以调用`tf.shape`操作，这将会返回指定tensor的形状，如：

```python
dynamic_shape = tf.shape(a)
```

`tensor`的静态形状可以通过方法`Tensor_name.set_shape()`设定，如：

```python
a.set_shape([32, 128])  # static shape of a is [32, 128]
a.set_shape([None, 128])  # first dimension of a is determined dynamically
```

调用`tf.reshape()`方法，你可以动态地重塑一个`tensor`的形状，如：

```python
a =  tf.reshape(a, [32, 128])
```

可以定义一个函数，当静态形状的时候返回其静态形状，当静态形状不存在时，返回其动态形状，如：

```python
def get_shape(tensor):
  static_shape = tensor.shape.as_list()
  dynamic_shape = tf.unstack(tf.shape(tensor))
  dims = [s[1] if s[0] is None else s[0]
          for s in zip(static_shape, dynamic_shape)]
  return dims
```

现在，如果我们需要将一个三阶的`tensor`转变为 2 阶的`tensor`，通过折叠第二维和第三维成一个维度，我们可以通过我们刚才定义的`get_shape()`方法进行，如：

```python
b = tf.placeholder(tf.float32, [None, 10, 32])
shape = get_shape(b)
b = tf.reshape(b, [shape[0], shape[1] * shape[2]])
```

注意到无论这个`tensor`的形状是静态指定的还是动态指定的，这个代码都是有效的。事实上，我们可以写出一个通用的`reshape`函数，用于折叠维度的任意列表:

```python
import TensorFlow as tf
import numpy as np

def reshape(tensor, dims_list):
  shape = get_shape(tensor)
  dims_prod = []
  for dims in dims_list:
    if isinstance(dims, int):
      dims_prod.append(shape[dims])
    elif all([isinstance(shape[d], int) for d in dims]):
      dims_prod.append(np.prod([shape[d] for d in dims]))
    else:
      dims_prod.append(tf.prod([shape[d] for d in dims]))
  tensor = tf.reshape(tensor, dims_prod)
  return tensor
```

然后折叠第二个维度就变得特别简单了。

```python
b = tf.placeholder(tf.float32, [None, 10, 32])
b = reshape(b, [0, [1, 2]])
```

## 三、作用域和何时使用它

在 TensorFlow 中，变量和张量有一个名字属性，用于作为他们在图中的标识。如果你在创造变量或者张量的时候，不给他们显式地指定一个名字，那么 TF 将会自动地，隐式地给他们分配名字，如：

```python
a = tf.constant(1)
print(a.name)  # prints "Const:0"

b = tf.Variable(1)
print(b.name)  # prints "Variable:0"
```

你也可以在定义的时候，通过显式地给变量或者张量命名，这样将会重写他们的默认名，如：

```python
a = tf.constant(1, name="a")
print(a.name)  # prints "b:0"

b = tf.Variable(1, name="b")
print(b.name)  # prints "b:0"
```

TF 引进了两个不同的上下文管理器，用于更改张量或者变量的名字，第一个就是`tf.name_scope`，如：

```python
with tf.name_scope("scope"):
  a = tf.constant(1, name="a")
  print(a.name)  # prints "scope/a:0"

  b = tf.Variable(1, name="b")
  print(b.name)  # prints "scope/b:0"

  c = tf.get_variable(name="c", shape=[])
  print(c.name)  # prints "c:0"
```

我们注意到，在 TF 中，我们有两种方式去定义一个新的变量，通过`tf.Variable()`或者调用`tf.get_variable()`。在调用`tf.get_variable()`的时候，给予一个新的名字，将会创建一个新的变量，但是如果这个名字并不是一个新的名字，而是已经存在过这个变量作用域中的，那么就会抛出一个`ValueError`异常，意味着重复声明一个变量是不被允许的。

`tf.name_scope()`只会影响到**通过调用`tf.Variable`创建的**张量和变量的名字，而**不会影响到通过调用`tf.get_variable()`创建**的变量和张量。  

和`tf.name_scope()`不同，`tf.variable_scope()`也会修改，影响通过`tf.get_variable()`创建的变量和张量，如：

```python
with tf.variable_scope("scope"):
  a = tf.constant(1, name="a")
  print(a.name)  # prints "scope/a:0"

  b = tf.Variable(1, name="b")
  print(b.name)  # prints "scope/b:0"

  c = tf.get_variable(name="c", shape=[])
  print(c.name)  # prints "scope/c:0"
with tf.variable_scope("scope"):
  a1 = tf.get_variable(name="a", shape=[])
  a2 = tf.get_variable(name="a", shape=[])  # Disallowed
```

但是如果我们真的想要重复使用一个先前声明过了变量怎么办呢？变量管理器同样提供了一套机制去实现这个需求：

```python
with tf.variable_scope("scope"):
  a1 = tf.get_variable(name="a", shape=[])
with tf.variable_scope("scope", reuse=True):
  a2 = tf.get_variable(name="a", shape=[])  # OK
This becomes handy for example when using built-in neural network layers:

features1 = tf.layers.conv2d(image1, filters=32, kernel_size=3)
# Use the same convolution weights to process the second image:
with tf.variable_scope(tf.get_variable_scope(), reuse=True):
  features2 = tf.layers.conv2d(image2, filters=32, kernel_size=3)
```

这个语法可能看起来并不是特别的清晰明了。特别是，如果你在模型中想要实现一大堆的变量共享，你需要追踪各个变量，比如说什么时候定义新的变量，什么时候要复用他们，这些将会变得特别麻烦而且容易出错，因此 TF 提供了 TF 模版自动解决变量共享的问题：

```python
conv3x32 = tf.make_template("conv3x32", lambda x: tf.layers.conv2d(x, 32, 3))
features1 = conv3x32(image1)
features2 = conv3x32(image2)  # Will reuse the convolution weights.
```

你可以将任何函数都转换为 TF 模版。当第一次调用这个模版的时候，在这个函数内声明的变量将会被定义，同时在接下来的连续调用中，这些变量都将自动地复用。

## 四、广播的优缺点

TensorFlow 支持广播机制，可以广播逐元素操作。正常情况下，当你想要进行一些操作如加法，乘法时，你需要确保操作数的形状是相匹配的，如：你不能将一个具有形状`[3, 2]`的张量和一个具有`[3,4]`形状的张量相加。但是，这里有一个特殊情况，那就是当你的其中一个操作数是一个某个维度为一的张量的时候，TF 会隐式地填充它的单一维度方向，以确保和另一个操作数的形状相匹配。所以，对一个`[3,2]`的张量和一个`[3,1]`的张量相加在 TF 中是合法的。

```python
import TensorFlow as tf

a = tf.constant([[1., 2.], [3., 4.]])
b = tf.constant([[1.], [2.]])
# c = a + tf.tile(b, [1, 2])
c = a + b
```

广播机制允许我们在隐式情况下进行填充，而这可以使得我们的代码更加简洁，并且更有效率地利用内存，因为我们不需要另外储存填充操作的结果。一个可以表现这个优势的应用场景就是在结合具有不同长度的特征向量的时候。为了拼接具有不同长度的特征向量，我们一般都先填充输入向量，拼接这个结果然后进行之后的一系列非线性操作等。这是一大类神经网络架构的共同模式。

```python
a = tf.random_uniform([5, 3, 5])
b = tf.random_uniform([5, 1, 6])

# concat a and b and apply nonlinearity
tiled_b = tf.tile(b, [1, 3, 1])
c = tf.concat([a, tiled_b], 2)
d = tf.layers.dense(c, 10, activation=tf.nn.relu)
```

但是这个可以通过广播机制更有效地完成。我们利用事实`f(m(x+y))=f(mx+my)f(m(x+y))=f(mx+my)f(m(x+y))=f(mx+my)`，简化我们的填充操作。因此，我们可以分离地进行这个线性操作，利用广播机制隐式地完成拼接操作。

```python
pa = tf.layers.dense(a, 10, activation=None)
pb = tf.layers.dense(b, 10, activation=None)
d = tf.nn.relu(pa + pb)
```

事实上，这个代码足够通用，并且可以在具有任意形状的张量间应用：

```python
def merge(a, b, units, activation=tf.nn.relu):
    pa = tf.layers.dense(a, units, activation=None)
    pb = tf.layers.dense(b, units, activation=None)
    c = pa + pb
    if activation is not None:
        c = activation(c)
    return c
```

一个更为通用函数形式如上所述：

目前为止，我们讨论了广播机制的优点，但是同样的广播机制也有其缺点，隐式假设几乎总是使得调试变得更加困难，考虑下面的例子：

```python
a = tf.constant([[1.], [2.]])
b = tf.constant([1., 2.])
c = tf.reduce_sum(a + b)
```

你猜这个结果是多少？如果你说是 6，那么你就错了，答案应该是 12。这是因为当两个张量的阶数不匹配的时候，在进行元素间操作之前，TF 将会自动地在更低阶数的张量的第一个维度开始扩展，所以这个加法的结果将会变为`[[2, 3], [3, 4]]`，所以这个`reduce`的结果是12.  

解决这种麻烦的方法就是尽可能地显式使用。我们在需要`reduce`某些张量的时候，显式地指定维度，然后寻找这个 bug 就会变得简单：

```python
a = tf.constant([[1.], [2.]])
b = tf.constant([1., 2.])
c = tf.reduce_sum(a + b, 0)
```

这样，`c`的值就是`[5, 7]`，我们就容易猜到其出错的原因。一个更通用的法则就是总是在`reduce`操作和在使用`tf.squeeze`中指定维度。

## 五、向 TensorFlow 投喂数据

**TensorFlow** 被设计可以在大规模的数据情况下高效地运行。所以你需要记住千万不要“饿着”你的 TF 模型，这样才能得到最好的表现。一般来说，一共有三种方法可以“投喂”你的模型。

### 常数方式（`tf.constant`）

最简单的方式莫过于直接将数据当成常数嵌入你的计算图中，如：

```python
import TensorFlow as tf
import numpy as np

actual_data = np.random.normal(size=[100])
data = tf.constant(actual_data)
```

这个方式非常地高效，但是却不灵活。这个方式存在一个大问题就是为了在其他数据集上复用你的模型，你必须要重写你的计算图，而且你必须同时加载所有数据，并且一直保存在内存里，这意味着这个方式仅仅适用于小数剧集的情况。

### 占位符方式（`tf.placeholder`）

可以通过占位符的方式解决刚才常数投喂网络的问题，如：

```python
import TensorFlow as tf
import numpy as np

data = tf.placeholder(tf.float32)
prediction = tf.square(data) + 1
actual_data = np.random.normal(size=[100])
tf.Session().run(prediction, feed_dict={data: actual_data})
```

占位符操作符返回一个张量，他的值在会话（`session`）中通过人工指定的`feed_dict`参数得到。

### python 操作（`tf.py_func`）

还可以通过利用 python 操作投喂数据：

```python
def py_input_fn():
    actual_data = np.random.normal(size=[100])
    return actual_data

data = tf.py_func(py_input_fn, [], (tf.float32))
```

python 操作允许你将一个常规的 python 函数转换成一个 TF 的操作。

### 利用 TF 的自带数据集 API

最值得推荐的方式就是通过 TF 自带的数据集 API 进行投喂数据，如：

```python
actual_data = np.random.normal(size=[100])
dataset = tf.contrib.data.Dataset.from_tensor_slices(actual_data)
data = dataset.make_one_shot_iterator().get_next()
```

如果你需要从文件中读入数据，你可能需要将文件转化为`TFrecord`格式，这将会使得整个过程更加有效

```python
dataset = tf.contrib.data.Dataset.TFRecordDataset(path_to_data)
```

查看[官方文档](https://www.TensorFlow.org/api_guides/python/reading_data#Reading_from_files)，了解如何将你的数据集转化为`TFrecord`格式。

```python
dataset = ...
dataset = dataset.cache()
if mode == tf.estimator.ModeKeys.TRAIN:
    dataset = dataset.repeat()
    dataset = dataset.shuffle(batch_size * 5)
dataset = dataset.map(parse, num_threads=8)
dataset = dataset.batch(batch_size)
```

在读入了数据之后，我们使用`Dataset.cache()`方法，将其缓存到内存中，以求更高的效率。在训练模式中，我们不断地重复数据集，这使得我们可以多次处理整个数据集。我们也需要打乱数据集得到批量，这个批量将会有不同的样本分布。下一步，我们使用`Dataset.map()`方法，对原始数据进行预处理，将数据转换成一个模型可以识别，利用的格式。然后，我们就通过`Dataset.batch()`，创造样本的批量了。

## 六、利用运算符重载

和 Numpy 一样，TensorFlow 重载了很多 python 中的运算符，使得构建计算图更加地简单，并且使得代码具有可读性。

**切片**操作是重载的诸多运算符中的一个，它可以使得索引张量变得很容易：

```python
z = x[begin:end]  # z = tf.slice(x, [begin], [end-begin])
```

但是在使用它的过程中，你还是需要非常地小心。切片操作非常低效，因此最好避免使用，特别是在切片的数量很大的时候。为了更好地理解这个操作符有多么地低效，我们先观察一个例子。我们想要人工实现一个对矩阵的行进行`reduce`操作的代码：

```python
import TensorFlow as tf
import time

x = tf.random_uniform([500, 10])

z = tf.zeros([10])
for i in range(500):
    z += x[i]

sess = tf.Session()
start = time.time()
sess.run(z)
print("Took %f seconds." % (time.time() - start))
```

在笔者的 MacBook Pro 上，这个代码花费了 2.67 秒！那么耗时的原因是我们调用了切片操作 500 次，这个运行起来超级慢的！一个更好的选择是使用`tf.unstack()`操作去将一个矩阵切成一个向量的列表，而这只需要一次就行！

```python
z = tf.zeros([10])
for x_i in tf.unstack(x):
    z += x_i
```

这个操作花费了 0.18 秒，当然，最正确的方式去实现这个需求是使用`tf.reduce_sum()`操作：

```python
z = tf.reduce_sum(x, axis=0)
```

这个仅仅使用了 0.008 秒，是原始实现的 300 倍！
TensorFlow 除了切片操作，也重载了一系列的数学逻辑运算，如：

```python
z = -x  # z = tf.negative(x)
z = x + y  # z = tf.add(x, y)
z = x - y  # z = tf.subtract(x, y)
z = x * y  # z = tf.mul(x, y)
z = x / y  # z = tf.div(x, y)
z = x // y  # z = tf.floordiv(x, y)
z = x % y  # z = tf.mod(x, y)
z = x ** y  # z = tf.pow(x, y)
z = x @ y  # z = tf.matmul(x, y)
z = x > y  # z = tf.greater(x, y)
z = x >= y  # z = tf.greater_equal(x, y)
z = x < y  # z = tf.less(x, y)
z = x <= y  # z = tf.less_equal(x, y)
z = abs(x)  # z = tf.abs(x)
z = x & y  # z = tf.logical_and(x, y)
z = x | y  # z = tf.logical_or(x, y)
z = x ^ y  # z = tf.logical_xor(x, y)
z = ~x  # z = tf.logical_not(x)
```

你也可以使用这些操作符的增广版本，如 `x += y`和`x **=2`同样是合法的。  
注意到 python 不允许重载`and`，`or`和`not`等关键字。  

TensorFlow 也不允许把张量当成`boolean`类型使用，因为这个很容易出错：

```python
x = tf.constant(1.)
if x:  # 这个将会抛出TypeError错误
    ...
```

如果你想要检查这个张量的值的话，你也可以使用`tf.cond(x,...)`，或者使用`if x is None`去检查这个变量的值。  

有些操作是不支持的，比如说等于判断`==`和不等于判断`!=`运算符，这些在 numpy 中得到了重载，但在 TF 中没有重载。如果需要使用，请使用这些功能的函数版本`tf.equal()`和`tf.not_equal()`。

## 七、理解执行顺序和控制依赖

我们知道，TensorFlow 是属于符号式编程的，它不会直接运行定义了的操作，而是在计算图中创造一个相关的节点，这个节点可以用`Session.run()`进行执行。这个使得 TF 可以在优化过程中决定优化的顺序，并且在运算中剔除一些不需要使用的节点，而这一切都发生在运行中。如果你只是在计算图中使用`tf.Tensors`，你就不需要担心依赖问题，但是你更可能会使用`tf.Variable()`，这个操作使得问题变得更加困难。笔者的建议是如果张量不能满足这个工作需求，那么仅仅使用`Variables`就足够了。这个可能不够直观，我们不妨先观察一个例子：

```python
import TensorFlow as tf

a = tf.constant(1)
b = tf.constant(2)
a = a + b

tf.Session().run(a)
```

计算`a`将会返回 3，就像期望中的一样。注意到我们现在有 3 个张量，两个常数张量和一个储存加法结果的张量。注意到我们不能重写一个张量的值，如果我们想要改变张量的值，我们就必须要创建一个新的张量，就像我们刚才做的那样。

> **小提示：**如果你没有显式地定义一个新的计算图，TF 将会自动地为你构建一个默认的计算图。你可以使用`tf.get_default_graph()`去获得一个计算图的句柄，然后，你就可以查看这个计算图了。比如，可以打印属于这个计算图的所有张量之类的的操作都是可以的。如：

```python
print(tf.contrib.graph_editor.get_tensors(tf.get_default_graph()))
```

不像张量，变量可以更新，所以让我们用变量去实现我们刚才的需求：

```python
a = tf.Variable(1)
b = tf.constant(2)
assign = tf.assign(a, a + b)

sess = tf.Session()
sess.run(tf.global_variables_initializer())
print(sess.run(assign))
```

同样，我们得到了 3，正如预期一样。注意到`tf.assign()`返回的代表这个赋值操作的张量。目前为止，所有事情都显得很棒，但是让我们观察一个稍微有点复杂的例子吧：

```python
a = tf.Variable(1)
b = tf.constant(2)
c = a + b

assign = tf.assign(a, 5)

sess = tf.Session()
for i in range(10):
    sess.run(tf.global_variables_initializer())
    print(sess.run([assign, c]))
```

注意到，张量`c`并没有一个确定性的值。这个值可能是 3 或者 7，取决于加法和赋值操作谁先运行。  

你应该也注意到了，你在代码中定义操作的顺序是不会影响到在 TF 运行时的执行顺序的，唯一会影响到执行顺序的是**控制依赖**。控制依赖对于张量来说是直接的。每一次你在操作中使用一个张量时，操作将会定义一个对于这个张量来说的隐式的依赖。但是如果你同时也使用了变量，事情就变得更糟糕了，因为变量可以取很多值。  

当处理这些变量时，你可能需要显式地去通过使用`tf.control_dependencies()`去控制依赖，如：

```python
a = tf.Variable(1)
b = tf.constant(2)
c = a + b

with tf.control_dependencies([c]):
    assign = tf.assign(a, 5)

sess = tf.Session()
for i in range(10):
    sess.run(tf.global_variables_initializer())
    print(sess.run([assign, c]))
```

这会确保赋值操作在加法操作之后被调用。

## 八、控制流操作：条件和循环

在构建复杂模型（如循环神经网络）时，你可能需要通过条件和循环来控制操作流。 在本节中，我们将介绍一些常用的控制流操作。

假设你要根据谓词决定，是否相乘或相加两个给定的张量。这可以简单地用`tf.cond`实现，它充当 python "if" 函数：

```py
a = tf.constant(1)
b = tf.constant(2)

p = tf.constant(True)

x = tf.cond(p, lambda: a + b, lambda: a * b)

print(tf.Session().run(x))
```

由于在这种情况下谓词为`True`，因此输出将是加法的结果，即 3。

大多数情况下，使用 TensorFlow 时，你使用的是大型张量，并希望批量执行操作。 相关的条件操作是`tf.where`，类似于`tf.cond`，它接受谓词，但是基于批量中的条件来选择输出。

```py
a = tf.constant([1, 1])
b = tf.constant([2, 2])

p = tf.constant([True, False])

x = tf.where(p, a + b, a * b)

print(tf.Session().run(x))
```

这将返回`[3,2]`。

另一种广泛使用的控制流操作是`tf.while_loop`。 它允许在 TensorFlow 中构建动态循环，这些循环操作可变长度的序列。 让我们看看如何使用`tf.while_loops`生成斐波那契序列：

```py
n = tf.constant(5)

def cond(i, a, b):
    return i < n

def body(i, a, b):
    return i + 1, b, a + b

i, a, b = tf.while_loop(cond, body, (2, 1, 1))

print(tf.Session().run(b))
```

这将打印 5。除了循环变量的初始值之外，`tf.while_loops`还接受条件函数和循环体函数。 然后通过多次调用循环体函数来更新这些循环变量，直到条件返回`False`。

现在想象我们想要保留整个斐波那契序列。 我们可以更新我们的循环体来记录当前值的历史：

```py
n = tf.constant(5)

def cond(i, a, b, c):
    return i < n

def body(i, a, b, c):
    return i + 1, b, a + b, tf.concat([c, [a + b]], 0)

i, a, b, c = tf.while_loop(cond, body, (2, 1, 1, tf.constant([1, 1])))

print(tf.Session().run(c))
```

现在，如果你尝试运行它，TensorFlow 会报错，第四个循环变量的形状改变了。 因此，你必须明确指出它是有意的：

```py
i, a, b, c = tf.while_loop(
    cond, body, (2, 1, 1, tf.constant([1, 1])),
    shape_invariants=(tf.TensorShape([]),
                      tf.TensorShape([]),
                      tf.TensorShape([]),
                      tf.TensorShape([None])))
```

这不仅变得丑陋，而且效率也有些低下。 请注意，我们正在构建许多我们不使用的中间张量。 TensorFlow 为这种不断增长的阵列提供了更好的解决方案。 看看`tf.TensorArray`。 让我们这次用张量数组做同样的事情：

```py
n = tf.constant(5)

c = tf.TensorArray(tf.int32, n)
c = c.write(0, 1)
c = c.write(1, 1)

def cond(i, a, b, c):
    return i < n

def body(i, a, b, c):
    c = c.write(i, a + b)
    return i + 1, b, a + b, c

i, a, b, c = tf.while_loop(cond, body, (2, 1, 1, c))

c = c.stack()

print(tf.Session().run(c))
```

TensorFlow while 循环和张量数组是构建复杂的循环神经网络的基本工具。 作为练习，尝试使用`tf.while_loops`实现[集束搜索（beam search）](https://en.wikipedia.org/wiki/Beam_search)。 使用张量数组可以使效率更高吗？

## 九、使用 Python 操作设计核心和高级可视化

TensorFlow 中的操作核心完全用 C++ 编写，用于提高效率。 但是用 C++ 编写 TensorFlow 核心可能会非常痛苦。因此，在花费数小时实现核心之前，你可能希望快速创建原型，但效率低下。使用`tf.py_func()`，你可以将任何一段 python 代码转换为 TensorFlow 操作。

例如，这就是如何在 TensorFlow 中将一个简单的 ReLU 非线性核心实现为 python 操作：

```py
import numpy as np
import tensorflow as tf
import uuid

def relu(inputs):
    # Define the op in python
    def _relu(x):
        return np.maximum(x, 0.)

    # Define the op's gradient in python
    def _relu_grad(x):
        return np.float32(x > 0)

    # An adapter that defines a gradient op compatible with TensorFlow
    def _relu_grad_op(op, grad):
        x = op.inputs[0]
        x_grad = grad * tf.py_func(_relu_grad, [x], tf.float32)
        return x_grad

    # Register the gradient with a unique id
    grad_name = "MyReluGrad_" + str(uuid.uuid4())
    tf.RegisterGradient(grad_name)(_relu_grad_op)

    # Override the gradient of the custom op
    g = tf.get_default_graph()
    with g.gradient_override_map({"PyFunc": grad_name}):
        output = tf.py_func(_relu, [inputs], tf.float32)
    return output
```

要验证梯度是否正确，可以使用 TensorFlow 的梯度检查器：

```py
x = tf.random_normal([10])
y = relu(x * x)

with tf.Session():
    diff = tf.test.compute_gradient_error(x, [10], y, [10])
    print(diff)
```

`compute_gradient_error()`以数值方式计算梯度，并返回提供的梯度的差。 我们想要的是非常低的差。

请注意，此实现效率非常低，仅适用于原型设计，因为 python 代码不可并行化，不能在 GPU 上运行。 一旦验证了你的想法，你肯定会想把它写成 C++ 核心。

在实践中，我们通常使用 python 操作在 Tensorboard 上进行可视化。 考虑你正在构建图像分类模型，并希望在训练期间可视化模型的预测情况。TensorFlow 允许使用`tf.summary.image()`函数可视化图像：

```py
image = tf.placeholder(tf.float32)
tf.summary.image("image", image)
```

但这只能显示输入图像。 为了显示预测，你必须找到一种向图像添加注释的方法，这对现有操作几乎是不可能的。 更简单的方法是在 python 中绘制，并将其包装在 python 操作中：

```py
import io
import matplotlib.pyplot as plt
import numpy as np
import PIL
import tensorflow as tf

def visualize_labeled_images(images, labels, max_outputs=3, name="image"):
    def _visualize_image(image, label):
        # Do the actual drawing in python
        fig = plt.figure(figsize=(3, 3), dpi=80)
        ax = fig.add_subplot(111)
        ax.imshow(image[::-1,...])
        ax.text(0, 0, str(label),
          horizontalalignment="left",
          verticalalignment="top")
        fig.canvas.draw()

        # Write the plot as a memory file.
        buf = io.BytesIO()
        data = fig.savefig(buf, format="png")
        buf.seek(0)

        # Read the image and convert to numpy array
        img = PIL.Image.open(buf)
        return np.array(img.getdata()).reshape(img.size[0], img.size[1], -1)

    def _visualize_images(images, labels):
        # Only display the given number of examples in the batch
        outputs = []
        for i in range(max_outputs):
            output = _visualize_image(images[i], labels[i])
            outputs.append(output)
        return np.array(outputs, dtype=np.uint8)

    # Run the python op.
    figs = tf.py_func(_visualize_images, [images, labels], tf.uint8)
    return tf.summary.image(name, figs)
```

请注意，由于摘要通常仅仅偶尔（不是每步）求值一次，因此可以在实践中使用此实现而不必担心效率。

## 十、多 GPU 和数据并行

如果你使用 C++ 等语言为单个 CPU 核心编写软件，并使其在多个 GPU 上并行运行，则需要从头开始重写软件。 但TensorFlow并非如此。 由于其象征性，TensorFlow 可以隐藏所有这些复杂性，使得无需在多个 CPU 和 GPU 上扩展程序。

让我们以在 CPU 上相加两个向量的简单示例开始：

```py
 import tensorflow as tf

with tf.device(tf.DeviceSpec(device_type="CPU", device_index=0)):
    a = tf.random_uniform([1000, 100])
    b = tf.random_uniform([1000, 100])
    c = a + b

tf.Session().run(c)
```

GPU 上可以做相同的事情：

```py
with tf.device(tf.DeviceSpec(device_type="GPU", device_index=0)):
    a = tf.random_uniform([1000, 100])
    b = tf.random_uniform([1000, 100])
    c = a + b
```

但是，如果我们有两个 GPU 并且想要同时使用它们呢？ 为此，我们可以拆分数据并使用单独的 GPU 来处理每一半：

```py
split_a = tf.split(a, 2)
split_b = tf.split(b, 2)

split_c = []
for i in range(2):
    with tf.device(tf.DeviceSpec(device_type="GPU", device_index=i)):
        split_c.append(split_a[i] + split_b[i])

c = tf.concat(split_c, axis=0)
```

让我们以更一般的形式重写它，以便我们可以用任何其他操作替换加法：

```py
def make_parallel(fn, num_gpus, **kwargs):
    in_splits = {}
    for k, v in kwargs.items():
        in_splits[k] = tf.split(v, num_gpus)

    out_split = []
    for i in range(num_gpus):
        with tf.device(tf.DeviceSpec(device_type="GPU", device_index=i)):
            with tf.variable_scope(tf.get_variable_scope(), reuse=i > 0):
                out_split.append(fn(**{k : v[i] for k, v in in_splits.items()}))

    return tf.concat(out_split, axis=0)


def model(a, b):
    return a + b

c = make_parallel(model, 2, a=a, b=b)
```

你可以使用任何接受一组张量作为输入的函数替换模型，并在输入和输出都是批量的条件下，返回张量作为结果。请注意，我们还添加了一个变量作用域并将复用设置为`True`。这确保我们使用相同的变量来处理两个分割。在我们的下一个例子中，这将变得很方便。

让我们看一个稍微更实际的例子。我们想在多个 GPU 上训练神经网络。在训练期间，我们不仅需要计算正向传播，还需要计算反向传播（梯度）。但是我们如何并行计算梯度呢？ 事实证明这很简单。

回想一下第一节，我们想要将二次多项式拟合到一组样本。我们重新组织了一些代码，以便在模型函数中进行大量操作：

```py
import numpy as np
import tensorflow as tf

def model(x, y):
    w = tf.get_variable("w", shape=[3, 1])

    f = tf.stack([tf.square(x), x, tf.ones_like(x)], 1)
    yhat = tf.squeeze(tf.matmul(f, w), 1)

    loss = tf.square(yhat - y)
    return loss

x = tf.placeholder(tf.float32)
y = tf.placeholder(tf.float32)

loss = model(x, y)

train_op = tf.train.AdamOptimizer(0.1).minimize(
    tf.reduce_mean(loss))

def generate_data():
    x_val = np.random.uniform(-10.0, 10.0, size=100)
    y_val = 5 * np.square(x_val) + 3
    return x_val, y_val

sess = tf.Session()
sess.run(tf.global_variables_initializer())
for _ in range(1000):
    x_val, y_val = generate_data()
    _, loss_val = sess.run([train_op, loss], {x: x_val, y: y_val})

_, loss_val = sess.run([train_op, loss], {x: x_val, y: y_val})
print(sess.run(tf.contrib.framework.get_variables_by_name("w")))
```

现在让我们使用我们刚刚编写的`make_parallel`来并行化它。我们只需要从上面的代码中更改两行代码：

```py
loss = make_parallel(model, 2, x=x, y=y)

train_op = tf.train.AdamOptimizer(0.1).minimize(
    tf.reduce_mean(loss),
    colocate_gradients_with_ops=True)
```

为了更改为梯度的并行化反向传播，我们需要的唯一的东西是，将`colocate_gradients_with_ops`标志设置为`True`。这可确保梯度操作和原始操作在相同的设备上运行。

## 十一、调试 TensorFlow 模型

与常规 python 代码相比，TensorFlow 的符号性质使调试 TensorFlow 代码变得相对困难。 在这里，我们介绍 TensorFlow 的一些附带工具，使调试更容易。

使用 TensorFlow 时可能出现的最常见错误，可能是将形状错误的张量传递给操作。 许多 TensorFlow 操作可以操作不同维度和形状的张量。 这在使用 API 时很方便，但在出现问题时可能会导致额外的麻烦。

例如，考虑`tf.matmul`操作，它可以相乘两个矩阵：

```py
a = tf.random_uniform([2, 3])
b = tf.random_uniform([3, 4])
c = tf.matmul(a, b)  # c is a tensor of shape [2, 4]
```


但同样的函数也可以进行批量矩阵乘法：

```py
a = tf.random_uniform([10, 2, 3])
b = tf.random_uniform([10, 3, 4])
tf.matmul(a, b)  # c is a tensor of shape [10, 2, 4]
```

我们之前在广播部分谈到的另一个例子，是支持广播的加法操作：

```py
a = tf.constant([[1.], [2.]])
b = tf.constant([1., 2.])
c = a + b  # c is a tensor of shape [2, 2]
```

### 使用`tf.assert*`操作验证你的张量

减少不必要行为的可能性的一种方法，是使用`tf.assert*`操作，明确验证中间张量的维度或形状。

```py
a = tf.constant([[1.], [2.]])
b = tf.constant([1., 2.])
check_a = tf.assert_rank(a, 1)  # This will raise an InvalidArgumentError exception
check_b = tf.assert_rank(b, 1)
with tf.control_dependencies([check_a, check_b]):
    c = a + b  # c is a tensor of shape [2, 2]
```

请记住，断言节点像其他操作一样，是图形的一部分，如果不进行求值，则会在`Session.run()`期间进行修剪。 因此，请确保为断言操作创建显式依赖，来强制 TensorFlow 执行它们。

你还可以使用断言，在运行时验证张量的值：

```py
check_pos = tf.assert_positive(a)
```

[断言操作的完整列表](https://www.tensorflow.org/api_guides/python/check_ops)请见官方文档。

### 使用`tf.Print`记录张量的值

用于调试的另一个有用的内置函数是`tf.Print`，它将给定的张量记录到标准错误：

```py
input_copy = tf.Print(input, tensors_to_print_list)
```

请注意，`tf.Print`返回第一个参数的副本作为输出。强制`tf.Print`运行的一种方法，是将其输出传递给另一个执行的操作。 例如，如果我们想在添加张量`a`和`b`之前，打印它们的值，我们可以这样做：

```py
a = ...
b = ...
a = tf.Print(a, [a, b])
c = a + b
```

或者，我们可以手动定义控制依赖。

### 使用`tf.compute_gradient_error`检查梯度

TensorFlow 中并非所有操作都带有梯度，并且很容易在无意中构建 TensorFlow 无法计算梯度的图形。

我们来看一个例子：

```py
import tensorflow as tf

def non_differentiable_entropy(logits):
    probs = tf.nn.softmax(logits)
    return tf.nn.softmax_cross_entropy_with_logits(labels=probs, logits=logits)

w = tf.get_variable("w", shape=[5])
y = -non_differentiable_entropy(w)

opt = tf.train.AdamOptimizer()
train_op = opt.minimize(y)

sess = tf.Session()
sess.run(tf.global_variables_initializer())
for i in range(10000):
    sess.run(train_op)

print(sess.run(tf.nn.softmax(w)))
```

我们使用`tf.nn.softmax_cross_entropy_with_logits`来定义类别分布的熵。然后我们使用 Adam 优化器来找到具有最大熵的权重。如果你通过了信息论课程，你就会知道均匀分布的熵最大。 所以你期望结果是`[0.2,0.2,0.2,0.2,0.2]`。 但如果你运行这个，你可能会得到意想不到的结果：

```py
[ 0.34081486  0.24287023  0.23465775  0.08935683  0.09230034]
```

事实证明，`tf.nn.softmax_cross_entropy_with_logits`的梯度对标签是未定义的！ 但如果我们不知道，我们怎么能发现它？

幸运的是，TensorFlow 带有一个数值微分器，可用于查找符号梯度误差。 让我们看看我们如何使用它：

```py
with tf.Session():
    diff = tf.test.compute_gradient_error(w, [5], y, [])
    print(diff)
```

如果你运行它，你会发现数值和符号梯度之间的差异非常大（在我的尝试中为`0.06 - 0.1`）。

现在让我们使用熵的可导版本，来修复我们的函数并再次检查：

```py
import tensorflow as tf
import numpy as np

def entropy(logits, dim=-1):
    probs = tf.nn.softmax(logits, dim)
    nplogp = probs * (tf.reduce_logsumexp(logits, dim, keep_dims=True) - logits)
    return tf.reduce_sum(nplogp, dim)

w = tf.get_variable("w", shape=[5])
y = -entropy(w)

print(w.get_shape())
print(y.get_shape())

with tf.Session() as sess:
    diff = tf.test.compute_gradient_error(w, [5], y, [])
    print(diff)
```

差应该约为 0.0001，看起来好多了。

现在，如果再次使用正确的版本运行优化器，你可以看到最终权重为：

```py
[ 0.2  0.2  0.2  0.2  0.2]
```

这正是我们想要的。

[TensorFlow 摘要](https://www.tensorflow.org/api_guides/python/summary)和 [tfdbg（TensorFlow 调试器）](https://www.tensorflow.org/api_guides/python/tfdbg)是可用于调试的其他工具。 请参阅官方文档来了解更多信息。

## 十二、TensorFlow 中的数值稳定性

当使用任何数值计算库（如 NumPy 或 TensorFlow）时，重要的是要注意，编写数学上正确的代码并不一定能产生正确的结果。 你还需要确保计算稳定。

让我们从一个简单的例子开始吧。 从小学我们知道`x * y / y`等于`x`的任何非零值。 但是，让我们看看在实践中是否总是如此：

```py
import numpy as np

x = np.float32(1)

y = np.float32(1e-50)  # y would be stored as zero
z = x * y / y

print(z)  # prints nan
```

结果不正确的原因是`y`对于`float32`类型来说太小了。当`y`太大时会出现类似的问题：

```py
y = np.float32(1e39)  # y would be stored as inf
z = x * y / y

print(z)  # prints 0
```

`float32`类型可以表示的最小正值是`1.4013e-45`，低于该值的任何值都将存储为零。 此外，任何超过`3.40282e+38`的数字都将存储为`inf`。

```py
print(np.nextafter(np.float32(0), np.float32(1)))  # prints 1.4013e-45
print(np.finfo(np.float32).max)  # print 3.40282e+38
```

为确保计算稳定，你需要避免使用绝对值非常小或大的值。这可能听起来非常明显，但这些问题可能变得非常难以调试，尤其是在 TensorFlow 中进行梯度下降时。这是因为你不仅需要确保正向传播中的所有值都在数据类型的有效范围内，而且还需要确保反向传播也相同（在梯度计算期间）。

让我们看一个真实的例子。 我们想要在`logits`向量上计算 softmax。 一个朴素的实现看起来像这样：

```py
import tensorflow as tf

def unstable_softmax(logits):
    exp = tf.exp(logits)
    return exp / tf.reduce_sum(exp)

tf.Session().run(unstable_softmax([1000., 0.]))  # prints [ nan, 0.]
```

请注意，计算`logits`中相对较小数字的指数会产生浮点范围之外的巨大结果。 我们的初始 softmax 实现的最大有效`logit`是`ln(3.40282e + 38）= 88.7`，除此之外的任何东西都会产生`nan`结果。

但是我们怎样才能让它更稳定呢？ 解决方案相当简单。 很容易看出`exp(x - c)/Σexp(x - c)= exp(x)/Σexp(x)`。 因此，我们可以从`logits`中减去任何常量，结果将保持不变。 我们选择此常量作为`logits`的最大值。 这样，指数函数的定义域将被限制为`[-inf，0]`，因此其值域将是`[0.0,1.0]`，这是预期的：

```py
import tensorflow as tf

def softmax(logits):
    exp = tf.exp(logits - tf.reduce_max(logits))
    return exp / tf.reduce_sum(exp)

tf.Session().run(softmax([1000., 0.]))  # prints [ 1., 0.]
```

让我们来看一个更复杂的案例。 考虑一下我们的分类问题。 我们使用 softmax 函数从我们的`logits`中产生概率。 然后，我们将损失函数定义为，我们的预测和标签之间的交叉熵。回想一下，分类分布的交叉熵可以简单地定义为`xe(p, q) = -∑ p_i log(q_i)`。 所以交叉熵的朴素实现看起来像这样：

```py
def unstable_softmax_cross_entropy(labels, logits):
    logits = tf.log(softmax(logits))
    return -tf.reduce_sum(labels * logits)

labels = tf.constant([0.5, 0.5])
logits = tf.constant([1000., 0.])

xe = unstable_softmax_cross_entropy(labels, logits)

print(tf.Session().run(xe))  # prints inf
```

注意，在此实现中，当 softmax 输出接近零时，`log`的输出接近无穷大，这导致我们的计算不稳定。 我们可以通过扩展 softmax 并进行一些简化来重写它：

```py
def softmax_cross_entropy(labels, logits):
    scaled_logits = logits - tf.reduce_max(logits)
    normalized_logits = scaled_logits - tf.reduce_logsumexp(scaled_logits)
    return -tf.reduce_sum(labels * normalized_logits)

labels = tf.constant([0.5, 0.5])
logits = tf.constant([1000., 0.])

xe = softmax_cross_entropy(labels, logits)

print(tf.Session().run(xe))  # prints 500.0
```

我们还可以验证梯度是否也计算正确：

```py
g = tf.gradients(xe, logits)
print(tf.Session().run(g))  # prints [0.5, -0.5]
```

是正确的。

让我再次提醒一下，在进行梯度下降时必须格外小心，来确保函数范围以及每层的梯度都在有效范围内。 指数和对数函数在朴素使用时尤其成问题，因为它们可以将小数字映射到大数字，反之亦然。

## 十三、使用学习 API 构建神经网络训练框架

为简单起见，在这里的大多数示例中，我们手动创建会话，我们不关心保存和加载检查点，但这不是我们通常在实践中做的事情。你最有可能希望使用学习 API 来处理会话管理和日志记录。 我们提供了一个简单但实用的框架，用于使用 TensorFlow 训练神经网络。在本节中，我们将解释此框架的工作原理。

在试验神经网络模型时，你通常需要进行训练/测试分割。你希望在训练集上训练你的模型，之后在测试集上评估它并计算一些指标。你还需要将模型参数存储为检查点，理想情况下，你希望能够停止和恢复训练。TensorFlow 的学习 API 旨在使这项工作更容易，让我们专注于开发实际模型。

使用`tf.learn` API 的最基本方法是直接使用`tf.Estimator`对象。 你需要定义模型函数，它定义了损失函数，训练操作，一个或一组预测，以及一组用于求值的可选的指标操作：

```py
import tensorflow as tf

def model_fn(features, labels, mode, params):
    predictions = ...
    loss = ...
    train_op = ...
    metric_ops = ...
    return tf.estimator.EstimatorSpec(
        mode=mode,
        predictions=predictions,
        loss=loss,
        train_op=train_op,
        eval_metric_ops=metric_ops)

params = ...
run_config = tf.contrib.learn.RunConfig(model_dir=FLAGS.output_dir)
estimator = tf.estimator.Estimator(
    model_fn=model_fn, config=run_config, params=params)
```

要训练模型，你只需调用`Estimator.train(0`函数，同时提供读取数据的输入函数。

```py
def input_fn():
    features = ...
    labels = ...
    return features, labels

estimator.train(input_fn=input_fn, max_steps=...)
```

要评估模型，只需调用`Estimator.evaluate()`：

```py
estimator.evaluate(input_fn=input_fn)
```

对于简单的情况，`Estimator`对象可能已经足够好了，但 TensorFlow 提供了一个名为`Experiment`的更高级别的对象，它提供了一些额外的有用功能。创建实验对象非常简单：

```py
experiment = tf.contrib.learn.Experiment(
    estimator=estimator,
    train_input_fn=train_input_fn,
    eval_input_fn=eval_input_fn,
    eval_metrics=eval_metrics)
```

现在我们可以调用`train_and_evaluate`函数来计算训练时的指标。

```py
experiment.train_and_evaluate()
```

更高级别的运行实验的方法，是使用`learn_runner.run()`函数。以下是我们的主函数在提供的框架中的样子：

```py
import tensorflow as tf

tf.flags.DEFINE_string("output_dir", "", "Optional output dir.")
tf.flags.DEFINE_string("schedule", "train_and_evaluate", "Schedule.")
tf.flags.DEFINE_string("hparams", "", "Hyper parameters.")

FLAGS = tf.flags.FLAGS

def experiment_fn(run_config, hparams):
  estimator = tf.estimator.Estimator(
    model_fn=make_model_fn(), config=run_config, params=hparams)
  return tf.contrib.learn.Experiment(
    estimator=estimator,
    train_input_fn=make_input_fn(tf.estimator.ModeKeys.TRAIN, hparams),
    eval_input_fn=make_input_fn(tf.estimator.ModeKeys.EVAL, hparams),
    eval_metrics=eval_metrics_fn(hparams))

def main(unused_argv):
  run_config = tf.contrib.learn.RunConfig(model_dir=FLAGS.output_dir)
  hparams = tf.contrib.training.HParams()
  hparams.parse(FLAGS.hparams)

  estimator = tf.contrib.learn.learn_runner.run(
    experiment_fn=experiment_fn,
    run_config=run_config,
    schedule=FLAGS.schedule,
    hparams=hparams)

if __name__ == "__main__":
  tf.app.run()
```

`schedule`标志决定调用`Experiment`对象的哪个成员函数。 因此，如果你将`schedule`设置为`train_and_evaluate`，则会调用`experiment.train_and_evaluate()`。

输入函数可以返回两个张量（或张量的字典），提供要传递给模型的特征和标签。

```py
def input_fn():
    features = ...
    labels = ...
    return features, labels
```

对于如何使用数据集 API 读取数据的示例，请参阅[`mnist.py`](https://github.com/vahidk/TensorflowFramework/blob/master/dataset/mnist.py)。要了解在 TensorFlow 中阅读数据的各种方法，请参阅[这里](https://yiyibooks.cn/__trs__/wizard/effective-tf/13.html#data)。

该框架还附带了一个简单的卷积网络分类器，在[`cnn_classifier.py`](https://github.com/vahidk/TensorflowFramework/blob/master/model/cnn_classifier.py)中，其中包含一个示例模型。

就是这样！ 这就是开始使用 TensorFlow 学习 API 所需的全部内容。我建议你查看框架[源代码](https://github.com/vahidk/TensorFlowFramework)并查看官方 python API 来了解学习 API 的更多信息。

## 十四、TensorFlow 秘籍

本节包括在 TensorFlow 中实现的一组常用操作。

### 集束搜索

```py
import tensorflow as tf

def get_shape(tensor):
  """Returns static shape if available and dynamic shape otherwise."""
  static_shape = tensor.shape.as_list()
  dynamic_shape = tf.unstack(tf.shape(tensor))
  dims = [s[1] if s[0] is None else s[0]
          for s in zip(static_shape, dynamic_shape)]
  return dims

def log_prob_from_logits(logits, axis=-1):
  """Normalize the log-probabilities so that probabilities sum to one."""
  return logits - tf.reduce_logsumexp(logits, axis=axis, keep_dims=True)

def batch_gather(tensor, indices):
  """Gather in batch from a tensor of arbitrary size.

  In pseudocode this module will produce the following:
  output[i] = tf.gather(tensor[i], indices[i])

  Args:
    tensor: Tensor of arbitrary size.
    indices: Vector of indices.
  Returns:
    output: A tensor of gathered values.
  """
  shape = get_shape(tensor)
  flat_first = tf.reshape(tensor, [shape[0] * shape[1]] + shape[2:])
  indices = tf.convert_to_tensor(indices)
  offset_shape = [shape[0]] + [1] * (indices.shape.ndims - 1)
  offset = tf.reshape(tf.range(shape[0]) * shape[1], offset_shape)
  output = tf.gather(flat_first, indices + offset)
  return output

def rnn_beam_search(update_fn, initial_state, sequence_length, beam_width,
                    begin_token_id, end_token_id, name="rnn"):
  """Beam-search decoder for recurrent models.

  Args:
    update_fn: Function to compute the next state and logits given the current
               state and ids.
    initial_state: Recurrent model states.
    sequence_length: Length of the generated sequence.
    beam_width: Beam width.
    begin_token_id: Begin token id.
    end_token_id: End token id.
    name: Scope of the variables.
  Returns:
    ids: Output indices.
    logprobs: Output log probabilities probabilities.
  """
  batch_size = initial_state.shape.as_list()[0]

  state = tf.tile(tf.expand_dims(initial_state, axis=1), [1, beam_width, 1])

  sel_sum_logprobs = tf.log([[1.] + [0.] * (beam_width - 1)])

  ids = tf.tile([[begin_token_id]], [batch_size, beam_width])
  sel_ids = tf.expand_dims(ids, axis=2)

  mask = tf.ones([batch_size, beam_width], dtype=tf.float32)

  for i in range(sequence_length):
    with tf.variable_scope(name, reuse=True if i > 0 else None):

      state, logits = update_fn(state, ids)
      logits = log_prob_from_logits(logits)

      sum_logprobs = (
          tf.expand_dims(sel_sum_logprobs, axis=2) +
          (logits * tf.expand_dims(mask, axis=2)))

      num_classes = logits.shape.as_list()[-1]

      sel_sum_logprobs, indices = tf.nn.top_k(
          tf.reshape(sum_logprobs, [batch_size, num_classes * beam_width]),
          k=beam_width)

      ids = indices % num_classes

      beam_ids = indices // num_classes

      state = batch_gather(state, beam_ids)

      sel_ids = tf.concat([batch_gather(sel_ids, beam_ids),
                           tf.expand_dims(ids, axis=2)], axis=2)

      mask = (batch_gather(mask, beam_ids) *
              tf.to_float(tf.not_equal(ids, end_token_id)))

  return sel_ids, sel_sum_logprobs
```

### 合并

```py
import tensorflow as tf

def merge(tensors, units, activation=tf.nn.relu, name=None, **kwargs):
  """Merge features with broadcasting support.

  This operation concatenates multiple features of varying length and applies
  non-linear transformation to the outcome.

  Example:
    a = tf.zeros([m, 1, d1])
    b = tf.zeros([1, n, d2])
    c = merge([a, b], d3)  # shape of c would be [m, n, d3].

  Args:
    tensors: A list of tensor with the same rank.
    units: Number of units in the projection function.
  """
  with tf.variable_scope(name, default_name="merge"):
    # Apply linear projection to input tensors.
    projs = []
    for i, tensor in enumerate(tensors):
      proj = tf.layers.dense(
          tensor, units, activation=None,
          name="proj_%d" % i,
          **kwargs)
      projs.append(proj)

    # Compute sum of tensors.
    result = projs.pop()
    for proj in projs:
      result = result + proj

    # Apply nonlinearity.
    if activation:
      result = activation(result)
  return result
```

### 熵

```py
import tensorflow as tf

def softmax(logits, dims=-1):
  """Compute softmax over specified dimensions."""
  exp = tf.exp(logits - tf.reduce_max(logits, dims, keep_dims=True))
  return exp / tf.reduce_sum(exp, dims, keep_dims=True)

def entropy(logits, dims=-1):
  """Compute entropy over specified dimensions."""
  probs = softmax(logits, dims)
  nplogp = probs * (tf.reduce_logsumexp(logits, dims, keep_dims=True) - logits)
  return tf.reduce_sum(nplogp, dims)
```

### KL 散度

```py
def gaussian_kl(q, p=(0., 0.)):
  """Computes KL divergence between two isotropic Gaussian distributions.

  To ensure numerical stability, this op uses mu, log(sigma^2) to represent
  the distribution. If q is not provided, it's assumed to be unit Gaussian.

  Args:
    q: A tuple (mu, log(sigma^2)) representing a multi-variatie Gaussian.
    p: A tuple (mu, log(sigma^2)) representing a multi-variatie Gaussian.
  Returns:
    A tensor representing KL(q, p).
  """
  mu1, log_sigma1_sq = q
  mu2, log_sigma2_sq = p
  return tf.reduce_sum(
    0.5 * (log_sigma2_sq - log_sigma1_sq +
           tf.exp(log_sigma1_sq - log_sigma2_sq) +
           tf.square(mu1 - mu2) / tf.exp(log_sigma2_sq) -
           1), axis=-1)
```

### 并行化

```py
def make_parallel(fn, num_gpus, **kwargs):
  """Parallelize given model on multiple gpu devices.

  Args:
    fn: Arbitrary function that takes a set of input tensors and outputs a
        single tensor. First dimension of inputs and output tensor are assumed
        to be batch dimension.
    num_gpus: Number of GPU devices.
    **kwargs: Keyword arguments to be passed to the model.
  Returns:
    A tensor corresponding to the model output.
  """
  in_splits = {}
  for k, v in kwargs.items():
    in_splits[k] = tf.split(v, num_gpus)

  out_split = []
  for i in range(num_gpus):
    with tf.device(tf.DeviceSpec(device_type="GPU", device_index=i)):
      with tf.variable_scope(tf.get_variable_scope(), reuse=i > 0):
        out_split.append(fn(**{k : v[i] for k, v in in_splits.items()}))

  return tf.concat(out_split, axis=0)
```
