\>cookie

\>\>定义：

cookie是服务器留在用户计算机中的小文件，每当相同的计算机通过浏览器请求页面时，他会同时发送cookie。通过php，能够创建并取回cookie的值

\>\>setcookie(name, value, expire, path, domain);

expire参数是过期时间

\>\>\$_COOKIE["user"] //这些全局变量都是数组

用于取回cookie的值

print_r(\$_COOKIE); //能显示所有的数组

isset(\$_COOKIE["user"]);//用于确定是否设置了cookie

setcokkie("name", "",
time()-3600);//当删除cookie是应当以国企日期变更为过去的时间点（不明白）

\>\>如果浏览器不支持cookie，可以使用表单将信息存在php中

\>sessions

\>\>作用：session变量用于存储有关用户会话的信息，更改用户会话的设置。保存信息属于单一用户，并且可供提供应用程序中的所有应用程序中的所有页面使用。

\>\>作用地点：服务器上，作用时间：用户离开网站时，这一部分会被删除。

\>\>session_start() //启动session变量，在html标签之前

\>\>存取session变量使用\$_SESSION

使用isset（\$_SESSION）判定是否设定变量

使用unset(\$_SESSION)函数释放单个session变量

使用session_destoy()终止所有\$_SESSION变量(无参数)

\>mail

\>\>maili(to, subject, message, headers, parameters)

分别是（接受者， 主题， 消息内容， 副标题， 额外的参数）

\>\>简易E-mail的实现，从脚本直接发送电子邮件（虚拟服务器实现失败）

**[php]** [view plain](http://blog.csdn.net/estom_yin/article/details/51941611)
[copy](http://blog.csdn.net/estom_yin/article/details/51941611)

1.  \<span style="font-size:14px;"\>\<html\>

2.  \<body\>

3.  

4.  \<?php

5.  **if** (isset(\$_REQUEST['email']))

6.  //if "email" is filled out, send email

7.  {

8.  //send email

9.  \$email = \$_REQUEST['email'] ;

10. \$subject = \$_REQUEST['subject'] ;

11. \$message = \$_REQUEST['message'] ;

12. mail( "someone@example.com", "Subject: \$subject",

13. \$message, "From: \$email" );

14. echo "Thank you for using our mail form";

15. }

16. **else**

17. //if "email" is not filled out, display the form

18. {

19. echo "\<form method='post' action='mailform.php'\>

20. Email: \<input name='email' type='text' /\>\<br /\>

21. Subject: \<input name='subject' type='text' /\>\<br /\>

22. Message:\<br /\>

23. \<textarea name='message' rows='15' cols='40'\>

24. \</textarea\>\<br /\>

25. \<input type='submit' /\>

26. \</form\>";

27. }

28. ?\>

29. 

30. \</body\>

31. \</html\>\</span\>

\>安全的电子邮件

电子邮件表单的风险：可能用户在输入框中注入代码

**[php]** [view plain](http://blog.csdn.net/estom_yin/article/details/51941611)
[copy](http://blog.csdn.net/estom_yin/article/details/51941611)

1.  \<span style="font-size:14px;"\>**function** spamcheck(\$field)

2.  {

3.  //filter_var() sanitizes the e-mail ，净化email

4.  //address using FILTER_SANITIZE_EMAIL,从验证邮件中删除电子邮件的非法字符

5.  \$field=filter\_var(\$field, FILTER_SANITIZE_EMAIL);

6.  

7.  //filter_var() validates the e-mail，确定email的合法性

8.  //address using FILTER_VALIDATE_EMAIL，验证电子邮件地址

9.  **if**(filter_var(\$field, FILTER_VALIDATE_EMAIL))

10. {

11. **return** TRUE;

12. }

13. **else**

14. {

15. **return** FALSE;

16. }

17. }\</span\>

在上一段代码之前加上这一段代码
