
## 3 CronTrigger类

 
Quartz有两大触发器，除了上面使用的SimpleTrigger外，就是CronTrigger。CronTrigger能够提供复杂的触发器表达式的支持。CronTrigger是基于Unix Cron守护进程，它是一个调度程序，支持简单而强大的触发器语法。
 
使用CronTrigger主要的是要掌握Cron表达式。Cron表达式包含6个必要组件和一个可选组件，如下表所示。

|  位置  |  含义  |  允许的特殊字符  |
|---|---|---|
|  1  |  秒（0~59）  |  ,&nbsp;-&nbsp; *&nbsp; /  |
|  2  |  分（0~59）  |  ,&nbsp;-&nbsp; *&nbsp; /  |
|  3  |  小时（0~24）  |  ,&nbsp;-&nbsp; *&nbsp; /  |
|  4  |  日期（1~31）  |  ,&nbsp;-&nbsp; *&nbsp; /&nbsp; ?&nbsp; L&nbsp; W&nbsp;  C  |
|  5  |  月（JAN~DEC或1~12）  |  ,&nbsp;-&nbsp; *&nbsp; /  |
|  6  |  星期（SUN~SAT或1~7）  |  ,&nbsp;-&nbsp; *&nbsp; /&nbsp; ?&nbsp; L&nbsp; C&nbsp;  #  |
|  7  |  年（可选，1970~2099），若为空，表示全部时间范围  |  ,&nbsp;-&nbsp; *&nbsp; /  |


特殊字符的含义，见下表。

|  特殊字符  |  说明  |
|---|---|
|  *  |  通配符，任意值  |
|  ?  |  无特定值。通常和其他指定的值一起使用，表示必须显示该值但不能检查  |
|  -  |  范围。e.g.小时部分10-12表示10:00，11:00， 12:00  |
|  ,  |  列分隔符。可以让你指定一系列的值。e.g.在星期域中指定MON、TUE和WED  |
|  /  |  增量。表示一个值的增量，e.g.分钟域中0/1表示从0开始，每次增加1min  |
|  L  |  表示Last。它在日期和星期域中表示有所不同。在日期域中，表示这个月的最后一天，而在星期域中，它永远是7（星期六）。当你希望使用星期中某一天时，L字符非常有用。e.g.星期域中6L表示每一个月的最后一个星期五  |
|  W  |  在本月内离当天最近的工作日触发，所谓的最近工作日，即当天到工作日的前后最短距离，如果当天即为工作日，则距离是0；所谓本月内指的是不能跨月取到最近工作日，即使前/后月份的最后一天/第一天确实满足最近工作日。e.g. LW表示本月的最后一个工作日触发，W强烈依赖月份。  |
|  #  |  表示该月的第几个星期，e.g. 1#2表示每一个月的第一个星期一  |
|  C  |  日历值。日期值是根据一个给定的日历计算出来的。在日期域中给定一个20C将在20日（日历包括20日）或20日后日历中包含的第一天（不包括20日）激活触发器。例如在一个星期域中使用6C表示日历中星期五（日历包括星期五）或者第一天（日历不包括星期五）  |


 
Cron表达式举例：

```
"30 * * * * ?" 每半分钟触发任务
"30 10 * * * ?" 每小时的10分30秒触发任务
"30 10 1 * * ?" 每天1点10分30秒触发任务
"30 10 1 20 * ?" 每月20号1点10分30秒触发任务
"30 10 1 20 10 ? *" 每年10月20号1点10分30秒触发任务
"30 10 1 20 10 ? 2011" 2011年10月20号1点10分30秒触发任务
"30 10 1 ? 10 * 2011" 2011年10月每天1点10分30秒触发任务
"30 10 1 ? 10 SUN 2011" 2011年10月每周日1点10分30秒触发任务
"15,30,45 * * * * ?" 每15秒，30秒，45秒时触发任务
"15-45 * * * * ?" 15到45秒内，每秒都触发任务
"15/5 * * * * ?" 每分钟的每15秒开始触发，每隔5秒触发一次
"15-30/5 * * * * ?" 每分钟的15秒到30秒之间开始触发，每隔5秒触发一次
"0 0/3 * * * ?" 每小时的第0分0秒开始，每三分钟触发一次
"0 15 10 ? * MON-FRI" 星期一到星期五的10点15分0秒触发任务
"0 15 10 L * ?" 每个月最后一天的10点15分0秒触发任务
"0 15 10 LW * ?" 每个月最后一个工作日的10点15分0秒触发任务
"0 15 10 ? * 5L" 每个月最后一个星期四的10点15分0秒触发任务
"0 15 10 ? * 5#3" 每个月第三周的星期四的10点15分0秒触发任务
```

将上面HelloQuartz例子中SimpleTrigger换成CronTrigger，代码如下。

```java
代码清单3：CronTrigger调度器
import java.text.ParseException;
import org.quartz.CronTrigger;
import org.quartz.JobDetail;
import org.quartz.Scheduler;
import org.quartz.SchedulerException;
import org.quartz.SchedulerFactory;
import org.quartz.impl.StdSchedulerFactory;

public class HelloQuartzScheduling {

     public static void main(String[] args) 
         throws SchedulerException, ParseException {

        SchedulerFactory schedulerFactory = new StdSchedulerFactory();
        Scheduler scheduler = schedulerFactory.getScheduler();

        JobDetail jobDetail = new JobDetail( "helloQuartzJob", 
                Scheduler.DEFAULT_GROUP, HelloQuartzJob. class);

         String cronExpression = "30/5 * * * * ?"; // 每分钟的30s起，每5s触发任务        
        CronTrigger cronTrigger = new CronTrigger( "cronTrigger", 
                Scheduler.DEFAULT_GROUP, cronExpression);

        scheduler.scheduleJob(jobDetail, cronTrigger);

        scheduler.start();
    }

}
```

CronTrigger使用HolidayCalendar类可以排除某一段时间，比如说国庆节不执行调度任务，代码示例如下：

```java
代码清单4：HolidayCalendar的使用
import java.text.ParseException;
import java.util.Calendar;
import org.quartz.CronTrigger;
import org.quartz.JobDetail;
import org.quartz.Scheduler;
import org.quartz.SchedulerException;
import org.quartz.SchedulerFactory;
import org.quartz.impl.StdSchedulerFactory;
import org.quartz.impl.calendar.HolidayCalendar;


public class HelloQuartzScheduling {

     public static void main(String[] args) 
         throws SchedulerException, ParseException {

        SchedulerFactory schedulerFactory = new StdSchedulerFactory();
        Scheduler scheduler = schedulerFactory.getScheduler();

        JobDetail jobDetail = new JobDetail( "helloQuartzJob", 
                Scheduler.DEFAULT_GROUP, HelloQuartzJob. class);

        Calendar cal = Calendar.getInstance();
        cal.set( 2012, Calendar.OCTOBER, 1); // 国庆节

        HolidayCalendar holidayCal = new HolidayCalendar();
        holidayCal.addExcludedDate(cal.getTime()); // 排除该日期

         // addCalendar(String calName, Calendar calendar, 
         //             boolean replace, boolean updateTriggers)
        scheduler.addCalendar( "calendar", holidayCal, true, false);

        String cronExpression = "30/5 * * * * ?"; // 每5s触发任务        
        CronTrigger cronTrigger = new CronTrigger( "cronTrigger", 
                Scheduler.DEFAULT_GROUP, cronExpression);

        cronTrigger.setCalendarName( "calendar");

        scheduler.scheduleJob(jobDetail, cronTrigger);

        scheduler.start();
    }

}
```

## 4 JobStore: 任务持久化

Quartz支持任务持久化，这可以让你在运行时增加任务或者对现存的任务进行修改，并为后续任务的执行持久化这些变更和增加的部分。中心概念是JobStore接口。默认的是RAMJobStore。
 
 
 