//释放无锁队列的结点引用
template <typename T>
class lock_free_queue
{
private:
	struct node
	{
		void release_ref()
		{
			node_counter old_counter=count.load(std::memory_order_relaxed);
			node_counter new_counter;
			do
			{
				new_counter=old_counter;
				--new_counter.internal_count;
			}
			while(!count.compare_exchange_strong(old_counter,new_counter,
				std::memory_order_acquire,std::memory_order_relaxed));

			if(!new_counter.internal_count && !new_counter.external_counters)
			{
				delete this;
			}
		}
	};
};