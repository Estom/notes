#include<iostream>
#include<fstream>
#include<sstream>
#include<string>
#include<vector>
#include<iomanip>
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


    // //string stream。字符串初始化输入流，通过输入流读取字符串
    // struct Person{
    //     string name;
    //     string phone;
    // };
    // vector<Person> p;
    // string line;
    // if(getline(cin,line)){
    //     Person pp;
    //     stringstream record(line);
    //     record>>pp.name;
    //     record>>pp.phone;
    //     p.push_back(pp);
    // }
    // cout<<p[0].name<<endl;
    // cout<<p[0].phone<<endl;

    //string stream 对字符串进行格式化
    double value = 4.55667;
    string format_string;
    stringstream sstream;
    // 将int类型的值放入输入流中
    sstream<<setw(10)<<setfill('0')<<fixed<<setprecision(3)<<value;
    // 从sstream中抽取前面插入的int类型的值，赋给string类型
    sstream >> format_string;
    cout<<format_string;


    //2. 创建流
    ofstream output;
    
    //3. 打开文件，将流与文件相关联，这里使用相对路径
    output.open("number.txt");
    
    //4. 向文件写入数据
    output << 1 << " " << 2 << " " << 3 << endl;
    
    //5. 关闭流
    output.close();
    
    return 0;
}