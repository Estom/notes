#include <iostream>
using namespace std;

class Reciever {
public:
    void Action() {
        cout << "Reciever::Action..." << endl;
    }
};

class Command {
public:
    virtual ~Command() { }
    virtual void Excute() = 0;
};

class ConcreteCommand :public Command {
public:
    ConcreteCommand(Reciever *rev) {
        _rev = rev;
    }

    void Excute() {
        _rev->Action();
    }
private:
    Reciever *_rev;
};

class Invoker {
public:
    Invoker(Command* cmd) {
        _cmd = cmd;
    }
    void Invoke() {
        _cmd->Excute();
    }

private:
    Command *_cmd;
};

int main() {
    Reciever *rev = new Reciever();
    Command* cmd = new ConcreteCommand(rev);
    Invoker *inv = new Invoker(cmd);
    inv->Invoke();

    delete rev;
    delete cmd;
    delete inv;

    return 0;
}
