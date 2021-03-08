// thread
#include<thread>
#include<chrono>
#include<random>
#include<iostream>
#include<exception>


using namespace std;

void doSomething(int num,char c){
    try
    {
        default_random_engine dre(42*c);
        uniform_int_distribution<int> id(10,1000);
        for(int i=0;i<num;++i){
            this_thread::sleep_for(chrono::milliseconds(id(dre)));
            cout.put(c).flush();
        }
    }
    catch(const std::exception& e)
    {
        cerr << e.what() << '\n';
        cerr << this_thread::get_id()<<endl;
    }
}

int main(){
    try{
        thread t1(doSomething,5,'.');
        cout<<"start thread"<<t1.get_id()<<endl;
        //启动了多个异步线程
        for(int i=0;i<5;++i){
            thread t(doSomething,10,'a'+i);//启动了5个线程
            cout<<"detach start thread"<<t.get_id()<<endl;
            t.detach();
        }
        cin.get();
        cout<<"join thread"<<t1.get_id()<<endl;
        //进行线程同步
        t1.join();
    }
    catch(const exception& e){
        cerr<<e.what()<<endl;
    }
}