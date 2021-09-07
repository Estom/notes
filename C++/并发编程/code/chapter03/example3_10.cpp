//在比较运算符中每次锁定一个互斥元
class Y
{
private:
	int some_detail;
	//被mutable修饰的变量(mutable只能由于修饰类的非静态数据成员),将永远处于可变的状态,即使在一个const函数中。
	mutable std::mutex m;

	int get_detail() const
	{
		std::lock_guard<std::mutex> lock_a(m);
		return some_detail;
	}
public:
	Y(int sd):some_detail(sd){}

	freind bool operator==(Y const& lhs, Y const& rhs)
	{
		if(&lhs==&rhs)
			return true;
		int const lhs_value=lhs.get_detail();
		int const rhs_value=rhs.get_detail();
		return lhs_value==rhs_value;
	}
};