#include<map>
#include<string>
#include<iostream>
using namespace std;
struct Node{
  string name;
  Node* next;
  
  Node(string _name){
  	name = _name;
    next=nullptr;
  }
};
class MyMap{
public:
  map<string,Node*> m;
  
  void insert(string s,Node* node){
    if(m.count(s)>0){
      Node* temp= m[s];
      while(temp->next!=nullptr)temp=temp->next;
      
      temp->next = node;
    }
    else{
      m[s] = node;
    }
  }
  
  Node* find(string s){
    if(m.count(s)>0){
      return m[s];
    }
    else{
      return nullptr;
    }
  }

};
int main(){
  MyMap mm;
  string zhangsan("yanfabu");
  Node* nzhangsan=new Node("zhangsan");
  string wangyi("yanfabu");
  Node* nwangyi = new Node("wangyi");
  string lisi("shichangbu");
  Node* nlisi =new Node("lisi");
  mm.insert(zhangsan,nzhangsan);
  mm.insert(wangyi,nwangyi);
  mm.insert(lisi,nlisi);
  
  Node* node1 = mm.find("yanfabu");
  while(node1!=nullptr){
      cout<<node1->name;
      node1=node1->next;
  }
  Node* node2 = mm.find("shichangbu");
  while(node2!=nullptr){
      cout<<node2->name;
      node2=node2->next;

  }
    return 0;
}