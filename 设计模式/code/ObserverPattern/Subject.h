#ifndef SUBJECT_H
#define SUBJECT_H

#include <iostream>
#include <list>
#include <string>

class Observer;

using namespace std;

class Subject {
public:
    virtual void SetState(const string& st) = 0;
    virtual string GetState() = 0;

    virtual void Attach(Observer* obv);

    virtual void Detach(Observer* obv);

    virtual void Notify();

    virtual ~Subject();
protected:
    Subject();
private:
    list<Observer*> _obvs;
};

class ConcreteSubject :public Subject {
public:
    string GetState();

    void SetState(const string& st);
private:
    string _st;
};

#endif// SUBJECT_H
