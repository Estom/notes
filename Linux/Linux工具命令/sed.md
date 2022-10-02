sed
===

功能强大的流式文本编辑器

## 补充说明

**sed** 是一种流编辑器，它是文本处理中非常重要的工具，能够完美的配合正则表达式使用，功能不同凡响。处理时，把当前处理的行存储在临时缓冲区中，称为“模式空间”（pattern space），接着用sed命令处理缓冲区中的内容，处理完成后，把缓冲区的内容送往屏幕。接着处理下一行，这样不断重复，直到文件末尾。文件内容并没有 改变，除非你使用重定向存储输出。Sed主要用来自动编辑一个或多个文件；简化对文件的反复操作；编写转换程序等。

## sed的选项、命令、替换标记  

 **命令格式** 

```shell
sed [options] 'command' file(s)
sed [options] -f scriptfile file(s)
```

###  选项 

```shell
-e<script>或--expression=<script>：以选项中的指定的script来处理输入的文本文件；
-f<script文件>或--file=<script文件>：以选项中指定的script文件来处理输入的文本文件；
-h或--help：显示帮助；
-n或--quiet或——silent：仅显示script处理后的结果；
-V或--version：显示版本信息。
```

###  参数 

文件：指定待处理的文本文件列表。

###  sed命令 

```shell
a # 在当前行下面插入文本。
i # 在当前行上面插入文本。
c # 把选定的行改为新的文本。
d # 删除，删除选择的行。
D # 删除模板块的第一行。
s # 替换指定字符
h # 拷贝模板块的内容到内存中的缓冲区。
H # 追加模板块的内容到内存中的缓冲区。
g # 获得内存缓冲区的内容，并替代当前模板块中的文本。
G # 获得内存缓冲区的内容，并追加到当前模板块文本的后面。
l # 列表不能打印字符的清单。
n # 读取下一个输入行，用下一个命令处理新的行而不是用第一个命令。
N # 追加下一个输入行到模板块后面并在二者间嵌入一个新行，改变当前行号码。
p # 打印模板块的行。
P # (大写) 打印模板块的第一行。
q # 退出Sed。
b lable # 分支到脚本中带有标记的地方，如果分支不存在则分支到脚本的末尾。
r file # 从file中读行。
t label # if分支，从最后一行开始，条件一旦满足或者T，t命令，将导致分支到带有标号的命令处，或者到脚本的末尾。
T label # 错误分支，从最后一行开始，一旦发生错误或者T，t命令，将导致分支到带有标号的命令处，或者到脚本的末尾。
w file # 写并追加模板块到file末尾。  
W file # 写并追加模板块的第一行到file末尾。  
! # 表示后面的命令对所有没有被选定的行发生作用。  
= # 打印当前行号码。  
# # 把注释扩展到下一个换行符以前。  
```

###  sed替换标记 

```shell
g # 表示行内全面替换。  
p # 表示打印行。  
w # 表示把行写入一个文件。  
x # 表示互换模板块中的文本和缓冲区中的文本。  
y # 表示把一个字符翻译为另外的字符（但是不用于正则表达式）
\1 # 子串匹配标记
& # 已匹配字符串标记
```

###  sed元字符集 

```shell
^ # 匹配行开始，如：/^sed/匹配所有以sed开头的行。
$ # 匹配行结束，如：/sed$/匹配所有以sed结尾的行。
. # 匹配一个非换行符的任意字符，如：/s.d/匹配s后接一个任意字符，最后是d。
* # 匹配0个或多个字符，如：/*sed/匹配所有模板是一个或多个空格后紧跟sed的行。
[] # 匹配一个指定范围内的字符，如/[sS]ed/匹配sed和Sed。  
[^] # 匹配一个不在指定范围内的字符，如：/[^A-RT-Z]ed/匹配不包含A-R和T-Z的一个字母开头，紧跟ed的行。
\(..\) # 匹配子串，保存匹配的字符，如s/\(love\)able/\1rs，loveable被替换成lovers。
& # 保存搜索字符用来替换其他字符，如s/love/ **&** /，love这成 **love** 。
\< # 匹配单词的开始，如:/\<love/匹配包含以love开头的单词的行。
\> # 匹配单词的结束，如/love\>/匹配包含以love结尾的单词的行。
x\{m\} # 重复字符x，m次，如：/0\{5\}/匹配包含5个0的行。
x\{m,\} # 重复字符x，至少m次，如：/0\{5,\}/匹配至少有5个0的行。
x\{m,n\} # 重复字符x，至少m次，不多于n次，如：/0\{5,10\}/匹配5~10个0的行。  
```

## sed用法实例  

###  替换操作：s命令 

替换文本中的字符串：

```shell
sed 's/book/books/' file
```

 **-n选项** 和 **p命令** 一起使用表示只打印那些发生替换的行：

sed -n 's/test/TEST/p' file

直接编辑文件 **选项-i** ，会匹配file文件中每一行的所有book替换为books：

```shell
sed -i 's/book/books/g' file
```

###  全面替换标记g 

使用后缀 /g 标记会替换每一行中的所有匹配：

```shell
sed 's/book/books/g' file
```

当需要从第N处匹配开始替换时，可以使用 /Ng：

```shell
echo sksksksksksk | sed 's/sk/SK/2g'
skSKSKSKSKSK

echo sksksksksksk | sed 's/sk/SK/3g'
skskSKSKSKSK

echo sksksksksksk | sed 's/sk/SK/4g'
skskskSKSKSK
```

###  定界符 

以上命令中字符 / 在sed中作为定界符使用，也可以使用任意的定界符：

```shell
sed 's:test:TEXT:g'
sed 's|test|TEXT|g'
```

定界符出现在样式内部时，需要进行转义：

```shell
sed 's/\/bin/\/usr\/local\/bin/g'
```

###  删除操作：d命令 

删除空白行：

```shell
sed '/^$/d' file
```

删除文件的第2行：

```shell
sed '2d' file
```

删除文件的第2行到末尾所有行：

```shell
sed '2,$d' file
```

删除文件最后一行：

```shell
sed '$d' file
```

删除文件中所有开头是test的行：

```shell
sed '/^test/'d file
```

###  已匹配字符串标记& 

正则表达式 \w\+ 匹配每一个单词，使用 [&] 替换它，& 对应于之前所匹配到的单词：

```shell
echo this is a test line | sed 's/\w\+/[&]/g'
[this] [is] [a] [test] [line]
```

所有以192.168.0.1开头的行都会被替换成它自已加localhost：

```shell
sed 's/^192.168.0.1/&localhost/' file
192.168.0.1localhost
```

###  子串匹配标记\1 

匹配给定样式的其中一部分：

```shell
echo this is digit 7 in a number | sed 's/digit \([0-9]\)/\1/'
this is 7 in a number
```

命令中 digit 7，被替换成了 7。样式匹配到的子串是 7，\(..\) 用于匹配子串，对于匹配到的第一个子串就标记为  **\1** ，依此类推匹配到的第二个结果就是  **\2** ，例如：

```shell
echo aaa BBB | sed 's/\([a-z]\+\) \([A-Z]\+\)/\2 \1/'
BBB aaa
```

love被标记为1，所有loveable会被替换成lovers，并打印出来：

```shell
sed -n 's/\(love\)able/\1rs/p' file
```

###  组合多个表达式 

```shell
sed '表达式' | sed '表达式'

等价于：

sed '表达式; 表达式'
```

###  引用 

sed表达式可以使用单引号来引用，但是如果表达式内部包含变量字符串，就需要使用双引号。

```shell
test=hello
echo hello WORLD | sed "s/$test/HELLO"
HELLO WORLD
```

###  选定行的范围：,（逗号） 

所有在模板test和check所确定的范围内的行都被打印：

```shell
sed -n '/test/,/check/p' file
```

打印从第5行开始到第一个包含以test开始的行之间的所有行：

```shell
sed -n '5,/^test/p' file
```

对于模板test和west之间的行，每行的末尾用字符串aaa bbb替换：

```shell
sed '/test/,/west/s/$/aaa bbb/' file
```

###  多点编辑：e命令 

-e选项允许在同一行里执行多条命令：

```shell
sed -e '1,5d' -e 's/test/check/' file
```

上面sed表达式的第一条命令删除1至5行，第二条命令用check替换test。命令的执行顺序对结果有影响。如果两个命令都是替换命令，那么第一个替换命令将影响第二个替换命令的结果。

和 -e 等价的命令是 --expression：

```shell
sed --expression='s/test/check/' --expression='/love/d' file
```

###  从文件读入：r命令 

file里的内容被读进来，显示在与test匹配的行后面，如果匹配多行，则file的内容将显示在所有匹配行的下面：

```shell
sed '/test/r file' filename
```

###  写入文件：w命令   

在example中所有包含test的行都被写入file里：

```shell
sed -n '/test/w file' example
```

###  追加（行下）：a\命令 

将 this is a test line 追加到 以test 开头的行后面：

```shell
sed '/^test/a\this is a test line' file
```

在 test.conf 文件第2行之后插入 this is a test line：

```shell
sed -i '2a\this is a test line' test.conf
```

###  插入（行上）：i\命令 

将 this is a test line 追加到以test开头的行前面：

```shell
sed '/^test/i\this is a test line' file
```

在test.conf文件第5行之前插入this is a test line：

```shell
sed -i '5i\this is a test line' test.conf
```

###  下一个：n命令 

如果test被匹配，则移动到匹配行的下一行，替换这一行的aa，变为bb，并打印该行，然后继续：

```shell
sed '/test/{ n; s/aa/bb/; }' file
```

###  变形：y命令 

把1~10行内所有abcde转变为大写，注意，正则表达式元字符不能使用这个命令：

```shell
sed '1,10y/abcde/ABCDE/' file
```

###  退出：q命令 

打印完第10行后，退出sed

```shell
sed '10q' file
```

###  保持和获取：h命令和G命令 

在sed处理文件的时候，每一行都被保存在一个叫模式空间的临时缓冲区中，除非行被删除或者输出被取消，否则所有被处理的行都将 打印在屏幕上。接着模式空间被清空，并存入新的一行等待处理。

```shell
sed -e '/test/h' -e '$G' file
```

在这个例子里，匹配test的行被找到后，将存入模式空间，h命令将其复制并存入一个称为保持缓存区的特殊缓冲区内。第二条语句的意思是，当到达最后一行后，G命令取出保持缓冲区的行，然后把它放回模式空间中，且追加到现在已经存在于模式空间中的行的末尾。在这个例子中就是追加到最后一行。简单来说，任何包含test的行都被复制并追加到该文件的末尾。

###  保持和互换：h命令和x命令 

互换模式空间和保持缓冲区的内容。也就是把包含test与check的行互换：

```shell
sed -e '/test/h' -e '/check/x' file
```

###  脚本scriptfile 

sed脚本是一个sed的命令清单，启动Sed时以-f选项引导脚本文件名。Sed对于脚本中输入的命令非常挑剔，在命令的末尾不能有任何空白或文本，如果在一行中有多个命令，要用分号分隔。以#开头的行为注释行，且不能跨行。

```shell
sed [options] -f scriptfile file(s)
```

###  打印奇数行或偶数行 

方法1：

```shell
sed -n 'p;n' test.txt  #奇数行
sed -n 'n;p' test.txt  #偶数行
```

方法2：

```shell
sed -n '1~2p' test.txt  #奇数行
sed -n '2~2p' test.txt  #偶数行
```

###  打印匹配字符串的下一行 

```shell
grep -A 1 SCC URFILE
sed -n '/SCC/{n;p}' URFILE
awk '/SCC/{getline; print}' URFILE
```


## sed简单用法

示例1：向文件中添加或插入行
```
sed '3ahello' 1.txt   #向第三行后面添加hello，3表示行号

sed '/123/ahello' 1.txt #向内容123后面添加hello，如果文件中有多行包括123，则每一行后面都会添加

sed  '$ahello'  1.txt  #在最后一行添加hello

sed '3ihello'  1.txt    #在第三行之前插入hello

sed '/123/ihello'  1.txt   #在包含123的行之前插入hello，如果有多行包含123，则包含123的每一行之前都会插入hello

sed '$ihello'  1.txt     #在最后一行之前插入hello
```
示例2：更改文件中指定的行
```
sed  '1chello'  1.txt  #将文件1.txt的第一行替换为hello

sed  '/123/chello'  1.txt  #将包含123的行替换为hello

sed '$chello'  1.txt  #将最后一行替换为hello
```


示例3：删除文件中的行
```
sed  '4d'  1.txt    #删除第四行

sed '1~2d' 1.txt   #从第一行开始删除，每隔2行就删掉一行，即删除奇数行

sed   '1,2d'  1.txt   #删除1~2行

sed  '1,2!d'  1.txt   #删除1~2之外的所有行

sed  '$d'   1.txt      #删除最后一行

sed  '/123/d'   1.txt   #删除匹配123的行

sed  '/123/,$d'  1.txt  #删除从匹配123的行到最后一行

sed  '/123/,+1d'  1.txt   #删除匹配123的行及其后面一行

sed  '/^$/d'    1.txt    #删除空行

sed   '/123\|abc/!d'  1.txt    #删除不匹配123或abc的行，/123\|abc/ 表示匹配123或abc ，！表示取反

sed  '1,3{/123/d}'   1.txt     #删除1~3行中，匹配内容123的行，1,3表示匹配1~3行，{/123/d}表示删除匹配123的行
```
示例4：替换文件中的内容
```
sed 's/^/#&/g' 1.txt  #在1.txt文件中的每一行开头加一个#

sed  's/123/hello/'   1.txt   #将文件中的123替换为hello，默认只替换每行第一个123

sed  's/123/hello/g'  1.txt #将文本中所有的123都替换为hello

sed 's/123/hello/2'   1.txt  #将每行中第二个匹配的123替换为hello

sed  -n 's/123/hello/gpw  2.txt'   1.txt    #将每行中所有匹配的123替换为hello，并将替换后的内容写入2.txt

sed  '/#/s/,.*//g'  1.txt   #匹配有#号的行，替换匹配行中逗号后的所有内容为空  (,.*)表示逗号后的所又内容

sed  's/..$//g'  1.txt  #替换每行中的最后两个字符为空，每个点代表一个字符，$表示匹配末尾  （..$）表示匹配最后两个字符

sed 's/^#.*//'  1.txt      #将1.txt文件中以#开头的行替换为空行，即注释的行  ( ^#)表示匹配以#开头，（.*）代表所有内容

sed 's/^#.*//;/^$/d'  1.txt  #先替换1.txt文件中所有注释的空行为空行，然后删除空行，替换和删除操作中间用分号隔开

sed 's/^[0-9]/(&)/'   1.txt   #将每一行中行首的数字加上一个小括号   (^[0-9])表示行首是数字，&符号代表匹配的内容

或者  sed 's/[0−9][0−9]/(\1)/'   1.txt  #替换左侧特殊字符需钥转义，右侧不需要转义，\1代表匹配的内容

sed  's/$/&'haha'/'  1.txt   # 在1.txt文件的每一行后面加上"haha"字段
```

示例5：打印文件中的行
```
sed  -n '3p'  1.txt   #打印文件中的第三行内容

sed  -n '2~2p'  1.txt   #从第二行开始，每隔两行打印一行，波浪号后面的2表示步长

sed -n '$p'  1.txt  #打印文件的最后一行

sed -n '1,3p'  1.txt  #打印1到3行

sed  -n '3,$p'  1.txt  #打印从第3行到最后一行的内容

sed  -n '/you/p'  1.txt   #逐行读取文件，打印匹配you的行

sed  -n '/bob/,3p'  1.txt  #逐行读取文件，打印从匹配bob的行到第3行的内容

sed  -n  '/you/,3p'  1.txt  #打印匹配you 的行到第3行，也打印后面所有匹配you 的行

sed  -n '1,/too/p'  1.txt    #打印第一行到匹配too的行

sed  -n  '3,/you/p'  1.txt   #只打印第三行到匹配you的行

sed  -n '/too/,$p'  1.txt  #打印从匹配too的行到最后一行的内容

sed  -n '/too/,+1p'  1.txt    #打印匹配too的行及其向后一行，如果有多行匹配too，则匹配的每一行都会向后多打印一行

sed  -n '/bob/,/too/p'  1.txt   #打印从匹配内容bob到匹配内容too的行
```

示例6：打印文件的行号
```
sed  -n "$="   1.txt   #打印1.txt文件最后一行的行号（即文件有多少行，和wc -l 功能类似）

sed  -n '/error/='  1.txt     #打印匹配error的行的行号

sed  -n '/error/{=;p}'   1.txt    #打印匹配error的行的行号和内容（可用于查看日志中有error的行及其内容）
```


示例7：从文件中读取内容
```
sed  'r 2.txt'  1.txt  #将文件2.txt中的内容，读入1.txt中，会在1.txt中的每一行后都读入2.txt的内容

sed '3r 2.txt'  1.txt       #在1.txt的第3行之后插入文件2.txt的内容（可用于向文件中插入内容）

sed  '/245/r   2.txt'   1.txt    #在匹配245的行之后插入文件2.txt的内容，如果1.txt中有多行匹配456则在每一行之后都会插入

sed  '$r  2.txt'   1.txt     #在1.txt的最后一行插入2.txt的内容
```

示例8：向文件中写入内容
```
sed  -n  'w 2.txt'   1.txt   #将1.txt文件的内容写入2.txt文件，如果2.txt文件不存在则创建，如果2.txt存在则覆盖之前的内容

sed   -n '2w  2.txt'   1.txt   #将文件1.txt中的第2行内容写入到文件2.txt

sed  -n -e '1w  2.txt'  -e '$w 2.txt'   1.txt   #将1.txt的第1行和最后一行内容写入2.txt

sed  -n -e '1w  2.txt'  -e '$w  3.txt'  1.txt   #将1.txt的第1行和最后一行分别写入2.txt和3.txt

sed  -n  '/abc\|123/w  2.txt'    1.txt   #将1.txt中匹配abc或123的行的内容，写入到2.txt中

sed  -n '/666/,$w 2.txt'   1.txt   #将1.txt中从匹配666的行到最后一行的内容，写入到2.txt中

sed  -n  '/xyz/,+2w  2.txt'     1.txt     #将1.txt中从匹配xyz的行及其后2行的内容，写入到2.txt中
```

## sed 在shell脚本中的使用

实例1：替换文件中的内容
```
#!/bin/bash
if [ $# -ne 3 ];then            #判断参数个数
  echo "Usage:  $0 old-part new-part filename"    #输出脚本用法
  exit
fi

sed -i "s#$1#$2#"  $3          #将 旧内容进行替换，当$1和$2中包含"/"时，替换指令中的定界符需要更换为其他符号
```


实例2：删除文件中的空白行
```
#!/bin/bash

if [ ! -f $1 ];then         #判断参数是否为文件且存在

   echo "$0 is not a file"

   exit

fi

sed -i "/^$/d"   $1 #将空白行删除
```

实例3：格式化文本内容
```
#!/bin/bash
a='s/^  *>//      #定义一个变量a保存sed指令，'s/^ *>//'：表示匹配以0个或多空格开头紧跟一个'>'号的行，将匹配内容替换
s/\t*//                 #'s/\t*//'：表示匹配以0个或多个制表符开头的行，将匹配内容替换

s/^>//               #'s/^>//' ：表示匹配以'>'开头的行，将匹配内容替换

s/^ *//'               #'s/^ *//'：表示匹配以0个或多个空格开头的行，将匹配内容替换
#echo $a
sed "$a" $1        #对用户给定的文本文件进行格式化处理
```

示例1：
```
#!/bin/bash
if [ $# -ne 2 ];then               #判断用户的输入，如果参数个数不为2则打印脚本用法
  echo "Usage:$0 + old-file new-file"
  exit
fi
for i in *$1*                         #对包含用户给定参数的文件进行遍历
do
  if [ -f $i ];then
     iname=`basename $i`        #获取文件名
     newname=`echo $iname | sed -e "s/$1/$2/g"`         #对文件名进行替换并赋值给新的变量
     mv  $iname  $newname          #对文件进行重命名
   fi
done

exit 666
```

示例2：
```
#!/bin/bash
read -p "input the old file:" old        #提示用户输入要替换的文件后缀
read -p "input the new file:" new
[ -z $old ] || [ -z $new ] && echo "error" && exit      #判断用户是否有输入，如果没有输入怎打印error并退出
for file in `ls *.$old`
do
  if [ -f $file ];then
     newfile=${file%$old}                        #对文件进行去尾
     mv $file ${newfile}$new                   #文件重命名
  fi

done
```


示例3：
```
#!/bin/bash

if [ $# -ne 2 ];then        #判断位置变量的个数是是否为2
   echo "Usage:$0  old-file  new-file"
   exit
fi
for file in `ls`                      #在当前目录中遍历文件
do
  if [[ $file =~ $1$ ]];then   #对用户给出的位置变量$1进行正则匹配，$1$表示匹配以变量$1的值为结尾的文件
     echo $file                      #将匹配项输出到屏幕进行确认
     new=${file%$1}             #对文件进行去尾处理，去掉文件后缀保留文件名，并将文件名赋给变量new                  
     mv $file ${new}$2          #将匹配文件重命名为：文件名+新的后缀名
  fi

done
```


示例4：使用sed匹配文件中的IP地址
```
sed -nr  '/([0-9]{1,3}\.){3}([0-9]{1,3})/p'  1.txt
```
