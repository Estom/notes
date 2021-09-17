// 二叉搜索树的创建和查找
/*
* 二叉搜索树的插入、删除、查找
*/
#include<iostream>
#include<vector>
#include<queue>
#include<algorithm>
#include<stack>
using namespace std;

struct TreeNode{
    int val;
    TreeNode* left;//左子树
    TreeNode* right;//右子树
    TreeNode* parent;//可以不用
    TreeNode(int v){
        val=v;
        left = nullptr;
        right = nullptr;
    }
};

class BinarySearchTree{
public:

    TreeNode* build(vector<int> &vec){
        TreeNode* head = new TreeNode(vec[0]);
        for(int i=1;i<vec.size();i++){
            insert(head,vec[i]);
        }
        return head;
    }
    // 循环插入叶子及诶点
    void insert(TreeNode* root,int val){
        TreeNode* temp = root;
        while(true){
            // cout<<temp->val<<endl;
            if(val>temp->val){
                if(temp->right!=nullptr){
                    temp = temp->right;
                }
                else{
                    temp->right = new TreeNode(val);
                    break;
                }
            }
            else if(val<temp->val){
                if(temp->left!=nullptr){
                    temp = temp->left;
                }
                else{
                    temp->left = new TreeNode(val);
                    break;
                }
            }
        }
    }
    // 递归插入叶子节点
    TreeNode* insert2(TreeNode* root,int val){
        if(root==nullptr){
            return new TreeNode(val);
        }
        if(val<root->val){
            root->left = insert2(root->left,val);
        }
        else{
            root->right = insert2(root->right,val);
        }
        return root;
    }
    void insert(TreeNode* root,TreeNode* node){
        TreeNode* temp = root;
        while(true){
            // cout<<temp->val<<endl;
            if(node->val>temp->val){
                if(temp->right!=nullptr){
                    temp = temp->right;
                }
                else{
                    temp->right = node;
                    break;
                }
            }
            else if(node->val<temp->val){
                if(temp->left!=nullptr){
                    temp = temp->left;
                }
                else{
                    temp->left = node;
                    break;
                }
            }
        }
        return ;
    }
    void mid_order(TreeNode* root){
        if(root == nullptr){
            return ;
        }
        mid_order(root->left);
        process(root);
        mid_order(root->right);
        return;
    }


    bool find(TreeNode* root,int val){
        TreeNode* temp = root;
        while(temp){
            if(temp->val==val){
                return true;
            }
            if(val > temp->val){
                temp = temp->right;
            }
            else{
                temp = temp->left;
            }
        }
        return false;
    }
    // 将左树上升。
    void delete_node(TreeNode* root,int val){
        TreeNode* new_root = new TreeNode(-1);
        new_root->right = root;
        TreeNode* temp = new_root;
        TreeNode* parent=new_root;

        // 查找节点，如果存在则删除，不存在直接退出。
        bool left_or_right=false;
        while(temp){
            if(temp->val==val){
                break;
            }
            if(val > temp->val){
                parent = temp;
                left_or_right=true;
                temp = temp->right;
            }
            else{
                parent = temp;
                left_or_right=false;

                temp = temp->left;
            }
        }
        if(temp==nullptr)return;
        cout<<"left_or_right:"<<left_or_right<<endl;
        // 删除parent的左或者右节点
        if(left_or_right==false){
            if(temp->left!=nullptr && temp->right!=nullptr){
                parent->left = temp->left;
                TreeNode* t=temp->right;
                while(t->left){
                    t=t->left;
                }
                t->left = parent->left->right;
                parent->left->right = temp->right;
            }
            else if(temp->left==nullptr){
                parent->left=temp->right;
            }
            else if(temp->right==nullptr){
                parent->left = temp->left;
            }
        }
        else{
            if(temp->left!=nullptr && temp->right!=nullptr){
                parent->right = temp->left;
                TreeNode* t=temp->right;
                while(t->left){
                    t=t->left;
                }
                t->left = parent->right->right;
                parent->right->right = temp->right;
            }
            else if(temp->left==nullptr){
                parent->right=temp->right;
            }
            else if(temp->right==nullptr){
                parent->right = temp->left;
            }
        }
        delete temp;
        return;

    }
    // 正常删除，找到右子树的最小节点，作为根节点。删除最小节点。
    // 非递归的方法实现，通过循环查找，循环删除
    void delete_node2(TreeNode* root,int val){
        TreeNode* new_root = new TreeNode(-1);
        new_root->right = root;
        TreeNode* temp = new_root;
        TreeNode* parent=new_root;
        while(temp){
            if(temp->val==val){
                break;
            }
            if(val > temp->val){
                parent = temp;
                temp = temp->right;
            }
            else{
                parent = temp;
                temp = temp->left;
            }
        }

        if(temp->left!=nullptr && temp->right!=nullptr){
            // 找到右子树的最小值。日后再来实现吧
            TreeNode* min_node=temp->right;
            TreeNode* min_node_parent = temp;
            while(temp->left!=nullptr){
                temp=temp->left;
            }
        }
    }
    void process(TreeNode* root){
        cout<<root->val<<" ";
    }
};
int main(){
    vector<int> vec{43, 10, 79, 90, 12, 54, 11, 9, 50};
    BinarySearchTree bt = BinarySearchTree();
    TreeNode* head = bt.build(vec);
    cout<<"build&mid_order"<<endl;
    bt.mid_order(head);
    cout<<endl;

    cout<<"insert"<<endl;
    bt.insert(head,78);
    bt.mid_order(head);
    cout<<endl;

    cout<<"find"<<endl;
    bool b =bt.find(head,78);
    cout<< b<<endl;

    cout<<"delete:"<<endl;
    bt.delete_node(head,10);
    bt.mid_order(head);
    cout<<endl;
}