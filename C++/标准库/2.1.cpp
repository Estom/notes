#include<vector>
#include<list>
#include<deque>
#include<forward_list>
#include<iostream>
#include<algorithm>
using namespace std;

int main(){

    vector<int> vec{1,2,3};
    int n=10;
    // 下表与迭代器的转换方式如下
    vector<int>::iterator it = vec.begin();
    if(*(it+n)==vec[n])cout<<boolalpha<<true<<endl;

    
    vec.insert(vec.begin()+2,{1,2,3});
    for(auto a:vec){
        cout<<a<<endl;
    }
    return 0 ;
}

int test_vector()
{
	vector <int> vec(5,8);
	//--类型是vector<int>，该容器向量中含有5个int类型的数值8，变量名为vec。
	//vector是一个类模板（class template）,所以必须要声明其类型，int，一个容器中所有的对象必须是同一种类型；
	// 定义一个容器对象；直接构造出一个数组；用法和数组一样；
	// 	
	 	for(int i=0;i<vec.size();i++)   //size()是指容器里当前有多少个使用的元素；
	 	{
	 		cout<<vec[i]<<"  ";
	 	}	
		cout<<endl<<vec.size()<<" "<<vec.capacity()<<endl;  //得到容器里用的多少个空间，和总共的大小；
	 vector<int>::iterator ite;  //定义了一个向量的迭代器；相当于定义了一个指针；
	for(ite=vec.begin();ite!=vec.end();ite++)   //得到开始、结束
	{
		cout<<*ite <<" ";  //迭代器返回的是引用：
	}
        cout<<endl;
	//在尾部插入；
	vec.push_back(9);  //VS6.0扩充的空间是两倍；在VS2005扩充的空间是1.5倍；
	for(ite=vec.begin();ite!=vec.end();ite++)   //得到开始、结束
	{
		cout<<*ite <<" ";
	}
	cout<<endl<<vec.size()<<" "<<vec.capacity()<<endl;
 
	//尾部删除;容量没变【capacitty】，但是使用空间减少一个；容量一旦增加就不会减小；
	vec.pop_back();
	for(ite=vec.begin();ite!=vec.end();ite++)   //得到开始、结束
	{
		cout<<*ite <<" ";
	}
	cout<<endl<<vec.size()<<" "<<vec.capacity()<<endl;
 
	vec.push_back(88);  
	vec.push_back(99); //容量刚好够；
 
	for(ite=vec.begin();ite!=vec.end();ite++)   //得到开始、结束
	{
		cout<<*ite <<" ";
	}
	cout<<endl<<vec.size()<<" "<<vec.capacity()<<endl;
 
	ite = find(vec.begin(),vec.end(),88);   //查找这个元素；
	vec.erase(ite);  //利用迭代器指针删除这个元素；
	for(int i=0;i<vec.size();i++)   //size()是指容器里当前有多少个使用的元素；
	{
		cout<<vec[i]<<" ";
	}
	cout<<endl<<vec.size()<<" "<<vec.capacity()<<endl;  //得到容器里用的多少个空间，和总共的大小；
 
	vec.clear(); //只是清除了数据，没有回收空间，空间的等到对象的生命周期结束时回收；
	//使用空间为0，但是容量的空间还在，只有在调用析构函数的时候空间才会回收；
 
	for(int i=0;i<vec.size();i++)   //size()是指容器里当前有多少个使用的元素；
	{
		cout<<vec[i]<<"  ";
	}
	cout<<endl<<vec.size()<<" "<<vec.capacity()<<endl;
 
	ite=find(vec.begin(),vec.end(),88);
	vec.insert(ite,2,77);  //迭代器标记的位置前，插入数据；
 
	//cout<<*ite<<endl;  //会崩溃，因为迭代器在使用后就释放了，*ite的时候就找不到它的地址了；
	//和向量的用法一样，但是链表list不同，它的迭代器在使用后还可以继续用；链表特有的；</span>
 
	for(int i=0;i<vec.size();i++)   
	{
		cout<<vec[i]<<"  ";
	}
	cout<<endl<<vec.size()<<" "<<vec.capacity()<<endl;
 
	system("pause");
	return 0;
}
int test_list()
{
	list<char> lit; 
	//用法和向量一样，
	//list是一个类模板，template，char是链表里对象的类型，lit是创建的一个对象；
	//链表可以再头尾两端插入,是双向的；
 
	lit.push_back('a');
	lit.push_back('b');
	lit.push_front('d');
	lit.push_front('e');
	lit.push_front('f');
	lit.push_front('b');
	lit.push_front('b');
 
	list<char>::iterator it;  //定义一个list的迭代器，类似一个纸箱链表的指针，但是比一般的指针好用，里面用到了好多重载操作；
	list<char>::iterator it1;  
	list<char>::iterator it2;  
	for(it=lit.begin();it!=lit.end();it++)
	{
		cout<<*it<<"  ";
	}
	cout<<endl;
	//-----------链表可以从两端删除------------------- 
	lit.pop_back();  
	lit.pop_front();
	for(it=lit.begin();it!=lit.end();it++)
	{
		cout<<*it<<"  ";
	}
	cout<<endl;
	//-------------删除所有的a---------------------------------
	//lit.remove('a');  //删除所有的a;
 
	for(it=lit.begin();it!=lit.end();it++)
	{
		cout<<*it<<"  ";
	}
	cout<<endl;
	//-------------移除连续且相同的a，只剩下一个;--------------------------------
	lit.unique();  //移除连续且相同的a，只剩下一个;
 
	for(it=lit.begin();it!=lit.end();it++)
	{
		cout<<*it<<"  ";
	}
	cout<<endl;
	list<char> lit1;
	lit1.push_back('g');
	lit1.push_back('h');
	lit1.push_back('i');
	lit1.push_back('k');
	for(it1=lit1.begin();it1!=lit1.end();it1++)
	{
		cout<<*it1<<"  ";
	}
	cout<<endl;
	//-------------将一个链表插入到另一个链表---------------------------------
	it1=find(lit.begin(),lit.end(),'f');  //先的找到要插入的位置，在该位置的前一个插入；
	lit.splice(it1,lit1); //将第二个链表插入到第一个链表中；合并后的链表就没了，因为传的是&；
	for(it=lit.begin();it!=lit.end();it++)
	{
		cout<<*it<<"  ";
	}
	cout<<endl;
	//------在链表lit中的it前插入lit1中的一个元素it1；在f之前插入k-----
	//-----拿下来之后那个元素就没有了-------------------
	it=find(lit.begin(),lit.end(),'f');
	it1=find(lit1.begin(),lit1.end(),'k');
	lit.splice(it,lit1,it1);
	//-------------把链表中的一段插入到另一个链表中---------------------------------
	//把链表lit1中的[it-----it1)段的字符插入到lit的it2指针前；
	it=find(lit1.begin(),lit1.end(),'h');
	it1=find(lit1.begin(),lit1.end(),'k');
	it2=find(lit.begin(),lit.end(),'f');
	lit.splice(it2,lit1,it,it1); 
	// ----void merge(list& x);	//将x合并到*this 身上。两个lists 的内容都必须先经过递增归并排序。
	lit.sort();   //对两个排序进行归并排序；
	lit1.sort();
	lit.merge(lit1);
	//-----------将list里的数据倒序排列---------------
	lit.reverse();
	for(it=lit.begin();it!=lit.end();it++)
	{
		cout<<*it<<"  ";
	}
	cout<<endl;
	for(it1=lit1.begin();it1!=lit1.end();it1++)
	{
		cout<<*it1<<"  ";
	}
	cout<<endl;
	system("pause");
	return 0;
}