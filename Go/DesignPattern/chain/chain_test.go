/**
* @Author:zhoutao
* @Date:2020/12/13 上午9:50
* @Desc:
 */

package chain

func ExampleChain() {

	//创建好每个节点的Manager
	chain1 := NewProjectManagerChain()
	chain2 := NewDepManagerChain()
	chain3 := NewGeneralManagerChain()

	//connected r Chain with m Chain
	chain1.SetSuccessor(chain2)
	chain2.SetSuccessor(chain3)

	var c Manager = chain1

	c.HandleFeeRequest("bob", 400)    //Project
	c.HandleFeeRequest("tom", 1400)   //Dep
	c.HandleFeeRequest("fool", 10000) //General
	//
	c.HandleFeeRequest("tony", 300) //Project

}
