#include <iostream>
using namespace std;

int main()
{
    // unsigned int a =1;
    // int b = -1;
    // cout<<a*b<<endl;
    // int c = 011;
    // cout<<c<<endl;//cout会转换成十进制输出。格式化输出中有改变cout输出类型。
    // int d = 1;//直接初始化
    // int e = {2};//直接初始化
    // int f{3};//花括号列表初始化
    // int g(4);//括号列表，列表初始化
    // extern int f; //表示这个变量是个外部变量，在外部定义。
    // extern int f; //多次声明必须相互兼容。类型一致
    // f = 5;

    // int t =1;
    // int* i=&t, *j= &t;
    // cout<<*i<<endl;
    // cout<<*j<<endl;

    extern int fff;
    fff=11;
    cout << fff << endl;

    // fff = 11;
    // cout << fff << endl;
    return 0;
}