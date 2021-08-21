#include<iostream>
#include<vector>

using namespace std;
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
    int i;
  	for(i=1;i<temp.size();i++){
      if(temp[i]==0)break;
    }
    cout<<i<<endl;

	return 0;
}



// 测试一下友元

