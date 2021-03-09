\>父子节点

\>\>childNode

>   使用语法：elementNode.childNodes

>   注意事项：空白节点会被浏览器但顾总文本节点

\>\>firstChild lastChild

>   使用语法：node.firstChild node.lastChild

\>\>parentNode

>   使用语法:elementNode.parentNode

**[html]** [view plain](http://blog.csdn.net/estom_yin/article/details/51899305)
[copy](http://blog.csdn.net/estom_yin/article/details/51899305)

1.  **\<span** style="font-size:14px;"**\>\<body\>**

2.  **\<ul** id="father"**\>**

3.  **\<li\>**大娃**\</li\>**

4.  **\</ul\>**

5.  **\<script** type="text/javascript"**\>**

6.  var li_num = 0;

7.  var childNodes = document.getElementById("father").childNodes;

8.  for(var i = 0; i **\<** **childNodes.length**; i++){

9.  document.write("节点名：" + childNodes[i].nodeName + " ");

10. document.write("节点类型：" + childNodes[i].nodeType + " ");

11. if(childNodes[i].nodeType == 1){

12. document.write("我是" + childNodes[i].innerHTML + "**\<br\>**");

13. li_num++;

14. }

15. else{

16. document.write("**\<br\>**");

17. console.log("这是一个空节点，不用理他");

18. }

19. }

20. document.write("子节点数目：" + childNodes.length + "**\<br\>**");

21. document.write("li 子节点数目：" + li_num + "**\<br\>**");

22. document.write("文本子节点数目：" + (childNodes.length - li_num));

23. **\</script\>**

24. **\</body\>\</span\>**

//补充节点的属性还有title！

\>兄弟节点

>   previousSibling nextSibling

>   使用语法：

>   nodeobject.nextSibling / previousSibling

**[html]** [view plain](http://blog.csdn.net/estom_yin/article/details/51899305)
[copy](http://blog.csdn.net/estom_yin/article/details/51899305)

1.  **\<span** style="font-size:14px;"**\>\<body\>**

2.  **\<ul** id="father"**\>**

3.  **\<li** title="force_max"**\>**大娃**\</li\>**

4.  **\<li** id="second_children"**\>**二娃**\</li\>**

5.  **\<li** title="fire"**\>**三娃**\</li\>**

6.  **\</ul\>**

7.  **\<script** type="text/javascript"**\>**

8.  function getprenode(node){

9.  var prenode = node.previousSibling;

10. while(prenode && prenode.nodeType != 1){

11. prenode = prenode.previousSibling;

12. }

13. return prenode;

14. }

15. function getnextnode(node){

16. var nextnode = node.nextSibling;

17. while(nextnode && nextnode.nodeType != 1){

18. nextnode =nextnode.nextSibling;

19. }

20. return nextnode;

21. }

22. var second_children = document.getElementById("second_children");

23. var first_children = getprenode(second_children);

24. var third_children = getnextnode(second_children);

25. alert(first\_children.innerHTML+first_children.title);

26. alert(third\_children.innerHTML+third_children.title);

27. **\</script\>**

28. **\</body\>\</span\>**

//虽然觉得这是史上最无聊的程序，但还是含泪贴上了

\>创建节点方法

>   createElement('tagName'):创建节点

>   crreateTextNode("text")：穿件文本节点

**[html]** [view plain](http://blog.csdn.net/estom_yin/article/details/51899305)
[copy](http://blog.csdn.net/estom_yin/article/details/51899305)

1.  **\<span** style="font-size:14px;"**\>** var newinp =
    document.createElement("input");

2.  alert(newinp);

3.  var newtext = document.createTextNode("text");

4.  alert(newtext);**\</span\>**

\>添加删除节点

>   nodeobject.appendChild(newnode)：父节点末尾添加

>   nodeobject.removeChild(node)：删除节点

**[html]** [view plain](http://blog.csdn.net/estom_yin/article/details/51899305)
[copy](http://blog.csdn.net/estom_yin/article/details/51899305)

1.  **\<span** style="font-size:14px;"**\>\<body\>**

2.  **\<ul** id="father"**\>**

3.  **\<li\>**大娃**\</li\>**

4.  **\</ul\>**

5.  **\<input** type="button" id="createbtn" value="祭出紫金葫芦"**\>**

6.  **\<script** type="text/javascript"**\>**

7.  function createnode(){

8.  var btn = document.createElement("input");

9.  btn.setAttribute("type", "button");

10. btn.setAttribute("name", "紫金葫芦");

11. btn.setAttribute("value", "吸进去");

12. btn.setAttribute("onclick", "removenode()");

13. document.body.appendChild(btn);

14. }

15. function removenode(){

16. var fnode = document.getElementById("father");

17. var nodes = fnode.childNodes;

18. for(var i = 0; i **\<** **nodes.length**; i++){

19. if(nodes[i] && nodes[i].nodeType == 1){

20. var rm = fnode.removeChild(nodes[i]);

21. rm = null;

22. break;

23. }

24. }

25. }

26. var createbtn = document.getElementById("createbtn");

27. createbtn.onclick = createnode;

28. **\</script\>**

29. **\</body\>\</span\>**

//有很多需要注意的地方，等吃饭回来补充

>   appendChild()方法的主体必须使父节点，而且只能添加到节点对类的末尾

\>插入节点

>   fnode.insertBefore(newnode，node)：可以指定插如节点的位置（在node之前）返回值是插入的节点

**[html]** [view plain](http://blog.csdn.net/estom_yin/article/details/51899305)
[copy](http://blog.csdn.net/estom_yin/article/details/51899305)

1.  **\<span** style="font-size:14px;"**\>\<body\>**

2.  **\<ul** id="father"**\>**

3.  **\<li\>**二娃**\</li\>**

4.  **\</ul\>**

5.  **\<input** type="button" id="add-btn" value="add"**\>**

6.  **\<script** type="text/javascript"**\>**

7.  function addnode(){

8.  var fnode = document.getElementById("father");

9.  var newnode = document.createElement("li");

10. newnode.innerHTML = "大娃";

11. fnode.insertBefore(newnode, fnode.childNodes[0]);

12. }

13. var add = document.getElementById("add-btn");

14. add.onclick = addnode;

15. **\</script\>**

16. **\</body\>\</span\>**

\>替换子节点（克隆替换）

>   fonde.replaceChild(newnode, oldnode) //返回值是被替换的节点

**[html]** [view plain](http://blog.csdn.net/estom_yin/article/details/51899305)
[copy](http://blog.csdn.net/estom_yin/article/details/51899305)

1.  **\<span** style="font-size:14px;"**\>\<body\>**

2.  **\<ul** id="father"**\>**

3.  **\<li** id="first"**\>**大娃**\</li\>**

4.  **\<li\>**二娃**\</li\>**

5.  **\</ul\>**

6.  **\<input** type="button" id="replace-btn" value="replace"**\>**

7.  **\<script** type="text/javascript"**\>**

8.  function replacenode(){

9.  var oldnode = document.getElementById("first");

10. var newnode = document.createElement("li");

11. newnode.innerHTML = "金刚葫芦娃";

12. oldnode.parentNode.replaceChild(newnode, oldnode);

13. }

14. var replace = document.getElementById("replace-btn");

15. replace.onclick = replacenode;

16. **\</script\>**

17. **\</body\>\</span\>**
