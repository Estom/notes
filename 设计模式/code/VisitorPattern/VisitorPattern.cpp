#include <iostream>
#include "Element.h"
#include "Visitor.h"
using namespace std;

int main() {
    Visitor *vis = new ConcreteVisitorA();
    Element *elm = new ConcreteElementA();
    elm->Accept(vis);

    delete elm;
    delete vis;

    return 0;
}
