package buidler

//builder模式适用的场景：无法或者不想一次性把实例的所有属性都给出，而是要分批次、分条件构造

// 不是这样 a:=SomeStruct{1,2,"hello"}

//而是这样
/*
a:=SomeStruct{}
a.setAge(1)
a.setMonth(2)
if(situation){
	a.setSomething("hello")
}

*/

//builder模式除了上边的形式，还有一种变种，那就是链式(在每个函数最后返回实例自身)
/*
a:=SomeStruct{}
a = a.setAge(1).setMonth(2).setSomething("hello")
*/

//生成器接口
type Builder interface {
	Part1()
	Part2()
	Part3()
}

//
func NewDirector(builder Builder) *Director {
	return &Director{
		builder: builder,
	}
}

type Director struct {
	builder Builder
}

func (d *Director) Construct() {
	d.builder.Part1()
	d.builder.Part2()
	d.builder.Part3()

}

//
type Builder1 struct {
	result string
}

func (b *Builder1) Part1() {
	b.result += "1"
}

func (b *Builder1) Part2() {
	b.result += "2"
}

func (b *Builder1) Part3() {
	b.result += "3"
}

func (b *Builder1) GetResult() string {
	return b.result
}

//
type Builder2 struct {
	result int
}

func (b *Builder2) Part1() {
	b.result += 1
}

func (b *Builder2) Part2() {
	b.result += 2
}

func (b *Builder2) Part3() {
	b.result += 3
}

func (b *Builder2) GetResult() int {
	return b.result
}
