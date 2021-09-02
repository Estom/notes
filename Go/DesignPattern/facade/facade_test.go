package facade

import "testing"

var expect = "A moudle running\nB module running"

func TestFacadeAPI(t *testing.T) {
	api := NewAPI()
	ret := api.Test()
	if ret != expect {
		t.Fatalf("expect %s,return %s", expect, ret)
	}
}
