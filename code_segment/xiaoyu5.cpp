#include<iostream>
#include<vector>
#include<algorithm>
// #include<sstream>
using namespace std;

struct Node{
    int val;
    int pos;
    Node(int v,int p){
        val=v;
        pos=p;
    }
    bool operator<(const Node& b){
        return val<b.val;
    }
};
int main(){
    // string s = "4\n1 2\n2 3\n3 5\n4 3\n";
    // istringstream cin(s);
    int N;
    cin>>N;
    vector<Node> vec;
    while(N--){
        int x,y;
        cin>>x>>y;
        vec.push_back(Node(x,1));
        vec.push_back(Node(x+y+1,-1));
    }
    sort(vec.begin(),vec.end());
    int max_num=0;
    int num=0;
    for(auto v:vec){
        num+=v.pos;
        max_num=max(num,max_num);
    }
    cout<<max_num<<endl;
}