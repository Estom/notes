#include<iostream>
#include<memory>
using namespace std;

int main(){
    //最安全的分配和使用广东台内存的方法，
    shared_ptr<int> p1 = make_shared<int>(42);
    shared_ptr<int> p2(new int(42));

    unique_ptr<string> p1(new string("stego"));
    return 0;
}