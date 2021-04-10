#include <iostream>
using namespace std;

class Target {
public:
    virtual void Request() {
        cout << "Target::Request..." << endl;
    }
    virtual ~Target() { }
};

class Adaptee {
public:
    void SpecificRequest() {
        cout << "Adaptee::SpecificRequest..." << endl;
    }
};

class Adapter :public Target, private Adaptee {
public:
    Adapter(Adaptee* ade) {
        _ade = ade;
    }
    void Request() {
        _ade->SpecificRequest();
    }
private:
    Adaptee *_ade;
};

int main() {
    Adaptee *adaptee = new Adaptee();
    Target *adapter = new Adapter(adaptee);

    adapter->Request();

    delete adapter;
    delete adaptee;

    return 0;
}
