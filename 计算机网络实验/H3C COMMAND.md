# H3C命令行

> 基于视图的命令行。

## 1 入门实验

### 视图结构图树
* user
* system
    * interface
    * ospf
      * ospf-area
    * vlan
      * vlan-interface

### 视图切换命令

```
system-view //进入系统视图

interface Ethernet1/0/1 //进入以太网接口视图
ospf processid //进入ospf视图
vlan 2 //创建VLAN2，并进入VLAN视图

area 2 //ospf视图下创建并进入 area视图

quit //退出当前视图到上一个视图
```

### 用户视图

```
display * //显示各种配置视图
display current-configguration
display version
display interface Ethernet1/0/1
display clock

? //查看该视图下的命令

debuging //调试命令

reset //重置或清除相关配置
reset saved-configuration//重置到出厂设置
reset arp //重置arp设置
reset ospf process //重置ospf进程，并重启进程

save //用来保存道歉的配置信息

reboot //重启
```

### 以太网端口视图

```
[system]interface Ethernet0/1
[Ethernet]
# ip协议相关命令
[Ethernet]ip address ip-address mask[sub]
[Ethernet]undo ip address [ip-address mask][sub]

# MTU
[Ethernet]mtu 100
[Ethernet]undo mtu

# speed
[Ethernet]speed [100|10|negotiation] //100M,10M,自动协商

# display
[system]display interfaces ethernet number

# 打开关闭以太网端口
[Ethernet]shutdown
[Ethernet]undo shutdown

# 端口工作模式
[Ethernet]duplex full //设置全双工状态
[Ethernet]undo duplex //回复以太网全双工状态

# 端口类型
[Ethernet]spreed [10|100|auto]

# 接口类型
[Ethernet]mdi [across|auto|normal] //设置接口网线类型

# 流量控制
[Ethernet]flow-control //流量控制
[Ethernet]undo flow-control //解除流量控制

# 链路类型
[Ethernet]port link-type [acces|hybrid|trunk] //设置接口链路类型
[Ethernet]undo port link-type

# 显示接口信息
[Ethernet]display interface Ethernet1/0/1 
```

### NAT联网相关命令

```
# 访问控制列表access control list：acl
[R]acl number 2001 //设置访问控制号
[R-acl-2001]rule permit source 10.0.0.0 0.0.0.255//设置访问控制列表的规则内容
[R-acl-2001]rule deny source any//设置不可访问的内容：这里是其他所有的

# 设置nat地址转换,address group 规定了地址转换后的组
[R]nat address-group 1 192.168.5.105 192.168.5.109

# 在接口上绑定nat对外解析的地址池
[R-Ethernet0/1]nat outbound 2001 address-group 1

# 设置静态ip 路由地址，如果目的IP地址和掩码都为0.0.0.0（或掩码为0），则配置的路由为缺省路由。当检查路由表失败的时候，将使用缺省路由进行报文转发。
[R]ip route-static 0.0.0.0 0.0.0.0 192.168.5.1

```
## 2 链路层实验

### 端口聚合
```
# 设置一台网端口聚合
link-aggragation ethernet port_num1 to ethernet port_num2 {ingress|both}//设置聚合端口
undo link-aggregation {ethernet master_port_num |all}//删除聚合端口
display link-aggregation[ethernet master_port_num]


# 进入聚合端口
[S]interface Bridge-Aggregation 1//设置并进入端口聚合视图
[S-bridge-aggregation 1]link-aggeragation mode dynamic //设置端口聚合模式
[s-ethernet0/1]port link-aggregation group 1//加入端口聚合组
[s]link-aggeragation load-sharing mode destionation-mac source-mac //配置聚合组的分发方式


# 生成树协议
[S]stp enable
[S]stp disenable
```
### VLAN实验

```
# 创建删除vlan
[S]vlan vlan_id
[S]undo vlan vlan_id

# 向vlan中添加删除端口
[S-vlan2]port port_num to port_num
[S-vlan2]undo port port_num

# 指定端口类型
[S-Ethernet0/1]port link-type {access|trunk|hybrid}
[S-Ethernet0/1]undo port link-type trunk

# 指定删除pvid
[S-Ethernet]port trunk pvid vlan vlan_id
[S-Ethernet0/1]undo port trunk pvid vlan vlan_id

# 指定删除trunk的vlan
[S-Ethernet0/1]port trunk permit vlan{vlan_id_list | all}
[S-Ethernet0/1]undo port trunk permit {vlan_id_list}

# hybrid端口添加删除vlantag
[S-Ethernet]prot hybrid vlan vlan_id_list untagged|tagged

```
### 广域网协议-PPP

```
# 配置ppp链路协议
[R-serial1/0]link-protocol ppp

# 显示ppp的debugging信息
[user]debugging ppp all //打开debug开关
[user]termimal debugging//显示debug信息

# 设置ppp服务认证
[R]local-user RTB class network//配置用户列表
[R-luser-network-RTB]service-type ppp//配置服务类型
[R-luser-network-RTB]password simple aaa//配置用户密码
# 设置pap验证
[R-serial1/0]ppp authentication pap//授权pap认证
# 对端pap设置
[R-serial1/0]ppp pap local-user RTB password simple aaa

# 设置ppp服务
[R]local-user RTB class network//配置用户列表
[R-luser-network-RTB]service-type ppp//配置服务类型
[R-luser-network-RTB]password simple aaa//配置RTB用户密码
# 设置chap验证
[R-serial0/0]ppp authentication-mode chap//配置验证方式
[R-serial0/0]ppp chap user RTA//配置本地名称
# 对端对端路由器配置
[R]lcoal-user RTA class network
[R-luser-network]service-type ppp
[R-luser-network]password simple aaa//配置RTA密码
[R-serial0/0]ppp chap user RTB
```

## 3 网络层实验

### ARP分析
```
# 使用三层交换机的第三层。可以用开启VLAN的端口作为其三层协议驻留的端口。配置VLAN，开启第三层网络层服务。
[S-vlan2]inter vlan 2//进入vlan2的接口（虚拟接口）
[S-Vlan-interface2]ip address 192.168.1.10 255.255.255.0 //配置虚拟局域网VLAN的虚拟接口的IP地址。开放第三层服务。

```

### ICMP分析
```
# 网络设备出于安全性考虑对tracert命令不回复。避免称为攻击目标。实验中可以打开
[S]ip ttl-expires enable//打开ttl计数
[S]ip unreachables enable//打开ip
```

### IP 分析
```
# 显示路由表。
display ip routing-table
```

### 网络层分片实验
```
# 设置接口最大传输单元
[R-Ethernet0/0]mtu 100
```

### VLAN间通信
```
# 开启VLAN的三成转发
[S]inter vlan 2
[S-vlan-interface2]ip address 192.168.2.1 255.255.255.0


# 重置
[user]reset ospf all process
# 显示
[user]display ospf peer/brief/error/routing
# 调试
[user]debugging ospf event/lsa/packet/spf
```
## 4 OSPF协议实验

### OSPF状态显示
```
# display ospf命令的说明，下面是三个不同的表格。
[user]display ospf brief //显示基本配置信息
[user]display ospf peer //显示的是邻居信息，有几个邻居路由器
[user]display ospf routing //是路由信息，具体用来决定从哪个接口，寻找下一跳。通过lsdb与ospf算法计算而来。
[user]display ospf lsdb //是整个区域的链路拓扑结构，即通过lsa链路状态通告而来。
[user]display adjacent-table //显示邻接信息。
```
### OSPF基本配置
```
# ospf启动相关命令
[system]router id router-id //设置router id
[system]undo router id //删除router id

[system]ospf [process-id[router-id]] //创建并进入ospf视图
[system]undo ospf [process-id]关闭ospf视图

[ospf]area area-id //创建并进入ospf下area视图
[ospf]undo area area-id //删除ospf area

[area]network ip-address wildcard-mask //指定网段运行OSPF协议
[area]undo network ip-address wildcard-mask //取消网段运行OSPF协议
```
### ospf路由引入

* 直连路由：直连路由就是路由器直接连接的网段信息的路由，是链路层直接发现的路由，又不需要写网络号，掩码什么的信息，就是条死命令。import route direct引入
```
# ospf引入命令。import-route命令用来配置引入外部路由信息。undo import-route命令用来取消引入外部路由信息。
[ospf]import-route direct/static

[ospf]import-route protocol [ process-id | all-processes | allow-ibgp ] [ cost cost | type type | tag tag | route-policy route-policy-name ] *

[ospf]undo import-route protocol [ process-id | all-processes ]
```

### ospf自组织LSA
```
# 显示ospf的lsdb自组织成第一类router-lsa的内容。
[R]dis ospf lsdb router 
# ospf的lsdb自组织第二类network-lsa
[R]dis ospf lsdb network 
# ospf的lsdb自组织第三类第四类summary lsa
[R]dis ospf lsdb summary
# ospf的lsdb自组织第五类lsa
[R]dis ospf lsdb ase 
```
## 5 BGP实验
### BGP 基本分析
```
# 启动BGP进程
bgp 100 //启动bgp指定as号
router-id 1.1.1.1 //配置BGP的router-id

# 配置BGP对等体：配置BGP对等体时，如果指定对等体所属的AS编号与本地AS编号相同，表示配置IBGP对等体。如果指定对等体所属的AS编号与本地AS编号不同，表示配置EBGP对等体。为了增强BGP连接的稳定性，推荐使用路由可达的Loopback接口地址建立BGP连接。
[BGP]peer 12.1.1.1 as-number 100 //创建BGP对等体
[BGP]peer 12.1.1.1 connet-interface lookback 0 //指定发送BGP报文的源接口，并可指定发起连接时使用的源地址。缺省情况下，BGP使用报文的出接口作为BGP报文的源接口。
[BGP]peer 12.1.1.1 ebgp-max-hop 2 //指定建立EBGP连接允许的最大跳数。 缺省情况下，EBGP连接允许的最大跳数为1，即只能在物理直连链路上建立EBGP连接。 
[BGP]peer peer 3.1.1.2 next-hop-local //强制下一跳地址为自身。用来配置IBGP。

# 配置BGP对等体组：（只能用来配置EBGP）
[BGP]group 1  [ external | internal ]//创建对等体组。
[BGP]peer 1 as-number 100//配置EBGP对等体组的AS号。 
[BGP]peer 12.1.1.2 group 1//向对等体组中加入对等体

# 配置BGP引入路由：BGP协议本身不发现路由，因此需要将其他路由（如IGP路由等）引入到BGP路由表中，从而将这些路由在AS之内和AS之间传播。BGP协议支持通过以下两种方式引入路由：

# Import方式：按协议类型，将RIP路由、OSPF路由、ISIS路由等协议的路由引入到BGP路由表中。为了保证引入的IGP路由的有效性，Import方式还可以引入静态路由和直连路由。

# Network方式：逐条将IP路由表中已经存在的路由引入到BGP路由表中，比Import方式更精确。

[BGP]import-router protocol //引入路由
[BGP]default-route imported//允许BGP引入本地IP路由表中已经存在的缺省路由。 
[BGP]network 1.1.1.1 mask //配置BGP逐条引入IPv4路由表或IPv6路由表中的路由。
```

### BGP状态转换分析
```
[user]debugging bgp event
[user]terminal debugging
[user]reset bgp all

[user]display bgp peer //可以显示bgp邻居信息，用来查看对等体是否已经建立。
[user]display bgp routing-table peer ip-address advertised-routes/received-routes //用来检查bgp通告的路由信息
[user]display bgp routing-table
```

### BGP路由聚合

```
[R]bgp 100
[R-bgp]aggregate 192.168.0.0 255.255.240.0 [detail-suppressed]//同网段路由聚合。当有detail-suppressed的时候只通告聚合路由。
[R-bgp]undo aggregate 192.168.0.0 255.255.240.0
```
### BGP路由属性

```
# 路由引入
import-route direct

```
### BGP的路由策略
```
# 访问控制列表
[R]acl number acl-number
[R-acl-number]rule rule-number permit|deny source-addr source-addr-mask | any//定义acl过滤规则
[R]peer 10.0.0.1 filter-policy acl-number {export|import}//应用acl访问控制列表

# 自制系统路径信息访问列表
ip as-path-acl as-path-acl-number {permit|deny} as-regular-expression//定义AS-path过滤规则
peer peer-address as-path-acl as-path-acl-number {import|export}//应用对等体的AS路径过滤器。

# 路由策略
route-policy policy-name {permit|deny}node node-number//定义route-policy路由策略过滤规则
peer peer-address route-policy policy-name {import|export}//应用对等体路由策略

if-match
apply//使用对等体路由策略

# 复位BGP
reset bgp all|peer-id
```

## 6 组播实验

### IGMP实验
```
接口上设置其他IGMP查询器的存活时间。
display igmp explicit-tracking
//查看使用Include模式加入特定源组的IGMPv3主机信息。
display igmp group
//查看通过主机发送报告报文动态加入的IGMP组播组信息。
display igmp group ssm-mapping
//查看根据SSM Mapping规则创建的组播组信息。
display igmp group static
//查看IGMP静态组播组的配置信息。
display igmp routing-table
//查看IGMP路由表信息。
display igmp ssm-mapping
//查看IGMP SSM Mapping的配置信息。
igmp
//进入IGMP视图。
igmp enable
//在接口上使能IGMP功能。
igmp global limit
//配置整个路由器上可以创建的所有IGMP表项的最大个数。
igmp group-policy
//在接口上设置IGMP组播组的过滤器，限制主机能够加入的组播组范围。
igmp ip-source-policy
//配置设备根据源地址对IGMP报告/离开报文进行过滤。
igmp lastmember-queryinterval interval
//在接口上配置IGMP查询器在收到主机发送的IGMP离开报文时，
//发送IGMP特定组\源组查询报文的时间间隔。
//缺省情况下，IGMP特定组\源组查询报文的发送时间间隔是1秒。
igmp max-response-time 10
//在接口上配置IGMP普遍组查询报文的最大响应时间。
//缺省情况下，IGMP普遍组查询报文的最大响应时间是10秒。
igmp on-demand
/*
  配置IGMP On-Demand功能.
  使查询器不主动发送查询报文，而是根据成员的要求来维护
  成员关系。配置IGMP On-Demand功能后，接口上动态加
  入的组播组永不超时。
*/
igmp prompt-leave
//在接口上配置组播组成员快速离开功能，
//即IGMP查询器在接收到成员主机发送的离开报文后不发送
//特定组查询报文，立即删除该组表项。
igmp proxy
//在接口上使能IGMP Proxy功能。
igmp proxy backup
//配置接口成为具有IGMP Proxy功能的备份接口。
igmp query ip-source-policy
//配置IGMP查询报文源地址过滤策略。
igmp send-router-alert
//在接口上配置发送的IGMP报文中包含Router-Alert选项。
igmp require-router-alert
//在接口上配置丢弃不包含Router-Alert选项的IGMP报文。
igmp robust-count 2
//在接口上设置IGMP查询器的健壮系数。
//缺省情况下，IGMP查询器的健壮系数是2。
igmp ssm-mapping enable
//在接口上使能SSM Mapping。
igmp static-group
//在接口上配置静态组播组。
igmp timer other-querier-present
//接口上设置其他IGMP查询器的存活时间。
//缺省时，其他IGMP查询器的存活时间的值为125秒。
//其他IGMP查询器的存活时间 ＝ 健壮系数 × IGMP普遍查询报文发送间隔 +（1/2）× 最大查询响应时间。
igmp timer query 60
//在接口上配置IGMP普遍组查询报文的发送间隔。
igmp version
//在接口上配置运行的IGMP版本。
lastmember-queryinterval 1
//配置IGMP查询器在收到主机发送的IGMP离开报文时，
//发送IGMP特定组\源组查询报文的时间间隔。
//缺省情况下，IGMP特定组\源组查询报文的发送时间间隔是1秒。
max-response-time 10
  //全局配置IGMP普遍组查询报文的最大响应时间。
 proxy source-lifetime 210
//配置Proxy设备上生成（S，G）表项的超时时间。
//缺省情况下，Proxy设备上生成（S，G）表项的超时时间是210秒。
require-router-alert
//配置丢弃不包含Router-Alert选项的IGMP报文。
reset igmp control-message counters
//清除IGMP报文统计数。
reset igmp explicit-tracking
//删除接口上通过IGMP动态加入组播组的主机。
robust-count 2
//设置IGMP查询器的健壮系数。
send-router-alert
//指定设备发送的IGMP报文中包含Router-Alert选项。
ssm-mapping
//配置SSM Mapping的源组映射规则。
timer other-querier-present
//设置其他IGMP查询器存活时间。
timer query 60
//全局配置IGMP普遍组查询报文的发送间隔。
```

### IGMP Snooping
```
igmp-snooping enable
//使能全局的IGMP Snooping功能。
//在VLAN内，也需要使能Igmp Snooping功能。
igmp-snooping group-limit
//指定接口能够学习的组播表项最大数目。
igmp-snooping lastmember-queryinterval 1
//配置VLAN内的最后成员查询时间间隔，即IGMP特定组查询报文发送时间间隔。
igmp-snooping learning
//使能动态成员端口学习功能。
//缺省情况下，动态成员端口学习功能处于使能状态。
igmp-snooping max-response-time 10
//在VLAN内配置IGMP普遍组查询的最大响应时间。
igmp-snooping prompt-leave
//配置允许VLAN内的成员端口快速离开组播组。
//成员端口快速离开是指当路由器收到主机发送的离开某个组
//播组的IGMP Leave报文后，不等待成员端口老化，将接口
//对应该组播组的转发表项直接删除，这样可以节约带宽和资源。
igmp-snooping querier enable
//使能VLAN的IGMP Snooping查询器功能。
igmp-snooping query-interval 60
//配置VLAN内的IGMP Snooping普遍组查询报文发送时间间隔。
igmp-snooping report-suppress
//配置在VLAN内对Report和Leave报文的抑制功能。
igmp-snooping router-aging-time 180
//配置VLAN内的动态路由器端口老化时间。
igmp-snooping router-learning
//使能VLAN的路由器端口动态学习功能。
igmp-snooping send-query enable
//配置设备响应二层拓扑变化向非路由器端口发送IGMP普遍组查询报文。
igmp-snooping send-query source-address
//配置IGMP普遍组查询报文的源IP地址。
//缺省情况下，IGMP普遍组查询报文的源IP地址为192.168.0.1。
igmp-snooping ssm-mapping enable
//使能VLAN内的SSM Mapping功能。
igmp-snooping static-router-port
//配置接口作为指定VLAN内的静态路由器端口。
igmp-snooping suppress-time 10
//配置VLAN内的IGMP报文抑制时间。
//缺省情况下，VLAN内IGMP报文抑制时间为10秒。
  igmp-snooping version
//来配置IGMP Snooping在VLAN内可以处理的IGMP报文的版本。
//缺省情况下，IGMP Snooping可以处理IGMPv1、IGMPv2版本的报文。
multicast drop-unknown
//配置将VLAN内收到的未知组播流丢弃。
//缺省情况下，收到未知组播流会在VLAN内广播。
```

### PIM

```
display pim grafts
//anycast-rp
//来配置Anycast RP，并进入Anycast-RP视图
auto-rp listening enable
//使能Auto-RP侦听功能，即路由器能够接收Auto-RP宣告和发现报文，从中学习RP信息。
bsm semantic fragmentation
//使能BSR报文分片功能。
bsr-policy
//限定合法BSR地址范围，使路由器丢弃来自该地址范围之外的自举报文，从而防止BSR欺骗。
c-bsr
//配置C-BSR。
c-bsr admin-scope
//使能路由器的BSR管理域功能。
c-bsr global
//配置路由器为Global域中的C-BSR。
c-bsr group
//配置C-BSR服务的管理域组地址范围。
c-bsr hash-length 30
//配置C-BSR的全局性哈希掩码长度。
c-bsr holdtime 130
//配置C-BSR等待接收BSR发送的Bootstrap报文的超时时间。
c-bsr interval 60
//来配置BSR发送Bootstrap报文的时间间隔。
c-bsr priority 0
//配置C-BSR的全局优先级。
c-rp
//配置路由器向BSR通告自己为候选RP。
c-rp advertisement-interval 60
//配置C-RP周期性发送Advertisement报文的时间间隔。
c-rp holdtime 150
//配置BSR等待接收该C-RP发送Advertisement报文的超时时间。
c-rp priority 0
//配置C-RP的全局性优先级。
crp-policy
//限定合法的C-RP地址范围及其服务的组播组地址范围，使
//BSR丢弃来自该地址范围之外的C-RP报文，从而防止C-RP欺骗。
display pim bsr-info
//查看PIM-SM域中BSR自举路由器的信息。
display pim claimed-route
//查看PIM使用的单播路由信息。
display pim grafts
//查看未确认的PIM-DM嫁接报文。
display pim interface
//查看接口上的PIM信息。
display pim neighbor
//查看PIM邻居信息。
display pim routing-table
//查看PIM协议组播路由表的内容。
display pim rp-info
//查看组播组对应的RP信息。
graceful-restart
//使能PIM GR功能。
graceful-restart period 120
//配置PIM GR的最小周期。
//缺省情况下，PIM GR最小周期为120秒。
hello-option dr-priority 1
//配置路由器竞选成为DR（Designated Router）的优先级。
hello-option holdtime 105
//配置路由器等待接收其PIM邻居发送Hello报文的超时时间。
//缺省情况下，路由器等待接收其PIM邻居发送Hello报文的超时时间是105秒。
hello-option lan-delay 500
//配置共享网段上传输Prune报文的延迟时间。
//缺省情况下，共享网段上传输Prune报文的延迟时间是500毫秒。
hello-option neighbor-tracking
//使能邻居跟踪功能。
hello-option override-interval 2500
//配置Hello报文中携带的否决剪枝的时间间隔。
//缺省情况下，Hello报文中携带的否决剪枝的时间间隔是2500毫秒。
holdtime assert 180
//配置路由器上所有PIM接口保持Assert状态的超时时间。
//缺省情况下，路由器上所有PIM接口保持Assert状态的超时时间是180秒。
holdtime join-prune 210
/*
  配置Join/Prune报文的保持时间。接收到Join/Prune报
  文的路由器依据该报文自身携带的保持时间来确定对应下游
  接口保持加入或剪枝状态的时间。
  缺省情况下，Join/Prune报文的保持时间是210秒。
*/
join-prune max-packet-length 8100
//配置PIM-SM发送的Join/Prune报文的最大长度。
join-prune periodic-messages queue-size 1020
//配置PIM-SM每秒发送周期性Join/Prune报文中包含的表项数目。
join-prune triggered-message-cache disable
//配置去使能实时触发的Join/Prune报文打包功能。
local-address
//配置Anycast RP本地地址。
neighbor-check
//使能PIM邻居检查功能。
peer 10.2.2.2 fwd-msdp-sa
//配置Anycast RP对等体。
//fwd-msdp-sa:指定将收到的MSDP SA报文提取源组信息
//后封装成注册报文向Anycast RP对等体转发。
pim bfd
//调整接口上的PIM BFD参数。
pim bfd enable
//在接口上使能PIM BFD功能。
pim bsr-boundary
//在接口上配置PIM-SM域的BSR边界。
pim dm
//在接口上使能PIM-DM。
pim hello-option dr-priority
//配置PIM接口竞选成为DR的优先级。
pim hello-option holdtime 105
//配置PIM接口等待接收PIM邻居发送Hello报文的超时时间。
 pim holdtime assert180
 //配置PIM接口保持Assert状态的超时时间。
 pim neighbor-policy
 //用来过滤接口上的PIM邻居。
 pim require-genid
 //配置PIM接口拒绝无Generation ID参数的Hello报文。
 //缺省情况下，PIM接口接收无Generation ID参数的Hello报文。
 pim silent
 //在接口上使能PIM Silent功能。
 /*
   为了避免恶意主机模拟PIM Hello报文攻击路由器，可
   以在直连用户的接口上执行pim silent命令，将接口设
   置为PIM消极模式。接口进入消极状态后，禁止接收和转
   发任何PIM协议报文，删除该接口上的所有PIM邻居以及
   PIM状态机，并自动成为DR。同时，该接口上的IGMP功
   能不受影响。
    PIM silent仅适用于与用户主机网段直连的接口，且
    网段上只能连接一台PIM路由器。
*/
pim sm
//在接口上使能PIM-SM。
pim state-refresh-capable
//在接口上使能PIM-DM状态刷新。
//缺省情况下，PIM-DM状态刷新功能已使能。
pim timer dr-switch-delay
//在接口上使能PIM DR切换延迟功能
 pim timer graft-retry 3
//在接口上配置重传嫁接（Graft）报文的时间间隔。  
pim timer hello 30
//在接口上配置发送Hello报文的时间间隔。
  probe-interval 5
//配置路由器向RP发送Probe报文（空注册报文）的时间间隔。
register-header-checksum
//配置仅根据Register注册报文头信息来计算校验和。
register-source
//指定源DR发送注册报文的源地址。
register-suppression-timeout 60
//来配置路由器保持注册抑制状态的超时时间。
source-lifetime 210
//配置路由器上（S，G）或者（*，G）表项的超时时间。
spt-switch-threshold
 //设置组成员端DR加入SPT的组播报文速率阈值。
//缺省情况下，从RPT收到第一个组播数据包后立即进行SPT切换。
state-refresh-interval60
//配置路由器发送PIM状态刷新报文（State-Refresh）的时间间隔。
state-refresh-rate-limit 30
//配置接收下一个PIM状态刷新报文前必须经过的最小时间长度。
 state-refresh-ttl 255
//配置发送PIM状态刷新报文的TTL值。
static-rp
//配置静态RP。
  timer spt-switch 15
  //配置在RPT切换到SPT前检查组播数据速率是否达到阈值的时间间隔。
```