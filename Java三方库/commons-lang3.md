
## 引入依赖
```
<dependency>
    <groupId>org.apache.commons</groupId>
    <artifactId>commons-lang3</artifactId>
    <version>3.12.0</version>
</dependency>
```
## 数据类型工具类
### StringUtils 字符串工具类
```java
包含判断方法：contains/containsXXX 
字符串替换方法：replace/replaceXXX 
获取子串：substring/substringXXX 
判断方法：
1、isEmpty/isNotEmpty/isBlank/isNotBlank/isNumeric/isWhitespace
2、sartsWith/startsWithAny/endsWith/endsWithIgnoreCase
索引(index)：indexOf/indexOfXXX/tIndexOf/lastIndexOfXXX
处理方法：
    abbreviate 缩短 capitalise 首字母 repeat 重复 left/right/center 左右中间
    removeXXX 移除 trimXXX 去空  reverseXXX 翻转 stripXXX 移除
    defaultXXX 默认 lowerCase/upperCase deleteXXX 删除处理
    splitXXX分解处理 join 拼接
```

### StringEscapeUtils 转义字符串工具类
StringEscapeUtils类可以对html js xml sql 等代码进行转义来防止SQL注入
```
escapeCsv/unescapeCsv/escapeHtml/unescapeHtml/escapeJava/unescapeJava
escapeJavaScript/unescapeJavaScript/escapeXml/unescapeXml/escapeSql
```

### NumberUtils 数字工具类

```
创建数字：createXXX  创建Integer,Float,Double,Number,BigDecimal,BigInteger等数字
字符转数字：toXXX     字符串转数字：Byte,Double,Float,Int,Long,Short
判断是否数字：isDigits/isNumber
其他方法：compare,max,min,
```

### ArrayUtils 数组工具类

```
添加移除:add,addAll，remove,removeElement,
拷贝：clone
判断：contains,isEmpty,isNotEmpty,isEquals,isSameLength,
其他：getLength,indexOf,lastIndexOf,nullToEmpty,reverse,subArray,
转换：toMap,toObject,toPrimitive,toString
```
### EnumUtils 枚举工具类
```
getEnum/getEnumIgnoreCase/getEnumList/getEnumMap
iterator
```
## 随机数工具类
### RandomUtils 随机数工具类
```
nextBoolean/nextInt/nextLong/nextFloat/nextDouble
```

### RandomStringUtils 随机字符串工具类
```
random/randomNumeric/randomAlphabetic/randomAscii
```
## 日期时间工具类
### DateUtils 日期工具类
```
说明：XXX表示milisecends,seconds,minutes,hours,days,weeks,months,years
时间加减：add/addXXX 
时间设置：setXXX 
获取片段：getFragmentInXXX    获取date的1月1日0点0分0秒到指定时间的片段值
判断： isSameDay/isSameInstant/isSameLocalTime
转换： parseDate/parseDateStrictly
取模： ceiling/round/truncate
时间段：iterator   注意rangeStyle=1到4表示周范围以及偏移，5和6表示月偏移
```

### DateFormatUtils时间格式化
```
格式化：format/formatUTC
```
### DurationFormatUtils时间段格式化
```
formatDuration/formatDurationHMS/formatDurationISO
formatPeriod/formatPeriodISO
formatDurationWords
```

### StopWatch 秒表
```
start/stop/suspend/split/resume/reset/unsplit
getSplitTime/getStartTime/getTime/
toSplitString/toString
```


## 反射工具类

### ClassUtils 类工具
```
获取： 
    1、类和接口 ：getClass/getAllInterfaces/getAllSuperclasses/getShortClassName
    2、包：getPackageName/getPackageCanonicalName
    3、方法：getPublicMethod
转换：
    1、toClass/convertClassesToClassNames/convertClassNamesToClasses/
    2、primitivesToWrappers/primitiveToWrapper/wrappersToPrimitives/wrapperToPrimitive
判断：isAssignable/isInnerClass
```

### MethodUtils
```
getAccessibleMethod/getMatchingAccessibleMethod
invokeMethod/invokeStaticMethod/invokeExactMethod/invokeExactStaticMethod
```

### FieldUtils
```
getField/readField/writeField
getDeclaredField/readDeclaredField/writeDeclaredField
readDeclaredStaticField/readStaticField/writeDeclaredStaticField/writeStaticField
```

### ConstructorUtils
```
getAccessibleConstructor/getMatchingAccessibleConstructor
invokeConstructor/invokeExactConstructor
```

## ObjectUtils 对象工具类
```
max/min/toString/identityToString/appendIdentityToString/defaultIfNull
```
## SystemUtils 系统属性工具类
```
getJavaHome/getJavaIoTmpDir/getJavaVersion/getUserDir/getUserHome/
isJavaAwtHeadless/isJavaVersionAtLeast
```

## SerializationUtils 序列化工具类
```
clone/deserialize/serialize
```

## LocaleUtils 本地工具类
```
availableLocaleList/availableLocaleSet
countriesByLanguage
localeLookupList/toLocale/isAvailableLocale/languagesByCountry
```