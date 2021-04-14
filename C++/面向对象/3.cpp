#include<iostream>
using namespace std;



class Quote{
public:
    Quote() = default;
    Quote(string book,double sales_price):book_no(book),price(sales_price){};
    string isbn()const{
        return book_no;
    }
    virtual double net_price(int n)const{
        return n*price;
    }
    virtual ~Quote()=default;
private:
    string book_no;
protected:
    double price;
};

class Bulk_quote:public Quote{
public:
    Bulk_quote()=default;
    Bulk_quote(string,double,int,double);
    double net_price(int n)const override;
private:
    int mn_qty = 0;
    double discount=0.0;
};

Bulk_quote::Bulk_quote(string a,double b,int c,double d):Quote(a,b),mn_qty(c),discount(d){};
double Bulk_quote::net_price(int n)const{
    return n*price*discount;
}


class A{
public:
    int a;
    A():a(10){};
    int real_ex(){
        return a;
    }
    virtual int virtual_ex(){
        return a;
    }
};

class B:public A{
public:
    int b;
    B():b(20){};
    int real_ex(){//重定义A的函数
        return b;
    }
    virtual int virtual_ex(){//重写A的函数
        return b;
    }
};
int main(){

    Quote p(Bulk_quote());//直接初始化，拷贝构造函数
    Quote q = Bulk_quote();//赋值初始化，拷贝构造函数
    
    // B test_b;
    // A* test = &test_b;
    A* test=new B();
    cout<<test->real_ex()<<endl;//B重定义了函数。但是A类型的指针，调用基类的函数。
    cout<<test->virtual_ex()<<endl;//B重写类函数。B类型的对象，动态绑定，调用了派生类的函数。
    return 0;
}
