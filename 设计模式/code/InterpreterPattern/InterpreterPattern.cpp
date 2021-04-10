#include <iostream>
#include <string>
using namespace std;

class Context { };

class Expression {
public:
    virtual ~Expression() { }
    virtual void Interpret(const Context& c) = 0;
};

class TerminalExpression :public Expression {
public:
    TerminalExpression(const string& statement) {
        _statement = statement;
    }

    void Interpret(const Context& c) {
        cout << this->_statement << " -- TerminalExpression" << endl;
    }

private:
    string _statement;
};

class NonterminalExpression :public Expression {
public:
    NonterminalExpression(Expression* expression, int times) {
        _expression = expression;
        _times = times;
    }

    void Interpret(const Context& c) {
        for (int i = 0; i < _times; i++) {
            _expression->Interpret(c);
        }
    }

private:
    Expression *_expression;
    int _times;
};

int main() {
    Context *c = new Context();
    Expression *tp = new TerminalExpression("echo");
    Expression *ntp = new NonterminalExpression(tp, 4);
    ntp->Interpret(*c);

    delete ntp;
    delete tp;
    delete c;

    return 0;
}
