#include <iostream>
#include <iomanip>
#include <vector>
#include <map>
using namespace std;
int main()
{
    vector<int> vec{1,2,3,4,5};
    auto beg = vec.begin();
    auto temp = beg+2;
    cout<<boolalpha<<(temp>beg)<<endl;
    cout<<*temp<<endl;

    map<int,int> m;
    m[1]=1;
    m[2]=2;
    m[3]=3;
    cout<<"map:"<<endl;
    for(auto beg1 = m.begin();beg1<m.end();beg1++){
        cout<<(beg1->second)<<endl;
    }

    auto iter = m.begin();
    auto temp2 = ++iter;
    // cout<<(iter
    // m.end())<<endl;
    cout<<temp2->second<<endl;
    return 0;
}