//二叉树的链表实现
#include<iostream>
#include<vector>
#include<queue>
#include<algorithm>
using namespace std;

struct TreeNode{
    int val;
    TreeNode* left;//左子树
    TreeNode* right;//右子树
    TreeNode* parent;//可以不用
};
class BinaryTree{
    //TreeNode* root;//二叉树的根节点
    //vector<int> tree;//二叉树的数组表示-1表示不存在的值
public:
    // 创建二叉树
    void build(TreeNode* &node,vector<int> &vec,int i){
        if(i>vec.size() || vec[i]<0){
            return ;
        }
        node =new TreeNode();
        node->val = vec[i];
        build(node->left,vec,2*i+1);
        build(node->right,vec,2*i+2);
        return;

    }
    //可视化二叉树
    void display(TreeNode*node){
        queue<TreeNode*> que;
        que.push(node);
        int i=1;
        int j=0;
        TreeNode* temp;
        while(!que.empty()){


            if(que.front()==nullptr){
                que.pop();
                cout<<"\t";
                continue;
            }
            temp=que.front();
            que.pop();
            cout<<temp->val<<"\t";
            que.push(temp->left);
            que.push(temp->right);
            j++;
            if(j==i){
                j=0;
                i=2*i;
                cout<<endl;
            }
        }

    }
    //处理节点值
    void process(TreeNode * node){
        cout<<node->val<<" ";
    }
    


    //前序遍历
    void pre_order(TreeNode*node){
        if(node == nullptr){
            return;
        }
        process(node);
        pre_order(node->left);
        pre_order(node->right);
        return;
    }
    //中序遍历
    void mid_order(TreeNode*node){
        if(node == nullptr){
            return;
        }
        mid_order(node->left);
        process(node);
        mid_order(node->right);
        return;
    }
    //后续遍历
    void lst_order(TreeNode* node){
        if(node == nullptr){
            return;
        }
        lst_order(node->left);
        lst_order(node->right);
        process(node);
    }
    // 层序遍历
    void layer_order(TreeNode*node){
        queue<TreeNode*> que;
        que.push(node);
        while(!que.empty()){
            if(que.front()==nullptr){
                continue;
            }
            process(que.front());
            que.push(que.front()->left);
            que.push(que.front()->right);
            que.pop();
        }
    }
    // 区分层次的层序遍历
    vector<vector<int>> levelOrder(TreeNode* root) {
        vector<vector<int>> vec;
        queue<TreeNode*> que[2];
        que[0].push(root);
        int i=0;

        while(!que[i%2].empty()){
            // 每次交换队列创建一个数组
            vec.push_back(vector<int>());

            while(!que[i%2].empty()){
                if(que[i%2].front()==nullptr){
                    que[i%2].pop();
                    continue;
                }
                TreeNode*temp=que[i%2].front();
                que[i%2].pop();
                vec[i].push_back(temp->val);
                que[(i+1)%2].push(temp->left);
                que[(i+1)%2].push(temp->right);
            }
            //可以在这里针对每层进行操作。例如反转。
            i++;
        }
    
        // 最后肯定是空元素组成的队列，创建一个额外的空数组。
        vec.pop_back();
        return vec;
    }
    //重建二叉树-前中
    /* 
    * pre 前序遍历的数组
    * mid 中序遍历的数组
    * root 前序遍历中的第一个数的坐标。也就是说，该子树的根节点。
    * beg2 中序遍历的起始位置。
    * end2 中序遍历的结束位置。
    *   问题分析：二叉树遍历问题，递归与分治的思想。创建一个树，可以分解为创建左子树和右子树两个子问题。问题的规模缩小。具有最优子结构性质，每一个子问题解法一致。子问题最终可以合并为问题的解。各个子问题相互独立。
    *   选择策略：使用链表数据结构存储结果。采用递归思想递归创建。
    *   算法技术：递归技术。算法流程，设计输入参数，界定本层处理范围。设计返回值即提供给上层的值。确定递归结构，分别调用左子树和右子树。确定递归的终止条件。确定递归前和递归后需要处理的内容。
    *   正确性证明。
     */
    TreeNode* rebuild(vector<int> pre,vector<int> mid,int root,int beg2,int end2){
        if(end2<beg2){
            return nullptr;
        }
        int i=0;
        TreeNode* node= new TreeNode();
        node->val=pre[root];
        for(i=beg2;i<=end2;i++){
            if(mid[i]==pre[root]){
                break;
            }
        }
        int dis = i-beg2;//左树的长度
        node->left=rebuild(pre,mid,root+1,beg2,beg2+dis-1);
        node->right=rebuild(pre,mid,root+dis+1,beg2+dis+1,end2);
        return node;
    }
    TreeNode* rebuild2();
    
    //重建二叉树-中后
};
int main(){
    //数组表示的树
    vector<int> vec{9,8,7,6,-1,4,3};
    TreeNode n;
    TreeNode* node=&n;
    BinaryTree tree;
    // tree.build(node,vec,0);
    // tree.display(node);
    // cout<<endl;
    // tree.pre_order(node);
    // cout<<endl;
    // tree.mid_order(node);
    // cout<<endl;
    // tree.lst_order(node);
    // 数组表示的前序遍历和后续遍历
    vector<int> pre{3,9,20,15,7};
    vector<int> mid{9,3,15,20,7};
    TreeNode* node2 = tree.rebuild(pre,mid,0,0,mid.size()-1);
    tree.display(node2);
    return 0;
}