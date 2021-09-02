package main

import (
	"fmt"
	"math"
	"reflect"
)

func main() {

	//
	// make new copy equal	等基本操作的实现
	//
	u := User{}
	fmt.Println(reflect.TypeOf(u).Kind(), reflect.ValueOf(u).Kind()) // struct struct
	// MakeSlice
	var s []string
	rs := reflect.MakeSlice(reflect.TypeOf(s), 0, 10) //
	fmt.Println(rs.Kind(), rs.Len(), rs.Cap())        // slice 0 10
	// MakeMap
	var m map[int]string
	fmt.Println(reflect.TypeOf(m).Key())                       // int
	rm := reflect.MakeMap(reflect.TypeOf(m))                   // TypeOf == reflect.Indirect(reflect.valueOf(&m)).Type()
	rm.SetMapIndex(reflect.ValueOf(1), reflect.ValueOf("one")) // 设置 map 的值
	fmt.Println(rm.Kind(), rm.Interface())                     // map map[1:one]
	counts := map[int]string{
		1: "one",
		2: "two",
	}
	countVal := reflect.ValueOf(counts)
	keys := countVal.MapKeys() // 无顺序获取 map 所有的 key
	for _, k := range keys {
		fmt.Println(k.Int())              // 1 2
		fmt.Println(countVal.MapIndex(k)) // one two	// 获取 map 上的值
	}
	// MakeChan
	var ch chan int
	v := reflect.ValueOf(ch)
	nChan := reflect.MakeChan(v.Type(), 10)             // 指定 channel 类型（chan TYPE）初始化缓冲 channel
	fmt.Println(nChan.Kind(), nChan.Len(), nChan.Cap()) // chan 0 10
	fmt.Println(nChan.Type().ChanDir())                 // 返回 channel 的方向：双向、send、recv
	nChan.Close()                                       // channel.Close
	// MakeFunc	// RPC 利器
	makeSwap := func(fPtr interface{}) {
		rf := reflect.Indirect(reflect.ValueOf(fPtr)) // 取到函数指针指向的值
		v := reflect.MakeFunc(rf.Type(), swap)        // 创建绑定者类型的新函数 // 此处有点实现泛型的意思
		rf.Set(v)                                     // 修改未初始化的函数实现
	}
	var intSwap func(int, int) (int, int)
	makeSwap(&intSwap)
	fmt.Println(intSwap(1, 2)) // 2 1

	// new
	newS := reflect.New(reflect.TypeOf(s)) //
	fmt.Println(newS.Kind())               // ptr	// 指向被初始化的零值

	// append
	nums := make([]int, 0, 2)
	rNums := reflect.ValueOf(&nums)
	if !rNums.CanSet() { // 判断值是否可寻址
		rNums = rNums.Elem() // 使 rNums 指向数据的内存地址，修改数据
	}
	rNums = reflect.Append(rNums, reflect.ValueOf(1))                // 第二个参数必须是单个 Value
	rNums = reflect.AppendSlice(rNums, reflect.ValueOf([]int{2, 3})) // 第二个参数必须是 slice Value

	// copy
	_ = reflect.Copy(rNums, reflect.ValueOf([]int{4, 5})) // [4 5 3]	// dst 和 src 必须拥有同样的类型

	// 深度比较
	u1, u2 := User{0, "Ken", 20}, User{0, "Ken", 20}
	p1 := Person{"Ken", 20}
	fmt.Println(reflect.DeepEqual(u1, u2)) // true	// 深度扫描数组、slice、map、struct 字段等，若类型和值都相同则相等
	fmt.Println(reflect.DeepEqual(u2, p1)) // false

	// 指针操作
	n := 10
	rn := reflect.ValueOf(&n)
	fmt.Println(rn.Kind())                               // ptr
	fmt.Println(reflect.Indirect(rn).Kind())             // int		// 获取指针指向的值
	fmt.Println(rNums.Kind())                            // slice
	fmt.Println(rNums.Slice(0, rNums.Len()).Interface()) // [1]		// slice 值的转化

	//
	// Type 操作
	//
	uType := reflect.TypeOf(u)
	fmt.Println(uType.PkgPath())               // main
	fmt.Println(uType.Name())                  // User
	fmt.Println(uType.String())                // main.User
	fmt.Println(uType.NumField())              // 3	// 不导出字段也可识别出
	fmt.Println(uType.Method(0).Type)          // func(main.User) string	// 函数类型					// 随意获取方法的参数、返回值
	fmt.Println(uType.Method(0).Type.NumIn())  // 1	// 返回传入参数的数量		// 注意：调用者也算一个
	fmt.Println(uType.Method(0).Type.In(0))    // main.User
	fmt.Println(uType.Method(0).Type.NumOut()) // 1	// 返回返回值的数量
	fmt.Println(uType.Method(0).Type.Out(0))   // string

	var c Color
	fmt.Println(reflect.TypeOf(c).Size())                // 40	// 返回值存储的字节数
	fmt.Println(reflect.TypeOf(n).Bits())                // 64	// 返回类型的位数
	fmt.Println(reflect.TypeOf(c).AssignableTo(uType))   // false	// 判断两种类型之间是否能相互赋值
	fmt.Println(uType.ConvertibleTo(reflect.TypeOf(u2))) // true	// 判断两种类型之间是否能相互转换

	x := 1
	xPtr := reflect.ValueOf(&x)
	fmt.Println(xPtr, xPtr.Kind())               // 0xc420016208 ptr
	fmt.Println(xPtr.Elem(), xPtr.Elem().Kind()) // 1 int												// Elem() 很有用，能直接获取指针指向的值

	//
	// Value 操作
	//
	x = 100
	xPtr = reflect.ValueOf(&x)
	fmt.Println(xPtr)                                  // 0xc4200161e0
	fmt.Println(xPtr.Pointer())                        // 842350551520	// 返回指针的整型值
	fmt.Println(xPtr.IsNil())                          // false			// 判断某个值是否为空。只能在 chan func interface map ptr slice 类型上使用
	fmt.Println(xPtr.CanAddr(), xPtr.Elem().CanAddr()) // false true	// 判断某个值是否为可寻址的
	fmt.Println(xPtr.CanSet(), xPtr.Elem().CanSet())   // false true	// 判断某个值是否可以修改
	fmt.Println(xPtr.Elem().Addr())                    // 0xc4200161e0
	fmt.Println(xPtr.Elem().Int())                     // 100			// 返回值的 int 值，若断言出错则 panic
	var t bool
	fmt.Println(reflect.ValueOf(&t).Elem().Bool()) // false	// 将 Elem 指向的值按照指定的类型取出

	// 函数调用
	sumVal := reflect.ValueOf(sum)
	inArgs := []reflect.Value{reflect.ValueOf(1), reflect.ValueOf(2)} // 构建入参
	out := sumVal.Call(inArgs)                                        // 直接调用函数
	fmt.Println(out[0].Int())                                         // 3

	//
	// struct 操作
	//
	// 字段
	var gray = Color{"gray", RGB{0, 255, 255}}
	grayType := reflect.TypeOf(gray)
	for i := 0; i < grayType.NumField(); i++ {
		field := grayType.Field(i)
		fmt.Println(field.Name, field.Type, field.Tag) // Name string	RGB main.RGB	// 获取字段的类型信息	// type 偏重于类型相关的信息
	}
	grayVal := reflect.ValueOf(gray)
	for i := 0; i < grayVal.NumField(); i++ {
		field := grayVal.Field(i)
		fmt.Println(field.Kind(), field.Interface()) // string gray	struct {0 255 255}	// 获取字段的值信息	// Value 偏重于值相关的信息
	}
	fmt.Printf("%+v\n", grayType.FieldByIndex([]int{1, 2})) // 获取嵌套的 struct 中的字段	//  {Name:green PkgPath:main Type:int Tag: Offset:16 Index:[2] Anonymous:false}
	field, ok := grayType.FieldByName("Name")               // {Name:Name PkgPath: Type:string Tag: Offset:0 Index:[0] Anonymous:false}
	if ok {
		fmt.Printf("%+v\n", field)
	}

	// 方法
	for i := 0; i < uType.NumMethod(); i++ {
		method := uType.Method(i)
		fmt.Println(method.Name, method.Type) // GetName func(main.User) string		// 没有私有方法 setAge
	}
	u.Name = "fff"
	uVal := reflect.ValueOf(u)
	for i := 0; i < uVal.NumMethod(); i++ {
		method := uVal.Method(i)
		fmt.Println(method.Call(nil)) // [fff]	// 同样忽略掉私有方法
	}
	fmt.Println(uType.MethodByName("GetName")) // {GetName  func(main.User) string <func(main.User) string Value> 0} true
	fmt.Println(uType.MethodByName("setAge"))  // {  <nil> <invalid Value> 0} false

	//
	// 其他操作
	//
	// 类型转换
	newX := reflect.ValueOf(x).Convert(reflect.TypeOf("str"))   // ok	// int -> string	// 不允许转换则 panic
	fmt.Println(newX.Kind(), newX.String())                     // string d
	fmt.Println(reflect.ValueOf(nil).IsValid())                 // false					// 若 v 代表一个值，则返回 true
	fmt.Println(reflect.ValueOf(nil).Kind() == reflect.Invalid) // true

	// 溢出检测
	var mid int32
	midVal := reflect.ValueOf(mid)
	fmt.Println(midVal.OverflowInt(math.MaxInt32 + 1)) // true	// 值超出了 val 能表示的范围

	// 类型零值
	fmt.Println(reflect.Zero(reflect.TypeOf(u))) // {0  0}
}

type User struct {
	id   int    `uid`
	Name string `json:"name"`
	Age  int    `json:"age"`
}

func (u User) GetName() string {
	return u.Name
}

func (u User) setAge(n int) {
	u.Age = n
}

type Person struct {
	Name string
	Age  int
}

type Color struct {
	Name string
	RGB
}

type RGB struct {
	Red   int
	Blue  int
	green int
}

func sum(x, y int) int {
	return x + y
}

func swap(in []reflect.Value) []reflect.Value {
	return []reflect.Value{in[1], in[0]}
}
