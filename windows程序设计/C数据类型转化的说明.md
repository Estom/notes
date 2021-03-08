**基础转化方式**

atoi(p) 字符串转换到 int 整型 atof(p) 字符串转换到 double 符点数 atol(p)
字符串转换到 long 整型

itoa()将整型值转换为字符串

ftoa()将浮点型转化为字符串

ultoa()将无符号长整型值转换为字符串

**字符串操作方式**

strtod(p, ppend) 从字符串 p 中转换 double 类型数值，并将后续的字符串指针存储到
ppend 指向的 char\* 类型存储。 strtol(p, ppend, base) 从字符串 p 中转换 long
类型整型数值，base 显式设置转换的整型进制，设置为 0
以根据特定格式判断所用进制，0x, 0X 前缀以解释为十六进制格式整型，0
前缀以解释为八进制格式整型

char \*ecvt(double value,int ndigIT,int \*dec,int \*sign)

ecvt() 将双精度浮点型值转换为字符串，转换结果中不包含十进制小数点

char \*fcvt(double value,int ndigIT,int \*dec,int \*sign)

fcvt() 以指定位数为转换精度，余同ecvt()

char \* gcvt(double value,int ndec,char \*buf)

gcvt() 将双精度浮点型值转换为字符串，转换结果中包含十进制小数点

**流转化方式**

sprintf(ctime, "%d:%d:%d", H, M, S); // 将整数转换成字符串ctime

sscanf( str, "%f", &fp ); // 将字符串转换成浮点数 fp = 15.455000
