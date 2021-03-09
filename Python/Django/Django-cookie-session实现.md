**启用session**

**在视图中使用session**

\# 创建或修改 session：

request.session[key] **=** value

\# 获取 session：

request.session.get(key,default**=**None)

\# 删除 session

**del** request.session[key] \# 不存在时报错

例子：让用户不能评论两次的应用（原来要用session实现不重复点赞）

**from** django.http **import** HttpResponse

**def** post_comment(request, new_comment):

**if** request.session.get('has_commented', False):

**return** HttpResponse("You've already commented.")

c **=** comments.Comment(comment**=**new_comment)

c.save()

request.session['has_commented'] **=** True

**return** HttpResponse('Thanks for your comment!')

**一个简化的登陆认证：**

**def** login(request):

m **=** Member.objects.get(username**=**request.POST['username'])

**if** m.password **==** request.POST['password']:

request.session['member_id'] **=** m.id

**return** HttpResponse("You're logged in.")

**else**:

**return** HttpResponse("Your username and password didn't match.")

**def** logout(request):

**try**:

**del** request.session['member_id']

**except** KeyError:

**pass**

**return** HttpResponse("You're logged out.")
