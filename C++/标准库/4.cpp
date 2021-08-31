#include<iostream>
#include<vector>
#include<deque>
#include<algorithm>
#include<numeric>
using namespace std;

//unique sort
void unique_sort(vector<int> &words){
    sort(words.begin(),words.end());
    auto end_unique = unique(words.begin(),words.end());
    words.erase(end_unique,words.end());
}


int main(){
    // 所以这万一是怎么记住上一个的状态的呢？
    // 查阅资料，发现这个函数是根据函数大小顺序生成下一个
    // 例如5,6,7的下一个是5,7,6
    // 但是7,6,5就没有下一个了，因为它已经是最大的排列了。
    // vector<int> n{4,2,5,2,5,6,7};
    vector<int> n {7,6,5};
    for(auto a :n){
        cout<<a<<" ";
    }
    cout<<endl;
    next_permutation(n.begin(),n.end());
    for(auto a :n){
        cout<<a<<" ";
    }
    cout<<endl;
    next_permutation(n.begin(),n.end());
    for(auto a :n){
        cout<<a<<" ";
    }
    cout<<endl;
    next_permutation(n.begin(),n.end());

    // next_permutation(n.begin(),n.end());
    // next_permutation(n.begin(),n.end());
    for(auto a :n){
        cout<<a<<" ";
    }
    cout<<endl;
    
    // for(int m :n){
    //     cout<<m<<" ";
    // }
    // cout<<endl;
    // unique_sort(n);

    //     for(int m :n){
    //     cout<<m<<" ";
    // }
    // cout<<endl;
    // for_each(n.begin(),n.end(),[](int &a){
    //     a=1;
    //     return;
    // });
    // for_each(n.begin(),n.end(),[](int&a){
    //     cout<<a<<endl;
    // });
    // return 0;
}