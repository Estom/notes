#include<iostream>
#include<vector>

using namespace std;
class MaxQueue {
public:
// 实现最大堆吧。使用数组实现
    MaxQueue() {
        // cout<<111<<endl;
    }
    vector<int> max_queue;
    // 创建堆
    MaxQueue(vector<int> vec) {
        max_queue=vec;
        for(int i=vec.size()-1;i>=0;i--){
            shift_down((i-1)/2);
        }
    }
    // 堆顶值.即队首的元素
    int max_value() {
        if(max_queue.size()==0)return -1;
        return max_queue.front();
    }
    // 插入元素，插入最后，进行上浮操作
    void push_back(int value) {
        max_queue.push_back(value);
        // 如果大小为1，不需要上浮
        if(max_queue.size()==1)return;
        shift_up((max_queue.size()-1)/2);
    }
    // 删除元素，交换到最后删除，进行下降操作。
    int pop_front() {
        if(max_queue.size()==0)return -1;
        int temp = max_queue.front();
        swap(max_queue.front(),max_queue.back());
        max_queue.pop_back();
        // 如果大小为1或者0，不需要下沉。
        if(max_queue.size()<=1)return temp;
        shift_down(0);
        return temp;
    }
    // 向上调整
    void shift_up(int pos){
        int left = 2*pos+1;
        int right = 2*pos+2;
        // 超出范围，说明是最后一个叶节点
        int max;
        if(right>max_queue.size()-1 ){
            if(max_queue[left]>max_queue[pos])swap(max_queue[left],max_queue[pos]);
            if(pos==0)return;
            shift_up((pos-1)/2);
            return ;
        }
        if(max_queue[left]>max_queue[right]){
            max=left;
        }
        else{
            max=right;
        }
        if(max_queue[max]>max_queue[pos]){
            swap(max_queue[max],max_queue[pos]);
        }
        if(pos==0)return;
        shift_up((pos-1)/2);
        return ;
    }
    // 向下调整
    void shift_down(int pos){
        // 不是最后的飞叶节点
        if(pos>max_queue.size()/2-1)return;
        int left = 2*pos+1;
        int right = 2*pos+2;
        int max;
        // 超出范围，说明是最后一个叶节点
        if(right>max_queue.size()-1){
            if(max_queue[left]>max_queue[pos])swap(max_queue[left],max_queue[pos]);
            return;
        }
        if(max_queue[left]>max_queue[right]){
            max=left;
        }
        else{
            max=right;
        }
        if(max_queue[max]>max_queue[pos]){
            swap(max_queue[max],max_queue[pos]);
        }
        shift_down(max);
    }

    void display(){
        for(int i:max_queue){
            cout<<i<<" ";
        }
        cout<<endl;
        return;
    }
};

int main(){
    // vector<int> vec{0,1,2,3,4,5};
    // MaxQueue mq=MaxQueue(vec);
    // mq.display();
    // cout<<mq.max_value()<<endl;
    // mq.pop_front();
    // mq.display();
    // mq.push_back(6);
    // mq.display();
    MaxQueue mq2 = MaxQueue();
    mq2.push_back(1);
    mq2.push_back(2);
    mq2.max_value();
    mq2.pop_front();
    mq2.max_value();
    return 0;
}