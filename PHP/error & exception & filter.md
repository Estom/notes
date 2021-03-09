\>error错误处理

\>\>基本错误处理die("错误反馈字符串")，能终止当前脚本的执行

**[php]** [view plain](http://blog.csdn.net/estom_yin/article/details/51942164)
[copy](http://blog.csdn.net/estom_yin/article/details/51942164)

1.  \<span style="font-size:14px;"\>\<?php

2.  **if**(!file\_exists("welcome.txt"))

3.  {

4.  **die**("File not found");

5.  }

6.  **else**

7.  {

8.  \$file=fopen("welcome.txt","r");

9.  }

10. ?\>\</span\>

\>\>自定义函数处理错误

\>\>错误记录

\>exception异常处理

\>\>可能的处理方式：

保存代码退出脚本执行

切换到预先定义好的异常处理函

重新执行代码或者从代码另外的位置继续执行脚本

\>\>异常的基本使用

步骤：抛出异常 - 捕获异常（对异常进行匹配） - 处理异常

**[php]** [view plain](http://blog.csdn.net/estom_yin/article/details/51942164)
[copy](http://blog.csdn.net/estom_yin/article/details/51942164)

1.  \<span style="font-size:14px;"\>\<?php

2.  //create function with an exception

3.  **function** checkNum(\$number)

4.  {

5.  **if**(\$number\>1)

6.  {

7.  **throw** **new** Exception("Value must be 1 or below");

8.  }

9.  **return** true;

10. }

11. 

12. //trigger exception

13. checkNum(2);

14. ?\>\</span\>

//其中使用throw new Exception("Value must be 1 or
below")抛出了异常，但没有查找到匹配模块，出现致命错误。

\>\>异常抛出的完整过程及其解释

try 异常函数位于try代码块内进行检测

throw 每一个throw对应一个catch

catch 捕获异常，创建一个包含异常信息的对象

**[php]** [view plain](http://blog.csdn.net/estom_yin/article/details/51942164)
[copy](http://blog.csdn.net/estom_yin/article/details/51942164)

1.  \<span style="font-size:14px;"\>\<?php

2.  //创建可抛出一个异常的函数

3.  **function** checkNum(\$number)

4.  {

5.  **if**(\$number\>1)

6.  {

7.  \<span style="color:\#ff0000;"\>**throw** **new** Exception("Value must be 1
    or below");//想当于创建了一个新的对象，其中“”是构造函数的参数。\</span\>

8.  }

9.  **return** true;

10. }

11. 

12. //在 "try" 代码块中触发异常

13. try

14. {

15. checkNum(2);

16. //If the exception is thrown, this text will not be shown

17. echo 'If you see this, the number is 1 or below';

18. }

19. 

20. //捕获异常

21. \<span style="color:\#ff0000;"\>catch(Exception \$e)\</span\>

22. {

23. echo 'Message: ' .\$e-\>getMessage();

24. }

25. ?\>\</span\>

26. 创建 checkNum() 函数。它检测数字是否大于 1。如果是，则抛出一个异常。

27. 在 "try" 代码块中调用 checkNum() 函数。

28. checkNum() 函数中的异常被抛出

29. "catch" 代码块接收到该异常，并创建一个包含异常信息的对象 (\$e)。

30. 通过从这个 exception 对象调用 \$e-\>getMessage()，输出来自该异常的错误消息

//这里exception就是一个类的定义，可以定义相应的对象，然后内部有函数如gerMessage()可以返回异常信息。

\>\>自定义的exception类（同样存在继承关系）

**[php]** [view plain](http://blog.csdn.net/estom_yin/article/details/51942164)
[copy](http://blog.csdn.net/estom_yin/article/details/51942164)

1.  \<span style="font-size:14px;"\>\<span style="color:\#ff0000;"\>**class**
    customException **extends** Exception//注意继承类的定义\</span\>

2.  {

3.  **public** **function** errorMessage()

4.  {

5.  //error message

6.  \$errorMsg = 'Error on line '.\$this-\>getLine().' in '.\$this-\>getFile()

7.  .': \<b\>'.\$this-\>getMessage().'\</b\> is not a valid E-Mail address';

8.  **return** \$errorMsg;

9.  }

10. }

11. 

12. \$email = "someone@example...com";

13. 

14. try

15. {

16. //check if

17. **if**(filter_var(\$email, FILTER_VALIDATE_EMAIL) === FALSE)

18. {

19. //throw exception if email is not valid

20. **throw** **new** customException(\$email);

21. }

22. }

23. 

24. catch (customException \$e)

25. {

26. //display custom message

27. echo \$e-\>errorMessage();

28. }\</span\>

系统中exception类的内部函数有getLine() 、 getFile()、 getMessage（）

\>\>多个异常的处理

用不同的异常处理类来捕获不同的异常。

\>\>重新抛出异常

用不同的异常处理类，一个类执行时，向另一个类抛出异常。

\>\>设置顶层异常处理器

set_exception_handler()设置处理所有未捕获异常的用户定义函数

//当没有异常抛出时硬要抛出一个异常，来显示我定义了某个函数。

\>\>异常处理规则

-   需要进行异常处理的代码应该放入 try 代码块内，以便捕获潜在的异常。

-   每个 try 或 throw 代码块必须至少拥有一个对应的 catch 代码块。

-   使用多个 catch
    代码块可以捕获不同种类的异常。不同的异常，就是属于不同的异常类，有多少种异常，就应该定义多少种类。

-   可以在 try 代码块内的 catch 代码块中再次抛出（re-thrown）异常。

**\>filter过滤器（错误处理部分的过滤器没看懂）**

用于过滤非安全来源的数据

验证和过滤用户输入或自定义数据是任何web应用程序的重要组成部分

设计PHP的过滤器扩展的目的是是数据过滤更轻松快捷

目的：数据类型匹配(来自外部数据和内部要求)

\>\>过滤函数

-   filter_var() - 通过一个指定的过滤器来过滤单一的变量

-   filter_var_array() - 通过相同的或不同的过滤器来过滤多个变量

-   filter_input - 获取一个输入变量，并对它进行过滤

-   filter_input_array -
    获取多个输入变量，并通过相同的或不同的过滤器对它们进行过滤

-   filter_has_var() - 判断变量是否存在

-   filter\_id()

-   filter\_list()

\>\>过滤器

FILTER_CALLBACK //调用用户自定义的函数过滤数据

sanitize：净化，表示对检测的数据进行处理

FILTER_SANITIZE_ENCODED //去除编码的特殊符号

FILTER_SANITIZE_SPECIAL_CHARS //html转义字符，ascII小于32的字符

FILTER_SANITIZE_STRING //去除标签和编码的特殊字符

FILTER_SANITIZE_EMAIL //去除非email字符

FILTER_SANITIZE_URL //去除非URL字符

FILTER_SANITIZE_NUMBER_INT //保留数字和加减号

FILTER_SANITIZE_NUMBER_FLOAT //保留浮点字符

FILTER_SANITIZE_MAGIC_QUOTERS //应用addslash（）不是很明白

balidate：确定，验证用户输入，严格的格式规则

FILTER_VALIDATE_INT //确定整型

FILTER_VALIDATE_VOOLEAN//确定布尔型

FILTER_VALIDATE_FLOAT//确定浮点型

FILTER_VALIDATE\_URL//确定合法URL

FILTER_VALIDATE_EMAIL//确定邮件

FILTER_VALIDATE_IP//确定ip地址

\>\>不同的过滤器有不同的选项和标志

//所以说每次在使用前，去找本参考手册好好看看。网站上的并不全面。

//FILTER_VALIDATE_INT的参数就是一个嵌套数组

**[php]** [view plain](http://blog.csdn.net/estom_yin/article/details/51942164)
[copy](http://blog.csdn.net/estom_yin/article/details/51942164)

1.  \<span style="font-size:14px;"\>\<?php

2.  \$var=300;

3.  

4.  \$int_options = **array**(

5.  "options"=\>**array**

6.  (

7.  "min_range"=\>0,

8.  "max_range"=\>256

9.  )

10. );

11. 

12. **if**(!filter_var(\$var, FILTER_VALIDATE_INT, \$int_options))

13. {

14. echo("Integer is not valid");

15. }

16. **else**

17. {

18. echo("Integer is valid");

19. }

20. ?\>\</span\>

\>\>验证输入filter_input(INPUT_GET, "email",FILTER_VALIDATE_EMAIL)

**[php]** [view plain](http://blog.csdn.net/estom_yin/article/details/51942164)
[copy](http://blog.csdn.net/estom_yin/article/details/51942164)

1.  \<span style="font-size:14px;"\>\<?php

2.  **if**(!filter_has_var(INPUT_GET, "email"))

3.  {

4.  echo("Input type does not exist");

5.  }

6.  **else**

7.  {

8.  \<span style="color:\#ff0000;"\> **if** (!filter_input(INPUT_GET, "email",
    FILTER_VALIDATE_EMAIL))//不是很明白INPUT_GET的意思，难道是超全局变量？\</span\>

9.  {

10. echo "E-Mail is not valid";

11. }

12. **else**

13. {

14. echo "E-Mail is valid";

15. }

16. }

17. ?\>\</span\>

\>\>净化输入filter_input(INPUT_POST, "URL", FILTER_SANITIZE_URL)

**[php]** [view plain](http://blog.csdn.net/estom_yin/article/details/51942164)
[copy](http://blog.csdn.net/estom_yin/article/details/51942164)

1.  \<span style="font-size:14px;"\>\<?php

2.  **if**(!filter_has_var(INPUT_POST, "url"))

3.  {

4.  echo("Input type does not exist");

5.  }

6.  **else**

7.  {

8.  \$url = filter\_input(INPUT_POST, "url", FILTER_SANITIZE_URL);

9.  }

10. ?\>\</span\>

\>\>过滤多个输入

**[php]** [view plain](http://blog.csdn.net/estom_yin/article/details/51942164)
[copy](http://blog.csdn.net/estom_yin/article/details/51942164)

1.  \<span style="font-size:14px;"\>\<?php

2.  \$filters = **array**

3.  (

4.  "name" =\> **array**

5.  (

6.  "filter"=\>FILTER_SANITIZE_STRING

7.  ),

8.  "age" =\> **array**

9.  (

10. "filter"=\>FILTER_VALIDATE_INT,

11. "options"=\>**array**

12. (

13. "min_range"=\>1,

14. "max_range"=\>120

15. )

16. ),

17. "email"=\> FILTER_VALIDATE_EMAIL,

18. );

19. 

20. \$result = filter_input\_array(INPUT_GET, \$filters);

21. 

22. **if** (!\$result["age"])

23. {

24. echo("Age must be a number between 1 and 120.\<br /\>");

25. }

26. **elseif**(!\$result["email"])

27. {

28. echo("E-Mail is not valid.\<br /\>");

29. }

30. **else**

31. {

32. echo("User input is valid");

33. }

34. ?\>\</span\>

1.  设置一个数组，其中包含了输入变量的名称，以及用于指定的输入变量的过滤器

2.  调用 filter_input_array 函数，参数包括 GET 输入变量及刚才设置的数组

3.  检测 \$result 变量中的 "age" 和 "email"
    变量是否有非法的输入。（如果存在非法输入，）

\>\>使用filter callback,自定义函数过滤器

将下划线装换为空格

**[php]** [view plain](http://blog.csdn.net/estom_yin/article/details/51942164)
[copy](http://blog.csdn.net/estom_yin/article/details/51942164)

1.  \<span style="font-size:14px;"\>\<?php

2.  **function** convertSpace(\$string)

3.  {

4.  **return** str\_replace("_", " ", \$string);

5.  }

6.  

7.  \$string = "Peter_is_a_great_guy!";

8.  

9.  echo filter\_var(\$string, FILTER_CALLBACK,
    **array**("options"=\>"convertSpace"));

10. ?\>\</span\>
