//使用锁和等待的线程安全队列：try_pop()和empty()
template <typename T>
class threadsafe_queue
{
private:
	std::unique_ptr<node> try_pop_head()
	{
		std::lock_guard<std::mutex> head_lock(head_mutex);
		if(head.get()==get_tail())
		{
			return std::unique_ptr<node>();
		}
		return pop_head();
	}

	std::unique_ptr<node> try_pop_head(T& value)
	{
		std::lock_guard<std::mutex> head_lock(head_mutex);
		if(head.get()==get_tail())
		{
			return std::unique_ptr<node>();
		}
		value=std::move(*head->data);
		return pop_head();
	}

public:
	std::shared_ptr<T> try_pop()
	{
		std::unique_ptr<node> old_head=try_pop_head();
		return old_head?old_head->data:std::shared_ptr<T>();
	}

	bool try_pop(T& value)
	{
		std::unique_ptr<node> const old_head=try_pop_head(value);
		return old_head;		//不知道这里是不是隐式转换
	}

	bool empty()
	{
		std::lock_guard<std::mutex> head_lock(head_mutex);
		return (head.get()==get_tail());
	}
};