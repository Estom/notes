#include<iostream>
#include<vector>
#include<algorithm>
using namespace std;


int main(){

    vector<int> vec{1,2,3};
    for_each(vec.begin(),vec.end(), [&](int &a){
        a++;
    });
    for(auto a:vec){
        cout<<a<<endl;
    }
}