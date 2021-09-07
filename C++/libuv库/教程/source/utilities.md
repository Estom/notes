# Utilities

本章介绍的工具和技术对于常见的任务非常的实用。libuv吸收了[libev用户手册页](http://pod.tst.eu/http://cvs.schmorp.de/libev/ev.pod#COMMON_OR_USEFUL_IDIOMS_OR_BOTH)中所涵盖的一些模式，并在此基础上对API做了少许的改动。本章还包含了一些无需用完整的一章来介绍的libuv API。  

## Timers

在定时器启动后的特定时间后，定时器会调用回调函数。libuv的定时器还可以设定为，按时间间隔定时启动，而不是只启动一次。  
可以简单地使用超时时间`timeout`作为参数初始化一个定时器，还有一个可选参数`repeat`。定时器能在任何时间被终止。  

```c
uv_timer_t timer_req;

uv_timer_init(loop, &timer_req);
uv_timer_start(&timer_req, callback, 5000, 2000);
```

上述操作会启动一个循环定时器（repeating timer），它会在调用`uv_timer_start`后，5秒（timeout）启动回调函数，然后每隔2秒（repeat）循环启动回调函数。你可以使用：  

```c
uv_timer_stop(&timer_req);
```

来停止定时器。这个函数也可以在回调函数中安全地使用。  

循环的间隔也可以随时定义，使用：  

```c
uv_timer_set_repeat(uv_timer_t *timer, int64_t repeat);
```

它会在**可能的时候**发挥作用。如果上述函数是在定时器回调函数中调用的，这意味着：  

>* 如果定时器未设置为循环，这意味着定时器已经停止。需要先用`uv_timer_start`重新启动。  
* 如果定时器被设置为循环，那么下一次超时的时间已经被规划好了，所以在切换到新的间隔之前，旧的间隔还会发挥一次作用。  

函数：  

```c
int uv_timer_again(uv_timer_t *)
```

**只适用于循环定时器**，相当于停止定时器，然后把原先的`timeout`和`repeat`值都设置为之前的`repeat`值，启动定时器。如果当该函数调用时，定时器未启动，则调用失败（错误码为`UV_EINVAL`）并且返回－1。  

下面的一节会出现使用定时器的例子。  

## Event loop reference count

event-loop在没有了活跃的handle之后，便会终止。整套系统的工作方式是：在handle增加时，event-loop的引用计数加1，在handle停止时，引用计数减少1。当然，libuv也允许手动地更改引用计数，通过使用：  

```c
void uv_ref(uv_handle_t*);
void uv_unref(uv_handle_t*);
```

这样，就可以达到允许loop即使在有正在活动的定时器时，仍然能够推出。或者是使用自定义的uv_handle_t对象来使得loop保持工作。  

第二个函数可以和间隔循环定时器结合使用。你会有一个每隔x秒执行一次的垃圾回收器，或者是你的网络服务器会每隔一段时间向其他人发送一次心跳信号，但是你不想只有在所有垃圾回收完或者出现错误时才能停止他们。如果你想要在你其他的监视器都退出后，终止程序。这时你就可以立即unref定时器，即便定时器这时是loop上唯一还在运行的监视器，你依旧可以停止`uv_run()`。  

它们同样会出现在node.js中，如js的API中封装的libuv方法。每一个js的对象产生一个`uv_handle_t`（所有监视器的超类），同样可以被uv_ref和uv_unref。  

#### ref-timer/main.c

```c
uv_loop_t *loop;
uv_timer_t gc_req;
uv_timer_t fake_job_req;

int main() {
    loop = uv_default_loop();

    uv_timer_init(loop, &gc_req);
    uv_unref((uv_handle_t*) &gc_req);

    uv_timer_start(&gc_req, gc, 0, 2000);

    // could actually be a TCP download or something
    uv_timer_init(loop, &fake_job_req);
    uv_timer_start(&fake_job_req, fake_job, 9000, 0);
    return uv_run(loop, UV_RUN_DEFAULT);
}
```

首先初始化垃圾回收器的定时器，然后在立刻`unref`它。注意观察9秒之后，此时fake_job完成，程序会自动退出，即使垃圾回收器还在运行。  

## Idler pattern

空转的回调函数会在每一次的event-loop循环激发一次。空转的回调函数可以用来执行一些优先级较低的活动。比如，你可以向开发者发送应用程序的每日性能表现情况，以便于分析，或者是使用用户应用cpu时间来做[SETI](http://www.seti.org)运算:)。空转程序还可以用于GUI应用。比如你在使用event-loop来下载文件，如果tcp连接未中断而且当前并没有其他的事件，则你的event-loop会阻塞，这也就意味着你的下载进度条会停滞，用户会面对一个无响应的程序。面对这种情况，空转监视器可以保持UI可操作。  

#### idle-compute/main.c

```c
uv_loop_t *loop;
uv_fs_t stdin_watcher;
uv_idle_t idler;
char buffer[1024];

int main() {
    loop = uv_default_loop();

    uv_idle_init(loop, &idler);

    uv_buf_t buf = uv_buf_init(buffer, 1024);
    uv_fs_read(loop, &stdin_watcher, 0, &buf, 1, -1, on_type);
    uv_idle_start(&idler, crunch_away);
    return uv_run(loop, UV_RUN_DEFAULT);
}
```

上述程序中，我们将空转监视器和我们真正关心的事件排在一起。`crunch_away`会被循环地调用，直到输入字符并回车。然后程序会被中断很短的时间，用来处理数据读取，然后在接着调用空转的回调函数。  

#### idle-compute/main.c

```c
void crunch_away(uv_idle_t* handle) {
    // Compute extra-terrestrial life
    // fold proteins
    // computer another digit of PI
    // or similar
    fprintf(stderr, "Computing PI...\n");
    // just to avoid overwhelming your terminal emulator
    uv_idle_stop(handle);
}
```

## Passing data to worker thread

在使用`uv_queue_work`的时候，你通常需要给工作线程传递复杂的数据。解决方案是自定义struct，然后使用`uv_work_t.data`指向它。一个稍微的不同是必须让`uv_work_t`作为这个自定义struct的成员之一（把这叫做接力棒）。这么做就可以使得，同时回收数据和`uv_wortk_t`。  

```c
struct ftp_baton {
    uv_work_t req;
    char *host;
    int port;
    char *username;
    char *password;
}
```

```c
ftp_baton *baton = (ftp_baton*) malloc(sizeof(ftp_baton));
baton->req.data = (void*) baton;
baton->host = strdup("my.webhost.com");
baton->port = 21;
// ...

uv_queue_work(loop, &baton->req, ftp_session, ftp_cleanup);
```

现在我们创建完了接力棒，并把它排入了队列中。  

现在就可以随性所欲地获取自己想要的数据啦。  

```c
void ftp_session(uv_work_t *req) {
    ftp_baton *baton = (ftp_baton*) req->data;

    fprintf(stderr, "Connecting to %s\n", baton->host);
}

void ftp_cleanup(uv_work_t *req) {
    ftp_baton *baton = (ftp_baton*) req->data;

    free(baton->host);
    // ...
    free(baton);
}
```

我们既回收了接力棒，同时也回收了监视器。  

## External I/O with polling

通常在使用第三方库的时候，需要应对他们自己的IO，还有保持监视他们的socket和内部文件。在此情形下，不可能使用标准的IO流操作，但第三方库仍然能整合进event-loop中。所有这些需要的就是，第三方库就必须允许你访问它的底层文件描述符，并且提供可以处理有用户定义的细微任务的函数。但是一些第三库并不允许你这么做，他们只提供了一个标准的阻塞IO函数，此函数会完成所有的工作并返回。在event-loop的线程直接使用它们是不明智的，而是应该使用libuv的工作线程。当然，这也意味着失去了对第三方库的颗粒化控制。  

libuv的`uv_poll`简单地监视了使用了操作系统的监控机制的文件描述符。从某方面说，libuv实现的所有的IO操作，的背后均有`uv_poll`的支持。无论操作系统何时监视到文件描述符的改变，libuv都会调用响应的回调函数。  

现在我们简单地实现一个下载管理程序，它会通过[libcurl](http://curl.haxx.se/libcurl/)来下载文件。我们不会直接控制libcurl，而是使用libuv的event-loop，通过非阻塞的异步的[多重接口](http://curl.haxx.se/libcurl/c/libcurl-multi.html)来处理下载，与此同时，libuv会监控IO的就绪状态。  

#### uvwget/main.c - The setup

```c
#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <uv.h>
#include <curl/curl.h>

uv_loop_t *loop;
CURLM *curl_handle;
uv_timer_t timeout;
}

int main(int argc, char **argv) {
    loop = uv_default_loop();

    if (argc <= 1)
        return 0;

    if (curl_global_init(CURL_GLOBAL_ALL)) {
        fprintf(stderr, "Could not init cURL\n");
        return 1;
    }

    uv_timer_init(loop, &timeout);

    curl_handle = curl_multi_init();
    curl_multi_setopt(curl_handle, CURLMOPT_SOCKETFUNCTION, handle_socket);
    curl_multi_setopt(curl_handle, CURLMOPT_TIMERFUNCTION, start_timeout);

    while (argc-- > 1) {
        add_download(argv[argc], argc);
    }

    uv_run(loop, UV_RUN_DEFAULT);
    curl_multi_cleanup(curl_handle);
    return 0;
}
```

每种库整合进libuv的方式都是不同的。以libcurl的例子来说，我们注册了两个回调函数。socket回调函数`handle_socket`会在socket状态改变的时候被触发，因此我们不得不开始轮询它。`start_timeout`是libcurl用来告知我们下一次的超时间隔的，之后我们就应该不管当前IO状态，驱动libcurl向前。这些也就是libcurl能处理错误或驱动下载进度向前的原因。  

可以这么调用下载器：  

```
$ ./uvwget [url1] [url2] ...
```

我们可以把url当成参数传入程序。  

#### uvwget/main.c - Adding urls

```c
void add_download(const char *url, int num) {
    char filename[50];
    sprintf(filename, "%d.download", num);
    FILE *file;

    file = fopen(filename, "w");
    if (file == NULL) {
        fprintf(stderr, "Error opening %s\n", filename);
        return;
    }

    CURL *handle = curl_easy_init();
    curl_easy_setopt(handle, CURLOPT_WRITEDATA, file);
    curl_easy_setopt(handle, CURLOPT_URL, url);
    curl_multi_add_handle(curl_handle, handle);
    fprintf(stderr, "Added download %s -> %s\n", url, filename);
}
```

我们允许libcurl直接向文件写入数据。  

`start_timeout`会被libcurl立即调用。它会启动一个libuv的定时器，使用`CURL_SOCKET_TIMEOUT`驱动`curl_multi_socket_action`，当其超时时，调用它。`curl_multi_socket_action`会驱动libcurl，也会在socket状态改变的时候被调用。但在我们深入讲解它之前，我们需要轮询监听socket，等待`handle_socket`被调用。  

#### uvwget/main.c - Setting up polling

```c
void start_timeout(CURLM *multi, long timeout_ms, void *userp) {
    if (timeout_ms <= 0)
        timeout_ms = 1; /* 0 means directly call socket_action, but we'll do it in a bit */
    uv_timer_start(&timeout, on_timeout, timeout_ms, 0);
}

int handle_socket(CURL *easy, curl_socket_t s, int action, void *userp, void *socketp) {
    curl_context_t *curl_context;
    if (action == CURL_POLL_IN || action == CURL_POLL_OUT) {
        if (socketp) {
            curl_context = (curl_context_t*) socketp;
        }
        else {
            curl_context = create_curl_context(s);
            curl_multi_assign(curl_handle, s, (void *) curl_context);
        }
    }

    switch (action) {
        case CURL_POLL_IN:
            uv_poll_start(&curl_context->poll_handle, UV_READABLE, curl_perform);
            break;
        case CURL_POLL_OUT:
            uv_poll_start(&curl_context->poll_handle, UV_WRITABLE, curl_perform);
            break;
        case CURL_POLL_REMOVE:
            if (socketp) {
                uv_poll_stop(&((curl_context_t*)socketp)->poll_handle);
                destroy_curl_context((curl_context_t*) socketp);                
                curl_multi_assign(curl_handle, s, NULL);
            }
            break;
        default:
            abort();
    }

    return 0;
}
```

我们关心的是socket的文件描述符s，还有action。对应每一个socket，我们都创造了`uv_poll_t`，并用`curl_multi_assign`把它们关联起来。每当回调函数被调用时，`socketp`都会指向它。  

在下载完成或失败后，libcurl需要移除poll。所以我们停止并回收了poll的handle。  

我们使用`UV_READABLE`或`UV_WRITABLE`开始轮询，基于libcurl想要监视的事件。当socket已经准备好读或写后，libuv会调用轮询的回调函数。在相同的handle上调用多次`uv_poll_start`是被允许的，这么做可以更新事件的参数。`curl_perform`是整个程序的关键。  

#### uvwget/main.c - Driving libcurl.

```c
void curl_perform(uv_poll_t *req, int status, int events) {
    uv_timer_stop(&timeout);
    int running_handles;
    int flags = 0;
    if (status < 0)                      flags = CURL_CSELECT_ERR;
    if (!status && events & UV_READABLE) flags |= CURL_CSELECT_IN;
    if (!status && events & UV_WRITABLE) flags |= CURL_CSELECT_OUT;

    curl_context_t *context;

    context = (curl_context_t*)req;

    curl_multi_socket_action(curl_handle, context->sockfd, flags, &running_handles);
    check_multi_info();   
}
```

首先我们要做的是停止定时器，因为内部还有其他要做的事。接下来我们我们依据触发回调函数的事件，来设置flag。然后，我们使用上述socket和flag作为参数，来调用`curl_multi_socket_action`。在此刻libcurl会在内部完成所有的工作，然后尽快地返回事件驱动程序在主线程中急需的数据。libcurl会在自己的队列中将传输进度的消息排队。对于我们来说，我们只关心是否传输完成，这类消息。所以我们将这类消息提取出来，并将传输完成的handle回收。  

#### uvwget/main.c - Reading transfer status.

```c
void check_multi_info(void) {
    char *done_url;
    CURLMsg *message;
    int pending;

    while ((message = curl_multi_info_read(curl_handle, &pending))) {
        switch (message->msg) {
        case CURLMSG_DONE:
            curl_easy_getinfo(message->easy_handle, CURLINFO_EFFECTIVE_URL,
                            &done_url);
            printf("%s DONE\n", done_url);

            curl_multi_remove_handle(curl_handle, message->easy_handle);
            curl_easy_cleanup(message->easy_handle);
            break;

        default:
            fprintf(stderr, "CURLMSG default\n");
            abort();
        }
    }
}
```

## Loading libraries

libuv提供了一个跨平台的API来加载[共享库shared libraries](http://liaoph.com/linux-shared-libary/)。这就可以用来实现你自己的插件／扩展／模块系统，它们可以被nodejs通过`require()`调用。只要你的库输出的是正确的符号，用起来还是很简单的。在载入第三方库的时候，要注意错误和安全检查，否则你的程序就会表现出不可预测的行为。下面这个例子实现了一个简单的插件，它只是打印出了自己的名字。  

首先看下提供给插件作者的接口。  

#### plugin/plugin.h

```c
#ifndef UVBOOK_PLUGIN_SYSTEM
#define UVBOOK_PLUGIN_SYSTEM

// Plugin authors should use this to register their plugins with mfp.
void mfp_register(const char *name);

#endif
```

你可以在你的程序中给插件添加更多有用的功能（mfp is My Fancy Plugin）。使用了这个api的插件的例子：  

#### plugin/hello.c

```c
#include "plugin.h"

void initialize() {
    mfp_register("Hello World!");
}
```

我们的接口定义了，所有的插件都应该有一个能被程序调用的`initialize`函数。这个插件被编译成了共享库，因此可以被我们的程序在运行的时候载入。  

```
$ ./plugin libhello.dylib
Loading libhello.dylib
Registered plugin "Hello World!"
```

##### Note
>共享库的后缀名在不同平台上是不一样的。在Linux上是libhello.so。

使用`uv_dlopen`首先载入了共享库`libhello.dylib`。再使用`uv_dlsym`获取了该插件的`initialize`函数，最后在调用它。  

#### plugin/main.c

```c
#include "plugin.h"

typedef void (*init_plugin_function)();

void mfp_register(const char *name) {
    fprintf(stderr, "Registered plugin \"%s\"\n", name);
}

int main(int argc, char **argv) {
    if (argc == 1) {
        fprintf(stderr, "Usage: %s [plugin1] [plugin2] ...\n", argv[0]);
        return 0;
    }

    uv_lib_t *lib = (uv_lib_t*) malloc(sizeof(uv_lib_t));
    while (--argc) {
        fprintf(stderr, "Loading %s\n", argv[argc]);
        if (uv_dlopen(argv[argc], lib)) {
            fprintf(stderr, "Error: %s\n", uv_dlerror(lib));
            continue;
        }

        init_plugin_function init_plugin;
        if (uv_dlsym(lib, "initialize", (void **) &init_plugin)) {
            fprintf(stderr, "dlsym error: %s\n", uv_dlerror(lib));
            continue;
        }

        init_plugin();
    }

    return 0;
}
```

函数`uv_dlopen`需要传入一个共享库的路径作为参数。当它成功时返回0，出错时返回－1。使用`uv_dlerror`可以获取出错的消息。  

`uv_dlsym`的第三个参数保存了一个指向第二个参数所保存的函数的指针。`init_plugin_function`是一个函数的指针，它指向了我们所需要的程序插件的函数。  

## TTY

文字终端长期支持非常标准化的[控制序列](https://en.wikipedia.org/wiki/ANSI_escape_code)。它经常被用来增强终端输出的可读性。例如`grep --colour`。libuv提供了跨平台的，`uv_tty_t`抽象（stream）和相关的处理ANSI escape codes 的函数。这也就是说，libuv同样在Windows上实现了对等的ANSI codes，并且提供了获取终端信息的函数。  

首先要做的是，使用读／写文件描述符来初始化`uv_tty_t`。如下：  

```c
int uv_tty_init(uv_loop_t*, uv_tty_t*, uv_file fd, int readable)
```

设置`readable`为true，意味着你打算使用`uv_read_start`从stream从中读取数据。  

最好还要使用`uv_tty_set_mode`来设置其为正常模式。也就是运行大多数的TTY格式，流控制和其他的设置。其他的模式还有[这些](http://docs.libuv.org/en/v1.x/tty.html#c.uv_tty_mode_t)。  

记得当你的程序退出后，要使用`uv_tty_reset_mode`恢复终端的状态。这才是礼貌的做法。另外要注意礼貌的地方是关心重定向。如果使用者将你的命令的输出重定向到文件，控制序列不应该被重写，因为这会阻碍可读性和grep。为了保证文件描述符确实是TTY，可以使用`uv_guess_handle`函数，比较返回值是否为`UV_TTY`。  

下面是一个把白字打印到红色背景上的例子。  

#### tty/main.c

```c
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <uv.h>

uv_loop_t *loop;
uv_tty_t tty;
int main() {
    loop = uv_default_loop();

    uv_tty_init(loop, &tty, 1, 0);
    uv_tty_set_mode(&tty, UV_TTY_MODE_NORMAL);
    
    if (uv_guess_handle(1) == UV_TTY) {
        uv_write_t req;
        uv_buf_t buf;
        buf.base = "\033[41;37m";
        buf.len = strlen(buf.base);
        uv_write(&req, (uv_stream_t*) &tty, &buf, 1, NULL);
    }

    uv_write_t req;
    uv_buf_t buf;
    buf.base = "Hello TTY\n";
    buf.len = strlen(buf.base);
    uv_write(&req, (uv_stream_t*) &tty, &buf, 1, NULL);
    uv_tty_reset_mode();
    return uv_run(loop, UV_RUN_DEFAULT);
}
```

最后要说的是`uv_tty_get_winsize()`，它能获取到终端的宽和长，当成功获取后返回0。下面这个小程序实现了一个动画的效果。  

#### tty-gravity/main.c

```c
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <uv.h>

uv_loop_t *loop;
uv_tty_t tty;
uv_timer_t tick;
uv_write_t write_req;
int width, height;
int pos = 0;
char *message = "  Hello TTY  ";

void update(uv_timer_t *req) {
    char data[500];

    uv_buf_t buf;
    buf.base = data;
    buf.len = sprintf(data, "\033[2J\033[H\033[%dB\033[%luC\033[42;37m%s",
                            pos,
                            (unsigned long) (width-strlen(message))/2,
                            message);
    uv_write(&write_req, (uv_stream_t*) &tty, &buf, 1, NULL);

    pos++;
    if (pos > height) {
        uv_tty_reset_mode();
        uv_timer_stop(&tick);
    }
}

int main() {
    loop = uv_default_loop();

    uv_tty_init(loop, &tty, 1, 0);
    uv_tty_set_mode(&tty, 0);
    
    if (uv_tty_get_winsize(&tty, &width, &height)) {
        fprintf(stderr, "Could not get TTY information\n");
        uv_tty_reset_mode();
        return 1;
    }

    fprintf(stderr, "Width %d, height %d\n", width, height);
    uv_timer_init(loop, &tick);
    uv_timer_start(&tick, update, 200, 200);
    return uv_run(loop, UV_RUN_DEFAULT);
}
```

escape codes的对应表如下：  

代码 | 意义 
------------ | ------------- 
2 J | Clear part of the screen, 2 is entire screen
H | Moves cursor to certain position, default top-left
n B | Moves cursor down by n lines
n C | Moves cursor right by n columns
m | Obeys string of display settings, in this case green background (40+2), white text (30+7)

正如你所见，它能输出酷炫的效果，你甚至可以发挥想象，用它来制作电子游戏。更有趣的输出，可以使用`http://www.gnu.org/software/ncurses/ncurses.html`。  

 
