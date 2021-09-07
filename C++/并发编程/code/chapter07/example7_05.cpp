//引用计数的回收机制try_reclaim
template <typename T>
class lock_free_stack
{
private:
	std::atomic<node*> to_be_deleted;

	static void delete_nodes(node* nodes)
	{
		while(nodes)
		{
			node* next=nodes->next;
			delete nodes;
			nodes=next;
		}
	}

	void try_reclaim(node* old_head)
	{
		if(threads_in_pop==1)
		{
			node* nodes_to_delete=to_be_deleted.exchange(nullptr);		//列出将要被删除的结点清单
			if(!--threads_in_pop)			//是pop()中唯一的线程吗?
			{
				delete_nodes(nodes_to_delete);
			}
			else if(nodes_to_delete)		//有等待的节点
			{
				chain_pending_nodes(nodes_to_delete);	//将此结点插入到等待删除结点列表的尾部
			}
			delete old_head;		//安全删除刚移动出来的结点
		}
		else
		{
			chain_pending_node(old_head);
			--threads_in_pop;
		}
	}
	void chain_pending_nodes(node* nodes)
	{
		node* last=nodes;
		while(node* const next=last->next)		//跟随下一个指针，链至末尾
		{
			last=next;
		}
		chain_pending_nodes(nodes,last);
	}

	void chain_pending_nodes(nodes* first,node* last)
	{
		last->next=to_be_deleted;
		while(!to_be_deleted.compare_exchange_weak(last->next,first));	//循环以保证last->next正确
	}

	void chain_pending_node(node* n)
	{
		chain_pending_nodes(n,n);
	}
};
