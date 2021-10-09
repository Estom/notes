#include<bits/stdc++.h>
using namespace std;
int getMinSwaps(vector<int> v)
{
    vector<int> v1(v);   //将A内元素复制到B。
    sort(v1.begin(), v1.end());
    map<int,int> m;
    int len = v.size();
    for (int i = 0; i < len; i++)
    {
        m[v1[i]] = i;    //  建立每个元素与其应放位置的映射关系
    }
    int loops = 0;      //  循环节个数
    vector<bool> flag(len, false); //初始化
    //找出循环节的个数
    for (int i = 0; i < len; i++)
    {
        if (!flag[i])
        {
            int j = i;
            while (!flag[j])     //对环处理
            {
                flag[j] = true;
                j = m[v[j]];    //原序列中j位置的元素在有序序列中的位置
            }
            loops++;
        }
    }
    return len - loops;
}
vector<int> v;
int main()
{
    int n,k;
    cin>>n;
    while(n--){
        cin>>k;
        v.push_back(k);
    }
    int num = getMinSwaps(v);
    cout<<num<<endl;
    return 0;
}