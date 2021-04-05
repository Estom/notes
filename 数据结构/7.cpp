// 图的邻接链表实现方法
#include<iostream>
#include<vector>
#include<unordered_map>
using namespace std;

const int N = 1e5+1;
struct Edge
{
    int to;
    int w;
    Edge(int t = 0, int w_ = 0) : to(t), w(w_) {}
};
 
// edge向量的数组
vector<Edge> H1[N];

// edge向量的向量（查找需要遍历某个顶点所有边的集合）
vector<vector<Edge>> H2;

// edge映射的向量（查找会更快）
vector<unordered_map<int, int>> H3;
 
int main()
{
 
    H2.resize(N + 1);
    H3.resize(N + 1);
    for (int i = 1; i <= N; ++i)
    {
        int a, b, c;
        cin >> a >> b >> c;
        H1[a].push_back(Edge(b,c));
        H2[a].push_back(Edge(b, c));
        H3[a][b] = c;
    }
 
    getchar();
    return 0;
}