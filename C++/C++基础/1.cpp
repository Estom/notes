#include <iostream>
using namespace std;

class B{
public:
    int a = 1;
    B():a(2){
        // a=3;
    }
};
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

    // extern int fff;
    // fff=11;
    // cout << fff << endl;

    // fff = 11;
    // cout << fff << endl;
    // int a = 10;
    // long long b = 10;
    // cout<<sizeof(a)<<"\t"<<sizeof(b)<<endl;

    // B *b =new B();
    // cout<<b->a<<endl;
    // int m = 10;
    // int *a[3]={&m,&m,&m};
    // int b[]={1,2,3};
    // int (*ptr)[3]=&b;

    // cout<<(*a)[7]<<endl;
    // cout<<(*ptr)[2]<<endl;

    const char* m = "123";
    const void* n = "123";

    char a[] = "123";
    char b[3] = "13";

    cout<<sizeof(m)<<"\t"<<sizeof(n)<<endl;
    cout<<sizeof(a)<<"\t"<<sizeof(b)<<endl;

    return 0;
}