## 1 Flux类中的静态方法
### 简单的创建方法

**just()**


可以指定序列中包含的全部元素。创建出来的Flux序列在发布这些元素之后会自动结束

**fromArray()，fromIterable()，fromStream()：**

可以从一个数组，Iterable对象或Stream对象中穿件Flux对象

**empty()**

创建一个不包含任何元素，只发布结束消息的序列

**error(Throwable error)：**

创建一个只包含错误消息的序列

**never()：**

传建一个不包含任务消息通知的序列

**range(int start, int count)：**

创建包含从start起始的count个数量的Integer对象的序列

**interval(Duration period)和interval(Duration delay, Duration period)：**

创建一个包含了从0开始递增的Long对象的序列。其中包含的元素按照指定的间隔来发布。除了间隔时间之外，还可以指定起始元素发布之前的延迟时间

**intervalMillis(long period)和intervalMillis(long delay, long period)：**

与interval()方法相同，但该方法通过毫秒数来指定时间间隔和延迟时间

例子
```
Flux.just("Hello", "World").subscribe(System.out::println);
Flux.fromArray(new Integer[]{1, 2, 3}).subscribe(System.out::println);
Flux.empty().subscribe(System.out::println);
Flux.range(1, 10).subscribe(System.out::println);
Flux.interval(Duration.of(10, ChronoUnit.SECONDS)).subscribe(System.out::println);
Flux.intervalMillis(1000).subscirbe(System.out::println);
```

### 复杂的序列创建 generate()
当序列的生成需要复杂的逻辑时，则应该使用generate()或create()方法。

* generate()方法通过同步和逐一的方式来产生Flux序列。

* 序列的产生是通过调用所提供的的SynchronousSink对象的next()，complete()和error(Throwable)方法来完成的。

* 逐一生成的含义是在具体的生成逻辑中，next()方法只能最多被调用一次。

* 在某些情况下，序列的生成可能是有状态的，需要用到某些状态对象，此时可以使用

```
generate(Callable<S> stateSupplier, BiFunction<S, SynchronousSink<T>, S> generator)，
```
其中stateSupplier用来提供初始的状态对象。

在进行序列生成时，状态对象会作为generator使用的第一个参数传入，可以在对应的逻辑中对改状态对象进行修改以供下一次生成时使用。
```java
Flux.generate(sink -> {
  sink.next("Hello");
  sink.complete();  
}).subscribe(System.out::println);


final Random random = new Random();
Flux.generate(ArrayList::new, (list, sink) -> {
  int value = random.nextInt(100);
  list.add(value);
  sink.next(value);
  if( list.size() ==10 )
    sink.complete();
  return list;
}).subscribe(System.out::println);
```

### 复杂的序列创建 create()
create()方法与generate()方法的不同之处在于所使用的是FluxSink对象。

FluxSink支持同步和异步的消息产生，并且可以在一次调用中产生多个元素。
```·
Flux.create(sink -> {
  for(int i = 0; i < 10; i ++)
    sink.next(i);
  sink.complete();
}).subscribe(System.out::println);
```

## 2 Mono静态方法
Mono类包含了与Flux类中相同的静态方法：just()，empty()和never()等。

除此之外，Mono还有一些独有的静态方法：


* fromCallable()，fromCompletionStage()，fromFuture()，fromRunnable()和fromSupplier()：分别从Callable，CompletionStage，CompletableFuture，Runnable和Supplier中创建Mono

* delay(Duration duration)和delayMillis(long duration)：创建一个Mono序列，在指定的延迟时间之后，产生数字0作为唯一值

* ignoreElements(Publisher source)：创建一个Mono序列，忽略作为源的Publisher中的所有元素，只产生消息

* justOrEmpty(Optional<? extends T> data)和justOrEmpty(T data)：从一个Optional对象或可能为null的对象中创建Mono。只有Optional对象中包含之或对象不为null时，Mono序列才产生对应的元素


```java
Mono.fromSupplier(() -> "Hello").subscribe(System.out::println);
Mono.justOrEmpty(Optional.of("Hello")).subscribe(System.out::println);
Mono.create(sink -> sink.success("Hello")).subscribte(System.out::println);
```

## 3 操作符
### 操作符buffer和bufferTimeout
这两个操作符的作用是把当前流中的元素收集到集合中，并把集合对象作为流中的新元素。

在进行收集时可以指定不同的条件：所包含的元素的最大数量或收集的时间间隔。方法buffer()仅使用一个条件，而bufferTimeout()可以同时指定两个条件。

指定时间间隔时可以使用Duration对象或毫秒数，即使用bufferMillis()或bufferTimeoutMillis()两个方法。

除了元素数量和时间间隔外，还可以通过bufferUntil和bufferWhile操作符来进行收集。这两个操作符的参数时表示每个集合中的元素索要满足的条件的Predicate对象。

bufferUntil会一直收集直到Predicate返回true。

使得Predicate返回true的那个元素可以选择添加到当前集合或下一个集合中；bufferWhile则只有当Predicate返回true时才会收集。一旦为false，会立即开始下一次收集。

```java
Flux.range(1, 100).buffer(20).subscribe(System.out::println);
Flux.intervalMillis(100).bufferMillis(1001).take(2).toStream().forEach(System.out::println);
Flux.range(1, 10).bufferUntil(i -> i%2 == 0).subscribe(System.out::println);
Flux.range(1, 10).bufferWhile(i -> i%2 == 0).subscribe(System.out::println);
```

### 操作符Filter
对流中包含的元素进行过滤，只留下满足Predicate指定条件的元素。
```
Flux.range(1, 10).filter(i -> i%2 == 0).subscribe(System.out::println);
```

### 操作符zipWith
zipWith操作符把当前流中的元素与另一个流中的元素按照一对一的方式进行合并。在合并时可以不做任何处理，由此得到的是一个元素类型为Tuple2的流；也可以通过一个BiFunction函数对合并的元素进行处理，所得到的流的元素类型为该函数的返回值。
```java
Flux.just("a", "b").zipWith(Flux.just("c", "d")).subscribe(System.out::println);
Flux.just("a", "b").zipWith(Flux.just("c", "d"), (s1, s2) -> String.format("%s-%s", s1, s2)).subscribe(System.out::println);
```

### 操作符take
take系列操作符用来从当前流中提取元素。提取方式如下：

* take(long n)，take(Duration timespan)和takeMillis(long timespan)：按照指定的数量或时间间隔来提取

* takeLast(long n)：提取流中的最后N个元素

* takeUntil(Predicate<? super T> predicate) ：提取元素直到Predicate返回true

* takeWhile(Predicate<? super T> continuePredicate)：当Predicate返回true时才进行提取

* takeUntilOther(Publisher<?> other)：提取元素知道另外一个流开始产生元素

```java
Flux.range(1, 1000).take(10).subscribe(System.out::println);
Flux.range(1, 1000).takeLast(10).subscribe(System.out::println);
Flux.range(1, 1000).takeWhile(i -> i < 10).subscribe(System.out::println);
Flux.range(1, 1000).takeUntil(i -> i == 10).subscribe(System.out::println);
```

### 操作符reduce和reduceWith
reduce和reduceWith操作符对流中包含的所有元素进行累计操作，得到一个包含计算结果的Mono序列。累计操作是通过一个BiFunction来表示的。在操作时可以指定一个初始值。若没有初始值，则序列的第一个元素作为初始值。

```
Flux.range(1, 100).reduce((x, y) -> x + y).subscribe(System.out::println);
Flux.range(1, 100).reduceWith(() -> 100, (x + y) -> x + y).subscribe(System.out::println);
```

### 操作符merge和mergeSequential
merge和mergeSequential操作符用来把多个流合并成一个Flux序列。merge按照所有流中元素的实际产生序列来合并，而mergeSequential按照所有流被订阅的顺序，以流为单位进行合并。
```java
Flux.merge(Flux.intervalMillis(0, 100).take(5), Flux.intervalMillis(50, 100).take(5)).toStream().forEach(System.out::println);
Flux.mergeSequential(Flux.intervalMillis(0, 100).take(5), Flux.intervalMillis(50, 100).take(5)).toStream().forEach(System.out::println);
```
### 操作符flatMap和flatMapSequential
flatMap和flatMapSequential操作符把流中的每个元素转换成一个流，再把所有流中的元素进行合并。flatMapSequential和flatMap之间的区别与mergeSequential和merge是一样的。

```java
Flux.just(5, 10).flatMap(x -> Flux.intervalMillis(x * 10, 100).take(x)).toStream().forEach(System.out::println);
```
### 操作符concatMap
concatMap操作符的作用也是把流中的每个元素转换成一个流，再把所有流进行合并。concatMap会根据原始流中的元素顺序依次把转换之后的流进行合并，并且concatMap堆转换之后的流的订阅是动态进行的，而flatMapSequential在合并之前就已经订阅了所有的流。
```
Flux.just(5, 10).concatMap(x -> Flux.intervalMillis(x * 10, 100).take(x)).toStream().forEach(System.out::println);
```
### 操作符combineLatest
combineLatest操作符把所有流中的最新产生的元素合并成一个新的元素，作为返回结果流中的元素。只要其中任何一个流中产生了新的元素，合并操作就会被执行一次，结果流中就会产生新的元素。
```
Flux.combineLatest(Arrays::toString, Flux.intervalMillis(100).take(5), Flux.intervalMillis(50, 100).take(5)).toStream().forEach(System.out::println);
```


## 4 消息处理
当需要处理Flux或Mono中的消息时，可以通过subscribe方法来添加相应的订阅逻辑。

* 在调用subscribe方法时可以指定需要处理的消息类型。
```java
Flux.just(1, 2).concatWith(Mono.error(new IllegalStateException())).subscribe(System.out::println, System.err::println);

Flux.just(1, 2).concatWith(Mono.error(new IllegalStateException())).onErrorReturn(0).subscribe(System.out::println);
```

* 第2种可以通过switchOnError()方法来使用另外的流来产生元素。
```java
Flux.just(1, 2).concatWith(Mono.error(new IllegalStateException())).switchOnError(Mono.just(0)).subscribe(System.out::println);
```

* 第三种是通过onErrorResumeWith()方法来根据不同的异常类型来选择要使用的产生元素的流。
```java
Flux.just(1, 2).concatWith(Mono.error(new IllegalArgumentException())).onErrorResumeWith(e -> {
  if(e instanceof IllegalStateException)
    return Mono.just(0);
  else if(e instanceof IllegalArgumentException)
    return Mono.just(-1);
  return Mono.epmty();
}).subscribe(System,.out::println);
```
* 当出现错误时还可以使用retry操作符来进行重试。重试的动作是通过重新订阅序列来实现的。在使用retry操作时还可以指定重试的次数。

```java
 Flux.just(1, 2).concatWith(Mono.error(new IllegalStateException())).retry(1).subscrible(System.out::println);
```

## 5 调度器Scheduler
通过调度器可以指定操作执行的方式和所在的线程。有以下几种不同的调度器实现

* 当前线程，通过Schedulers.immediate()方法来创建

* 单一的可复用的线程，通过Schedulers.single()方法来创建

* 弹性的线程池，通过Schedulers.elastic()方法来创建。线程池中的线程是可以复用的。当所需要时，新的线程会被创建。若一个线程闲置时间太长，则会被销毁。该调度器适用于I/O操作相关的流的处理

* 并行操作优化的线程池，通过Schedulers.parallel()方法来创建。其中的线程数量取决于CPU的核的数量。该调度器适用于计算密集型的流的处理

* 使用支持任务调度的调度器，通过Schedulers.timer()方法来创建

* 从已有的ExecutorService对象中创建调度器，通过Schedulers.fromExecutorService()方法来创建

通过publishOn()和subscribeOn()方法可以切换执行操作调度器。publishOn()方法切换的是操作符的执行方式，而subscribeOn()方法切换的是产生流中元素时的执行方式

```java
Flux.create(sink -> {
  sink.next(Thread.currentThread().getName());
  sink.complete();  
}).publishOn(Schedulers.single())
.map(x ->  String.format("[%s] %s", Thread.currentThread().getName(), x))
.publishOn(Schedulers.elastic())
.map(x -> String.format("[%s] %s", Thread.currentThread().getName(), x))
.subscribeOn(Schedulers.parallel())
.toStream()
.forEach(System.out::println);
```

## 6 测试
StepVerifier的作用是可以对序列中包含的元素进行逐一验证。通过StepVerifier.create()方法对一个流进行包装之后再进行验证。expectNext()方法用来声明测试时所期待的流中的下一个元素的值，而verifyComplete()方法则验证流是否正常结束。verifyError()来验证流由于错误而终止。

```
StepVerifier.create(Flux.just(a, b)).expectNext("a").expectNext("b").verifyComplete();
```
使用StepVerifier.withVirtualTime()方法可以创建出使用虚拟时钟的SteoVerifier。通过thenAwait(Duration)方法可以让虚拟时钟前进。
```
StepVerifier.withVirtualTime(() -> Flux.interval(Duration.ofHours(4), Duration.ofDays(1)).take(2))
　.expectSubscription()
　.expectNoEvent(Duration.ofHours(4))
　.expectNext(0L)
　.thenAwait(Duration.ofDays(1))
　.expectNext(1L)
　.verifyComplete();
```
TestPublisher的作用在于可以控制流中元素的产生，甚至是违反反应流规范的情况。通过create()方法创建一个新的TestPublisher对象，然后使用next()方法来产生元素，使用complete()方法来结束流。
```
final TestPublisher<String> testPublisher = TestPublisher.creater();
testPublisher.next("a");
testPublisher.next("b");
testPublisher.complete();

StepVerifier.create(testPublisher)
    .expectNext("a")
    .expectNext("b")
    .expectComplete();
```
## 7 调试
在调试模式启用之后，所有的操作符在执行时都会保存额外的与执行链相关的信息。当出现错误时，这些信息会被作为异常堆栈信息的一部分输出。
```
Hooks.onOperator(providedHook -> providedHook.operatorStacktrace());
```
也可以通过checkpoint操作符来对特定的流处理链来启用调试模式。
```
Flux.just(1, 0).map(x -> 1/x).checkpoint("test").subscribe(System.out::println);
```

## 8 日志记录
可以通过添加log操作把流相关的事件记录在日志中，
```
Flux.range(1, 2).log("Range").subscribe(System.out::println);
```
## 9 冷热序列
冷序列的含义是不论订阅者在何时订阅该序列，总是能收到序列中产生的全部消息。热序列是在持续不断的产生消息，订阅者只能获取到在其订阅之后产生的消息。
```java
final Flux<Long> source = Flux.intervalMillis(1000).take(10).publish.autoConnect();
source.subscribe();
Thread.sleep(5000);
source.toStream().forEach(System.out::println);
```


