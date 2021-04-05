#include<iostream>
#include<stack>
#include<vector>
#include<deque>
#include<queue>
using namespace std;

int main(){

    //stack test
    // deque<int> deq{2,3,4,5};
    
    // stack<int> stk{deq};
    // int m = stk.top();
    // stk.pop();
    // stk.push(111);
    // cout<<m<<endl;
    // for(int n:deq){
    //     cout<<n<<endl;
    // }

    // vector<int> vec;
// 构造边的对象
struct Edge
{
    int start;
    int end;
    int weight;
    Edge(int s,int e,int w){
        start=s;
        end=e;
        weight=w;
    }
    // 重写<运算符
    bool operator<(const Edge& a)const{
        return a.weight < weight;
    }
};
    priority_queue<Edge> pri;
    Edge e1(1,2,3);
    Edge e2(3,2,1);
    Edge e3(2,1,4);
    pri.push(e1);
    pri.push(e2);
    pri.push(e3);
    while(!pri.empty()){
        cout<<pri.top().weight<<endl;
        pri.pop();
    }
    return 0;
}