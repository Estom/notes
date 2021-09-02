class Solution:
    def revmoveDuplicateChars(self,s:list)->None:
        m = list([0 for i in range(255)])
        i=0
        while i<len(s):
            if m[ord(s[i])]==1:
                del s[i]
                #s.pop(i)
            else:
                m[ord(s[i])]=1
                i=i+1
    def isOrderedWithOneMove(self,array:list):
        # 找到左右边界
        i=1
        left=0;
        right=-1;
        while i<len(array):
            if array[i]<array[i-1]:
                if left!=0:
                    return False
                left = i
            if left!=0 and array[i]>array[left-1]:
                right = i-1
            
            i =i+1
        if left==0:
            return True
        if right == -1:
            right = len(array)-1

        i=0
        insert_pos=0
        while i< left:
            if array[i]>array[right]:
                insert_pos=i
                break
            i=i+1
        if i==0 and insert_pos==0:
            return True
        
        if i!=0 and insert_pos==0:
            return False
        
        if insert_pos!=0 and array[insert_pos-1]<array[left]:
            return True
        else:
            return False

def main():
    # list_line = ['h','e','l','l','l','b','b','o','o','o']
    # Solution().revmoveDuplicateChars(list_line)
    # print(123)
    # print(list_line)
    array = [3,4,4,5,-2,-1]
    res = Solution().isOrderedWithOneMove(array)
    print(res)

main()