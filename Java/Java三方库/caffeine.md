Caffeine本地缓存详解


## 1 概述

### 简介
Caffeine是一种高性能的缓存库，是基于Java 8的最佳（最优）缓存框架。

基于Google的Guava Cache，Caffeine提供一个性能卓越的本地缓存(local cache) 实现, 也是SpringBoot内置的本地缓存实现。(Caffeine性能是Guava Cache的6倍)

Caffeine提供了灵活的结构来创建缓存，并且有以下特性：

* 自动加载条目到缓存中，可选异步方式
* 可以基于大小剔除
* 可以设置过期时间，时间可以从上次访问或上次写入开始计算
* 异步刷新
* keys自动包装在弱引用中
* values自动包装在弱引用或软引用中
* 条目剔除通知
* 缓存访问统计

### 依赖
引入Maven依赖

```java

        <dependency>
            <groupId>com.github.ben-manes.caffeine</groupId>
            <artifactId>caffeine</artifactId>
            <version>2.9.2</version>
        </dependency>
```

## 2 数据加载

Caffeine提供以下四种类型的加载策略：

### Manual手动
Cache接口可以显式地控制检索、更新和删除Entry


```java
public static void demo(){
		Cache<String,String> cache = Caffeine.newBuilder()
			.expireAfterWrite(20, TimeUnit.SECONDS)
			.maximumSize(5000)
			.build();

		// 1.Insert or update an entry
		cache.put("hello","world");

		// 2. Lookup an entry, or null if not found
		String val1 = cache.getIfPresent("hello");

		// 3. Lookup and compute an entry if absent, or null if not computable
		cache.get("msg", k -> createExpensiveGraph(k));

		// 4. Remove an entry
		cache.invalidate("hello");
	}

	private static String createExpensiveGraph(String key){
		System.out.println("begin to query db..."+Thread.currentThread().getName());
		try {
			Thread.sleep(2000);
		} catch (InterruptedException e) {
		}
		System.out.println("success to query db...");
		return UUID.randomUUID().toString();
	}
```

### Loading自动

```java
private static void demo() {

		LoadingCache<String, String> cache = Caffeine.newBuilder()
			.expireAfterWrite(5, TimeUnit.SECONDS)
			.maximumSize(500)
			.build(new CacheLoader<String, String>() {

				@Override
				public String load(String key) throws Exception {
					return createExpensiveGraph(key);
				}

				@Override
				public Map<String, String>  loadAll(Iterable<? extends String> keys) {
					System.out.println("build keys");
					Map<String,String> map = new HashMap<>();
					for(String k : keys){
						map.put(k,k+"-val");
					}
					return map;
				}
			});

		String val1 = cache.get("hello");
		Map<String,String> values = cache.getAll(Lists.newArrayList("key1", "key2"));

	}

	private static String createExpensiveGraph(String key){
		System.out.println("begin to query db..."+Thread.currentThread().getName());
		try {
			Thread.sleep(2000);
		} catch (InterruptedException e) {
		}
		System.out.println("success to query db...");
		return UUID.randomUUID().toString();
	}
```

LoadingCache通过关联一个CacheLoader来构建Cache, 当缓存未命中会调用CacheLoader的load方法生成V

还可以通过LoadingCache的getAll方法批量查询, 当CacheLoader未实现loadAll方法时, 会批量调用load方法聚合会返回.

当CacheLoader实现loadAll方法时, 则直接调用loadAll返回.

```java
public interface CacheLoader<K, V>{
  
    V load(@NonNull K var1) throws Exception;
  
    Map<K, V> loadAll(@NonNull Iterable<? extends K> keys);
}
```

### Asynchronous Manual异步手动
AsyncCache是另一种Cache，它基于Executor计算Entry，并返回一个CompletableFuture

和Cache的区别是, AsyncCache计算Entry的线程是ForkJoinPool线程池. 手动Cache缓存是调用线程进行计算


```java
private static void demo() throws ExecutionException, InterruptedException {
		AsyncCache<String,String> cache = Caffeine.newBuilder()
			.maximumSize(500)
			.expireAfterWrite(10, TimeUnit.SECONDS)
			.buildAsync();

		// Lookup and asynchronously compute an entry if absent
		CompletableFuture<String> future = cache.get("hello", k -> createExpensiveGraph(k));
		System.out.println(future.get());
	}

	private static String createExpensiveGraph(String key){
		System.out.println("begin to query db..."+Thread.currentThread().getName());
		try {
			Thread.sleep(2000);
		} catch (InterruptedException e) {
		}
		System.out.println("success to query db...");
		return UUID.randomUUID().toString();
	}
```

### Asynchronously Loading异步自动
AsyncLoadingCache 是关联了 AsyncCacheLoader 的 AsyncCache



```java
public static void demo() throws ExecutionException, InterruptedException {
		AsyncLoadingCache<String,String> cache = Caffeine.newBuilder()
			.expireAfterWrite(10, TimeUnit.SECONDS)
			.maximumSize(500)
			.buildAsync(k -> createExpensiveGraph(k));
		CompletableFuture<String> future = cache.get("hello");
		System.out.println(future.get());
	}

	private static String createExpensiveGraph(String key){
		System.out.println("begin to query db..."+Thread.currentThread().getName());
		try {
			Thread.sleep(2000);
		} catch (InterruptedException e) {
		}
		System.out.println("success to query db...");
		return UUID.randomUUID().toString();
	}
```


## 3 数据驱逐

Caffeine提供以下几种剔除方式：基于大小、基于权重、基于时间、基于引用

### 1. 基于容量
又包含两种, 基于size和基于weight权重

* 基于size
  * 如果缓存的条目数量不应该超过某个值，那么可以使用Caffeine.maximumSize(long)。如果超过这个值，则会剔除很久没有被访问过或者不经常使用的那个条目。
  * 上述测试并不是i=500时, 而是稍微延迟于i的增加, 说明驱逐是另外一个线程异步进行的

```
LoadingCache<String,String> cache = Caffeine.newBuilder()
			.maximumSize(500)
			.recordStats()
			.build( k -> UUID.randomUUID().toString());

		for (int i = 0; i < 600; i++) {
			cache.get(String.valueOf(i));
			if(i> 500){
				CacheStats stats = cache.stats();
				System.out.println("evictionCount:"+stats.evictionCount());
				System.out.println("stats:"+stats.toString());
			}
		}
```

* 基于权重
  * 如果，不同的条目有不同的权重值的话(不同的实例占用空间大小不一样)，那么你可以用Caffeine.weigher(Weigher)来指定一个权重函数，并且使用Caffeine.maximumWeight(long)来设定最大的权重值。
  * 上述测试并不是i=200时, 而是稍微延迟于i的增加, 说明驱逐是另外一个线程异步进行的
  * 简单的来说，要么限制缓存条目的数量，要么限制缓存条目的权重值，二者取其一。
```java
LoadingCache<Integer,String> cache = Caffeine.newBuilder()
			.maximumWeight(300)
			.recordStats()
			.weigher((Weigher<Integer, String>) (key, value) -> {
				if(key % 2 == 0){
					return 2;
				}
				return 1;
			})
			.build( k -> UUID.randomUUID().toString());

		for (int i = 0; i < 300; i++) {
			cache.get(i);
			if(i> 200){
				System.out.println(cache.stats().toString());
			}
		}
```



### 2. 基于时间
基于时间又分为四种: expireAfterAccess、expireAfterWrite、refreshAfterWrite、expireAfter

#### expireAfterAccess
超时未访问则失效: 访问包括读和写
```java
	private static LoadingCache<String,String> cache = Caffeine.newBuilder()
		.expireAfterAccess(1, TimeUnit.SECONDS)
		.build(key -> UUID.randomUUID().toString());
```
特征:

* 访问包括读和写入
* 数据失效后不会主动重新加载, 必须依赖下一次访问. (言外之意: 失效和回源是两个动作)
* key超时失效或不存在，若多个线程并发访问, 只有1个线程回源数据，其他线程阻塞等待数据返回
* 对同一数据一直访问, 且间隔小于失效时间, 则不会去load数据, 一直读到的是脏数据

#### expireAfterWrite
写后超时失效
```java
	private static LoadingCache<String,String> cache = Caffeine.newBuilder()
		.expireAfterWrite(1, TimeUnit.SECONDS)
		.build(key -> UUID.randomUUID().toString());
```
特征:

* 数据失效后不会主动重新加载, 必须依赖下一次访问. (言外之意: 失效和回源是两个动作)
* key超时失效或不存在，若多个线程并发访问, 只有1个线程回源数据，其他线程阻塞等待数据返回
* expire后来访问一定能保证拿到最新的数据

#### refreshAfterWrite
```java
	private static LoadingCache<String,String> cache = Caffeine.newBuilder()
		.refreshAfterWrite(1, TimeUnit.SECONDS)
		.build(key -> UUID.randomUUID().toString());
```
和expireAfterWrite类似基于写后超时驱逐, 区别是重新load的操作不一样.

特征:

* 数据失效后不会主动重新加载, 必须依赖下一次访问. (言外之意: 失效和回源是两个动作)
* 当cache命中未命中时, 若多个线程并发访问时, 只有1个线程回源数据，其他线程阻塞等待数据返回
* 当cache命中失效数据时, 若多个线程并发访问时, 第一个访问的线程提交一个load数据的任务到公共线程池，然后和所有其他访问线程一样直接返回旧值
* 实际通过LoadingCache.refresh(K)进行异步刷新, 如果想覆盖默认的刷新行为, 可以实现CacheLoader.reload(K, V)方法


#### expireAfter
比较少用
```java
public static void demo(){

		MyTicker ticker = new MyTicker();

		LoadingCache<String,String> cache = Caffeine.newBuilder()
			.maximumSize(500)
			.ticker(ticker)
			//此时的效果为expireAfterWrite(5,TimeUnit.SECONDS)
			.expireAfter(new Expiry<String, String>() {
				//1.如果写入key时是第一次创建，则调用该方法返回key剩余的超时时间, 单位纳秒ns
				//currentTime为当前put时Ticket的时间，单位ns
				@Override
				public long expireAfterCreate(String key,String value, long currentTime) {
					System.out.println("write first currentTime:"+currentTime/1_000_000_000L);
					return 5_000_000_000L;//5s
				}
				//2.如果写入key时已经存在即更新key时，则调用该方法返回key剩余的超时时间, 单位纳秒ns
				//currentTime为当前put时Ticket的时间，单位ns，durationTime为旧值(上次设置)剩余的存活时间，单位是ns
				@Override
				public long expireAfterUpdate(String key,String value, long currentTime,long durationTime) {
					System.out.println("update currentTime:"+currentTime/1_000_000_000L+",leftTime:"+durationTime/1_000_000_000L);
					return 5_000_000_000L;//5s
				}
				//3.如果key被访问时,则调用该方法返回key剩余的超时时间, 单位纳秒ns
				//currentTime为read时Ticket的时间，单位ns，durationTime为旧值(上次设置)剩余的存活时间，单位是ns
				@Override
				public long expireAfterRead(String key,String value, long currentTime,long durationTime) {
					System.out.println("read currentTime:"+currentTime/1_000_000_000L+",leftTime:"+durationTime/1_000_000_000L);
					return durationTime;
				}
			})
			.build(k ->  UUID.randomUUID().toString());

		cache.get("key1");//触发expireAfterCreate
		ticker.advance(1, TimeUnit.SECONDS);//模拟时间消逝
		cache.get("key1");//触发expireAfterRead,剩余生存时间4s
		ticker.advance(2, TimeUnit.SECONDS);//模拟时间消逝
		cache.put("key1","value1");//触发expireAfterUpdate,重置生存时间为5s
		ticker.advance(3, TimeUnit.SECONDS);//模拟时间消逝
		cache.get("key1");//触发expireAfterCreate,剩余生存时间为2s

	}

public class MyTicker implements Ticker {
	private final AtomicLong nanos = new AtomicLong();
	//模拟时间消逝
	public void advance(long time, TimeUnit unit) {
		this.nanos.getAndAdd(unit.toNanos(time));
	}
	@Override
	public long read() {
		return this.nanos.get();
	}
}
```
上述实现了Expiry接口, 分别重写了expireAfterCreate、expireAfterUpdate、expireAfterRead方法, 当第一次写入时、更新时、读访问时会分别调用这三个方法有机会重新设置剩余的失效时间, 上述案例模拟了expireAfterWrite(5,TimeUnit.SECONDS)的效果.


注意点:

* 以上基于时间驱逐, 数据超时失效和回源是两个动作, 必须依赖下一次访问. 为了避免服务启动时大量缓存穿透, 可以通过提前项目启动时手动预热
* 一般expireAfterWrite和refreshAfterWrite结合使用, expire的时间t1大于refresh的时间t2, 在t2~t1内数据更新允许脏数据, t1之后必须要重新同步加载新数据

### 3. 基于弱/软引用
```java
/**
	 * 允许GC时回收keys或values
	 */
	public static void demo(){
		LoadingCache<String,String> cache = Caffeine.newBuilder()
			.maximumSize(500)
			.expireAfterWrite(10, TimeUnit.SECONDS)
			.weakKeys()
			.weakValues()
			.build(k -> UUID.randomUUID().toString());

	}
```
* Caffeine.weakKeys() 使用弱引用存储key。如果没有强引用这个key，则GC时允许回收该条目

* Caffeine.weakValues() 使用弱引用存储value。如果没有强引用这个value，则GC时允许回收该条目

* Caffeine.softValues() 使用软引用存储value, 如果没有强引用这个value，则GC内存不足时允许回收该条目
```java
public static void demo(){
		/**
		 * 使用软引用存储value,GC内存不够时会回收
		 */
		LoadingCache<String,String> cache = Caffeine.newBuilder()
			.maximumSize(500)
			.expireAfterWrite(10, TimeUnit.SECONDS)
			.softValues()//注意没有softKeys方法
			.build(k -> UUID.randomUUID().toString());
	}
```
### 总结
Java4种引用的级别由高到低依次为：强引用 > 软引用 > 弱引用 > 虚引用

| 引用类型 | 被垃圾回收时间 | 用途      | 生存时间       |
|------|---------|---------|------------|
| 强引用  | 从来不会    | 对象的一般状态 | JVM停止运行时终止 |
| 软引用  | 在内存不足时  | 对象缓存    | 内存不足时终止    |
| 弱引用  | 在垃圾回收时  | 对象缓存    | gc运行后终止    |
| 虚引用  | Unknown | Unknown | Unknown    |


## 4 驱逐监听

* eviction 指受策略影响而被删除
* invalidation 值被调用者手动删除
* removal 值因eviction或invalidation而发生的一种行为

### 手动触发删除
```java
// individual key
cache.invalidate(key)
// bulk keys
cache.invalidateAll(keys)
// all keys
cache.invalidateAll()
```

### 被驱逐的原因
```java
EXPLICIT：如果原因是这个，那么意味着数据被我们手动的remove掉了
REPLACED：就是替换了，也就是put数据的时候旧的数据被覆盖导致的移除
COLLECTED：这个有歧义点，其实就是收集，也就是垃圾回收导致的，一般是用弱引用或者软引用会导致这个情况
EXPIRED：数据过期，无需解释的原因。
SIZE：个数超过限制导致的移除
```

### 监听器
```java
public static void demo(){
		LoadingCache<String,String> cache = Caffeine.newBuilder()
			.maximumSize(5)
			.recordStats()
			.expireAfterWrite(2, TimeUnit.SECONDS)
			.removalListener((String key, String value, RemovalCause cause) -> {
				System.out.printf("Key %s was removed (%s)%n", key, cause);
			})
			.build(key -> UUID.randomUUID().toString());
		for (int i = 0; i < 15; i++) {
			cache.get(i+"");
			try {
				Thread.sleep(200);
			} catch (InterruptedException e) {
			}
		}

		//因为evict是异步线程去执行，为了看到效果稍微停顿一下
		try {
			Thread.sleep(2000);
		} catch (InterruptedException e) {
		}
	}
```

```log
Key 0 was removed (SIZE)
Key 1 was removed (SIZE)
Key 6 was removed (SIZE)
Key 7 was removed (SIZE)
Key 8 was removed (SIZE)
Key 9 was removed (SIZE)
Key 10 was removed (SIZE)
Key 2 was removed (EXPIRED)
Key 3 was removed (EXPIRED)
Key 4 was removed (EXPIRED)
```

## 5 统计
```java
public static void demo(){
		LoadingCache<Integer,String> cache = Caffeine.newBuilder()
			.maximumSize(10)
			.expireAfterWrite(10, TimeUnit.SECONDS)
			.recordStats()
			.build(key -> {
				if(key % 6 == 0 ){
					return null;
				}
				return  UUID.randomUUID().toString();
			});

		for (int i = 0; i < 20; i++) {
			cache.get(i);
			printStats(cache.stats());
		}
		for (int i = 0; i < 10; i++) {
			cache.get(i);
			printStats(cache.stats());
		}
	}

	private static void printStats(CacheStats stats){
		System.out.println("---------------------");
		System.out.println("stats.hitCount():"+stats.hitCount());//命中次数
		System.out.println("stats.hitRate():"+stats.hitRate());//缓存命中率
		System.out.println("stats.missCount():"+stats.missCount());//未命中次数
		System.out.println("stats.missRate():"+stats.missRate());//未命中率
		System.out.println("stats.loadSuccessCount():"+stats.loadSuccessCount());//加载成功的次数
		System.out.println("stats.loadFailureCount():"+stats.loadFailureCount());//加载失败的次数,返回null
		System.out.println("stats.loadFailureRate():"+stats.loadFailureRate());//加载失败的百分比
		System.out.println("stats.totalLoadTime():"+stats.totalLoadTime());//总加载时间,单位ns
		System.out.println("stats.evictionCount():"+stats.evictionCount());//驱逐次数
		System.out.println("stats.evictionWeight():"+stats.evictionWeight());//驱逐的weight值总和
		System.out.println("stats.requestCount():"+stats.requestCount());//请求次数
		System.out.println("stats.averageLoadPenalty():"+stats.averageLoadPenalty());//单次load平均耗时
	}
```


## 6 其他

### Ticker
时钟, 方便测试模拟时间流逝
```java
public static void demo(){

		MyTicker ticker = new MyTicker();

		LoadingCache<String,String> cache = Caffeine.newBuilder()
			.maximumSize(500)
			.ticker(ticker)
			.expireAfterWrite(1, TimeUnit.SECONDS)
			.build(k ->  UUID.randomUUID().toString());

		cache.get("key1");//触发expireAfterCreate
		ticker.advance(1, TimeUnit.SECONDS);//模拟时间消逝
		cache.get("key1");//触发expireAfterRead,剩余生存时间4s
		ticker.advance(2, TimeUnit.SECONDS);//模拟时间消逝
		cache.put("key1","value1");//触发expireAfterUpdate,重置生存时间为5s
	}

public class MyTicker implements Ticker {
	private final AtomicLong nanos = new AtomicLong();
	//模拟时间消逝
	public void advance(long time, TimeUnit unit) {
		this.nanos.getAndAdd(unit.toNanos(time));
	}
	@Override
	public long read() {
		return this.nanos.get();
	}
}
```


## 7 缓存常见问题处理

### 缓存穿透——不存在的key

尝试返回一个空对象。


### 缓存击穿——大量线程同时访问同一个Key
* 在一个key失效的瞬间有大量访问进入。
  * 多线程单一key互斥（该包已经实现。）
  * 如果对 get(K) 的另一个调用当前正在加载键的值，则该线程只是等待该线程完成并返回其加载的值。 请注意，多个线程可以同时加载不同键的值。
  * 如果指定的键尚未与值关联，则尝试计算其值并将其输入此缓存，除非为空。 整个方法调用是原子执行的，因此每个键最多应用一次函数。 当计算正在进行时，其他线程对此缓存的一些尝试更新操作可能会被阻塞，因此计算应该简短，并且不得尝试更新此缓存的任何其他映射。

* 在一开始的时候，该key还没有加入有大量key同时访问
  * 缓存预热。

```java
    @PostConstruct
    private void preLoading(){
        List<InstanceMetaDO> instanceMetaDOS = instanceMetaDAO.findByQuery();
        int nums = 0;
        for(InstanceMetaDO metaDO:instanceMetaDOS){
            if(StringUtils.isNotEmpty(metaDO.getInstanceId())){
                nums++;
                if(StringUtils.isNotEmpty(metaDO.getWorkspaceId())){
                    workspaceIdCache.put(metaDO.getInstanceId(),metaDO.getWorkspaceId());
                }
                if(StringUtils.isNotEmpty(metaDO.getInstanceId())){
                    tenantIdCache.put(metaDO.getInstanceId(),metaDO.getTenantId());
                }
            }
        }
        log.info("[InstanceMetaCacheService] preload count:{}",nums);
    }
```


### 缓存雪崩——大量key同时失效

