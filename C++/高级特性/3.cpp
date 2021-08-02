#include <iostream>
using namespace std;
//重载被调用函数，查看完美转发的效果
void otherdef(int & t) {
    cout << "lvalue\n";
}
void otherdef(const int & t) {
    cout << "rvalue\n";
}
//重载函数模板，分别接收左值和右值
//接收右值参数。常量左值引用可以接受左值、常量左值、右值、常量右值。
template <typename T>
void function(const T& t) {
    otherdef(t);
}
//接收左值参数
template <typename T>
void function(T& t) {
    otherdef(t);
}
int main()
{
    function(5);//5 是右值
    int  x = 1;
    function(x);//x 是左值
    return 0;
}