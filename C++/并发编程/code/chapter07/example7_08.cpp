//回收函数的简单实现
template <typename T>
void do_delete(void* p)
{
	delete static_cast<T*>(p);
}

struct data_to_reclaim
{
	void* data;
	std::function<void(void*)> deleter;
	data_to_reclaim* next;

	template <typename T>
	data_to_reclaim(T* p):
		data(p),
		deleter(&do_delete<T>),
		next(0)
	{}

	~data_to_reclaim()
	{
		deleter(data);
	}
};

std::atomic<data_to_reclaim*> nodes_to_reclaim;
void add_to_reclaim_list(data_to_reclaim* node)
{
	node->next=nodes_to_reclaim.load();
	while(!nodes_to_reclaim.compare_exchange_weak(node->next,node));
}

template <typename T>
void reclaim_later(T* data)
{
	add_to_reclaim_list(new data_to_reclaim(data));
}

bool outstanding_hazard_pointers_for(void* p)
{
	for(unsigned i=0;i<max_hazard_pointers;++i)
	{
		if(hazard_pointers[i].pointer.load()==p)
		{
			return true;
		}
	}
	return false;
}

void delete_nodes_with_no_hazards()
{
	data_to_reclaim* current=nodes_to_reclaim.exchange(nullptr);
	while(current)
	{
		data_to_reclaim* const next=current->next;
		if(!outstanding_hazard_pointers_for(current->data))
		{
			delete current;
		}
		else
		{
			add_to_reclaim_list(current);
		}
		current=next;
	}
}