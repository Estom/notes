#include<iostream>
#include<sstream>
#include<iterator>
#include<vector>
#include<list>

using namespace std;

int main(){

    list<int> lst ={1,2,3,4};
    list<int> lst2,lst3;
    //反向一个列表
    copy(lst.cbegin(),lst.cend(),front_inserter(lst2));
    //正向一个列表
    copy(lst.cbegin(),lst.cend(),inserter(lst3,lst3.begin()));
    
    /*
    * 读取数据的三种方法
    * 直接使用输入输出流iostream
    * 使用字符串方法封装getline
    * 使用迭代器读取输入输出流istream_iterator/ostream_iterator
    */
    istream_iterator<int> in_iter(cin);//从cin读取数据
    istream_iterator<int> eof;//尾后迭代器
    istringstream in_string("hello world");
    istream_iterator<string> str_it(in_string);//字符串流迭代器
    
    int a =0;
    a = *in_iter;
    cout<<a<<endl;
    // in_iter++;
    cout<<*str_it<<endl;
    str_it++;
    cout<<*str_it<<endl;

    ostream_iterator<int> out_iter(cout,"\n");
    *out_iter =10;
    *out_iter = 100;
    return 0;
}