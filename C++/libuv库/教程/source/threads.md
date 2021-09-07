# Threads
等一下！为什么我们要聊线程？事件循环（event loop）不应该是用来做web编程的方法吗？(如果你对event loop, 不是很了解，可以看[这里](http://www.ruanyifeng.com/blog/2014/10/event-loop.html))。哦，不不。线程依旧是处理器完成任务的重要手段。线程因此有可能会派上用场，虽然会使得你不得不艰难地应对各种原始的同步问题。  

线程会在内部使用，用来在执行系统调用时伪造异步的假象。libuv通过线程还可以使得程序异步地执行一个阻塞的任务。方法就是大量地生成新线程，然后收集线程执行返回的结果。  

当下有两个占主导地位的线程库：windows下的线程实现和POSIX的[pthread](http://man7.org/linux/man-pages/man7/pthreads.7.html)。libuv的线程API与pthread的API在使用方法和语义上很接近。  

值得注意的是，libuv的线程模块是自成一体的。比如，其他的功能模块都需要依赖于event loop和回调的原则，但是线程并不是这样。它们是不受约束的，会在需要的时候阻塞，通过返回值产生信号错误，还有像接下来的这个例子所演示的这样，不需要在event loop中执行。  

因为线程API在不同的系统平台上，句法和语义表现得都不太相似，在支持程度上也各不相同。考虑到libuv的跨平台特性，libuv支持的线程API个数很有限。  

最后要强调一句：只有一个主线程，主线程上只有一个event loop。不会有其他与主线程交互的线程了。（除非使用`uv_async_send`）。  

## Core thread operations

下面这个例子不会很复杂，你可以使用`uv_thread_create()`开始一个线程，再使用`uv_thread_join()`等待其结束。  

#### thread-create/main.c

```c
int main() {
    int tracklen = 10;
    uv_thread_t hare_id;
    uv_thread_t tortoise_id;
    uv_thread_create(&hare_id, hare, &tracklen);
    uv_thread_create(&tortoise_id, tortoise, &tracklen);

    uv_thread_join(&hare_id);
    uv_thread_join(&tortoise_id);
    return 0;
}
```

##### TIP
>在Unix上``uv_thread_t``只是``pthread_t``的别名, 但是这只是一个具体实现，不要过度地依赖它，认为这永远是成立的。

`uv_thread_create`的第二个参数指向了要执行的函数的地址。最后一个参数用来传递自定义的参数。最终，函数hare将在新的线程中执行，由操作系统调度。  

#### thread-create/main.c

```c
void hare(void *arg) {
    int tracklen = *((int *) arg);
    while (tracklen) {
        tracklen--;
        sleep(1);
        fprintf(stderr, "Hare ran another step\n");
    }
    fprintf(stderr, "Hare done running!\n");
}
```

`uv_thread_join`不像`pthread_join`那样，允许线线程通过第二个参数向父线程返回值。想要传递值，必须使用线程间通信[Inter-thread communication](#inter_thread_communication-pane)。  

## Synchronization Primitives

因为本教程重点不在线程，所以我只罗列了libuv API中一些神奇的地方。剩下的你可以自行阅读pthreads的手册。  

#### Mutexes

libuv上的互斥量函数与pthread上存在一一映射。如果对pthread上的mutex不是很了解可以看[这里](https://computing.llnl.gov/tutorials/pthreads/)。

#### libuv mutex functions

```c
UV_EXTERN int uv_mutex_init(uv_mutex_t* handle);
UV_EXTERN void uv_mutex_destroy(uv_mutex_t* handle);
UV_EXTERN void uv_mutex_lock(uv_mutex_t* handle);
UV_EXTERN int uv_mutex_trylock(uv_mutex_t* handle);
UV_EXTERN void uv_mutex_unlock(uv_mutex_t* handle);
```

`uv_mutex_init`与`uv_mutex_trylock`在成功执行后，返回0，或者在错误时，返回错误码。  

如果libuv在编译的时候开启了调试模式，`uv_mutex_destroy()`, `uv_mutex_lock()` 和 `uv_mutex_unlock()`会在出错的地方调用`abort()`中断。类似的，`uv_mutex_trylock()`也同样会在错误发生时中断，而不是返回`EAGAIN`和`EBUSY`。  

递归地调用互斥量函数在某些系统平台上是支持的，但是你不能太过度依赖。因为例如在BSD上递归地调用互斥量函数会返回错误，比如你准备使用互斥量函数给一个已经上锁的临界区再次上锁的时候，就会出错。比如，像下面这个例子：  

```c
uv_mutex_lock(a_mutex);
uv_thread_create(thread_id, entry, (void *)a_mutex);
uv_mutex_lock(a_mutex);
// more things here
```

可以用来等待其他线程初始化一些变量然后释放`a_mutex`锁，但是第二次调用`uv_mutex_lock()`, 在调试模式下会导致程序崩溃，或者是返回错误。  

##### NOTE
>在linux中是支持递归上锁的，但是在libuv的API中并未实现。

#### Lock

读写锁是更细粒度的实现机制。两个读者线程可以同时从共享区中读取数据。当读者以读模式占有读写锁时，写者不能再占有它。当写者以写模式占有这个锁时，其他的写者或者读者都不能占有它。读写锁在数据库操作中非常常见，下面是一个玩具式的例子：  

#### locks/main.c - simple rwlocks

```c
#include <stdio.h>
#include <uv.h>

uv_barrier_t blocker;
uv_rwlock_t numlock;
int shared_num;

void reader(void *n)
{
    int num = *(int *)n;
    int i;
    for (i = 0; i < 20; i++) {
        uv_rwlock_rdlock(&numlock);
        printf("Reader %d: acquired lock\n", num);
        printf("Reader %d: shared num = %d\n", num, shared_num);
        uv_rwlock_rdunlock(&numlock);
        printf("Reader %d: released lock\n", num);
    }
    uv_barrier_wait(&blocker);
}

void writer(void *n)
{
    int num = *(int *)n;
    int i;
    for (i = 0; i < 20; i++) {
        uv_rwlock_wrlock(&numlock);
        printf("Writer %d: acquired lock\n", num);
        shared_num++;
        printf("Writer %d: incremented shared num = %d\n", num, shared_num);
        uv_rwlock_wrunlock(&numlock);
        printf("Writer %d: released lock\n", num);
    }
    uv_barrier_wait(&blocker);
}

int main()
{
    uv_barrier_init(&blocker, 4);

    shared_num = 0;
    uv_rwlock_init(&numlock);

    uv_thread_t threads[3];

    int thread_nums[] = {1, 2, 1};
    uv_thread_create(&threads[0], reader, &thread_nums[0]);
    uv_thread_create(&threads[1], reader, &thread_nums[1]);

    uv_thread_create(&threads[2], writer, &thread_nums[2]);

    uv_barrier_wait(&blocker);
    uv_barrier_destroy(&blocker);

    uv_rwlock_destroy(&numlock);
    return 0;
}
```

试着来执行一下上面的程序，看读者有多少次会同步执行。在有多个写者的时候，调度器会给予他们高优先级。因此，如果你加入两个读者，你会看到所有的读者趋向于在读者得到加锁机会前结束。  

在上面的例子中，我们也使用了屏障。因此主线程来等待所有的线程都已经结束，最后再将屏障和锁一块回收。  

#### Others

libuv同样支持[信号量](https://en.wikipedia.org/wiki/Semaphore_programming)，[条件变量](https://en.wikipedia.org/wiki/Monitor_synchronization#Waiting_and_signaling)和[屏障](https://en.wikipedia.org/wiki/Barrier_computer_science)，而且API的使用方法和pthread中的用法很类似。（如果你对上面的三个名词还不是很熟，可以看[这里](http://www.wuzesheng.com/?p=1668)，[这里](http://name5566.com/4535.html)，[这里](http://www.cnblogs.com/panhao/p/4653623.html)）。 

 还有，libuv提供了一个简单易用的函数`uv_once()`。多个线程调用这个函数，参数可以使用一个uv_once_t和一个指向特定函数的指针，**最终只有一个线程能够执行这个特定函数，并且这个特定函数只会被调用一次**：  

 ```c
 /* Initialize guard */
static uv_once_t once_only = UV_ONCE_INIT;

int i = 0;

void increment() {
    i++;
}

void thread1() {
    /* ... work */
    uv_once(once_only, increment);
}

void thread2() {
    /* ... work */
    uv_once(once_only, increment);
}

int main() {
    /* ... spawn threads */
}
 ```

当所有的线程执行完毕时，`i == 1`。  

在libuv的v0.11.11版本里，推出了uv_key_t结构和操作[线程局部存储TLS](http://baike.baidu.com/view/598128.htm)的[API](http://docs.libuv.org/en/v1.x/threading.html#thread-local-storage)，使用方法同样和pthread类似。  

##libuv work queue

`uv_queue_work()`是一个便利的函数，它使得一个应用程序能够在不同的线程运行任务，当任务完成后，回调函数将会被触发。它看起来好像很简单，但是它真正吸引人的地方在于它能够使得任何第三方的库都能以event-loop的方式执行。当使用event-loop的时候，最重要的是不能让loop线程阻塞，或者是执行高cpu占用的程序，因为这样会使得loop慢下来，loop event的高效特性也不能得到很好地发挥。  

然而，很多带有阻塞的特性的程序(比如最常见的I/O）使用开辟新线程来响应新请求(最经典的‘一个客户，一个线程‘模型)。使用event-loop可以提供另一种实现的方式。libuv提供了一个很好的抽象，使得你能够很好地使用它。  

下面有一个很好的例子，灵感来自<<[nodejs is cancer](http://teddziuba.github.io/2011/10/node-js-is-cancer.html)>>。我们将要执行fibonacci数列，并且睡眠一段时间，但是将阻塞和cpu占用时间长的任务分配到不同的线程，使得其不会阻塞event loop上的其他任务。  

#### queue-work/main.c - lazy fibonacci

```c
void fib(uv_work_t *req) {
    int n = *(int *) req->data;
    if (random() % 2)
        sleep(1);
    else
        sleep(3);
    long fib = fib_(n);
    fprintf(stderr, "%dth fibonacci is %lu\n", n, fib);
}

void after_fib(uv_work_t *req, int status) {
    fprintf(stderr, "Done calculating %dth fibonacci\n", *(int *) req->data);
}
```

任务函数很简单，也还没有运行在线程之上。`uv_work_t`是关键线索，你可以通过`void *data`传递任何数据，使用它来完成线程之间的沟通任务。但是你要确信，当你在多个线程都在运行的时候改变某个东西的时候，能够使用适当的锁。  

触发器是`uv_queue_work`：  

#### queue-work/main.c

```c
int main() {
    loop = uv_default_loop();

    int data[FIB_UNTIL];
    uv_work_t req[FIB_UNTIL];
    int i;
    for (i = 0; i < FIB_UNTIL; i++) {
        data[i] = i;
        req[i].data = (void *) &data[i];
        uv_queue_work(loop, &req[i], fib, after_fib);
    }

    return uv_run(loop, UV_RUN_DEFAULT);
}
```

线程函数fbi()将会在不同的线程中运行，传入`uv_work_t`结构体参数，一旦fib()函数返回，after_fib()会被event loop中的线程调用，然后被传入同样的结构体。  

为了封装阻塞的库，常见的模式是用[baton](http://nikhilm.github.io/uvbook/utilities.html#baton)来交换数据。

从libuv 0.9.4版后，添加了函数`uv_cancel()`。它可以用来取消工作队列中的任务。只有还未开始的任务可以被取消，如果任务已经开始执行或者已经执行完毕，`uv_cancel()`调用会失败。  

当用户想要终止程序的时候，`uv_cancel()`可以用来清理任务队列中的等待执行的任务。例如，一个音乐播放器可以以歌手的名字对歌曲进行排序，如果这个时候用户想要退出这个程序，`uv_cancel()`就可以做到快速退出，而不用等待执行完任务队列后，再退出。  

让我们对上述程序做一些修改，用来演示`uv_cancel()`的用法。首先让我们注册一个处理中断的函数。  

#### queue-cancel/main.c

```c
int main() {
    loop = uv_default_loop();

    int data[FIB_UNTIL];
    int i;
    for (i = 0; i < FIB_UNTIL; i++) {
        data[i] = i;
        fib_reqs[i].data = (void *) &data[i];
        uv_queue_work(loop, &fib_reqs[i], fib, after_fib);
    }

    uv_signal_t sig;
    uv_signal_init(loop, &sig);
    uv_signal_start(&sig, signal_handler, SIGINT);

    return uv_run(loop, UV_RUN_DEFAULT);
}
```

当用户通过`Ctrl+C`触发信号时，`uv_cancel()`回收任务队列中所有的任务，如果任务已经开始执行或者执行完毕，`uv_cancel()`返回0。  

#### queue-cancel/main.c  

```c
void signal_handler(uv_signal_t *req, int signum)
{
    printf("Signal received!\n");
    int i;
    for (i = 0; i < FIB_UNTIL; i++) {
        uv_cancel((uv_req_t*) &fib_reqs[i]);
    }
    uv_signal_stop(req);
}
```

对于已经成功取消的任务，他的回调函数的参数`status`会被设置为`UV_ECANCELED`。  

#### queue-cancel/main.c

```c
void after_fib(uv_work_t *req, int status) {
    if (status == UV_ECANCELED)
        fprintf(stderr, "Calculation of %d cancelled.\n", *(int *) req->data);
}
```

`uv_cancel()`函数同样可以用在`uv_fs_t`和`uv_getaddrinfo_t`请求上。对于一系列的文件系统操作函数来说，`uv_fs_t.errorno`会同样被设置为`UV_ECANCELED`。  

##### Tip
>一个良好设计的程序，应该能够终止一个已经开始运行的长耗时任务。  
>Such a worker could periodically check for a variable that only the main process sets to signal termination.

##Inter-thread communication

很多时候，你希望正在运行的线程之间能够相互发送消息。例如你在运行一个持续时间长的任务（可能使用uv_queue_work），但是你需要在主线程中监视它的进度情况。下面有一个简单的例子，演示了一个下载管理程序向用户展示各个下载线程的进度。  

#### progress/main.c

```c
uv_loop_t *loop;
uv_async_t async;

int main() {
    loop = uv_default_loop();

    uv_work_t req;
    int size = 10240;
    req.data = (void*) &size;

    uv_async_init(loop, &async, print_progress);
    uv_queue_work(loop, &req, fake_download, after);

    return uv_run(loop, UV_RUN_DEFAULT);
}
```

因为异步的线程通信是基于event-loop的，所以尽管所有的线程都可以是发送方，但是只有在event-loop上的线程可以是接收方（或者说event-loop是接收方）。在上述的代码中，当异步监视者接收到信号的时候，libuv会激发回调函数（print_progress）。  

##### WARNING
>应该注意: 因为消息的发送是异步的,当`uv_async_send`在另外一个线程中被调用后，回调函数可能会立即被调用, 也可能在稍后的某个时刻被调用。libuv也有可能多次调用`uv_async_send`，但只调用了一次回调函数。唯一可以保证的是: 线程在调用`uv_async_send`之后回调函数可至少被调用一次。 如果你没有未调用的`uv_async_send`, 那么回调函数也不会被调用。 如果你调用了两次(以上)的`uv_async_send`, 而 libuv 暂时还没有机会运行回调函数, 则libuv可能会在多次调用`uv_async_send`后只调用一次回调函数，你的回调函数绝对不会在一次事件中被调用两次(或多次)。

#### progress/main.c
```c
void fake_download(uv_work_t *req) {
    int size = *((int*) req->data);
    int downloaded = 0;
    double percentage;
    while (downloaded < size) {
        percentage = downloaded*100.0/size;
        async.data = (void*) &percentage;
        uv_async_send(&async);

        sleep(1);
        downloaded += (200+random())%1000; // can only download max 1000bytes/sec,
                                           // but at least a 200;
    }
}

```

在上述的下载函数中，我们修改了进度显示器，使用`uv_async_send`发送进度信息。要记住：`uv_async_send`同样是非阻塞的，调用后会立即返回。  

#### progress/main.c

```c
void print_progress(uv_async_t *handle) {
    double percentage = *((double*) handle->data);
    fprintf(stderr, "Downloaded %.2f%%\n", percentage);
}
```

函数`print_progress`是标准的libuv模式，从监视器中抽取数据。最后最重要的是把监视器回收。  

#### progress/main.c
```c
void after(uv_work_t *req, int status) {
    fprintf(stderr, "Download complete\n");
    uv_close((uv_handle_t*) &async, NULL);
}
```

在例子的最后，我们要说下`data`域的滥用，[bnoordhuis](https://github.com/bnoordhuis)指出使用`data`域可能会存在线程安全问题，`uv_async_send()`事实上只是唤醒了event-loop。可以使用互斥量或者读写锁来保证执行顺序的正确性。  

##### Note
>互斥量和读写锁不能在信号处理函数中正确工作，但是`uv_async_send`可以。

一种需要使用`uv_async_send`的场景是，当调用需要线程交互的库时。例如，举一个在node.js中V8引擎的例子，上下文和对象都是与v8引擎的线程绑定的，从另一个线程中直接向v8请求数据会导致返回不确定的结果。但是，考虑到现在很多nodejs的模块都是和第三方库绑定的，可以像下面一样，解决这个问题：  

>1.在node中，第三方库会建立javascript的回调函数，以便回调函数被调用时，能够返回更多的信息。

```javascript
var lib = require('lib');
lib.on_progress(function() {
    console.log("Progress");
});

lib.do();

// do other stuff
```

>2.`lib.do`应该是非阻塞的，但是第三方库却是阻塞的，所以需要调用`uv_queue_work`函数。
>3.在另外一个线程中完成任务想要调用progress的回调函数，但是不能直接与v8通信，所以需要`uv_async_send`函数。 
>4.在主线程（v8线程）中调用的异步回调函数，会在v8的配合下执行javscript的回调函数。（也就是说，主线程会调用回调函数，并且提供v8解析javascript的功能，以便其完成任务）。
