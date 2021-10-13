#include<iostream>
using namespace std;
int main(){
    // int a=1;
    // int b= 255;
    // int c = (a<<(sizeof(double)))|(b>>sizeof(int));
    // cout<<c<<endl;
    int arr[5]={5,6,7,8,9};
    int *b = (int *)(&arr+1);
    cout<<*(arr+1)<<*(b-1)<<endl;#i22
    return 0;
}