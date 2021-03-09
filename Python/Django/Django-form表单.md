使用GET方法接受表单

\<form action="/search" method="get"\> \<input type="text" name="q"\> \<input
type="submit" value="搜索"\>\</form\>

\# 接收请求数据def search(request): request.encoding='utf-8' if 'q' in
request.GET: message = '你搜索的内容为: ' + request.GET['q'] else: message =
'你提交了空表单' return HttpResponse(message)

使用post方法对表单进行操作

\<form action="/search-post" method="post"\> {% csrf_token %} \<input
type="text" name="q"\> \<input type="submit" value="Submit"\> \</form\> \<p\>{{
rlt }}\</p\>

\# 接收POST请求数据def search_post(request): ctx ={} if request.POST: ctx['rlt']
= request.POST['q'] return render(request, "post.html", ctx)
