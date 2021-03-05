#include<iostream>
#include<fstream>
#include<sstream>
#include<string>
#include<vector>
using namespace std;

int main(){

    // //IO state test
    // int a{3};
    // cin>>a;
    // auto old_state = cin.rdstate();//返回s当前的状态
    // cout<<old_state<<endl;//输出状态
    // cout<<cin.eof()<<endl;//是否终止符
    // cout<<cin.fail()<<endl;//是否IO过程错误，但未崩溃
    // cout<<cin.bad()<<endl;//是否崩溃
    // cout<<cin.good()<<endl;//是否正产
    // cin.clear();//充值最初的状态
    // cin.setstate(old_state);//设置流的状态

    // int word =0;
    // while(cin>>word){//>>函数返回流的状态。如果成功则返回true

    // }
    // return 0;


    //string stream
    struct Person{
        string name;
        string phone;
    };
    vector<Person> p;
    string line;
    if(getline(cin,line)){
        Person pp;
        stringstream record(line);
        record>>pp.name;
        record>>pp.phone;
        p.push_back(pp);
    }
    cout<<p[0].name<<endl;
    cout<<p[0].phone<<endl;
}