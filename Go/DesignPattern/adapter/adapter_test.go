/**
* @Author:zhoutao
* @Date:2020/12/11 下午1:52
* @Desc:
 */

package adapter

import "testing"

var expect = "adaptee method被适配器方法"

func TestAdapter(t *testing.T) {
	adaptee := NewAdaptee()
	target := NewAdapter(adaptee)
	res := target.Request()
	if res != expect {
		t.Fatalf("expect %s,return %s", expect, res)
	}
}
