//一个线程安全栈的概要类定义
#include <exception>
#include <memory>		//For std::shared_ptr<>

struct empty_stack: std::exception
{
	const char* waht() const throw();
};

template<typename T>
class threadsafe_stack
 {
 public:
 	threadsafe_stack();
 	threadsafe_stack(const threadsafe_stack&);
 	threadsafe_stack& operator=(const threadsafe_stack&) = delete;	//赋值运算符被删除了

 	void push(T new_value);
 	std::shared_ptr<T> pop();
 	void pop(T& value);
 	bool empty() const;
 }; 