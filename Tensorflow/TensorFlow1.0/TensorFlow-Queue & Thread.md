## TensorFlow-Queue & Thread

> 使用TensorFlow进行异步计算

### Queue

> tf.queue.*

##### 分类
* tf.queue.FIFOQueue ：按入列顺序出列的队列
* tf.queue.RandomShuffleQueue ：随机顺序出列的队列
* tf.queue.PaddingFIFOQueue ：以固定长度批量出列的队列
* tf.queue.PriorityQueue ：带优先级出列的队列

##### 基本方法(tf.queue.queuebase)

* dequeue(name=None)    
    Dequeues one element from this queue.If the queue is empty when this operation executes, it will block until there is an element to dequeue.

    The tuple of tensors that was dequeued.
    
* dequeuemany(n,name=None)    
    Dequeues and concatenates n elements from this queue.This operation concatenates queue-element component tensors along the 0th dimension to make a single component tensor. All of the components in the dequeued tuple will have size n in the 0th dimension.

    The list of concatenated tensors that was dequeued.
    
* dequeue_up_to(n,name=None)

    Dequeues and concatenates n elements from this queue.

    Note This operation is not supported by all queues. If a queue does not support DequeueUpTo, then a tf.errors.UnimplementedError is raised.

    This operation concatenates queue-element component tensors along the 0th dimension to make a single component tensor. If the queue has not been closed, all of the components in the dequeued tuple will have size n in the 0th dimension.
* enqueue(vals,name=None)    
    Enqueues one element to this queue.
    
    If the queue is full when this operation executes, it will block until the element has been enqueued.
    
* enqueue_many(vals,name=None)
    Enqueues zero or more elements to this queue.

    This operation slices each component tensor along the 0th dimension to make multiple queue elements. All of the tensors in vals must have the same size in the 0th dimension.

    If the queue is full when this operation executes, it will block until all of the elements have been enqueued.

### Coordinator

> tf.train.Coordinator

##### 功能概述
* Coordinator类可以用来同时停止多个工作线程并且向那个在等待所有工作线程终止的程序报告异常。

##### 主要方法

* should_stop():如果线程应该停止则返回True。
* request_stop(<exception>): 请求该线程停止。
* join(<list of threads>):等待被指定的线程终止。

##### 工作原理

* 创建一个Coordinator对象
* 然后建立一些使用Coordinator对象的线程。这些线程通常一直循环运行，一直到should_stop()返回True时停止。
* 任何线程都可以决定计算什么时候应该停止。它只需要调用request_stop()同时其他线程的should_stop()将会返回True，然后都停下来。

##### 代码示例

```
# 线程体：循环执行，直到`Coordinator`收到了停止请求。
# 如果某些条件为真，请求`Coordinator`去停止其他线程。
def MyLoop(coord):
  while not coord.should_stop():
    ...do something...
    if ...some condition...:
      coord.request_stop()

# Main code: create a coordinator.
coord = Coordinator()

# Create 10 threads that run 'MyLoop()'
threads = [threading.Thread(target=MyLoop, args=(coord)) for i in xrange(10)]

# Start the threads and wait for all of them to stop.
for t in threads: 
    t.start()
coord.join(threads)
```

### QueueRunner

> tf.train.QueueRunner

##### 功能概述
QueueRunner类会创建一组线程， 这些线程可以重复的执行Enquene操作， 他们使用同一个Coordinator来处理线程同步终止。此外，一个QueueRunner会运行一个closer thread，当Coordinator收到异常报告时，这个closer thread会自动关闭队列。

##### 工作原理

* 首先建立一个TensorFlow图表，这个图表使用队列来输入样本。
* 增加处理样本并将样本推入队列中的操作。
* 队列和入队操作，作为参数，构件quuuerunner。一个QueueRunner管理多个入队线程。
* 通过QueueRunner.create_threads()创建并启动多线程。通过sess.run进行启动。
* 增加training操作来移除队列中的样本。

##### 主要方法
* QueueRunner(queue,[enqueue_op] * numbers)
* create_threads(sess,coord,start)

##### 代码示例
```
# Create a queue runner that will run 4 threads in parallel to enqueue
# examples.
qr = tf.train.QueueRunner(queue, [enqueue_op] * 4)

# Launch the graph.
sess = tf.Session()
# Create a coordinator, launch the queue runner threads.
coord = tf.train.Coordinator()
enqueue_threads = qr.create_threads(sess, coord=coord, start=True)
# Run the training loop, controlling termination with the coordinator.
for step in xrange(1000000):
    if coord.should_stop():
        break
    sess.run(train_op)
# When done, ask the threads to stop.
coord.request_stop()
# And wait for them to actually do it.
coord.join(threads)
```


### 异常处理

通过queue runners启动的线程不仅仅只处理推送样本到队列。他们还捕捉和处理由队列产生的异常，包括OutOfRangeError异常，这个异常是用于报告队列被关闭。

##### 代码示例

```
try:
    for step in xrange(1000000):
        if coord.should_stop():
            break
        sess.run(train_op)
except Exception, e:
   # Report exceptions to the coordinator.
   coord.request_stop(e)

# Terminate as usual.  It is innocuous to request stop twice.
coord.request_stop()
coord.join(threads)
```
