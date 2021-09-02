/**
* @Author:zhoutao
* @Date:2020/12/11 下午3:46
* @Desc:
 */

package decorator

import (
	"testing"
)

func TestDecrator(t *testing.T) {
	var c Component = &ConcreteComponent{}
	c = WarpAddDecrator(c, 10)
	c = WarpMulDecorator(c, 8)
	res := c.Calc()
	if res != 80 {
		t.Fatalf("expect 80 ,return %d", res)
	}

}
