//使用风险指针的pop()实现
std::shared_ptr<T> pop()
{
	std::atomic<void*>& hp=get_hazard_pointer_for_current_thread();
	node* old_head=head.load();
	do
	{
		node* temp;
		//一直循环到你将风险指针设置到head上
		do
		{
			temp=old_head;
			hp.store(old_head);
			old_head=head.load();
		}while(old_head!=temp);
		//设置风险指针放到外部循环，如果比较/交换失败，则重载old_head。
	}
	while(old_head && !head.compare_exchange_strong(old_head,old_head->next));
	//因为在这个while循环中确实有效，使用weak()会导致不必要地重置风险指针
	hp.store(nullptr);		//当你完成时清除风险指针
	std::shared_ptr<T> res;
	if(old_head)
	{
		res.swap(old_head->data);
		//在你删除一个结点前检查风险指针是否引用它
		if(outstanding_hazard_pointers_for(old_head))
		{
			reclaim_later(old_head);		//放在稍后回收的列表中
		}
		else
		{
			delete old_head;				//立刻删除
		}
		delete_nodes_with_no_hazards();
	}
	return res;
}