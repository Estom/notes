//在无锁队列中引用计数tail来实现push()
template <typename T>
class lock_free_queue
{
private:
private:
	struct node;

	struct counted_node_ptr
	{
		int external_count;
		node* ptr;
	};

	std::atomic<counted_node_ptr> head;
	std::atomic<counted_node_ptr> tail;

	//将此结构体保存在一个机器字中在许多平台中使原子操作更容易是无锁的
	struct node_counter
	{
		unsigned internal_count:30;		
		unsigned external_counters:2;		//这里的external_counters只包含两个比特，因为最多只有两个计数器
	};

	struct node
	{
		std::atomic<T*> data;
		std::atomic<node_counter> count;
		counted_node_ptr next;

		node()
		{
			node_counter new_count;
			new_count.internal_count=0;
			new_count.external_counters=2;
			count.store(new_count);

			next.ptr=nullptr;
			next.external_count=0;
		}
	};

public:
	void push(T new_value)
	{
		std::unique_ptr<T> new_data(new T(new_value));
		counted_node_ptr new_next;
		new_next.ptr=new node;
		new_next.external_count=1;
		counted_node_ptr old_tail=tail.load();

		for(;;)
		{
			increase_external_count(tail,old_tail);		//增加计数

			T* old_data=nullptr;
			if(old_tail.ptr->data.compare_exchange_strong(old_data,new_data.get()))		//解引用
			{
				old_tail.ptr->next=new_next;
				old_tail=tail.exchange(new_next);
				free_external_counter(old_tail);
				new_data.release();
				break;
			}
			old_tail.ptr->release_ref();
		}
	}
};