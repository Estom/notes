#include <iostream>
using namespace std;

class SubSystem1 {
public:
    void Operation() {
        cout << "SubSystem1 operation..." << endl;
    }
};

class SubSystem2 {
public:
    void Operation() {
        cout << "SubSystem2 operation..." << endl;
    }
};

class Facade {
public:
    Facade() {
        _sub1 = new SubSystem1();
        _sub2 = new SubSystem2();
    }

    ~Facade() {
        delete _sub1;
        delete _sub2;
    }

    void OperationWrapper() {
        _sub1->Operation();
        _sub2->Operation();
    }
private:
    SubSystem1 *_sub1;
    SubSystem2 *_sub2;
};


int main() {
    Facade *facade = new Facade();
    facade->OperationWrapper();

    delete facade;
    return 0;
}
