#include<vector>
#include<iostream>
using namespace std;

class SetUnion{
public:
    vector<int> vec;
    // 初始化并查集
    SetUnion(int n){
        vec=vector<int>(n);
        for(int i=0;i<n;i++){
            vec[i]=i;
        }
    }
    // 没有路径压缩的递归查找
    int find_r(int x){
        if(x==vec[x])return x;
        else{
            return find_r(vec[x]);
        }
    }
    // 合并两个非连通图。
    void merge(int i,int j){
        vec[find(i)]=find(j);
    }
    // 有路径压缩的递归查找
    int find(int x){
        if(x==vec[x]){
            return x;
        }
        else{
            vec[x]=find(vec[x]);
            return vec[x];
        }
    }

};

int main(){

    return 0;
}