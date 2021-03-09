datetime 模块
datetime 模块用来完成日期和时间的解析、格式化和算术运算等。
In: import datetime

In: now = datetime.datetime.now() # 获取当前时间
In: now
Out: datetime.datetime(2018, 4, 14, 21, 49, 7, 733048)

In: now.year, now.month, now.day, now.hour, now.minute
Out: (2018, 4, 14, 21, 49)

In: today = datetime.date.today()
In: today
Out: datetime.date(2018, 4, 14)
In: today.year, today.month, today.day
Out: (2018, 4, 14)

In: d1 = datetime.date(2010, 9, 1)
In: d1
Out: datetime.date(2010, 9, 1)

# 可以使用 datetime.timedelta 对象进行时间的运算, 支持秒、分钟、小时、天、周
In : print('seconds :', datetime.timedelta(seconds=1))
...: print('minutes :', datetime.timedelta(minutes=1))
...: print('hours :', datetime.timedelta(hours=1))
...: print('days :', datetime.timedelta(days=1))
...: print('weeks :', datetime.timedelta(weeks=1))
...:
Out:
seconds : 0:00:01
minutes : 0:01:00
hours : 1:00:00
days : 1 day, 0:00:00
weeks : 7 days, 0:00:00

In: hour = datetime.timedelta(hours=1)
In: hour.total_seconds
Out: <built-in method total_seconds of datetime.timedelta object at 0x0000028F5609F418>
In hour.total_seconds() # 获得一个小时的秒数
Out: 3600.0

In: today = datetime.date(2010, 9, 1)
In: today + datetime.timedelta(days=1) # 加上一天
Out: datetime.date(2010, 9, 2)
In: today - datetime.timedelta(days=1) # 减去一天
Out: datetime.date(2010, 8, 31)

时间格式化
In: dt_format = '%Y-%m-%d %H:%M:%S'

In: s = datetime.datetime.now().strftime(dt_format)
In: print('strftime:'s)
Out: strftime: 2018-04-14 22:17:27

In: d = datetime.datetime.strptime(s, dt_format)
In: print('strptime:', d)
Out: strptime: 2018-04-14 22:17:27

In: d
Out: datetime.datetime(2018, 4, 14, 22, 17, 27)

作者：江洋林澜
链接：https://www.jianshu.com/p/87a40fbac17f
來源：简书
简书著作权归作者所有，任何形式的转载都请联系作者获得授权并注明出处。