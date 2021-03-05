#include<iostream>
using namespace std;

int main(){
    int a=1,b=2;
    auto l = [](int m,int n)->int{cout<<m+n<<endl;return m+n;};
    //省去了函数的名字，生成一个函数对象。可以调用函数。
    cout<<l(a,b)<<endl;
    return 0;
}