//使用无锁的std::shared_ptr<>的无锁栈实现
template <typename T>
class lock_free_stack
{
private:
	struct node
	{
		std::shared_ptr<T> data;
		std::shared_ptr<node> next;

		node(T const& data_):
			data(std::make_shared<T>(data_))
		{}
	};

	std::shared_ptr<node> head;
public:
	void push(T const& data)
	{
		std::shared_ptr<node> const new_node=std::make_shared<node>(data);
		new_node->next=head.load();
		while(!std::atomic_compare_exchange_weak(&head,&new_node->next,new_node))
	}
	
	std::shared_ptr<T> pop()
	{
		std::shared_ptr<node> old_head=std::atomic_load(&head);
		while(old_head && !std::atomic_compare_exchange_weak(&head,&old_head,old_head->next));
		return old_head ? old_head->data : std::shared_ptr<T>();
	}
};