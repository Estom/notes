#include <iostream>
using namespace std;

class Component {
public:
    virtual void Operation() = 0;
    virtual ~Component() { }
};

class ConcreteComponent :public Component {
public:
    void Operation() {
        cout << "ConcreteComponent::Operation..." << endl;
    }
};

class Decorator {
public:
    virtual void Operation() = 0;
    virtual void AddBehavior() = 0;
    virtual ~Decorator() { }
};

class ConcreteDecorator :public Decorator {
public:
    ConcreteDecorator(Component *com) {
        _com = com;
    }

    void AddBehavior() {
        cout << "ConcreteDecorator::AddBehavior..." << endl;
    }

    void Operation() {
        cout << "ConcreteDecorator::Operation..." << endl;
        AddBehavior();
        _com->Operation();
    }
private:
    Component *_com;
};

int main() {
    Component *con = new ConcreteComponent();
    Decorator *dec = new ConcreteDecorator(con);
    dec->Operation();

    delete con;
    delete dec;

    return 0;
}
