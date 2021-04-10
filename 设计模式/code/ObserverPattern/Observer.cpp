#include "Observer.h"
#include "Subject.h"

Observer::~Observer() { }

Observer::Observer() { }

Subject* ConcreteObserver::GetSubject() {
    return _sub;
}

ConcreteObserver::ConcreteObserver(Subject* sub) {
    _sub = sub;
    _sub->Attach(this);
}

ConcreteObserver::~ConcreteObserver() {
    _sub->Detach(this);
    //if (_sub != nullptr) {
    //    delete _sub;
    //}
}

void ConcreteObserver::Update(Subject* sub) {
    _st = sub->GetState();
    PrintInfo();
}

void ConcreteObserver::PrintInfo() {
    cout << "ConcreteObserver::PrintInfo\t" << _sub->GetState() << endl;
}
