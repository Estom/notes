#include <iostream>
using namespace std;

// Prototype

class Prototype {
public:
    virtual Prototype* Clone() = 0;
    virtual ~Prototype() { }
};

class ConcretePrototype :public Prototype {
public:
    ConcretePrototype() { }

    ConcretePrototype(const ConcretePrototype&cp) {
        cout << "ConcretePrototype copy..." << endl;
    }

    Prototype* Clone() {
        return new ConcretePrototype(*this);
    }
};

int main() {
    Prototype *prototype = new ConcretePrototype();
    cout << prototype << endl;
    Prototype* prototype1 = prototype->Clone();
    cout << prototype1 << endl;
    Prototype* prototype2 = prototype->Clone();
    cout << prototype2 << endl;

    delete prototype;
    delete prototype1;
    delete prototype2;

    return 0;
}
