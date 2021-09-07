# Basics of libuv

libuv强制使用异步和事件驱动的编程风格。它的核心工作是提供一个event-loop，还有基于I/O和其它事件通知的回调函数。libuv还提供了一些核心工具，例如定时器，非阻塞的网络支持，异步文件系统访问，子进程等。  

## Event loops

在事件驱动编程中，程序会关注每一个事件，并且对每一个事件的发生做出反应。libuv会负责将来自操作系统的事件收集起来，或者监视其他来源的事件。这样，用户就可以注册回调函数，回调函数会在事件发生的时候被调用。event-loop会一直保持运行状态。用伪代码描述如下：  

```c
while there are still events to process:
    e = get the next event
    if there is a callback associated with e:
        call the callback
```

举几个事件的例子：  
>* 准备好被写入的文件。  
>* 包含准备被读取的数据的socket。  
>* 超时的定时器。  

event-loop最终会被`uv_run()`启动－当使用libuv时，最后都会调用的函数。  

系统编程中最经常处理的一般是输入和输出，而不是一大堆的数据处理。问题在于传统的输入/输出函数(例如`read`，`fprintf`)都是阻塞式的。实际上，向文件写入数据，从网络读取数据所花的时间，对比CPU的处理速度差得太多。任务没有完成，函数是不会返回的，所以你的程序在这段时间内什么也做不了。对于需要高性能的的程序来说，这是一个主要的障碍因为其他活动和I/O操作都在保持等待。 

其中一个标准的解决方案是使用多线程。每一个阻塞的I/O操作都会被分配到各个线程中（或者是使用线程池）。当某个线程一旦阻塞，处理器就可以调度处理其他需要cpu资源的线程。  

但是libuv使用了另外一个解决方案，那就是异步，非阻塞风格。大多数的现代操作系统提供了基于事件通知的子系统。例如，一个正常的socket上的`read`调用会发生阻塞，直到发送方把信息发送过来。但是，实际上程序可以请求操作系统监视socket事件的到来，并将这个事件通知放到事件队列中。这样，程序就可以很简单地检查事件是否到来（可能此时正在使用cpu做数值处理的运算），并及时地获取数据。说libuv是异步的，是因为程序可以在一头表达对某一事件的兴趣，并在另一头获取到数据（对于时间或是空间来说）。它是非阻塞是因为应用程序无需在请求数据后等待，可以自由地做其他的事。libuv的事件循环方式很好地与该模型匹配, 因为操作系统事件可以视为另外一种libuv事件. 非阻塞方式可以保证在其他事件到来时被尽快处理（当然还要考虑硬件的能力）。  

##### Note
>我们不需要关心I/O在后台是如何工作的，但是由于我们的计算机硬件的工作方式，线程是处理器最基本的执行单元，libuv和操作系统通常会运行后台/工作者线程, 或者采用非阻塞方式来轮流执行任务。  

Bert Belder，一个libuv的核心开发者，通过一个短视频向我们解释了libuv的架构和它的后台工作方式。如果你之前没有接触过类似libuv，libev，这个视频会非常有用。视频的网址是https://youtu.be/nGn60vDSxQ4 。

包含了libuv的event-loop的更多详细信息的[文档](http://docs.libuv.org/en/v1.x/design.html#the-i-o-loop)。  

## HELLO WORLD

让我们开始写第一个libuv程序吧！它什么都没做，只是开启了一个loop，然后很快地退出了。  

#### helloworld/main.c

```c
#include <stdio.h>
#include <stdlib.h>
#include <uv.h>

int main() {
    uv_loop_t *loop = malloc(sizeof(uv_loop_t));
    uv_loop_init(loop);

    printf("Now quitting.\n");
    uv_run(loop, UV_RUN_DEFAULT);

    uv_loop_close(loop);
    free(loop);
    return 0;
}
```

这个程序会很快就退出了，因为没有可以很处理的事件。我们可以使用各种API函数来告诉event-loop我们要监视的事件。  

从libuv的1.0版本开始，用户就可以在使用`uv_loop_init`初始化loop之前，给其分配相应的内存。这就允许你植入自定义的内存管理方法。记住要使用`uv_loop_close(uv_loop_t *)`关闭loop，然后再回收内存空间。在例子中，程序退出的时候会关闭loop，系统也会自动回收内存。对于长时间运行的程序来说，合理释放内存很重要。   

### Default loop

可以使用`uv_default_loop`获取libuv提供的默认loop。如果你只需要一个loop的话，可以使用这个。  

##### Note

>nodejs中使用了默认的loop作为自己的主loop。如果你在编写nodejs的绑定，你应该注意一下。  

## Error handling

初始化函数或者同步执行的函数，会在执行失败后返回代表错误的负数。但是对于异步执行的函数，会在执行失败的时候，给它们的回调函数传递一个状态参数。错误信息被定义为`UV_E*`[常量](http://docs.libuv.org/en/v1.x/errors.html#error-constants)。  

你可以使用`uv_strerror(int)`和`uv_err_name(int)`分别获取`const char *`格式的错误信息和错误名字。  

I/O函数的回调函数（例如文件和socket等）会被传递一个`nread`参数。如果`nread`小于0，就代表出现了错误（当然，UV_EOF是读取到文件末端的错误，你要特殊处理）。  

##Handles and Requests

libuv的工作建立在用户表达对特定事件的兴趣。这通常通过创造对应I/O设备，定时器，进程等的handle来实现。handle是不透明的数据结构，其中对应的类型`uv_TYPE_t`中的type指定了handle的使用目的。  

#### libuv watchers

```c
/* Handle types. */
typedef struct uv_loop_s uv_loop_t;
typedef struct uv_handle_s uv_handle_t;
typedef struct uv_stream_s uv_stream_t;
typedef struct uv_tcp_s uv_tcp_t;
typedef struct uv_udp_s uv_udp_t;
typedef struct uv_pipe_s uv_pipe_t;
typedef struct uv_tty_s uv_tty_t;
typedef struct uv_poll_s uv_poll_t;
typedef struct uv_timer_s uv_timer_t;
typedef struct uv_prepare_s uv_prepare_t;
typedef struct uv_check_s uv_check_t;
typedef struct uv_idle_s uv_idle_t;
typedef struct uv_async_s uv_async_t;
typedef struct uv_process_s uv_process_t;
typedef struct uv_fs_event_s uv_fs_event_t;
typedef struct uv_fs_poll_s uv_fs_poll_t;
typedef struct uv_signal_s uv_signal_t;

/* Request types. */
typedef struct uv_req_s uv_req_t;
typedef struct uv_getaddrinfo_s uv_getaddrinfo_t;
typedef struct uv_getnameinfo_s uv_getnameinfo_t;
typedef struct uv_shutdown_s uv_shutdown_t;
typedef struct uv_write_s uv_write_t;
typedef struct uv_connect_s uv_connect_t;
typedef struct uv_udp_send_s uv_udp_send_t;
typedef struct uv_fs_s uv_fs_t;
typedef struct uv_work_s uv_work_t;

/* None of the above. */
typedef struct uv_cpu_info_s uv_cpu_info_t;
typedef struct uv_interface_address_s uv_interface_address_t;
typedef struct uv_dirent_s uv_dirent_t;
```

handle代表了持久性对象。在异步的操作中，相应的handle上有许多与之关联的request。request是短暂性对象（通常只维持在一个回调函数的时间），通常对映着handle上的一个I/O操作。Requests用来在初始函数和回调函数之间，传递上下文。例如uv_udp_t代表了一个udp的socket，然而，对于每一个向socket的写入的完成后，都会向回调函数传递一个`uv_udp_send_t`。  

handle可以通过下面的函数设置：  

```c
uv_TYPE_init(uv_loop_t *, uv_TYPE_t *)
```

回调函数是libuv所关注的事件发生后，所调用的函数。应用程序的特定逻辑会在回调函数中实现。例如，一个IO监视器的回调函数会接收到从文件读取到的数据，一个定时器的回调函数会在超时后被触发等等。  

### Idling

下面有一个使用空转handle的例子。回调函数在每一个循环中都会被调用。在Utilities这部分会讲到一些空转handle的使用场景。现在让我们使用一个空转监视器，然后来观察它的生命周期，接着看`uv_run`调用会造成阻塞。当达到事先规定好的计数后，空转监视器会退出。因为`uv_run`已经找不到活着的事件监视器了，所以`uv_run()`也退出。  

#### idle-basic/main.c

```c
#include <stdio.h>
#include <uv.h>

int64_t counter = 0;

void wait_for_a_while(uv_idle_t* handle) {
    counter++;

    if (counter >= 10e6)
        uv_idle_stop(handle);
}

int main() {
    uv_idle_t idler;

    uv_idle_init(uv_default_loop(), &idler);
    uv_idle_start(&idler, wait_for_a_while);

    printf("Idling...\n");
    uv_run(uv_default_loop(), UV_RUN_DEFAULT);

    uv_loop_close(uv_default_loop());
    return 0;
}

```

### Storing context

在基于回调函数的编程风格中，你可能会需要在调用处和回调函数之间，传递一些上下文等特定的应用信息。所有的handle和request都有一个`data`域，可以用来存储信息并传递。这是一个c语言库中很常见的模式。即使是`uv_loop_t`也有一个相似的`data`域。	  

