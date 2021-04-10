#include "Visitor.h"
#include <iostream>
using namespace std;

Visitor::Visitor() {
}

Visitor::~Visitor() {
}

void ConcreteVisitorA::VisitConcreteElementA(Element* elm) {
    cout << "i will visit ConcreteElementA..." << endl;
}

void ConcreteVisitorA::VisitConcreteElementB(Element* elm) {
    cout << "i will visit ConcreteElementB..." << endl;
}

void ConcreteVisitorB::VisitConcreteElementA(Element* elm) {
    cout << "i will visit ConcreteElementA..." << endl;
}

void ConcreteVisitorB::VisitConcreteElementB(Element* elm) {
    cout << "i will visit ConcreteElementB..." << endl;

}