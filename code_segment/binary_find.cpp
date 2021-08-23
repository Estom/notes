class Solution {
public:
    double findone(vector<int>&nums){
        int n = nums.size();
        if(n==1)return nums[0];
        if(n%2==1){
            
            return nums[(n-1)/2];
        }
        else{
            // cout<< nums[(n-1)/2]<<endl;
            return (nums[(n-1)/2]+nums[(n-1)/2+1])/2;
        }
    }
    double findMedianSortedArrays(vector<int>& nums1, vector<int>& nums2) {
        int n1 = nums1.size(),n2=nums2.size();
        int i=0,j=0,n=n1+n2;
        while(i+j<n/2){
            if(nums1[i]<nums2[j] && i<n1 || j>=n2){
                i++;
            }
            else if(j<n2){
                j++;
            }
        }

    }
    double findMedianSortedArrays2(vector<int>& nums1, vector<int>& nums2) {
        // 一种新的二分查找。每次排除掉两个数组的1/4。直接扫描两遍也行？这个数据规模，爆搜吧。
        int n1 = nums1.size(),n2=nums2.size();
        int l1=0,m1=0,r1=n1-1;
        int l2=0,m2=0,r2=n2-1;
        m1 = (l1+r1)/2;
        m2 = (l2+r2)/2;
        int n = n1+n2;
        int *m,*l,*r;
        // 特殊情况的讨论

        if(n1==0){
            return findone(nums2);
        }
        if(n2==0){
            return findone(nums1);
        }
        if(n1==1){
            nums2.push_back(nums1[0]);
            sort(nums2.begin(),nums2.end());
            return findone(nums2);
        }
        if(n2==1){
            nums1.push_back(nums2[0]);
            sort(nums1.begin(),nums1.end());
            // for(auto a : nums1){
            //     cout<<a<<" ";
            // }
            return findone(nums1);
        }
        // 保证左边的元素小于等于右
        while(true){
            // 终止搜索的条件。l1和l2不需要相邻。都完成二分搜索后，只剩下两个数。
            if(r1-l1<=1 && r2-l2<=1){
                cout<<l1<<" "<<r1<<" "<<l2<<" "<<r2<<endl;
                vector<int> temp{nums1[l1],nums1[r1],nums2[l2],nums2[r2]};
                sort(temp.begin(),temp.end());
                int left = l1+l2;
                int right = n-r1-r2-2;
                int index = ((right-left)+3)/2;

                if(n%2==1){
                    return temp[index];
                }
                else{
                    return (temp[index]+temp[index+1])/2.0;
                }
            }

            // 继续搜索，排除掉1/4的方法.暂不考虑相等
            // 选择做二分的数组
            if(nums1[m1]<nums2[m2] && m1+m2<n/2 && r1-l1>1 || nums1[m1]>nums2[m2] && m1+m2>n/2 && r1-l1>1){
                m = &m1;
                l=&l1;
                r=&r1;
            }else if(r2-l2>1){
                m = &m2;
                l = &l2;
                r = &r2;
            }
            if(m1+m2<n/2){
                *l = *m;
                *m = (*l+*r)/2;
            }
            else{
                *r = *m;
                *m = (*l+*r)/2;
            }
        }
        return 1;
    }
};