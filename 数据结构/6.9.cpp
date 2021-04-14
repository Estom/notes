
/**
 * Your Trie object will be instantiated and called as such:
 * Trie* obj = new Trie();
 * obj->insert(word);
 * bool param_2 = obj->search(word);
 * bool param_3 = obj->startsWith(prefix);
 */
#include<iostream>
#include<vector>
#include<map>
using namespace std;
struct Tree{
    Tree(){
        m=new map<char,Tree*>();
        is_word=false;
    }
    bool is_word=false;
    map<char,Tree*> *m;
};

class Trie2 {
public:
    /** Initialize your data structure here. */
    Tree* tree;
    Trie2() {
        tree=new Tree();
    }
    
    /** Inserts a word into the trie. */
    void insert(string word) {
        Tree* temp;
        temp=tree;
        for(auto a:word){
            if((temp->m)->count(a)==0){
                (*(temp->m))[a]=new Tree();
            }
            temp=(*(temp->m))[a];
        }
        temp->is_word=true;
    }
    
    /** Returns if the word is in the trie. */
    bool search(string word) {
        Tree* temp=tree;
        int i=0;
        for(i=0;i<word.size();i++){
            if((*(temp->m)).count(word[i])>0){
                temp=(*(temp->m))[word[i]];
            }
            else{
                break;
            }
        }
        if(i==word.size() && temp->is_word)return true;
        else return false;
    }
    
    /** Returns if there is any word in the trie that starts with the given prefix. */
    bool startsWith(string prefix) {
        Tree* temp=tree;
        int i=0;
        for(i=0;i<prefix.size();i++){
            if((*(temp->m)).count(prefix[i])>0){
                temp=(*(temp->m))[prefix[i]];
            }
            else{
                break;
            }
        }
        if(i==prefix.size())return true;
        else return false;   
    }
};
// 官方没有使用心得结构体
// 使用向量存储映射而不是map效率更高。
class Trie {
private:
    vector<Trie*> children;
    bool isEnd;

    Trie* searchPrefix(string prefix) {
        Trie* node = this;
        for (char ch : prefix) {
            ch -= 'a';
            if (node->children[ch] == nullptr) {
                return nullptr;
            }
            node = node->children[ch];
        }
        return node;
    }

public:
    Trie() : children(26), isEnd(false) {}

    void insert(string word) {
        Trie* node = this;
        for (char ch : word) {
            ch -= 'a';
            if (node->children[ch] == nullptr) {
                node->children[ch] = new Trie();
            }
            node = node->children[ch];
        }
        node->isEnd = true;
    }

    bool search(string word) {
        Trie* node = this->searchPrefix(word);
        return node != nullptr && node->isEnd;
    }

    bool startsWith(string prefix) {
        return this->searchPrefix(prefix) != nullptr;
    }
};

int main(){

    Trie t;
    string h = "hello";
    string s1 = "hel";
    string s2 = "hee";
    t.insert(h);
    cout<<t.startsWith(s1)<<endl;
    cout<<t.search(h)<<endl;
    cout<<t.search(s1)<<endl;
    
}