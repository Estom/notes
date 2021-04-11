#include<iostream>
using namespace std;

int main(){
    int n=1;
    cin>>n;

    int a=0;
    //编译器提示数组的长度必须是常量（即编译器能够推断出数组的地址）
    // 但是，编译器好像并没有报错而是采用了动态重定位的方式解决了运行时才能确定的数组的长度。
    // 反正用vector就不会出现这些问题了，因为他们的空间都是在堆上分配的。
    int b[n];
    int c=0;
    cout<<&a<<" "<<&b<<" "<<&c<<endl;
    cin>>c;
    return 0;
}