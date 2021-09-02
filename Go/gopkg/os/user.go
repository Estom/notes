// os/user 提供与系统用户相关的查询接口
package main

import (
	"fmt"
	"os/user"
)

func main() {
	// 获取系统当前的用户信息
	u, _ := user.Current()
	fmt.Printf("%+v\n", u) // &{Uid:501 Gid:20 Username:wuyin Name:wuyin HomeDir:/Users/wuyin}

	_, err := user.Lookup("demo") // 根据用户名查找用户
	fmt.Println(err)              // user: unknown user demo

	user, err := user.LookupId("501")
	fmt.Println(user.Name)
}
