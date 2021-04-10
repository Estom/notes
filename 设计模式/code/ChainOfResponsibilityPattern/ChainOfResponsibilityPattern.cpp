#include <iostream>
using namespace std;

class Handle {
public:
    virtual ~Handle() { }

    virtual void HandleRequest() = 0;

    void SetSuccessor(Handle *succ) {
        _succ = succ;
    }

    Handle* GetSuccessor()const {
        return _succ;
    }

protected:
    Handle() { _succ = nullptr; }

    Handle(Handle* succ) {
        _succ = succ;
    }
private:
    Handle* _succ;
};

class ConcreteHandleA :public Handle {
public:
    ConcreteHandleA() { }

    ConcreteHandleA(Handle* succ)
        :Handle(succ) {
    }

    void HandleRequest() {
        if (this->GetSuccessor() != 0) {
            cout << "ConcreteHandleA--Successor" << endl;
            GetSuccessor()->HandleRequest();
        }
        else {
            cout << "ConcreteHandleA::HandleRequest" << endl;
        }
    }
};

class ConcreteHandleB :public Handle {
public:
    ConcreteHandleB() { }

    ConcreteHandleB(Handle* succ)
        :Handle(succ) {
    }

    void HandleRequest() {
        if (this->GetSuccessor() != 0) {
            cout << "ConcreteHandleB--Successor" << endl;
            GetSuccessor()->HandleRequest();
        }
        else {
            cout << "ConcreteHandleB::HandleRequest" << endl;
        }
    }
};

int main() {
    Handle *h1 = new ConcreteHandleA();
    Handle *h2 = new ConcreteHandleB(h1);// or h1->SetSuccessor(h2);
    h2->HandleRequest();

    delete h1;
    delete h2;

    return 0;
}
