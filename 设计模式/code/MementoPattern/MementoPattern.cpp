#include <iostream>
#include <string>
using namespace std;

class Memento {
private:
    friend class Originator;

    Memento(const string& st) {
        _st = st;
    }

    void SetState(const string& st) {
        _st = st;
    }

    string GetState() {
        return _st;
    }

private:
    string _st;
};

class Originator {
public:
    Originator() {
        _mt = nullptr;
    }

    Originator(const string &st) {
        _st = st;
        _mt = nullptr;
    }

    Memento* CreateMemento() {
        return new Memento(_st);
    }

    void SetMemento(Memento* mt) {
        _mt = mt;
    }

    void RestoreToMemento(Memento* mt) {
        _st = mt->GetState();
    }

    string GetState() {
        return _st;
    }

    void SetState(const string& st) {
        _st = st;
    }

    void PrintState() {
        cout << _st << "..." << endl;
    }

private:
    string _st;
    Memento *_mt;
};

int main() {
    Originator *o = new Originator();
    o->SetState("old");
    o->PrintState();
    Memento *m = o->CreateMemento();
    o->SetState("new");
    o->PrintState();
    o->RestoreToMemento(m);
    o->PrintState();

    delete o;
    delete m;

    return 0;
}
