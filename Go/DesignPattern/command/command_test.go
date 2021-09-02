/**
* @Author:zhoutao
* @Date:2020/12/12 上午11:40
* @Desc:
 */

package command

//将"方法调用"封装到对象中，方便传输、调用、存储
func ExampleCommand() {
	mb := &MotherBoard{}

	startCommand := NewStartCommand(mb)
	rebootCommond := NewRebootCommand(mb)

	box1 := NewBox(startCommand, rebootCommond)
	box1.PressButton1()
	box1.PressButton2()
	//output:
	//system starting
	//system rebooting

	box2 := NewBox(rebootCommond, startCommand)
	box2.PressButton1()
	box2.PressButton2()
	//output:
	//system rebooting
	//system starting
}
