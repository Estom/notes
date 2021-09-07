//在无锁队列中获得结点的新引用
template <typename T>
class lock_free_queue
{
private:
	static void increase_external_count(std::atomic<counted_node_ptr>& counter, counted_node_ptr& old_counter)
	{
		counted_node_ptr& new_counter;

		do
		{
			new_counter = old_counter;
			++new_counter.external_count;
		}
		while(!counter.compare_exchange_strong(
			old_counter,new_counter,
			std::memory_order_acquire,std::memory_order_relaxed));

		old_counter.external_count=new_counter.external_count;
	}
};