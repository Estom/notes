# Hash 表的查找

## 要点

### 哈希表和哈希函数

在记录的存储位置和它的关键字之间是建立一个确定的对应关系（映射函数），使每个关键字和一个存储位置能**唯一对应**。这个映射函数称为**哈希函数**，根据这个原则建立的表称为**哈希表(Hash Table)**，也叫**散列表**。

以上描述，如果通过数学形式来描述就是：

若查找关键字为 **key**，则其值存放在 **f(key)** 的存储位置上。由此，**不需比较便可直接取得所查记录**。

***注：哈希查找与线性表查找和树表查找最大的区别在于，不用数值比较。***

### 冲突

若 key1 ≠ key2 ，而 f(key1) = f(key2)，这种情况称为**冲突(Collision)**。

根据哈希函数f(key)和处理冲突的方法将一组关键字映射到一个有限的连续的地址集（区间）上，并以关键字在地址集中的“像”作为记录在表中的存储位置，这一映射过程称为**构造哈希表**。

构造哈希表这个场景就像汽车找停车位，如果车位被人占了，只能找空的地方停。

![img](http://upload-images.jianshu.io/upload_images/3101171-4f4e0c3def86f7bb.jpg "点击查看源网页")

## 构造哈希表

由以上内容可知，哈希查找本身其实不费吹灰之力，问题的关键在于如何构造哈希表和处理冲突。

常见的构造哈希表的方法有 `5` 种：

### 直接定址法

说白了，就是小学时学过的**一元一次方程**。

即 f(key) = a * key + b。其中，a和b 是常数。

### 数字分析法

假设关键字是R进制数（如十进制）。并且哈希表中**可能出现的关键字都是事先知道的**，则可选取关键字的若干数位组成哈希地址。

选取的原则是使得到的哈希地址尽量避免冲突，即所选数位上的数字尽可能是随机的。

### 平方取中法

取关键字平方后的中间几位为哈希地址。通常在选定哈希函数时不一定能知道关键字的全部情况，仅取其中的几位为地址不一定合适；

而一个数平方后的中间几位数和数的每一位都相关， 由此得到的哈希地址随机性更大。取的位数由表长决定。

### 除留余数法

取关键字被某个**不大于哈希表表长** m 的数 p 除后所得的余数为哈希地址。

即 f(key) = key % p (p ≤ m)

这是一种**最简单、最常用**的方法，它不仅可以对关键字直接取模，也可在折叠、平方取中等运算之后取模。

注意：p的选择很重要，如果选的不好，容易产生冲突。根据经验，**一般情况下可以选p为素数**。

### 随机数法

选择一个随机函数，取关键字的随机函数值为它的哈希地址，即 f(key) = random(key)。

通常，在关键字长度不等时采用此法构造哈希函数较为恰当。

## 解决冲突

设计合理的哈希函数可以减少冲突，但不能完全避免冲突。

所以需要有解决冲突的方法，常见有两类：

### 开放定址法

如果两个数据元素的哈希值相同，则在哈希表中为后插入的数据元素另外选择一个表项。
当程序查找哈希表时，如果没有在第一个对应的哈希表项中找到符合查找要求的数据元素，程序就会继续往后查找，直到找到一个符合查找要求的数据元素，或者遇到一个空的表项。

**示例**

若要将一组关键字序列 {1, 9, 25, 11, 12, 35, 17, 29} 存放到哈希表中。

采用除留余数法构造哈希表；采用开放定址法处理冲突。

不妨设选取的p和m为13，由 f(key) = key % 13 可以得到下表。

![img](https://upload-images.jianshu.io/upload_images/3101171-06a789e7f9b31da6.png)

需要注意的是，在上图中有两个关键字的探查次数为 2 ，其他都是1。

这个过程是这样的：

a. 12 % 13 结果是12，而它的前面有个 25 ，25 % 13 也是12，存在冲突。

我们使用开放定址法 (12 + 1) % 13 = 0，没有冲突，完成。

b. 35 % 13 结果是 9，而它的前面有个 9，9 % 13也是 9，存在冲突。

我们使用开放定址法 (9 + 1) % 13 = 10，没有冲突，完成。

### 拉链法

将哈希值相同的数据元素存放在一个链表中，在查找哈希表的过程中，当查找到这个链表时，必须采用线性查找方法。

在这种方法中，哈希表中每个单元存放的不再是记录本身，而是相应同义词单链表的头指针。

**示例**

如果对开放定址法示例中提到的序列使用拉链法，得到的结果如下图所示：

![img](https://upload-images.jianshu.io/upload_images/3101171-c14e03882e8a0f3a.png)

## 实现一个哈希表

假设要实现一个哈希表，要求

a. 哈希函数采用**除留余数法**，即 f(key) = key % p (p ≤ m)

b. 解决冲突采用**开放定址法**，即 f<sub>2</sub>(key) = (f(key)+i) % size (p ≤ m)

（1）定义哈希表的数据结构

```java
class HashTable {
    public int key = 0; // 关键字
    public int data = 0; // 数值
    public int count = 0; // 探查次数
}
```

（2）在哈希表中查找关键字key

根据设定的哈希函数，计算哈希地址。如果出现地址冲突，则按设定的处理冲突的方法寻找下一个地址。

如此反复，直到不冲突为止（查找成功）或某个地址为空（查找失败）。

```java
/**
 * 查找哈希表
 * 构造哈希表采用除留取余法，即f(key) = key mod p (p ≤ size)
 * 解决冲突采用开放定址法，即f2(key) = (f(key) + i) mod p (1 ≤ i ≤ size-1)
 * ha为哈希表，p为模，size为哈希表大小，key为要查找的关键字
 */
public int searchHashTable(HashTable[] ha, int p, int size, int key) {
    int addr = key % p; // 采用除留取余法找哈希地址

    // 若发生冲突，用开放定址法找下一个哈希地址
    while (ha[addr].key != NULLKEY && ha[addr].key != key) {
        addr = (addr + 1) % size;
    }

    if (ha[addr].key == key) {
        return addr; // 查找成功
    } else {
        return FAILED; // 查找失败
    }
}
```

（3）删除关键字为key的记录

在采用开放定址法处理冲突的哈希表上执行删除操作，只能在被删记录上做删除标记，而不能真正删除记录。

找到要删除的记录，将关键字置为删除标记DELKEY。

```java
public int deleteHashTable(HashTable[] ha, int p, int size, int key) {
    int addr = 0;
    addr = searchHashTable(ha, p, size, key);
    if (FAILED != addr) { // 找到记录
        ha[addr].key = DELKEY; // 将该位置的关键字置为DELKEY
        return SUCCESS;
    } else {
        return NULLKEY; // 查找不到记录，直接返回NULLKEY
    }
}
```

（4）插入关键字为key的记录

将待插入的关键字key插入哈希表
先调用查找算法，若在表中找到待插入的关键字，则插入失败；
若在表中找到一个开放地址，则将待插入的结点插入到其中，则插入成功。

```java
public void insertHashTable(HashTable[] ha, int p, int size, int key) {
    int i = 1;
    int addr = 0;
    addr = key % p; // 通过哈希函数获取哈希地址
    if (ha[addr].key == NULLKEY || ha[addr].key == DELKEY) { // 如果没有冲突，直接插入
        ha[addr].key = key;
        ha[addr].count = 1;
    } else { // 如果有冲突，使用开放定址法处理冲突
        do {
            addr = (addr + 1) % size; // 寻找下一个哈希地址
            i++;
        } while (ha[addr].key != NULLKEY && ha[addr].key != DELKEY);

        ha[addr].key = key;
        ha[addr].count = i;
    }
}
```

（5）建立哈希表

先将哈希表中各关键字清空，使其地址为开放的，然后调用插入算法将给定的关键字序列依次插入。

```java
public void insertHashTable(HashTable[] ha, int p, int size, int key) {
    int i = 1;
    int addr = 0;
    addr = key % p; // 通过哈希函数获取哈希地址
    if (ha[addr].key == NULLKEY || ha[addr].key == DELKEY) { // 如果没有冲突，直接插入
        ha[addr].key = key;
        ha[addr].count = 1;
    } else { // 如果有冲突，使用开放定址法处理冲突
        do {
            addr = (addr + 1) % size; // 寻找下一个哈希地址
            i++;
        } while (ha[addr].key != NULLKEY && ha[addr].key != DELKEY);

        ha[addr].key = key;
        ha[addr].count = i;
    }
}
```

### 完整示例

[示例代码](https://github.com/dunwu/algorithm/blob/master/codes/src/main/java/io/github/dunwu/algorithm/search/HashDemo.java)

## 资源

《数据结构习题与解析》（B级第3版）
