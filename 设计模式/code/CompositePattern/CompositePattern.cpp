#include <iostream>
#include <vector>
using namespace std;

class Component {
public:
    virtual void Operation() { }

    virtual void Add(const Component& com) { }

    virtual void Remove(const Component& com) { }

    virtual Component* GetChild(int index) {
        return 0;
    }

    virtual ~Component() { }
};

class Composite :public Component {
public:
    void Add(Component* com) {
        _coms.push_back(com);
    }

    void Operation() {
        for (auto com : _coms)
            com->Operation();
    }

    void Remove(Component* com) {
        //_coms.erase(&com);
    }

    Component* GetChild(int index) {
        return _coms[index];
    }

private:
    std::vector<Component*> _coms;
};

class Leaf :public Component {
public:
    void Operation() {
        cout << "Leaf::Operation..." << endl;
    }
};


int main() {
    Leaf *leaf = new Leaf();
    leaf->Operation();
    Composite *com = new Composite();
    com->Add(leaf);
    com->Operation();
    Component *leaf_ = com->GetChild(0);
    leaf_->Operation();

    delete leaf;
    delete com;

    return 0;
}
