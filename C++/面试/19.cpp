#include<iostream>

using namespace std;

// 测试结构体内存对齐
struct data
{
    char a='1';
    char b='2';
    char c='3';
    char h='5';
    char e='6';
    int d = 4;

};

int main(){
    struct data d;
    cout<<sizeof(d)<<endl;//=12
    cout<<&d.a<<endl;
    cout<<d.d<<endl;
    return 0;
}