#include<iostream>
#include<vector>
#include<algorithm>
#include<sstream>
#include<map>
using namespace std;

int main(){
    string s = "2\n7\n4 -4 -2 -1 -1 -1 -1\n5\n1 2 3 4 5\n";
    istringstream cin(s);
    // cin=is;
    int t=0;
    cin>>t;
    while(t--){
        int n;
        cin>>n;
        vector<int> vec;
        while(n--){
            int x;
            cin>>x;
            vec.push_back(x);
        }
        // sort(vec.begin(),vec.end());
        vector<int> sum_vec(vec.size(),0);
        vector<int> num_vec(vec.size(),0);
        multimap<int,int> m;
        
        int sum=0,num=0;
        for(int i=0;i<vec.size();i++){
            if(vec[i]>=0){
                sum+=vec[i];
                num++;
            }
            else{
                m.insert(pair<int,int>(vec[i],i));
            }
            sum_vec[i]=sum;
            num_vec[i]=num;
        }
        for(auto a=m.rbegin();a!=m.rend();a++){
            if(sum_vec[a->second]+a->first>0){
                for(int i=a->second;i<vec.size();i++){
                    sum_vec[i]+=a->first;
                    num_vec[i]++;
                }
            }
            cout<<sum_vec[vec.size()-1]<<" ";
        }
        cout<<endl;
        cout<<num_vec[vec.size()-1]<<endl;
    }
}