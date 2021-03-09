\>页面尺寸

\>\>宽高尺寸

>   clientWidth / clientHeight窗口的宽度高度

>   scrollWidth / scrollHeight文档内容的高度宽度

>   offsetWidth / offsetHeight文档内容的高度宽度

\>\>坐标位置

>   scrollleft / scrollTop滚轴的水平便宜距离，垂直偏移距离

>   offsetLeft / offsetTop对象与页面的边距

>   event.clientX /
>   event.clientY事件触发时，鼠标指针对窗口的水平垂直坐标(event为时间)

//注意事项：documentElement是整个节点树的根节点root，即html标签，document.body也是document能直接调用的属性标签

语法：

>   object.offsetLeft/oobject.offsetTop

\>拖拽功能的实现

**[html]** [view plain](http://blog.csdn.net/estom_yin/article/details/51900581)
[copy](http://blog.csdn.net/estom_yin/article/details/51900581)

1.  **\<html\>**

2.  **\<head\>**

3.  **\<meta** charset="UTF-8"**\>**

4.  **\<title\>**event**\</title\>**

5.  **\<style\>**

6.  \#box {

7.  width: 100px;

8.  height: 100px;

9.  background-color: aquamarine;

10. position: absolute;

11. }

12. **\</style\>**

13. **\</head\>**

14. **\<body\>**

15. **\<div** id="box"**\>\</div\>**

16. **\<script** type="text/javascript"**\>**

17. var oDiv = document.getElementById("box");

18. oDiv.onmousedown = function(ev){

19. var oEvent = ev;

20. var disX = oEvent.clientX-oDiv.offsetLeft;

21. var disY = oEvent.clientY-oDiv.offsetTop;

22. document.onmousemove = function(ev){

23. oEvent = ev;

24. oDiv.style.left = oEvent.clientX - disX +"px";

25. oDiv.style.top = oEvent.clientY - disY +"px";

26. }

27. document.onmouseup = function(){

28. document.onmousemove = null;

29. document.onmouseup = null;

30. }

31. }

32. 

33. **\</script\>**

34. **\</body\>**

35. **\</html\>**
