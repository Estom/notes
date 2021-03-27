#include<iostream>
#include<sstream>
#include<string>
#include<vector>
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
    // size_t m;
    // string s="123avicfee";
    // int a = stoi(s,&m,10);
    // cout<<a<<endl;
    // cout<<m<<endl;

    string strs ="  adb   dai fei af";
    
    string pattern = " ";
    size_t start_pos=0;
    size_t end_pos = strs.find(pattern,start_pos);
    vector<string> vec;
    string temp;
    while (end_pos != string::npos)
    {   cout<<start_pos<<"--"<<end_pos<<endl;
        if(start_pos!=end_pos){
            temp = strs.substr(start_pos,end_pos-start_pos);
            vec.push_back(temp);
        }
        start_pos = end_pos+1;
        end_pos = strs.find(pattern,start_pos);
        
    }
    vec.push_back(strs.substr(start_pos,strs.size()-start_pos));
    for(auto a : vec){
        cout<<"name:"<<a<<":end"<<endl;
    }
    return 0;
}