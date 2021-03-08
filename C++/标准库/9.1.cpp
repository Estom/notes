//async & future
#include<iostream>
#include<future>
#include<chrono>
#include<random>
#include<iostream>
#include<exception>

using namespace std;

int do_something(char c){
    //初始化了一个随机数引擎和一个随机数分布
    default_random_engine dre(c);
    uniform_int_distribution<int> id(10,1000);

    for(int i =0;i<10;++i){
        //随机停止一段时间。
        this_thread::sleep_for(chrono::milliseconds(id(dre)));
        cout.put(c).flush();
    }
    return c;
}

int func1(){
    return do_something('.');
}

int func2(){
    return do_something('+');
}

int main(){
    //启动异步线程，执行函数1。使用future作为占位符
    //async的返回值与func1自动匹配，是模板函数。
    //future object的类型也可以与async自动匹配，设置成auto result1()
    //async接受任何可调用对象。包括函数、函数指针、lambda函数
    future<int> result1(async(func1));

    //主线程中执行函数2
    int result2 = func2();

    int result=0;
    try
    {
        result = result1.get()+result2;

    }
    catch(const std::exception& e)
    {
        std::cerr << e.what() << '\n';
    }
    
    //计算结果，阻塞主线程

    //输出结果
    cout<<result<<endl;

    // cout<<chrono::seconds(10).count()<<endl;
    return 0;
}