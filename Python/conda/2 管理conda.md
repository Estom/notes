# 管理conda


> 参考文献
> * [jianshu.com/p/62f155eb6ac5](jianshu.com/p/62f155eb6ac5)


> Windows用户请打开“Anaconda Prompt”；

## 1. 验证conda已被安装
```
conda --version
```
* 终端上将会以conda 版本号的形式显示当前安装conda的版本号。如：conda 3.11.0

* 注意：如果出现错误信息，则需核实是否出现以下情况：
  * 使用的用户是否是安装Anaconda时的账户。
  * 是否在安装Anaconda之后重启了终端。

## 2. 更新conda至最新版本
```
conda update conda
```
* 执行命令后，conda将会对版本进行比较并列出可以升级的版本。同时，也会告知用户其他相关包也会升级到相应版本。

* 当较新的版本可以用于升级时，终端会显示Proceed ([y]/n)?，此时输入y即可进行升级。

## 3. 查看conda帮助信息

```
conda --help
```
或
```
conda -h
```