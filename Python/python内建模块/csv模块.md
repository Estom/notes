csv 模块
逗号分隔值（Comma-Separated Values，CSV，有时也称为字符分隔值，因为分隔字符也可以不是逗号），其文件以纯文本形式存储表格数据（数字和文本）。 纯文本意味着该文件是一个字符序列，不含必须像二进制数字那样被解读的数据。
>>> with open('test.csv', 'wt') as f:
...     writer = csv.writer(f) # 把文件对象传给 csv.writer()
...     writer.writerow(('ID', '用户', '类型')) # 写入标题
...     for i in range(5):
...         row = (i, f'用户{i}', f'类型{i}')
...         writer.writerow(row)

In: cat test.csv
Out:
ID,用户,类型
0,用户0,类型0
1,用户1,类型1
2,用户2,类型2
3,用户3,类型3
4,用户4,类型4

>>> with open('test.csv', 'rt') as f:
...     reader = csv.reader(f)
...     for line in reader:
...         print(line)

# 输出:
['ID', '用户', '类型']
['0', '用户0', '类型0']
['1', '用户1', '类型1']
['2', '用户2', '类型2']
['3', '用户3', '类型3']
['4', '用户4', '类型4']

>>> with open('test.csv', 'rt') as f:
...     reader = csv.DictReader(f) # 键为第一行写入的键名, 值是对应的字段的值
...     for line in reader:
...         print(line)
...         print(line['类型'])

# 输出:

OrderedDict([('ID', '0'), ('用户', '用户0'), ('类型', '类型0')])
类型0
OrderedDict([('ID', '1'), ('用户', '用户1'), ('类型', '类型1')])
类型1
OrderedDict([('ID', '2'), ('用户', '用户2'), ('类型', '类型2')])
类型2
OrderedDict([('ID', '3'), ('用户', '用户3'), ('类型', '类型3')])
类型3
OrderedDict([('ID', '4'), ('用户', '用户4'), ('类型', '类型4')])
类型4

作者：江洋林澜
链接：https://www.jianshu.com/p/87a40fbac17f
來源：简书
简书著作权归作者所有，任何形式的转载都请联系作者获得授权并注明出处。