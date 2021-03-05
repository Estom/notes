#include<iostream>
#include<stack>
#include<vector>
#include<deque>
using namespace std;

int main(){

    //stack test
    deque<int> deq{2,3,4,5};
    stack<int> stk{deq};
    int m = stk.top();
    stk.pop();
    stk.push(111);
    cout<<m<<endl;
    for(int n:deq){
        cout<<n<<endl;
    }

    
    return 0;
}