//数组的创建、遍历、插入、删除
#include<iostream>
using namespace std;

int main(){
    // 定义数组
    int size =20;//容量
    int numbers =10;//数据量
    int a[20]={1,3,4,5,6,7,4,2,4,5};

    // 数组遍历
    for(int i=0;i<10;i++){
        cout<<a[i];
    }

    //数组插入,尾插入
    int value=9;
    if(numbers<size){
        a[numbers]=value;
        numbers++;
    }
    else{
        cout<<"overflow"<<endl;
    }
    // 数组插入，头插入
    int value2=10;
    if(numbers<size){
        for(int i=1;i<=numbers;i++){
            a[numbers]=a[numbers-i];
        }
        a[0]=value2;
    }
    else{
        cout<<"overflow"<<endl;
    }

    // 删除
    int aim=8;
    if(aim>=numbers){
        cout<<"overbound"<<endl;
    }
    else{
        for(int i=aim;i<numbers-1;i++){
            a[i]=a[i+1];
        }
    }

}