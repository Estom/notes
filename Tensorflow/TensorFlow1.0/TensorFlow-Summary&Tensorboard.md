## tensorflow 数据可视化

> tf.summary

> 在TensorFlow中，最常用的可视化方法有三种途径，分别为TensorFlow与OpenCv的混合编程、利用Matpltlib进行可视化、利用TensorFlow自带的可视化工具TensorBoard进行可视化。

### 原理介绍

tf.summary中相关的方法会输出一个含tensor的Summary protocol buffer，这是一种能够被tensorboard模块解析的结构化数据格式。

protocol buffer(protobuf)是谷歌专用的数据序列化工具。速度更快，但格式要求更严格，应用范围可能更小。


### 用法详解
##### 1. tf.summary.scalar

用来显示标量信息：
```
tf.summary.scalar(tags, values, collections=None, name=None)
例如：tf.summary.scalar('mean', mean)
一般在画loss,accuary时会用到这个函数。
```

参数说明：
* name:生成节点的名字，也会作为TensorBoard中的系列的名字。
* tensor:包含一个值的实数Tensor。
* collection：图的集合键值的可选列表。新的求和op被添加到这个集合中。缺省为[GraphKeys.SUMMARIES]
* family:可选项；设置时用作求和标签名称的前缀，这影响着TensorBoard所显示的标签名。

主要用途：
* 将【计算图】中的【标量数据】写入TensorFlow中的【日志文件】，以便为将来tensorboard的可视化做准备。
* 一般在画loss曲线和accuary曲线时会用到这个函数。


##### 2. tf.summary.histogram

用来显示直方图信息，其格式为：
```
tf.summary.histogram(tags, values, collections=None, name=None) 
例如： tf.summary.histogram('histogram', var)
一般用来显示训练过程中变量的分布情况
```
参数说明：
* name :一个节点的名字，如下图红色矩形框所示
* values:要可视化的数据，可以是任意形状和大小的数据

主要用途：
* 将【计算图】中的【数据的分布/数据直方图】写入TensorFlow中的【日志文件】，以便为将来tensorboard的可视化做准备
* 一般用来显示训练过程中变量的分布情况


##### 3. tf.summary.distribution
分布图，一般用于显示weights分布

##### 4. tf.summary.text
可以将文本类型的数据转换为tensor写入summary中：

```
text = """/a/b/c\\_d/f\\_g\\_h\\_2017"""
summary_op0 = tf.summary.text('text', tf.convert_to_tensor(text))
```
##### 5. tf.summary.image

输出带图像的probuf，汇总数据的图像的的形式如下： ' tag /image/0', ' tag /image/1'...，如：input/image/0等。

```
tf.summary.image(tag, tensor, max_images=3, collections=None, name=None)
```
参数说明：

* name :一个节点的名字，如下图红色矩形框所示
* tensor:要可视化的图像数据，一个四维的张量，元素类型为uint8或者float32，维度为[batch_size, height,width, channels]
* max_outputs:输出的通道数量，可以结合下面的示例代码进行理解

主要用途：
* 将【计算图】中的【图像数据】写入TensorFlow中的【日志文件】，以便为将来tensorboard的可视化做准备
* 输出一个包含图像的summary,这个图像是通过一个4维张量构建的，这个张量的四个维度如下所示：[batch_size,height, width, channels]
* 其中参数channels有三种取值：  

    1: tensor is interpreted as Grayscale,如果为1，那么这个张量被解释为灰度图像  
    3: tensor is interpreted as RGB,如果为3，那么这个张量被解释为RGB彩色图像  
    4: tensor is interpreted as Grayscale,如果为4，那么这个张量被解释为RGBA四通道图

##### 6. tf.summary.audio

展示训练过程中记录的音频 

##### 7. tf.summary.merge_all

merge_all 可以将所有summary全部保存到磁盘，以便tensorboard显示。如果没有特殊要求，一般用这一句就可一显示训练时的各种信息了。

```
tf.summaries.merge_all(key='summaries')
```
参数说明：

* key : 用于收集summaries的GraphKey，默认的为GraphKeys.SUMMARIES
* scope：可选参数


函数说明：

* 将之前定义的所有summary整合在一起
* 和TensorFlow中的其他操作类似，tf.summary.scalar、tf.summary.histogram、tf.summary.image函数也是一个op，它们在定义的时候，也不会立即执行，需要通过sess.run来明确调用这些函数。因为，在一个程序中定义的写日志操作比较多，如果一一调用，将会十分麻烦，所以Tensorflow提供了tf.summary.merge_all()函数将所有的summary整理在一起。在TensorFlow程序执行的时候，只需要运行这一个操作就可以将代码中定义的所有【写日志操作】执行一次，从而将所有的日志写入【日志文件】。



##### 8. tf.summary.FileWriter

指定一个文件用来保存图。可以调用其add_summary（）方法将训练过程数据保存在filewriter指定的文件中

```
tf.summary.FileWritter(path,sess.graph)
```

Tensorflow Summary 用法示例:

```
tf.summary.scalar('accuracy',acc)                   #生成准确率标量图  
merge_summary = tf.summary.merge_all()  
train_writer = tf.summary.FileWriter(dir,sess.graph)#定义一个写入summary的目标文件，dir为写入文件地址  
......(交叉熵、优化器等定义)  
for step in xrange(training_step):                  #训练循环  
    train_summary = sess.run(merge_summary,feed_dict =  {...})#调用sess.run运行图，生成一步的训练过程数据  
    train_writer.add_summary(train_summary,step)#调用train_writer的add_summary方法将训练过程以及训练步数保存  
```
此时开启tensorborad：
```
tensorboard --logdir=/summary_dir 
```
便能看见accuracy曲线了。

##### 9. tf.summary.merge

可以调用其add_summary（）方法将训练过程数据保存在filewriter指定的文件中
```
tf.summary.merge(inputs, collections=None, name=None)
```
一般选择要保存的信息还需要用到tf.get_collection()函数

```
tf.summary.scalar('accuracy',acc)                   #生成准确率标量图  
merge_summary = tf.summary.merge([tf.get_collection(tf.GraphKeys.SUMMARIES,'accuracy'),...(其他要显示的信息)])  
train_writer = tf.summary.FileWriter(dir,sess.graph)#定义一个写入summary的目标文件，dir为写入文件地址  
......(交叉熵、优化器等定义)  
for step in xrange(training_step):                  #训练循环  
    train_summary = sess.run(merge_summary,feed_dict =  {...})#调用sess.run运行图，生成一步的训练过程数据  
    train_writer.add_summary(train_summary,step)#调用train_writer的add_summary方法将训练过程以及训练步数保存  
```

使用tf.get_collection函数筛选图中summary信息中的accuracy信息，这里的

tf.GraphKeys.SUMMARIES  是summary在collection中的标志。

当然，也可以直接：
```
acc_summary = tf.summary.scalar('accuracy',acc)                   #生成准确率标量图  
merge_summary = tf.summary.merge([acc_summary ,...(其他要显示的信息)])  #这里的[]不可省
```
 如果要在tensorboard中画多个数据图，需定义多个tf.summary.FileWriter并重复上述过程。


### 步骤说明

* summary记录的tensor
* 使用merge_all或者merge函数收集所有的summary
* 定制summary的存储对象
* 运行summary，按照训练步骤，传入测试数据，提取summary的值
* 最后将summary的结果添加到日志当中

> 如果目标网址不行可以尝试localhost:6006

### 代码示例
```
import tensorflow as tf
import tensorflow.examples.tutorials.mnist.input_data as input_data
mnist = input_data.read_data_sets("MNIST_data/", one_hot=True)
# 也能成功运行了

x_data = tf.placeholder("float32",[None,784])
# x_data = tf.placeholder("float32",[100,784])

weight = tf.Variable(tf.ones([784,10]))
bias = tf.Variable(tf.ones([10]))
y_model = tf.nn.softmax(tf.matmul(x_data,weight)+bias)
y_data = tf.placeholder("float32",[None,10])
# y_data = tf.placeholder("float32",[100,10])

loss = tf.reduce_sum(tf.pow((y_model-y_data),2))

train_step = tf.train.GradientDescentOptimizer(0.01).minimize(loss)

init = tf.initialize_all_variables()
sess = tf.Session()
sess.run(fetches=init)

# 用来显示loss
tf.summary.scalar("loss",loss)

# 用来计算准确度
correct_prediction = tf.equal(tf.argmax(y_model, 1), tf.argmax(y_data, 1))
accuracy = tf.reduce_mean(tf.cast(correct_prediction, "float"))
summary_acc = tf.summary.scalar("acc", accuracy)

# 用来显示weight的训练过程
tf.summary.histogram("weight",weight)

# 用来显示bias的训练过程
tf.summary.histogram("bias",bias)

# 用来将所有的summary收集起来
summary_merge = tf.summary.merge_all()
# 定义了一个文件读写对象，用来写入summary的probuf到文件当中
summary_writer = tf.summary.FileWriter('mnist_logs', sess.graph)


for _ in range(100):
    batch_xs, batch_ys = mnist.train.next_batch(100)
    sess.run(train_step,feed_dict={x_data:batch_xs,y_data:batch_ys})
    # 调用sess.run运行图，生成一步的训练过程数据
    summary_trian = sess.run(summary_merge, feed_dict={x_data:mnist.test.images,y_data:mnist.test.labels})
    # 调用train_writer的add_summary方法将训练过程以及训练步数保存
    summary_writer.add_summary(summary_trian, _)


```

# 网上的一份不错的代码
```
 1 import tensorflow as tf
 2 import numpy as np
 3 
 4 ## prepare the original data
 5 with tf.name_scope('data'):
 6      x_data = np.random.rand(100).astype(np.float32)
 7      y_data = 0.3*x_data+0.1
 8 ##creat parameters
 9 with tf.name_scope('parameters'):
10      with tf.name_scope('weights'):
11             weight = tf.Variable(tf.random_uniform([1],-1.0,1.0))
12            tf.summary.histogram('weight',weight)
13      with tf.name_scope('biases'):
14            bias = tf.Variable(tf.zeros([1]))
15            tf.summary.histogram('bias',bias)
16 ##get y_prediction
17 with tf.name_scope('y_prediction'):
18      y_prediction = weight*x_data+bias
19 ##compute the loss
20 with tf.name_scope('loss'):
21      loss = tf.reduce_mean(tf.square(y_data-y_prediction))
22      tf.summary.scalar('loss',loss)
23 ##creat optimizer
24 optimizer = tf.train.GradientDescentOptimizer(0.5)
25 #creat train ,minimize the loss 
26 with tf.name_scope('train'):
27      train = optimizer.minimize(loss)
28 #creat init
29 with tf.name_scope('init'): 
30      init = tf.global_variables_initializer()
31 ##creat a Session 
32 sess = tf.Session()
33 #merged
34 merged = tf.summary.merge_all()
35 ##initialize
36 writer = tf.summary.FileWriter("logs/", sess.graph)
37 sess.run(init)
38 ## Loop
39 for step  in  range(101):
40     sess.run(train)
41     rs=sess.run(merged)
42     writer.add_summary(rs, step)
```
