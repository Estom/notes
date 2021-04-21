#ifndef __JJALLOC__
#define __JJALLOC__
#endif
#include<new> // for placement new
#include<iostream> //for cerr
#include<cstddef>  //for ptrdiff_t
#include<cstdlib> // for exit()
#include<climits> // for UINT_MAX
namespace my{
    // 申请内存空间。调用operator new 。
    // T*参数是为了注册模板类型T
    template<class T>
    inline T* _allocate(ptrdiff_t size, T*){
        //set_new_handler(0);
        T* tmp = (T*)(::operator new)((size_t)(size * sizeof(T)));
        if (tmp == 0){
            std::cerr << "out of memory" << std::endl;
        }
        return tmp;
    }

    // 释放内存空间。调用operator delete
    template<class T>
    inline void _deallocate(T* buffer){
        ::operator delete(buffer);
    }

    // 创建内存对象。调用placement new
    template<class T1,class T2>
    inline void _construct(T1 *p, const T2 &value){
        new (p)T1(value);
    }
    // 通过查询了解到这个操作叫做placement new，就是在指针p所指向的内存空间创建一个T1类型的对象，但是对象的内容是从T2类型的对象转换过来的（调用了T1的构造函数，T1::T1(value)）。
    // 就是在已有空间的基础上重新调整分配的空间，类似于realloc函数。这个操作就是把已有的空间当成一个缓冲区来使用，这样子就减少了分配空间所耗费的时间，因为直接用new操作符分配内存的话，在堆中查找足够大的剩余空间速度是比较慢的。

    // 释放内存对象。调用析构函数。
    template<class T>
    inline void _destroy(T* ptr){
        ptr->~T();
    }


    template <class T>
    class allocate{
    public:
        typedef T value_type;
        typedef T* pointer;
        typedef const T* const_pointer;
        typedef T& reference;
        typedef const T& const_reference;
        typedef size_t size_type;
        typedef ptrdiff_t difference_type;

        // template<class U>
        // struct rebind{
        //     typedef allocator<U> other;
        // };

        pointer alloc(size_type n, const void * hint = 0){
            return _allocate((difference_type)n, (pointer)0);
        }
        void deallocate(pointer p, size_type n){
            _deallocate(p);
        }

        void construct(pointer p, const_reference value){
            return _construct(p, value);
        }

        void destroy(pointer p){
            _destroy(p);
        }
        pointer address(reference x){
            return (pointer)&x;
        }
        pointer const_address(const_reference x){
            return (const_pointer)&x;
        }

        size_type max_size()const{
            return (size_type)(UINT_MAX / sizeof(T));
        }
    };
}
#include<iostream>
using namespace std;
int main(){
    my::allocate<int> al;
    int * ptr = al.alloc(10);
    cout<<"alloc:"<<*ptr<<"\t"<<*(ptr+1)<<endl;
    al.construct(ptr,123);
    cout<<"construct:"<<*ptr<<"\t"<<*(ptr+1)<<endl;
    al.destroy(ptr);
    cout<<"destroy:"<<*ptr<<"\t"<<*(ptr+1)<<endl;
    al.deallocate(ptr,100);
    cout<<"deallocate:"<<*ptr<<"\t"<<*(ptr+1)<<endl;
    int size = al.max_size();
    cout<<"size:"<<size<<endl;

    int* b=new int[3];
    cout<<*b<<endl;
    new (b)int(999);
    cout<<*b<<endl;
    cout<<*(b+1)<<endl;
}