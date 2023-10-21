https://commons.apache.org/
## 引入依赖
```xml
<!-- https://mvnrepository.com/artifact/org.apache.commons/commons-collections4 -->
<dependency>
    <groupId>org.apache.commons</groupId>
    <artifactId>commons-collections4</artifactId>
    <version>4.4</version>
</dependency>
```

## CollectionUtils 集合工具类
```
添加/删除:addAll/addIgnoreNull/retainAll/removeAll/
获取：
	find/get/containsAny/index/size/sizeIsEmpty/select/selectRejected/subtract
	typedCollection
判断： 
	isEmpty/isNotEmpty/isFull/exists/isEqualCollection/
	isSubCollection/isProperSubCollection 
转换： 
	collect/transform/transformedCollection/predicatedCollection
	unmodifiableCollection/synchronizedCollection 
计算：cardinality/countMatches/maxSize
过滤：filter
集合：intersection/union/disjunction  交集，并集，差集
其他操作：
   reverseArray  翻转  forAllDo 给每个元素执行闭包
   getCardinalityMap 转成Map,key是元素，value是次数
```

## ListUtils-List工具类
```
判断： isEqualList
集合：intersection/sum/union/retainAll 交集，并集，合集，差集
操作：removeAll/hashCodeForList
子集： typedList/subtract/fixedSizeList
转换处理：synchronizedList/unmodifiableList/predicatedList/transformedList/lazyList
```

## SetUtils-Set集合工具类
```
判断：isEqualSet
转换处理：
		transformedSet/transformedSortedSet/predicatedSet/predicatedSortedSet
		unmodifiableSet/synchronizedSet/synchronizedSortedSet
		orderedSet/typedSet/typedSortedSet
操作：hashCodeForSet
```

## MapUtils-Map工具类
```
获取：getObject/getString/getXXX/getXXXValue  获取指定类型值，getXXXValue 如果没有值则默认值
子集：fixedSizeMap/fixedSizeSortedMap/typedMap/typedSortedMap
判断：isEmpty/isNotEmpty
转换：
	predicatedMap/predicatedSortedMap/transformedMap/transformedSortedMap/
	synchronizedMap/synchronizedSortedMap/
	unmodifiableMap/unmodifiableSortedMap/multiValueMap/orderedMap
	toMap/toProperties/lazyMap/lazySortedMap
添加移除：safeAddToMap/putAll
其他操作：invertMap/debugPrint/verbosePrint
```