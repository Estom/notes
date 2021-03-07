#include<iostream>
#include<regex>

using namespace std;

int main(){
    //i 必须在e之前，除非在c之后
    string pattern("[^c]ei");
    pattern ="[a-zA-Z]"+pattern+"[a-zA-Z]";
    regex r(pattern);
    smatch results;

    string test_str="receipt freind theif receive";
    if(regex_search(test_str,results,r))   
        cout<<results.str()<<endl;
    else
        cout<<results.str()<<endl;

    regex r2(pattern, regex::icase);

    sregex_iterator end_it;//string 
    sregex_iterator it(test_str.begin(),test_str.end(),r2);
    for(;it != end_it;++it){
        cout<<it->str()<<endl;
    }
    return 0;
}