# DHCPv6

> 参考文献
> * [DHCPv6](https://blog.csdn.net/qq_38265137/article/details/80466734)

DHCPv6简介
IPv6动态主机配置协议DHCPv6(Dynamic Host Configuration Protocol for IPv6)是针对IPv6编址方案设计，为主机分配IPv6地址/前缀和其他网络配置参数。

目的：
IPv6协议具有地址空间巨大的特点，但同时长达128比特的IPv6地址又要求高效合理的地址自动分配和管理策略。IPv6无状态地址配置方式（参看协议RFC2462）是目前广泛采用的IPv6地址自动配置方式。配置了该协议的主机只需相邻设备开启IPv6路由通告功能，即可以根据通告报文包含的前缀信息自动配置本机地址。

无状态地址配置方案中设备并不记录所连接的IPv6主机的具体地址信息，可管理性差。而且当前无状态地址配置方式不能使IPv6主机获取DNS服务器的IPv6地址等配置信息，在可用性上有一定缺陷。对于互联网服务提供商来说，也没有相关的规范指明如何向设备自动分配IPv6前缀，所以在部署IPv6网络时，只能采用手动配置的方法为设备配置IPv6地址。

DHCPv6技术解决了这一问题。DHCPv6属于一种有状态地址自动配置协议。

与其他IPv6地址分配方式（手工配置、通过路由器通告消息中的网络前缀无状态自动配置等）相比，DHCPv6具有以下优点：

更好地控制IPv6地址的分配。DHCPv6方式不仅可以记录为IPv6主机分配的地址，还可以为特定的IPv6主机分配特定的地址，以便于网络管理。
DHCPv6支持为网络设备分配IPv6前缀，便于全网络的自动配置和网络层次性管理。
除了为IPv6主机分配IPv6地址/前缀外，还可以分配DNS服务器IPv6地址等网络配置参数。
DHCPv6原理描述
DHCPv6概述：
DHCPv6是一种运行在客户端和服务器之间的协议，与IPv4中的DHCP一样，所有的协议报文都是基于UDP的。但是由于在IPv6中没有广播报文，因此DHCPv6使用组播报文，客户端也无需配置服务器的IPv6地址。

IPv6地址分配类型：
IPv6协议具有地址空间巨大的特点，但同时长达128比特的IPv6地址又要求高效合理的地址自动分配和管理策略。

手动配置。手动配置IPv6地址/前缀及其他网络配置参数（DNS、NIS、SNTP服务器地址等参数）。
无状态自动地址分配。由接口ID生成链路本地地址，再根据路由通告报文RA（Router Advertisement）包含的前缀信息自动配置本机地址。
有状态自动地址分配，即DHCPv6方式。DHCPv6又分为如下两种:
DHCPv6有状态自动分配。DHCPv6服务器自动分配IPv6地址/PD前缀及其他网络配置参数（DNS、NIS、SNTP服务器地址等参数）。
DHCPv6无状态自动分配。主机IPv6地址仍然通过路由通告方式自动生成，DHCPv6服务器只分配除IPv6地址以外的配置参数，包括DNS、NIS、SNTP服务器等参数。
DHCPv6基本架构：


图：DHCPv6基本架构
DHCPv6基本协议架构中，主要包括以下三种角色：

DHCPv6 Client：

DHCPv6客户端，通过与DHCPv6服务器进行交互，获取IPv6地址/前缀和网络配置信息，完成自身的地址配置功能。

DHCPv6 Relay：

DHCPv6中继代理，负责转发来自客户端方向或服务器方向的DHCPv6报文，协助DHCPv6客户端和DHCPv6服务器完成地址配置功能。一般情况下，DHCPv6客户端通过本地链路范围的组播地址与DHCPv6服务器通信，以获取IPv6地址/前缀和其他网络配置参数。如果服务器和客户端不在同一个链路范围内，则需要通过DHCPv6中继代理来转发报文，这样可以避免在每个链路范围内都部署DHCPv6服务器，既节省了成本，又便于进行集中管理。

DHCPv6基本协议架构中，DHCPv6中继代理不是必须的角色。如果DHCPv6客户端和DHCPv6服务器位于同一链路范围内，或DHCPv6客户端和DHCPv6服务器直接通过单播交互完成地址分配或信息配置的情况下，是不需要DHCPv6中继代理参与的。只有当DHCPv6客户端和DHCPv6服务器不在同一链路范围内，或DHCPv6客户端和DHCPv6服务器无法单播交互的情况下，才需要DHCPv6中继代理的参与。

DHCPv6 Server：

DHCPv6服务器，负责处理来自客户端或中继代理的地址分配、地址续租、地址释放等请求，为客户端分配IPv6地址/前缀和其他网络配置信息。

DHCPv6基本概念：
组播地址

在DHCPv6协议中，客户端不用配置DHCPv6 Server的IPv6地址，而是发送目的地址为组播地址的Solicit报文来定位DHCPv6服务器。
在DHCPv4协议中，客户端发送广播报文来定位服务器。为避免广播风暴，在IPv6中，已经没有了广播类型的报文，而是采用组播报文。DHCPv6用到的组播地址有两个：
FF02::1:2（All DHCP Relay Agents and Servers）：所有DHCPv6服务器和中继代理的组播地址，这个地址是链路范围的，用于客户端和相邻的服务器及中继代理之间通信。所有DHCPv6服务器和中继代理都是该组的成员。
FF05::1:3（All DHCP Servers）：所有DHCPv6服务器组播地址，这个地址是站点范围的，用于中继代理和服务器之间的通信，站点内的所有DHCPv6服务器都是此组的成员。
UDP端口号

DHCPv6报文承载在UDPv6上。
客户端侦听的UDP目的端口号是546。
服务器、中继代理侦听的UDP端口号是547。
DHCP唯一标识符（DUID）

DHCP设备唯一标识符DUID（DHCPv6 Unique Identifier），每个服务器或客户端有且只有一个唯一标识符，服务器使用DUID来识别不同的客户端，客户端则使用DUID来识别服务器。

客户端和服务器DUID的内容分别通过DHCPv6报文中的Client Identifier和Server Identifier选项来携带。两种选项的格式一样，通过option-code字段的取值来区分是Client Identifier还是Server Identifier选项。

身份联盟（IA）

身份联盟IA（Identity Association）是使得服务器和客户端能够识别、分组和管理一系列相关IPv6地址的结构。每个IA包括一个IAID和相关联的配置信息。
客户端必须为它的每一个要通过服务器获取IPv6地址的接口关联至少一个IA。客户端用给接口关联的IA来从服务器获取配置信息。每个IA必须明确关联到一个接口。
IA的身份由IAID唯一确定，同一个客户端的IAID不能出现重复。IAID不应因为设备的重启等因素发生丢失或改变。
IA中的配置信息由一个或多个IPv6地址以及T1和T2生存期组成。IA中的每个地址都有首选生存期和有效生存期。
一个接口至少关联一个IA，一个IA可以包含一个或多个地址信息。
DHCPv6报文类型
DHCPv6报文格式：


图：DHCPv6的报文格式
字段	长度	含义
msg-type	1字节	表示报文的类型，取值为1～13，具体请参见DHCPv6报文类型。
transaction-ID	3字节	DHCPv6交互ID，也叫事务ID，用来标识一个来回的DHCPv6报文交互。例如Solicit/Advertise报文为一个交互。Request/Reply报文为另外一个交互，两者有不同的事务ID。交互ID特点如下：交互ID是DHCPv6客户端生成的一个随机值，DHCPv6客户端应当保证交互ID具有一定的随机性。对于DHCPv6服务器响应报文和相应的请求报文，两者交互ID保持一致。如果是DHCPv6服务器主动发起的会话报文，则交互ID为0。
Options	可变	表示DHCPv6的选项字段。此字段包含了DHCPv6服务器分配给IPv6主机的配置信息，如DNS服务器的IPv6地址等信息。
DHCPv6报文类型：
目前DHCPv6定义了如下十三种类型报文，DHCPv6服务器和DHCPv6客户端之间通过这十三种类型的报文进行通信。

DHCPv6和DHCPv4报文对比：

报文类型	DHCPv6报文	DHCPv4报文	说明
1	SOLICIT	DHCP DISCOVER	DHCPv6客户端使用Solicit报文来确定DHCPv6服务器的位置。
2	ADVERTISE	DHCP OFFER	DHCPv6服务器发送Advertise报文来对Solicit报文进行回应，宣告自己能够提供DHCPv6服务。
3	REQUEST	DHCP REQUEST	DHCPv6客户端发送Request报文来向DHCPv6服务器请求IPv6地址和其它配置信息。
4	CONFIRM	-	DHCPv6客户端向任意可达的DHCPv6服务器发送Confirm报文检查自己目前获得的IPv6地址是否适用与它所连接的链路。
5	RENEW	DHCP REQUEST	DHCPv6客户端向给其提供地址和配置信息的DHCPv6服务器发送Renew报文来延长地址的生存期并更新配置信息。
6	REBIND	DHCP REQUEST	如果Renew报文没有得到应答，DHCPv6客户端向任意可达的DHCPv6服务器发送Rebind报文来延长地址的生存期并更新配置信息。
7	REPLY	DHCP ACK/NAK	DHCPv6服务器在以下场合发送Reply报文：DHCPv6服务器发送携带了地址和配置信息的Reply消息来回应从DHCPv6客户端收到的Solicit、Request、Renew、Rebind报文。DHCPv6服务器发送携带配置信息的Reply消息来回应收到的Information-Request报文。用来回应DHCPv6客户端发来的Confirm、Release、Decline报文。
8	RELEASE	DHCP RELEASE	DHCPv6客户端向为其分配地址的DHCPv6服务器发送Release报文，表明自己不再使用一个或多个获取的地址。
9	DECLINE	DHCP DECLINE	DHCPv6客户端向DHCPv6服务器发送Decline报文，声明DHCPv6服务器分配的一个或多个地址在DHCPv6客户端所在链路上已经被使用了。
10	RECONFIGURE	-	DHCPv6服务器向DHCPv6客户端发送Reconfigure报文，用于提示DHCPv6客户端，在DHCPv6服务器上存在新的网络配置信息。
11	INFORMATION-REQUEST	DHCP INFORM	DHCPv6客户端向DHCPv6服务器发送Information-Request报文来请求除IPv6地址以外的网络配置信息。
12	RELAY-FORW	-	中继代理通过Relay-Forward报文来向DHCPv6服务器转发DHCPv6客户端请求报文。
13	RELAY-REPL	-	DHCPv6服务器向中继代理发送Relay-Reply报文，其中携带了转发给DHCPv6客户端的报文。
DHCPv6报文抓包：
Solicit报文（类型1）：
DHCPv6客户端使用Solicit报文来确定DHCPv6服务器的位置。



图：Solicit报文抓包示例
Advertise报文（类型2）：
DHCPv6服务器发送Advertise报文来对Solicit报文进行回应，宣告自己能够提供DHCPv6服务。



图：Advertise报文抓包示例
Request报文（类型3）：
DHCPv6客户端发送Request报文来向DHCPv6服务器请求IPv6地址和其它配置信息。



图：Request报文抓包示例
Renew报文（类型5）：
DHCPv6客户端向给其提供地址和配置信息的DHCPv6服务器发送Renew报文来延长地址的生存期并更新配置信息。



图：Renew报文抓包示例
Rebind报文（类型6）：
如果Renew报文没有得到应答，DHCPv6客户端向任意可达的DHCPv6服务器发送Rebind报文来延长地址的生存期并更新配置信息。



图：Rebind报文抓包示例
Reply报文（类型7）：
DHCPv6服务器在以下场合发送Reply报文：DHCPv6服务器发送携带了地址和配置信息的Reply消息来回应从DHCPv6客户端收到的Solicit、Request、Renew、Rebind报文。DHCPv6服务器发送携带配置信息的Reply消息来回应收到的Information-Request报文。用来回应DHCPv6客户端发来的Confirm、Release、Decline报文。



图：Reply报文抓包示例
Release(类型8);
DHCPv6客户端向为其分配地址的DHCPv6服务器发送Release报文，表明自己不再使用一个或多个获取的地址。



图：Release报文抓包示例
Reply-forw报文（类型12）：
中继代理通过Relay-Forward报文来向DHCPv6服务器转发DHCPv6客户端请求报文。


图：Relay-Forw报文抓包示例
Relay-reply报文（类型13）：
DHCPv6服务器向中继代理发送Relay-Reply报文，其中携带了转发给DHCPv6客户端的报文。



图：Relay-Reply报文抓包示例
DHCPv6工作原理：：
DHCPv6自动分配分为DHCPv6有状态自动分配和DHCPv6无状态自动分配。

DHCPv6有状态自动分配。DHCPv6服务器自动配置IPv6地址/前缀，同时分配DNS、NIS、SNTP服务器等网络配置参数。
DHCPv6无状态自动分配。主机IPv6地址仍然通过路由通告方式自动生成，DHCP服务器只分配除IPv6地址以外的配置参数，包括DNS、NIS、SNTP服务器地址等参数。
DHVPv6有状态自动分配：
IPv6主机通过有状态DHCPv6方式获取IPv6地址和其他配置参数（例如DNS服务器的IPv6地址等）。

DHCPv6服务器为客户端分配地址/前缀的过程分为两类：

DHCPv6四步交互分配过程
DHCPv6两步交互快速分配过程
DHCPv6四步交互

四步交互常用于网络中有多个DHCPv6服务器的情况。DHCPv6客户端首先通过组播发送Solicit报文来定位可以为其提供服务的DHCPv6服务器，在收到多个DHCPv6服务器的Advertise报文后，根据DHCPv6服务器的优先级选择一个为其分配地址和配置信息的服务器，接着通过Request/Reply报文交互完成地址申请和分配过程。

DHCPv6服务器端如果没有配置使能两步交互，无论客户端报文中是否包含Rapid Commit选项，服务器都采用四步交互方式为客户端分配地址和配置信息。

DHCPv6四步交互地址分配过程如下：



图：DHCPv6四步交互地址分配过程
DHCPv6四步交互地址分配过程如下：

DHCPv6客户端发送Solicit报文，请求DHCPv6服务器为其分配IPv6地址和网络配置参数。
如果Solicit报文中没有携带Rapid Commit选项，或Solicit报文中携带Rapid Commit选项，但服务器不支持快速分配过程，则DHCPv6服务器回复Advertise报文，通知客户端可以为其分配的地址和网络配置参数。
如果DHCPv6客户端接收到多个服务器回复的Advertise报文，则根据Advertise报文中的服务器优先级等参数，选择优先级最高的一台服务器，并向所有的服务器发送Request组播报文，该报文中携带已选择的DHCPv6服务器的DUID。
DHCPv6服务器回复Reply报文，确认将地址和网络配置参数分配给客户端使用。
DHCPv6两步交互

两步交互常用于网络中只有一个DHCPv6服务器的情况。DHCPv6客户端首先通过组播发送Solicit报文来定位可以为其提供服务的DHCPv6服务器，DHCPv6服务器收到客户端的Solicit报文后，为其分配地址和配置信息，直接回应Reply报文，完成地址申请和分配过程。

两步交换可以提高DHCPv6过程的效率，但在有多个DHCPv6服务器的网络中，多个DHCPv6服务器都可以为DHCPv6客户端分配IPv6地址，回应Reply报文，但是客户端实际只可能使用其中一个服务器为其分配的IPv6地址和配置信息。为了防止这种情况的发生，管理员可以配置DHCPv6服务器是否支持两步交互地址分配方式。

DHCPv6服务器端如果配置使能了两步交互，并且客户端报文中也包含Rapid Commit选项，服务器采用两步交互方式为客户端分配地址和配置信息。
如果DHCPv6服务器不支持快速分配地址，则采用四步交互方式为客户端分配IPv6地址和其他网络配置参数。
DHCPv6两步交互地址分配过程如下图：



图：DHCPv6两步交互地址分配过程
DHCPv6两步交互地址分配过程如下：

DHCPv6客户端在发送的Solicit报文中携带Rapid Commit选项，标识客户端希望服务器能够快速为其分配地址和网络配置参数。
DHCPv6服务器接收到Solicit报文后，将进行如下处理：
如果DHCPv6服务器支持快速分配地址，则直接返回Reply报文，为客户端分配IPv6地址和其他网络配置参数，Replay报文中也携带Rapid Commit选项。
如果DHCPv6服务器不支持快速分配过程，则采用四步交互方式为客户端分配IPv6地址/前缀和其他网络配置参数。
DHCPv6无状态自动分配：
IPv6节点可以通过DHCPv6无状态方式获取配置参数（包括DNS、SIP、SNTP等服务器配置信息，不包括IPv6地址）。

DHCPv6无状态工作过程如下图所示：



图：DHCPv6无状态工作过程
DHCPv6无状态工作过程如下：

DHCPv6客户端以组播方式向DHCPv6服务器发送Information-Request报文，该报文中携带Option Request选项，指定DHCPv6客户端需要从DHCPv6服务器获取的配置参数。
DHCPv6服务器收到Information-Request报文后，为DHCPv6客户端分配网络配置参数，并单播发送Reply报文，将网络配置参数返回给DHCPv6客户端。DHCPv6客户端根据收到Reply报文提供的参数完成DHCPv6客户端无状态配置。
DHCPv6 PD工作原理：
DHCPv6前缀代理DHCPv6 PD(Prefix Delegation)是由Cisco公司提出的一种前缀分配机制，并在RFC3633中得以标准化。在一个层次化的网络拓扑结构中，不同层次的IPv6地址分配一般是手工指定的。手工配置IPv6地址扩展性不好，不利于IPv6地址的统一规划管理。

通过DHCPv6前缀代理机制，下游网络设备不需要再手工指定用户侧链路的IPv6地址前缀，它只需要向上游网络设备提出前缀分配申请，上游网络设备便可以分配合适的地址前缀给下游设备，下游设备把获得的前缀(一般前缀长度小于64)进一步自动细分成64前缀长度的子网网段，把细分的地址前缀再通过路由通告(RA)至与IPv6主机直连的用户链路上，实现IPv6主机的地址自动配置，完成整个系统层次的地址布局。

DHCPv6 PD工作过程下图所示：



图：DHCPv6 PD工作原理
DHCPv6 PD四步交互地址分配过程如下：

DHCPv6 PD客户端发送Solicit报文，请求DHCPv6 PD服务器为其分配IPv6地址前缀。
如果Solicit报文中没有携带Rapid Commit选项，或Solicit报文中携带Rapid Commit选项，但服务器不支持快速分配过程，则DHCPv6服务器回复Advertise报文，通知客户端可以为其分配的IPv6地址前缀。
如果DHCPv6客户端接收到多个服务器回复的Advertise报文，则根据Advertise报文中的服务器优先级等参数，选择优先级最高的一台服务器，并向该服务器发送Request报文，请求服务器确认为其分配地址前缀。
DHCPv6 PD服务器回复Reply报文，确认将IPv6地址前缀分配给DHCPv6 PD客户端使用。
DHCPv6中继工作原理：
DHCPv6客户端通过DHCPv6中继转发报文，获取IPv6地址/前缀和其他网络配置参数（例如DNS服务器的IPv6地址等）。

DHCPv6中继工作过程如下图所示：



图：DHCPv6中继工作原理
DHCPv6中继工作交互过程如下：

DHCPv6客户端向所有DHCPv6服务器和DHCPv6中继发送目的地址为FF02::1:2（组播地址）的请求报文。
根据DHCPv6中继转发报文有如下两种情况：
如果DHCPv6中继和DHCPv6客户端位于同一个链路上，即DHCPv6中继为DHCPv6客户端的第一跳中继，中继转发直接来自客户端的报文，此时DHCPv6中继实质上也是客户端的IPv6网关设备。DHCPv6中继收到客户端的报文后，将其封装在Relay-Forward报文的中继消息选项（Relay Message Option）中，并将Relay-Forward报文发送给DHCPv6服务器或下一跳中继。
如果DHCPv6中继和DHCPv6客户端不在同一个链路上，中继收到的报文是来自其他中继的Relay-Forward报文。中继构造一个新的Relay-Forward报文，并将Relay-Forward报文发送给DHCPv6服务器或下一跳中继。
DHCPv6服务器从Relay-Forward报文中解析出DHCPv6客户端的请求，为DHCPv6客户端选取IPv6地址和其他配置参数，构造应答消息，将应答消息封装在Relay-Reply报文的中继消息选项中，并将Relay-Reply报文发送给DHCPv6中继。
DHCPv6中继从Relay-Reply报文中解析出DHCPv6服务器的应答，转发给DHCPv6客户端。如果DHCPv6客户端接收到多个DHCPv6服务器的应答，则根据报文中的服务器优先级选择一个DHCPv6服务器，后续从该DHCPv6服务器获取IPv6地址和其他网络配置参数。
IPv6地址/前缀的分配与更新原则：
IPv6地址分配的优先次序：
DHCPv6服务器按照如下次序为DHCPv6客户端选择IPv6地址/前缀。

选择IPv6地址池

DHCPv6服务器的接口可以绑定IPv6地址池，DHCPv6服务器将选择该IPv6地址池为接口下的DHCPv6客户端分配地址/前缀。对于存在中继的场景，DHCPv6服务器的接口可以不绑定IPv6地址池，而是根据报文中第一个不为0的“link-address”字段（标识DHCPv6客户端所在链路范围），选择与地址池中已配置的网络前缀或IPv6地址前缀属于同一链路范围的地址池。

选择IPv6地址/前缀

确定地址池后，DHCPv6服务器将按照下面步骤为DHCPv6客户端分配IPV6地址/前缀：

如果地址池中为客户端指定了地址/前缀，优先从地址池中选择与客户端DUID匹配的地址/前缀分配给客户端。
如果客户端报文中的IA选项携带了有效的地址/前缀，优先从地址池中选择该地址/前缀分配给客户端。如果该地址/前缀在地址池中不可用，则另外分配一个空闲地址/前缀给客户端。如果IPV6前缀长度比指定分配长度大，则按指定分配长度来分配。
从地址池中选择空闲地址/前缀分配给客户端，保留地址（例如RFC 2526中定义的任播地址）、冲突地址、已被分配的地址不能再分配给客户端。
如果没有合适的IPv6地址/前缀可以分配，则分配失败。
DHCPv6地址租约更新：
DHCPv6服务器为DHCPv6客户端分配的地址是有租约的，租约由生命期（包括地址的首选生命期和有效生命期构成）和续租时间点（IA的T1、T2）构成。地址有效生命期结束后，DHCPv6客户端不能再使用该地址。在有效生命期到达之前，如果DHCPv6客户端希望继续使用该地址，则需要更新地址租约。

DHCPv6客户端为了延长其与IA关联的地址的有效生命期和首选生命期，在T1时刻，发送包含IA选项的Renew报文给服务器，其中IA选项中携带需要续租的IA地址选项。如果DHCPv6客户端一直没有收到T1时刻续租报文的回应报文，那么在T2时刻，DHCPv6客户端通过Rebind报文向DHCPv6服务器继续续租地址。

T1时刻地址租约更新过程如下：

DHCPv6客户端在T1时刻（推荐值为优先生命期的0.5倍）发送Renew报文进行地址租约更新请求。
DHCPv6服务器回应Reply报文。
如果DHCPv6客户端可以继续使用该地址，则DHCPv6服务器回应续约成功的Reply报文，通知DHCPv6客户端已经成功更新地址租约。
如果该地址不可以再分配给该DHCPv6客户端，则DHCPv6服务器回应续约失败的Reply报文，通知DHCPv6客户端不能获得新的租约。
T2时刻地址租约更新过程如下：

DHCPv6客户端在T1时刻发送Renew请求更新租约，但是没有收到DHCPv6服务器的回应报文。

DHCPv6客户端在T2时刻（推荐值为优先生命期的0.8倍），向所有DHCPv6服务器组播发送Rebind报文请求更新租约。

DHCPv6服务器回应Reply报文。

如果DHCPv6客户端可以继续使用该地址，则DHCPv6服务器回应续约成功的Reply报文，通知DHCPv6客户端已经成功更新地址/前缀租约。
如果该地址不可以再分配给该DHCPv6客户端，则DHCPv6服务器回应续约失败的Reply报文，通知DHCPv6客户端不能获得新的租约。
如果DHCPv6客户端没有收到DHCPv6服务器的应答报文，则到达有效生命期后，DHCPv6客户端停止使用该地址。

IP地址预留：
DHCPv6服务器支持预留IPv6地址，即保留部分IPv6地址不参与动态分配。比如预留的IPv6地址可作为DNS服务器的IPv6地址。

DHCPv6基础配置命令
address prefix 
//IPv6地址池视图下配置网络前缀和生命周期。
//infinite:指定生命周期为无穷大。
//生命周期默认值为86400，即1天。
capwap-ac ipv6-address
//在IPv6地址池视图下配置AC的IPv6地址。
conflict-address expire-time expire-time
//配置IPv6地址池下冲突地址老化时间。
//缺省情况下，地址池下的冲突地址老化时间是172800秒，即2天。
dhcpv6 client information-request
//使能接口以DHCPv6无状态自动分配方式获取网络配置参数
//（不包括IPv6地址）的功能。
dhcpv6 client pd
//配置DHCPv6 PD客户端功能。
//hint ipv6-address:指定期望申请的IPv6地址
//hint ipv6-prefix/ipv6-prefix-length:
//      指定期望申请的IPv6地址前缀和前缀长度。
//rapid-commit:指定客户端以两步交互申请IPv6地址前缀。
//unicast-option:指定客户端以单播方式申请IPv6地址前缀。
//union-mode:指定客户端使用一个报文同时获取IPv6地址和前缀。
dhcpv6 duid { ll | llt | duid }
//配置DHCPv6设备的唯一标识符DUID。
//缺省情况下，设备以ll的方式生成DUID。
//ll:指定设备采用链路层地址（即MAC地址）方式生成DUID。
//llt:指定设备采用链路层地址（即MAC地址）加时间的方式生成DUID。
dhcpv6 client renew
//手动更新DHCPv6客户端申请到的IPv6地址/前缀。
renew-time-percent rebind-time-percent
//配置IPv6地址池的续租时间和重绑定时间占优先生命周期的百分比。
//缺省情况下，IPv6地址池的续租时间占优先生命周期的50%
//重绑定时间占优先生命周期的80%。
dhcpv6 interface-id format { default | user-defined text }
//配置DHCPv6报文中Interface-ID选项的格式。
dhcpv6 packet-rate
//使能DHCPv6报文限速功能，并配置速率抑制值。
//缺省情况下，DHCPv6报文限速功能处于未使能状态。
dhcpv6 packet-rate drop-alarm enable
//使能DHCPv6报文限速丢弃告警功能。
dhcpv6 packet-rate drop-alarm threshold 100
  //配置DHCPv6报文限速丢弃告警阈值.缺省值为100包
dhcpv6 pool pool-name
//创建IPv6/IPv6 PD地址池或进入IPv6/IPv6 PD地址池视图
dhcpv6 relay destination
//使能接口的DHCPv6中继代理功能
//并配置DHCPv6服务器或下一跳中继代理的IPv6地址。
dhcpv6 relay server-select group-name 
//来配置DHCPv6中继所对应的DHCPv6服务器组。 
dhcpv6 relay source-interface
//配置接口地址作为报文源IPv6地址。
dhcpv6 remote-id format
//配置DHCPv6报文中Remote-ID选项的格式。
dhcpv6 remote-id insert enable
//使能在DHCPv6中继报文中插入remote-id选项的功能。
dhcpv6 server
//使能DHCPv6服务器或DHCPv6 PD服务器功能。
dhcpv6-server ipv6-address
//配置在DHCPv6服务器组中添加DHCPv6服务器或下一跳中继的成员。
dhcpv6 server database
//使能DHCPv6数据保存功能。
//write-delay :指定DHCPv6数据保存的时间间隔。
dhcpv6 server group group-name 
//创建一个DHCPv6服务器组并进入DHCPv6服务器组视图
dns-domain-name
//配置DHCPv6服务器为DHCPv6客户端分配的域名后缀。
dns-server ipv6-address 
//配置DNS服务器IPv6地址。
excluded-address
//配置IPv6地址池中不参与自动分配的IPv6地址范围。
information-refresh time
//设置无状态DHCPv6方式分配给客户端的配置信息刷新时间。
//缺省情况下，IPv6地址池配置信息刷新时间86400秒，即24小时。
ipv6 address auto dhcp命
//使能接口通过DHCPv6协议自动获取IPv6地址及其他网络配置参数。
link-address
//在IPv6地址池视图下配置网络前缀。
lock
//锁定IPv6地址池。
nis-domain-name
//配置DHCPv6服务器为DHCPv6客户端分配的NIS域名后缀
nisp-domain-name
//配置DHCPv6服务器为DHCPv6客户端分配的NISP域名后缀。
prefix-delegation
//配置地址池视图下的代理前缀。
static-bind prefix
//在DHCPv6地址池下静态绑定地址前缀与DHCPv6 PD客户端。
import all
//使能设备向DHCPv6客户端动态分配DNS服务器和SNTP服务器配置信息的功能。
1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
20
21
22
23
24
25
26
27
28
29
30
31
32
33
34
35
36
37
38
39
40
41
42
43
44
45
46
47
48
49
50
51
52
53
54
55
56
57
58
59
60
61
62
63
64
65
66
67
68
69
70
71
72
73
74
75
76
77
78
79
80
81
82
83
84
85
86
87
DHCPv6服务器、中继配置示例
实验拓扑：



图：DHCPv6实验拓扑
实验要求：
在AR1为DHCPv6服务器，AR2为DHCP中继。通过配置，为主机分配IPv6地址。

配置文件：
AR1：

<DHCPv6>dis current-configuration 
#
 sysname DHCPv6
#
ipv6 
#
dhcp enable
#
dhcpv6 pool pool1
 address prefix 2000::/64
  //配置IPv6地址前缀
 excluded-address 2000::1
#
interface GigabitEthernet0/0/0
 ipv6 enable 
 ipv6 address 3000::1/64 
 dhcpv6 server pool1
#
ipv6 route-static :: 0 3000::2 
#
return
1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
20
21
AR2：

<Realy>dis current-configuration 
#
 sysname Realy
#
ipv6 
#
dhcp enable
#
interface GigabitEthernet0/0/0
 ipv6 enable 
 ipv6 address 3000::2/64 
#
interface GigabitEthernet0/0/1
 ipv6 enable 
 ipv6 address 2000::1/64 
 undo ipv6 nd ra halt
 //使能路由器向主机发送路由通告信息
 ipv6 nd autoconfig managed-address-flag
 //使M和O标志位置位。实现主机通过DHCPv6方式获取地址
 ipv6 nd autoconfig other-flag
 dhcpv6 relay destination 3000::1
 //指明DHCP服务器的地址
#
return
1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
20
21
22
23
24


图：DHCPv6服务器地址分配状况
