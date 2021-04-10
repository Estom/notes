#pragma once
#include "Aggregate.h"

class Iterator {
public:
    Iterator();
    virtual ~Iterator();
    virtual void First() = 0;
    virtual void Next() = 0;
    virtual bool IsDone() = 0;
    virtual Object CurrentItem() = 0;
};

class ConcreteIterator :public Iterator {
public:
    ConcreteIterator(Aggregate *ag, int idx /* = 0 */);

    void First();
    void Next();
    bool IsDone();
    Object CurrentItem();
private:
    Aggregate* _ag;
    int _idx;
};
