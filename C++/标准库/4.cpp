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
    vector<int> n{4,2,5,2,5,6,7};
    
    for(int m :n){
        cout<<m<<" ";
    }
    cout<<endl;
    unique_sort(n);

        for(int m :n){
        cout<<m<<" ";
    }
    cout<<endl;
    return 0;
}