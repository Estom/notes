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