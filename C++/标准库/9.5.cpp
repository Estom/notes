//condition variable生产者消费者问题
#include<condition_variable>
#include<mutex>
#include<future>
#include<iostream>

using namespace std;


bool readyFlag;
mutex readyMutex;
condition_variable readyCondVar;

void thread1(){
    cout<<"thread1"<<endl;
    cin.get();

    //以下是lock保护区
    {
        lock_guard<mutex> lg(readyMutex);
        readyFlag = true;
    }
    readyCondVar.notify_one();
}

void thread2(){
    {
        unique_lock<mutex> ul(readyMutex);
        readyCondVar.wait(ul,[]{return readyFlag;});
    }

    cout<<"done"<<endl;
    return;
}

int main(){
    auto f1 = async(thread1);
    auto f2 = async(thread2);
}