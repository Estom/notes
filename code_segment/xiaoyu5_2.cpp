#include<iostream>
#include<map>
using namespace std;

int main(){
    int N;
    cin>>N;
    map<int,int> m;
    while(N--){
        int x,y;
        cin>>x>>y;
        m.count(x)?m[x]++:m[x]=1;
        m.count(x+y+1)?m[x+y+1]--:m[x+y+1]=-1;
    }
    int max_num=0;
    int num=0;
    for(auto v:m){
        num+=v.second;
        max_num=max(num,max_num);
    }
    cout<<max_num<<endl;
}