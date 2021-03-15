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
    vector<int> vec;
    priority_queue<int> pir(vec,[](const int a,const int b){
        if(a>b){
            return true;
        }
        else{
            return false;
        }})
    return 0;
}