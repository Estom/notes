EntityFramework中使用Repository装饰器

**铺垫**

通常在使用 EntityFramework 时，我们会封装出 IRepository 和 IUnitOfWork
接口，前者负责 CRUD 操作，后者负责数据提交 Commit。

![copycode.gif](media/51e409b11aa51c150090697429a953ed.gif)

复制代码

1 public interface IRepository\<T\> 2 where T : class 3 { 4 IQueryable\<T\>
Query(); 5 6 void Insert(T entity); 7 8 void Update(T entity, params
Expression\<Func\<T, object\>\>[] modifiedPropertyLambdas); 9 10 void Delete(T
entity); 11 }

![copycode.gif](media/51e409b11aa51c150090697429a953ed.gif)

复制代码

1 public interface IUnitOfWork 2 { 3 void Commit(); 4 }

然后，通过使用 Unity IoC 容器来注册泛型接口与实现类型。

![copycode.gif](media/51e409b11aa51c150090697429a953ed.gif)

复制代码

1 Func\<IUnityContainer\> factory = () =\> 2 { 3 return new UnityContainer() 4
.RegisterType(typeof(IRepository\<\>), typeof(Repository\<\>), new
ContainerControlledLifetimeManager()) 5 .RegisterType\<IUnitOfWork,
UnitOfWork\>(new ContainerControlledLifetimeManager()) 6
.RegisterType\<DbContext, MyDBContext\>(new
ContainerControlledLifetimeManager()) 7 .RegisterType\<DbContextAdapter\>(new
ContainerControlledLifetimeManager()) 8 .RegisterType\<IObjectSetFactory,
DbContextAdapter\>(new ContainerControlledLifetimeManager()) 9
.RegisterType\<IObjectContext, DbContextAdapter\>(new
ContainerControlledLifetimeManager()); 10 };

![copycode.gif](media/51e409b11aa51c150090697429a953ed.gif)

复制代码

进而使与数据库相关的操作在 Bisuness Logic 中呈现的非常简单。

例如，通过一系列封装，我们可以达到如下效果：

![copycode.gif](media/51e409b11aa51c150090697429a953ed.gif)

复制代码

1 Customer customer = new Customer() 2 { 3 ID = "123",4 FirstName = "Dennis",5
LastName = "Gao",6 }; 7 Repository.Customer.Insert(customer); 8
Repository.Commit();

![copycode.gif](media/51e409b11aa51c150090697429a953ed.gif)

复制代码

查询操作也是一句话搞定：

1 Customer customer = Repository.Customer.Query().SingleOrDefault(c =\> c.ID ==
"123");

**需求**

假设有一个新的需求：要求在应用层面记录对每个 Table 的 CRUD 的次数。

这时，有几种办法：

1.  应用程序的 Business Logic 中自己记录，比如调用 Update() 操作后记录。

2.  使用 AOP 模式，在调用 CRUD 方法时注入计数器。

3.  修改 Repository\<T\> 实现，在每个方法中嵌入计数器。

4.  继承 Repository\<T\> 类，在衍生类中嵌入计数器。

5.  使用装饰器模式封装 Repository\<T\>，在新的 RepositoryDecorator\<T\>
    类中嵌入计数器。

考虑到前三种方法均需要改动已有代码，主要是涉及的修改太多，所有没有尝试采用。

方法 4 则要求修改 Repository\<T\> 的实现，为 CRUD 方法添加 virtual
关键字以便扩展。

方法 5 不需要修改 Repository\<T\> 的实现，对已有代码的改动不大。

综上所述，我们选择了方法 5。

**Repository 装饰器基类实现**

为便于以后的扩展，创建一个装饰器的抽象类。

![copycode.gif](media/51e409b11aa51c150090697429a953ed.gif)

复制代码

1 public abstract class RepositoryDecorator\<T\> : IRepository\<T\> 2 where T :
class 3 { 4 private readonly IRepository\<T\> \_surrogate; 5 6 protected
RepositoryDecorator(IRepository\<T\> surrogate) 7 { 8 \_surrogate = surrogate; 9
} 10 11 protected IRepository\<T\> Surrogate 12 { 13 get { return \_surrogate; }
14 } 15 16 \#region IRepository\<T\> Members 17 18 public virtual
IQueryable\<T\> Query() 19 { 20 return \_surrogate.Query(); 21 } 22 23 public
virtual void Insert(T entity) 24 { 25 \_surrogate.Insert(entity); 26 } 27 28
public virtual void Update(T entity, params Expression\<Func\<T, object\>\>[]
modifiedPropertyLambdas)29 { 30 \_surrogate.Update(entity,
modifiedPropertyLambdas); 31 } 32 33 public virtual void Delete(T entity) 34 {
35 \_surrogate.Delete(entity); 36 } 37 38 \#endregion39 }

![copycode.gif](media/51e409b11aa51c150090697429a953ed.gif)

复制代码

可以看到，RepositoryDecorator\<T\> 类型仍然实现了 IRepository\<T\>
接口，对外使用没有任何变化。

**实现需求**

我们定义一个 CountableRepository\<T\> 类用于封装 CRUD 计数功能，其继承自
RepositoryDecorator\<T\> 抽象类。

![copycode.gif](media/51e409b11aa51c150090697429a953ed.gif)

复制代码

1 public class CountableRepository\<T\> : RepositoryDecorator\<T\> 2 where T :
class 3 { 4 public CountableRepository(IRepository\<T\> surrogate) 5 :
base(surrogate) 6 { 7 } 8 9 public override IQueryable\<T\> Query() 10 { 11
PerformanceCounter.CountQuery\<T\>(); 12 return base.Query();13 } 14 15 public
override void Insert(T entity) 16 { 17 PerformanceCounter.CountInsert\<T\>(); 18
base.Insert(entity);19 } 20 21 public override void Update(T entity, params
Expression\<Func\<T, object\>\>[] modifiedPropertyLambdas)22 { 23
PerformanceCounter.CountUpdate\<T\>(); 24 base.Update(entity,
modifiedPropertyLambdas);25 } 26 27 public override void Delete(T entity) 28 {
29 PerformanceCounter.CountDelete\<T\>(); 30 base.Delete(entity);31 } 32 }

![copycode.gif](media/51e409b11aa51c150090697429a953ed.gif)

复制代码

我们在 override 方法中，添加了 CRUD 的计数功能。这里的代码简写为：

1 PerformanceCounter.CountQuery\<T\>();

对原有代码的修改则是需要注册新的 CountableRepository\<T\> 类型。

![copycode.gif](media/51e409b11aa51c150090697429a953ed.gif)

复制代码

1 Func\<IUnityContainer\> factory = () =\> 2 { 3 return new UnityContainer() 4
.ReplaceBehaviorExtensionsWithSafeExtension() 5
.RegisterType(typeof(IRepository\<\>), typeof(Repository\<\>), new
ContainerControlledLifetimeManager()) 6
.RegisterType(typeof(CountableRepository\<\>), new
ContainerControlledLifetimeManager()) 7 .RegisterType\<IUnitOfWork,
UnitOfWork\>(new ContainerControlledLifetimeManager()) 8
.RegisterType\<DbContext, MyDBContext\>(new
ContainerControlledLifetimeManager()) 9 .RegisterType\<DbContextAdapter\>(new
ContainerControlledLifetimeManager()) 10 .RegisterType\<IObjectSetFactory,
DbContextAdapter\>(new ContainerControlledLifetimeManager()) 11
.RegisterType\<IObjectContext, DbContextAdapter\>(new
ContainerControlledLifetimeManager()); 12 };

![copycode.gif](media/51e409b11aa51c150090697429a953ed.gif)

复制代码

**扩展应用**

既然有了抽象基类 RepositoryDecorator\<T\> ，我们可以从其设计衍生多个特定场景的
Repository 。

比如，当我们需要为某个 Table 的 Entity 添加缓存功能时，我们可以定制一个
CachableRepository\<T\> 来完成这一个扩展。
