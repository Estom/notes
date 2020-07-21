## 1 实例

```
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<script>
function loadXMLDoc()
{
	var xmlhttp;
	if (window.XMLHttpRequest)
	{
		//  IE7+, Firefox, Chrome, Opera, Safari 浏览器执行代码
		xmlhttp=new XMLHttpRequest();
	}
	else
	{
		// IE6, IE5 浏览器执行代码
		xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
	}
	xmlhttp.onreadystatechange=function()
	{
		if (xmlhttp.readyState==4 && xmlhttp.status==200)
		{
			document.getElementById("myDiv").innerHTML=xmlhttp.responseText;
		}
	}
	xmlhttp.open("GET","/try/ajax/ajax_info.txt",true);
	xmlhttp.send();
}
</script>
</head>
<body>

<div id="myDiv"><h2>使用 AJAX 修改该文本内容</h2></div>
<button type="button" onclick="loadXMLDoc()">修改内容</button>

</body>
```

## 2 说明

* 创建xmlhttp=new XMLHTTPRequest()对象。（浏览器的内建对象）
* xmlhttp.open(method,url,async)打开http请求async=true，异步执行。async=false同步执行，JavaScript会等到服务器返回后才执行。
* xmlhttp.send(string);发送http请求
* xmlhttp.responseText;返回字符串形式
* xmlhttp.responseXML;使用XML解析返回值

## 3 事件响应机制

* onreadystatechange:存储函数，当readyState属性改变时，调用该函数（也是回调函数。）
* readyState，存储有状态。0：请求初始化，1已经建立连接，2请求已接收，3请求处理中，4请求已完成
* status：200：OK，404：未找到页面。

```
xmlhttp.onreadystatechange=function()
{
    if (xmlhttp.readyState==4 && xmlhttp.status==200)
    {
        document.getElementById("myDiv").innerHTML=xmlhttp.responseText;
    }
}
```