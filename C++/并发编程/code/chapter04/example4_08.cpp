//std::packaged_task<>特化的部分类定义
template<>
class packaged_task<std::string(std::vector<char>*,int)>
{
public:
	template<typename Callable>
	explicit packaged_task(Callable&& f);
	std::future<std::string> get_future();
	void operator()(std::vector<char>*,int);
};