//清单4.3 threadsafe_queue的接口
#include <memory>	//为了std::shared_ptr

template <typename T>
class threadsafe_queue
{
public:
	threadsafe_queue();
	threadsafe_queue(const threadsafe_queue&);
	threadsafe_queue& operator=(const threadsafe_queue&) = delete;	//为了简单起见不允许复制

	void push(T new_value);

	bool try_pop(T& value);
	std::shared_ptr<T> try_pop();

	void wait_and_pop(T& value);
	std::shared_ptr<T> wait_and_pop();

	bool empty() const;
};