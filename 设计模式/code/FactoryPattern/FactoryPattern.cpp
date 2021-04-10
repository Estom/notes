#include <iostream>

// Product

class Product {
public:
    virtual ~Product() { }
    virtual void say() = 0;
};

class ConcreteProduct :public Product {
public:
    ConcreteProduct() {
        std::cout << "ConcreteProduct..." << std::endl;
    }
    void say() {
        std::cout << "ConcreteProduct Say..." << std::endl;
    }
    ~ConcreteProduct() { }
};

// Factory

class Factory {
public:
    virtual Product* CreateProduct() = 0;
    virtual ~Factory() { }
protected:
    Factory() { }
};

class ConcreteFactory :public Factory {
public:
    ConcreteFactory() {
        std::cout << "ConcreteFactory..." << std::endl;
    }

    ~ConcreteFactory() {

    }

    Product* CreateProduct() {
        return new ConcreteProduct();
    }

};

// Test

int main() {
    Factory *factory = new ConcreteFactory();
    Product *product = factory->CreateProduct();
    product->say();

    delete factory;
    delete product;

    return 0;
}
