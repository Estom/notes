# Filesystem

简单的文件读写是通过```uv_fs_*```函数族和与之相关的```uv_fs_t```结构体完成的。

#### note
>libuv 提供的文件操作和 socket operations 并不相同。套接字操作使用了操作系统本身提供了非阻塞操作，而文件操作内部使用了阻塞函数，但是 libuv 是在线程池中调用这些函数，并在应用程序需要交互时通知在事件循环中注册的监视器。

所有的文件操作函数都有两种形式 - 同步**(synchronous)** 和 异步**( asynchronous)**。

同步方式如果没有指定回调函数则会被自动调用( 并阻塞)，函数的返回值是[libuv error code](http://docs.libuv.org/en/v1.x/guide/basics.html#libuv-error-handling)  。但以上通常只对同步调用有意义。而异步方式则会在传入回调函数时被调用, 并且返回 0。

## Reading/Writing files


文件描述符可以采用如下方式获得：

```c
int uv_fs_open(uv_loop_t* loop, uv_fs_t* req, const char* path, int flags, int mode, uv_fs_cb cb)
```

参数```flags```与```mode```和标准的 Unix flags 相同。libuv 会小心地处理 Windows 环境下的相关标志位(flags)的转换, 所以编写跨平台程序时你不用担心不同平台上文件打开的标志位不同。

关闭文件描述符可以使用：

```c
int uv_fs_close(uv_loop_t* loop, uv_fs_t* req, uv_file file, uv_fs_cb cb)
```

文件系统的回调函数有如下的形式：

```c
void callback(uv_fs_t* req);
```

让我们看一下一个简单的```cat```命令的实现。我们通过当文件被打开时注册一个回调函数来开始：

#### uvcat/main.c - opening a file

```c
void on_open(uv_fs_t *req) {
    // The request passed to the callback is the same as the one the call setup
    // function was passed.
    assert(req == &open_req);
    if (req->result >= 0) {
        iov = uv_buf_init(buffer, sizeof(buffer));
        uv_fs_read(uv_default_loop(), &read_req, req->result,
                   &iov, 1, -1, on_read);
    }
    else {
        fprintf(stderr, "error opening file: %s\n", uv_strerror((int)req->result));
    }
}
```

`uv_fs_t`的`result`域保存了`uv_fs_open`回调函数**打开的文件描述符**。如果文件被正确地打开，我们可以开始读取了。

#### uvcat/main.c - read callback

```c
void on_read(uv_fs_t *req) {
    if (req->result < 0) {
        fprintf(stderr, "Read error: %s\n", uv_strerror(req->result));
    }
    else if (req->result == 0) {
        uv_fs_t close_req;
        // synchronous
        uv_fs_close(uv_default_loop(), &close_req, open_req.result, NULL);
    }
    else if (req->result > 0) {
        iov.len = req->result;
        uv_fs_write(uv_default_loop(), &write_req, 1, &iov, 1, -1, on_write);
    }
}
```

在调用读取函数的时候，你必须传递一个已经初始化的缓冲区，在```on_read()```被触发后，缓冲区被写入数据。```uv_fs_*```系列的函数是和POSIX的函数对应的，所以当读到文件的末尾时(EOF)，result返回0。在使用streams或者pipe的情况下，使用的是libuv自定义的```UV_EOF```。   

现在你看到类似的异步编程的模式。但是```uv_fs_close()```是同步的。一般来说，一次性的，开始的或者关闭的部分，都是同步的，因为我们一般关心的主要是任务和多路I/O的快速I/O。所以在这些对性能微不足道的地方，都是使用同步的，这样代码还会简单一些。  

文件系统的写入使用 ```uv_fs_write()```，当写入完成时会触发回调函数，在这个例子中回调函数会触发下一次的读取。
#### uvcat/main.c - write callback

```c
void on_write(uv_fs_t *req) {
    if (req->result < 0) {
        fprintf(stderr, "Write error: %s\n", uv_strerror((int)req->result));
    }
    else {
        uv_fs_read(uv_default_loop(), &read_req, open_req.result, &iov, 1, -1, on_read);
    }
}
```

##### Warning
>由于文件系统和磁盘的调度策略，写入成功的数据不一定就存在磁盘上。 

我们开始在main中推动多米诺骨牌：  

#### uvcat/main.c

```c
int main(int argc, char **argv) {
    uv_fs_open(uv_default_loop(), &open_req, argv[1], O_RDONLY, 0, on_open);
    uv_run(uv_default_loop(), UV_RUN_DEFAULT);

    uv_fs_req_cleanup(&open_req);
    uv_fs_req_cleanup(&read_req);
    uv_fs_req_cleanup(&write_req);
    return 0;
}
```

##### Warning
>函数uv_fs_req_cleanup()在文件系统操作结束后必须要被调用，用来回收在读写中分配的内存。

##Filesystem operations


所有像 ``unlink``, ``rmdir``, ``stat`` 这样的标准文件操作都是支持异步的，并且使用方法和上述类似。下面的各个函数的使用方法和read/write/open类似，在``uv_fs_t.result``中保存返回值。所有的函数如下所示：
（译者注：返回的result值，<0表示出错，其他值表示成功。但>=0的值在不同的函数中表示的意义不一样，比如在```uv_fs_read```或者```uv_fs_write```中，它代表读取或写入的数据总量，但在```uv_fs_open```中表示打开的文件描述符。）

```c
UV_EXTERN int uv_fs_close(uv_loop_t* loop,
                          uv_fs_t* req,
                          uv_file file,
                          uv_fs_cb cb);
UV_EXTERN int uv_fs_open(uv_loop_t* loop,
                         uv_fs_t* req,
                         const char* path,
                         int flags,
                         int mode,
                         uv_fs_cb cb);
UV_EXTERN int uv_fs_read(uv_loop_t* loop,
                         uv_fs_t* req,
                         uv_file file,
                         const uv_buf_t bufs[],
                         unsigned int nbufs,
                         int64_t offset,
                         uv_fs_cb cb);
UV_EXTERN int uv_fs_unlink(uv_loop_t* loop,
                           uv_fs_t* req,
                           const char* path,
                           uv_fs_cb cb);
UV_EXTERN int uv_fs_write(uv_loop_t* loop,
                          uv_fs_t* req,
                          uv_file file,
                          const uv_buf_t bufs[],
                          unsigned int nbufs,
                          int64_t offset,
                          uv_fs_cb cb);
UV_EXTERN int uv_fs_mkdir(uv_loop_t* loop,
                          uv_fs_t* req,
                          const char* path,
                          int mode,
                          uv_fs_cb cb);
UV_EXTERN int uv_fs_mkdtemp(uv_loop_t* loop,
                            uv_fs_t* req,
                            const char* tpl,
                            uv_fs_cb cb);
UV_EXTERN int uv_fs_rmdir(uv_loop_t* loop,
                          uv_fs_t* req,
                          const char* path,
                          uv_fs_cb cb);
UV_EXTERN int uv_fs_scandir(uv_loop_t* loop,
                            uv_fs_t* req,
                            const char* path,
                            int flags,
                            uv_fs_cb cb);
UV_EXTERN int uv_fs_scandir_next(uv_fs_t* req,
                                 uv_dirent_t* ent);
UV_EXTERN int uv_fs_stat(uv_loop_t* loop,
                         uv_fs_t* req,
                         const char* path,
                         uv_fs_cb cb);
UV_EXTERN int uv_fs_fstat(uv_loop_t* loop,
                          uv_fs_t* req,
                          uv_file file,
                          uv_fs_cb cb);
UV_EXTERN int uv_fs_rename(uv_loop_t* loop,
                           uv_fs_t* req,
                           const char* path,
                           const char* new_path,
                           uv_fs_cb cb);
UV_EXTERN int uv_fs_fsync(uv_loop_t* loop,
                          uv_fs_t* req,
                          uv_file file,
                          uv_fs_cb cb);
UV_EXTERN int uv_fs_fdatasync(uv_loop_t* loop,
                              uv_fs_t* req,
                              uv_file file,
                              uv_fs_cb cb);
UV_EXTERN int uv_fs_ftruncate(uv_loop_t* loop,
                              uv_fs_t* req,
                              uv_file file,
                              int64_t offset,
                              uv_fs_cb cb);
UV_EXTERN int uv_fs_sendfile(uv_loop_t* loop,
                             uv_fs_t* req,
                             uv_file out_fd,
                             uv_file in_fd,
                             int64_t in_offset,
                             size_t length,
                             uv_fs_cb cb);
UV_EXTERN int uv_fs_access(uv_loop_t* loop,
                           uv_fs_t* req,
                           const char* path,
                           int mode,
                           uv_fs_cb cb);
UV_EXTERN int uv_fs_chmod(uv_loop_t* loop,
                          uv_fs_t* req,
                          const char* path,
                          int mode,
                          uv_fs_cb cb);
UV_EXTERN int uv_fs_utime(uv_loop_t* loop,
                          uv_fs_t* req,
                          const char* path,
                          double atime,
                          double mtime,
                          uv_fs_cb cb);
UV_EXTERN int uv_fs_futime(uv_loop_t* loop,
                           uv_fs_t* req,
                           uv_file file,
                           double atime,
                           double mtime,
                           uv_fs_cb cb);
UV_EXTERN int uv_fs_lstat(uv_loop_t* loop,
                          uv_fs_t* req,
                          const char* path,
                          uv_fs_cb cb);
UV_EXTERN int uv_fs_link(uv_loop_t* loop,
                         uv_fs_t* req,
                         const char* path,
                         const char* new_path,
                         uv_fs_cb cb);
```

## Buffers and Streams

在libuv中，最基础的I/O操作是流stream(``uv_stream_t``)。TCP套接字，UDP套接字，管道对于文件I/O和IPC来说，都可以看成是流stream(``uv_stream_t``)的子类。
上面提到的各个流的子类都有各自的初始化函数，然后可以使用下面的函数操作：

```c
int uv_read_start(uv_stream_t*, uv_alloc_cb alloc_cb, uv_read_cb read_cb);
int uv_read_stop(uv_stream_t*);
int uv_write(uv_write_t* req, uv_stream_t* handle,
                 const uv_buf_t bufs[], unsigned int nbufs, uv_write_cb cb);
```

可以看出，流操作要比上述的文件操作要简单一些，而且当``uv_read_start()``一旦被调用，libuv会保持从流中持续地读取数据，直到``uv_read_stop()``被调用。
数据的离散单元是buffer-``uv_buffer_t``。它包含了指向数据的开始地址的指针(``uv_buf_t.base``)和buffer的长度(``uv_buf_t.len``)这两个信息。``uv_buf_t``很轻量级，使用值传递。我们需要管理的只是实际的数据，即程序必须自己分配和回收内存。

**ERROR：**

    THIS PROGRAM DOES NOT ALWAYS WORK, NEED SOMETHING BETTER

为了更好地演示流stream，我们将会使用``uv_pipe_t``。它可以将本地文件转换为流（stream）的形态。接下来的这个是使用libuv实现的，一个简单的tee工具（如果不是很了解，请看[维基百科](https://en.wikipedia.org/wiki/Tee_(command))）。所有的操作都是异步的，这也正是事件驱动I/O的威力所在。两个输出操作不会相互阻塞，但是我们也必须要注意，确保一块缓冲区不会在还没有写入之前，就提前被回收了。  

这个程序执行命令如下

```
./uvtee <output_file>
```

在使用pipe打开文件时，libuv会默认地以可读和可写的方式打开文件。

#### uvtee/main.c - read on pipes

```c
int main(int argc, char **argv) {
    loop = uv_default_loop();

    uv_pipe_init(loop, &stdin_pipe, 0);
    uv_pipe_open(&stdin_pipe, 0);

    uv_pipe_init(loop, &stdout_pipe, 0);
    uv_pipe_open(&stdout_pipe, 1);
    
    uv_fs_t file_req;
    int fd = uv_fs_open(loop, &file_req, argv[1], O_CREAT | O_RDWR, 0644, NULL);
    uv_pipe_init(loop, &file_pipe, 0);
    uv_pipe_open(&file_pipe, fd);

    uv_read_start((uv_stream_t*)&stdin_pipe, alloc_buffer, read_stdin);

    uv_run(loop, UV_RUN_DEFAULT);
    return 0;
}	
```

当需要使用具名管道的时候（**译注：匿名管道 是Unix最初的IPC形式，但是由于匿名管道的局限性，后来出现了具名管道 FIFO，这种管道由于可以在文件系统中创建一个名字，所以可以被没有亲缘关系的进程访问**），``uv_pipe_init()``的第三个参数应该被设置为1。这部分会在Process进程的这一章节说明。``uv_pipe_open()``函数把管道和文件描述符关联起来，在上面的代码中表示把管道``stdin_pipe``和标准输入关联起来（**译者注：``0``代表标准输入，``1``代表标准输出，``2``代表标准错误输出**）。  

当调用``uv_read_start()``后，我们开始监听``stdin``，当需要新的缓冲区来存储数据时，调用alloc_buffer，在函数``read_stdin()``中可以定义缓冲区中的数据处理操作。

#### uvtee/main.c - reading buffers

```c
void alloc_buffer(uv_handle_t *handle, size_t suggested_size, uv_buf_t *buf) {
    *buf = uv_buf_init((char*) malloc(suggested_size), suggested_size);
}

void read_stdin(uv_stream_t *stream, ssize_t nread, const uv_buf_t *buf) {
    if (nread < 0){
        if (nread == UV_EOF){
            // end of file
            uv_close((uv_handle_t *)&stdin_pipe, NULL);
            uv_close((uv_handle_t *)&stdout_pipe, NULL);
            uv_close((uv_handle_t *)&file_pipe, NULL);
        }
    } else if (nread > 0) {
        write_data((uv_stream_t *)&stdout_pipe, nread, *buf, on_stdout_write);
        write_data((uv_stream_t *)&file_pipe, nread, *buf, on_file_write);
    }

    if (buf->base)
        free(buf->base);
}
```

标准的``malloc``是非常高效的方法，但是你依然可以使用其它的内存分配的策略。比如，nodejs使用自己的内存分配方法（```Smalloc```），它将buffer用v8的对象关联起来，具体的可以查看[nodejs的官方文档](https://nodejs.org/docs/v0.11.5/api/smalloc.html)。  

当回调函数```read_stdin()```的nread参数小于0时，表示错误发生了。其中一种可能的错误是EOF(**读到文件的尾部**)，这时我们可以使用函数```uv_close()```关闭流了。除此之外，当nread大于0时，nread代表我们可以向输出流中写入的字节数目。最后注意，缓冲区要由我们手动回收。  

当分配函数```alloc_buf()```返回一个长度为0的缓冲区时，代表它分配内存失败。在这种情况下，读取的回调函数会被错误```UV_ENOBUFS```唤醒。libuv同时也会继续尝试从流中读取数据，所以如果你想要停止的话，必须明确地调用```uv_close()```. 

当nread为0时，代表已经没有可读的了，大多数的程序会自动忽略这个。  

#### uvtee/main.c - Write to pipe

```c
typedef struct {
    uv_write_t req;
    uv_buf_t buf;
} write_req_t;

void free_write_req(uv_write_t *req) {
    write_req_t *wr = (write_req_t*) req;
    free(wr->buf.base);
    free(wr);
}

void on_stdout_write(uv_write_t *req, int status) {
    free_write_req(req);
}

void on_file_write(uv_write_t *req, int status) {
    free_write_req(req);
}

void write_data(uv_stream_t *dest, size_t size, uv_buf_t buf, uv_write_cb cb) {
    write_req_t *req = (write_req_t*) malloc(sizeof(write_req_t));
    req->buf = uv_buf_init((char*) malloc(size), size);
    memcpy(req->buf.base, buf.base, size);
    uv_write((uv_write_t*) req, (uv_stream_t*)dest, &req->buf, 1, cb);
}
```

`write_data()`开辟了一块地址空间存储从缓冲区读取出来的数据。这块缓存不会被释放，直到与``uv_write()``绑定的回调函数执行。为了实现它，我们用结构体``write_req_t``包裹一个write request和一个buffer，然后在回调函数中展开它。因为我们复制了一份缓存，所以我们可以在两个``write_data()``中独立释放两个缓存。 我们之所以这样做是因为，两个调用`write_data()`是相互独立的。为了保证它们不会因为读取速度的原因，由于共享一片缓冲区而损失掉独立性，所以才开辟了新的两块区域。当然这只是一个简单的例子，你可以使用更聪明的内存管理方法来实现它，比如引用计数或者缓冲区池等。    


##### WARNING
>你的程序在被其他的程序调用的过程中，有意无意地会向pipe写入数据，这样的话它会很容易被信号SIGPIPE终止掉，你最好在初始化程序的时候加入这句： 
>`signal(SIGPIPE, SIG_IGN)`。


## File change events

所有的现代操作系统都会提供相应的API来监视文件和文件夹的变化(**如Linux的inotify，Darwin的FSEvents，BSD的kqueue，Windows的ReadDirectoryChangesW， Solaris的event ports**)。libuv同样包括了这样的文件监视库。这是libuv中很不协调的部分，因为在跨平台的前提上，实现这个功能很难。为了更好地说明，我们现在来写一个监视文件变化的命令： 

```
./onchange <command> <file1> [file2] ...
```
实现这个监视器，要从```uv_fs_event_init()```开始：

#### onchange/main.c - The setup
```c
int main(int argc, char **argv) {
    if (argc <= 2) {
        fprintf(stderr, "Usage: %s <command> <file1> [file2 ...]\n", argv[0]);
        return 1;
    }

    loop = uv_default_loop();
    command = argv[1];

    while (argc-- > 2) {
        fprintf(stderr, "Adding watch on %s\n", argv[argc]);
        uv_fs_event_t *fs_event_req = malloc(sizeof(uv_fs_event_t));
        uv_fs_event_init(loop, fs_event_req);
        // The recursive flag watches subdirectories too.
        uv_fs_event_start(fs_event_req, run_command, argv[argc], UV_FS_EVENT_RECURSIVE);
    }

    return uv_run(loop, UV_RUN_DEFAULT);
}
```

函数```uv_fs_event_start()```的第三个参数是要监视的文件或文件夹。最后一个参数，```flags```，可以是：   

```
  UV_FS_EVENT_WATCH_ENTRY = 1,
  UV_FS_EVENT_STAT = 2,
  UV_FS_EVENT_RECURSIVE = 4
```

`UV_FS_EVENT_WATCH_ENTRY`和`UV_FS_EVENT_STAT`不做任何事情(至少目前是这样)，`UV_FS_EVENT_RECURSIVE`可以在支持的系统平台上递归地监视子文件夹。 
在回调函数`run_command()`中，接收的参数如下：  
>1.`uv_fs_event_t *handle`-句柄。里面的path保存了发生改变的文件的地址。 
>2.`const char *filename`-如果目录被监视，它代表发生改变的文件名。只在Linux和Windows上不为null，在其他平台上可能为null。 
>3.`int flags` -`UV_RENAME`名字改变，`UV_CHANGE`内容改变之一，或者他们两者的按位或的结果(`|`)。 
>4.`int status`－当前为0。

在我们的例子中，只是简单地打印参数和调用`system()`运行command.

#### onchange/main.c - file change notification callback
```c
void run_command(uv_fs_event_t *handle, const char *filename, int events, int status) {
    char path[1024];
    size_t size = 1023;
    // Does not handle error if path is longer than 1023.
    uv_fs_event_getpath(handle, path, &size);
    path[size] = '\0';

    fprintf(stderr, "Change detected in %s: ", path);
    if (events & UV_RENAME)
        fprintf(stderr, "renamed");
    if (events & UV_CHANGE)
        fprintf(stderr, "changed");

    fprintf(stderr, " %s\n", filename ? filename : "");
    system(command);
}
```

----


