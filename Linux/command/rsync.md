rsync
===

远程数据同步工具

## 补充说明

**rsync命令** 是一个远程数据同步工具，可通过LAN/WAN快速同步多台主机间的文件。rsync使用所谓的“rsync算法”来使本地和远程两个主机之间的文件达到同步，这个算法只传送两个文件的不同部分，而不是每次都整份传送，因此速度相当快。 rsync是一个功能非常强大的工具，其命令也有很多功能特色选项，我们下面就对它的选项一一进行分析说明。

### 语法

```shell
rsync [OPTION]... SRC DEST
rsync [OPTION]... SRC [USER@]host:DEST
rsync [OPTION]... [USER@]HOST:SRC DEST
rsync [OPTION]... [USER@]HOST::SRC DEST
rsync [OPTION]... SRC [USER@]HOST::DEST
rsync [OPTION]... rsync://[USER@]HOST[:PORT]/SRC [DEST]
```

对应于以上六种命令格式，rsync有六种不同的工作模式：

1.  拷贝本地文件。当SRC和DES路径信息都不包含有单个冒号":"分隔符时就启动这种工作模式。如：`rsync -a /data /backup`
2.  使用一个远程shell程序(如rsh、ssh)来实现将本地机器的内容拷贝到远程机器。当DST路径地址包含单个冒号":"分隔符时启动该模式。如：`rsync -avz *.c foo:src`
3.  使用一个远程shell程序(如rsh、ssh)来实现将远程机器的内容拷贝到本地机器。当SRC地址路径包含单个冒号":"分隔符时启动该模式。如：`rsync -avz foo:src/bar /data`
4.  从远程rsync服务器中拷贝文件到本地机。当SRC路径信息包含"::"分隔符时启动该模式。如：`rsync -av root@192.168.78.192::www /databack`
5.  从本地机器拷贝文件到远程rsync服务器中。当DST路径信息包含"::"分隔符时启动该模式。如：`rsync -av /databack root@192.168.78.192::www`
6.  列远程机的文件列表。这类似于rsync传输，不过只要在命令中省略掉本地机信息即可。如：`rsync -v rsync://192.168.78.192/www`

### 选项

```shell
-v, --verbose 详细模式输出。
-q, --quiet 精简输出模式。
-c, --checksum 打开校验开关，强制对文件传输进行校验。
-a, --archive 归档模式，表示以递归方式传输文件，并保持所有文件属性，等于-rlptgoD。
-r, --recursive 对子目录以递归模式处理。
-R, --relative 使用相对路径信息。
-b, --backup 创建备份，也就是对于目的已经存在有同样的文件名时，将老的文件重新命名为~filename。可以使用--suffix选项来指定不同的备份文件前缀。
--backup-dir 将备份文件(如~filename)存放在在目录下。
-suffix=SUFFIX 定义备份文件前缀。
-u, --update 仅仅进行更新，也就是跳过所有已经存在于DST，并且文件时间晚于要备份的文件，不覆盖更新的文件。
-l, --links 保留软链结。
-L, --copy-links 想对待常规文件一样处理软链结。
--copy-unsafe-links 仅仅拷贝指向SRC路径目录树以外的链结。
--safe-links 忽略指向SRC路径目录树以外的链结。
-H, --hard-links 保留硬链结。
-p, --perms 保持文件权限。
-o, --owner 保持文件属主信息。
-g, --group 保持文件属组信息。
-D, --devices 保持设备文件信息。
-t, --times 保持文件时间信息。
-S, --sparse 对稀疏文件进行特殊处理以节省DST的空间。
-n, --dry-run现实哪些文件将被传输。
-w, --whole-file 拷贝文件，不进行增量检测。
-x, --one-file-system 不要跨越文件系统边界。
-B, --block-size=SIZE 检验算法使用的块尺寸，默认是700字节。
-e, --rsh=command 指定使用rsh、ssh方式进行数据同步。
--rsync-path=PATH 指定远程服务器上的rsync命令所在路径信息。
-C, --cvs-exclude 使用和CVS一样的方法自动忽略文件，用来排除那些不希望传输的文件。
--existing 仅仅更新那些已经存在于DST的文件，而不备份那些新创建的文件。
--delete 删除那些DST中SRC没有的文件。
--delete-excluded 同样删除接收端那些被该选项指定排除的文件。
--delete-after 传输结束以后再删除。
--ignore-errors 及时出现IO错误也进行删除。
--max-delete=NUM 最多删除NUM个文件。
--partial 保留那些因故没有完全传输的文件，以是加快随后的再次传输。
--force 强制删除目录，即使不为空。
--numeric-ids 不将数字的用户和组id匹配为用户名和组名。
--timeout=time ip超时时间，单位为秒。
-I, --ignore-times 不跳过那些有同样的时间和长度的文件。
--size-only 当决定是否要备份文件时，仅仅察看文件大小而不考虑文件时间。
--modify-window=NUM 决定文件是否时间相同时使用的时间戳窗口，默认为0。
-T --temp-dir=DIR 在DIR中创建临时文件。
--compare-dest=DIR 同样比较DIR中的文件来决定是否需要备份。
-P 等同于 --partial。
--progress 显示备份过程。
-z, --compress 对备份的文件在传输时进行压缩处理。
--exclude=PATTERN 指定排除不需要传输的文件模式。
--include=PATTERN 指定不排除而需要传输的文件模式。
--exclude-from=FILE 排除FILE中指定模式的文件。
--include-from=FILE 不排除FILE指定模式匹配的文件。
--version 打印版本信息。
--address 绑定到特定的地址。
--config=FILE 指定其他的配置文件，不使用默认的rsyncd.conf文件。
--port=PORT 指定其他的rsync服务端口。
--blocking-io 对远程shell使用阻塞IO。
-stats 给出某些文件的传输状态。
--progress 在传输时显示传输过程。
--log-format=formAT 指定日志文件格式。
--password-file=FILE 从FILE中得到密码。
--bwlimit=KBPS 限制I/O带宽，KBytes per second。
-h, --help 显示帮助信息。
```

### 实例

 **SSH方式**

首先在服务端启动ssh服务：

```shell
service sshd start
启动 sshd： [确定]
```

 **使用rsync进行同步**

接下来就可以在客户端使用rsync命令来备份服务端上的数据了，SSH方式是通过系统用户来进行备份的，如下：

```shell
rsync -vzrtopg --progress -e ssh --delete work@172.16.78.192:/www/* /databack/experiment/rsync
work@172.16.78.192's password:
receiving file list ...
5 files to consider
test/
a
0 100% 0.00kB/s 527:35:41 (1, 20.0% of 5)
b
67 100% 65.43kB/s 0:00:00 (2, 40.0% of 5)
c
0 100% 0.00kB/s 527:35:41 (3, 60.0% of 5)
dd
100663296 100% 42.22MB/s 0:00:02 (4, 80.0% of 5)
sent 96 bytes received 98190 bytes 11563.06 bytes/sec
total size is 100663363 speedup is 1024.19
```

上面的信息描述了整个的备份过程，以及总共备份数据的大小。

 **后台服务方式**

启动rsync服务，编辑`/etc/xinetd.d/rsync`文件，将其中的`disable=yes`改为`disable=no`，并重启xinetd服务，如下：

```shell
vi /etc/xinetd.d/rsync

#default: off
# description: The rsync server is a good addition to an ftp server, as it \
# allows crc checksumming etc.
service rsync {
disable = no
socket_type = stream
wait = no
user = root
server = /usr/bin/rsync
server_args = --daemon
log_on_failure += USERID
}
```

```shell
/etc/init.d/xinetd restart
停止 xinetd： [确定]
启动 xinetd： [确定]
```

创建配置文件，默认安装好rsync程序后，并不会自动创建rsync的主配置文件，需要手工来创建，其主配置文件为“/etc/rsyncd.conf”，创建该文件并插入如下内容：

```shell
vi /etc/rsyncd.conf

uid=root
gid=root
max connections=4
log file=/var/log/rsyncd.log
pid file=/var/run/rsyncd.pid
lock file=/var/run/rsyncd.lock
secrets file=/etc/rsyncd.passwd
hosts deny=172.16.78.0/22

[www]
comment= backup web
path=/www
read only = no
exclude=test
auth users=work
```

创建密码文件，采用这种方式不能使用系统用户对客户端进行认证，所以需要创建一个密码文件，其格式为“username:password”，用户名可以和密码可以随便定义，最好不要和系统帐户一致，同时要把创建的密码文件权限设置为600，这在前面的模块参数做了详细介绍。

```shell
echo "work:abc123" > /etc/rsyncd.passwd
chmod 600 /etc/rsyncd.passwd
```

备份，完成以上工作，现在就可以对数据进行备份了，如下：

```shell
rsync -avz --progress --delete work@172.16.78.192::www /databack/experiment/rsync

Password:
receiving file list ...
6 files to consider
./ files...
a
0 100% 0.00kB/s 528:20:41 (1, 50.0% of 6)
b
67 100% 65.43kB/s 0:00:00 (2, 66.7% of 6)
c
0 100% 0.00kB/s 528:20:41 (3, 83.3% of 6)
dd
100663296 100% 37.49MB/s 0:00:02 (4, 100.0% of 6)
sent 172 bytes received 98276 bytes 17899.64 bytes/sec
total size is 150995011 speedup is 1533.75
```

恢复，当服务器的数据出现问题时，那么这时就需要通过客户端的数据对服务端进行恢复，但前提是服务端允许客户端有写入权限，否则也不能在客户端直接对服务端进行恢复，使用rsync对数据进行恢复的方法如下：

```shell
rsync -avz --progress /databack/experiment/rsync/ work@172.16.78.192::www

Password:
building file list ...
6 files to consider
./
a
b
67 100% 0.00kB/s 0:00:00 (2, 66.7% of 6)
c
sent 258 bytes received 76 bytes 95.43 bytes/sec
total size is 150995011 speedup is 452080.87
```

**将源目录同步到目标目录**

```shell
$ rsync -r source destination
```

上面命令中，`-r` 表示递归，即包含子目录。注意，`-r`是必须的，否则 `rsync` 运行不会成功。`source` 目录表示源目录，`destination` 表示目标目录。

**多个文件或目录同步**

```shell
$ rsync -r source1 source2 destination
```

上面命令中，`source1`、`source2` 都会被同步到 `destination` 目录。

**同步元信息**

`-a` 参数可以替代 `-r`，除了可以递归同步以外，还可以同步元信息（比如修改时间、权限等）。由于 `rsync` 默认使用文件大小和修改时间决定文件是否需要更新，所以 `-a` 比 `-r` 更有用。下面的用法才是常见的写法。

```shell
$ rsync -a source destination
```

目标目录 `destination` 如果不存在，`rsync` 会自动创建。执行上面的命令后，源目录 `source` 被完整地复制到了目标目录 `destination` 下面，即形成了 `destination/source` 的目录结构。

如果只想同步源目录 `source` 里面的内容到目标目录 `destination` ，则需要在源目录后面加上斜杠。

```shell
$ rsync -a source/ destination
```

上面命令执行后，`source` 目录里面的内容，就都被复制到了 `destination` 目录里面，并不会在 `destination` 下面创建一个 `source` 子目录。


**模拟执行的结果**

如果不确定 `rsync` 执行后会产生什么结果，可以先用 `-n` 或 `--dry-run` 参数模拟执行的结果。

```shell
$ rsync -anv source/ destination
```

上面命令中，`-n` 参数模拟命令执行的结果，并不真的执行命令。`-v` 参数则是将结果输出到终端，这样就可以看到哪些内容会被同步。

**目标目录成为源目录的镜像副本**

默认情况下，`rsync` 只确保源目录的所有内容（明确排除的文件除外）都复制到目标目录。它不会使两个目录保持相同，并且不会删除文件。如果要使得目标目录成为源目录的镜像副本，则必须使用 `--delete` 参数，这将删除只存在于目标目录、不存在于源目录的文件。

```shell
$ rsync -av --delete source/ destination
```

上面命令中，`--delete` 参数会使得 `destination` 成为 `source` 的一个镜像。


**排除文件**

有时，我们希望同步时排除某些文件或目录，这时可以用--exclude参数指定排除模式。

```shell
$ rsync -av --exclude='*.txt' source/ destination
# 或者
$ rsync -av --exclude '*.txt' source/ destination
```

上面命令排除了所有 `TXT` 文件。

注意，`rsync` 会同步以"点"开头的隐藏文件，如果要排除隐藏文件，可以这样写 `--exclude=".*"`。

如果要排除某个目录里面的所有文件，但不希望排除目录本身，可以写成下面这样。

```shell
$ rsync -av --exclude 'dir1/*' source/ destination
```

多个排除模式，可以用多个 `--exclude` 参数。

```shell
$ rsync -av --exclude 'file1.txt' --exclude 'dir1/*' source/ destination
```

多个排除模式也可以利用 Bash 的大扩号的扩展功能，只用一个 `--exclude` 参数。

```shell
$ rsync -av --exclude={'file1.txt','dir1/*'} source/ destination
```

如果排除模式很多，可以将它们写入一个文件，每个模式一行，然后用 `--exclude-from` 参数指定这个文件。

```shell
$ rsync -av --exclude-from='exclude-file.txt' source/ destination
```

**指定必须同步的文件模式**

`--include` 参数用来指定必须同步的文件模式，往往与 `--exclude` 结合使用。

```shell
$ rsync -av --include="*.txt" --exclude='*' source/ destination
```

上面命令指定同步时，排除所有文件，但是会包括 `TXT` 文件。


# 网络教程

[教程地址](https://zhuanlan.zhihu.com/p/49577967)

## 1简介
### 1.1 认识

Rsync（remote synchronize）是一个远程数据同步工具，可通过LAN/WAN快速同步多台主机间的文件。Rsync使用所谓的“Rsync算法”来使本地和远 程两个主机之间的文件达到同步，这个算法只传送两个文件的不同部分，而不是每次都整份传送，因此速度相当快；

Rsync支持大多数的类Unix系统，无论是Linux、Solaris还是BSD上都经过了良好的测试；

此外，它在windows平台下也有相应的版本，如cwRsync和Sync2NAS等工具

### 1.2 原理

Rsync本来是用于替代rcp的一个工具，目前由http://rsync.samba.org维护，所以rsync.conf文件的格式类似于samba的主配 置文件；

Rsync可以通过rsh或ssh使用，也能以daemon模式去运行

在以daemon方式运行时Rsync server会打开一个873 端口，等待客户端去连接。

连接时，Rsync server会检查口令是否相符，若通过口令查核，则可以开始进行文件传输。第一次连通完成时，会把整份文件传输一次，以后则就只需进行增量备份。

### 1.3 特点

* 可以镜像保存整个目录树和文件系统；
* 可以很容易做到保持原来文件的权限、时间、软硬链接等；
* 无须特殊权限即可安装；
* 优化的流程，文件传输效率高；
* 可以使用rsh、ssh等方式来传输文件，当然也可以通过直接的socket连接；
* 支持匿名传输


## 2 ssh模式

### 2.1 本地间同步

环境： 172.16.22.12
```
# mkdir src
# touch src/{1,2,3,4}
# mkdir dest
# rsync -av src/ dest/ --将 src 目录里的所有的文件同步至 dest 目录（不包含src本身）
# rsync -av src dest/ --将 src 目录包括自己整个同步至 dest 目录
# rsync -avR src/ dest/ --即使 src 后面接有 / ，效果同上
```
### 2.2、局域网间同步

环境： 172.16.22.11
```
# mkdir src
# touch src/{a,b,c,d}
# mkdir dest
# rsync -av 172.16.22.12:/data/test/src/ dest/ --远程同步至本地，需输入root密码
# rsync -av src/ 172.16.22.12:/data/test/dest/ --本地文件同步至远程
# rsync -av src 172.16.22.12:/data/test/dest/ --整个目录同步过去
# rm -rf src/d --删除一个文件 d
# rsync -av --delete src/ 172.16.22.12:/data/test/dest/ --delete，从目标目录里面删除无关的文件
```

### 2.3、局域网指定用户同步

—172.16.22.12
```
# useradd george
# passwd george
# mkdir /home/george/test
# touch /home/george/test/g{1,2,3,4}
```
—172.16.22.11
```
# rsync -av src '-e ssh -l george' 172.16.22.12:/home/george --本地同步至远程
# rsync -av 172.16.22.12:/home/george/test/g* '-e ssh -l george -p 22' dest/
```

## 3 daemon模式

环境：192.168.22.11


### 3.1、服务启动方式

1. 对于负荷较重的 rsync 服务器应该使用独立运行方式
```
# yum install rsync xinetd --服务安装
# /usr/bin/rsync --daemon
```
2. 对于负荷较轻的 rsync 服务器可以使用 xinetd 运行方式
```
# yum install rsync xinetd --服务安装
# vim /etc/xinetd.d/rsync --配置托管服务，将下项改为 no
disable = no
# /etc/init.d/xinetd start --启动托管服务 xinetd
# chkconfig rsync on
# netstat -ntpl | grep 873 --查看服务是否启动
```

### 3.2、配置详解

两种 rsync 服务运行方式都需要配置 rsyncd.conf，其格式类似于 samba 的主配置文件

**全局参数**

* 在全局参数部分也可以定义模块参数，这时该参数的值就是所有模块的默认值
* address —在独立运行时，用于指定的服务器运行的 IP 地址；由 xinetd 运行时将忽略此参数，使用命令行上的 –address 选项替代。默认本地所有IP
* port —指定 rsync 守护进程监听的端口号。 由 xinetd 运行时将忽略此参数，使用命令行上的 –port 选项替代。默认 873
* motd file —指定一个消息文件，当客户连接服务器时该文件的内容显示给客户
* pid file —rsync 的守护进程将其 PID 写入指定的文件
* log file —指定 rsync 守护进程的日志文件，而不将日志发送给 syslog
* syslog facility —指定 rsync 发送日志消息给 syslog 时的消息级别
* socket options —指定自定义 TCP 选项
* lockfile —指定rsync的锁文件存放路径
* timeout = 600 —超时时间


**模块参数**

模块参数主要用于定义 rsync 服务器哪个目录要被同步。模块声明的格式必须为 [module] 形式，这个名字就是在 rsync 客户端看到的名字，类似于 Samba 服务器提供的共享名。而服务器真正同步的数据是通过 path 来指定的

**基本模块参数**

* path —指定当前模块在 rsync 服务器上的同步路径，该参数是必须指定的
* comment —给模块指定一个描述，该描述连同模块名在客户连接得到模块列表时显示给客户


**模块控制参数**

* use chroot = —默认为 true，在传输文件之前首先 chroot 到 path 参数所指定的目录下；优点，安全；缺点，需要 root 权限，不能备份指向 path 外部的符号连接所指向的目录文件
* uid = —指定该模块以指定的 UID 传输文件；默认nobody
* gid = —指定该模块以指定的 GID 传输文件；默认nobody
* max connections —最大并发连接数，0为不限制
* lock file —指定支持 max connections 参数的锁文件。默认 /var/run/rsyncd.lock
* list —指定当客户请求列出可以使用的模块列表时，该模块是否应该被列出。默认为 true，显示
* read only = —只读选择，也就是说，不让客户端上传文件到服务器上。默认true
* write only = —只写选择，也就是说，不让客户端从服务器上下载文件。默认false
* ignore errors —忽略IO错误。默认true
* ignore nonreadable —指定 rysnc服务器完全忽略那些用户没有访问权限的文件。这对于在需要备份的目录中有些不应该被备份者获得的文件时是有意义的。 false
* timeout = —该选项可以覆盖客户指定的 IP 超时时间。从而确保 rsync 服务器不会永远等待一个崩溃的客户端。对于匿名 rsync 服务器来说，理想的数字是 600（单位为秒）。 0 (未限制)
* dont compress —用来指定那些在传输之前不进行压缩处理的文件。该选项可以定义一些不允许客户对该模块使用的命令选项列表。必须使用选项全名，而不能是简称。当发生拒绝某个选项的情况时，服务器将报告错误信息然后退出。例如，要防止使用压缩，应该是：”dont compress = ”。 .gz .tgz .zip .z .rpm .deb .iso .bz2 .tbz

**模块文件筛选参数**

* exclude —指定多个由空格隔开的多个文件或目录(相对路径)，并将其添加到 exclude 列表中。这等同于在客户端命令中使用 –exclude 来指定模式
* exclude from —指定一个包含 exclude 规则定义的文件名，服务器从该文件中读取 exclude 列表定义
* include —指定多个由空格隔开的多个文件或目录(相对路径)，并将其添加到 include 列表中。这等同于在客户端命令中使用 –include 来指定模式
* include from —指定一个包含 include 规则定义的文件名，服务器从该文件中读取 include 列表定义


**模块用户认证参数**

* auth users —指定由空格或逗号分隔的用户名列表，只有这些用户才允许连接该模块（和系统用户没有任何关系）。用户名和口令以明文方式存放在 secrets file 参数指定的文件中。默认为匿名方式
* secrets file —指定一个 rsync 认证口令文件。只有在 auth users 被定义时，该文件才起作用。文件权限必须是 600
* strict modes —指定是否监测口令文件的权限。为 true 则口令文件只能被 rsync 服务器运行身份的用户访问，其他任何用户不可以访问该文件。默认为true

**模块访问控制参数**

* hosts allow —用一个主机列表指定哪些主机客户允许连接该模块。不匹配主机列表的主机将被拒绝。默认值为 *
* hosts deny —用一个主机列表指定哪些主机客户不允许连接该模块

**模块日志参数**

* transfer logging —使 rsync 服务器将传输操作记录到传输日志文件。默认值为false
* log format —指定传输日志文件的字段。默认为：”%o %h [%a] %m (%u) %f %l”
* 设置了”log file”参数时，在日志每行的开始会添加”%t [%p]“；
* 可以使用的日志格式定义符如下所示：
```
%o —操作类型：”send” 或 “recv”
%h —远程主机名
%a —远程IP地址
%m —模块名
%u —证的用户名（匿名时是 null）
%f —文件名
%l —文件长度字符数
%p —该次 rsync 会话的 PID
%P —模块路径
%t —当前时间
%b —实际传输的字节数
%c —当发送文件时，记录该文件的校验码
```

### 3.3、服务端配置

* 编辑配置文件
```
# vim /etc/rsyncd.conf --为 rsyncd 服务编辑配置文件，默认没有，需自己编辑
```
* 配置文件说明
```
uid = root —rsync运行权限为root
gid = root —rsync运行权限为root
use chroot = no —是否让进程离开工作目录
max connections = 5 —最大并发连接数，0为不限制
timeout = 600 —超时时间
pid file = /var/run/rsyncd.pid —指定rsync的pid存放路径
lockfile = /var/run/rsyncd.lock —指定rsync的锁文件存放路径
log file = /var/log/rsyncd.log —指定rsync的日志存放路径
[web1] —模块名称
path = /data/test/src —该模块存放文件的基础路径
ignore errors = yes —忽略一些无关的I/O错误
read only = no —客户端可以上传
write only = no —客户端可以下载
hosts allow = 192.168.22.12 —允许连接的客户端主机ip
hosts deny = —黑名单，表示任何主机
list = yes
auth users = web —认证此模块的用户名
secrets file = /etc/web.passwd —指定存放“用户名：密码”格式的文件
```

* 构建备份目录
```
# mkdir /data/test/src --创建基础目录
# mkdir /data/test/src/george --再创建一个目录
# touch /data/test/src/{1,2,3}
# echo "web:123" > /etc/web.passwd --创建密码文件
# chmod 600 /etc/web.passwd
# service xinetd restart
```

## 4 测试

### 4.1、客户端

环境：192.168.22.12
```
# yum -y install rsync
# mkdir /data/test
```

### 4.2、小试参数

```
# rsync -avzP web@192.168.22.11::web1 /data/test/ --输入密码 123
```
将服务器 web1 模块里的文件同步至 /data/test，参数说明：

```
-a —参数，相当于-rlptgoD，
-r —是递归
-l —是链接文件，意思是拷贝链接文件
-i —列出 rsync 服务器中的文件
-p —表示保持文件原有权限
-t —保持文件原有时间
-g —保持文件原有用户组
-o —保持文件原有属主
-D —相当于块设备文件
-z —传输时压缩
-P —传输进度
-v —传输时的进度等信息，和-P有点关系
```

```
# rsync -avzP --delete web@192.168.22.11::web1 /data/test/ --让客户端与服务器保持完全一致， --delete
# rsync -avzP --delete /data/test/ web@192.168.22.11::web1 --上传客户端文件至服务端
# rsync -avzP --delete /data/test/ web@192.168.22.11::web1/george --上传客户端文件至服务端的 george 目录
# rsync -ir --password-file=/tmp/rsync.password web@192.168.22.11::web1 --递归列出服务端 web1 模块的文件
# rsync -avzP --exclude="*3*" --password-file=/tmp/rsync.password web@192.168.22.11::web1 /data/test/ --同步除了路径以及文件名中包含 “3” *的所有文件
```

### 4.3、通过密码文件同步

```
# echo "123"> /tmp/rsync.password
# chmod 600 /tmp/rsync.password
# rsync -avzP --delete --password-file=/tmp/rsync.password web@192.168.22.11::web1 /data/test/ --调用密码文件
```

### 4.4、客户端自动同步
```
# crontab -e
10 0 * rsync -avzP —delete —password-file=/tmp/rsync.password web@192.168.22.11::web1 /data/test/

# crontab -l
```


## 5 数据实时同步

环境：Rsync + Inotify-tools

### 5.1、inotify-tools

* 是为linux下 inotify文件监控工具提供的一套c的开发接口库函数，同时还提供了一系列的命令行工具，这些工具可以用来监控文件系统的事件
* inotify-tools是用c编写的，除了要求内核支持 inotify 外，不依赖于其他
* inotify-tools提供两种工具：一是inotifywait，它是用来监控文件或目录的变化，二是inotifywatch，它是用来统计文件系统访问的次数

### 5.2、安装inotify-tools

下载地址：http://github.com/downloads/rvoicilas/inotify-tools/inotify-tools-3.14.tar.gz

```
# yum install –y gcc --安装依赖
# mkdir /usr/local/inotify
# tar -xf inotify-tools-3.14.tar.gz
# cd inotify-tools-3.14
# ./configure --prefix=/usr/local/inotify/
# make && make install
```

### 3、设置环境变量

```
# vim /root/.bash_profile
export PATH=/usr/local/inotify/bin/:$PATH

# source /root/.bash_profile
# echo '/usr/local/inotify/lib' >> /etc/ld.so.conf --加载库文件
# ldconfig
# ln -s /usr/local/inotify/include /usr/include/inotify
```

### 5.4、常用参数
```
-m —始终保持监听状态，默认触发事件即退出
-r —递归查询目录
-q —打印出监控事件
-e —定义监控的事件，可用参数：
access —访问文件
modify —修改文件
attrib —属性变更
open —打开文件
delete —删除文件
create —新建文件
move —文件移动
—fromfile —从文件读取需要监视的文件或者排除的文件，一个文件一行，排除的文件以@开头
—timefmt —时间格式
—format —输出格式
—exclude —正则匹配需要排除的文件，大小写敏感
—excludei —正则匹配需要排除的文件，忽略大小写
%y%m%d %H%M —年月日时钟
%T%w%f%e —时间路径文件名状态
```

### 5.5、测试一

检测源目录中是否有如下动作：modify,create,move,delete,attrib；

一旦发生则发布至目标机器；

方式为 ssh
```
src: 192.168.22.11(Rsync + Inotify-tools) dest: 192.168.22.12
```

两台机器需要做好 ssh 免密登录
```
# mdkir /data/test/dest/ --dest机器

# mdkir /data/test/src/ --src机器

# rsync -av --delete /data/test/src/ 192.168.22.12:/data/test/dest --测试下命令

# vim /data/test/test.sh

#!/bin/bash

/usr/local/inotify/bin/inotifywait -mrq -e modify,create,move,delete,attrib /data/test/src | while read events

do

rsync -a --delete /data/test/src/ 192.168.22.12:/data/test/dest

echo "`date +'%F %T'` 出现事件：$events" >> /tmp/rsync.log 2>&1

done

# chmod 755 /data/test/test.sh

# /data/test/test.sh &

# echo '/data/test/test.sh &' >> /etc/rc.local --设置开机自启
```


我们可以在目标机上也写一个这样的脚本： rsync -a —delete /data/test/dest/ 192.168.22.11:/data/test/src ；
这样可以实现双向同步。