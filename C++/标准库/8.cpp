#include <iostream>
#include <random>

#include<ctime>
using namespace std;
 
int main( ){
    default_random_engine e;
    cout<<time(nullptr)<<endl;
    e.seed(time(nullptr));
    uniform_int_distribution<unsigned> u(0, 9);
    for(int i=0; i<10; ++i)
        cout<<u(e)<<endl;
    return 0;
}