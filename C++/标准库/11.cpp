#include<iostream>
#include<algorithm>
#include<vector>
using namespace std;

int main(){

//使用find_if和lambda表达式
    vector<string> words={"abc","a","bc","feiao"};
    int sz =4;
    auto wc = find_if(words.begin(),words.end(),
        [&sz](const string &a){
            return a.size()>=sz;
        }
    );
    cout<<(*wc)<<endl;

// for_each给每一个元素的操作
    int sz2 = 3;
    for_each(words.begin(),words.end(),
        [&sz2](const string&a){
            if(a.size()>=sz2){
                cout<<a<<endl;
            }
        }
    );
// 捕获列表
    int a=3;        
    auto f = [&a]{return ++a;};//默认捕获列表不可修改
    a=10;
    cout<< f()<<endl;
    
    return 0;

}