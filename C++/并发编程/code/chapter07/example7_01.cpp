//使用std::atomic_flag的自旋锁互斥元的实现
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