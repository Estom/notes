#pragma once

#include "Element.h"
class Element;

class Visitor {
public:
    virtual ~Visitor();

    virtual void VisitConcreteElementA(Element* elm) = 0;
    virtual void VisitConcreteElementB(Element* elm) = 0;
protected:
    Visitor();
};

class ConcreteVisitorA :public Visitor {
public:
    void VisitConcreteElementA(Element* elm);
    void VisitConcreteElementB(Element* elm);
};

class ConcreteVisitorB :public Visitor {
public:
    void VisitConcreteElementA(Element* elm);
    void VisitConcreteElementB(Element* elm);
};
