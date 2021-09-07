//在使用两个引用计数的无锁栈中入栈结点
template <typename T>
class lock_free_stack
{
private:
	struct node;

	struct counted_node_ptr
	{
		int external_count;
		node* ptr;
	};

	struct node
	{
		std::shared_ptr<T> data;
		std::atomic<int> internal_count;
		counted_node_ptr next;

		node(T const& data_):
			data(std::make_shared<T>(data_)),
			internal_count(0)
		{}
	};

	std::atomic<counted_node_ptr> head;

public:
	
	~lock_free_stack()
	{
		while(pop());
	}
	
	void push(T const& data)
	{
		counted_node_ptr new_node;
		new_node.ptr=new node(data);
		new_node.external_count=1;
		new_node.ptr->next.ptr->next=head.load();
		while(!head.compare_exchange_weak(new_node.ptr->next,new_node));
	}
};