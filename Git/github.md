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


## 2 fork同步
> 参考文献
> * [https://blog.csdn.net/qq_22918243/article/details/89642445](https://blog.csdn.net/qq_22918243/article/details/89642445)
Fork 之后同步源的更新内容
配置fork 远程仓库
查看fork之后的项目的远程仓库状态 git remote -v

添加一个将被同步给 fork 远程的上游仓库

 git remote add upstream <git_url>
1
再次查看状态确认是否配置成功

同步Fork
从上游仓库 fetch 分支和提交点，传送到本地，并会被存储在一个本地分支 upstream/master.

执行 git fetch upstream

切换到本地主分支 git checkout master

把 upstream/master 分支合并到本地 master 上，这样就完成了同步，并且不会丢掉本地修改的内容。

执行 git merge upstream/master

如果想更新到 GitHub 的 fork 上，直接 git push origin master 就好了。

提交代码到原有的源上
在原有的代码修改之后，使用 git rebase 合并代码。然后再行提交

git remote add
git fetch
git rebase/merge
git push

