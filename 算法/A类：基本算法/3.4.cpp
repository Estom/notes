#include<iostream>
#include<vector>

using namespace std;

// 插入排序
void insertion_sort(vector<int> &vec);
// 冒泡排序
void bubble_sort(vector<int> &vec);
// 选择排序
void selection_sort(vector<int> &vec);
// 快速排序
void quick_sort(vector<int> &vec,int left,int right);
// 归并排序
void merge_sort(vector<int> &vec,int left,int right);
// 堆排序
void heap_sort(vector<int> &vec);
int main(){
    vector<int> vec{6,3,1,4,9,7,8,2,5,0};
    // bubble_sort(vec);
    // selection_sort(vec);
    // insertion_sort(vec);
    // quick_sort(vec,0,vec.size()-1);
    // merge_sort(vec,0,vec.size()-1);
    heap_sort(vec);
    for(int i=0;i<vec.size();i++){
        cout<<vec[i]<<endl;
    }
    return 0;
}
// 三大排序思想:插入/交换/选择


// 插入排序
void insertion_sort(vector<int> &vec){
    for(int i=1;i<vec.size();i++){
        int temp = vec[i];
        int j;
        for(j=i;j>0;j--){            
            if(vec[j-1]>temp){
                vec[j]=vec[j-1];
            }
            else{
                break;
            }
        }
        vec[j]=temp;
    }
    return ;
}
// 冒泡排序
void bubble_sort(vector<int> &vec){
    for(int i=0;i<vec.size()-1;i++){
        for(int j=0;j<vec.size()-1-i;j++){
            if(vec[j]>vec[j+1]){
                swap(vec[j],vec[j+1]);
            }
        }
    }
    return ;
}
// 选择排序
void selection_sort(vector<int> &vec){
    int min=INT_MAX,min_index=0;
    int i=0,j=0;
    for(i=0;i<vec.size()-1;i++){
        min=INT_MAX;
        for(j=i;j<vec.size();j++){
            if(vec[j]<=min){
                min = vec[j];
                min_index=j;
            }
        }
        swap(vec[i],vec[min_index]);
    }
}
// 快速排序
int partion(vector<int>&vec, int left, int right){
    int index = right;
    // 哨兵
    int sentinel = vec[index];
    // 子数组长度为 right - left + 1
    int i = left;
    // 从左到右，小的与前边交换。大的就会到右边。
    for (int j = left; j <= right - 1; j++){
        if (vec[j] <= sentinel){
            swap(vec[i],vec[j]);
            i++;
        }
    }
    swap(vec[i],vec[index]);
    return i;
}
// 尾递归。先头递归
void quick_sort(vector<int> &vec,int left,int right){
    if(left>=right)return ;
    int index = partion(vec,left,right);
    quick_sort(vec,left,index-1);
    quick_sort(vec,index+1,right);
    return ;
}
// 归并排序
void merge(vector<int> &vec,int left,int right,int mid){
    vector<int> temp(vec);
    int left_index=left;
    int right_index = mid+1;
    int i=left;
    while(left_index<=mid && right_index<=right){
        if(temp[left_index]<=temp[right_index]){
            vec[i++]=temp[left_index++];
        }
        else{
            vec[i++]=temp[right_index++];
        }
    }
    // 处理左边没有用完的数据。（右边没有用完的可以保留在原地
    while(left_index<=mid){
        vec[i++]=temp[left_index++];
    }
    return;
}
// 头递归
void merge_sort(vector<int> &vec,int left,int right){
    if(left>=right)return;
    // divide
    int mid = (left+right)/2;
    // conquer
    merge_sort(vec,left,mid);
    merge_sort(vec,mid+1,right);
    // combine
    merge(vec,left,right,mid);
    return;
}

// 堆排序
// 向下调整
void shift_down(vector<int> &vec,int pos,int end){
    // 不是最后的非叶节点，直接返回
    if(pos>(end-1)/2)return;
    int left = 2*pos+1;
    int right = 2*pos+2;
    int max;
    // 超出范围，说明是最后一个非叶节点只有一个叶节点
    // 找到两个节点中最大的那个
    if(right>end || vec[left]>vec[right]){
        max=left;
    }
    else{
        max=right;
    }
    // 进行一次下降操作
    if(vec[max]>vec[pos]){
        swap(vec[max],vec[pos]);
    }
    // 下一层的下降
    shift_down(vec,max,end);
}

void heap_sort(vector<int> &vec){
    int end = vec.size()-1;
    // 从最后一个非页节点开始向下调整。到最后一个节点
    for(int i=(end-1)/2;i>=0;i--){
        shift_down(vec,i,end);
    }
    swap(vec[0],vec[end]);
    end--;
    while(end>0){
        // 从根节点开始向下调整到最后一个叶节点。
        shift_down(vec,0,end);        
        // 交换根节点和最后一个叶子节点
        swap(vec[0],vec[end]);
        end--;
    }
    return;
}
