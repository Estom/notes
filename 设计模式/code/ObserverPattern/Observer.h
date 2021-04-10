#ifndef OBSERVER_H
#define OBSERVER_H

#include <iostream>
#include <string>
#include "Subject.h"
using namespace std;

class Observer {
public:
    virtual void Update(Subject* sub) = 0;
    virtual void PrintInfo() = 0;
    virtual ~Observer();
protected:
    Observer();
    string _st;
};

class ConcreteObserver :public Observer {
public:
    virtual Subject* GetSubject();

    ConcreteObserver(Subject* sub);

    ~ConcreteObserver();

    void Update(Subject* sub);

    void PrintInfo();

private:
    Subject *_sub;
};

#endif //OBSERVER_H