MSDP简介
MSDP是Multicast Source Discovery Protocol（组播源发现协议）的简称，是为了解决多个PIM-SM（Protocol Independent Multicast Sparse Mode，协议无关组播—稀疏模式）域之间的互连而开发的一种域间组播解决方案，用来发现其他PIM-SM域内的组播源信息。

MSDP目前只支持在IPv4网络部署，域内组播路由协议必须是PIM-SM。MSDP仅对ASM（Any-Source Multicast）模型有意义。

目的：
PIM-SM模式下，源端DR（Designated Router）向RP注册，成员端DR也会向RP发起加入报文，因此RP可以获取到所有组播源和组播组成员的信息。随着网络规模的增大以及便于控制组播资源，管理员可能会将一个PIM网络划分为多个PIM-SM域，此时各个域中的RP无法了解其他域中的组播源信息。MSDP可以解决这一问题。

MSDP通过在不同PIM-SM域的路由器（通常在RP上）之间建立MSDP对等体，MSDP对等体之间交互SA（Source-Active）消息，共享组播源信息，最终可以使一个域内的组播用户接收到其他域的组播源发送的组播数据。

MSDP用于在ISP（Internet Service Provider）之间建立对等体。通常，ISP并不希望借助其他ISP的RP来向自己的用户提供服务。这一方面是出于安全性考虑，另一方面如果其他ISP的RP发生故障导致业务中断，用户投诉的却是自己的服务。借助MSDP，每个ISP可以实现依靠自己的RP来向Internet转发和接收组播数据。

尽管MSDP是为域间组播产生的，但它在PIM-SM域内还有着一项特殊的应用——Anycast RP（任播RP）。Anycast RP是指在同一PIM-SM域内通过设置两个或多个具有相同地址的RP，并在这些RP之间建立MSDP对等体关系，以实现域内各RP之间的负载分担和冗余备份。

优点：
MSDP可以实现域间组播，同时对ISP而言还有以下优点：

PIM-SM域可以依靠本域的RP提供服务，降低了对其他域RP的依赖。还可以控制本域的源信息是否传递到其他域中，提高了网络安全性。
如果某个域中只有接收者，他不必去整个网络上汇报组成员关系，只在本PIM-SM域内汇报，就可以接收到组播数据。
单个PIM-SM域内的设备不需要专门维护整网的组播源信息和组播路由表项，节省系统资源。
原理描述
MSDP对等体：
使用MSDP实现跨域组播的首要任务是：建立MSDP对等体。

通常，在各个PIM-SM域的RP之间配置MSDP对等体关系，MSDP对等体之间交互SA（Source Active）消息，SA消息中携带组播源DR在RP上注册时的（S，G）信息。通过这些MSDP对等体之间的信息传递，任意一个RP发出的SA消息能够被其他所有的RP收到。

MSDP对等体并不是只能配置在RP上，如下图所示，MSDP对等体可以创建在任意的PIM路由器上，在不同角色的PIM路由器上所创建的MSDP对等体的功能有所不同。



图：MSDP对等体位置
在RP上创建的MSDP对等体:

MSDP对等体分类	位置	功能
源端MSDP对等体	离组播源（Source）最近的MSDP对等体（通常也就是源端RP，如RP1）	源端RP创建SA消息并发送给远端MSDP对等体，通告在本RP上注册的组播源信息。源端MSDP对等体必须配置在RP上，否则将无法向外发布组播源信息。
接收者端MSDP对等体	离接收者（Receiver）最近的MSDP对等体（如RP3）	接收者端MSDP对等体在收到SA消息后，根据该消息中所包含的组播源信息，跨域加入以该组播源为根的SPT；当来自该组播源的组播数据到达后，再沿RPT向本地接收者转发。接收者端MSDP对等体必须配置在RP上，否则无法接收到其他域的组播源信息。
中间MSDP对等体	拥有多个远端MSDP对等体的MSDP对等体（如RP2）	中间MSDP对等体把从一个远端MSDP对等体收到的SA消息转发给其他远端MSDP对等体，其作用相当于传输组播源信息的中转站。
在普通的PIM路由器（非RP）上创建的MSDP对等体

如RouterA和RouterB，其作用仅限于将收到的SA消息转发出去。

MSDP协议报文：
MSDP的协议报文封装在TCP数据报中，协议报文的格式都符合标准的TLV（Type-Length-Value）消息格式，如下图所示：



图：MSDP协议报文格式
MSDP协议报文类型：
Source-Active（SA）：

Type 1。

功能：1、携带多组（S，G）信息，在多个RP之间传递。

​ 包含的主要信息：

​ 源RP的IP地址。

​ 消息中包含的（S,G）项数量。

​ 域中活跃的（S，G）列表

​ 2、封装PIM-SM组播数据。

​ 包含的主要信息：

​ 源RP的IP地址。

​ PIM-SM组播数据。

Source-Active-Response（SA-Req）:

Type 2。
功能：主动请求指定组G的（S，G）列表，减少源加入的延迟。
报文中包含：被请求的组地址G。
Source-Active Response（SA-Resp）：

Type 3.
功能：对Source-Active Request消息的响应。
报文中包含：源RP的IP地址
​ 消息中包含的（S，G）项数量
​ 域中活动（S，G）列表
KeepAlive：

Type 4。
功能：保持MSDP对等体的连接关系。只在对等体之间无其他协议报文交互时才发送。
Reserved：

Type 5。
功能：保留类型，当前是用作Notification消息。
Traceroute in Progress：

Type 6。
Traceroute Reply：

Type 7。
和类型6的功能：用于MSDP的Traceroute功能，对SA消息的RPF传递路径进行检测。
SA消息中可以携带（S，G）信息，也可以封装组播数据报文。MSDP对等体之间通过交互SA消息共享（S，G）信息。为了避免SA消息中的（S，G）表项超时导致远端用户无法收到组播源的数据，可以在SA消息中封装组播数据报文。

由于SA消息是周期性发送的，当域内出现新的组用户时，要等待一个周期内的SA消息以获取有效的（S，G）信息。为了减少新组用户加入源SPT的时延，MSDP提供了Type2和Type3的SA-Req消息与SA-Resp消息，提高活动源信息更新的效率。

对等体建立的过程：
MSDP对等体建立：
MSDP对等体通过TCP连接建立，使用端口639。

两台设备使能MSDP并互相指定对方为MSDP对等体后，两端先比较IP地址**，IP地址较小**的一端会启动连接重试定时器（ConnectRetry timer），并主动发起TCP连接。IP地址较大的一端负责确认是否有TCP连接在端口639建立。TCP连接建立后，MSDP对等体关系就建立了，对等体之间通过KeepAlive消息维持连接关系。



图：MSDP对等体建立过程
如上图所示，RouterA和RouterB之间建立MSDP对等体的过程如下：

起始状态下，两台路由器的MSDP会话状态都是Down。
在两端使能MSDP并互相指定对方为MSDP对等体后，两端比较建立连接使用的地址：
RouterA的地址较小，进入Connect状态，向RouterB发起连接，并启动ConnectRetry定时器。该定时器用于定义连接重试的周期。
RouterB的地址较大，进入Listen状态，等待对端进行连接。
TCP连接建立成功后，两端的MSDP会话进入Up状态。
MSDP对等体两端发送KeepAlive消息，通知对方保持MSDP连接状态。
MSDP认证：
在TCP连接建立时进行加密认证，可以保证安全性。配置了认证功能后，MSDP对等体两端必须都使用相同的加密算法和密码，才能正常建立TCP连接，否则不建立连接。MSDP支持MD5和Keychain两种加密方式，二者在使用时互斥，MSDP对等体之间只能选择一种方式加密。

组播源信息在域间的传递：
如下图所示，PIM-SM网络被划分为4个PIM-SM域。PIM-SM1域内存在激活的组播源（Source），RP1通过组播源注册过程了解到了该组播源的存在。如果PIM-SM2和PIM-SM3域也希望知道该组播源的具体位置，进而能够从该组播源获取组播数据，则需要在RP1与RP2、RP2与RP3之间分别建立MSDP对等体关系。



图：组播源信息在域间的传递
组播源信息在域间传递的过程如下：

当PIM-SM1域内的组播源Source向组播组G发送第一个组播数据包时，DR1（Designated Router）将该组播数据封装在注册报文（Register Message）中，并发给RP1。RP1因此获知了该组播源的相关信息。
RP1作为源端RP，创建SA消息，并周期性地向它的对等体RP2发送。SA消息中包含组播源的地址S、组播组的地址G以及创建该SA消息的源端RP（即RP1）的地址。
RP2接收到该SA消息后，执行RPF（Reverse Path Forwarding）检查。检查通过，向RP3转发，同时检查本域内是否存在组G成员。由于PIM-SM2域内没有组G的接收者，故RP2不做其他动作。
RP3接收到该SA消息后，执行RPF检查，检查通过。由于PIM-SM3域内存在组G成员，会通过IGMP协议在RP3上生成（*，G）表项，表示本域内存在组G成员。
RP3创建（S，G）表项，向组播源Source逐跳发送（S，G）加入报文，创建一条从Source到RP3的组播路径（SPT）。组播数据沿SPT到达RP3后，再沿RPT向接收者转发。
当接收者侧DR3收到Source发出的组播数据后，可以自行决定是否发起SPT切换。
控制SA消息的转发：
SA消息在MSDP对等体之间转发，除了RPF检查，还可以配置各种转发策略的过滤，从而只接收和转发来自正确路径并通过过滤的SA消息，以避免SA消息传递环路；另外，可以在MSDP对等体之间配置MSDP全连接组（Mesh Group），以避免SA消息在MSDP对等体之间的泛滥。

SA消息的RPF检测规则：
为了防止SA消息在MSDP对等体之间被循环转发，MSDP对接收到的SA消息执行RPF检查，在消息传递的入方向上进行严格的控制。不符合RPF规则的SA消息，将被丢弃。

RPF检查的主要规则为：MSDP设备收到SA消息后，根据MRIB（Multicast RPF Routing Information Base）确定到源RP（即创建该SA消息的RP）最佳路径的下一跳是哪个对等体，这个对等体也称为“RPF对等体”。如果发现SA消息是从RPF对等体发出的，则接收该SA消息并向其他对等体转发。MRIB包括：MBGP、组播静态路由、单播路由（包括BGP、IGP）。

此外，还有如下的一些RPF检查规则，SA消息在转发时遵守：

规则1：发出SA消息的对等体就是源RP，则接收该SA消息并向其他对等体转发。
规则2：接收从静态RPF对等体到来的SA消息。一台路由器可以同时与多个路由器建立MSDP对等体关系。用户可以从这些远端对等体中选取一个或多个，配置为静态RPF对等体。
规则3：如果一台路由器只拥有一个远端MSDP对等体，则该远端对等体自动成为RPF对等体，路由器接收从该远端对等体发来的SA消息。
规则4：发出SA消息的对等体与本地路由器属于同一Mesh Group，则接收该SA消息。来自Mesh Group的SA消息不再向属于该Mesh Group的成员转发，但向该Mesh Group之外的所有对等体转发。
规则5：到达源RP的路由需要跨越多个AS时，接收从下一跳AS（以AS为单位）中的对等体发出的SA消息，如果该AS中存在多个远端MSDP对等体，则接收从IP地址最高的对等体发来的SA消息。
MSDP全连接组（Mesh Group）：
当网络中存在多个MSDP对等体时，很容易导致SA消息在对等体之间泛滥。同时，MSDP对等体对每一个到来的SA报文进行RPF检查，给系统造成很大的负担。将多个MSDP对等体加入同一个Mesh Group，就可以大幅度减少在这些MSDP对等体之间传递的SA消息。

Mesh Group成员可以都属于同一个PIM-SM域，也可以分布在多个PIM-SM域中；可以都位于同一个AS，也可以位于多个AS中。

属于同一个Mesh Group的所有成员之间必须两两建立MSDP对等体连接，并承认对方为该Mesh Group的成员。如下图中的RouterA、RouterB、RouterC和RouterD，加入同一个Mesh Group，则必须在每台路由器上配置与其他三台路由器建立MSDP对等体关系。



图：Mesh Group内部成员之间的MSDP对等体连接
当Mesh Group内部成员接收到SA消息后，首先检查该SA消息的来源：

如果该SA消息来自Mesh Group外部的某个MSDP对等体，则对该SA消息进行RPF检查。如果检查通过，向Mesh Group内其他所有成员转发。
如果该SA消息来自Mesh Group内部成员，则不进行RPF检查，直接接收。同时也不再向Mesh Group内其他成员转发。
SA消息过滤：
缺省情况下，MSDP不过滤SA消息，从一个域中发出的SA消息可以被传递到全网的MSDP对等体。

然而，有些PIM-SM域的（S，G）表项只适用于本域内指导转发，如一些本地组播应用使用了全局的组播组地址，或组播源用的是私网地址10.x.x.x。如果不加过滤，这些（S，G）表项就会经过SA消息传递到其他MSDP对等体。针对这种情况，可以配置SA消息的过滤规则（一般使用ACL定义过滤的规则），并在创建、转发或接收SA消息时使用这些规则，就可以实现SA消息过滤。