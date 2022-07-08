## 标签
新建标签：command + t
 
关闭标签：command + w
 
切换标签：command + 数字 command + 左右方向键
 
切换全屏：command + enter
 
查找：command + f

## 分屏


垂直分屏：command + d
 
水平分屏：command + shift + d
 
切换屏幕：command + option + 方向键 command + [ 或 command + ]
 
查看历史命令：command + ;
 
查看剪贴板历史：command + shift + h


## 其他
清除当前行：ctrl + u
 
到行首：ctrl + a
 
到行尾：ctrl + e
 
前进后退：ctrl + f/b (相当于左右方向键)
 
上一条命令：ctrl + p
 
搜索命令历史：ctrl + r
 
删除当前光标的字符：ctrl + d
 
删除光标之前的字符：ctrl + h
 
删除光标之前的单词：ctrl + w
 
删除到文本末尾：ctrl + k
 
交换光标处文本：ctrl + t
 
清屏1：command + r
 
清屏2：ctrl + l
 
### 自带有哪些很实用的功能/快捷键
 
1. ⌘ + 数字在各 tab 标签直接来回切换
 
2. 选择即复制 + 鼠标中键粘贴，这个很实用
 
3. ⌘ + f 所查找的内容会被自动复制
 
4. ⌘ + d 横着分屏 / ⌘ + shift + d 竖着分屏
 
5. ⌘ + r = clear，而且只是换到新一屏，不会想 clear 一样创建一个空屏
 
6. ctrl + u 清空当前行，无论光标在什么位置
 
7. 输入开头命令后 按 ⌘ + ; 会自动列出输入过的命令
 
8. ⌘ + shift + h 会列出剪切板历史
 
10. 可以在 Preferences > keys 设置全局快捷键调出 iterm，这个也可以用过 Alfred 实现


### 常用的一些快捷键

1. ⌘ + 1 / 2 左右 tab 之间来回切换，这个在 前面 已经介绍过了
 
2. ⌘← / ⌘→ 到一行命令最左边/最右边 ，这个功能同 C+a / C+e

3. ⌥← / ⌥→ 按单词前移/后移，相当与 C+f / C+b，其实这个功能在Iterm中已经预定义好了，⌥f / ⌥b，看个人习惯了

4. C+a / C+e 这个几乎在哪都可以使用
 
5. C+p / !! 上一条命令
 
6. C+k 从光标处删至命令行尾 (本来 C+u 是删至命令行首，但iterm中是删掉整行)
 
7. C+w A+d 从光标处删至字首/尾
 
8. C+h C+d 删掉光标前后的自负
 
9. C+y 粘贴至光标后
 
10. C+r 搜索命令历史，这个较常用


11. 选中即复制
iterm2 有 2 种好用的选中即复制模式。

一种是用鼠标，在 iterm2 中，选中某个路径或者某个词汇，那么，iterm2 就自动复制了。 　　
另一种是无鼠标模式，command+f,弹出 iterm2 的查找模式，输入要查找并复制的内容的前几个字母，确认找到的是自己的内容之后，输入 tab，查找窗口将自动变化内容，并将其复制。如果输入的是 shift+tab，则自动将查找内容的左边选中并复制。
自动完成
输入打头几个字母，然后输入 command+; iterm2 将自动列出之前输入过的类似命令。 　　

剪切历史
输入 command+shift+h，iterm2 将自动列出剪切板的历史记录。如果需要将剪切板的历史记录保存到磁盘，在 Preferences > General > Save copy/paste history to disk 中设置。