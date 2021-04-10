#include "Iterator.h"


Iterator::Iterator() {
}


Iterator::~Iterator() {
}

ConcreteIterator::ConcreteIterator(Aggregate *ag, int idx = 0) {
    _ag = ag;
    _idx = idx;
}

Object ConcreteIterator::CurrentItem() {
    return _ag->GetItem(_idx);
}

void ConcreteIterator::First() {
    _idx = 0;
}

void ConcreteIterator::Next() {
    if (_idx < _ag->GetSize()) {
        _idx++;
    }
}

bool ConcreteIterator::IsDone() {
    return (_idx == _ag->GetSize());
}