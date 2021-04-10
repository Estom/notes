#include <iostream>
using namespace std;

class Strategy {
public:
    virtual void Interface() = 0;
    virtual ~Strategy() { }
};

class ConcreteStrategyA :public Strategy {
public:
    void Interface() {
        cout << "ConcreteStrategyA::Interface..." << endl;
    }
};

class ConcreteStrategyB :public Strategy {
public:
    void Interface() {
        cout << "ConcreteStrategyB::Interface..." << endl;
    }
};

class Context {
public:
    Context(Strategy *stg) {
        _stg = stg;
    }

    void DoAction() {
        _stg->Interface();
    }

private:
    Strategy *_stg;
};

int main() {
    Strategy *ps = new ConcreteStrategyA();
    Context *pc = new Context(ps);
    pc->DoAction();

    delete pc;
    delete ps;

    return 0;
}
