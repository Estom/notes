#include<iostream>
#include<sstream>
#include<string>
using namespace std;

int main(){
    // istringstream s("145,5343,42,44");
    // int a;
    // s>>a;
    // cout<<a<<endl;

    // string str="12345678";
    // cout<<str.erase(3,1)<<endl;
    // cout<<str<<endl;
    
    // char* helo;
    // s.getline(helo,10,',');
    size_t m;
    string s="123avicfee";
    int a = stoi(s,&m,10);
    cout<<a<<endl;
    cout<<m<<endl;
    return 0;
}