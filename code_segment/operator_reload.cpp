#include<iostream>
#include<vector>

using namespace std;

int compress(vector<char>& chars) {
    vector<char> vec;
    vector<int> num;
    char lc=chars[0];
    int ln=1;
    int j=0;
    for(int i=1;i<chars.size();i++){
        if(chars[i]==lc){
            ln++;
        }
        else{
            vec[j]=lc;
            num[j]=ln;
            j++;
            lc=chars[i];
            ln=1;
// 重载运算符。返回流本身，用于链式法则。如果需要访问私有变量
// 需要声明为友元。一般不需要声明为友元。
ostream & operator<<(ostream &os, const vector<int> temp)  
{
    for(auto a : temp){
        os<<a<<" ";
    }
    os<<endl;
    return os;
}
int main(){
	vector<int> arr{-1, 3, -3, 4,5};
    cout<<arr<<endl;

  	vector<int> temp(arr.size()+1,0);
	for(int i=0;i<arr.size();i++){
    	if(arr[i]<arr.size()+1 && arr[i]>0){
          temp[arr[i]]=1;
        }
    }
    vec[j]=lc;
    num[j]=ln;
    vector<char> &res=chars;
    res.clear();
    for(int i=0;i<vec.size();i++){
        res.push_back(vec[i]);
        if(num[i]==1)continue;
        if(num[i]>0){
            char temp = char(num[i]%10-0+'0');
            res.push_back(temp);
            num[i]/=10;
        }
    }
    return res.size();
}

<<<<<<< HEAD:a.cpp
int main(){
    vector<char> chars={'a','a','b'};
    for(auto a:chars){
        cout<<a<<endl;
    }
    compress(chars);

    for(auto a:chars){
        cout<<a;
    }
    cout<<endl;
    return 0;
}
=======
	return 0;
}



// 测试一下友元

>>>>>>> fb01b190883e115ab7560e5401aa57540e889977:code_segment/operator_reload.cpp
