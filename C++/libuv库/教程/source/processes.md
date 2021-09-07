# Processes

libuv提供了相当多的子进程管理函数，并且是跨平台的，还允许使用stream，或者说pipe完成进程间通信。  

在UNIX中有一个共识，就是进程只做一件事，并把它做好。因此，进程通常通过创建子进程来完成不同的任务（例如，在shell中使用pipe）。 一个多进程的，通过消息通信的模型，总比多线程的，共享内存的模型要容易理解得多。  

当前一个比较常见的反对事件驱动编程的原因在于，其不能很好地利用现代多核计算机的优势。一个多线程的程序，内核可以将线程调度到不同的cpu核心中执行，以提高性能。但是一个event-loop的程序只有一个线程。实际上，工作区可以被分配到多进程上，每一个进程执行一个event-loop，然后每一个进程被分配到不同的cpu核心中执行。  

## Spawning child processes

一个最简单的用途是，你想要开始一个进程，然后知道它什么时候终止。需要使用`uv_spawn`完成任务：  

#### spawn/main.c

```c
uv_loop_t *loop;
uv_process_t child_req;
uv_process_options_t options;
int main() {
    loop = uv_default_loop();

    char* args[3];
    args[0] = "mkdir";
    args[1] = "test-dir";
    args[2] = NULL;

    options.exit_cb = on_exit;
    options.file = "mkdir";
    options.args = args;

    int r;
    if ((r = uv_spawn(loop, &child_req, &options))) {
        fprintf(stderr, "%s\n", uv_strerror(r));
        return 1;
    } else {
        fprintf(stderr, "Launched process with ID %d\n", child_req.pid);
    }

    return uv_run(loop, UV_RUN_DEFAULT);
}
```

##### Note

>由于上述的options是全局变量，因此被初始化为0。如果你在局部变量中定义options，请记得将所有没用的域设为0   

```c
uv_process_options_t options = {0};
```

`uv_process_t`只是作为句柄，所有的选择项都通过`uv_process_options_t`设置，为了简单地开始一个进程，你只需要设置file和args，file是要执行的程序，args是所需的参数（和c语言中main函数的传入参数类似）。因为`uv_spawn`在内部使用了[execvp](http://man7.org/linux/man-pages/man3/exec.3.html)，所以不需要提供绝对地址。遵从惯例，**实际传入参数的数目要比需要的参数多一个，因为最后一个参数会被设为NULL**。  

在函数`uv_spawn`被调用之后，`uv_process_t.pid`会包含子进程的id。  

回调函数`on_exit()`会在被调用的时候，传入exit状态和导致exit的信号。  

#### spawn/main.c

```c
void on_exit(uv_process_t *req, int64_t exit_status, int term_signal) {
    fprintf(stderr, "Process exited with status %" PRId64 ", signal %d\n", exit_status, term_signal);
    uv_close((uv_handle_t*) req, NULL);
```

在进程关闭后，需要回收handler。  

## Changing process parameters

在子进程开始执行前，你可以通过使用`uv_process_options_t`设置运行环境。  

### Change execution directory

设置`uv_process_options_t.cwd`，更改相应的目录。  

### Set environment variables

`uv_process_options_t.env`的格式是以null为结尾的字符串数组，其中每一个字符串的形式都是`VAR=VALUE`。这些值用来设置进程的环境变量。如果子进程想要继承父进程的环境变量，就将`uv_process_options_t.env`设为null。  

### Option flags

通过使用下面标识的按位或的值设置`uv_process_options_t.flags`的值，可以定义子进程的行为：  

>* `UV_PROCESS_SETUID`-将子进程的执行用户id（UID）设置为`uv_process_options_t.uid`中的值。  
* `UV_PROCESS_SETGID`-将子进程的执行组id(GID)设置为`uv_process_options_t.gid`中的值。  
  只有在unix系的操作系统中支持设置用户id和组id，在windows下设置会失败，`uv_spawn`会返回`UV_ENOTSUP`。 
* `UV_PROCESS_WINDOWS_VERBATIM_ARGUMENTS`-在windows上，`uv_process_options_t.args`参数不要用引号包裹。此标记对unix无效。  
* `UV_PROCESS_DETACHED`-在新会话(session)中启动子进程，这样子进程就可以在父进程退出后继续进行。请看下面的例子：  

## Detaching processes

使用标识`UV_PROCESS_DETACHED`可以启动守护进程(daemon)，或者是使得子进程从父进程中独立出来，这样父进程的退出就不会影响到它。   

#### detach/main.c

```c
int main() {
    loop = uv_default_loop();

    char* args[3];
    args[0] = "sleep";
    args[1] = "100";
    args[2] = NULL;

    options.exit_cb = NULL;
    options.file = "sleep";
    options.args = args;
    options.flags = UV_PROCESS_DETACHED;

    int r;
    if ((r = uv_spawn(loop, &child_req, &options))) {
        fprintf(stderr, "%s\n", uv_strerror(r));
        return 1;
    }
    fprintf(stderr, "Launched sleep with PID %d\n", child_req.pid);
    uv_unref((uv_handle_t*) &child_req);

    return uv_run(loop, UV_RUN_DEFAULT);
```

记住一点，就是handle会始终监视着子进程，所以你的程序不会退出。`uv_unref()`会解除handle。  

## Sending signals to processes

libuv打包了unix标准的`kill(2)`系统调用，并且在windows上实现了一个类似用法的调用，但要注意：所有的`SIGTERM`，`SIGINT`和`SIGKILL`都会导致进程的中断。`uv_kill`函数如下所示：  

```c
uv_err_t uv_kill(int pid, int signum);
```

对于用libuv启动的进程，应该使用`uv_process_kill`终止，它会以`uv_process_t`作为第一个参数，而不是pid。当使用`uv_process_kill`后，记得使用`uv_close`关闭`uv_process_t`。  

## Signals

libuv对unix信号和一些[windows下类似的机制](http://docs.libuv.org/en/v1.x/signal.html#signal)，做了很好的打包。  

使用`uv_signal_init`初始化handle（`uv_signal_t `），然后将它与loop关联。为了使用handle监听特定的信号，使用`uv_signal_start()`函数。每一个handle只能与一个信号关联，后续的`uv_signal_start`会覆盖前面的关联。使用`uv_signal_stop`终止监听。下面的这个小例子展示了各种用法：  

#### signal/main.c

```c
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <uv.h>

uv_loop_t* create_loop()
{
    uv_loop_t *loop = malloc(sizeof(uv_loop_t));
    if (loop) {
      uv_loop_init(loop);
    }
    return loop;
}

void signal_handler(uv_signal_t *handle, int signum)
{
    printf("Signal received: %d\n", signum);
    uv_signal_stop(handle);
}

// two signal handlers in one loop
void thread1_worker(void *userp)
{
    uv_loop_t *loop1 = create_loop();

    uv_signal_t sig1a, sig1b;
    uv_signal_init(loop1, &sig1a);
    uv_signal_start(&sig1a, signal_handler, SIGUSR1);

    uv_signal_init(loop1, &sig1b);
    uv_signal_start(&sig1b, signal_handler, SIGUSR1);

    uv_run(loop1, UV_RUN_DEFAULT);
}

// two signal handlers, each in its own loop
void thread2_worker(void *userp)
{
    uv_loop_t *loop2 = create_loop();
    uv_loop_t *loop3 = create_loop();

    uv_signal_t sig2;
    uv_signal_init(loop2, &sig2);
    uv_signal_start(&sig2, signal_handler, SIGUSR1);

    uv_signal_t sig3;
    uv_signal_init(loop3, &sig3);
    uv_signal_start(&sig3, signal_handler, SIGUSR1);

    while (uv_run(loop2, UV_RUN_NOWAIT) || uv_run(loop3, UV_RUN_NOWAIT)) {
    }
}

int main()
{
    printf("PID %d\n", getpid());

    uv_thread_t thread1, thread2;

    uv_thread_create(&thread1, thread1_worker, 0);
    uv_thread_create(&thread2, thread2_worker, 0);

    uv_thread_join(&thread1);
    uv_thread_join(&thread2);
    return 0;
}
```

##### Note
>`uv_run(loop, UV_RUN_NOWAIT)`和`uv_run(loop, UV_RUN_ONCE)`非常像，因为它们都只处理一个事件。但是不同在于，UV_RUN_ONCE会在没有任务的时候阻塞，但是UV_RUN_NOWAIT会立刻返回。我们使用`NOWAIT`，这样才使得一个loop不会因为另外一个loop没有要处理的事件而挨饿。  

当向进程发送`SIGUSR1`，你会发现signal_handler函数被激发了4次，每次都对应一个`uv_signal_t`。然后signal_handler调用uv_signal_stop终止了每一个`uv_signal_t`，最终程序退出。对每个handler函数来说，任务的分配很重要。一个使用了多个event-loop的服务器程序，只要简单地给每一个进程添加信号SIGINT监视器，就可以保证程序在中断退出前，数据能够安全地保存。  

## Child Process I/O

一个正常的新产生的进程都有自己的一套文件描述符映射表，例如0，1，2分别对应`stdin`，`stdout`和`stderr`。有时候父进程想要将自己的文件描述符映射表分享给子进程。例如，你的程序启动了一个子命令，并且把所有的错误信息输出到log文件中，但是不能使用`stdout`。因此，你想要使得你的子进程和父进程一样，拥有`stderr`。在这种情形下，libuv提供了继承文件描述符的功能。在下面的例子中，我们会调用这么一个测试程序：  

#### proc-streams/test.c

```c
#include <stdio.h>

int main()
{
    fprintf(stderr, "This is stderr\n");
    printf("This is stdout\n");
    return 0;
}
```

实际的执行程序` proc-streams`在运行的时候，只向子进程分享`stderr`。使用`uv_process_options_t`的`stdio`域设置子进程的文件描述符。首先设置`stdio_count`，定义文件描述符的个数。`uv_process_options_t.stdio`是一个`uv_stdio_container_t`数组。定义如下：  

```c
typedef struct uv_stdio_container_s {
  uv_stdio_flags flags;

  union {
    uv_stream_t* stream;
    int fd;
  } data;
} uv_stdio_container_t;
```

上边的flag值可取多种。比如，如果你不打算使用，可以设置为`UV_IGNORE`。如果与stdio中对应的前三个文件描述符被标记为`UV_IGNORE`，那么它们会被重定向到`/dev/null`。  

因为我们想要传递一个已经存在的文件描述符，所以使用`UV_INHERIT_FD`。因此，fd被设为stderr。  

#### proc-streams/main.c

```c
int main() {
    loop = uv_default_loop();

    /* ... */

    options.stdio_count = 3;
    uv_stdio_container_t child_stdio[3];
    child_stdio[0].flags = UV_IGNORE;
    child_stdio[1].flags = UV_IGNORE;
    child_stdio[2].flags = UV_INHERIT_FD;
    child_stdio[2].data.fd = 2;
    options.stdio = child_stdio;

    options.exit_cb = on_exit;
    options.file = args[0];
    options.args = args;

    int r;
    if ((r = uv_spawn(loop, &child_req, &options))) {
        fprintf(stderr, "%s\n", uv_strerror(r));
        return 1;
    }

    return uv_run(loop, UV_RUN_DEFAULT);
}
```

这时你启动proc-streams，也就是在main中产生一个执行test的子进程，你只会看到“This is stderr”。你可以试着设置stdout也继承父进程。  

同样可以把上述方法用于流的重定向。比如，把flag设为`UV_INHERIT_STREAM`，然后再设置父进程中的`data.stream`，这时子进程只会把这个stream当成是标准的I/O。这可以用来实现，例如[CGI](https://en.wikipedia.org/wiki/Common_Gateway_Interface)。  

一个简单的CGI脚本的例子如下：  

#### cgi/tick.c

```c
#include <stdio.h>
#include <unistd.h>

int main() {
    int i;
    for (i = 0; i < 10; i++) {
        printf("tick\n");
        fflush(stdout);
        sleep(1);
    }
    printf("BOOM!\n");
    return 0;
}
```

CGI服务器用到了这章和[网络](http://luohaha.github.io/Chinese-uvbook/source/networking.html)那章的知识，所以每一个client都会被发送10个tick，然后被中断连接。  

#### cgi/main.c

```c
void on_new_connection(uv_stream_t *server, int status) {
    if (status == -1) {
        // error!
        return;
    }

    uv_tcp_t *client = (uv_tcp_t*) malloc(sizeof(uv_tcp_t));
    uv_tcp_init(loop, client);
    if (uv_accept(server, (uv_stream_t*) client) == 0) {
        invoke_cgi_script(client);
    }
    else {
        uv_close((uv_handle_t*) client, NULL);
    }
```

上述代码中，我们接受了连接，并把socket（流）传递给`invoke_cgi_script`。  

#### cgi/main.c

```c
  args[1] = NULL;

    /* ... finding the executable path and setting up arguments ... */

    options.stdio_count = 3;
    uv_stdio_container_t child_stdio[3];
    child_stdio[0].flags = UV_IGNORE;
    child_stdio[1].flags = UV_INHERIT_STREAM;
    child_stdio[1].data.stream = (uv_stream_t*) client;
    child_stdio[2].flags = UV_IGNORE;
    options.stdio = child_stdio;

    options.exit_cb = cleanup_handles;
    options.file = args[0];
    options.args = args;

    // Set this so we can close the socket after the child process exits.
    child_req.data = (void*) client;
    int r;
    if ((r = uv_spawn(loop, &child_req, &options))) {
        fprintf(stderr, "%s\n", uv_strerror(r));
```

cgi的`stdout`被绑定到socket上，所以无论tick脚本程序打印什么，都会发送到client端。通过使用进程，我们能够很好地处理读写并发操作，而且用起来也很方便。但是要记得这么做，是很浪费资源的。  

## Pipes

libuv的`uv_pipe_t`结构可能会让一些unix程序员产生困惑，因为它像魔术般变幻出`|`和[`pipe(7)`](http://man7.org/linux/man-pages/man7/pipe.7.html)。但这里的`uv_pipe_t`并不是IPC机制里的 匿名管道（在IPC里，pipe是 匿名管道，只允许父子进程之间通信。FIFO则允许没有亲戚关系的进程间通信，显然llibuv里的`uv_pipe_t`不是第一种）。`uv_pipe_t`背后有[unix本地socket](http://man7.org/linux/man-pages/man7/unix.7.html)或者[windows 具名管道](https://msdn.microsoft.com/en-us/library/windows/desktop/aa365590.aspx)的支持，可以实现多进程间的通信。下面会具体讨论。  

#### Parent-child IPC

父进程与子进程可以通过单工或者双工管道通信，获得管道可以通过设置`uv_stdio_container_t.flags`为`UV_CREATE_PIPE`，`UV_READABLE_PIPE`或者`UV_WRITABLE_PIPE`的按位或的值。上述的读／写标记是对于子进程而言的。  

#### Arbitrary process IPC

既然本地socket具有确定的名称，而且是以文件系统上的位置来标示的（例如，unix中socket是文件的一种存在形式），那么它就可以用来在不相关的进程间完成通信任务。被开源桌面环境使用的[`D-BUS`系统](http://www.freedesktop.org/wiki/Software/dbus/)也是使用了本地socket来作为事件通知的，例如，当消息来到，或者检测到硬件的时候，各种应用程序会被通知到。mysql服务器也运行着一个本地socket，等待客户端的访问。  

当使用本地socket的时候，客户端／服务器模型通常和之前类似。在完成初始化后，发送和接受消息的方法和之前的tcp类似，接下来我们同样适用echo服务器的例子来说明。  

#### pipe-echo-server/main.c

```c
int main() {
    loop = uv_default_loop();

    uv_pipe_t server;
    uv_pipe_init(loop, &server, 0);

    signal(SIGINT, remove_sock);

    int r;
    if ((r = uv_pipe_bind(&server, "echo.sock"))) {
        fprintf(stderr, "Bind error %s\n", uv_err_name(r));
        return 1;
    }
    if ((r = uv_listen((uv_stream_t*) &server, 128, on_new_connection))) {
        fprintf(stderr, "Listen error %s\n", uv_err_name(r));
        return 2;
    }
    return uv_run(loop, UV_RUN_DEFAULT);
}
```

我们把socket命名为echo.sock，意味着它将会在本地文件夹中被创造。对于stream API来说，本地socekt表现得和tcp的socket差不多。你可以使用[socat](http://www.dest-unreach.org/socat/)测试一下服务器：  

```
$ socat - /path/to/socket
```

客户端如果想要和服务器端连接的话，应该使用：  

```c
void uv_pipe_connect(uv_connect_t *req, uv_pipe_t *handle, const char *name, uv_connect_cb cb);
```

上述函数，name应该为echo.sock。  

#### Sending file descriptors over pipes

最酷的事情是本地socket可以传递文件描述符，也就是说进程间可以交换文件描述符。这样就允许进程将它们的I/O传递给其他进程。它的应用场景包括，负载均衡服务器，分派工作进程等，各种可以使得cpu使用最优化的应用。libuv当前只支持通过管道传输**TCP sockets或者其他的pipes**。  

为了展示这个功能，我们将来实现一个由循环中的工人进程处理client端请求，的这么一个echo服务器程序。这个程序有一些复杂，在教程中只截取了部分的片段，为了更好地理解，我推荐你去读下完整的[代码](https://github.com/nikhilm/uvbook/tree/master/code/multi-echo-server)。  

工人进程很简单，文件描述符将从主进程传递给它。  

#### multi-echo-server/worker.c

```c
uv_loop_t *loop;
uv_pipe_t queue;
int main() {
    loop = uv_default_loop();

    uv_pipe_init(loop, &queue, 1 /* ipc */);
    uv_pipe_open(&queue, 0);
    uv_read_start((uv_stream_t*)&queue, alloc_buffer, on_new_connection);
    return uv_run(loop, UV_RUN_DEFAULT);
}
```

`queue`是另一端连接上主进程的管道，因此，文件描述符可以传送过来。在`uv_pipe_init`中将`ipc`参数设置为1很关键，因为它标明了这个管道将被用来做进程间通信。因为主进程需要把文件handle赋给了工人进程作为标准输入，因此我们使用`uv_pipe_open`把stdin作为pipe（别忘了，0代表stdin）。  

#### multi-echo-server/worker.c

```c
void on_new_connection(uv_stream_t *q, ssize_t nread, const uv_buf_t *buf) {
    if (nread < 0) {
        if (nread != UV_EOF)
            fprintf(stderr, "Read error %s\n", uv_err_name(nread));
        uv_close((uv_handle_t*) q, NULL);
        return;
    }

    uv_pipe_t *pipe = (uv_pipe_t*) q;
    if (!uv_pipe_pending_count(pipe)) {
        fprintf(stderr, "No pending count\n");
        return;
    }

    uv_handle_type pending = uv_pipe_pending_type(pipe);
    assert(pending == UV_TCP);

    uv_tcp_t *client = (uv_tcp_t*) malloc(sizeof(uv_tcp_t));
    uv_tcp_init(loop, client);
    if (uv_accept(q, (uv_stream_t*) client) == 0) {
        uv_os_fd_t fd;
        uv_fileno((const uv_handle_t*) client, &fd);
        fprintf(stderr, "Worker %d: Accepted fd %d\n", getpid(), fd);
        uv_read_start((uv_stream_t*) client, alloc_buffer, echo_read);
    }
    else {
        uv_close((uv_handle_t*) client, NULL);
    }
}
```

首先，我们调用`uv_pipe_pending_count`来确定从handle中可以读取出数据。如果你的程序能够处理不同类型的handle，这时`uv_pipe_pending_type`就可以用来决定当前的类型。虽然在这里使用`accept`看起来很怪，但实际上是讲得通的。`accept`最常见的用途是从其他的文件描述符（监听的socket）获取文件描述符（client端）。这从原理上说，和我们现在要做的是一样的：从queue中获取文件描述符（client）。接下来，worker可以执行标准的echo服务器的工作了。  

我们再来看看主进程，观察如何启动worker来达到负载均衡。  

#### multi-echo-server/main.c

```c
struct child_worker {
    uv_process_t req;
    uv_process_options_t options;
    uv_pipe_t pipe;
} *workers;
```

`child_worker`结构包裹着进程，和连接主进程和各个独立进程的管道。  

#### multi-echo-server/main.c

```c
void setup_workers() {
    round_robin_counter = 0;

    // ...

    // launch same number of workers as number of CPUs
    uv_cpu_info_t *info;
    int cpu_count;
    uv_cpu_info(&info, &cpu_count);
    uv_free_cpu_info(info, cpu_count);

    child_worker_count = cpu_count;

    workers = calloc(sizeof(struct child_worker), cpu_count);
    while (cpu_count--) {
        struct child_worker *worker = &workers[cpu_count];
        uv_pipe_init(loop, &worker->pipe, 1);

        uv_stdio_container_t child_stdio[3];
        child_stdio[0].flags = UV_CREATE_PIPE | UV_READABLE_PIPE;
        child_stdio[0].data.stream = (uv_stream_t*) &worker->pipe;
        child_stdio[1].flags = UV_IGNORE;
        child_stdio[2].flags = UV_INHERIT_FD;
        child_stdio[2].data.fd = 2;

        worker->options.stdio = child_stdio;
        worker->options.stdio_count = 3;

        worker->options.exit_cb = close_process_handle;
        worker->options.file = args[0];
        worker->options.args = args;

        uv_spawn(loop, &worker->req, &worker->options); 
        fprintf(stderr, "Started worker %d\n", worker->req.pid);
    }
}
```

首先，我们使用酷炫的`uv_cpu_info`函数获取到当前的cpu的核心个数，所以我们也能启动一样数目的worker进程。再次强调一下，务必将`uv_pipe_init`的ipc参数设置为1。接下来，我们指定子进程的`stdin`是一个可读的管道（从子进程的角度来说）。接下来的一切就很直观了，worker进程被启动，等待着文件描述符被写入到他们的标准输入中。  

在主进程的`on_new_connection`中，我们接收了client端的socket，然后把它传递给worker环中的下一个可用的worker进程。  

#### multi-echo-server/main.c

```c
void on_new_connection(uv_stream_t *server, int status) {
    if (status == -1) {
        // error!
        return;
    }

    uv_tcp_t *client = (uv_tcp_t*) malloc(sizeof(uv_tcp_t));
    uv_tcp_init(loop, client);
    if (uv_accept(server, (uv_stream_t*) client) == 0) {
        uv_write_t *write_req = (uv_write_t*) malloc(sizeof(uv_write_t));
        dummy_buf = uv_buf_init("a", 1);
        struct child_worker *worker = &workers[round_robin_counter];
        uv_write2(write_req, (uv_stream_t*) &worker->pipe, &dummy_buf, 1, (uv_stream_t*) client, NULL);
        round_robin_counter = (round_robin_counter + 1) % child_worker_count;
    }
    else {
        uv_close((uv_handle_t*) client, NULL);
    }
}
```

`uv_write2`能够在所有的情形上做了一个很好的抽象，我们只需要将client作为一个参数即可完成传输。现在，我们的多进程echo服务器已经可以运转起来啦。  

感谢Kyle指出了`uv_write2`需要一个不为空的buffer。  
