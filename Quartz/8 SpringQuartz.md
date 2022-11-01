
## 1 SpringBoot-quartz基本用法

### 添加依赖

```xml
<!-- 实现对 Spring MVC 的自动化配置 -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
</dependency>

<!-- 实现对 Quartz 的自动化配置 -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-quartz</artifactId>
</dependency>
```
### 创建任务
创建job
```java
@Slf4j
public class FirstJob extends QuartzJobBean {

    @Override
    protected void executeInternal(JobExecutionContext jobExecutionContext) throws JobExecutionException {
        String now = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss").format(LocalDateTime.now());
        log.info("当前的时间: " + now);
    }
}

@Slf4j
public class SecondJob extends QuartzJobBean {

    @Override
    protected void executeInternal(JobExecutionContext jobExecutionContext) throws JobExecutionException {
        String now = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss").format(LocalDateTime.now());
        log.info("SecondJob执行, 当前的时间: " + now);
    }
}
```


### 创建配置类
JobDetail&Trigger该方法实现的定时任务，由spring框架启动线程进行调度。用户不需要自己初始化scheduler并启动线程。

SimpleScheduleBuilder自动配置
```java
@Configuration
@Service
public class QuartzConfig {

    @Bean
    public JobDetail scheduleJobDetail() {
        System.out.println("**************************************** scheduler job begin");
        JobDetail jobDetail = JobBuilder.newJob(SchedulerJob.class)
                .withIdentity("schedulerJob")
                .storeDurably()
                .build();
        System.out.println("**************************************** scheduler job end");
        return jobDetail;
    }

    @Bean
    public Trigger scheduleJobDetailTrigger() {
        Trigger trigger = TriggerBuilder
                .newTrigger()
                .forJob(scheduleJobDetail())
                .withIdentity("schedulerJob")
                .withSchedule(SimpleScheduleBuilder.simpleSchedule().withRepeatCount(0))
                .startNow()
                .build();
        System.out.println("schedulerJob trigger end");
        return trigger;
    }
```

CronScheduleBuilder手动配置

使用ApplicationRunner方法启动了一个线程运行程序。手动创建scheduler加载配置、JobDetail、Trigger然后启动任务。
```java
@Component
public class JobInit implements ApplicationRunner {

    private static final String ID = "SUMMERDAY";

    @Autowired
    private Scheduler scheduler;

    @Override
    public void run(ApplicationArguments args) throws Exception {
        JobDetail jobDetail = JobBuilder.newJob(FirstJob.class)
                .withIdentity(ID + " 01")
                .storeDurably()
                .build();
        CronScheduleBuilder scheduleBuilder =
                CronScheduleBuilder.cronSchedule("0/5 * * * * ? *");
        // 创建任务触发器
        Trigger trigger = TriggerBuilder.newTrigger()
                .forJob(jobDetail)
                .withIdentity(ID + " 01Trigger")
                .withSchedule(scheduleBuilder)
                .startNow() //立即執行一次任務
                .build();
        // 手动将触发器与任务绑定到调度器内
        scheduler.scheduleJob(jobDetail, trigger);
    }
}
```


## 2 使用Spring提供的工厂Bean进行配置
> 根本找到相关的教程。这都是什么东西啊？？？
### 添加依赖
同上
### 创建任务
同上

### 使用工厂bean
