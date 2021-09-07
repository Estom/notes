//修改pop()来允许帮助push()
template <typename T>
class lock_free_queue
{
private:
	struct node
	{
		std::atomic<T*> data;
		std::atomic<node_counter> count;
		std::atomic<counted_node_ptr> next;
	};
public:
	std::unique<T> pop()
	{
		counted_node_ptr old_head=head.load(std::memory_order_relaxed);
		for(;;)
		{
			increase_external_count(head,old_head);
			node* const ptr=old_head.ptr;
			if(ptr==tail.load().ptr)
			{
				return std::unique_ptr<T>();
			}
			counted_node_ptr next=ptr->next.load();
			if(head.compare_exchange_strong(old_head,next))
			{
				T* const res=ptr->data.exchange(nullptr);
				free_external_counter(old_head);
				return std::unique_ptr<T>(res);
			}
			ptr->release_ref();
		}
	}
};