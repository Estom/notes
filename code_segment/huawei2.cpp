#include<iostream>
#include<vector>
#include<algorithm>
using namespace std;


string get(string s,vector<string> dictionary){
    vector<int> vec(dictionary.size(),0);
    for(int i=0;i<s.size();i++){
        for(int j=0;j<dictionary.size();j++){
            // cout<<dictionary[j][vec[j]] << " "<< s[i]<<endl;
            if(vec[j]<dictionary[j].size() && dictionary[j][vec[j]]==s[i]){
                vec[j]++;
            }
            // else if(vec[j]==dictionary[j].size())
        }
    }
    int max_length =0;
    int index=-1;
    for(int i=0;i<s.size();i++){
        if(vec[i]==dictionary[i].size() && vec[i]>max_length){
            index=i;
            max_length=dictionary[i].size();
        }
    }
    if(max_length==0){
        return "";
    }
    return dictionary[index];
}
int main(){
    string s = "abpcplea";
    vector<string> dictionary = {"ale","apple","monkey","plea"};
    // vector<string> dictionary = {"a","b","c"};

    sort(dictionary.begin(), dictionary.end());
    string res = get(s,dictionary);
    cout<<res<<endl;
    return 0;
}