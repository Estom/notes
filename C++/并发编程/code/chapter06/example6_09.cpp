//使用锁和等待的线程安全队列:wait_and_pop()
template <typename T>
class threadsafe_queue
{
private:
	node* get_tail()
	{
		std::lock_guard<std::mutex> tail_lock(tail_mutex);
		return tail;
	}

	std::unique_ptr<node> pop_head()
	{
		std::unique_ptr<node> old_head=std::move(head);
		head=std::move(old_head->next);
		return old_head;
	}

	std::unique_ptr<std::mutex> wait_for_data()
	{
		std::unique_lock<std::mutex> head_lock(head_mutex);
		data_cond.wait(head_lock,[&]{return head.get()!=get_tail();});
		return std::move(head_lock);
	}

	std::unique_ptr<node> wait_pop_head()
	{
		std::unique_lock<std::mutex> head_lock(wait_for_data());
		return pop_head();
	}

	std::unique_ptr<node> wait_pop_head(T& value)
	{
		std::unique_lock<std::mutex> head_lock(wait_for_data());
		value=std::move(*head->data);
		return pop_head();
	}
public:
	std::shared_ptr<T> wait_and_pop()
	{
		std::unique_ptr<node> const old_head=wait_pop_head();
		retun old_head->data;
	}

	void wait_and_pop(T& value)
	{
		std::unique_ptr<node> const old_head=wait_pop_head(value);
	}
};