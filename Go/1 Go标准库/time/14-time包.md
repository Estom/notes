# 14 time

基于 原文[《Go语言基础之time包》](https://www.liwenzhou.com/posts/Go/go_time/) 和视频内容整理。

time 包提供了时间的显示和测量用的函数。日历的计算采用的是公历。

## 14.1 时间类型

`time.Time` 类型表示时间。我们可以通过 `time.Now()` 函数获取当前的时间对象，然后获取时间对象的年月日时分秒等信息。示例代码如下：

```go
func timeDemo() {
	//获取当前时区的当前时间
	now := time.Now() 
	fmt.Printf("current time:%v\n", now)

	year := now.Year()     //年
	month := now.Month()   //月
	day := now.Day()       //日
	hour := now.Hour()     //小时
	minute := now.Minute() //分钟
	second := now.Second() //秒
	fmt.Printf("%d-%02d-%02d %02d:%02d:%02d\n", year, month, day, hour, minute, second)
}
```

## 14.2 时间戳

时间戳是自1970年1月1日（08:00:00GMT）至当前时间的总**毫秒数**。它也被称为 Unix 时间戳（UnixTimestamp）。

* 基于时间对象获取时间戳的示例代码如下：

```go
func timestampDemo() {
	now := time.Now()            //获取当前时间
	timestamp1 := now.Unix()     //时间戳
	timestamp2 := now.UnixNano() //纳秒时间戳
	fmt.Printf("current timestamp1:%v\n", timestamp1)
	fmt.Printf("current timestamp2:%v\n", timestamp2)
}

func timeStamp2() {
	fmt.Printf("时间戳（秒）：%v;\n", time.Now().Unix())
	fmt.Printf("时间戳（纳秒）：%v;\n",time.Now().UnixNano())
	fmt.Printf("时间戳（毫秒）：%v;\n",time.Now().UnixNano() / 1e6)
	fmt.Printf("时间戳（纳秒转换为秒）：%v;\n",time.Now().UnixNano() / 1e9)
}
```

* 使用 `time.Unix()`函数可以将时间戳转为时间格式。

```go
func timestampDemo2(timestamp int64) {
	timeObj := time.Unix(timestamp, 0) //将时间戳转为时间格式
	fmt.Println(timeObj)
	year := timeObj.Year()     //年
	month := timeObj.Month()   //月
	day := timeObj.Day()       //日
	hour := timeObj.Hour()     //小时
	minute := timeObj.Minute() //分钟
	second := timeObj.Second() //秒
	fmt.Printf("%d-%02d-%02d %02d:%02d:%02d\n", year, month, day, hour, minute, second)
}
```

## 14.3 时间间隔

`time.Duration` 是 time 包定义的一个类型，它代表两个时间点之间经过的时间，以**纳秒**为单位。

`time.Duration` 表示一段时间间隔，可表示的最长时间段大约290年。

time 包中定义的时间间隔类型的常量如下：

```go
const (
    Nanosecond  Duration = 1
    Microsecond          = 1000 * Nanosecond
    Millisecond          = 1000 * Microsecond
    Second               = 1000 * Millisecond
    Minute               = 60 * Second
    Hour                 = 60 * Minute
)
```

例如：`time.Duration` 表示1纳秒，`time.Second` 表示1秒。

## 14.4 时间操作

### 1.4.1 Add

我们在日常的编码过程中可能会遇到要求 `时间+时间间隔` 的需求，Go语言的时间对象有提供 Add 方法如下：

```go
func (t Time) Add(d Duration) Time
```

举个例子，求一个小时之后的时间：

```go
func main() {
	now := time.Now()
	later := now.Add(24 * time.Hour) // 当前时间加24小时后的时间
	fmt.Println(later)
}
```

### 14.4.2 Sub

求两个时间之间的差值：

```go
func (t Time) Sub(u Time) Duration
```

返回一个**时间段** `t-u` 。如果结果超出了 Duration 可以表示的最大值/最小值，将返回最大值/最小值。

要获取**时间点** `t-d`（d为Duration），可以使用 `t.Add(-d)`。


### 14.4.3 Equal

```go
func (t Time) Equal(u Time) bool
```

判断两个时间是否相同，会考虑时区的影响，因此不同时区标准的时间也可以正确比较。

本方法和用 `t==u` 不同，这种方法还会比较地点和时区信息。

### 14.4.4 Before

```go
func (t Time) Before(u Time) bool
```

如果 t 代表的时间点在 u 之前，返回真；否则返回假。

### 14.4.5 After

```go
func (t Time) After(u Time) bool
```

如果 t 代表的时间点在 u 之后，返回真；否则返回假。

## 14.5 定时器

使用 `time.Tick(时间间隔)` 来设置定时器，**定时器本质上是一个通道（channel）**。

```go
func tickDemo() {
	ticker := time.Tick(time.Second) //定义一个1秒间隔的定时器
	for i := range ticker {
		//因为上面的时间间隔定义为 time.Second 所以每秒都会执行的任务
		fmt.Println(i)
	}
}
```

运行之后，将输出如下格式的内容：

```go
2020-09-15 08:22:09.906515 +0800 CST m=+1.001907219
2020-09-15 08:22:10.905672 +0800 CST m=+2.001090754
2020-09-15 08:22:11.905355 +0800 CST m=+3.000801291
2020-09-15 08:22:12.904676 +0800 CST m=+4.000149566
2020-09-15 08:22:13.905339 +0800 CST m=+5.000839685
```

## 14.6 时间格式化

时间类型有一个自带的方法 `Format` 进行格式化，需要注意的是 Go 语言中格式化时间模板不是常见的 `Y-m-d H:M:S` 而是使用 Go 的诞生时间 `2006年1月2号15点04分`（记忆口诀为2006 1 2 3 4）作为格式化模板。

### 14.6.1 时间格式化

如果想格式化为12小时方式，需指定PM。

```go
func formatDemo() {
	now := time.Now()
	// 格式化的模板为Go的出生时间2006年1月2号15点04分 Mon Jan
	// 24小时制，秒数后面的 .000 表示毫秒数
	fmt.Println(now.Format("2006-01-02 15:04:05.000 Mon Jan"))
	// 12小时制，需要指定 PM
	fmt.Println(now.Format("2006-01-02 03:04:05.000 PM Mon Jan"))
	fmt.Println(now.Format("2006/01/02 15:04"))
	fmt.Println(now.Format("15:04 2006/01/02"))
	fmt.Println(now.Format("2006/01/02"))
}
```


### 14.6.2 解析字符串格式的时间

```go
// 获取当前时区的当前时间
now := time.Now()
fmt.Println(now)
// 因为我们在东八区，所以需要加载 Shanghai 时区
loc, err := time.LoadLocation("Asia/Shanghai")
if err != nil {
	fmt.Println(err)
	return
}
// 按照指定时区和指定格式解析字符串时间. 传入的时间串格式必须和要解析成的模板格式一致
timeObj, err := time.ParseInLocation("2006/01/02 15:04:05", "2019/08/04 14:15:20", loc)
if err != nil {
	fmt.Println(err)
	return
}
fmt.Println(timeObj)
fmt.Println(timeObj.Sub(now))
```

## 14.7 sleep

```go
n := 100
// n 是 int 类型，Sleep 接收 Duration 类型， 所以需要强转。——Duration 本质是 int64 的别名
time.Sleep(time.Duration(n))
// 直接传入一个数值会自动转换为 Duration 类型
time.Sleep(100)
```

## 14.8 其他

### 14.8.1 获取月份的第一天和最后一天

```go
func getDate() {
	now := time.Now()
	currentYear, currentMonth, _ := now.Date()
	currentLocation := now.Location()

	// 获取某月的第一天和最后一天
	firstOfMonth := time.Date(currentYear, currentMonth, 1, 0, 0, 0, 0, currentLocation)
	lastOfMonth := firstOfMonth.AddDate(0, 1, -1)

	// 1609430400
	fmt.Println(firstOfMonth.Unix())
	// 1612022400
	fmt.Println(lastOfMonth.Unix())
}
```

## 练习题：

* 获取当前时间，格式化输出为 2017/06/19 20:30:05`格式。
* 编写程序统计一段代码的执行耗时时间，单位精确到微秒