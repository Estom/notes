## 1 使用github
> 参考文献
> [https://www.bilibili.com/video/av10475153/index_2.html\#page=5]


### **github的简介**

* Create Repository创建仓库
* Star收藏
* Fork复制一份远程仓库
* Pull Request拉我呀，快点，我改好了。
* Open & Merge Request拉你了，别墨迹。
* Watch看着你呢，关注一个项目。
* Github主页仓库主页——仓库相关的信息和相关操作





### **git remote**

```
git remote
```

列出你和远程仓库之间的远程连接

```
git remote -v
```

列出每个连接的名字和url

```
git remote add \<name\> \<url\>
```

创建一个新的远程连接并添加名字
```
git remote rm \<name\>
```

移除远程仓库的链接

### **git fetch**

```
git fetch \<remote\>
```

拉取仓库中的所有分支（包括相关的文件和所有的提交）
```
git fetch \<remote\> \<branch\>
```

拉取制定仓库中的所有分支（包括相关的文件和所欲的提交）

> 注意，这个步骤知识拉取远程的分支，在本地并没有合并也没有生成本地分支，知识一个可读的远程分支。
> * 使用git branch -r 命令可以查看所有只读的远程分支。
> * 使用gitcheckout命令可以创建本地分支，并与远程分支关联。
> * 使用git merge命令可以将远程分支与本地分支合并。

### **git pull**
```
git pull remote
```

拉取当前分支对应的远程副本，并将远程副本的更改写入本地副本。相当于git fetch之后git merge。

```
git pull -rebase \<remote\>
```

使用git rebase命令合并远程分支与本地分支，不使用git merge

### **git push**

```
git push \<remote\> \<branch\>
```

将制定分支推送到远程分支。包括所有的文件和提交。

```
git push \<remote\> --force
```
强制推送
```
git push \<remote\> --all
```

本地所有的分支推送到远程仓库当中

```
git push \<remote\> --tags
```

将本地所有标签推送到远程仓库中
