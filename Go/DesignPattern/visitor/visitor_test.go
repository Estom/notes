/**
* @Author:zhoutao
* @Date:2020/12/13 上午10:31
* @Desc:
 */

package visitor

func ExampleRequestVisitor() {
	c := CustomerCol{}
	c.Add(NewEnterpriseCustomer("NO.1"))
	c.Add(NewEnterpriseCustomer("NO.2"))
	c.Add(NewIndividualCustomer("bob"))
	c.Accept(&ServiceRequestVisitor{})
	//output :
	// enterprise
	// enterprise
	// individual
}

func ExampleAnalisis() {
	c := CustomerCol{}
	c.Add(NewEnterpriseCustomer("A"))
	c.Add(NewIndividualCustomer("B"))
	c.Add(NewEnterpriseCustomer("C"))
	c.Accept(&AnalisisVisitor{})
	//output :
	// enterprise
	// enterprise

}
