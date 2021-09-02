/**
* @Author:zhoutao
* @Date:2020/12/12 下午2:06
* @Desc:
 */

package strategy

func ExamplePayByCash() {
	payment := NewPayment("ad", "808490523", 900, &Cash{})
	payment.Pay()
	//Output:
	//Pay by cash

}

func ExamplePayByBank() {
	payment := NewPayment("tom", "345782345", 900, &Bank{})
	payment.Pay()
}
