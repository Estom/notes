#include<iostream>
#include<sstream>
#include<vector>
#include<algorithm>
using namespace std;

/*
输入例子1:
a,c,bb
f,dddd
nowcoder
*/
int main(){
    string m = "a,c,bb\nf,dddd\nnowcoder";
    auto cin=stringstream(m);
    string s,t;
    while(getline(cin,s)){
        vector<string> vec;
        auto ss = stringstream(s);
        while(getline(ss,t,',')){
            vec.push_back(t);
        }
        sort(vec.begin(),vec.end());
        for(int i=0;i<vec.size();i++){
            cout<<vec[i];
            if(i!=vec.size()-1)cout<<",";
        }
        cout<<endl;
    }
    return 0;
}