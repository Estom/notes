#ifndef A
#define A

extern int a;//仅进行声明
// int a=11;
const int aaa=10;//定义常量，在文件内部有效。
// class M;//仅进行声明
class N//对类类型进行了定义（当包含定义的时候，就应该尽量避免多次定义，使用条件编译进行控制）。类型定义并没有生成变量。
{
public:
    int m=0;//仅进行声明
    int world();//仅进行声明
};
// extern N k;//仅声明了了一个变量
int hello();//仅仅进行声明，extern可有可无，省略了extern
// int hhh(){return 0;};//声明并定义了方法，会报错。
#endif

//使用条件编译，b.cpp<-b.h<-a.h。b.cpp<-a.h。两次引入了同一段代码片段。防止出错。
//使用extern，多个包含a的文件，使用了同一个a的声明。
//.h文件中不应该包含变量的定义、方法的定义，可以包含变量的声明、方法的声明、类的声明、类的定义。