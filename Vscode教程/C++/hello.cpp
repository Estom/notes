#include<iostream>
#include<vector>
using namespace std;

int main(){
    vector<string> vec{"hello", "world","nihao","!"};
    for(auto a:vec){
        cout<<a<<" ";
    }
    cout<<endl;
    return 0;
}