#include <iostream>
using namespace std;

// Product

class Product {
public:
    Product() {
        cout << "Product..." << endl;
    }
};

// Builder

class Builder {
public:
    virtual void BuildPartA() = 0;
    virtual void BuildPartB() = 0;
    virtual void BuildPartC() = 0;
    virtual Product* GetProduct() = 0;
    virtual ~Builder() { }
};

class ConcreteBuilder :public Builder {
public:
    void BuildPartA() {
        cout << "BuildPartA..." << endl;
    }

    void BuildPartB() {
        cout << "BuildPartB..." << endl;
    }

    void BuildPartC() {
        cout << "BuildPartC..." << endl;
    }

    Product* GetProduct() {
        return new Product();
    }
};

// Director

class Director {
public:
    Director(Builder* pBuilder) {
        _builer = pBuilder;
    }

    void Construct() {
        _builer->BuildPartA();
        _builer->BuildPartB();
        _builer->BuildPartC();
    }

private:
    Builder *_builer;
};


int main() {
    auto builder = new ConcreteBuilder();
    auto director = new Director(builder);
    director->Construct();
    Product* product = builder->GetProduct();

    delete product;
    delete builder;
    delete director;

    return 0;
}
