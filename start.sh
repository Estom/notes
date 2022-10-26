# 将笔记推送到不同的仓库中
git push git@github.com:Estom/notes.git
git push git@github.com:Estom/notes.git


# 统计代码的数量
find . -name "*.java" -exec wc -l  {} \;#利用exec参数
find . -name "*.java" |xargs wc -l # 利用xargs参数
find . -name "*.java" -exec wc -l  {} \; | awk 'BEGIN{num=0} {num+=$1;print $1;}END{print num}'

# 查看今天的日志
find . -name "*.log" | xargs grep "wrod"
