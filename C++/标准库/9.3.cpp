//promise
#include<thread>
#include<future>
#include<iostream>
#include<string>
#include<exception>
#include<functional>
#include<utility>

using namespace std;
void doSomething(promise<string>& p){
    try{
        cout<<"read char x for exception"<<endl;
        char c = cin.get();
        if(c=='x'){
            throw runtime_error(string("char")+c+"fault");
        }
        else{
            string s = string("char")+c+"correct";
            p.set_value(move(s));//移动赋值函数。防止退出局部变量后销毁。
        }
    }
    catch(...){
        p.set_exception(current_exception());
    }
}

int main()
{

    try{
        promise<string>p;
        thread t(doSomething,std::ref(p));
        t.detach();

        future<string> f(p.get_future());

        cout<<"result:"<<f.get()<<endl;
    }
    catch(const exception& e){
        std::cerr<<"exception"<<e.what()<<endl;
    }
}