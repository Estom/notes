#include<iostream>
#include<map>
using namespace std;


int main(){
    map<int,int> m;
    m[10]=10;
    m[4]=4;
    m[5]=5;
    m[1000]=1000;
    m[1]=1;
    for(auto k:m){
        cout<<k.first<<endl;
    }
    // cout<<map[3].first<<endl;
    return 0;
}