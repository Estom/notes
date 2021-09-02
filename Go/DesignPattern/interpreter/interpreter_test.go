/**
* @Author:zhoutao
* @Date:2020/12/12 下午3:35
* @Desc:
 */

package interpreter

import "testing"

func TestInterpreter(t *testing.T) {
	p := Parser{}
	p.Parse("1 + 2 + 3 - 4 + 5 - 6")
	res := p.Result().Interpret()
	expect := 1
	if res != expect {
		t.Fatalf("expect %d got %d", expect, res)
	}
}
