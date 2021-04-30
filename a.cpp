#include<iostream>
#include<vector>

using namespace std;

int main(){
	vector<int> arr{-1, 3, -3, 4,5};
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