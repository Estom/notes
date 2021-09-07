//使用锁和等待的线程安全队列:push新值
template <typename T>
void threadsafe_queue<T>::push(T new_value)
{
	std::shared_ptr<T> new_data(std::make_shared<T>(std::move(new_value)));
	std::unique_ptr<node> p(new node);
	{
		std::lock_guard<std::mutex> tail_lock(tail_mutex);
		tail->data=new_data;
		node* const new_tail=p.get();
		tail->next=std::move(p);
		tail=new_tail;
	}
	data_cond.notify_one();
}