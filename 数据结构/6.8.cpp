#include<iostream>
#include<vector>

using namespace std;
class MaxQueue {
public:
// 实现最大堆吧。使用数组实现

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
        return max_queue.front();
    }
    // 插入元素，插入最后，进行上浮操作
    void push_back(int value) {
        max_queue.push_back(value);
        shift_up(max_queue.size()-1);
    }
    // 删除元素，交换到最后删除，进行下降操作。
    int pop_front() {
        swap(max_queue.front(),max_queue.back());
        max_queue.pop_back();
        shift_down(0);
    }
    // 向上调整
    void shift_up(int pos){

    }
    // 向下调整
    void shift_down(int pos){

    }
};