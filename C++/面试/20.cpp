/* 
* C++ string 类的实现
* 1. 构造函数和析构函数
* 2. 字符串长度
* 3. 重载=运算符
* 4. 重载+=运算符
* 5. 重载<< >> 运算符
* 6. 重载比较运算符
* 7. 重载[]下标运算符
*/

#include <iostream>
#include <cstring>
using namespace std;

class MyString
{
private:
    char * str;
    int length;
public:
    // 长度
    int size ()const {
        return length;
    };
    char* getstr()const{
        return str;
    }
    // 默认构造函数
    MyString();
    // 字符串构造函数
    MyString(const char*);
    // 复制构造函数
    MyString(const MyString& b);

    // 重载等号运算符
    MyString& operator=(const MyString &b);
    // 重载+=运算符
    MyString& operator+=(const MyString &b);
    // 重载比较运算符
    bool operator<(const MyString &b);
    // 重载下标运算符
    char& operator[](const int &index) const ;
    // 重载输入输出操作
    friend ostream& operator<<(ostream& ,const MyString &b);
    ~MyString();
};

MyString::MyString()
{
    str = new char[1];
    str[0]='\0';
    length = 0;
}

MyString::MyString(const char* b){
    if(b){
        length = strlen(b);
        str = new char[length+1];
        strcpy(str,b);
    }
    else{
        MyString();
    }
}
MyString::MyString(const MyString&b){
    length = b.size();
    if(length>0)
    str = new char[length+1];
    else
    MyString();
}

MyString& MyString::operator=(const MyString &b){
    if(&b == this){
        return *this;
    }
    delete[] str;
    length = b.size();
    str = new char[length + 1];
    strcpy(str,b.getstr());
    return *this;
}

MyString& MyString::operator+=(const MyString&b){
    if(b.size()==0){
        return *this;
    }
    char* temp = new char[length+b.length+1];
    strcpy(temp,str);
    strcat(temp,b.getstr());
    delete[] str;
    str = temp;
    return *this;
}

char& MyString::operator[](const int &index)const {
    if(index>length)return str[length];
    return str[index];
}

bool MyString::operator<(const MyString &b){
    for(int i=0;i<length;i++){
        if(i>b.size())return false;
        if(b[i]>str[i])return true;
        if(b[i]<str[i])return false;
    }
    return true;
}

MyString::~MyString()
{
    delete[] str;
}

// 外部定义一个函数，内部声明为友元
ostream& operator<<(ostream &out,const MyString&b){
    out<<b.getstr();
    return out;
}


int main()
{
    // 测试函数
    MyString s1,s2="123",s3,s4="456";
    s3=s2;
    s1=s2;
    s1+=s1;
    cout<<s1<<endl;
    cout<<s2<<endl;
    cout<<s3<<endl;
    cout<<(s3<s4)<<endl;
    cout<<endl;
    return 0;
}