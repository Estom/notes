## 1 TSL1.0
### 概念
* TLS(Transport Layer Security，传输层安全协议)，用于两个应用程序之间提供保密性和数据完整性。
* TLS 1.0是IETF（Internet Engineering Task Force，Internet工程任务组）制定的一种新的协议，它建立在SSL 3.0协议规范之上，是SSL 3.0的后续版本，可以理解为SSL 3.1(可简单理解为同一事物不同阶段的不同称呼)，它是写入了 RFC 的。该协议由两层组成： TLS 记录协议（TLS Record）和 TLS 握手协议（TLS Handshake）。较低的层为 TLS 记录协议，位于某个可靠的传输协议（例如 TCP）上面。

### 特点
* 对话的内容用”对称加密”,而对于”对称加密”带来的密钥传输问题,则由”非对称加密”来解决,由于客户端没有”非对称加密”的解密能力,所以密钥由客户端来产生并用公钥加密传输给服务端,这样就(在思路上)解决了密钥传输的安全问题和对话数据解密的性能问题

### 技术
```
CipherSuite TLS_NULL_WITH_NULL_NULL                = { 0x00,0x00 };

//RSA 密钥建立、认证套件
CipherSuite TLS_RSA_WITH_NULL_MD5                  = { 0x00,0x01 };
CipherSuite TLS_RSA_WITH_NULL_SHA                  = { 0x00,0x02 };
CipherSuite TLS_RSA_EXPORT_WITH_RC4_40_MD5         = { 0x00,0x03 };
CipherSuite TLS_RSA_WITH_RC4_128_MD5               = { 0x00,0x04 };
CipherSuite TLS_RSA_WITH_RC4_128_SHA               = { 0x00,0x05 };
CipherSuite TLS_RSA_EXPORT_WITH_RC2_CBC_40_MD5     = { 0x00,0x06 };
CipherSuite TLS_RSA_WITH_IDEA_CBC_SHA              = { 0x00,0x07 };
CipherSuite TLS_RSA_EXPORT_WITH_DES40_CBC_SHA      = { 0x00,0x08 };
CipherSuite TLS_RSA_WITH_DES_CBC_SHA               = { 0x00,0x09 };
CipherSuite TLS_RSA_WITH_3DES_EDE_CBC_SHA          = { 0x00,0x0A };

//DH 密钥建立 RSA/DSS 认证套件
CipherSuite TLS_DH_DSS_EXPORT_WITH_DES40_CBC_SHA   = { 0x00,0x0B };
CipherSuite TLS_DH_DSS_WITH_DES_CBC_SHA            = { 0x00,0x0C };
CipherSuite TLS_DH_DSS_WITH_3DES_EDE_CBC_SHA       = { 0x00,0x0D };
CipherSuite TLS_DH_RSA_EXPORT_WITH_DES40_CBC_SHA   = { 0x00,0x0E };
CipherSuite TLS_DH_RSA_WITH_DES_CBC_SHA            = { 0x00,0x0F };
CipherSuite TLS_DH_RSA_WITH_3DES_EDE_CBC_SHA       = { 0x00,0x10 };
CipherSuite TLS_DHE_DSS_EXPORT_WITH_DES40_CBC_SHA  = { 0x00,0x11 };
CipherSuite TLS_DHE_DSS_WITH_DES_CBC_SHA           = { 0x00,0x12 };
CipherSuite TLS_DHE_DSS_WITH_3DES_EDE_CBC_SHA      = { 0x00,0x13 };
CipherSuite TLS_DHE_RSA_EXPORT_WITH_DES40_CBC_SHA  = { 0x00,0x14 };
CipherSuite TLS_DHE_RSA_WITH_DES_CBC_SHA           = { 0x00,0x15 };
CipherSuite TLS_DHE_RSA_WITH_3DES_EDE_CBC_SHA      = { 0x00,0x16 };

//DH 密钥建立 no 认证套件
CipherSuite TLS_DH_anon_EXPORT_WITH_RC4_40_MD5     = { 0x00,0x17 };
CipherSuite TLS_DH_anon_WITH_RC4_128_MD5           = { 0x00,0x18 };
CipherSuite TLS_DH_anon_EXPORT_WITH_DES40_CBC_SHA  = { 0x00,0x19 };
CipherSuite TLS_DH_anon_WITH_DES_CBC_SHA           = { 0x00,0x1A };
CipherSuite TLS_DH_anon_WITH_3DES_EDE_CBC_SHA      = { 0x00,0x1B };
```
## 2 TSL1.1
### 特点
相对之前版本的变化
- 隐式初始化向量（IV）被显式IV替换以防止CBC攻击[CBCATT]。

- 填充错误的处理被更改为使用坏的\u记录\u mac警报，而不是解密失败的警报，以防止CBC攻击。

- IANA注册表是为协议参数定义的。

- 过早关闭不再导致会话不可恢复。

- 为TLS上的各种新攻击添加了其他信息注释。

### 技术


* 密码套件
```
//RSA 加密、认证套件
CipherSuite TLS_RSA_WITH_NULL_MD5                  = { 0x00,0x01 };
CipherSuite TLS_RSA_WITH_NULL_SHA                  = { 0x00,0x02 };
CipherSuite TLS_RSA_WITH_RC4_128_MD5               = { 0x00,0x04 };
CipherSuite TLS_RSA_WITH_RC4_128_SHA               = { 0x00,0x05 };
CipherSuite TLS_RSA_WITH_IDEA_CBC_SHA              = { 0x00,0x07 };
CipherSuite TLS_RSA_WITH_DES_CBC_SHA               = { 0x00,0x09 };
CipherSuite TLS_RSA_WITH_3DES_EDE_CBC_SHA          = { 0x00,0x0A };

//DH 加密 RSA/DSS 认证套件
CipherSuite TLS_DH_DSS_WITH_DES_CBC_SHA            = { 0x00,0x0C };
CipherSuite TLS_DH_DSS_WITH_3DES_EDE_CBC_SHA       = { 0x00,0x0D };
CipherSuite TLS_DH_RSA_WITH_DES_CBC_SHA            = { 0x00,0x0F };
CipherSuite TLS_DH_RSA_WITH_3DES_EDE_CBC_SHA       = { 0x00,0x10 };
CipherSuite TLS_DHE_DSS_WITH_DES_CBC_SHA           = { 0x00,0x12 };
CipherSuite TLS_DHE_DSS_WITH_3DES_EDE_CBC_SHA      = { 0x00,0x13 };
CipherSuite TLS_DHE_RSA_WITH_DES_CBC_SHA           = { 0x00,0x15 };
CipherSuite TLS_DHE_RSA_WITH_3DES_EDE_CBC_SHA      = { 0x00,0x16 };

//DH 加密 no 认证套件
CipherSuite TLS_DH_anon_WITH_RC4_128_MD5           = { 0x00,0x18 };
CipherSuite TLS_DH_anon_WITH_DES_CBC_SHA           = { 0x00,0x1A };
CipherSuite TLS_DH_anon_WITH_3DES_EDE_CBC_SHA      = { 0x00,0x1B };
```
## 3 TSL1.2

### 特点

本文件是TLS 1.1[TLS1.1]协议的修订版，其中包含改进的灵活性，特别是对于密码算法的协商。主要变化是：

- 伪随机函数（PRF）中的MD5/SHA-1组合已被密码套件指定的PRF所取代。本文档中的所有密码套件都使用P_SHA256。

- MD5/SHA-1组合在数字电视中的应用.签名元素已被替换为单个哈希。有符号元素现在包含一个字段，该字段显式指定所使用的哈希算法。


- 增加了对附加数据模式的认证加密的支持。

- TLS扩展定义和AES密码套件由外部[TLSEXT]和[TLSAES]合并而成。

- 更严格地检查加密的premastersecret版本号。

- 验证数据的长度现在取决于密码套件（默认值仍然是12）。

- 在许多情况下，现在必须发送警报。

- 在证书请求之后，如果没有可用的证书，客户端现在必须发送一个空的证书列表。

- TLS_RSA_WITH_AES_128_CBC_SHA现在是实现密码套件的必备工具。

- 添加HMAC-SHA256密码套件。

- 删除IDEA和DES密码套件。它们现在已被弃用，并将记录在一个单独的文档中。

- 支持SSLv2


### 技术


* 密码套件
```
//RSA 加密、认证套件

CipherSuite TLS_RSA_WITH_NULL_MD5                 = { 0x00,0x01 };
CipherSuite TLS_RSA_WITH_NULL_SHA                 = { 0x00,0x02 };
CipherSuite TLS_RSA_WITH_NULL_SHA256              = { 0x00,0x3B };
CipherSuite TLS_RSA_WITH_RC4_128_MD5              = { 0x00,0x04 };
CipherSuite TLS_RSA_WITH_RC4_128_SHA              = { 0x00,0x05 };
CipherSuite TLS_RSA_WITH_3DES_EDE_CBC_SHA         = { 0x00,0x0A };
CipherSuite TLS_RSA_WITH_AES_128_CBC_SHA          = { 0x00,0x2F };
CipherSuite TLS_RSA_WITH_AES_256_CBC_SHA          = { 0x00,0x35 };
CipherSuite TLS_RSA_WITH_AES_128_CBC_SHA256       = { 0x00,0x3C };
CipherSuite TLS_RSA_WITH_AES_256_CBC_SHA256       = { 0x00,0x3D };

//DH 加密 RSA/DSS 认证套件
CipherSuite TLS_DH_DSS_WITH_3DES_EDE_CBC_SHA      = { 0x00,0x0D };
CipherSuite TLS_DH_RSA_WITH_3DES_EDE_CBC_SHA      = { 0x00,0x10 };
CipherSuite TLS_DHE_DSS_WITH_3DES_EDE_CBC_SHA     = { 0x00,0x13 };
CipherSuite TLS_DHE_RSA_WITH_3DES_EDE_CBC_SHA     = { 0x00,0x16 };
CipherSuite TLS_DH_DSS_WITH_AES_128_CBC_SHA       = { 0x00,0x30 };
CipherSuite TLS_DH_RSA_WITH_AES_128_CBC_SHA       = { 0x00,0x31 };
CipherSuite TLS_DHE_DSS_WITH_AES_128_CBC_SHA      = { 0x00,0x32 };
CipherSuite TLS_DHE_RSA_WITH_AES_128_CBC_SHA      = { 0x00,0x33 };
CipherSuite TLS_DH_DSS_WITH_AES_256_CBC_SHA       = { 0x00,0x36 };
CipherSuite TLS_DH_RSA_WITH_AES_256_CBC_SHA       = { 0x00,0x37 };
CipherSuite TLS_DHE_DSS_WITH_AES_256_CBC_SHA      = { 0x00,0x38 };
CipherSuite TLS_DHE_RSA_WITH_AES_256_CBC_SHA      = { 0x00,0x39 };
CipherSuite TLS_DH_DSS_WITH_AES_128_CBC_SHA256    = { 0x00,0x3E };
CipherSuite TLS_DH_RSA_WITH_AES_128_CBC_SHA256    = { 0x00,0x3F };
CipherSuite TLS_DHE_DSS_WITH_AES_128_CBC_SHA256   = { 0x00,0x40 };
CipherSuite TLS_DHE_RSA_WITH_AES_128_CBC_SHA256   = { 0x00,0x67 };
CipherSuite TLS_DH_DSS_WITH_AES_256_CBC_SHA256    = { 0x00,0x68 };
CipherSuite TLS_DH_RSA_WITH_AES_256_CBC_SHA256    = { 0x00,0x69 };
CipherSuite TLS_DHE_DSS_WITH_AES_256_CBC_SHA256   = { 0x00,0x6A };
CipherSuite TLS_DHE_RSA_WITH_AES_256_CBC_SHA256   = { 0x00,0x6B };

//DH 加密 no 认证套件
CipherSuite TLS_DH_anon_WITH_RC4_128_MD5          = { 0x00,0x18 };
CipherSuite TLS_DH_anon_WITH_3DES_EDE_CBC_SHA     = { 0x00,0x1B };
CipherSuite TLS_DH_anon_WITH_AES_128_CBC_SHA      = { 0x00,0x34 };
CipherSuite TLS_DH_anon_WITH_AES_256_CBC_SHA      = { 0x00,0x3A };
CipherSuite TLS_DH_anon_WITH_AES_128_CBC_SHA256   = { 0x00,0x6C };
CipherSuite TLS_DH_anon_WITH_AES_256_CBC_SHA256   = { 0x00,0x6D };

```
## 4 TSL1.3

### 特点


- 受支持的对称加密算法列表已从所有被认为是遗留的算法中删去。剩下的都是使用关联数据（AEAD）算法进行身份验证的加密。密码套件的概念已经改变，将身份验证和密钥交换机制与记录保护算法（包括密钥长度）分开，并将哈希与密钥派生函数和握手消息身份验证码（MAC）一起使用。

- 添加了零往返时间（0-RTT）模式，节省了一些应用程序数据在连接设置时的往返时间，但牺牲了某些安全属性。

- 删除了静态RSA和Diffie-Hellman密码；所有基于公钥的密钥交换机制现在都提供前向保密性。

- ServerHello之后的所有握手消息现在都已加密。新引入EncryptedExtensions消息允许以前在服务器hello中以明文形式发送的各种扩展也享受保密保护。

- 重新设计了密钥派生函数。新的设计由于其改进的密钥分离特性，使得密码学家可以更容易地进行分析。基于HMAC的提取和扩展密钥派生函数（HKDF）被用作底层原语。

- 握手状态机已经被显著地重新构造为更加一致，并且删除了诸如ChangeCipherSpec之类的多余消息（除了在需要中间盒兼容性时）。

- 椭圆曲线算法现在是基本规范，新的签名算法，如EdDSA，包括在内。TLS 1.3删除了点格式协商，支持每条曲线的单点格式。

- 进行了其他加密改进，包括更改 RSA 填充以使用 RSA 概率签名方案 (RSASSA-PSS)，以及取消压缩、数字签名算法 (DSA) 和自定义临时 Diffie-Hellman (DHE) 组。

- TLS 1.2 版本协商机制已被弃用，以支持扩展中的版本列表。 这增加了与错误实施版本协商的现有服务器的兼容性。

- 带有和不带有服务器端状态的会话恢复以及早期 TLS 版本的基于 PSK 的密码套件已被一个新的 PSK 交换所取代。

### 技术
* 新增的加密套件套件
```
+------------------------------+-------------+
| Description                  | Value       |
+------------------------------+-------------+
| TLS_AES_128_GCM_SHA256       | {0x13,0x01} |
|                              |             |
| TLS_AES_256_GCM_SHA384       | {0x13,0x02} |
|                              |             |
| TLS_CHACHA20_POLY1305_SHA256 | {0x13,0x03} |
|                              |             |
| TLS_AES_128_CCM_SHA256       | {0x13,0x04} |
|                              |             |
| TLS_AES_128_CCM_8_SHA256     | {0x13,0x05} |
+------------------------------+-------------+
```


