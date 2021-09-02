### conf.ini 解析器

```go
package main

import (
	"fmt"
	"io/ioutil"
	"reflect"
	"strconv"
	"strings"
)

type MysqlConfig struct {
	Address  string `ini:"address"`
	Port     int `ini:"port"`
	Username string `ini:"username"`
	Password string `ini:"password"`
}

type Redis struct {
	Host     string `ini:"host"`
	Port     int `ini:"port"`
	Password string `ini:"password"`
	Database string `ini:"database"`
}

type Config struct {
	MysqlConfig `ini:"mysql"`
	Redis       `ini:"redis"`
}

func loadIni(filePath string, data interface{}) (err error) {
	/*
		1 参数校验
			1.1 data为指针类型, 因为需要满足 setability
			1.2 data为结构体指针
		2 读取文件,得到字节切片
		3 按行读取数据
		4 如果是注解 ; # 就掉过
		5 如果是 [ 开头表示遇到了新的节点
		6 如果不是[开头, 按照 = 分隔取值
	*/

	// Config中单个配置节点的名称
	var structName string
    // 判断类型, 使用Typeof
	dataType := reflect.TypeOf(data)
	if dataType.Kind() != reflect.Ptr && dataType.Elem().Kind() != reflect.Struct {
		err = fmt.Errorf("为了能将解析出的值返回给您, 请传入结构体指针")
	}
    // ioutil.ReadFile(path) 一次性将配置文件读取出来
	bytes, err2 := ioutil.ReadFile(filePath)
	if err2 != nil {
		fmt.Printf("error: %v\n", err)
		return
	}
    // 使用strings工具, 将读取到的字节流按照 \r\n 回车换行切割(windows)
	lines := strings.Split(string(bytes), "\r\n")

	for index, line := range lines {
		line = strings.TrimSpace(line)
		// 解析注释和空行
		if strings.HasPrefix(line, ";") || strings.HasPrefix(line, "#") || line == "" {
			continue
		} else if strings.HasPrefix(line, "[") { // 解析 [ 开头的行

			// 校验节点语法声明节点
			if line[0] == '[' && line[len(line)-1] != ']' {
				err = fmt.Errorf("配置文件第%d行出现语法错误", index+1)
				return
			}
			if line[0] == '[' && line[len(line)-1] == ']' && len(line) < 2 {
				err = fmt.Errorf("配置文件第%d行出现语法错误, 节点名不能为空", index+1)
				return
			}

			// 解析出节点名称
			sectionName := strings.TrimSpace(line[1 : len(line)-1])
			// 通过反射解析 data , 然后将值给他填充上
			for i := 0; i < dataType.Elem().NumField(); i++ {
				field := dataType.Elem().Field(i)
				// todo 如果当前节点的名字 和 用户传递传递进来的结构体指针中封装的结构体相同, 先暂存一下这个节点的名字, 后续
				// 对比解析出来的配置文件中的[name] name 和 通过反射从结构体的ini部分取出的值,
				// 如果相同, 那么就保存下当前结构体的名字, 因为通过反射创建出data对象之后, 需要根据这个名字获取出具体的字段, 再填充上配置文件中的值
				// 比如: 从配置文件中解析出 mysql , 通过反射创建出 Config , 取出Config第一个属性的ini也是mysql , 于是我们就将mysql对应的属性名: MysqlcConfig保存下来
				// 因为后续我们解析出 username=root时, 需要将值赋值给MysqlConfig, 但是它是从Config中通过FieldByName获取出来的, 这个name就是前面存储的 structName
				if sectionName == field.Tag.Get("ini") {
					// 从config的封装结构体中找出mysql,redis的配置项
					structName = field.Name
				}
			}
		} else { //节点名称没有出先语法错误, 处理 key=value 格式的行

			// 检查语法, 不包含 = , 报错
			if strings.Index(line, "=") == -1{
				err = fmt.Errorf("配置文件第%d行出现语法错误, 格式应该为 key=value", index+1)
				return
			}
			// 根据=切割行
			splitLine := strings.Split(line, "=")
			key:=strings.TrimSpace(splitLine[0])
			value:=strings.TrimSpace(splitLine[1])
			// 检查语法
			if key==""||value==""{
				err = fmt.Errorf("配置文件第%d行出现语法错误, 格式应该为 key=value", index+1)
				return
			}

			// 反射创建用户传递进来的结构体指针, 准备初始化
			v := reflect.ValueOf(data)
			structObjValue := v.Elem().FieldByName(structName) // 嵌套结构体 , 现在是空值, 再往下执行给他初始化

			// 参数校验: 确定它是结构体类型, 才做后续的初始化
			if structObjValue.Kind() != reflect.Struct{
				err = fmt.Errorf("data中的%s 应该是结构体变量...",structName)
				return
			}

			//  从结构体中的ini中找到和当前行属性名相同的行
			for i:=0;i < structObjValue.NumField() ;i++{
				field:=structObjValue.Type().Field(i)
				if 	field.Tag.Get("ini") == key{
					// 初始化
					switch structObjValue.FieldByName(field.Name).Kind() {
					case reflect.String:
						structObjValue.Field(i).SetString(value)
					case reflect.Int, reflect.Int8, reflect.Int16, reflect.Int32, reflect.Int64:
						var parseInt  int64
						parseInt, error := strconv.ParseInt(value, 10,64)
						if error != nil {
							error = fmt.Errorf("第%d行, error: %v\n", err,index+1)
							return
						}
						structObjValue.Field(i).SetInt(parseInt)
					}
					break
				}
			}
		}
	}
	return
}

func main() {

	var config Config
	err := loadIni("E:\\GO\\src\\code.github.com\\changwu\\2020-03-17\\parseIni\\conf.ini", &config)
	if err != nil {
		fmt.Printf("error: %v\n", err)
		return
	}
}

```

