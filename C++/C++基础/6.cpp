#include <iostream>
#include <vector>
using namespace std;

int hello(int a, int b)
{
    cout << a << b << endl;
    return 0;
}

//多个形参列表，必须是相同类型。
//另外把这个东西换成vector也是没有问题的。
//但是这个东西C++默认提供的类型，不需要头文件。
int multi_value(initializer_list<int> lst)
{
    auto begin = lst.begin();
    auto last = lst.end();
    while (begin != last)
    {
        cout << *begin << endl;
        begin++;
    }
    return 0;
}

int main()
{
    int i = 0;
    // hello(i+1,i=i+1);
    multi_value({1, 2, 3, 5});
    return 0;
}