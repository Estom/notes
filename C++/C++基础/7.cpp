#include<iostream>
#include<vector>
using namespace std;

// 这种使用流的方式感觉很好玩。
class Book{
private:
    int a;
    int b;
public:
    istream &read(istream &is)
    {
        is>>a>>b;
        return is;
    }

    ostream & print(ostream &os)
    {
        os<<a<<b<<endl;
        return os;
    }
};
class Car{
public:
    int a=0;
    int b=1;

    Car(int aa,int bb):a(aa),b(bb){};//初始化列表，进行初始化
    Car(int aa):Car(aa,0){};//委托构造函数，使用第一个构造函数进行构造。
    Car():Car(0,0){};//默认构造函数，委托构造函数
    string m="fjeioaf";
    string *n=&m;
};
int main(){

    Book bk;
    Car cr;
    // if(1){
    //     Car cr2;
    //     string k="shuai";
    //     cr2.a=2;
    //     cr2.b=3;
    //     cr2.m="yinkanglong";
    //     cr2.n=&k;
    //     cout<<"k addr:"<<&k<<endl;
    //     cr=cr2;//输出地址发现，二者地址不同，应该是发生了拷贝赋值，而不是单纯的地址赋值。
    //     cout<<&cr<<endl;
    //     cout<<&cr2<<endl;
    // }
    // cout<<cr.a<<cr.b<<cr.m<<endl;
    // cout<<*(cr.n)<<endl;
    // cout<<"cr addr:"<<cr.n<<endl;//发现这个地址与局部变量k的地址一致，并且可以访问。
    // // 块作用域能够限制名称的可见性，但是函数的才是堆栈生成销毁的条件。所以k的地址指向的值能够用。
    // // istream i = bk.read();
    // // ostream o = bk.print();

    // vector<Car> vc(3);//vector会自动调用元素对象的默认初始化函数。
    // cout<<vc[1].a<<endl;
    // vc[2].b=10;
    // cout<<vc[2].b<<endl;

    string uu = "fei";
    int rr(12);
    cout<<rr<<endl;
    Car t1(3,4);//调用构造函数
    Car t2 = Car(3,4);//调用构造函数
    // Car* t = new Car(3,4);
    Car tt{3,4};//可以调用构造函数
    vector<Car> ttt{Car(3.4),Car(5,6)};
    cout<<ttt[0].a<<endl;
    cout<<ttt[1].b<<endl;

    return 0;
}