//mute & lock
#include<future>
#include<mutex>
#include<iostream>
#include<string>

using namespace std;

//互斥体的控制变量
mutex printMutex;

void print(const std::string&s){
    // 如果没有枷锁，多个线程共同调用会乱序输出
    lock_guard<mutex> l(printMutex);
    for(char c:s){
        cout.put(c);
    }
    cout<<endl;
}

int main()
{
    auto f1 = async(print,"Hello from a first thread");
    auto f2 = async(print,"hello from a second thread");

    print("hello from the main thread");

    return 0;
}