#include<iostream>
#include<utility>
#include<tuple>
#include<random>
using namespace std;

int main(){
    tuple<int,double,string> t{1,4,"fei"};
    default_random_engine e;
    cout<<e()<<endl;

}