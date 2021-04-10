#include <iostream>
using namespace std;

class State;
class ConcreteStateB;
class ConcreteStateA;

class State {
public:
    virtual void OperationChangeState(Context*) = 0;
    virtual void OperationInterface(Context*) = 0;
    virtual ~State() { }
protected:
    bool ChangeState(Context* con, State *st) {
        con->ChangeState(st);
    }
};

class ConcreteStateA :public State {
public:
    void OperationChangeState(Context* con) {
        OperationInterface(con);
        this->ChangeState(con, new ConcreteStateB());
    }

    void OperationInterface(Context* con) {
        cout << "ConcreteStateA::OperationInterface..." << endl;
    }
};

class ConcreteStateB :public State {
public:
    void OperationChangeState(Context* con) {
        OperationInterface(con);
        this->ChangeState(con, new ConcreteStateA());
    }

    void OperationInterface(Context* con) {
        cout << "ConcreteStateB::OperationInterface..." << endl;
    }
};

class Context {
public:
    Context(State* st) {
        _st = st;
    }

    void OperationInterface() {
        _st->OperationInterface(this);
    }

    void OperationChangeState() {
        _st->OperationInterface(this);
    }
private:
    friend class State;
    bool ChangeState(State* st) {
        _st = st;
        return true;
    }

    State *_st;
};

int main() {
    State *st = new ConcreteStateA();
    Context *con = new Context(st);
    con->OperationInterface();
    con->OperationInterface();
    con->OperationInterface();

    delete con;
    delete st;

    return 0;
}
