/**
* @Author:zhoutao
* @Date:2020/12/12 上午10:49
* @Desc:
 */

package observer

func ExampleObserver() {
	Subject := NewSubject()

	reader1 := NewReader("reader1")
	reader2 := NewReader("reader2")
	reader3 := NewReader("reader3")

	Subject.Attach(reader1)
	Subject.Attach(reader2)
	Subject.Attach(reader3)

	//update and notify all obervers
	Subject.UpdateContext("observer mode")

}
