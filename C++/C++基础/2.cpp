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

    // int t{3};
    // cout<<t<<endl;
    // string m{"3,4,5"};
    // cout<<m<<endl;
    // int a[]{3,4,5};
    // cout<<a[1]<<a[2]<<endl;

    // vector<int> p;
    // for(int i=0;i!=100;i++){
    //     p.push_back(i);
    // }

    //迭代器的使用
    // vector<int> v{1,2,3,4,5,6,7};
    // auto b =v.begin(),e=v.end();

    // while(b != e){
    //     cout<<*e<<endl;
    //     cout<<(*b)<<endl;
    //     b++;
    // }

    // // 二分查找实例
    // int aim =3;
    // vector<int> text ={1,2,3,4,5,6};
    // auto beg = text.begin(),end=text.end();
    // auto mid = text.begin()+(end-beg)/2;
    // while(mid != end && *mid != aim){
    //     if(aim<*mid){
    //         end=mid;
    //     }else{
    //         beg=mid+1;
    //     }
    //     mid =beg+(end-beg)/2;
    // }
    // cout<<mid-text.begin()<<endl;
    // class helo{
    //     int m;
    //     int n;
    // };
    // helo a[10];
    
    // int k[] = {1,2,3};
    // for (auto l:k){
    //     cout<<l<<endl;
    // }
    // cout<<*(k+1)<<endl;

    int ia[2][3]={1,2,3,4,5,6};
    for(auto &row:ia){
        for(auto col:row){
            cout<<col<<endl;
        }
    }
    return 0;
}