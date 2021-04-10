#include <iostream>
using namespace std;

#include "Aggregate.h"
#include "Iterator.h"

Aggregate::Aggregate() {
}

Aggregate::~Aggregate() {
}

ConcreteAggreaget::ConcreteAggreaget() {
    for (int i = 0; i < SIZE; i++) {
        _objs[i] = i;
    }
}

//Iterator* ConcreteAggreaget::CreateIterator() {
//    return new ConcreteIterator(this);
//}

Object ConcreteAggreaget::GetItem(int idx) {
    if (idx < this->GetSize()) {
        return _objs[idx];
    }
    else {
        return -1;
    }
}

int ConcreteAggreaget::GetSize() {
    return SIZE;
}


