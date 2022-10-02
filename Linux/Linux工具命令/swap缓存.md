# swap缓存配置


> swapon、swapoff

## 配置过程
1.首先用命令free查看系统内 Swap 分区大小
```
　　free -m 
　　total used free shared buffers cached 
　　Mem: 2012 1960 51 0 748 950 
　　-/+ buffers/cache: 260 1751 
　　Swap: 255 0 255 
　　可以看到 Swap 只有255M，下面我们来扩大到2G。
```
2.创建一个 Swap 文件
```
　　找一个空间足够的目录用来存放swap文件 
　　mkdir /swap 
　　cd /swap 
　　sudo dd if=/dev/zero of=swapfile bs=1024 count=2000000 
　　出现下列提示，上面命令中的 count 即代表swap文件大小。 
　　记录了2000000+0 的读入 
　　记录了2000000+0 的写出 
　　2048000000字节(2.0 GB)已复制，63.3147 秒，32.3 MB/秒 
　　把生成的文件转换成 Swap 文件 
　　sudo mkswap -f swapfile 
　　Setting up swapspace version 1, size = 1999996 KiB 
　　no label, UUID=fee9ab21-9efb-47c9-80f4-57e48142dd69
```
3.激活 Swap 文件
```
　　sudo swapon swapfile 
　　再次查看 free -m 的结果。 
　　total used free shared buffers cached 
　　Mem: 2012 1971 41 0 572 1156 
　　-/+ buffers/cache: 241 1770 
　　Swap: 2209 0 2209 
　　添加成功。
```
4.扩展：
```
　　如果需要卸载这个 swap 文件，可以进入建立的 swap 文件目录。执行下列命令。 
　　sudo swapoff swapfile 
　　如果需要一直保持这个 swap ，可以把它写入 /etc/fstab 文件。 
　　/swap/swapfile /swap swap defaults 0 0
```