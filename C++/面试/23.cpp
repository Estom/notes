#include <iostream>
#include <vector>
using namespace std;

// 测试字符串和字符数组的参数传递
void test1(int *s){
    cout<<*(s)<<endl;
    return;
}
void test2(int s[]){
    cout<<*s<<endl;
    return;
}
void test3(int s[5]){
    cout<<*s<<endl;
    return;
}

int main()
{
    int s1[]={1,2,3,4,5,6,7,8};
    int s2[3]={4,5,6};
    int* s3 = new int(999);
    test1(s1);
    test2(s1);
    test3(s1);
    return 0;
}