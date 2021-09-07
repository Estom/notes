//使用std::async的并行查找算法的实现
template <typename Iterator,typename MatchType>
Iterator parallel_find_impl(Iterator first,Iterator last,MatchType match,std::atomic<bool>& done)
{
	try
	{
		unsigned long const length=std::distance(first,second);
		unsigned long const min_per_thread=25;
		if(length<(2*min_per_thread))
		{
			for(;(first!=last) && !done.load();++first)
			{
				if(*first==match)
				{
					done=true;
					return first;
				}
			}
			return last;
		}
		else
		{
			Iterator const mid_point=first+(length/2);
			std::future<Iterator> async_result=std::async(&parallel_find_impl<Iterator,MatchType>,
														  mid_point,last,match,std::ref(done));
			Iterator const direct_result=parallel_find_impl(first,mid_point,match,done);
			return (direct_result==mid_point)?async_result.get():direct_result;
		}
	}
	catch(...)
	{
		done=true;
		throw;
	}
}

template <typename Iterator,typename MatchType>
Iterator parallel_find(Iterator first,Iterator last,MatchType match)
{
	std::atomic<bool> done(false);
	//线程间共享的标志，需要传递给所有递归调用。从主入口点传递进来的。
	return parallel_find_impl(first,last,match,done);
}