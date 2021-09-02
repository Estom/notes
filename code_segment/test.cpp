#include <iostream>
#include <vector>
#include <map>
using namespace std;
struct ListNode{
    ListNode(int a){
        val = a;
    }
    ListNode* pre;
    ListNode* next;
    int val;
};

class Data{
public:
    ListNode* head;
    ListNode* end;
    map<int,ListNode*> m;
    int size;
    
    Data(){
        head = new ListNode(-1);
        end  = head;
        size=0;
    }
    void set(int a){
        ListNode* temp;
        if(size==4){
            temp = end;
            end = end->pre;
            m.erase(temp->val);
            delete temp;
            size--;
        }


        ListNode* n = new ListNode(a);
        m[a]=n;
        if(size==0){
            head->next =n;
            n->pre=head;
            end = n;
            size=1;
        }
        else{
            temp = head->next;
            head->next = n;
            n->pre = head;
            n->next = temp;
            temp->pre = n;
            size++;
        }

    }
    ListNode* get(int a){
        ListNode* temp = m[a];
        if(temp==head->next){
            return temp;
        }
        if(temp==end){
            end = end->pre;
        }
        temp->pre->next = temp->next;
        temp->next->pre = temp->pre;
        ListNode* n = head->next;
        temp->next = n;
        n->pre = temp;
        head->next = temp;
        temp->pre = head;
        
        return temp;
    }
    ListNode* get(){
        return head->next;
    }
    ~Data(){
        ListNode* temp=head;
        while(temp!=nullptr){
            ListNode* n = temp;
            delete n;
            temp=temp->next;
        }
    }
};
int main() {
    Data data;
    data.set(1);
    cout<<data.get()->val<<endl;
    data.set(2);
    data.set(3);
    
    ListNode* temp = data.get(2);
    cout<<temp->val<<endl;
    temp = data.get();
    cout<<temp->val<<endl;

    cout << "Hello World!" << endl;
}