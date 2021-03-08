http://www.360doc.com/content/17/0220/19/39202731_630623149.shtml


## TF系统依赖
TF托管在github平台，有google groups和contributors共同维护。



TF提供了丰富的深度学习相关的API，支持Python和C/C++接口。



TF提供了可视化分析工具Tensorboard，方便分析和调整模型。



TF支持Linux平台，Windows平台，Mac平台，甚至手机移动设备等各种平台


## TF的系统架构

第一层设备通信层负责网络通信和设备管理。设备管理可以实现TF设备异构的特性，支持CPU、GPU、Mobile等不同设备。网络通信依赖gRPC通信协议实现不同设备间的数据传输和更新。



第二层是Tensor的OpKernels实现。这些OpKernels以Tensor为处理对象，依赖网络通信和设备内存分配，实现了各种Tensor操作或计算。Opkernels不仅包含MatMul等计算操作，还包含Queue等非计算操作，这些将在第5章Kernels模块详细介绍。



第三层是图计算层（Graph），包含本地计算流图和分布式计算流图的实现。Graph模块包含Graph的创建、编译、优化和执行等部分，Graph中每个节点都是OpKernels类型表示。关于图计算将在第6章Graph模块详细介绍。



第四层是API接口层。Tensor C API是对TF功能模块的接口封装，便于其他语言平台调用。



第四层以上是应用层。不同编程语言在应用层通过API接口层调用TF核心功能实现相关实验和应用。

## TensorFlow代码的核心模块

> Tensorflow/core目录


```
    public: API接口头文件目录，用于外部接口调用的API定义，主要是session.h 和tensor_c_api.h。

    client: API接口实现文件目录。

    platform: OS系统相关接口文件，如file system, env等。

    protobuf: 均为.proto文件，用于数据传输时的结构序列化.
    
    common_runtime: 公共运行库，包含session, executor, threadpool, rendezvous, memory管理, 设备分配算法等。

    distributed_runtime: 分布式执行模块，如rpc session, rpc master, rpc worker, graph manager。

    framework: 包含基础功能模块，如log, memory, tensor

    graph: 计算流图相关操作，如construct, partition, optimize, execute等

    kernels: 核心Op，如matmul, conv2d, argmax, batch_norm等

    lib: 公共基础库，如gif、gtl(google模板库)、hash、histogram等。

    ops: 基本ops运算，ops梯度运算，io相关的ops，控制流和数据流操作


```

> TensorFlow/* 其他目录

    Tensorflow/stream_executor目录是并行计算框架，由google stream executor团队开发。
    
    Tensorflow/contrib目录是contributor开发目录。
    
    Tensroflow/python目录是python API客户端脚本。
    
    Tensorflow/tensorboard目录是可视化分析工具，不仅可以模型可视化，还可以监控模型参数变化。

> third_party/*第三方库

    eigen3: eigen矩阵运算库，TF基础ops调用
    
    gpus: 封装了cuda/cudnn编程库


## TF核心概念

TF的核心是围绕Graph展开的，简而言之，就是Tensor沿着Graph传递闭包完成Flow的过程。所以在介绍Graph之前需要讲述一下符号编程、计算流图、梯度计算、控制流的概念

##### tensor

Tensor在高维空间数学运算比Matrix计算复杂，计算量也非常大，加速张量并行运算是TF优先考虑的问题，如add, contract, slice, reshape, reduce, shuffle等运算。



TF中Tensor的维数描述为阶，数值是0阶，向量是1阶，矩阵是2阶，以此类推，可以表示n阶高维数据。



TF中Tensor支持的数据类型有很多，如tf.float16, tf.float32, tf.float64, tf.uint8, tf.int8, tf.int16, tf.int32, tf.int64, tf.string, tf.bool, tf.complex64等，所有Tensor运算都使用泛化的数据类型表示。



TF的Tensor定义和运算主要是调用Eigen矩阵计算库完成的。TF中Tensor的UML定义如图 2 2。其中TensorBuffer指针指向Eigen::Tensor类型。其中，Eigen::Tensor[5][6]不属于Eigen官方维护的程序，由贡献者提供文档和维护，所以Tensor定义在Eigen unsupported模块中。

##### 符号编程


编程模式通常分为命令式编程（imperative style programs）和符号式编程（symbolic style programs）。



命令式编程容易理解和调试，命令语句基本没有优化，按原有逻辑执行。符号式编程涉及较多的嵌入和优化，不容易理解和调试，但运行速度有同比提升。



这两种编程模式在实际中都有应用，Torch是典型的命令式风格，caffe、theano、mxnet和Tensorflow都使用了符号式编程。其中caffe、mxnet采用了两种编程模式混合的方法，而Tensorflow是完全采用了符号式编程，Theano和Tensorflow的编程模式更相近。



命令式编程是常见的编程模式，编程语言如python/C++都采用命令式编程。命令式编程明确输入变量，并根据程序逻辑逐步运算，这种模式非常在调试程序时进行单步跟踪，分析中间变量。


##### 梯度计算

梯度计算主要应用在误差反向传播和数据更新，是深度学习平台要解决的核心问题。梯度计算涉及每个计算节点，每个自定义的前向计算图都包含一个隐式的反向计算图。从数据流向上看，正向计算图是数据从输入节点到输出节点的流向过程，反向计算图是数据从输出节点到输入节点的流向过程。

反向计算限制了符号编程中内存空间复用的优势，因为在正向计算中的计算数据在反向计算中也可能要用到。从这一点上讲，粗粒度的计算节点比细粒度的计算节点更有优势，而TF大部分为细粒度操作，虽然灵活性很强，但细粒度操作涉及到更多的优化方案，在工程实现上开销较大，不及粗粒度简单直接。在神经网络模型中，TF将逐步侧重粗粒度运算

##### 控制流

TF的计算图如同数据流一样，数据流向表示计算过程，如图 2 6。数据流图可以很好的表达计算过程，为了扩展TF的表达能力，TF中引入控制流。

在编程语言中，if…else…是最常见的逻辑控制，在TF的数据流中也可以通过这种方式控制数据流向。接口函数如下，pred为判别表达式，fn1和fn2为运算表达式。当pred为true是，执行fn1操作；当pred为false时，执行fn2操作。


TF还可以协调多个数据流，在存在依赖节点的场景下非常有用，例如节点B要读取模型参数θ更新后的值，而节点A负责更新参数θ，则节点B必须等节点A完成后才能执行，否则读取的参数θ为更新前的数值，这时需要一个运算控制器。接口函数如下，tf.control_dependencies函数可以控制多个数据流执行完成后才能执行接下来的操作，通常与tf.group函数结合使用。


TF支持的控制算子有Switch、Merge、Enter、Leave和NextIteration等。



TF不仅支持逻辑控制，还支持循环控制。TF使用和MIT Token-Tagged machine相似的表示系统，将循环的每次迭代标记为一个tag，迭代的执行状态标记为一个frame，但迭代所需的数据准备好的时候，就可以开始计算，从而多个迭代可以同时执行。


## TF开发工具介绍

> TF系统开发使用了bazel工具实现工程代码自动化管理，使用了protobuf实现了跨设备数据传输，使用了swig库实现python接口封装。本章将从这三方面介绍TF开发工具的使用。

##### Swig封装



Tensorflow核心框架使用C++编写，API接口文件定义在tensorflow/core/public目录下，主要文件是tensor_c_api.h文件，C++语言直接调用这些头文件即可。



Python通过Swig工具封装TF库包间接调用，接口定义文件tensorflow/python/ tensorflow.i。其中swig全称为Simplified Wrapper and Interface Generator，是封装C/C++并与其它各种高级编程语言进行嵌入联接的开发工具，对swig感兴趣的请参考相关文档。



在tensorflow.i文件中包含了若干个.i文件，每个文件是对应模块的封装，其中tf_session.i文件中包含了tensor_c_api.h，实现client向session发送请求创建和运行graph的功能。



##### Bazel编译和调试



Bazel是Google开源的自动化构建工具，类似于Make和CMake工具。Bazel的目标是构建“快速并可靠的代码”，并且能“随着公司的成长持续调整其软件开发实践”。



TF中几乎所有代码编译生成都是依赖Bazel完成的，了解Bazel有助于进一步学习TF代码，尤其是编译测试用例进行gdb调试。



Bazel假定每个目录为[package]单元，目录里面包含了源文件和一个描述文件BUILD，描述文件中指定了如何将源文件转换成构建的输出。



以图 3 13为例，左子图为工程中不同模块间的依赖关系，右子图是对应模块依赖关系的BUILD描述文件。



图 3 13中name属性来命名规则，srcs属性为模块相关源文件列表，deps属性来描述规则之间的依赖关系。”//search: google_search_page”中”search”是包名，”google_search_page”为规则名，其中冒号用来分隔包名和规则名；如果某条规则所依赖的规则在其他目录下，就用'//'开头，如果在同一目录下，可以忽略包名而用冒号开头。



图 3 13中cc_binary表示编译目标是生成可执行文件，cc_library表示编译目标是生成库文件。如果要生成google_search_page规则可运行



TF中首次运行bazel时会自动下载很多依赖包，如果有的包下载失败，打开tensorflow/workspace.bzl查看是哪个包下载失败，更改对应依赖包的new_http_archive中的url地址，也可以把new_http_archive设置为本地目录new_local_repository。



TF中测试用例跟相应代码文件放在一起，如MatMul操作的core/kernels/matmul_op.cc文件对应的测试用例文件为core/kernels/matmul_op_test.cc文件。运行这个测试用例需要查找这个测试用例对应的BUILD文件和对应的命令规则，如matmul_op_test.cc文件对应的BUILD文件为core/kernels/BUILD文件，如下


其中tf_cuda_cc_test函数是TF中自定义的编译函数，函数定义在/tensorflow/ tensorflow.bzl文件中，它会把matmul_op_test.cc放进编译文件中。要生成matmul_op_test可执行文件可运行如下脚本：




##### Protobuf序列化



Protocol Buffers 是一种轻便高效的结构化数据存储格式，可以用于结构化数据串行化，或者说序列化。它很适合做数据存储或 RPC 数据交换格式。可用于通讯协议、数据存储等领域的语言无关、平台无关、可扩展的序列化结构数据格式。



Protobuf对象描述文件为.proto类型，编译后生成.pb.h和.pb.cc文件。



Protobuf主要包含读写两个函数：Writer（序列化）函数SerializeToOstream() 和  Reader（反序列化）函数 ParseFromIstream()。



Tensorflow在core/probobuf目录中定义了若干与分布式环境相关的.proto文件，同时在core/framework目录下定义了与基本数据类型和结构的.proto文件，在core/util目录中也定义部分.proto文件，感觉太随意了。


在分布式环境中，不仅需要传输数据序列化，还需要数据传输协议。Protobuf在序列化处理后，由gRPC完成数据传输。gRPC数据传输架构图见图 3 14。



gRPC服务包含客户端和服务端。gRPC客户端调用stub 对象将请求用 protobuf 方式序列化成字节流，用于线上传输，到 server 端后调用真正的实现对象处理。gRPC的服务端通过observer观察处理返回和关闭通道。



TF使用gRPC完成不同设备间的数据传输，比如超参数、梯度值、graph结构。

## Eigen介绍



在Tensoflow中核心数据结构和运算主要依赖于Eigen和Stream Executor库，其中Eigen支持CPU和GPU加速计算，Stream Executor主要用于GPU环境加速计算。下面简单讲述Eigen库的相关特性，有助于进一步理解Tensorflow。



3.2.1 Eigen简述



Eigen是高效易用的C++开源库，有效支持线性代数，矩阵和矢量运算，数值分析及其相关的算法。不依赖于任何其他依赖包，安装使用都很简便[8]。具有如下特性：



  支持整数、浮点数、复数，使用模板编程，可以为特殊的数据结构提供矩阵操作。比如在用ceres-solver进行做优化问题（比如bundle adjustment）的时候，有时候需要用模板编程写一个目标函数，ceres可以将模板自动替换为内部的一个可以自动求微分的特殊的double类型。而如果要在这个模板函数中进行矩阵计算，使用Eigen就会非常方便。



  支持逐元素、分块、和整体的矩阵操作。



  内含大量矩阵分解算法包括LU，LDLt，QR、SVD等等。



  支持使用Intel MKL加速



  部分功能支持多线程



  稀疏矩阵支持良好，到今年新出的Eigen3.2，已经自带了SparseLU、SparseQR、共轭梯度（ConjugateGradient solver）、bi conjugate gradient stabilized solver等解稀疏矩阵的功能。同时提供SPQR、UmfPack等外部稀疏矩阵库的接口。



  支持常用几何运算，包括旋转矩阵、四元数、矩阵变换、AngleAxis（欧拉角与Rodrigues变换）等等。



  更新活跃，用户众多（Google、WilliowGarage也在用），使用Eigen的比较著名的开源项目有ROS（机器人操作系统）、PCL（点云处理库）、Google Ceres（优化算法）。OpenCV自带到Eigen的接口。



Eigen库包含 Eigen模块和unsupported模块，其中Eigen模块为official module，unsupported模块为开源贡献者开发的。



Eigen unsupported 模块中定义了数据类型Tensor及相关函数，包括Tensor的存储格式，Tensor的符号表示，Tensor的编译加速，Tensor的一元运算、二元运算、高维度泛化矩阵运算，Tensor的表达式计算。本章后续所述Tensor均为Eigen::Tensor



Eigen运算性能评估如图 3 6所示[9]，eigen3的整体性能比eigen2有很大提升，与GOTO2、INTEL_MKL基本持平。


图 3 6矩阵运算常用库比较



3.2.2 Eigen 存储顺序



Eigen中的Tensor支持两种存储方式:



  Row-major表示矩阵存储时按照row-by-row的方式。



  Col-major表示矩阵存储时按照column-by-column的方式。



Eigen默认采用Col-major格式存储的（虽然也支持Row-major，但不推荐），具体采用什么存储方式取决于算法本身是行遍历还是列遍历为主。例如：A=[[a11, a12, a13], [a21, a22, a23]]的存储序列见图 3 7。


图 3 7 Row-major和Column-major存储顺序



3.2.3 Eigen 惰性求值



在编程语言理论中，存在及早求值(Eager Evaluation) 和惰性求值（Lazy Evaluation）



  及早求值：大多数编程语言所拥有的普通计算方式



  惰性求值：也认为是“延迟求值”，可以提高计算性能，最重要的好处是它可以构造一个无限的数据类型。



关于惰性求值，举例如下：



Vec3 = vec1 + vec2;



及早求值形式需要临时变量vec_temp存储运算结果，再赋值给vec3，计算效率和空间效率都不高：



Vec_temp = vec1 + vec2;

Vec3 = vec_temp



而惰性求值不需要临时变量保存中间结果，提高了计算性能：



Vec_symbol_3 = (vec_symbol_1 + vec_symbol_2);

Vec3 = vec_symbol_3.eval(vec1, vec2)



由于Eigen默认采用惰性计算，如果要求表达式的值可以使用Tensor::eval()函数。Tensor::eval()函数也是session.run()的底层运算。例如：



Tensor result = ((t1 + t2).eval() * 0.2f).exp();



3.2.4 Eigen 编译加速



编译加速可以充分发挥计算机的并行计算能力，提高程序运行速度。



举例如下：



普通的循环相加运算时间复杂度是O(n)：


如果指令集支持128bit并行计算，则时间复杂度可缩短为O(n/4)：


Eigen编译时使用了SSE2加速。假设处理float32类型，指令集支持128bit并行计算，则一次可以计算4个float32类型，速度提升4倍。



3.2.5 Eigen::half



Tensorflow支持的浮点数类型有float16, float32, float64，其中float16本质上是Eigen::half类型，即半精度浮点数[10]。关于半精度浮点数，英伟达2002年首次提出使用半精度浮点数达到降低数据传输和存储成本的目的。



在分布式计算中，如果对数据精度要求不那么高，可以将传输数据转换为float16类型，这样可以大大缩短设备间的数据传输时间。在GPU运算中，float16还可以减少一般的内存占用。



在Tensorflow的分布式传输中，默认会将float32转换为float16类型。Tensorflow的转换方式不同于nvidia的标准，采用直接截断尾数的方式转化为半精度浮点数，以减少转换时间。



浮点数存储格式分成3部分，符号位，指数和尾数。不同精度是指数位和尾数位的长度不一样。


## 设备内存管理



TF设备内存管理模块利用BFC算法（best-fit with coalescing）实现。BFC算法是Doung Lea’s malloc(dlmalloc)的一个非常简单的版本。它具有内存分配、释放、碎片管理等基本功能[11]。



BFC将内存分成一系列内存块，每个内存块由一个chunk数据结构管理。从chunk结构中可以获取到内存块的使用状态、大小、数据的基址、前驱和后继chunk等信息。整个内存可以通过一个chunk的双链表结构来表示。


图 3 11内存分块结构图



用户申请一个内存块（malloc）。根据建立的chunk双链表找到一个合适的内存块（后面会说明什么是合适的内存块），如果该内存块的大小是用户申请大小的两倍以上，那么将该内存块切分成两块，这就是split操作。返回其中一块给用户，并将该内存块标识为占用。Spilt操作会新增一个chunk，所以需要修改chunk双链表以维持前驱和后继关系。



用户释放一个内存块（free）。先将该块标记为空闲。然后根据chunk数据结构中的信息找到其前驱和后继内存块。如果前驱和后继块中有空闲的块，那么将刚释放的块和空闲的块合并成一个更大的chunk（这就是merge操作，合并当前块和其前后的空闲块）。再修改双链表结构以维持前驱后继关系。这就做到了内存碎片的回收。



BFC的核心思想是：将内存分块管理，按块进行空间分配和释放；通过split操作将大内存块分解成小内存块；通过merge操作合并小的内存块，做到内存碎片回收。



但是还留下许多疑问。比如说申请内存空间时，什么样的块算合适的内存块？如何快速管理这种块？



BFC算法采取的是被动分块的策略。最开始整个内存是一个chunk，随着用户申请空间的次数增加，最开始的大chunk会被不断的split开来，从而产生越来越多的小chunk。当chunk数量很大时，为了寻找一个合适的内存块而遍历双链表无疑是一笔巨大的开销。为了实现对空闲块的高效管理，BFC算法设计了bin这个抽象数据结构。



Bin数据结构中，每个bin都有一个size属性，一个bin是一个拥有chunk size >= bin size的空闲chunk的集合。集合中的chunk按照chunk size的升序组织成单链表。BFC算法维护了一个bin的集合：bins。它由多个bin以及从属于每个bin的chunks组成。内存中所有的空闲chunk都由bins管理。


图 3 12 bins集合的结构图



图 3 12中每一列表示一个bin，列首方格中的数字表示bin的size。bin size的大小都是256的2^n的倍。每个bin下面挂载了一系列的空闲chunk，每个chunk的chunk size都大于等于所属的bin的bin size，按照chunk size的升序挂载成单链表。BFC算法针对bins这个集合设计了三个操作：search、insert、delete。



Search 操作：给定一个chunk size，从bins中找到大于等于该chunk size的最小的那个空闲chunk。Search操作具体流程如下。如果bin以数组的形式组织，那么可以从index = chunk size /256 >>2的那个bin开始查找。最好的情况是开始查找的那个bin的chunk链表非空，那么直接返回链表头即可。这种情况时间复杂度是常数级的。最坏的情况是遍历bins数组中所有的bin。对于一般大小的内存来说，bins数组元素非常少，比如4G空间只需要23个bin就足够了（256 * 2 ^ 23 > 4G），因此也很快能返回结果。总体来说search操作是非常高效的。对于固定大小内存来说，查找时间是常数量级的。



Insert 操作：将一个空闲的chunk插入到一个bin所挂载的chunk链表中，同时需要维持chunk链表的升序关系。具体流程是直接将chunk插入到index = chunk size /256 >>2的那个bin中即可。



Delete操作：将一个空闲的chunk从bins中移除。



TF中内存分配算法实现文件core/common_runtime/bfc_allocator.cc，GPU内存分配算法实现文件core/common_runtime/gpu/gpu_bfc_allocator.cc。