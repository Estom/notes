#include "Observer.h"
#include "Subject.h"

void Subject::Attach(Observer* obv) {
    _obvs.push_front(obv);
}

void Subject::Detach(Observer* obv) {
    if (obv != nullptr) {
        _obvs.remove(obv);
    }
}

void Subject::Notify() {
    for (auto obv : _obvs) {
        obv->Update(this);
    }
}

Subject::~Subject() { }

Subject::Subject() { 
    //_obvs.clear();
}

string ConcreteSubject::GetState() {
    return _st;
}

void ConcreteSubject::SetState(const string& st) {
    _st = st;
}
