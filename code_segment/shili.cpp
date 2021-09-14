#include<iostream>
using namespace std;

class Wood{
private:
    int length;
    int width;
public:
    int get_length(){
        return this->length;
    }
    int get_width(){
        return this->width;
    }
};

class desk:public wood{
private:
    int height;
public:
    int get_height(){
        return this->height;
    }
};

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