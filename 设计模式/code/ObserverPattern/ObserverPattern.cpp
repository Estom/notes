#include "Subject.h"
#include "Observer.h"

int main() {
    Subject *sub = new ConcreteSubject();
    Observer *o1 = new ConcreteObserver(sub);
    Observer *o2 = new ConcreteObserver(sub);

    sub->SetState("old");
    sub->Notify();
    sub->SetState("new");
    sub->Notify();

    delete o1;
    delete o2;
    delete sub;

    return 0;
}
