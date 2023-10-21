## 1 org.apache.commons.text

变量默认前缀是`${`，后缀是`}`
```xml
<dependency>
        <groupId>org.apache.commons</groupId>
        <artifactId>commons-lang3</artifactId>
        <version>3.12.0</version>
</dependency>
```
```java
Map valuesMap = new HashMap();
valuesMap.put("code", 1234);
String templateString = "验证码：${code}，您正在登录管理后台，5分钟内输入有效。";
StringSubstitutor sub = new StringSubstitutor(valuesMap);
String content= sub.replace(templateString);
System.out.println(content);
验证码：1234，您正在登录管理后台，5分钟内输入有效。
```
### 修改前缀、后缀
```java
Map valuesMap = new HashMap();
valuesMap.put("code", 1234);
String templateString = "验证码：[code]，您正在登录管理后台，5分钟内输入有效。";
StringSubstitutor sub = new StringSubstitutor(valuesMap);
//修改前缀、后缀
sub.setVariablePrefix("[");
sub.setVariableSuffix("]");
String content= sub.replace(templateString);
System.out.println(content);
```

## 2 org.springframework.expression
```java
String smsTemplate = "验证码：#{[code]}，您正在登录管理后台，5分钟内输入有效。";
Map<String, Object> params = new HashMap<>();
params.put("code", 12345);;
 
ExpressionParser parser = new SpelExpressionParser();
TemplateParserContext parserContext = new TemplateParserContext();
String content = parser.parseExpression(smsTemplate,parserContext).getValue(params, String.class);
 
System.out.println(content);
验证码：12345，您正在登录管理后台，5分钟内输入有效。
```
ExpressionParser是简单的用java编写的表达式解析器，官方文档：

http://docs.spring.io/spring/docs/current/spring-framework-reference/html/expressions.html

## 3 java.text.MessageFormat
```java
Object[] params = new Object[]{"1234", "5"};
String msg = MessageFormat.format("验证码：{0}，您正在登录管理后台，{1}分钟内输入有效。", params);
System.out.println(msg);
验证码：1234，您正在登录管理后台，10分钟内输入有效。
```
## 4 java.lang.String
```java
String s = String.format("My name is %s. I am %d.", "Tom", 18);
System.out.println(s);
```