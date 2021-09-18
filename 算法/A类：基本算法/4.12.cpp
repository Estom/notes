#include<iostream>

using namespace std;

int gcd1(int x,int y){
    if(x%y==0){
        return y;
    }
    return gcd1(y,x%y);
}

int gcd2(int x,int y){
    int r = x % y;
    while( r )
    {
        x = y;
        y = r;
        r = x % y;
    }
    return y;
}

int lcm(int x,int y){
    int k = gcd2(x,y);
    return x*y/k;
}
int main(){
    int x=60,y=95;
    cout<<gcd1(x,y);
    return 0;
}