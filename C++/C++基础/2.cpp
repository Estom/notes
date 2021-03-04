#include <iostream>
#include <string>
#include <cctype>
#include <vector>
using namespace std;

int main()
{
    // const char* cc("abc\0");
    // char cc2[]={"abc\0"};
    // string a = "abc";
    // string b = "abc\0";
    // string c(cc2);
    // cout << a << a.size() << sizeof(a) << endl;
    // cout << b << b.size() << sizeof(b) <<endl;
    // cout << c << c.size() << sizeof(c) <<endl;

    // string str("hello world!");
    // int punc =0;
    // for(auto &c :str){
    //     if(ispunct(c)){
    //         punc++;
    //     }
    //     c = toupper(c);
    //     cout<<c<<endl;
    //     cout<<str<<endl;
    // }
    // string s("helo");
    // for(int index =0;index != s.size();++index){
    //     cout<<s[index];
    //     s[index]=toupper(s[index]);
    // }
    // cout<<s<<endl;

    int t{3};
    cout<<t<<endl;
    string m{"3,4,5"};
    cout<<m<<endl;
    int a[]{3,4,5};
    cout<<a[1]<<a[2]<<endl;

    vector<int> p;
    for(int i=0;i!=100;i++){
        p.push_back(i);
    }
    return 0;
}