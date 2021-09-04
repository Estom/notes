#include<iostream>
using namespace std;
int add(int a,int b){
    int c = a+b;
    return c;
}

int main(){
    int a=10,b=11;
    add(a,b);
    int m = 10;
    while(m--){
        if(m>5){
            cout<<m<<endl;
        }
    }
    return 0;
}