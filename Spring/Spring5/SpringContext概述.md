## Spring有哪些Context
Spring 里带 “Context” 的类很多，但日常真正会手动 new 出来或配置在 web.xml 里的只有 **6 个**。把它们按“运行环境”和“配置方式”两条轴一摆，就知道该选谁。

---------------------------------
1. 纯 Java SE / 单元测试
---------------------------------
| 实现类 | 特点 | 典型场景 |
|---|---|---|
| **AnnotationConfigApplicationContext** | 注解驱动，零 XML；自动扫描 `@Component`、`@Configuration` | 单元测试、Spring Boot 早期启动器、微服务 jar |
| **GenericApplicationContext** | 完全空壳，需手动 `registerBeanDefinition` 或 `registerBean` | 需要动态编程注册 Bean 的框架二次开发、测试 |
| **GenericXmlApplicationContext** | 只读 XML，不刷新多次 | 快速起一个 XML 配置的原型，极少用 |

---------------------------------
2. Web 环境（Servlet）
---------------------------------
| 实现类 | 特点 | 典型场景 |
|---|---|---|
| **XmlWebApplicationContext** | 传统 web.xml 指定 `contextConfigLocation` 的 XML | 老项目、遗留系统 |
| **AnnotationConfigWebApplicationContext** | 注解驱动，web.xml 里写 `<context-param>` 指向 `@Configuration` 类 | Spring MVC 无 XML 项目、Spring Boot 内嵌容器 |
| **GroovyWebApplicationContext** | 支持 Groovy DSL 脚本 | 极小众，内部脚手架/脚本化部署 |

---------------------------------
3. 响应式 Web（Spring WebFlux）
---------------------------------
| 实现类 | 特点 | 典型场景 |
|---|---|---|
| **ReactiveWebApplicationContext**（接口） | 由 Spring Boot 自动选择 `AnnotationConfigReactiveWebServerApplicationContext` | 响应式 Netty/Undertow 应用 |

---------------------------------
4. 一张决策表（怎么选？）

| 场景 | 推荐 Context |
|---|---|
| 写单元测试 | `AnnotationConfigApplicationContext` |
| 写框架/工具，需要动态注册 Bean | `GenericApplicationContext` |
| 老项目 web.xml 还在用 XML | `XmlWebApplicationContext` |
| Spring MVC 新项目无 XML | `AnnotationConfigWebApplicationContext` |
| Spring Boot 默认 | 由 `SpringApplication.run()` 自动选择：<br>• servlet → `AnnotationConfigServletWebServerApplicationContext`<br>• reactive → `AnnotationConfigReactiveWebServerApplicationContext` |

---------------------------------
一句话记忆  
- **注解驱动**：`AnnotationConfig*ApplicationContext`  
- **XML 驱动**：`Xml*ApplicationContext`  
- **动态注册**：`GenericApplicationContext`  
- **WebFlux**：`Reactive*ApplicationContext`


## SpringContext中有哪些东西

把 Spring 所有 **ApplicationContext**（无论哪种实现）抽象出来，它们都继承同一棵接口树，因此拥有 **一组通用能力** 和 **一批核心托管对象**。背住下面这张“九宫格”，就掌握了 Context 的全部底牌。

──────────────────  
一、通用功能（对外 API）
──────────────────  
1. **IoC 容器**  
   `getBean()` / `getBeansOfType()` / `containsBean()` … 直接面向开发者。  

2. **生命周期管理**  
   `start()` / `stop()` / `refresh()` / `close()`，支持 SmartLifecycle 回调。  

3. **事件广播**  
   `publishEvent()` + `@EventListener`（或 `ApplicationListener`），内部使用 `ApplicationEventMulticaster`。  

4. **国际化（i18n）**  
   `getMessage(code, args, locale)`，底层持有一个 `MessageSource`。  

5. **资源加载**  
   `getResource("classpath:...")`、`getResource("file:...")`，统一协议，底层是 `ResourceLoader`。  

6. **Environment 抽象**  
   `getEnvironment().getProperty(...)`，整合 JVM 参数、系统变量、YAML/Properties、Profile。  

──────────────────  
二、核心托管对象（内部持有的“大管家”）
──────────────────  
| 成员对象 | 接口/类 | 主要能力 |
|---|---|---|
| **ConfigurableEnvironment** | Environment | 统一读取配置、激活 Profile |
| **BeanFactory** | ConfigurableListableBeanFactory | 真正实例化、注入、缓存 Bean |
| **BeanDefinitionRegistry** | 同上 | 注册/删除 BeanDefinition（配方） |
| **ApplicationEventMulticaster** | ApplicationEventMulticaster | 事件广播（同步/异步） |
| **ResourceLoader** | DefaultResourceLoader | 按协议加载文件、URL、类路径资源 |
| **MessageSource** | DelegatingMessageSource | 支持 i18n 文本解析 |
| **ConversionService** | ConversionService | 类型转换（String → Date 等） |
| **PropertyResolver** | PropertySourcesPropertyResolver | 占位符 `${}` 解析 |
| **TypeConverter** | SimpleTypeConverter | 字段/参数级类型转换 |

──────────────────  
三、关系图（一句话）
```
ApplicationContext 门面
        │ 对外暴露“九宫格”功能
        │
        ├─组合→ Environment
        ├─组合→ BeanFactory（Registry）
        ├─组合→ ApplicationEventMulticaster
        ├─组合→ ResourceLoader
        └─组合→ MessageSource
```

因此，无论你在用  
`AnnotationConfigApplicationContext`、`GenericApplicationContext` 还是  
`AnnotationConfigServletWebServerApplicationContext`，它们都 **统一拥有** 上述 6 大通用功能和 9 个核心托管对象，差别只在“**配置来源**”（注解、XML、Groovy、编程式）和“**运行环境**”（独立 JVM、Servlet、Reactive）。