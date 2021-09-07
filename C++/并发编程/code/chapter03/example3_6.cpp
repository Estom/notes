//在交换操作中使用std::lock()和std::lock_guard
class some_big_object;
void swap(some_big_object& lhs,some_big_object& rhs);

class X
{
private:
	some_big_object some_detail;
	std::mutex m;
public:
	X(some_big_object const& sd):some_detail(sd){}

	friend void swap(X& lhs, X& rhs)
	{
		if(&lhs == &rhs)
			return;
		std::lock(lhs.m,rhs.m);	//std::lock函数可以同时锁定两个或更多的互斥元，而没有死锁的风险。
		std::lock_guard<std::mutex> lock_a(lhs.m,std::adopt_lock);
		//额外提供一个adopt_lock给互斥元,沿用互斥元上已有锁的所有权
		std::lock_guard<std::mutex> lock_b(rhs.m,std::adopt_lock);
		swap(lhs.some_detail,rhs.some_detail);
	}
}