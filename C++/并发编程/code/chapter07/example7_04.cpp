//当pop()中没有线程时回收结点
template <typename T>
class lock_free_stack
{
private:
	std::atomic<unsigned> threads_in_pop;		//原子变量
	void try_reclaim(node* old_head);		//试着回收内存 7.5有详细的实现
public:
	std::shared_ptr<T> pop()
	{
		++threads_in_pop;		//在做任何其他事情前增加计数
		node* old_head=head.load();
		while(old_head && !head.compare_exchange_weak(old_head,old_head->next));
		std::shared_ptr<T> res;
		if(old_head)
		{
			res.swap(old_head->data);		//如果可能，回收删除的结点
		}
		try_reclaim(old_head);				//从结点中提取数据，而不是复制指针
		return res;
	} 
};