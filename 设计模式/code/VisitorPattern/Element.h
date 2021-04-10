#pragma once
#include "Visitor.h"
class Visitor;

class Element {
public:
    Element();
    virtual ~Element();
    virtual void Accept(Visitor* vis) = 0;
};

class ConcreteElementA :public Element {
public:
    void Accept(Visitor* vis);
};

class ConcreteElementB :public Element {
public:
    void Accept(Visitor* vis);
};