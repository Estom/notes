#include<iostream>
#include<map>
#include<set>
#include<unordered_map>
#include<unordered_set>
#include<vector>
#include<queue>
using namespace std;

int main(){
    return 0;
    
}

void test_map(){
    map<string,int> word_count;//空容器
    set<string> ex{"the","to"};//初始化set
    map<string,int> wc{
        {"jo",10},
        {"yin",13},
        {"kang",53},
        {"long",3}
    };//初始化map
    string word="hello";
    word_count[word]=10;
    word_count["world"]=35;
    //遍历map
    for(auto &w:word_count){
        cout<<"w.first"<<w.second<<endl;
    }

    //使用迭代器遍历关联容器
    auto map_it = word_count.cbegin();
    while(map_it != word_count.cend()){
        cout<<map_it->first<<map_it->second<<endl;
        map_it++;
    }

    //无序map测试

    unordered_map<string,int> people;
    people["yin"]=10;
    people["yin"]++;

    cout<<people["yin"]<<endl;

    
}

void test_set(){

    //set
    set<string> ss{"yin","kang","long","hello","world"};
    for (auto s : ss)
    {
        cout<<s<<endl;
    }
    
    //可以使用顺序容器初始化关联容器multiset初始化
    vector<int> vec{1,2,3,4,5,5,4,3,2,1};
    set<int> iset(vec.begin(),vec.end());
    multiset<int> mset(vec.begin(),vec.end());
    cout<<iset.size()<<endl;
    cout<<mset.size()<<endl;
    
}