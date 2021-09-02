/**
* @Author:zhoutao
* @Date:2020/12/12 下午2:16
* @Desc:
 */

package state

import "fmt"

//状态模式：用于分离 状态和行为

type Week interface {
	Today()
	Next(*DayContext)
}

//
func NewTodayContext() *DayContext {
	return &DayContext{
		today: &Sunday{},
	}
}

type DayContext struct {
	today Week
}

func (d *DayContext) Today() {
	d.today.Today()
}

func (d *DayContext) Next() {
	d.today.Next(d)
}

//sunday
type Sunday struct {
}

func (*Sunday) Today() {
	fmt.Print("sunday\n")
}

func (*Sunday) Next(ctx *DayContext) {
	ctx.today = &Monday{}
}

//Monday
type Monday struct {
}

func (*Monday) Today() {
	fmt.Print("Monday\n")
}

func (*Monday) Next(ctx *DayContext) {
	ctx.today = &Tuesday{}
}

//Tuesday
type Tuesday struct {
}

func (*Tuesday) Today() {
	fmt.Print("Tuesday\n")
}

func (*Tuesday) Next(ctx *DayContext) {
	ctx.today = &Wednesday{}
}

type Wednesday struct{}

func (*Wednesday) Today() {
	fmt.Printf("Wednesday\n")
}

func (*Wednesday) Next(ctx *DayContext) {
	ctx.today = &Thursday{}
}

type Thursday struct{}

func (*Thursday) Today() {
	fmt.Printf("Thursday\n")
}

func (*Thursday) Next(ctx *DayContext) {
	ctx.today = &Friday{}
}

type Friday struct{}

func (*Friday) Today() {
	fmt.Printf("Friday\n")
}

func (*Friday) Next(ctx *DayContext) {
	ctx.today = &Saturday{}
}

type Saturday struct{}

func (*Saturday) Today() {
	fmt.Printf("Saturday\n")
}

func (*Saturday) Next(ctx *DayContext) {
	ctx.today = &Sunday{}
}
