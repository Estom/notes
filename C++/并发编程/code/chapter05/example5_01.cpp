//使用std::atomic_flag的自旋锁互斥实现
class spinlock_mutex
{
	std::atomic_flag flag;
public:
	spinlock_mutex():
		flag(ATOMIC_FLAG_INIT)
	{}
	void lock()
	{
		while(flag.test_and_set(std::memory_order_acquire));
	}
	void unlock()
	{
		flag.clear(std::memory_order_release);
	}
};
//为了锁定互斥元，循环执行test_and_set()知道旧值为false，指示这个线程将值设为true。解锁互斥元就是简单地清除标志。