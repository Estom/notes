# Advanced event loops

libuv提供了非常多的控制event-loop的方法，你能通过使用多loop来实现很多有趣的功能。你还可以将libuv的event loop嵌入到其它基于event-loop的库中。比如，想象着一个基于Qt的UI，然后Qt的event-loop是由libuv驱动的，做着加强级的系统任务。  

## Stopping an event loop

`uv_stop()`用来终止event loop。loop会停止的最早时间点是在下次循环的时候，或者稍晚些的时候。这也就意味着在本次循环中已经准备被处理的事件，依然会被处理，`uv_stop`不会起到作用。当`uv_stop`被调用，在当前的循环中，loop不会被IO操作阻塞。上面这些说得有点玄乎，还是让我们看下`uv_run()`的代码：  

#### src/unix/core.c - uv_run

```c
int uv_run(uv_loop_t* loop, uv_run_mode mode) {
  int timeout;
  int r;
  int ran_pending;

  r = uv__loop_alive(loop);
  if (!r)
    uv__update_time(loop);

  while (r != 0 && loop->stop_flag == 0) {
    uv__update_time(loop);
    uv__run_timers(loop);
    ran_pending = uv__run_pending(loop);
    uv__run_idle(loop);
    uv__run_prepare(loop);

    timeout = 0;
    if ((mode == UV_RUN_ONCE && !ran_pending) || mode == UV_RUN_DEFAULT)
      timeout = uv_backend_timeout(loop);

    uv__io_poll(loop, timeout);
```

`stop_flag`由`uv_stop`设置。现在所有的libuv回调函数都是在一次loop循环中被调用的，因此调用`uv_stop`并不能中止本次循环。首先，libuv会更新定时器，然后运行接下来的定时器，空转和准备回调，调用任何准备好的IO回调函数。如果你在它们之间的任何一个时间里，调用`uv_stop()`，`stop_flag`会被设置为1。这会导致`uv_backend_timeout()`返回0，这也就是为什么loop不会阻塞在I／O上。从另外的角度来说，你在任何一个检查handler中调用`uv_stop`，此时I/O已经完成，所以也没有影响。 

在已经得到结果，或是发生错误的时候，`uv_stop()`可以用来关闭一个loop，而且不需要保证handler停止的顺序。  

下面是一个简单的例子，它演示了loop的停止，以及当前的循环依旧在执行。  

#### uvstop/main.c

```c
#include <stdio.h>
#include <uv.h>

int64_t counter = 0;

void idle_cb(uv_idle_t *handle) {
    printf("Idle callback\n");
    counter++;

    if (counter >= 5) {
        uv_stop(uv_default_loop());
        printf("uv_stop() called\n");
    }
}

void prep_cb(uv_prepare_t *handle) {
    printf("Prep callback\n");
}

int main() {
    uv_idle_t idler;
    uv_prepare_t prep;

    uv_idle_init(uv_default_loop(), &idler);
    uv_idle_start(&idler, idle_cb);

    uv_prepare_init(uv_default_loop(), &prep);
    uv_prepare_start(&prep, prep_cb);

    uv_run(uv_default_loop(), UV_RUN_DEFAULT);

    return 0;
}
```

