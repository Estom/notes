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
```
## 4 OSPF协议实验

```
# display ospf命令的说明，下面是三个不同的表格。
display ospf peer //显示的是邻居信息，有几个邻居路由器
display ospf routing //是路由信息，具体用来决定从哪个接口，寻找下一跳。通过lsdb与ospf算法计算而来。
display ospf lsdb //是整个区域的链路拓扑结构，即通过lsa链路状态通告而来。
display adjacent-table //显示邻接信息。

# router id相关命令
[system]router id router-id //设置router id
[system]undo router id //删除router id

[system]ospf [process-id[router-id]] //创建并进入ospf视图
[system]undo ospf [process-id]关闭ospf视图

[ospf]area area-id //创建并进入ospf下area视图
[ospf]undo area area-id //删除ospf area

[area]network ip-address wildcard-mask //指定网段运行OSPF协议
[area]undo network ip-address wildcard-mask //取消网段运行OSPF协议

# 重置
[user]reset ospf all process
# 显示
[user]display ospf peer/brief/error/routing
# 调试
[user]debugging ospf event/lsa/packet/spf

# 用来显示ospf的lsdb（链路状态数据库）自组织成第一类router-lsa的内容。
[R]dis ospf 1 lsdb router self-originate  
# ospf的lsdb自组织第二类network-lsa
[R]dis ospf 1 lsdb network self-originate 
# ospf的lsdb自组织第三类第四类summary lsa
[R]dis ospf 1 lsdb summary self-originate 
# ospf的lsdb自组织第五类lsa
[R]dis ospf lsdb ase 
```


## 4 交换机系统视图

```
```

