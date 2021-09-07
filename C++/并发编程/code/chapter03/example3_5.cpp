//一个线程安全栈的详细类定义
#include <exception>
#include <memory>
#include <mutex>
#include <stack>

struct empty_stack: std::exception
{
	const char* what() const throw();
};

template <typename T>
class threadsafe_stack
{
private:
	std::stack<T> data;
//mutalbe的中文意思是“可变的，易变的”，跟constant（既C++中的const）是反义词。
//在C++中，mutable也是为了突破const的限制而设置的。被mutable修饰的变量(mutable只能由于修饰类的非静态数据成员)，
//将永远处于可变的状态，即使在一个const函数中。
	mutable std::mutex m;
public:
	threadsafe_stack(){}
	threadsafe_stack(const threadsafe_stack& other)
	{
		std::lock_guard<std::mutex> lock(other.m);
		data=other.data;
	}
	
	threadsafe_stack& operator=(const threadsafe_stack&) = delete;

	void push(T new_value)
	{
		std::lock_guard<std::mutex> lock(m);
		data.push(new_value);
	}
	std::share_ptr<T> pop()
	{
		std::lock_guard<std::mutex> lock(m);
		if(data.empty()) throw empty_stack();	//在试着出栈值的时候检查是否为空
		std::share_ptr<T> const res(std::make_shared<T>(data.top()));	//在修改栈之前分配返回值
		data.pop();
		return res;
	}
	void pop(T& value)
	{
		std::lock_guard<std::mutex> lock(m);
		if(data.empty()) throw empty_stack();
		value = data.top();
		data.pop();
	}
	bool empty() const
	{
		std::lock_guard<std::mutex> lock(m);
		return data.empty();
	}
};