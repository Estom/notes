Listeners是您创建的对象，用于根据调度程序中发生的事件执行操作。您可能猜到，TriggerListeners接收到与触发器（trigger）相关的事件，JobListeners 接收与jobs相关的事件。

与触发相关的事件包括：触发器触发，触发失灵（在本文档的“触发器”部分中讨论），并触发完成（触发器关闭的作业完成）。

org.quartz.TriggerListener接口

public interface TriggerListener {

    public String getName();

    public void triggerFired(Trigger trigger, JobExecutionContext context);

    public boolean vetoJobExecution(Trigger trigger, JobExecutionContext context);

    public void triggerMisfired(Trigger trigger);

    public void triggerComplete(Trigger trigger, JobExecutionContext context,
            int triggerInstructionCode);
}
job相关事件包括：job即将执行的通知，以及job完成执行时的通知。

org.quartz.JobListener接口

public interface JobListener {

    public String getName();

    public void jobToBeExecuted(JobExecutionContext context);

    public void jobExecutionVetoed(JobExecutionContext context);

    public void jobWasExecuted(JobExecutionContext context,
            JobExecutionException jobException);

}
使用自己的Listeners
要创建一个listener，只需创建一个实现org.quartz.TriggerListener和/或org.quartz.JobListener接口的对象。然后，listener在运行时会向调度程序注册，并且必须给出一个名称（或者，他们必须通过他们的getName（）方法来宣传自己的名字）。

为了方便起见，实现这些接口，您的类也可以扩展JobListenerSupport类或TriggerListenerSupport类，并且只需覆盖您感兴趣的事件。

listener与调度程序的ListenerManager一起注册，并配有描述listener希望接收事件的job/触发器的Matcher。

Listener在运行时间内与调度程序一起注册，并且不与jobs和触发器一起存储在JobStore中。这是因为听众通常是与应用程序的集成点。因此，每次运行应用程序时，都需要重新注册该调度程序。
添加对特定job感兴趣的JobListener：

scheduler.getListenerManager().addJobListener(myJobListener，KeyMatcher.jobKeyEquals(new JobKey("myJobName"，"myJobGroup")));
您可能需要为匹配器和关键类使用静态导入，这将使您定义匹配器更简洁：

import static org.quartz.JobKey.*;
import static org.quartz.impl.matchers.KeyMatcher.*;
import static org.quartz.impl.matchers.GroupMatcher.*;
import static org.quartz.impl.matchers.AndMatcher.*;
import static org.quartz.impl.matchers.OrMatcher.*;
import static org.quartz.impl.matchers.EverythingMatcher.*;
...etc.
这将上面的例子变成这样：

scheduler.getListenerManager().addJobListener(myJobListener, jobKeyEquals(jobKey("myJobName", "myJobGroup")));
添加对特定组的所有job感兴趣的JobListener：

scheduler.getListenerManager().addJobListener(myJobListener, jobGroupEquals("myJobGroup"));
添加对两个特定组的所有job感兴趣的JobListener：

scheduler.getListenerManager().addJobListener(myJobListener, or(jobGroupEquals("myJobGroup"), jobGroupEquals("yourGroup")));
添加对所有job感兴趣的JobListener：

scheduler.getListenerManager().addJobListener(myJobListener, allJobs());
注册TriggerListeners的工作原理相同。

Quartz的大多数用户并不使用Listeners，但是当应用程序需求创建需要事件通知时不需要Job本身就必须明确地通知应用程序，这些用户就很方便。


SchedulerListeners
2018-09-15 11:02 更新
SchedulerListeners非常类似于TriggerListeners和JobListeners，除了它们在Scheduler本身中接收到事件的通知 - 不一定与特定触发器（trigger）或job相关的事件。

与计划程序相关的事件包括：添加job/触发器，删除job/触发器，调度程序中的严重错误，关闭调度程序的通知等。

org.quartz.SchedulerListener接口

public interface SchedulerListener {

    public void jobScheduled(Trigger trigger);

    public void jobUnscheduled(String triggerName, String triggerGroup);

    public void triggerFinalized(Trigger trigger);

    public void triggersPaused(String triggerName, String triggerGroup);

    public void triggersResumed(String triggerName, String triggerGroup);

    public void jobsPaused(String jobName, String jobGroup);

    public void jobsResumed(String jobName, String jobGroup);

    public void schedulerError(String msg, SchedulerException cause);

    public void schedulerStarted();

    public void schedulerInStandbyMode();

    public void schedulerShutdown();

    public void schedulingDataCleared();
}
SchedulerListeners注册到调度程序的ListenerManager。SchedulerListeners几乎可以实现任何实现org.quartz.SchedulerListener接口的对象。

添加SchedulerListener：

scheduler.getListenerManager().addSchedulerListener(mySchedListener);
删除SchedulerListener：

scheduler.getListenerManager().removeSchedulerListener(mySchedListener);