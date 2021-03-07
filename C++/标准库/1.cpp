#include<iostream>
#include<utility>
#include<tuple>
#include<random>
#include<chrono>
using namespace std;

int main(){
    tuple<int,double,string> t{1,4,"fei"};
    default_random_engine e;
    cout<<e()<<endl;

    chrono::hours mday(24);
    chrono::seconds sec(mday);
    cout<<sec.count()<<endl;

    auto ti = chrono::system_clock::now();
    // cout<<asString(ti)<<endl;
}