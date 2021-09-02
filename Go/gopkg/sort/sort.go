package main

import (
	"fmt"
	"sort"
)

func main() {

	//
	// 数据排序
	//
	nums := []int{-10, 2, 1, 100, -20}
	sort.Ints(nums)
	fmt.Println(nums, sort.IntsAreSorted(nums)) // [-20 -10 1 2 100] true

	fs := []float64{1.2, 100, 0.2, -1.1}
	sort.Float64s(fs)                           // 升序排列
	fmt.Println(fs, sort.Float64sAreSorted(fs)) // [-1.1 0.2 1.2 100] true

	fmt.Println(sort.IsSorted(sort.IntSlice(nums))) // true
	fmt.Println(sort.Reverse(sort.IntSlice(nums)))  // &{[-20 -10 1 2 100]}

	//
	// 对于自定义的数据类型 type、struct 等
	// 只需要满足以下三个函数，即可使用 sort 包的排序
	// Len() int
	// Less(i, j int) bool
	// Swap(i, j int)
}
