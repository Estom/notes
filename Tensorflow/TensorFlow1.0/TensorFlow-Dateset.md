导入数据（Reading data）
上一篇介绍了TensorFlow读取数据的四种方法：tf.data、Feeding、QueueRunner、Preloaded data。

推荐：如何构建高性能的输入 pipeline

本篇的内容主要介绍 tf.data API的使用

文章目录
导入数据（Reading data）
1. Dataset 的基本机制 ¶
1.1 了解 Dataset 的结构并尝试创建 Dataset ¶
1.2 了解迭代器的作用，并创建 Iterator ¶
1.3 从迭代器中读取数据 ¶
1.4 保存迭代器的状态 ¶
2. 构建 Dataset ¶
2.1 基于 NumPy 数组构建Dataset ¶
2.2 基于 tf.data.TFRecordDataset 构建 Dataset ¶
2.3 基于 tf.data.FixedLengthRecordDataset 构建 Dataset ¶
2.4 基于 tf.data.TextLineDataset 构建 Dataset ¶
2.5 基于 tf.contrib.data.CsvDataset 构建 Dataset ¶
2.5 直接从文件读取，解析数据 ¶
3. 用 Dataset.map() 进行数据预处理 ¶
3.1 从 tf.Example 中解析出数据 ¶
3.2 解码图片数据并调整其大小 / 直接从文件读取文件 ¶
3.3 基于 tf.py_func 使用 Python 函数进行预处理 ¶
4. 数据集进行 batch ¶
4.1 最简单的 batch（直接 stack） ¶
4.2 将 Tensor 填充成统一大小，然后 batch ¶
5. 训练时数据集的配置 ¶
5.1 迭代多个 epoch ¶
5.2 随机 shuffle 数据集 ¶
5.3 tf.data 和使用高阶 API 的混合使用 ¶
5.3.1 在 tf.train.MonitoredTrainingSession 中使用 tf.data ¶
5.3.2 在 tf.estimator.Estimator 中使用 tf.data ¶

基于 tf.data API，我们可以使用简单的代码来构建复杂的输入 pipeline。 （例1，从分布式文件系统中读取数据、进行预处理、合成为 batch、训练中使用数据集；例2，文本模型的输入 pipeline 需要从原始文本数据中提取符号、根据对照表将其转换为嵌入标识符，以及将不同长度的序列组合成batch数据等。） 使用 tf.data API 可以轻松处理大量数据、不同的数据格式以及复杂的转换。
tf.data API 在 TensorFlow 中引入了两个新概念：

tf.data.Dataset：表示一系列元素，其中每个元素包含一个或多个 Tensor 对象。例如，在图片管道中，一个元素可能是单个训练样本，具有一对表示图片数据和标签的张量。可以通过两种不同的方式来创建数据集。

直接从 Tensor 创建 Dataset（例如 Dataset.from_tensor_slices()）；当然 Numpy 也是可以的，TensorFlow 会自动将其转换为 Tensor。

通过对一个或多个 tf.data.Dataset 对象来使用变换（例如 Dataset.batch()）来创建 Dataset

tf.data.Iterator：这是从数据集中提取元素的主要方法。Iterator.get_next() 指令会在执行时生成 Dataset 的下一个元素，并且此指令通常充当输入管道和模型之间的接口。最简单的迭代器是“单次迭代器”，它会对处理好的 Dataset 进行单次迭代。要实现更复杂的用途，您可以通过 `Iterator.initializer` 指令使用不同的数据集重新初始化和参数化迭代器，这样一来，您就可以在同一个程序中对训练和验证数据进行多次迭代（举例而言）。

1. Dataset 的基本机制 ¶
本部分将介绍：

Dataset 的基础知识，并尝试创建 Dataset
Iterator 的基础知识，并尝试创建 Iterator
通过 Iterator 来提取 Dataset 中的数据
要构建输入 pipeline，你必须首先根据数据集的存储方式选择相应的方法创建 Dataset 对象来读取数据。（如果你的数据在内存中，请使用tf.data.Dataset.from_tensors() 或 tf.data.Dataset.from_tensor_slices() 来创建 Dataset；如果你的数据是 tfrecord 格式的，那么请使用 tf.data.TFRecordDataset 来创建 Dataset）

有了 Dataset 对象以后，您就可以通过使用 tf.data.Dataset 对象的各种方法对其进行处理。例如，您可以对Dataset的每一个元素使用某种变换，例 Dataset.map()（为每个元素使用一个函数），也可以对多个元素使用某种变换（例如 Dataset.batch()）。 要了解所有可用的变换，请参阅 tf.data.Dataset 的文档。

消耗 Dataset 中值的最常见方法是构建迭代器对象。通过迭代器对象，每次可以访问数据集中的一个元素 （例如，通过调用 Dataset.make_one_shot_iterator()）。 tf.data.Iterator 提供了两个指令：Iterator.initializer，您可以通过此指令（重新）初始化迭代器的状态；以及 Iterator.get_next()，此指令返回迭代器中的下一个元素的 tf.Tensor 对象。根据您的需求，您可以选择不同类型的迭代器，下文将对此进行详细介绍。

1.1 了解 Dataset 的结构并尝试创建 Dataset ¶
一个 Dataset 对象包含多个元素，每个元素的结构都相同。每个元素包含一个或多个 tf.Tensor 对象，这些对象被称为组件。每个组件都有 tf.DType 属性，表示 Tensor 中元素的类型；以及 tf.TensorShape 属性，表示每个元素（可能部分指定）的静态形状。您可以通过 Dataset.output_types 和 Dataset.output_shapes 属性检查数据集元素各个组件的类型和形状。Dataset 的属性由构成该 Dataset 的元素的属性映射得到，元素可以是单个张量、张量元组，也可以是张量的嵌套元组。例如：

dataset1 = tf.data.Dataset.from_tensor_slices(tf.random_uniform([4, 10]))
print(dataset1.output_types)  # ==> "tf.float32"
print(dataset1.output_shapes)  # ==> "(10,)"

dataset2 = tf.data.Dataset.from_tensor_slices(
   (tf.random_uniform([4]),
    tf.random_uniform([4, 100], maxval=100, dtype=tf.int32)))
print(dataset2.output_types)  # ==> "(tf.float32, tf.int32)"
print(dataset2.output_shapes)  # ==> "((), (100,))"

dataset3 = tf.data.Dataset.zip((dataset1, dataset2))
print(dataset3.output_types)  # ==> (tf.float32, (tf.float32, tf.int32))
print(dataset3.output_shapes)  # ==> "(10, ((), (100,)))"
1
2
3
4
5
6
7
8
9
10
11
12
13
为 Dataset 中的元素的各个组件命名通常会带来便利性（例如，元素的各个组件表示不同特征时）。除了元组之外，还可以使用 命名元组（collections.namedtuple） 或 字典 来表示 Dataset 的单个元素。

dataset = tf.data.Dataset.from_tensor_slices(
   {"a": tf.random_uniform([4]),
    "b": tf.random_uniform([4, 100], maxval=100, dtype=tf.int32)})
print(dataset.output_types)  # ==> "{'a': tf.float32, 'b': tf.int32}"
print(dataset.output_shapes)  # ==> "{'a': (), 'b': (100,)}"
1
2
3
4
5
Dataset 的变换支持任何结构的数据集。在使用 Dataset.map()、Dataset.flat_map() 和 Dataset.filter() 函数时（这些转换会对每个元素应用一个函数），元素结构决定了函数的参数：

dataset1 = dataset1.map(lambda x: ...)

dataset2 = dataset2.flat_map(lambda x, y: ...)

# Note: Argument destructuring is not available in Python 3.
dataset3 = dataset3.filter(lambda x, (y, z): ...)
1
2
3
4
5
6
1.2 了解迭代器的作用，并创建 Iterator ¶
构建了表示输入数据的 Dataset 后，下一步就是创建 Iterator 来访问该数据集中的元素。tf.data API 目前支持下列迭代器，其复杂程度逐渐上升：

单次迭代器
可初始化迭代器
可重新初始化迭代器
可 feeding 迭代器
单次迭代器是最简单的迭代器形式，仅支持对数据集进行一次迭代，不需要显式初始化。单次迭代器可以处理现有的基于队列的输入管道支持的几乎所有情况，但不支持参数化。以 Dataset.range() 为例：

dataset = tf.data.Dataset.range(100)
iterator = dataset.make_one_shot_iterator()
next_element = iterator.get_next()

for i in range(100):
  value = sess.run(next_element)
  assert i == value
1
2
3
4
5
6
7
注意：目前，单次迭代器是唯一可轻松与 Estimator 配合使用的类型。

您需要先运行显式 iterator.initializer 指令，才能使用可初始化迭代器。虽然有些不便，但它允许您使用一个或多个 tf.placeholder() 张量（可在初始化迭代器时馈送）参数化数据集的定义。继续以 Dataset.range() 为例：

max_value = tf.placeholder(tf.int64, shape=[])
dataset = tf.data.Dataset.range(max_value)
iterator = dataset.make_initializable_iterator()
next_element = iterator.get_next()

# Initialize an iterator over a dataset with 10 elements.
sess.run(iterator.initializer, feed_dict={max_value: 10})
for i in range(10):
  value = sess.run(next_element)
  assert i == value

# Initialize the same iterator over a dataset with 100 elements.
sess.run(iterator.initializer, feed_dict={max_value: 100})
for i in range(100):
  value = sess.run(next_element)
  assert i == value
1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
可重新初始化迭代器 可以通过多个不同的 Dataset 对象进行初始化。例如，您可能有一个训练输入管道，它会对输入图片进行随机扰动来改善泛化；还有一个验证输入管道，它会评估对未修改数据的预测。这些管道通常会使用不同的 Dataset 对象，这些对象具有相同的结构（即每个组件具有相同类型和兼容形状）。

# Define training and validation datasets with the same structure.
training_dataset = tf.data.Dataset.range(100).map(
    lambda x: x + tf.random_uniform([], -10, 10, tf.int64))
validation_dataset = tf.data.Dataset.range(50)

# A reinitializable iterator is defined by its structure. We could use the
# `output_types` and `output_shapes` properties of either `training_dataset`
# or `validation_dataset` here, because they are compatible.
iterator = tf.data.Iterator.from_structure(training_dataset.output_types,
                                           training_dataset.output_shapes)
next_element = iterator.get_next()

training_init_op = iterator.make_initializer(training_dataset)
validation_init_op = iterator.make_initializer(validation_dataset)

# Run 20 epochs in which the training dataset is traversed, followed by the
# validation dataset.
for _ in range(20):
  # Initialize an iterator over the training dataset.
  sess.run(training_init_op)
  for _ in range(100):
    sess.run(next_element)

  # Initialize an iterator over the validation dataset.
  sess.run(validation_init_op)
  for _ in range(50):
    sess.run(next_element)
1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
20
21
22
23
24
25
26
27
可 feeding 迭代器可以与 tf.placeholder 一起使用，通过熟悉的 feed_dict 机制来选择每次调用 tf.Session.run 时所使用的 Iterator。它提供的功能与可重新初始化迭代器的相同，但在迭代器之间切换时不需要从数据集的开头初始化迭代器。例如，以上面的同一训练和验证数据集为例，您可以使用 tf.data.Iterator.from_string_handle 定义一个可让您在两个数据集之间切换的可 feeding 迭代器：

# Define training and validation datasets with the same structure.
training_dataset = tf.data.Dataset.range(100).map(
    lambda x: x + tf.random_uniform([], -10, 10, tf.int64)).repeat()
validation_dataset = tf.data.Dataset.range(50)

# A feedable iterator is defined by a handle placeholder and its structure. We
# could use the `output_types` and `output_shapes` properties of either
# `training_dataset` or `validation_dataset` here, because they have
# identical structure.
handle = tf.placeholder(tf.string, shape=[])
iterator = tf.data.Iterator.from_string_handle(
    handle, training_dataset.output_types, training_dataset.output_shapes)
next_element = iterator.get_next()

# You can use feedable iterators with a variety of different kinds of iterator
# (such as one-shot and initializable iterators).
training_iterator = training_dataset.make_one_shot_iterator()
validation_iterator = validation_dataset.make_initializable_iterator()

# The `Iterator.string_handle()` method returns a tensor that can be evaluated
# and used to feed the `handle` placeholder.
training_handle = sess.run(training_iterator.string_handle())
validation_handle = sess.run(validation_iterator.string_handle())

# Loop forever, alternating between training and validation.
while True:
  # Run 200 steps using the training dataset. Note that the training dataset is
  # infinite, and we resume from where we left off in the previous `while` loop
  # iteration.
  for _ in range(200):
    sess.run(next_element, feed_dict={handle: training_handle})

  # Run one pass over the validation dataset.
  sess.run(validation_iterator.initializer)
  for _ in range(50):
    sess.run(next_element, feed_dict={handle: validation_handle})
1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
20
21
22
23
24
25
26
27
28
29
30
31
32
33
34
35
36
1.3 从迭代器中读取数据 ¶
Iterator.get_next() 方法返回一个或多个 tf.Tensor 对象，这些对象对应于迭代器的下一个元素。每次 eval 这些张量时，它们都会获取底层数据集中下一个元素的值。（请注意，与 TensorFlow 中的其他有状态对象一样，调用 Iterator.get_next() 并不会立即使迭代器进入下个状态。相反，您必须使用 TensorFlow 表达式中返回的 tf.Tensor 对象，并将该表达式的结果传递到 tf.Session.run()，以获取下一个元素并使迭代器进入下个状态。）

如果迭代器到达数据集的末尾，则执行 Iterator.get_next() 指令会产生 tf.errors.OutOfRangeError。在此之后，迭代器将处于不可用状态；如果需要继续使用，则必须对其重新初始化。

dataset = tf.data.Dataset.range(5)
iterator = dataset.make_initializable_iterator()
next_element = iterator.get_next()

# Typically `result` will be the output of a model, or an optimizer's
# training operation.
result = tf.add(next_element, next_element)

sess.run(iterator.initializer)
print(sess.run(result))  # ==> "0"
print(sess.run(result))  # ==> "2"
print(sess.run(result))  # ==> "4"
print(sess.run(result))  # ==> "6"
print(sess.run(result))  # ==> "8"
try:
  sess.run(result)
except tf.errors.OutOfRangeError:
  print("End of dataset")  # ==> "End of dataset"
1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
一种常用的方法是将“训练循环”封装在 try-except 块中：

sess.run(iterator.initializer)
while True:
  try:
    sess.run(result)
  except tf.errors.OutOfRangeError:
    break
1
2
3
4
5
6
如果数据集的每个元素都具有嵌套结构，则 Iterator.get_next() 的返回值将是一个或多个 tf.Tensor 对象，这些对象具有相同的嵌套结构：

dataset1 = tf.data.Dataset.from_tensor_slices(tf.random_uniform([4, 10]))
dataset2 = tf.data.Dataset.from_tensor_slices((tf.random_uniform([4]), tf.random_uniform([4, 100])))
dataset3 = tf.data.Dataset.zip((dataset1, dataset2))

iterator = dataset3.make_initializable_iterator()

sess.run(iterator.initializer)
next1, (next2, next3) = iterator.get_next()
1
2
3
4
5
6
7
8
注意：next1、next2、next3 由相同的 op / node 产生，因此eval next1、next2 或 next3 中的任何一个都会使所有组件的迭代器进入下个状态。

1.4 保存迭代器的状态 ¶
tf.contrib.data.make_saveable_from_iterator 函数会从迭代器创建一个 SaveableObject，这个对象可以用来保存、恢复迭代器的当前状态（甚至是整个输入 pipeline）。

# Create saveable object from iterator.
saveable = tf.contrib.data.make_saveable_from_iterator(iterator)

# Save the iterator state by adding it to the saveable objects collection.
tf.add_to_collection(tf.GraphKeys.SAVEABLE_OBJECTS, saveable)
saver = tf.train.Saver()

with tf.Session() as sess:

  if should_checkpoint:
    saver.save(path_to_checkpoint)

# Restore the iterator state.
with tf.Session() as sess:
  saver.restore(sess, path_to_checkpoint)
1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
2. 构建 Dataset ¶
2.1 基于 NumPy 数组构建Dataset ¶
如果您的所有输入数据都适合存储在内存中，则根据输入数据创建 Dataset 的最简单方法是将它们转换为 tf.Tensor 对象，并使用 Dataset.from_tensor_slices()。

# Load the training data into two NumPy arrays, for example using `np.load()`.
with np.load("/var/data/training_data.npy") as data:
  features = data["features"]
  labels = data["labels"]

# Assume that each row of `features` corresponds to the same row as `labels`.
assert features.shape[0] == labels.shape[0]

dataset = tf.data.Dataset.from_tensor_slices((features, labels))
1
2
3
4
5
6
7
8
9
注意：上面的代码段会将 features 和 labels 数组作为 tf.constant() 指令嵌入在 TensorFlow 图中。这非常适合小型数据集，但会浪费内存，因为这会多次复制数组的内容，并可能会达到 tf.GraphDef 协议缓冲区的 2GB 上限。

作为替代方案，您可以基于 tf.placeholder() 张量定义 Dataset，并使用可初始化 Iterator，然后在初始化 dataset 的 Iterator 时将 NumPy 数组供给程序。

# Load the training data into two NumPy arrays, for example using `np.load()`.
with np.load("/var/data/training_data.npy") as data:
  features = data["features"]
  labels = data["labels"]

# Assume that each row of `features` corresponds to the same row as `labels`.
assert features.shape[0] == labels.shape[0]

features_placeholder = tf.placeholder(features.dtype, features.shape)
labels_placeholder = tf.placeholder(labels.dtype, labels.shape)

dataset = tf.data.Dataset.from_tensor_slices((features_placeholder, labels_placeholder))
# [Other transformations on `dataset`...]
dataset = ...
iterator = dataset.make_initializable_iterator()

sess.run(iterator.initializer, feed_dict={features_placeholder: features,
                                          labels_placeholder: labels})
1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
2.2 基于 tf.data.TFRecordDataset 构建 Dataset ¶
tf.data API 支持多种文件格式，因此您可以处理那些不适合存储在内存中的大型数据集。例如，TFRecord 文件格式是一种面向记录的简单二进制格式，很多 TensorFlow 应用采用此格式来训练数据。通过 tf.data.TFRecordDataset 类，您可以将一个或多个 TFRecord 文件的内容作为输入管道的一部分进行流式传输。

# Creates a dataset that reads all of the examples from two files.
filenames = ["/var/data/file1.tfrecord", "/var/data/file2.tfrecord"]
dataset = tf.data.TFRecordDataset(filenames)
1
2
3
TFRecordDataset 初始化程序的 filenames 参数可以是字符串、字符串列表，也可以是字符串 tf.Tensor。因此，如果您有两组分别用于训练和验证的文件，则可以使用 tf.placeholder(tf.string) 来表示文件名，并使用适当的文件名初始化迭代器：

filenames = tf.placeholder(tf.string, shape=[None])
dataset = tf.data.TFRecordDataset(filenames)
#如何将数据解析（parse）为Tensor见 3.1 节
dataset = dataset.map(...)  # Parse the record into tensors.
dataset = dataset.repeat()  # Repeat the input indefinitely.
dataset = dataset.batch(32)
iterator = dataset.make_initializable_iterator()

# You can feed the initializer with the appropriate filenames for the current
# phase of execution, e.g. training vs. validation.

# Initialize `iterator` with training data.
training_filenames = ["/var/data/file1.tfrecord", "/var/data/file2.tfrecord"]
sess.run(iterator.initializer, feed_dict={filenames: training_filenames})

# Initialize `iterator` with validation data.
validation_filenames = ["/var/data/validation1.tfrecord", ...]
sess.run(iterator.initializer, feed_dict={filenames: validation_filenames})
1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
2.3 基于 tf.data.FixedLengthRecordDataset 构建 Dataset ¶
有很多数据集都是二进制文件。tf.data.FixedLengthRecordDataset 提供了一种从一个或多个二进制文件中读取数据的简单方法。给定一个或多个文件名，FixedLengthRecordDataset

filenames = ["/var/data/file1.bin", "/var/data/file2.bin"]
dataset = tf.data.FixedLengthRecordDataset(filenames, record_bytes, header_bytes, footer_bytes， buffer_size)
1
2
filenames ： tf.string，包含一个或多个文件名；
record_bytes ：tf.int64，一个 record 占的 bytes；
header_bytes ：（可选）tf.int64，每个文件开头需要跳过多少 bytes；
footer_bytes ：（可选）tf.int64，每个文件结尾需要忽略多少 bytes；
buffer_size ：（可选）tf.int64，读取时，缓冲多少bytes；

2.4 基于 tf.data.TextLineDataset 构建 Dataset ¶
很多数据集都是作为一个或多个文本文件分布的。tf.data.TextLineDataset 提供了一种从一个或多个文本文件中提取行的简单方法。给定一个或多个文件名，TextLineDataset 会为这些文件的每行生成一个字符串值元素。像 TFRecordDataset 一样，TextLineDataset 将 filenames 视为 tf.Tensor，因此您可以通过传递 tf.placeholder(tf.string) 来进行参数化。

filenames = ["/var/data/file1.txt", "/var/data/file2.txt"]
dataset = tf.data.TextLineDataset(filenames)
1
2
默认情况下，TextLineDataset 每次读取每个文件的一行，这可能是不是我们想要的，例如，如果文件以标题行开头或包含评论。可以使用 Dataset.skip() 和 Dataset.filter() 转换来移除这些行。为了将这些转换分别应用于每个文件，我们使用 Dataset.flat_map() 为每个文件创建一个嵌套的 Dataset。

filenames = ["/var/data/file1.txt", "/var/data/file2.txt"]

dataset = tf.data.Dataset.from_tensor_slices(filenames)

# Use `Dataset.flat_map()` to transform each file as a separate nested dataset,
# and then concatenate their contents sequentially into a single "flat" dataset.
# * Skip the first line (header row).
# * Filter out lines beginning with "#" (comments).
dataset = dataset.flat_map(
    lambda filename: (
        tf.data.TextLineDataset(filename)
        .skip(1)
        .filter(lambda line: tf.not_equal(tf.substr(line, 0, 1), "#"))))
1
2
3
4
5
6
7
8
9
10
11
12
13
2.5 基于 tf.contrib.data.CsvDataset 构建 Dataset ¶
csv 是一种以纯文本方式储存表格数据的文件格式。tf.contrib.data.CsvDataset 类提供了一种方式去从一个或多个符合 RFC 4180 规范的 CSV 文件中提取 records。

# Creates a dataset that reads all of the records from two CSV files, each with
# eight float columns
filenames = ["/var/data/file1.csv", "/var/data/file2.csv"]
record_defaults = [tf.float32] * 8   # Eight required float columns
dataset = tf.contrib.data.CsvDataset(filenames, record_defaults)
1
2
3
4
5
如果一些列是空的，你可以设置默认值。

# Creates a dataset that reads all of the records from two CSV files, each with
# four float columns which may have missing values
record_defaults = [[0.0]] * 8
dataset = tf.contrib.data.CsvDataset(filenames, record_defaults)
1
2
3
4
默认情况下，一个 CsvDataset 每次从文件中读取一行，这可能不是想要的（例如：如果文件的 header line 应该被忽略；或者输入中的一些列是不需要的）。可以使用 header 及 select_cols 参数完成这些想法。

# Creates a dataset that reads all of the records from two CSV files, each with
# four float columns which may have missing values
record_defaults = [[0.0]] * 8
dataset = tf.contrib.data.CsvDataset(filenames, record_defaults)
1
2
3
4
2.5 直接从文件读取，解析数据 ¶
这一部分其实就是3.2节代码所示

3. 用 Dataset.map() 进行数据预处理 ¶
Dataset.map(f) 转换通过将指定函数 f 应用于输入数据集的每个元素来生成新数据集。此转换基于 map() 函数（通常应用于函数式编程语言中的列表（和其他结构））。函数 f 会接受表示输入中单个元素的 tf.Tensor 对象，并返回表示新数据集中单个元素的 tf.Tensor 对象。此函数的实现使用标准的 TensorFlow 指令将一个元素转换为另一个元素。

本部分介绍了如何使用 Dataset.map() 的常见示例。

3.1 从 tf.Example 中解析出数据 ¶
很多输入管道都从 TFRecord 格式的文件（例如使用 tf.python_io.TFRecordWriter 编写）中提取 tf.train.Example 协议缓冲区消息。每个 tf.train.Example 记录都包含一个或多个“特征”，输入管道通常会将这些特征转换为张量。

# Transforms a scalar string `example_proto` into a pair of a scalar string and
# a scalar integer, representing an image and its label, respectively.
def _parse_function(example_proto):
  features = {"image": tf.FixedLenFeature((), tf.string, default_value=""),
              "label": tf.FixedLenFeature((), tf.int32, default_value=0)}
  parsed_features = tf.parse_single_example(example_proto, features)
  return parsed_features["image"], parsed_features["label"]

# Creates a dataset that reads all of the examples from two files, and extracts
# the image and label features.
filenames = ["/var/data/file1.tfrecord", "/var/data/file2.tfrecord"]
dataset = tf.data.TFRecordDataset(filenames)
dataset = dataset.map(_parse_function)
1
2
3
4
5
6
7
8
9
10
11
12
13
3.2 解码图片数据并调整其大小 / 直接从文件读取文件 ¶
在用真实的图片数据训练神经网络时，通常需要将不同大小的图片转换为通用大小，这样就可以将它们批处理为具有固定大小的数据。

# Reads an image from a file, decodes it into a dense tensor, and resizes it
# to a fixed shape.
def _parse_function(filename, label):
  image_string = tf.read_file(filename)
  image_decoded = tf.image.decode_image(image_string)
  image_resized = tf.image.resize_images(image_decoded, [28, 28])
  return image_resized, label

# A vector of filenames.
filenames = tf.constant(["/var/data/image1.jpg", "/var/data/image2.jpg", ...])

# `labels[i]` is the label for the image in `filenames[i].
labels = tf.constant([0, 37, ...])

dataset = tf.data.Dataset.from_tensor_slices((filenames, labels))
dataset = dataset.map(_parse_function)
1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
3.3 基于 tf.py_func 使用 Python 函数进行预处理 ¶
为了确保性能，我们建议您尽可能使用 TensorFlow 指令预处理数据。不过，在解析输入数据时，调用外部 Python 库有时很有用。为此，请在 Dataset.map() 转换中调用 tf.py_func() 指令。

# tf.py_func
tf.py_func(func, # 一个Python函数
           inp, # 一个Tensor列表
           Tout, # 输出的Tensor的dtype或Tensors的dtype列表
           stateful=True, # 布尔值，输入值相同，输出值就相同，那么就将stateful设置为False
           name=None)
1
2
3
4
5
6
下面是一个借助opencv进行图像预处理的例子。

import cv2

# Use a custom OpenCV function to read the image, instead of the standard
# TensorFlow `tf.read_file()` operation.
def _read_py_function(filename, label):
  image_decoded = cv2.imread(filename.decode(), cv2.IMREAD_GRAYSCALE)
  return image_decoded, label

# Use standard TensorFlow operations to resize the image to a fixed shape.
def _resize_function(image_decoded, label):
  image_decoded.set_shape([None, None, None])
  image_resized = tf.image.resize_images(image_decoded, [28, 28])
  return image_resized, label

filenames = ["/var/data/image1.jpg", "/var/data/image2.jpg", ...]
labels = [0, 37, 29, 1, ...]

dataset = tf.data.Dataset.from_tensor_slices((filenames, labels))
dataset = dataset.map(
    lambda filename, label: tuple(tf.py_func(
        _read_py_function, [filename, label], [tf.uint8, label.dtype])))
dataset = dataset.map(_resize_function)
1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
20
21
22
4. 数据集进行 batch ¶
4.1 最简单的 batch（直接 stack） ¶
最简单的 batch 处理方法是将数据集中的 n 个连续元素堆叠为一个元素。Dataset.batch() 转换正是这么做的，它与 tf.stack() 运算符具有相同的限制（被应用于元素的每个组件）：即对于每个组件 i，所有元素的张量形状必须完全相同。

inc_dataset = tf.data.Dataset.range(100)
dec_dataset = tf.data.Dataset.range(0, -100, -1)
dataset = tf.data.Dataset.zip((inc_dataset, dec_dataset))
batched_dataset = dataset.batch(4)

iterator = batched_dataset.make_one_shot_iterator()
next_element = iterator.get_next()

print(sess.run(next_element))  # ==> ([0, 1, 2,   3],   [ 0, -1,  -2,  -3])
print(sess.run(next_element))  # ==> ([4, 5, 6,   7],   [-4, -5,  -6,  -7])
print(sess.run(next_element))  # ==> ([8, 9, 10, 11],   [-8, -9, -10, -11])
1
2
3
4
5
6
7
8
9
10
11
4.2 将 Tensor 填充成统一大小，然后 batch ¶
使用填充批处理张量
上述方法适用于具有相同大小的张量。不过，很多模型（例如序列模型）处理的输入数据可能具有不同的大小（例如序列的长度不同）。为了解决这种情况，可以通过 Dataset.padded_batch() 转换来指定一个或多个会被填充的维度，从而批处理不同形状的张量。

dataset = tf.data.Dataset.range(100)
dataset = dataset.map(lambda x: tf.fill([tf.cast(x, tf.int32)], x))
dataset = dataset.padded_batch(4, padded_shapes=[None])

iterator = dataset.make_one_shot_iterator()
next_element = iterator.get_next()

print(sess.run(next_element))  # ==> [[0, 0, 0], 
                               #      [1, 0, 0], 
                               #      [2, 2, 0], 
                               #      [3, 3, 3]]

print(sess.run(next_element))  # ==> [[4, 4, 4, 4, 0, 0, 0],
                               #      [5, 5, 5, 5, 5, 0, 0],
                               #      [6, 6, 6, 6, 6, 6, 0],
                               #      [7, 7, 7, 7, 7, 7, 7]]
1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
您可以通过 Dataset.padded_batch() 转换为每个组件的每个维度设置不同的填充，并且可以采用可变长度（在上面的示例中用 None 表示）或恒定长度。也可以替换填充值，默认设置为 0。

5. 训练时数据集的配置 ¶
5.1 迭代多个 epoch ¶
tf.data API 提供了两种主要方式来处理同一数据的多个周期。

要迭代数据集多个周期，最简单的方法是使用 Dataset.repeat()。例如，要创建一个将其输入重复 10 个周期的数据集：

filenames = ["/var/data/file1.tfrecord", "/var/data/file2.tfrecord"]
dataset = tf.data.TFRecordDataset(filenames)
dataset = dataset.map(...)
dataset = dataset.repeat(10)
dataset = dataset.batch(32)
1
2
3
4
5
应用不带参数的 Dataset.repeat() 转换将无限次地重复输入。Dataset.repeat() 转换将其参数连接起来，而不会在一个周期结束和下一个周期开始时发出信号。

如果您想在每个周期结束时收到信号，则可以编写在数据集结束时捕获 tf.errors.OutOfRangeError 的训练循环。此时，您可以收集关于该周期的一些统计信息（例如验证错误）。

filenames = ["/var/data/file1.tfrecord", "/var/data/file2.tfrecord"]
dataset = tf.data.TFRecordDataset(filenames)
dataset = dataset.map(...)
dataset = dataset.batch(32)
iterator = dataset.make_initializable_iterator()
next_element = iterator.get_next()

# Compute for 100 epochs.
for _ in range(100):
  sess.run(iterator.initializer)
  while True:
    try:
      sess.run(next_element)
    except tf.errors.OutOfRangeError:
      break

  # [Perform end-of-epoch calculations here.]
1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
5.2 随机 shuffle 数据集 ¶
Dataset.shuffle() 转换使用一个类似于 tf.RandomShuffleQueue 的算法来随机重排输入数据集：它保留一个固定大小的缓冲区，并以相同方式从此缓冲区中随机选择下一个元素。

filenames = ["/var/data/file1.tfrecord", "/var/data/file2.tfrecord"]
dataset = tf.data.TFRecordDataset(filenames)
dataset = dataset.map(...)
dataset = dataset.shuffle(buffer_size=10000)
dataset = dataset.batch(32)
dataset = dataset.repeat()
1
2
3
4
5
6
5.3 tf.data 和使用高阶 API 的混合使用 ¶
5.3.1 在 tf.train.MonitoredTrainingSession 中使用 tf.data ¶
tf.train.MonitoredTrainingSession API 简化了在分布式设置下运行 TensorFlow 的很多方面。MonitoredTrainingSession 使用 tf.errors.OutOfRangeError 表示训练已完成，因此要将其与 tf.data API 结合使用，我们建议使用 Dataset.make_one_shot_iterator()。例如：

filenames = ["/var/data/file1.tfrecord", "/var/data/file2.tfrecord"]
dataset = tf.data.TFRecordDataset(filenames)
dataset = dataset.map(...)
dataset = dataset.shuffle(buffer_size=10000)
dataset = dataset.batch(32)
dataset = dataset.repeat(num_epochs)
iterator = dataset.make_one_shot_iterator()

next_example, next_label = iterator.get_next()
loss = model_function(next_example, next_label)

training_op = tf.train.AdagradOptimizer(...).minimize(loss)

with tf.train.MonitoredTrainingSession(...) as sess:
  while not sess.should_stop():
    sess.run(training_op)

5.3.2 在 tf.estimator.Estimator 中使用 tf.data ¶
要在 tf.estimator.Estimator 的 input_fn 中使用 Dataset，我们建议使用 Dataset.make_one_shot_iterator()。例如：

def dataset_input_fn():
  filenames = ["/var/data/file1.tfrecord", "/var/data/file2.tfrecord"]
  dataset = tf.data.TFRecordDataset(filenames)

  # Use `tf.parse_single_example()` to extract data from a `tf.Example`
  # protocol buffer, and perform any additional per-record preprocessing.
  def parser(record):
    keys_to_features = {
        "image_data": tf.FixedLenFeature((), tf.string, default_value=""),
        "date_time": tf.FixedLenFeature((), tf.int64, default_value=""),
        "label": tf.FixedLenFeature((), tf.int64,
                                    default_value=tf.zeros([], dtype=tf.int64)),
    }
    parsed = tf.parse_single_example(record, keys_to_features)

    # Perform additional preprocessing on the parsed data.
    image = tf.image.decode_jpeg(parsed["image_data"])
    image = tf.reshape(image, [299, 299, 1])
    label = tf.cast(parsed["label"], tf.int32)

    return {"image_data": image, "date_time": parsed["date_time"]}, label

  # Use `Dataset.map()` to build a pair of a feature dictionary and a label
  # tensor for each example.
  dataset = dataset.map(parser)
  dataset = dataset.shuffle(buffer_size=10000)
  dataset = dataset.batch(32)
  dataset = dataset.repeat(num_epochs)
  iterator = dataset.make_one_shot_iterator()

  # `features` is a dictionary in which each value is a batch of values for
  # that feature; `labels` is a batch of labels.
  features, labels = iterator.get_next()
  return features, labels
1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
20
21
22
23
24
25
26
27
28
29
30
31
32
33
34
注：本文来自于TenosrFlow官方使用tf.data导入数据的 Develop > GUIDE > Importing data
--------------------- 
作者：黑暗星球 
来源：CSDN 
原文：https://blog.csdn.net/u014061630/article/details/80728694 
版权声明：本文为博主原创文章，转载请附上博文链接！