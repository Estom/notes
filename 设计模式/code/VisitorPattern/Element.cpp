#include "Element.h"
#include <iostream>
using namespace std;

Element::Element() {
}

Element::~Element() {
}

void ConcreteElementA::Accept(Visitor* vis) {
    vis->VisitConcreteElementA(this);
    cout << "visiting ConcreteElementA..." << endl;
}

void ConcreteElementB::Accept(Visitor* vis) {
    vis->VisitConcreteElementB(this);
    cout << "visiting ConcreteElementA..." << endl;
}
