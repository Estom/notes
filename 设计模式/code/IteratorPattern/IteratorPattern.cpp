#include <iostream>
#include "Aggregate.h"
#include "Iterator.h"
using namespace std;

int main() {
    Aggregate* ag = new ConcreteAggreaget();
    Iterator *it = new ConcreteIterator(ag, 0);
    for (; !(it->IsDone()); it->Next()) {
        cout << it->CurrentItem() << endl;
    }
    delete it;
    delete ag;

    return 0;
}
