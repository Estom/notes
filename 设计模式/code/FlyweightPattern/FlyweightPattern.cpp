#include <iostream>
#include <string>
#include <vector>

using namespace std;

class Flyweight {
public:
    Flyweight(string state):_state(state) {

    }

    virtual void Operation(const string&state) { }

    string GetState()const { return _state; }

    virtual ~Flyweight() { }
private:
    string _state;
};

class ConcreteFlyweight :public Flyweight {
public:
    ConcreteFlyweight(string state)
        :Flyweight(state) {
        cout << "ConcreteFlyweight Build..." << state << endl;
    }

    void Operation(const string& state) {
        cout << "ConcreteFlyweight " << GetState() << " \\ " << state << endl;
    }
};

class FlyweightFactory {
public:
    Flyweight *GetFlyweight(std::string key) {
        for (auto fly : _flys) {
            if (fly->GetState() == key) {
                cout << "already created by users..." << endl;
                return fly;
            }
        }
        Flyweight *fn = new ConcreteFlyweight(key);
        _flys.push_back(fn);
        return fn;
    }
private:
    std::vector<Flyweight*> _flys;
};

int main() {
    FlyweightFactory *fc = new FlyweightFactory();
    Flyweight *fw1 = fc->GetFlyweight("hello");
    Flyweight *fw2 = fc->GetFlyweight("world");
    Flyweight *fw3 = fc->GetFlyweight("hello");

    delete fw1;
    delete fw2;
    //delete fw3;
    delete fc;

    return 0;
}
