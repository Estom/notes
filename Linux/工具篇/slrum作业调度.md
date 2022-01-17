> 参考文献
> https://www.hpccube.com/doc/1.0.6/30000/general-handbook/scheduler/intro.html


## 介绍

不要在登录节点上不通过作业调度管理系统直接运行作业（编译等日常 操作除外），以免影响其余用户的正常使用。

不通过作业调度管理系统直接在计算节点上运行将会被杀掉。


## 分区信息查询-sinfo
用户在使用时，首先需要了解哪些分区可以使用。在计算服务中，使用sinfo命令查询队列信息。根据命令输出，可以看到当前节点所在集群的作业调度系统的队列情况，并可看到每个分区可访问的空闲节点数量、节点名称。

命令的默认输出中，PARTITION表示分区、NODES表示节点数、STATE表示节点运行状态、NODELIST表示节点列表。其中状态一列中idle表示节点处于空闲状态，可接收新的作业；allocated表示节点已经分配了一个或者多个作业且所有核心用满，在作业释放前不能再被分配作业；mix状态为使用部分核心，仍可以被分配作业；drain状态表示对应节点已经下线；drng表示已下线但仍有作业在运行。需要关注的是PARTITION和STATE两列。PARTITION指示任务可提交到的分区（即队列）。下表列出关于sinfo命令常用选项，更多选项可通过man sinfo命令查看sinfo手册。

| sinfo                                              | 信息              |
|----------------------------------------------------|-----------------|
| -a, --all                                          | 查看所有分区信息        |
| -d, --dead                                         | 查看处于dead状态的详细信息 |
| -l, --long                                         | 查看分区详细信息        |
| -N, --Node                                         | 查看节点信息          |
| -p <patition>, --partition=<partition> | 查看指定分区信息        |
| -t <states>, --state=<state>           | 查看指定状态的节点       |

## 2 提交交互式作业
交互式提交作业：在计算服务E-Shell窗口中执行srun命令，主要命令格式如下：
```
srun [options] program
```
### srun常用选项
srun包括多个选项，其中最常用的选项主要有以下几个：

```
-n 或 --ntasks=number
```
指定要运行的任务数，默认每个任务一个处理器核。
```
-c 或 --cpus-per-task=ncpus
```
作业步的每个任务需要 ncpus 个处理器核。若未指定该选项，则默认为每个任务分配一个处理器核。
```
-N 或 --nodes=nnodes
```
请求为作业分配nnodes个节点。如果作业的请求节点个数超出了分区中配置的节点数目，作业将被拒绝。
```
-p 或 --partition=partitionname
```
在指定分区中分配资源。如未指定，则在系统默认分区中分配资源。
```
-w 或 --nodelist=nodenamelist
```
请求指定的节点名称列表。列表可以用逗号分隔的节点名或节点范围（如 h02r1n[00-19]）指定。
```
--exclusive
```
作业独占节点，作业运行过程中不允许其他作业使用节点，即使节点核心未用满。
```
-h, --help
```
若需使用 srun 更多选项，可通过“srun -h” 或“srun --help” 查看。

使用示例
在分区 normal 上指定任务数运行 hostname，如下图所示：
```
srun -p normal -n 2 hostname
```

在分区 normal 上指定节点运行 hostname，如下图所示：

```
srun -p normal -N 2 -n 2 -2 abc,def hostname
```

在分区 normal 上指定节点数2，任务数6，独占运行 hostname，如下图所示：
```
srun -p normal -N 2 -n 6 --exclusive hostname
```


## 3 提交批处理作业-sbatch
### 简介
用户使用sbatch命令提交作业脚本，其基本格式为sbatch jobfile。jobfile为作业脚本文件。在批处理作业脚本中，脚本第一行以"#!"字符开头，并指定脚本文件的解释程序，如 sh，bash。接下来写作业使用到的调度系统参数，以#开头，最后写作业运行的程序命令。

用户可使用sbatch命令提交用户作业脚本。示例如下：
```
sbatch < xxx.sbatch
```

作业提交脚本格式编写如下，作业控制指令以"#SBATCH"开头，其他注释以"#"开头。例如wrf测试脚本run.sbatch如下：
```
#!/bin/bash
#SBATCH -J wrf
#SBATCH --comment=WRF
#SBATCH -n 128
#SBATCH --ntasks-per-node=32
#SBATCH -p normal
#SBATCH -o %j
#SBATCH -e %j

mpirun -np 128./wrf.exe
```

### sbatch常用选项。

作业控制参数如下：


| 选项                                       | 含义                            | 类型  | 示例                                    |
|------------------------------------------|-------------------------------|-----|---------------------------------------|
| -J                                       | 作业名称，使用squeue看到的作业名           | 字符串 | -J wrf；表示作业名称为"wrf"                   |
| -n                                       | 作业申请的总cpu核心数                  | 数值  | -n 240；表示作业申请240个cpu核心                |
| -N                                       | 作业申请的节点数                      | 数值  | -N 10 表示作业申请10个计算节点                   |
| -p                                       | 指定作业提交的队列                     | 字符串 | -p silicon表示将作业提交到silicon队列           |
| --ntasks-per-node                        | 指定每个节点运行进程数                   | 数值  | --ntasks-per-node=32表示每个节点运行32个进程（任务） |
| --cpus-per-task=<count>            | 指定任务需要的处理器数目                  | 数值  | --cpus-per-task=1 表示每个任务占用1个处理器核      |
| -t                                       | 指定作业的执行时间，若超过该时间，作业将会被杀死      | 数值  | -t 30 表示作业的执行时间不超过30分钟                |
| -o                                       | 指定作业标准输出文件的名称，不能使用shell环境变量   | 字符串 | -o %j，表示使用作业号作为作业标准输出文件的名称，%J表示作业号    |
| -e                                       | 指定作业标准错误输出文件的名称，不能使用shell环境变量 | 字符串 | -e %j，表示使用作业号作为作业标准错误输出文件的名称          |
| -w, --nodelist=hosts...                  | 指定分配特定的计算节点                   | 字符串 | -w t0100,t0101 表示使用t0100 t0101等2个节点   |
| -x, --exclude=hosts...                   | 指定不分配特定的阶段节点                  | 字符串 | -x t0100,t0101 表示不使用t0100 t0101等2个节点  |
| --exclusive                              | 指定作业独占计算节点                    | 字符串 | sbatch –exclusivetest.job             |
| --mem=<size[units]>                | 指定作业在每个节点使用的内存限制。             | 数字  | --mem=2G 限定作业在每个节点最多占用2G的最大内存。        |
| --mem-per-cpu=<size[units]>        | 限定每个进程占用的内存数。                 | 数字  | --mem-per-cpu=512M 限定作业每个进程占用的最大内存。   |
| -d, --dependency=<dependency_list> | 作业依赖关系设置                      | 字符串 | -d after:123 表示本作业须待作业123开始以后再执行      |
| --gres=<list>                      | 指定每个节点使用通用资源名称及数量             | 字符串 | --gres=加速卡:2 表示本作业使用加速卡，且每个节点使用2卡     |



参数补充说明

* 实际在每个节点上分配的 CPU 数量由 --ntasks-per-node 和 --cpus-per-task 参数共同决定。默认情况下二者都是 1。一般来讲，多进程的程序需要更改 --ntasks-per-node，多线程的程序需要更改 --cpus-per-task。各位用户请根据 自己需求进行设置。
* 任务最长时间的设置格式是 DD-HH:MM:SS，例如一天又 15 小时写作 1-15:00:00。 如果高位为 0 可省略。如果不写任务最长时间，则任务的最长时间默认为对应分区 (Partition) 的默认时间。
### 使用实例gpu

```
#!/bin/bash
#SBATCH -J test                   # 作业名为 test
#SBATCH -o test.out               # 屏幕上的输出文件重定向到 test.out
#SBATCH -p gpu                    # 作业提交的分区为 cpu
#SBATCH --qos=debug               # 作业使用的 QoS 为 debug
#SBATCH -N 1                      # 作业申请 1 个节点
#SBATCH --ntasks-per-node=1       # 单节点启动的进程数为 1
#SBATCH --cpus-per-task=4         # 单任务使用的 CPU 核心数为 4
#SBATCH -t 1:00:00                # 任务运行的最长时间为 1 小时
#SBATCH --gres=gpu:1              # 单个节点使用 1 块 GPU 卡，默认不会分配gpu
#SBATCh -w comput6                # 指定运行作业的节点是 comput6，若不填写系统自动分配节点

# 设置运行环境
module add anaconda/3-5.0.0.1     # 添加 anaconda/3-5.0.0.1 模块

# 输入要执行的命令，例如 ./hello 或 python test.py 等
python test.py                    # 执行命令
```
### 使用示例-串行作业示例
```
#!/bin/bash
#SBATCH –J TestSerial
#SBATCH -p normal
#SBATCH -N 1
#SBATCH –n 1
#SBATCH -o log/%j.loop
#SBATCH -e log/%j.loop
echo "SLURM_JOB_PARTITION=$SLURM_JOB_PARTITION"
echo "SLURM_JOB_NODELIST=$SLURM_JOB_NODELIST"
srun  ./calc_serial 1000000
```

### 使用实例-mpi作业示例
OpenMPI支持多种方式与作业调度集成，其中最推荐的方式是使用srun直接启动任务。

在作业脚本中使用srun；
```sh
#!/bin/bash
#SBATCH -o %j
#SBATCH -J MPI
#SBATCH -t 00:10:00
#SBATCH -p hpc
#SBATCH --mem-per-cpu=3G
#SBATCH --tasks-per-node=32
#SBATCH -N 2

module load compiler/devtoolset/7.3.1
module load compiler/rocm/2.9
module load mpi/hpcx/2.4.1/gcc-7.3.1

#  4x32, about   60 sec
 export LOOPMAX=1000000

CORELOOP=$(expr $LOOPMAX / 128)
echo "CORELOOP=$CORELOOP"
export LOOPMAX=$(expr $SLURM_NTASKS \* $CORELOOP )
echo "LOOPMAX=$LOOPMAX"

export MPITYPE=pmix_v3
echo "use srun, loop=$LOOPMAX" && time srun --mpi=$MPITYPE ./open_fire_v5 $LOOPMAX
```

### 作业环境变量

提交作业后，作业管理软件会产生一些环境变量，可以在作业脚本中使用。列举如下

| 名称                     | 含义                                | 类型  | 示例                                                                       |
|------------------------|-----------------------------------|-----|--------------------------------------------------------------------------|
| SLURM\_JOB\_ID         | 作业id，即作业调度系统为作业分配的作业号，可用于bjobs等命令 | 数值  | hostfile=" ma\.$SLURM\_JOB\_ID" 使用$SLURM\_JOB\_ID定义machinefile，指定mpi节点文件 |
| SLURM\_JOB\_NAME       | 作业名称，即\-J 选项指定的名称                 | 字符串 | mkdir $\{SLURM\_JOB\_NAME\} 根据作业名称创建临时工作目录                               |
| SLURM\_JOB\_NUM\_NODES | 作业分配到的节点总数                        | 数值  | echo $SLURM\_JOB\_NUM\_NODES                                             |
| SLURM\_JOB\_NODELIST   | 作业被分配到的节点列表                       | 字符串 | echo $SLURM\_JOB\_NODELIST                                               |
| SLURM\_JOB\_PARTITION  | 作业被分配到的队列名                        | 字符串 | echo $SLURM\_JOB\_NODELIST                                               |


## 4 提交节点资源获取作业-salloc
### 简介
该命令支持用户在提交作业前，先获取所需计算资源。

### 使用示例
首先申请资源，如图所示：
```
salloc -n=4
```


ssh到计算节点执行命令：
```
ssh abced
```


执行exit退出，作业资源释放：

```
exit
```

## 5 作业信息查询-squeue
用户使用squeue命令可以查看作业信息，例如hc用户执行命令，输出如下：
```
JOBID PARTITION NAME USER ST TIME NODES NODELIST(REASON)

64509 debug DL_test hc R 3:58:40 300
b01r1n[00-08],b01r4n[06-08],b03r1n[00-08,10-18],b06r2n[10-18],b06r3n[00-08,10-18],b07r1n[00-08,10-18],b07r2n[00-08,10-18],b07r3n[00-08,10-18],b08r1n[00-08,10-18],b08r2n[00-08,10-18],b08r4n[00-08,10-18],b09r1n[00-08,10-18],b09r2n[00-08,10-18],b09r3n[00-08,10-18],b09r4n[00-08,10-18],b10r4n[00-08,10-18],b11r1n[00-08,10-18],g05r4n[15-19],g06r1n[00-06],g09r1n[15-19],g09r2n[00-09]
```

其中JOBID表示任务ID编号，PARTITION表示作业所在队列（分区），NAME表示任务名称，USER为用户，ST为作业状态，TIME为已运行时间，NODES表示占用节点数，NODELIST(REASON)为任务运行的节点列表或者原因说明。另外，状态列中R-Runing（正在运行），PD-PenDing（资源不足，排队中），CG-COMPLETING(作业正在完成中)，CA-CANCELLED（作业被人为取消），CD-COMPLETED（作业运行完成），F-FAILED 作业运行失败，NF-NODE_FAIL节点问题导致作业运行失败，PR 作业被抢占，S 作业被挂起，TO 作业超时被杀。

| squeue                         |信息|
|--------------------------------|---|
| \-\-jobs <job\_id\_list> | 查看指定JOB IDS的作业信息 |
| \-\-name=<name>          | 查看指定名称的作业信息      |
| \-\-partition=<names>    | 查看指定分区的作业信息      |
| \-\-priority                   | 按照优先级查看作业信息      |
| \-\-state=<names>        | 指定状态查看作业信息       |
| \-\-users=<names>        | 指定用户名称查看作业信息     |



## 6 节点/作业详细信息查询-scontrol
查看、修改SLURM配置和状态，此处仅介绍常用的查看命令。

查看节点信息
```sh
scontrol show node[=node_name]
```
查看节点的详细信息，如果不指定ndoe_name默认会显示所有节点信息，如果指定node_name，则仅显示指定节点的信息。
```sh
$ scontrol show node b13r2n18
NodeName=b13r2n18 Arch=x86_64 CoresPerSocket=8 
CPUAlloc=32 CPUTot=32 CPULoad=0.10
AvailableFeatures=(null)
ActiveFeatures=(null)
Gres=加速卡:国产处理器:4
NodeAddr=b13r2n18 NodeHostName=b13r2n18 Version=18.08
OS=Linux 3.10.0-693.el7.x86_64 #1 SMP Mon Apr 8 19:28:59 CST 2019 
RealMemory=126530 AllocMem=61856 FreeMem=116609 Sockets=4 Boards=1
MemSpecLimit=10240
State=ALLOCATED ThreadsPerCore=1 TmpDisk=0 Weight=1 Owner=N/A MCS_label=N/A
Partitions=debug 
BootTime=2019-07-14T13:42:57 SlurmdStartTime=2019-07-14T13:43:22
CfgTRES=cpu=32,mem=126530M,billing=32,gres/加速卡=4
AllocTRES=cpu=32,mem=61856M,gres/加速卡=4
CapWatts=n/a
CurrentWatts=0 LowestJoules=0 ConsumedJoules=0
ExtSensorsJoules=n/s ExtSensorsWatts=0 ExtSensorsTemp=n/s
```
### 查看作业信息
```
scontrol show job [jod_id]
```
查看作业的详细信息，如果指定job_id，则仅显示指定作业的信息。
```
$ scontrol show job 64509
JobId=64509 JobName=DL_test
UserId=hc(1060) GroupId=nobody(1060) MCS_label=N/A
Priority=1000 Nice=0 Account=sugon QOS=normal
JobState=RUNNING Reason=None Dependency=(null)
Requeue=1 Restarts=0 BatchFlag=1 Reboot=0 ExitCode=0:0
RunTime=04:01:35 TimeLimit=1-00:00:00 TimeMin=N/A
SubmitTime=2019-07-16T13:44:19 EligibleTime=2019-07-16T13:44:19
AccrueTime=2019-07-16T13:44:19
StartTime=2019-07-16T13:44:20 EndTime=2019-07-17T13:44:20 Deadline=N/A
PreemptTime=None SuspendTime=None SecsPreSuspend=0
LastSchedEval=2019-07-16T13:44:20
Partition=debug AllocNode:Sid=j00admin2:44146
ReqNodeList=(null) ExcNodeList=(null)
NodeList=b01r1n[00-08],b01r4n[06-08],b03r1n[00-08,10-18],b06r2n[10-18],b06r3n[00-08,10-18],b07r1n[00-08,10-18],b07r2n[00-08,10-18]b07r3n[00-08,10-18],b08r1n[00-08,10-18],b08r2n[00-08,10-18],b08r4n[00-08,10-18],b09r1n[00-08,10-18],b09r2n[00-08,10-18],b09r3n[00-0810-18],b09r4n[00-08,10-18],b10r4n[00-08,10-18],b11r1n[00-08,10-18],g05r4n[15-19],g06r1n[00-06],g09r1n[15-19],g09r2n[00-09]
BatchHost=b01r1n00
NumNodes=300 NumCPUs=9600 NumTasks=9600 CPUs/Task=1 ReqB:S:C:T=0:0:*:*
TRES=cpu=9600,mem=18556800M,node=300,billing=9600,gres/加速卡=1200
Socks/Node=* NtasksPerN:B:S:C=0:0:*:* CoreSpec=*
MinCPUsNode=1 MinMemoryCPU=1933M MinTmpDiskNode=0
Features=(null) DelayBoot=00:00:00
OverSubscribe=OK Contiguous=0 Licenses=(null) Network=(null)
Command=/public/home/hc/slurm/sleep.slurm
WorkDir=/public/home/hc/slurm
StdErr=/public/home/hc/slurm/slurm-64509.out
StdIn=/dev/null
StdOut=/public/home/hc/slurm/slurm-64509.out
Power=
TresPerNode=加速卡:4
```


## 7 作业删除-scancel
作业删除命令：scancel <作业号> 。
```
[haowj@h01r1n00 ~]$ squeue
JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
65639    normal executab    haowj  R       0:02      2 h07r1n[14-15]
[haowj@h01r1n00 ~]$ scancel 65639
[haowj@h01r1n00 ~]$ squeue
JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
[haowj@h01r1n00 ~]$
```
普通用户只能查看、删除自己提交的作业；

| squeue                         |信息|
|--------------------------------|---|
| \-\-jobs <job\_id\_list> | 查看指定JOB IDS的作业信息 |
| \-\-name=<name>          | 查看指定名称的作业信息      |
| \-\-partition=<names>    | 查看指定分区的作业信息      |
| \-\-priority                   | 按照优先级查看作业信息      |
| \-\-state=<names>        | 指定状态查看作业信息       |
| \-\-users=<names>        | 指定用户名称查看作业信息     |


## sacct 的使用

sacct能够查看当前用户下的作业的简要信息

sacct -e显示所有可以的选项


根据sacct -e的选项进行格式化
sacct --format="CPUTime,MaxRSS"
