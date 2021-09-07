//通过成对更新的partial_sum的并行实现
struct barrier
{
	std::atomic<unsigned> count;
	std::atomic<unsigned> spaces;
	std::atomic<unsigned> generation;

	barrier(unsigned count_):
		count(count_),spaces(count_),generation(0)
	{}

	void wait()
	{
		unsigned const gen=generation.load();
		if(!--spaces)
		{
			spaces=count.load();
			++generation;
		}
		else
		{
			while(generation.load()==gen)
			{
				std::this_thread::yield();		//是将当前线程所抢到的CPU”时间片A”让渡给其他线程
			}
		}
	}

	void done_waiting()
	{
		--count;
		if(!--spaces)
		{
			spaces=count.load();
			++generation;
		}
	}
};

template <typename Iterator>
void parallel_partial_sum(Iterator first,Iterator last)
{
	typedef typename Iterator::value_type value_type;

	struct process_element
	{
		void operator()(Iterator first,Iterator last,
						std::vector<value_type>& buffer,
						unsigned i,barrier& b)
		{
			value_type& ith_element=*(first+i);
			bool update_source=false;

			for(unsigned step=0,stride=1;stride<=i;++step,stride*=2)
			{
				value_type const& source=(step%2)?buffer[i]:ith_element;
				value_type& dest=(step%2)?ith_element:buffer[i];
				value_type const& addend=(step%2)?buffer[i-stride]:*(first+i-stride);

				dest=source+addend;
				update_source=!(step%2);
				b.wait();		//开始下一步之前在屏障上等待
			}
			//如果你的最终结果存储在缓冲器中的话，就更新原先范围里的元素
			if(update_source)
			{
				ith_element=buffer[i];
			}
			b.done_waiting();
		}
	};

	unsigned long const length=std::distance(first,last);

	if(length<=1)
		return;

	std::vector<value_type> buffer(length);
	barrier b(length);

	std::vector<std::thread> threads(length-1);
	join_threads joiner(threads);

	Iterator block_start=first;
	for(unsigned long i=0;i<(length-1);++i)
	{
		threads[i]=std::thread(process_element(),first,last,std::ref(buffer),i,std::ref(b));
	}
	process_element()(first,last,buffer,length-1,b);
}