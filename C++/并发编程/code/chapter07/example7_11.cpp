//使用两个引用计数从无锁栈中出栈一个结点
template <typename T>
class lock_free_stack
{
private:
	void increase_head_count(counted_node_ptr& old_counter)
	{
		counted_node_ptr new_counter;

		do
		{
			new_counter=old_counter;
			++new_counter.external_count;
		}
		while(!head.compare_exchange_strong(old_counter,new_counter));

		old_counter.external_count=new_counter.external_count;
	}
public:
	std::shared_ptr<T> pop()
	{
		counted_node_ptr old_head=head.load();
		for(;;)
		{
			increase_head_count(old_head);
			node* const ptr=old_head.ptr;
			if(!ptr)
			{
				return std::shared_ptr<T>();
			}
			if(head.compare_exchange_strong(old_head,ptr->next))
			{
				std::shared_ptr<T> res;
				res.swap(ptr->data);
				//你增加的值比外部计数的值减少2
				int const count_increase=old_head.external_count-2;
				// 如果当前引用计数的值为0，那么先前你增加的值(即fetch_add的返回值)就是负数,此时可以删除这个结点
				if(ptr->internal_count.fetch_add(count_increase)==(-count_increase))	
				{
					delete ptr;
				}

				return res;
			}
			else if(ptr->internal_count.fetch_sub(1)==1)
			{
				delete ptr;
			}
		}
	}
};