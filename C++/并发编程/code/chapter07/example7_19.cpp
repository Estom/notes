//在无锁队列中释放结点的外部计数
template <typename T>
class lock_free_queue
{
private:
	static void free_external_counter(counted_node_ptr& old_node_ptr)
	{
		node* const ptr=old_node_ptr.ptr;
		int const count_increase=old_node_ptr.external_count-2;

		node_counter old_counter=ptr->count.load(std::memory_order_relaxed);

		node_counter new_counter;
		do
		{
			new_counter=old_counter;
			--new_counter.external_counters;
			new_counter.internal_count+=count_increase;
		}
		while(!ptr->count.compare_exchange_strong(
			old_counter,new_counter,
			std::memory_order_acquire,std::memory_order_relaxed));

		if(!new_counter.internal_count && !new_counter.external_counters)
		{
			delete ptr;
		}
	}
};