#include<iostream>
#include<vector>
#include<queue>
#include<algorithm>
using namespace std;

// 一下算法可以借助一些东西进行改进。
class Graph{
private:
    int vertex_num;   //图的顶点个数
    int edge;
    // 如果顶点的表示是离散的应该加一层映射
    vector<vector<int>> arc; //邻接矩阵
public:
    // 测试用的默认构造函数
    Graph();
    //构造函数,从命令行输入
    Graph(int vertex_num_,int edge_);
    //打印所有的边
    void print_edge();
    // 打印整个邻接矩阵
    void print_arc();
    //求最短路径
    void Dijkstra(int begin);//单源最短路
    void Floyd();//多源最短路
    void Prim(int begin);//最小生成树
    void Kruskal();//最小生成树
};

Graph::Graph(){
    this->vertex_num = 7;
    this->edge=12;
    this->arc = vector<vector<int>>(vertex_num,vector<int>(vertex_num,INT_MAX));
    // cout<<vertex_num<<endl;
    // 初始化一个邻接矩阵.dijskra算法的图。
    arc[0][1]=12;
    arc[1][0]=12;
    arc[0][6]=14;
    arc[6][0]=14;
    arc[0][5]=16;
    arc[5][0]=16;
    arc[1][2]=10;
    arc[2][1]=10;
    arc[1][5]=7;
    arc[5][1]=7;
    arc[2][3]=3;
    arc[3][2]=3;
    arc[2][4]=5;
    arc[4][2]=5;
    arc[2][5]=6;
    arc[5][2]=6;
    arc[3][4]=4;
    arc[4][3]=4;
    arc[4][5]=2;
    arc[5][4]=2;
    arc[4][6]=8;
    arc[6][4]=8;
    arc[5][6]=9;
    arc[6][5]=9;
    // 对角线自己到自己是0
    for(int i=0;i<vertex_num;i++){
        arc[i][i]=0;
    }
}

// 从命令行输入一个邻接矩阵
Graph::Graph(int vertex_num_,int edge_){
    this->vertex_num=vertex_num_;
    this->edge=edge_;
    this->arc=vector<vector<int>>(vertex_num,vector<int>(vertex_num,INT_MAX));
    int beg=0,end=0,weight=0;
    for(int i=0;i<edge_;i++){
        cin>>beg>>end>>weight;
        arc[beg][end]=weight;
        // 如果是无向图则需要添加反向的路径
        arc[end][beg]=weight;
    }
}

void Graph::print_edge(){
    for(int i=0;i<vertex_num;i++){
        for(int j=0;j<vertex_num;j++){
            if(arc[i][j]<INT_MAX)
            cout<<"begin:"<<i<<"\tend:"<<j<<"\tweight:"<<arc[i][j]<<endl;
        }
    }
}


void Graph::print_arc(){
    for(int i=0;i<vertex_num;i++){
        for(int j=0;j<vertex_num;j++){
            cout<<arc[i][j]<<"\t";
        }
        cout<<endl;
    }
}
void Graph::Dijkstra(int begin){
    // 初始化结果集,到自己是0。
    vector<int> result(vertex_num,INT_MAX);
    result[begin]=0;
    // 初始化距离集合，每次从中挑选
    vector<int> distance(vertex_num,INT_MAX);
    for(int i=0;i<vertex_num;i++){
        distance[i]=arc[begin][i];
    }

    for(int k=0;k<vertex_num-1;k++){
        // 从中挑选非零的最小值，使用0表示已经挑选到结果集合中。
        int min_distance=INT_MAX;
        int min_index=0;
        for(int i=0;i<vertex_num;i++){
            if(distance[i]!=0 && distance[i]<min_distance){
                min_distance=distance[i];
                min_index=i;
            }
        }
        // 添加到结果集合中，并更新删除distance集合。
        cout<<min_index<<endl;
        result[min_index]=min_distance;
        distance[min_index]=0;

        // 使用min_index更新距离集合
        for(int i=0;i<vertex_num;i++){
            if(distance[i]!=0 && arc[min_index][i]<INT_MAX){
                distance[i]=min(distance[i],min_distance+arc[min_index][i]);
            }
        }
    }

    for(int i=0;i<vertex_num;i++){
        cout<<"end:"<<i<<"\tweight:"<<result[i]<<endl;
    }

}
// 三层for循环。中间节点、起始点、终止点。不断更新表格。
void Graph::Floyd(){
    // 初始化结果集合，一个用来记录最短距离，一个用来记录最短路径。
    vector<vector<int>> distance(arc);
    vector<vector<int>> path(vertex_num,vector<int>(vertex_num,0));
    int i,j,k;
    int temp;

    // 三层for循环。k表示中间点。i表示起点，j表示中点。如果经过起始点小于直接点，则更新。
    // 可以进行优化，例如i||j==k的时候，可以不用运算，直接continue。
    for(k=0;k<vertex_num;k++){
        for(i=0;i<vertex_num;i++){
            for(j=0;j<vertex_num;j++){
                temp=INT_MAX;
                if(distance[i][k]<INT_MAX && distance[k][j]<INT_MAX){
                    temp=distance[i][k]+distance[k][j];
                }
                if(temp<distance[i][j]){
                    distance[i][j]=temp;
                    path[i][j]=k;
                }
            }
        }

    }
    for(i=0;i<vertex_num;i++){
        for(j=0;j<vertex_num;j++){
            cout<<distance[i][j]<<"\t";
        }
        cout<<endl;
    }
}
// 经过分析不需要使用优先队列。与dijkstra算法一样。可以使用向量来表示是否选中。
// 与dijkstra算法十分相似。唯一的区别是距离更新的方式不同。dijkstra更新使用新的点做为中间节点，计算起始点到该节点的距离，更新最小距离。结果集中保存的是到某个点的最小距离。
// 而Prim算法是直接使用新的点和新添加到集合中的点进行更新。如果新添加到结果集合中的点周围有更短的距离，则进行更新。而不是作为转接点。结果集中保存的是某个节点的前一个节点。构成一条边。
// 为了跟Dijkstra统一，这里改成相同的添加方式。
void Graph::Prim(int begin){
    // 最小生成树开始的顶点。表示顶点是否被选中过.-1表示没有被选中。其他值表示它的上一个节点。
    vector<int> result(vertex_num,-1);
    result[begin]=begin;//表示从当前节点开始.前一个节点时自己。

    // 用来记录到某个节点的距离的向量。使用0表示节点已经计算过，添加到结果当中了。
    vector<int> distance(vertex_num,INT_MAX);
    // 用来记录到某个节点的前一个节点向量。dijsktra也可以添加一个前置节点向量，用来保存路径。
    vector<int> pre_point(vertex_num,-1);

    // 初始化刚开始的边集合。从当前点出发的边集合
    for(int i=0;i<vertex_num;i++){
        distance[i]=arc[begin][i];
        pre_point[i]=begin;
    }

    for(int k=0;k<vertex_num-1;k++){
        int min_index =0;
        int min_distance=INT_MAX;
        // 挑选距离最小的节点
        for(int i=0;i<vertex_num;i++){
            if(distance[i]!=0 && distance[i]<min_distance){
                min_distance=distance[i];
                min_index=i;
            }
        }
        // cout<<min_index<<"\t"<<pre_point[min_index]<<endl;
        // 更新结果集合
        result[min_index]=pre_point[min_index];
        distance[min_index]=0;

        // 以当前节点更新距离结合
        for(int i=0;i<vertex_num;i++){
            if(distance[i]!=0 && arc[min_index][i]<distance[i]){
                distance[i]=arc[min_index][i];
                pre_point[i]=min_index;
            }
        }

    }

    // 输出结果集合
    for(int i=0;i<vertex_num;i++){
        cout<<i<<"\t"<<result[i]<<"\t"<<arc[result[i]][i]<<endl;
    }

}

// 并查集的设计实现，用来检验是否连通
class SetUnion{
public:
    vector<int> vec;
    // 初始化并查集
    SetUnion(int n){
        vec=vector<int>(n);
        for(int i=0;i<n;i++){
            vec[i]=i;
        }
    }
    // 没有路径压缩的递归查找
    int find_r(int x){
        if(x==vec[x])return x;
        else{
            return find_r(vec[x]);
        }
    }
    // 合并两个非连通图。
    void merge(int i,int j){
        vec[find(i)]=find(j);
    }
    // 有路径压缩的递归查找
    int find(int x){
        if(x==vec[x]){
            return x;
        }
        else{
            vec[x]=find(vec[x]);
            return vec[x];
        }
    }

};
// 构造边的对象
struct Edge
{
    int start;
    int end;
    int weight;
    Edge(int s,int e,int w){
        start=s;
        end=e;
        weight=w;
    }
    // 重写<运算符
    bool operator<(const Edge& a)const{
        return a.weight > weight;
    }
};
// 贪心选择最小的边。且使他们不连通。
void Graph::Kruskal(){
    // 构建结果集合
    vector<Edge> result;
    // 对边初始化并进行排序
    vector<Edge> vec;
    for(int i=0;i<vertex_num;i++){
        for(int j=i+1;j<vertex_num;j++){
            if(arc[i][j]<INT_MAX){
                vec.push_back(Edge(i,j,arc[i][j]));
            }
            
        }
    }
    sort(vec.begin(),vec.end());

    // 创建点的并查集
    SetUnion su(vertex_num);
    int k=0;
    for(int i=0;i<vec.size();i++){
        Edge e = vec[i];
        if(su.find(e.start)!=su.find(e.end)){
            result.push_back(e);
            su.merge(e.start,e.end);
        }
    }

    // 显示结果
    for(int i=0;i<result.size();i++){
        cout<<result[i].start<<"\t"<<result[i].end<<"\t"<<result[i].weight<<endl;
    }
}
int main(){
    Graph g;
    // g.print();
    // g.Dijkstra(3);
    // g.Floyd();
    // g.Prim(2);
    // g.Kruskal();
    return 0;
}