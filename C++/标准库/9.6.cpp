//condition variable实现多线程queue
#include<condition_variable>
#include<mutex>
#include<future>
#include<thread>
#include<iostream>
#include<queue>

using namespace std;

queue<int> que;//消费对象
mutex queueMutex;
condition_variable queueCondVar;

//生产者
void provider(int val){
    for(int i=0;i<6;++i){
        lock_guard<mutex> lg(queueMutex);
        que.push(val+i);
        //貌似这句话会被优化掉
        this_thread::sleep_for(chrono::microseconds(100000));
    }
    queueCondVar.notify_one();

    this_thread::sleep_for(chrono::microseconds(val));
}


//消费者
void consumer(int num){
    while(true){
        int val;
        {
            unique_lock<mutex> ul(queueMutex);
            queueCondVar.wait(ul,[]{return !que.empty();});
            val = que.front();
            que.pop();
            cout<<"consumer"<<num<<":"<<val<<endl;

        }
    }

}

int main()
{
    //生产者列表
    auto p1 = async(provider,1000);
    auto p2 = async(provider,2000);
    auto p3 = async(provider,3000);

    //消费者列表
    auto c1 = async(consumer,1);
    auto c2 = async(consumer,2);
}