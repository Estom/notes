#pragma once

class Iterator;
typedef int Object;

class Aggregate {
public:
    Aggregate();
    virtual ~Aggregate();
    //virtual Iterator* CreateIterator() = 0;
    virtual Object GetItem(int idx) = 0;
    virtual int GetSize() = 0;
};

class ConcreteAggreaget :public Aggregate {
public:
    enum { SIZE = 3 };
    ConcreteAggreaget();
    //Iterator* CreateIterator();
    Object GetItem(int idx);
    int GetSize();
private:
    Object _objs[SIZE];
};

