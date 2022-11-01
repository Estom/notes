Job Stores
2018-09-18 14:36 更新
JobStore负责跟踪您提供给调度程序的所有“工作数据”：jobs，triggers，日历等。为您的Quartz调度程序实例选择适当的JobStore是重要的一步。幸运的是，一旦你明白他们之间的差异，那么选择应该是一个非常简单的选择。

您声明您提供给用于生成调度程序实例的SchedulerFactory的属性文件（或对象）中您的调度程序应使用哪个JobStore（以及它的配置设置）。

切勿在代码中直接使用JobStore实例。由于某种原因，许多人试图这样做。JobStore用于Quartz本身的幕后使用。你必须告诉Quartz（通过配置）使用哪个JobStore，但是你应该只在代码中使用Scheduler界面。
RAMJobStore
RAMJobStore是使用最简单的JobStore，它也是性能最高的（在CPU时间方面）。RAMJobStore以其明显的方式获取其名称：它将其所有数据保存在RAM中。这就是为什么它是闪电般快的，也是为什么这么简单的配置。缺点是当您的应用程序结束（或崩溃）时，所有调度信息都将丢失 - 这意味着RAMJobStore无法履行作业和triggers上的“非易失性”设置。对于某些应用程序，这是可以接受的 - 甚至是所需的行为，但对于其他应用程序，这可能是灾难性的。

要使用RAMJobStore（并假设您使用的是StdSchedulerFactory），只需将类名称org.quartz.simpl.RAMJobStore指定为用于配置石英的JobStore类属性：

配置Quartz以使用RAMJobStore

org.quartz.jobStore.class = org.quartz.simpl.RAMJobStore
没有其他需要担心的设置。

JDBC JobStore
JDBCJobStore也被恰当地命名 - 它通过JDBC将其所有数据保存在数据库中。因此，配置比RAMJobStore要复杂一点，而且也不是那么快。但是，性能下降并不是很糟糕，特别是如果您在主键上构建具有索引的数据库表。在相当现代的一套具有体面的LAN（在调度程序和数据库之间）的机器上，检索和更新触发triggers的时间通常将小于10毫秒。

JDBCJobStore几乎与任何数据库一起使用，已被广泛应用于Oracle，PostgreSQL，MySQL，MS SQLServer，HSQLDB和DB2。要使用JDBCJobStore，必须首先创建一组数据库表以供Quartz使用。您可以在Quartz发行版的“docs / dbTables”目录中找到表创建SQL脚本。如果您的数据库类型尚未有脚本，请查看其中一个脚本，然后以数据库所需的任何方式进行修改。需要注意的一点是，在这些脚本中，所有的表都以前缀“QRTZ_”开始（如表“QRTZ_TRIGGERS”和“QRTZ_JOB_DETAIL”）。只要你通知JDBCJobStore前缀是什么（在你的Quartz属性中），这个前缀实际上可以是你想要的。对于多个调度程序实例，使用不同的前缀可能有助于创建多组表，

创建表后，在配置和启动JDBCJobStore之前，您还有一个重要的决定。您需要确定应用程序需要哪种类型的事务。如果您不需要将调度命令（例如添加和删除triggers）绑定到其他事务，那么可以通过使用JobStoreTX作为JobStore 来管理事务（这是最常见的选择）。

如果您需要Quartz与其他事务（即J2EE应用程序服务器）一起工作，那么您应该使用JobStoreCMT - 在这种情况下，Quartz将让应用程序服务器容器管理事务。

最后一个难题是设置一个DataSource，JDBCJobStore可以从中获取与数据库的连接。DataSources在Quartz属性中使用几种不同的方法之一进行定义。一种方法是让Quartz创建和管理DataSource本身 - 通过提供数据库的所有连接信息。另一种方法是让Quartz使用由Quartz正在运行的应用程序服务器管理的DataSource，通过提供JDBCJobStore DataSource的JNDI名称。有关属性的详细信息，请参阅“docs / config”文件夹中的示例配置文件。

要使用JDBCJobStore（并假定您使用的是StdSchedulerFactory），首先需要将Quartz配置的JobStore类属性设置为org.quartz.impl.jdbcjobstore.JobStoreTX或org.quartz.impl.jdbcjobstore.JobStoreCMT - 具体取决于根据上述几段的解释，您所做的选择。

配置Quartz以使用JobStoreTx
org.quartz.jobStore.class = org.quartz.impl.jdbcjobstore.JobStoreTX
接下来，您需要为JobStore选择一个DriverDelegate才能使用。DriverDelegate负责执行特定数据库可能需要的任何JDBC工作。StdJDBCDelegate是一个使用“vanilla”JDBC代码（和SQL语句）来执行其工作的委托。如果没有为您的数据库专门制作另一个代理，请尝试使用此委托 - 我们仅为数据库制作了特定于数据库的代理，我们使用StdJDBCDelegate（似乎最多！）发现了问题。其他代理可以在“org.quartz.impl.jdbcjobstore”包或其子包中找到。其他代理包括DB2v6Delegate（用于DB2版本6及更早版本），HSQLDBDelegate（用于HSQLDB），MSSQLDelegate（用于Microsoft SQLServer），PostgreSQLDelegate（用于PostgreSQL）），WeblogicDelegate（用于使用Weblogic创建的JDBC驱动程序）

选择委托后，将其类名设置为JDBCJobStore的委托使用。

配置JDBCJobStore以使用DriverDelegate
org.quartz.jobStore.driverDelegateClass = org.quartz.impl.jdbcjobstore.StdJDBCDelegate
接下来，您需要通知JobStore您正在使用的表前缀（如上所述）。

使用表前缀配置JDBCJobStore
org.quartz.jobStore.tablePrefix = QRTZ_
最后，您需要设置JobStore应该使用哪个DataSource。命名的DataSource也必须在Quartz属性中定义。在这种情况下，我们指定Quartz应该使用DataSource名称“myDS”（在配置属性中的其他位置定义）。

使用要使用的DataSource的名称配置JDBCJobStore
org.quartz.jobStore.dataSource = myDS
如果您的计划程序正忙（即几乎总是执行与线程池大小相同的job数量），那么您应该将DataSource中的连接数设置为线程池+ 2的大小。
可以将“org.quartz.jobStore.useProperties”配置参数设置为“true”（默认为false），以指示JDBCJobStore将JobDataMaps中的所有值都作为字符串，因此可以作为名称 - 值对存储而不是在BLOB列中以其序列化形式存储更多复杂的对象。从长远来看，这是更安全的，因为您避免了将非String类序列化为BLOB的类版本问题。
TerracottaJobStore
TerracottaJobStore提供了一种缩放和鲁棒性的手段，而不使用数据库。这意味着您的数据库可以免受Quartz的负载，可以将其所有资源保存为应用程序的其余部分。

TerracottaJobStore可以运行群集或非群集，并且在任一情况下，为应用程序重新启动之间持续的作业数据提供存储介质，因为数据存储在Terracotta服务器中。它的性能比通过JDBCJobStore使用数据库要好得多（约一个数量级更好），但比RAMJobStore要慢。

要使用TerracottaJobStore（并且假设您使用的是StdSchedulerFactory），只需将类名称org.quartz.jobStore.class = org.terracotta.quartz.TerracottaJobStore指定为用于配置石英的JobStore类属性，并添加一个额外的行配置来指定Terracotta服务器的位置：

配置Quartz以使用TerracottaJobStore
org.quartz.jobStore.class = org.terracotta.quartz.TerracottaJobStore
org.quartz.jobStore.tcConfigUrl = localhost:9510