//使用锁和等待的线程安全队列：内部与接口
template <typename T>
class threadsafe_queue
{
private:
	struct node
	{
		std::shared_ptr<T> data;
		std::unique_ptr<node> next;
	};

	std::mutex head_mutex;
	std::unique_ptr<node> head;
	std::mutex tail_mutex;
	node* tail;
	std::condition_variable data_cond;
public:
	threadsafe_queue():
		head(new node),tail(head.get())
	{}
	threadsafe_queue(const threadsafe_queue& other)=delete;
	threadsafe_queue& operator=(const threadsafe_queue& other)=delete;

	std::shared_ptr<T> try_pop();
	bool try_pop(T& value);
	std::shared_ptr<T> wait_and_pop();
	void wait_and_pop(T& value);
	void push(T new_value);
	void empty();
};