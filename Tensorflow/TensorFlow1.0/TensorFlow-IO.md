## TensorFlow - IO

> 在 tf.data 之前，一般使用 QueueRunner，但 QueueRunner 基于 Python 的多线程及队列等，效率不够高，所以 Google发布了tf.data，其基于C++的多线程及队列，彻底提高了效率。所以不建议使用 QueueRunner 了，取而代之，使用 tf.data 模块吧：简单、高效。


### preload

直接将数据设置为常量，加载到TensorFlow的graph中。
```
import tensorflow as tf
x1 = tf.constant([2,3,4])
x2 = tf.constant([4,0,1])

y = tf.add(x1,x2)

with tf.Session() as sess:
    print(sess.run(y))
```

### feed_dict

使用Python代码获取数据，通过给run()或者eval()函数输入feed_dict参数，传入数据，可以启动运算过程。

```
with tf.Session():
  input = tf.placeholder(tf.float32)
  classifier = ...
  print classifier.eval(feed_dict={input: my_python_preprocessing_fn()})
```
或者通过sess.run的feed参数
```
with tf.Session() as sess:
  result = sess.run(fetches=[mul, intermed],feed_dict={x1:inputX,y:outputY})
  print(result)
```
### FileRead & QueueRuuner

> 基于队列（Queue）API构建输入通道（pipelines）,读取文件中的数据

##### 原理介绍

* 使用字符串张量(比如["file0", "file1"]) 或者tf.train.match_filenames_once 函数来产生文件名列表。
* 文件名打乱（可选）（Optional filename shuffling）。
* epoch限制（可选）（Optional epoch limit）
* tf.train.string_input_producer 函数.string_input_producer来生成一个先入先出的文件名队列。
* 将文件名队列提供给阅读器Reader的read方法。文件阅读器来读取数据。需要根据不同的文件内容选取不同的文件格式。
* decoder（A decoder for a record read by the reader）
* 预处理（可选）（Optional preprocessing）。然后你可以对examples进行你想要的预处理（preprocessing）。预处理是独立的（不依赖于模型参数）。常见的预处理有：数据的标准化（normalization of your data）、挑选一个随机的切片，添加噪声（noise）或者畸变（distortions）等。
* 在pipeline的末端，我们通过调用 tf.train.shuffle_batch 来创建两个queue，一个将example batch起来 for training、evaluation、inference；另一个来shuffle examples的顺序。

##### 文件列表和文件队列生成

可以使用字符串张量(比如["file0", "file1"], [("file%d" % i) for i in range(2)]， [("file%d" % i) for i in range(2)]) 或者tf.train.match_filenames_once 函数来产生文件名列表。

将文件名列表交给tf.train.string_input_producer 函数.string_input_producer来生成一个先入先出的队列， 文件阅读器会需要它来读取数据。

string_input_producer 提供的可配置参数来设置文件名乱序和最大的训练迭代数， QueueRunner会为每次迭代(epoch)将所有的文件名加入文件名队列中， 如果shuffle=True的话， 会对文件名进行乱序处理。这一过程是比较均匀的，因此它可以产生均衡的文件名队列。

##### CSV 文件读取
使用步骤：
* 使用textLineReader()阅读器。读取文件名队列
* 使用decode_csv()对内容解析

过程介绍：

read 方法每执行一次，会从文件中读取一行。然后 decode_csv 将读取的内容解析成一个Tensor列表。参数 record_defaults 决定解析产生的Tensor的类型，另外，如果输入中有缺失值，则用record_defaults 指定的默认值来填充。

在使用run或者eval 执行 read 方法前，你必须调用 tf.train.start_queue_runners 去填充 queue。否则，read 方法将会堵塞（等待 filenames queue 中 enqueue 文件名）。

代码示例：
```
filename_queue = tf.train.string_input_producer(["file0.csv", "file1.csv"])

reader = tf.TextLineReader()
key, value = reader.read(filename_queue)

# Default values, in case of empty columns. Also specifies the type of the
# decoded result.
record_defaults = [[1], [1], [1], [1], [1]]
col1, col2, col3, col4, col5 = tf.decode_csv(
    value, record_defaults=record_defaults)
features = tf.concat(0, [col1, col2, col3, col4])

with tf.Session() as sess:
  # Start populating the filename queue.
  coord = tf.train.Coordinator()
  threads = tf.train.start_queue_runners(coord=coord)

  for i in range(1200):
    # Retrieve a single instance:
    example, label = sess.run([features, col5])

  coord.request_stop()
  coord.join(threads)
```
##### bin文件读取

使用步骤：

* 使用一个 tf.FixedLengthRecordReader进行读取。
* tf.decode_raw进行解析。解析成一个uint8 tensor。

使用过程：
the CIFAR-10 dataset的文件格式定义是：每条记录的长度都是固定的，一个字节的标签，后面是3072字节的图像数据。uint8的张量的标准操作就可以从中获取图像片并且根据需要进行重组。


##### tfrecord文件读取(Standard TensorFlow format)

使用步骤：

* 使用tf.TFRecordReader()进行读取
* 使用decode()函数进行解析

使用过程：

另一种保存记录的方法可以允许你讲任意的数据转换为TensorFlow所支持的格式， 这种方法可以使TensorFlow的数据集更容易与网络应用架构相匹配。这种建议的方法就是使用TFRecords文件，TFRecords文件包含了tf.train.Example 协议内存块(protocol buffer)(协议内存块包含了字段 Features)。你可以写一段代码获取你的数据， 将数据填入到Example协议内存块(protocol buffer)，将协议内存块序列化为一个字符串， 并且通过tf.python_io.TFRecordWriter class写入到TFRecords文件。tensorflow/g3doc/how_tos/reading_data/convert_to_records.py就是这样的一个例子。

从TFRecords文件中读取数据， 可以使用tf.TFRecordReader的tf.parse_single_example解析器。这个parse_single_example操作可以将Example协议内存块(protocol buffer)解析为张量。 MNIST的例子就使用了convert_to_records 所构建的数据。 



##### 预处理

你可以对输入的样本进行任意的预处理， 这些预处理不依赖于训练参数， 你可以在tensorflow/models/image/cifar10/cifar10.py找到数据归一化， 提取随机数据片，增加噪声或失真等等预处理的例子。

##### 批处理

在数据输入管线的末端， 我们需要有另一个队列来执行输入样本的训练，评价和推理。

代码示例：
```
def read_my_file_format(filename_queue):
  reader = tf.SomeReader()
  key, record_string = reader.read(filename_queue)
  example, label = tf.some_decoder(record_string)
  processed_example = some_processing(example)
  return processed_example, label

def input_pipeline(filenames, batch_size, num_epochs=None):
  filename_queue = tf.train.string_input_producer(
      filenames, num_epochs=num_epochs, shuffle=True)
  example, label = read_my_file_format(filename_queue)
  # min_after_dequeue defines how big a buffer we will randomly sample
  #   from -- bigger means better shuffling but slower start up and more
  #   memory used.
  # capacity must be larger than min_after_dequeue and the amount larger
  #   determines the maximum we will prefetch.  Recommendation:
  #   min_after_dequeue + (num_threads + a small safety margin) * batch_size
  min_after_dequeue = 10000
  capacity = min_after_dequeue + 3 * batch_size
  example_batch, label_batch = tf.train.shuffle_batch(
      [example, label], batch_size=batch_size, capacity=capacity,
      min_after_dequeue=min_after_dequeue)
  return example_batch, label_batch
```

##### 创建线程并使用QueueRunner对象

工作原理：

使用上面列出的许多tf.train函数添加QueueRunner到你的数据流图中。在你运行任何训练步骤之前，需要调用tf.train.start_queue_runners函数，否则数据流图将一直挂起。tf.train.start_queue_runners 这个函数将会启动输入管道的线程，填充样本到队列中，以便出队操作可以从队列中拿到样本。这种情况下最好配合使用一个tf.train.Coordinator，这样可以在发生错误的情况下正确地关闭这些线程。如果你对训练迭代数做了限制，那么需要使用一个训练迭代数计数器，并且需要被初始化。

代码示例：
```
# Create the graph, etc.
init_op = tf.initialize_all_variables()

# Create a session for running operations in the Graph.
sess = tf.Session()

# Initialize the variables (like the epoch counter).
sess.run(init_op)

# Start input enqueue threads.
coord = tf.train.Coordinator()
threads = tf.train.start_queue_runners(sess=sess, coord=coord)

try:
    while not coord.should_stop():
        # Run training steps or whatever
        sess.run(train_op)

except tf.errors.OutOfRangeError:
    print 'Done training -- epoch limit reached'
finally:
    # When done, ask the threads to stop.
    coord.request_stop()

# Wait for threads to finish.
coord.join(threads)
sess.close()
```



