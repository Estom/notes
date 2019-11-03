# DHCP

> 参考文献
> * [DHCP基础](https://blog.csdn.net/qq_38265137/article/details/80404407)
> * 等到复习的时候过来整理这玩意。

DHCP简介
动态主机配置协议DHCP（Dynamic Host Configuration Protocol）是一种用于集中对用户IP地址进行动态管理和配置的技术。

DHCP采用客户端/服务器通信模式，由客户端（DHCP Client）向服务器（DHCP Server）提出配置申请，服务器返回为客户端分配的配置信息（包括IP地址、缺省网关、DNS Server、WINS Server等参数），可以实现IP地址动态分配，以及其他网络参数的集中配置管理。

DHCP的发展：
DHCP是在BOOTP（BOOTstrap Protocol）基础上发展而来，但BOOTP运行在相对静态（每台主机都有固定的网络连接）的环境中，管理员为每台主机配置专门的BOOTP参数文件，该文件会在相当长的时间内保持不变。DHCP从以下两方面对BOOTP进行了扩展：

DHCP加入了对重新使用的网络地址的动态分配和附加配置选项的功能，可使计算机仅用一个消息就获取它所需要的所有配置信息。
DHCP允许计算机动态地获取IP地址，而不是静态为每台主机指定地址。
DHCP技术实现用户地址和配置信息的动态分配和集中管理，使企业可以动态地为企业用户分配和管理地址，避免繁琐的手工配置，可以快速适应网络的变化。

DHCP原理描述
DHCP角色：
DHCP客户端：通过DHCP协议请求获取IP地址等网络参数的设备。例如，IP电话、PC、手机、无盘工作站等。
DHCP服务器：负责为DHCP客户端分配网络参数的设备。
（可选）DHCP中继：负责转发DHCP服务器和DHCP客户端之间的DHCP报文，协助DHCP服务器向DHCP客户端动态分配网络参数的设备。
DHCP客户端广播发送请求报文（即目的IP地址为255.255.255.255），位于同一网段内的DHCP服务器能够接收请求报文。如果DHCP客户端和DHCP服务器不在同一个网段，DHCP服务器无法接收来自客户端的请求报文，此时，需要通过DHCP中继来转发DHCP报文。不同于传统的IP报文转发，DHCP中继接收到DHCP请求或应答报文后，会重新修改报文格式并生成一个新的DHCP报文再进行转发。

在企业网络中，如果需要规划较多网段，且网段中的终端都需要通过DHCP自动获取IP地址等网络参数时，可以部署DHCP中继。这样，不同网段的终端可以共用一个DHCP服务器，节省了服务器资源，方便统一管理。

DHCP报文是基于UDP协议传输的。DHCP客户端向DHCP服务器发送报文时采用67端口号，DHCP服务器向DHCP客户端发送报文时采用68端口号。

DHCP服务器给首次接入网络的客户端分配网络参数的工作原理：
无中继场景时DHCP客户端首次接入网络的工作原理：


图：无中继场景DHCP客户端首次接入网络的报文交互示意图
发现阶段，即DHCP客户端发现DHCP服务器的阶段。

DHCP客户端发送DHCP DISCOVER报文来发现DHCP服务器。由于DHCP客户端不知道DHCP服务器的IP地址，所以DHCP客户端以广播方式发送DHCP DISCOVER报文（目的IP地址为255.255.255.255），同一网段内所有DHCP服务器或中继都能收到此报文。DHCP DISCOVER报文中携带了客户端的MAC地址（DHCP DISCOVER报文中的chaddr字段）、需要请求的参数列表选项（Option55中填充的内容，标识了客户端需要从服务器获取的网络配置参数）、广播标志位（DHCP DISCOVER报文中的flags字段，表示客户端请求服务器以单播或广播形式发送响应报文）等信息。

DHCP DISCOVER报文中的Option字段定义了网络参数信息，不同Option值代表了不同的参数。例如，Option3表示客户端的网关地址选项（当客户端发送的DHCP DISCOVER报文的Option55中填充了选项值3，就表示客户端希望从服务器获取网关地址）；Option53表示DHCP报文类型（例如，DHCP DISCOVER报文）。Option选项分为知名选项和自定义选项，关于知名选项的含义请参见RFC2132。除了RFC2132里面定义的知名选项，不同厂商可以根据需求自己定义自定义选项，例如，Option43为厂商特定信息选项。
RFC2131中定义了DHCP报文的广播标志字段（flags），当标志字段的最高位为0时，表示客户端希望服务器以单播方式发送DHCP OFFER/DHCP ACK报文；当标志字段的最高位为1时，表示客户端希望服务器以广播方式发送DHCP OFFER/DHCP ACK报文。Huawei AR100&AR120&AR150&AR160&AR200&AR1200&AR2200&AR3200&AR3600系列作为客户端时，此字段为1。
提供阶段，即DHCP服务器提供网络配置信息的阶段。

位于同一网段的DHCP服务器都会接收到DHCP DISCOVER报文，每个DHCP服务器上可能会部署多个地址池，服务器通过地址池来管理可供分配的IP地址等网络参数。服务器接收到DHCP DISCOVER报文后，选择跟接收DHCP DISCOVER报文接口的IP地址处于同一网段的地址池，并且从中选择一个可用的IP地址，然后通过DHCP OFFER报文发送给DHCP客户端。DHCP OFFER报文里面携带了希望分配给指定MAC地址客户端的IP地址（DHCP报文中的yiaddr字段）及其租期等配置参数。

通常，DHCP服务器的地址池中会指定IP地址的租期，如果DHCP客户端发送的DHCP DISCOVER报文中携带了期望租期，服务器会将客户端请求的期望租期与其指定的租期进行比较，选择其中时间较短的租期分配给客户端。

DHCP服务器上已配置的与客户端MAC地址静态绑定的IP地址。
客户端发送的DHCP DISCOVER报文中Option50字段（请求IP地址选项）指定的地址。
DHCP服务器上记录的曾经分配给客户端的IP地址。
按照IP地址从大到小的顺序查询，选择最先找到的可供分配的IP地址。
如果未找到可供分配的IP地址，则依次查询超过租期、处于冲突状态的IP地址，如果找到可用的IP地址，则进行分配；否则，发送DHCP NAK报文作为应答，通知DHCP客户端无法分配IP地址。DHCP客户端需要重新发送DHCP DISCOVER报文来申请IP地址。
为了防止分配出去的IP地址跟网络中其他客户端的IP地址冲突，DHCP服务器在发送DHCP OFFER报文前可以通过发送源地址和目的地址都为预分配出去IP地址的ICMP ECHO REQUEST报文对分配的IP地址进行地址冲突探测。如果在指定的时间内没有收到应答报文，表示网络中没有客户端使用这个IP地址，可以分配给客户端；如果指定时间内收到应答报文，表示网络中已经存在使用此IP地址的客户端，则把此地址列为冲突地址，然后等待重新接收到DHCP DISCOVER报文后按照前面介绍的选择IP地址的优先顺序重新选择可用的IP地址。

此阶段DHCP服务器分配给客户端的IP地址不一定是最终确定使用的IP地址，因为DHCP OFFER报文发送给客户端等待16秒后如果没有收到客户端的响应，此地址就可以继续分配给其他客户端。通过下面的选择阶段和确认阶段后才能最终确定客户端可以使用的IP地址。

选择阶段，即DHCP客户端选择IP地址的阶段。

因为DHCP DISCOVER报文是广播发送的，所以如果同一网段内存在多个DHCP服务器，接收到DHCP DISCOVER报文的服务器都会回应DHCP OFFER报文。如果有多个DHCP服务器向DHCP客户端回应DHCP OFFER报文，则DHCP客户端一般只接收第一个收到的DHCP OFFER报文，然后以广播方式发送DHCP REQUEST报文，该报文中包含客户端想选择的DHCP服务器标识符（即Option54）和客户端IP地址（即Option50，填充了接收的DHCP OFFER报文中yiaddr字段的IP地址）。

以广播方式发送DHCP REQUEST报文，是为了通知所有的DHCP服务器，它将选择某个DHCP服务器提供的IP地址，其他DHCP服务器可以重新将曾经分配给客户端的IP地址分配给其他客户端。

确认阶段，即DHCP服务器确认所分配IP地址的阶段。

当DHCP服务器收到DHCP客户端发送的DHCP REQUEST报文后，DHCP服务器回应DHCP ACK报文，表示DHCP REQUEST报文中请求的IP地址（Opton50填充的）分配给客户端使用。

DHCP客户端收到DHCP ACK报文，会广播发送免费ARP报文，探测本网段是否有其他终端使用服务器分配的IP地址，如果在指定时间内没有收到回应，表示客户端可以使用此地址。如果收到了回应，说明有其他终端使用了此地址，客户端会向服务器发送DECLINE报文，并重新向服务器请求IP地址，同时，服务器会将此地址列为冲突地址。当服务器没有空闲地址可分配时，再选择冲突地址进行分配，尽量减少分配出去的地址冲突。

当DHCP服务器收到DHCP客户端发送的DHCP REQUEST报文后，如果DHCP服务器由于某些原因（例如协商出错或者由于发送REQUEST过慢导致服务器已经把此地址分配给其他客户端）无法分配DHCP REQUEST报文中Opton50填充的IP地址，则发送DHCP NAK报文作为应答，通知DHCP客户端无法分配此IP地址。DHCP客户端需要重新发送DHCP DISCOVER报文来申请新的IP地址。

有中继场景时DHCP客户端首次接入网络的工作原理：


图：有中继场景时DHCP客户端首次接入网络的工作原理
发现阶段

检查DHCP报文中的hops字段，如果大于16，则丢弃DHCP报文；否则，将hops字段加1（表明经过一次DHCP中继），并继续下面的操作。

DHCP报文中的hops字段表示DHCP报文经过的DHCP中继的数目，该字段由客户端或服务器设置为0，每经过一个DHCP中继时，该字段加1。hops字段的作用是限制DHCP报文所经过的DHCP中继的数目。目前，设备最多支持DHCP客户端与服务器之间有存在16个中继。

检查DHCP报文中的giaddr字段。如果是0，将giaddr字段设置为接收DHCP DISCOVER报文的接口IP地址。如果不是0，则不修改该字段，继续下面的操作。

DHCP报文中的giaddr字段标识客户端网关的IP地址。如果服务器和客户端不在同一个网段且中间存在多个DHCP中继，当客户端发出DHCP请求时，第一个DHCP中继会把自己的IP地址填入此字段，后面的DHCP中继不修改此字段内容，DHCP服务器会根据此字段来判断出客户端所在的网段地址，从而为客户端分配该网段的IP地址。

将DHCP报文的目的IP地址改为DHCP服务器或下一跳中继的IP地址，源地址改为中继连接客户端的接口地址，通过路由转发将DHCP报文单播发送到DHCP服务器或下一跳中继。

如果DHCP客户端与DHCP服务器之间存在多个DHCP中继，后面的中继接收到DHCP DISCOVER报文的处理流程同前面所述。

提供阶段

DHCP服务器接收到DHCP DISCOVER报文后，选择与报文中giaddr字段为同一网段的地址池，并为客户端分配IP地址等参数然后向giaddr字段标识的DHCP中继单播发送DHCP OFFER报文。

检查报文中的giaddr字段，如果不是接口的地址，则丢弃该报文；否则，继续下面的操作。
DHCP中继检查报文的广播标志位。如果广播标志位为1，则将DHCP OFFER报文广播发送给DHCP客户端；否则将DHCP OFFER报文单播发送给DHCP客户端。
选择阶段

确认阶段

选择阶段和确认阶段的过程同无中继场景。

DHCP客户端重用曾经使用的地址的工作原理：
DHCP客户端非首次接入网络时，可以重用曾经使用过的地址。



图：DHCP客户端重用曾经使用过的IP地址的报文交互过程
客户端广播发送包含前一次分配的IP地址的DHCP REQUEST报文，报文中的Option50（请求的IP地址选项）字段填入曾经使用过的IP地址。
DHCP服务器收到DHCP REQUEST报文后，根据DHCP REQUEST报文中携带的MAC地址来查找有没有相应的租约记录，如果有则返回DHCP ACK报文，通知DHCP客户端可以继续使用这个IP地址。否则，保持沉默，等待客户端重新发送DHCP DISCOVER报文请求新的IP地址。
DHCP客户端更新租期的工作原理：
DHCP服务器采用动态分配机制给客户端分配IP地址时，分配出去的IP地址有租期限制。DHCP客户端向服务器申请地址时可以携带期望租期，服务器在分配租期时把客户端期望租期和地址池中租期配置比较，分配其中一个较短的租期给客户端。租期时间到后服务器会收回该IP地址，收回的IP地址可以继续分配给其他客户端使用。这种机制可以提高IP地址的利用率，避免客户端下线后IP地址继续被占用。如果DHCP客户端希望继续使用该地址，需要更新IP地址的租期（如延长IP地址租期）。

当租期达到50%（T1）时，DHCP客户端会自动以单播的方式向DHCP服务器发送DHCP REQUEST报文，请求更新IP地址租期。如果收到DHCP服务器回应的DHCP ACK报文，则租期更新成功（即租期从0开始计算）；如果收到DHCP NAK报文，则重新发送DHCP DISCOVER报文请求新的IP地址。
当租期达到87.5%（T2）时，如果仍未收到DHCP服务器的应答，DHCP客户端会自动以广播的方式向DHCP服务器发送DHCP REQUEST报文，请求更新IP地址租期。如果收到DHCP服务器回应的DHCP ACK报文，则租期更新成功（即租期从0开始计算）；如果收到DHCP NAK报文，则重新发送DHCP DISCOVER报文请求新的IP地址。
如果租期时间到时都没有收到服务器的回应，客户端停止使用此IP地址，重新发送DHCP DISCOVER报文请求新的IP地址。
客户端在租期时间到之前，如果用户不想使用分配的IP地址（例如客户端网络位置需要变更），会触发DHCP客户端向DHCP服务器发送DHCP RELEASE报文，通知DHCP服务器释放IP地址的租期。DHCP服务器会保留这个DHCP客户端的配置信息，将IP地址列为曾经分配过的IP地址中，以便后续重新分配给该客户端或其他客户端。

客户端可以通过发送DHCP INFORM报文向服务器请求更新配置信息。

DHCP报文：
DHCP报文类型：
DHCP Discover

由客户端来查找可用的服务器。

DHCP offer

服务器用来响应客户端的DHCP Discover报文，并指定相应的配置参数。

DHCP Resquet

由客户端发送给服务器来请求配置参数或者请求配置确认或者续借租期。

DHCP ACK

由服务器到客户端，含有配置参数包括IP地址。

DHCP Decline

当客户端发现地址已经被使用时，用来通知服务器。

DHCP Inform

客户端已经有IP地址时用它来向服务器请求其他的配置参数。

DHCP NAK

由服务器发送给客户端来报名客户端的地址请求不正确或者租期已过期。

DHCP Release

客户端要释放地址时用来通知服务器。

DHCP报文是承载于UDP上的高层协议报文，采用67（DHCP服务器）和68（DHCP客户端）两个端口号。

DHCP的报文格式如下图所示。

DHCP报文格式：


图：DHCP报文格式
报文字段解释：
字段	长度	含义
OP （op code）	1字节	表示报文的类型：1：客户端请求报文2：服务器响应报文
htype （hardware type）	1字节	表示硬件地址的类型。对于以太网，该类型的值为“1”。
hlen （hardware type）	1字节	表示硬件地址的长度，单位是字节。对于以太网，该值为6。
Hops	1字节	表示当前的DHCP报文经过的DHCP中继的数目。该字段由客户端或服务器设置为0，每经过一个DHCP中继时，该字段加1。此字段的作用是限制DHCP报文所经过的DHCP中继数目。
xid	4字节	事务ID，由客户端选择的一个随机数，被服务器和客户端用来在它们之间交流请求和响应，客户端用它对请求和应答进行匹配。该ID由客户端设置并由服务器返回，为32位整数。
secs (seconds)	2字节	由客户端填充，表示从客户端开始获得IP地址或IP地址续借后所使用了的秒数。
flags	2字节	此字段在BOOTP中保留未用，在DHCP中表示标志字段。只有标志字段的最高位才有意义，其余的位均被置为0。最左边的字段被解释为广播响应标志位，内容如下所示：0：客户端请求服务器以单播形式发送响应报文1：客户端请求服务器以广播形式发送响应报文
ciaddr (client ip address)	4字节	表示客户端的IP地址。可以是服务器分配给客户端的IP地址或者客户端已有的IP地址。客户端在初始化状态时没有IP地址，此字段为0.0.0.0。IP地址0.0.0.0仅在采用DHCP方式的系统启动时允许本主机利用它进行临时的通信，不是有效目的地址。
yiaddr (your client ip address)	4字节	表示服务器分配给客户端的IP地址。当服务器进行DHCP响应时，将分配给客户端的IP地址填入此字段。
siaddr (server ip address)	4字节	DHCP客户端获得启动配置信息的服务器的IP地址。
giaddr （gateway ip address）	4字节	该字段表示第一个DHCP中继的IP地址（注意：不是地址池中定义的网关）。当客户端发出DHCP请求时，如果服务器和客户端不在同一个网络中，那么第一个DHCP中继在转发这个DHCP请求报文时会把自己的IP地址填入此字段。服务器会根据此字段来判断出网段地址，从而选择为用户分配地址的地址池。服务器还会根据此地址将响应报文发送给此DHCP中继，再由DHCP中继将此报文转发给客户端。若在到达DHCP服务器前经过了不止一个DHCP中继，那么第一个DHCP中继后的中继不会改变此字段，只是把Hops的数目加1。
chaddr (client hardware address)	16字节	该字段表示客户端的MAC地址，此字段与前面的“Hardware Type”和“Hardware Length”保持一致。当客户端发出DHCP请求时，将自己的硬件地址填入此字段。对于以太网，当“Hardware Type”和“Hardware Length”分别为“1”和“6”时，此字段必须填入6字节的以太网MAC地址。
sname (server host name)	64字节	该字段表示客户端获取配置信息的服务器名字。此字段由DHCP Server填写，是可选的。如果填写，必须是一个以0结尾的字符串。
file (file name)	128字节	该字段表示客户端的启动配置文件名。此字段由DHCP Server填写，是可选的，如果填写，必须是一个以0结尾的字符串。
options	可变	该字段表示DHCP的选项字段，至少为312字节，格式为"代码+长度+数据"。DHCP通过此字段包含了服务器分配给终端的配置信息，如网关IP地址，DNS服务器的IP地址，客户端可以使用IP地址的有效租期等信息。
DHCP报文抓包示例：


图：DHCP报文抓包示例
DHCP Opthion字段选项：
DHCP报文中的Options字段可以用来存放普通协议中没有定义的控制信息和参数。如果用户在DHCP服务器端配置了Options字段，DHCP客户端在申请IP地址的时候，会通过服务器端回应的DHCP报文获得Options字段中的配置信息。

Options字段由Type、Length和Value三部分组成。这三部分的表示含义如下所示：

字段	长度	含义
Type	1字节	该字段表示信息类型。
Length	1字节	该字段表示后面信息内容的长度。
Value	其长度为Length字段所指定	该字段表示信息内容。
DHCP Options选项的取值范围为1～255。

Options号	Options作用
1	设置子网掩码选项。
3	设置网关地址选项。
6	设置DNS服务器地址选项。
12	设置DHCP客户端的主机名选项。
15	设置域名后缀选项。
33	设置静态路由选项。该选项中包含一组有分类静态路由（即目的地址的掩码固定为自然掩码，不能划分子网），客户端收到该选项后，将在路由表中添加这些静态路由。如果存在Option121，则忽略该选项。
44	设置NetBios服务器选项。
46	设置NetBios节点类型选项。
50	设置请求IP地址选项。
51	设置IP地址租约时间选项。
52	设置Option附加选项。
53	设置DHCP消息类型。
54	设置服务器标识。
55	设置请求参数列表选项。客户端利用该选项指明需要从服务器获取哪些网络配置参数。该选项内容为客户端请求的参数对应的选项值。
58	设置续约T1时间，一般是租期时间的50%。
59	设置续约T2时间。一般是租期时间的87.5%。
60	设置厂商分类信息选项，用于标识DHCP客户端的类型和配置。
61	设置客户端标识选项。
66	设置TFTP服务器名选项，用来指定为客户端分配的TFTP服务器的域名。
67	设置启动文件名选项，用来指定为客户端分配的启动文件名。
77	设置用户类型标识。
121	设置无分类路由选项。该选项中包含一组无分类静态路由（即目的地址的掩码为任意值，可以通过掩码来划分子网），客户端收到该选项后，将在路由表中添加这些静态路由。
根据Options选项功能的不同，此字段的作用对象也不同。比如Option77用于DHCP客户端，用于识别用户所属的类型，根据Options字段中所携带的用户类型（User Class），DHCP服务器选择适当的地址池为客户端分配IP地址以及相关配置参数。Option77一般在客户端由用户进行配置，而不必在服务器端配置。

自定义DHCP选项：
除了RFC2132中规定的字段选项外，还有部分选项内容没有统一规定，例如Option82。

Option82称为中继代理信息选项，该选项记录了DHCP客户端的位置信息。DHCP中继或DHCP Snooping设备接收到DHCP客户端发送给DHCP服务器的请求报文后，在该报文中添加Option82，并转发给DHCP服务器。

**管理员可以从Option82中获得DHCP客户端的位置信息，以便定位DHCP客户端，实现对客户端的安全和计费等控制。**支持Option82的服务器还可以根据该选项的信息制定IP地址和其他参数的分配策略，提供更加灵活的地址分配方案。

Option82最多可以包含255个子选项。若定义了Option82，则至少要定义一个子选项。目前设备只支持两个子选项：sub-option1（Circuit ID，电路ID子选项）和sub-option2（Remote ID，远程ID子选项）。

由于Option82的内容没有统一规定，不同厂商通常根据需要进行填充。

DHCP的Option82原理：
DHCP Relay Agent插入到用户的DHCP报文，DHCP服务器通过识别Option82来执行IP地址分配策略或其他策略。
DHCP服务器的响应报文也带Option82，Relay Agent将Option82剥离后发给用户。
Agent Information Fied中包含多个子选项，每个子选项格式为iSubOpt/Length/Value三元组。
使能Option82功能，可以根据Option82信息建立精确到接口的绑定表。

DHCP服务器如果存在多个地址池，如何判断应该分配哪个地址池的地址？
如果discovery报文中gateway ip address （relay agent address）被填充地址，则分配该IP地址所在网段的地址。
如果discovery报文中gateway ip address 为空，则分配discovery报文接收端口所在IP网段的地址。
unr：Uer Nerwork Router，用户网络路由。由DHCP服务器通告给客户端的静态路由。

DHCP配置
配置为客户端分配IP地址：
创建地址池：
基于接口方式的地址池：在DHCP Server与Client相连的接口上配置IP地址，地址池是跟此接口地址所属同一网段的IP地址，且地址池中地址只能分配给此接口下的Client。这种配置方式简单，仅适用于DHCP Server与Client在同一个网段，即不存在中继的场景。例如，设备做DHCP Server仅给一个接口下的Client分配IP地址或者给多个接口下的Client分别分配不同网段的IP地址。
基于全局方式的地址池：在系统视图下创建指定网段的地址池，且地址池中地址可以分配给设备所有接口下的Client。这种配置方式适用于：
DHCP Server与Client在不同网段，即存在中继的场景。
DHCP Server与Client在同一网段，且需要给一个接口下的Client分配IP地址或者给多个接口下的Client分别分配IP地址。
DHCP基于接口配置：
如下图，AR1为DHCP服务器，接口配置地址为192.168.0.1/24.给接口下所连接的设备主机分配IP地址。



图：DHCP基于接口配置拓扑
配置文件：
DHCP服务器配置：

<DHCP>dis current-configuration 
#
 sysname DHCP
#
dhcp enable //使能DHCP功能
#
interface GigabitEthernet0/0/0
 ip address 192.168.0.1 255.255.255.0 
 dhcp check dhcp-rate enable 
 //使能DHCP报文速率检查功能。
 dhcp check dhcp-rate 90
 //配置DHCP报文上送到DHCP协议栈的检查速率。
 dhcp alarm dhcp-rate enable
 //使能DHCP报文速率告警功能。
 dhcp alarm dhcp-rate threshold 500
 //配置DHCP报文速率检查告警阈值。
 dhcp select interface
 //开启接口采用接口地址池的DHCP Server功能。
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
AR3作为DHCP客户端配置：

<AR2>dis current-configuration 
 sysname AR2
#
dhcp enable //使能DHCP功能
#
interface GigabitEthernet0/0/0
 dhcp client default-route preference 100
 //配置DHCP服务器下发给DHCP客户端的路由表项优先级。
 dhcp client gateway-detect period 3600 retransmit 3 timeout 500
 //来配置DHCP Client网关探测功能。
 dhcp client expected-lease 3600
 //配置DHCP Client期望租期功能。
 dhcp client class-id huawei
//配置设备作为DHCP客户端时，发送DHCP请求报文中的Option60字段。
 dhcp client hostname DHCPClient
 //配置DHCP客户的主机名
 ip address dhcp-alloc
 //配置ip地址获取方式为通过DHCP获取
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
dhcp client gateway-detect period 3600 retransmit 3 timeout 500
参数	参数说明	取值
period period	指定DHCP Client网关探测周期。	整数形式，取值范围是1～86400。单位是秒。
retransmit retransmit	指定DHCP Client网关探测重传次数。	整数形式，取值范围是1～10。
timeout time	指定DHCP Client网关探测超时时间。	整数形式，取值范围是300～2000。单位是毫秒。
应用场景

此命令应用于DHCP客户端。当DHCP Client成功获取IP地址后，该功能可以使DHCP Client迅速检测正在使用的网关状态，如果网关地址错误或网关设备故障，DHCP Client将向DHCP Server重新发送IP地址请求。

注意事项

DHCP Client网关探测功能适用于双上行链路场景。

dhcp client class-id
DHCP服务器需要根据请求报文中的Option60字段内容来区分不同设备，用户可以使用此命令自定义设备作为DHCP客户端时，发送的请求报文中封装的Option60内容。

接口下配置此命令后，设备作为DHCP客户端时，从该接口发送的DHCP请求报文中将使用配置的内容填充Option60字段。

dhcp client client-id
该命令用来配置DHCP客户端的标识，该标识将会封装在DHCP请求报文中与服务器进行交互。DHCP客户端在申请IP地址的时候，DHCP服务器会获取请求报文中的DHCP客户端标识信息，DHCP服务器将根据该标识，为DHCP客户端分配IP地址。

DHCP基于全局配置：
如下图，路由器AR1为DHCP服务器，为不同VLAN的主机分配不同网段的IP地址，同时，为了节约IP地址，使用了聚合VLAN。



基于全局的配置文件：
AR1DHCP服务器的配置文件：

<DHCP>dis current-configuration 
#
 sysname DHCP
#
dhcp enable
#
dhcp snooping enable
#
ip pool VLAN100
 gateway-list 10.0.10.254 
 network 10.0.10.0 mask 255.255.255.0 
 excluded-ip-address 10.0.10.1 
 lease day 1 hour 23 minute 30 
 dns-list 114.114.114.144 8.8.8.8 
 domain-name VLAN100
#
ip pool VLAN200 //配置VLAN200地址池
 gateway-list 10.0.20.254  
 network 10.0.20.0 mask 255.255.255.0 
 excluded-ip-address 10.0.20.1 
 dns-list 10.0.20.254 
 domain-name VLAN200
#
ip pool VLAN300
 gateway-list 10.0.30.1 10.0.30.254 
 network 10.0.30.0 mask 255.255.255.0 
 dns-list 10.0.30.254 8.8.8.8 
 domain-name VLAN300
#
interface GigabitEthernet0/0/0
 ip address 10.0.0.1 255.255.255.0 
 dhcp select global 
 //开启接口采用全局地址池的DHCP Server功能。
#
//配置去往DHCP中继不同网段的路由
ip route-static 10.0.10.0 255.255.255.0 10.0.0.2
ip route-static 10.0.20.0 255.255.255.0 10.0.0.2
ip route-static 10.0.30.0 255.255.255.0 10.0.0.2
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


图：DHCP服务器分配情况
SW1作为DHCP中继的配置：

[SW]dis current-configuration 
#
sysname SW
#
vlan batch 10 to 11 20 to 21 30 to 31 100 200 300 
//批量创建VLAN
#
dhcp enable//使能DHCP功能 
#
dhcp snooping enable //使能DHCP Snooping功能
#
//在每个VLAN下都开启DHCP Snooping功能
vlan 1
 dhcp snooping enable
vlan 10
 dhcp snooping enable
vlan 11
 dhcp snooping enable
vlan 20
 dhcp snooping enable
vlan 21
 dhcp snooping enable
vlan 30
 dhcp snooping enable
vlan 31
 dhcp snooping enable
vlan 100 //聚合VLAN
 aggregate-vlan 
 access-vlan 10 to 11
vlan 200 //聚合VLAN
 aggregate-vlan
 access-vlan 20 to 21
vlan 300 //聚合VLAN
 aggregate-vlan
 access-vlan 30 to 31
#
interface Vlanif1 
 ip address 10.0.0.2 255.255.255.0
 //配置与DHCP服务器直通的路由
#
interface Vlanif100
 ip address 10.0.10.254 255.255.255.0
 dhcp select relay //开启DHCP 中继
 dhcp relay server-ip 10.0.0.1
 //DHCP服务器IP地址
#
interface Vlanif200
 ip address 10.0.20.254 255.255.255.0
 dhcp select relay
 dhcp relay server-ip 10.0.0.1
#
interface Vlanif300
 ip address 10.0.30.254 255.255.255.0
 dhcp select relay
 dhcp relay server-ip 10.0.0.1
#
interface GigabitEthernet0/0/1
 port link-type trunk
 dhcp snooping trusted 
 //配置接口为信任状态。
#
interface GigabitEthernet0/0/2
 port link-type trunk
 port trunk allow-pass vlan 10 to 11
#
interface GigabitEthernet0/0/3
 port link-type trunk
 port trunk allow-pass vlan 20 to 21
#
interface GigabitEthernet0/0/4
 port link-type trunk
 port trunk allow-pass vlan 30 to 31
#
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


图：DHCP中继情况
SW2配置文件：SW3,4与之类似。

<SW2>dis current-configuration 
#
sysname SW2
#
vlan batch 10 to 11
#
dhcp enable
#
dhcp snooping enable
#
interface GigabitEthernet0/0/1
 port link-type trunk
 port trunk allow-pass vlan 2 to 4094
 dhcp snooping enable
 dhcp snooping trusted
#
interface GigabitEthernet0/0/2
 port link-type access
 port default vlan 10
#
interface GigabitEthernet0/0/3
 port link-type access
 port default vlan 11
#
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
