#include<iostream>
#include<vector>
#include<algorithm>
#include<sstream>
#include<stack>
using namespace std;
// 拓扑排序——循环入度为零
vector<int> tuopu1(vector<vector<int>> vec){
    vector<int> res;
    vector<int> in(vec.size(),0);
    vector<int> flag(vec.size(),0);
    for(int i=0;i<vec.size();i++){
        for(int j=0;j<vec[i].size();j++){
            in[vec[i][j]]++;
        }
    }
    
    for(int i=0;i<vec.size();i++){
        int j;
        // 查找入度为零的节点，添加到结果中，并标记
        for(j=0;j<vec.size();j++){
            if(in[j]==0 && flag[j]==0){
                flag[j]=1;
                res.push_back(j);
                break;
            }
            
        }
        // 将该节点的下一个节点的入度减1
        for(auto a:vec[j]){
            in[a]--;
        }
    }
    return res;
}

// 拓扑排序——深度递归+栈
void tuopu2(vector<vector<int>> &vec,stack<int> &st,vector<int> &flag,int node){
      for(int i=0;i<vec[node].size();i++){
            if(flag[vec[node][i]]==0){
                tuopu2(vec,st,flag,vec[node][i]);
            }
      }
      if(flag[node]==0){
            st.push(node);
            flag[node]=1;
      }
}

// 使用深度优先搜索计算
int dfs(vector<vector<int>> &vec,vector<int> &cost,int node,int c){
    int max_cost=c+cost[node];
    // cout<<max_cost<<endl;
    for(int i=0;i<vec[node].size();i++){
        max_cost = max(max_cost,dfs(vec,cost,vec[node][i],c+cost[node]));
    }
    return max_cost;
}
int main(){
    string input="4\nsoftmax 10 1 2\nrelu 5\nconv1 1 3 1\nsoftmax 2";
    istringstream cin(input);
    int N ;
    cin>>N;
    cout<<N<<endl;
    // 表示每个边花费的时间
    vector<int> cost(N,0);
    // 使用邻接链表表示关系吧。单点触发的所有边
    vector<vector<int>> vec(N,vector<int>());
    cin.ignore();
    // string input2;
    // getline(cin,input2);
    for(int i=0;i<N;i++){
        string line;
        getline(cin,line,'\n');
        // cout<<line<<endl;
        istringstream is(line);
        string name;
        is>>name;
        is>>cost[i];
        int next;
        while(is>>next){
            vec[i].push_back(next);
        }
        cout<<name<<":"<<cost[i]<<endl;
    }
    // for(auto a:vec){
    //     for(auto b:a){
    //         cout<<b<<" ";
    //     }
    //     cout<<endl;
    // }
    cout<<"result:"<<dfs(vec,cost,0,0)<<endl;

    // 进行拓扑排序并查看结果

    vector<int> res = tuopu1(vec);
    for(auto a:res){
        cout<<a<<" ";
    }
    cout<<endl;

    vector<int> flag(vec.size(),0);
    stack<int> st;
    tuopu2(vec,st,flag,0);
    vector<int> res2;
    while(!st.empty()){
        cout<<st.top()<<" ";
        res2.push_back(st.top());
        st.pop();
        
    }
    cout<<endl;
    // 然后根据拓扑排序计算最长时间。没哟必要

}