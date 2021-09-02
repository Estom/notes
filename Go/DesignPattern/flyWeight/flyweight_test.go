/**
* @Author:zhoutao
* @Date:2020/12/11 下午3:27
* @Desc:
 */

package flyWeight

import "testing"

func TestFlyWeight(t *testing.T) {
	viewer1 := NewImageViewr("image1.png")
	viewer2 := NewImageViewr("image1.png")
	if viewer1.ImageFlyWeight != viewer2.ImageFlyWeight {
		t.Fail()
	}
}
