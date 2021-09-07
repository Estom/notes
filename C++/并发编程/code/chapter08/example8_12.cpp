//屏障(barrier)，一种同步方法使得线程等待直到要求的线程已经到达了屏障。
//一个简单的屏障类
class barrier
{
	unsigned const count;
	std::atomic<unsigned> spaces;
	std::atomic<unsigned> generation;
public:
	explicit barrier(unsigned count_):
		count(count_),spaces(count),generation(0)
	{}
	void wait()
	{
		unsigned const my_generation=generation;
		if(!--spaces)			//到达0时，通过共享的generation变量通知其它线程行动
		{
			spaces=count;
			++generation;
		}
		else
		{
			while(generation==my_generation)	//如果空闲的spaces的数量没有到达零，你就必须等待，简单的自旋锁
				std::this_thread::yield();
		}
	}
};