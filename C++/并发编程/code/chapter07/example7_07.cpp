//get_hazard_pointer_for_current_thread()的简单实现
unsigned const max_hazard_pointers=100;
struct hazard_pointer
{
	std::atomic<std::thread::id> id;
	std::atomic<void*> pointer;
};
hazard_pointer hazard_pointers[max_hazard_pointers];

class hp_owner
{
	hazard_pointer* hp;

public:
	hp_owner(hp_owner const&)=delete;
	hp_owner& operator=(hp_owner const&)=delete;

	hp_owner():
		hp(nullptr)
	{
		for (unsigned i = 0; i < max_hazard_pointers; ++i)
		{
			std::thread::id old_id;
			//试着获取风险指针的所有权
			if(hazard_pointers[i].id.compare_exchange_strong(old_id,std::this_thread::get_id()))
			{
				hp=&hazard_pointers[i];
				break;
			}
		}
		if(!hp)
		{
			throw std::runtime_error("No hazard pointers available");
		}
	}

	std::atomic<void*>& get_pointer()
	{
		return hp->pointer;
	}
	//线程退出，hp_owner实例就被销毁了
	~hp_owner()
	{
		hp->pointer.store(nullptr);
		hp->id.store(std::thread::id());
	}	
};

std::atomic<void*>& get_hazard_pointer_for_current_thread()
{
	thread_local static hp_owner hazard;	//每个线程有自己的风险指针
	return hazard.get_pointer();
}