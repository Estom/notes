#include<iostream>
#include<sstream>
#include<string>
#include<vector>
using namespace std;

void test_seq(){
    cout<<"test_seq"<<endl;
    string s = "1234";
    s.push_back('5');
    cout<<s<<endl;
    s.insert(s.begin()+2,'0');
    cout<<s<<endl;
    cout<<s.size()<<endl;
    cout<<sizeof(s)<<endl;
    cout<<s.capacity()<<endl;
    s.pop_back();
    for(auto beg = s.begin(); beg!=s.end(); beg++){
        cout<<*beg<<endl;
    }
}

void test_find(){

    string strs ="  adb   dai fei af";
    
    string pattern = " ";
    size_t start_pos=0;
    size_t end_pos = strs.find(pattern,start_pos);
    vector<string> vec;
    string temp;
    while (end_pos != string::npos){   
        cout<<start_pos<<"--"<<end_pos<<endl;
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
}

void test_substr(){
    istringstream s("145,5343,42,44");
    int a;
    s>>a;
    cout<<a<<endl;

    string str="12345678";
    cout<<str.erase(3,1)<<endl;
    cout<<str<<endl;
    
    char* helo;
    s.getline(helo,10,',');
    size_t m;
    // string s="123avicfee";
    // int a = stoi(s,&m,10);
    cout<<a<<endl;
    cout<<m<<endl;

}
void test_contruct(){
    string a("12345",2,2);
    cout<<a<<endl;
}
int main(){
    // test_contruct();
    // test_seq();
    test_find();
    // test_substr();
    return 0;
}