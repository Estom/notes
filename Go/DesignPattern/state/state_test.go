/**
* @Author:zhoutao
* @Date:2020/12/12 下午2:53
* @Desc:
 */

package state

func ExampleWeek() {
	ctx := NewTodayContext()
	todayAndNext := func() {
		ctx.Today()
		ctx.Next()
	}

	for i := 0; i < 8; i++ {
		todayAndNext()
	}

}
