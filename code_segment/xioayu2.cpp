#include <vector>
#include <string>
#include <iostream>
#include <sstream>
#include <map>
using namespace std;

class Solution{

    public:
    std::vector<std::string> scoresort(std::vector<std::string> names,std::vector<std::string> scores){
        map<int,int> m;
        for(int i=0;i<scores.size();i++){
            istringstream ss(scores[i]);
            string temp;
            int sum=0;
            while(getline(ss,temp,',')){
                sum+=atoi(temp.c_str());
            }
            m[sum]=i;
        }
        vector<string> res;
        for(auto beg=m.rbegin();beg!=m.rend();beg++){
            res.push_back(names[beg->second]);
        }
        return res;
    }
};

int main(){

    Solution s;
    using namespace std;
    vector<string> names{"1","2","3"};
    vector<string> scores{"1,2,3","3,4,5","6,7,8"};

    vector<string> res = s.scoresort(names,scores);
    for(auto a:res){
        cout<<a<<" ";
    }
    cout<<endl;

}