# 1. 什么是Vuex

**Vuex**是一个专为**Vue.js**应用程序开发的状态管理模式。它采用集中式存储管理应用的所有组件的状态，并以相应的规则保证状态以一种可预测的方式发生变化。

其实最简单理解为，在我们写Vue组件中，一个页面多个组件之间想要通信数据，那你可以使用**Vuex**

- Vuex 是一个专为 Vue.js 应用程序开发的状态管理模式
- Vuex状态管理 === 管理组件数据流动 === 全局数据管理
- Vue的全局数据池，在这里它存放着大量的复用或者公有的数据，然后可以分发给组件
- Vue双向数据绑定的MV框架，数据驱动(区别节点驱动)，模块化和组件化，所以管理各组件和模块之间数据的流向至关重要
- Vuex是一个前端非持久化的数据库中心，Vuex其实是Vue的重要选配，一般小型不怎么用，大型项目运用比较多，所以页面刷新，Vuex数据池会重置
- 

> 路由-》管理的是组件流动

> Vuex-》管理的是数据流动

没有`Vuex`之前，组件数据来源

- ajax请求后端
- 组件自身定义默认数据
- 继承其他组件的数据
- (从vuex拿)

## 1.1 使用场景

- **多个视图使用于同一状态**

```
传参的方法对于多层嵌套的组件将会非常繁琐，并且对于兄弟组件间的状态传递无能为力
```

- **不同视图需要变更同一状态**：

```
采用父子组件直接引用或者通过事件来变更和同步状态的多份拷贝，通常会导致无法维护的代码
```

## 1.2 数据流层

![](https://gitee.com/krislin_zhao/IMGcloud/raw/master/img/20200520091346.png)

### 注意事项

1. 数据流都是单向的 
2.  组件能够调用action 
3.  action用来派发mutation 
4.  只有mutation可以改变状态 
5.  store是响应式的，无论state什么时候更新，组件都将同步更新

# 2. 核心概念



## 2.1 state

Vuex 使用单一状态树，用一个对象就包含了全部的应用层次状态。至此它便作为一个唯一的数据源而存在。这也意味着，每个应用将仅仅包含一个store实例。

单状态树让我们能够直接地定位任一特定的状态片段，在调试的过程中也能轻易地取得整个当前应用状态的快照。

### 2.1.1 在 Vue 组件中获得 Vuex 状态

由于 Vuex 的状态存储是响应式的，从 store 实例中读取状态最简单的方法就是在计算属性中返回某个状态：

```javascript
// 创建一个 Counter 组件
const Counter = {
  template: `<div>{{ count }}</div>`,
  computed: {
    count () {
      return store.state.count
    }
  }
}

//每当 store.state.count 变化的时候, 都会重新求取计算属性，并且触发更新相关联的 DOM。
```

Vuex 通过 `store` 选项，提供了一种机制将状态从根组件“注入”到每一个子组件中（需调用 Vue.use(Vuex)）：

```javascript
const app = new Vue({
  el: '#app',
  // 把 store 对象提供给 “store” 选项，这可以把 store 的实例注入所有的子组件
  store,
  components: { Counter },
  template: `
    <div class="app">
      <counter></counter>
    </div>
  `
})
```

通过在根实例中注册 store 选项，该 store 实例会注入到根组件下的所有子组件中，且子组件能通过 this.$store 访问到。让我们更新下 Counter 组件 的实现：

```javascript
const Counter = {
  template: `<div>{{ count }}</div>`,
  computed: {
    count () {
      return this.$store.state.count
    }
  }
}
```

### 2.1.2 mapState 辅助函数

当一个组件需要获取多个状态时，将这些状态都声明为计算属性会有些重复和冗余。为了解决这个问题，我们可以使用 mapState 辅助函数帮助我们生成计算属性，让你少按几次键：

```javascript
// 在单独构建的版本中辅助函数为 Vuex.mapState
import { mapState } from 'vuex'

export default {
  // ...
  computed: mapState({
    // 箭头函数可使代码更简练
    count: state => state.count,

    // 传字符串参数 'count' 等同于 `state => state.count`
    countAlias: 'count',

    // 为了能够使用 `this` 获取局部状态，必须使用常规函数
    countPlusLocalState (state) {
      return state.count + this.localCount
    }
  })
}
```

当映射的计算属性的名称与 state 的子节点名称相同时，我们也可以给 mapState 传一个字符串数组。

```javascript
computed: mapState([
  // 映射 this.count 为 store.state.count
  'count'
])
```

由于 `mapState` 函数返回的是一个对象，在ES6的写法中，我们可以通过对象展开运算符，可以极大的简化写法:

```javascript
computed: {
  localComputed () { /* ... */ },
  // 使用对象展开运算符将此对象混入到外部对象中
  ...mapState({
    // ...
  })
}

//相当于将 state的属性，都添加到computed，而且指向state中的数据
```

## 2.2 Getter

用来从store获取Vue组件数据，类似于computed。

**Getter 接受 state 作为其第一个参数：**

```javascript
const store = new Vuex.Store({
  state: {
    todos: [
      { id: 1, text: '...', done: true },
      { id: 2, text: '...', done: false }
    ]
  },
  getters: {
    doneTodos: state => {
      return state.todos.filter(todo => todo.done)
    }
  }
})
```

### 2.2.1 通过属性访问

Getter 会暴露为 store.getters 对象，你可以以属性的形式访问这些值：

```javascript
store.getters.doneTodos // -> [{ id: 1, text: '...', done: true }]
```

Getter 也可以接受其他 getter 作为第二个参数：

```javascript
getters: {
  // ...
  doneTodosCount: (state, getters) => {
    return getters.doneTodos.length
  }
}
```

在其他组件中使用getter:

```javascript
computed: {
  doneTodosCount () {
    return this.$store.getters.doneTodosCount
  }
}
```

> 注意: getter 在通过属性访问时是作为 Vue 的响应式系统的一部分缓存其中的。

### 2.2.2 通过方法访问

你也可以通过让 getter 返回一个函数，来实现给 getter 传参。在你对 store 里的数组进行查询时非常有用。

```javascript
getters: {
  // ...
  getTodoById: (state) => (id) => {
    return state.todos.find(todo => todo.id === id)
  }
}


store.getters.getTodoById(2) // -> { id: 2, text: '...', done: false }
```

> 注意: getter 在通过方法访问时，每次都会去进行调用，而不会缓存结果。

### 2.2.3 mapGetters 辅助函数

`mapGetters` 辅助函数仅仅是将 store 中的 getter 映射到局部计算属性：

```javascript
import { mapGetters } from 'vuex'

export default {
  // ...
  computed: {
  // 使用对象展开运算符将 getter 混入 computed 对象中
    ...mapGetters([
      'doneTodosCount',
      'anotherGetter',
      // ...
    ])
  }
}
```

如果你想将一个 getter 属性另取一个名字，使用对象形式：

```javascript
mapGetters({
  // 把 `this.doneCount` 映射为 `this.$store.getters.doneTodosCount`
  doneCount: 'doneTodosCount'
})
```

## 2.3 Mutation

事件处理器用来驱动状态的变化，类似于methods，同步操作。

**更改 Vuex 的 store 中的状态的唯一方法是提交 mutation。**

每个 mutation 都有一个字符串的 事件类型 (type) 和 一个 回调函数 (handler)。这个回调函数就是我们实际进行状态更改的地方，并且它会接受 state 作为第一个参数：

```javascript
const store = new Vuex.Store({
  state: {
    count: 1
  },
  mutations: {
    increment (state,value) { 
      // 变更状态
      state.count++
    }
  }
})
```

当外界需要通过mutation的handler 来修改state的数据时，不能直接调用 mutation的handler，而是要通过 `commit` 方法 传入类型。

`store.mutations.increment`,这种方式是错误的，必须使用 `store.commit('increment',value)` ,value可作为要传递进入store的数据

### 2.3.1 提交载荷（Payload）

你可以向 `store.commit` 传入额外的参数，即 mutation 的 载荷（payload）：

```javascript
// ...
mutations: {
  increment (state, value) {
  //第一个参数是state,value可以作为传递进来数据的参数
    state.count += value
  }
}
```

使用方式：

```javascript
store.commit('increment', 10)
```

在大多数情况下，载荷应该是一个对象，这样可以包含多个字段并且记录的 mutation 会更易读：

```javascript
...
mutations: {
  increment (state, payload) {
    state.count += payload.amount
  }
}
```

```javascript
// 以载荷形式分发
store.commit('increment', {
  amount: 10
})
```

### 2.3.2 对象风格的提交方式

提交 mutation 的另一种方式是直接使用包含 type 属性的对象：

```javascript
// 以对象形式分发
store.commit({
  type: 'increment',
  amount: 10
})
```

当使用对象风格的提交方式，整个对象都作为载荷传给 mutation 函数，因此 handler 保持不变：

```javascript
mutations: {
  increment (state, payload) {
    state.count += payload.amount
  }
}
```

### 2.3.3 Mutation 需遵守 Vue 的响应规则

既然 Vuex 的 `store` 中的状态是响应式的，那么当我们变更状态时，监视状态的 Vue 组件也会自动更新。	

1. 最好提前在你的 store 中初始化好所有所需属性

2. 使用 Vue.set(obj, 'newProp', 123)

3. 以新对象替换老对象。例如，利用对象展开运算符我们可以这样写：state.obj = { ...state.obj, newProp: 123 }


### 2.3.4 使用常量替代 Mutation 事件类型

1. 新建 `mutation-types.js` 文件，定义常量来管理 `mutation` 中的类型:

```javascript
// mutation-types.js
export const SOME_MUTATION = 'SOME_MUTATION'
```

或者直接导出对象

```javascript
export default  {
  SOME_MUTATION:'SOME_MUTATION'

}
```

2. 在 `store.js` 中引入 `mutation-types.js`，引入类型常量使用

```javascript
// store.js
import Vuex from 'vuex'
import { SOME_MUTATION } from './mutation-types'

const store = new Vuex.Store({
  state: { ... },
  mutations: {
    // 我们可以使用 ES2015 风格的计算属性命名功能来使用一个常量作为函数名
    [SOME_MUTATION] (state) {
      // mutate state
    }
  }
})
```

**引入类型对象使用:**

```javascript
...
import  MutationType from './mutation-type'
 mutations: {
    // 我们可以使用 ES2015 风格的计算属性命名功能来使用一个常量作为函数名
    [MutationType.SOME_MUTATION] (state) {
      // mutate state
    }
  }
```

3. 在外部使用时，需要局部先引入或者在`main.js`全局引入`mutation-types.js`:

```javascript
import  MutationType from './mutation-type'

this.$store.commit(MutationType.SOME_MUTATION,'传入内容')
```

### 2.3.5 Mutation 必须是同步函数

```javascript
mutations: {
  someMutation (state) {
    api.callAsyncMethod(() => {
      state.count++
    })
  }
}
```

假设现在正在debug 一个 app 并且观察 devtool中的mutation日志。 每一条 mutation 被记录，devtools 都需要捕捉到前一状态和后一状态的快照。 然而，在上面的例子中 mutation 中的异步函数中的回调让这不可能完成：

> 因为当 mutation 触发的时候，回调函数还没有被调用，devtools 不知道什么时候回调函数实际上被调用——实质上任何在回调函数中进行的状态的改变都是不可追踪的。

### 2.3.6 在组件中提交 Mutation

你可以在组件中使用 `this.$store.commit('xxx')` 提交 mutation，或者使用 `mapMutations` 辅助函数将组件中的 methods 映射为 `store.commit` 调用（需要在根节点注入 `store`）。

方式一:

```javas
  this.$store.commit('increment','参数')
```

方式二:

```javascript
import { mapMutations } from 'vuex'

export default {
  // ...
  methods: {
    ...mapMutations([
      'increment', // 将 `this.increment()` 映射为 `this.$store.commit('increment')`

      // `mapMutations` 也支持载荷：
      'incrementBy' // 将 `this.incrementBy(amount)` 映射为 `this.$store.commit('incrementBy', amount)`
    ]),
    ...mapMutations({
      add: 'increment' // 将 `this.add()` 映射为 `this.$store.commit('increment')`
    })
  }
}
```

## 2.4 Action

可以给组件使用的函数，以此用来驱动事件处理器 mutations，异步操作。

**Action 类似于 mutation，不同在于：**

1. Action 提交的是 mutation，而不是直接变更状态。
2. Action 可以包含任意异步操作。

例子:

```javascript
const store = new Vuex.Store({
  state: {
    count: 0
  },
  mutations: {
    increment (state) {
      state.count++
    }
  },
  actions: {
    increment (context) {  //context 执行的上下文，作为第一个参数
      context.commit('increment')
    }
  }
})
```

Action 函数接受一个与 store 实例具有相同方法和属性的 context 对象，因此你可以调用 `context.commit` 提交一个 mutation，或者通过 `context.state` 和 `context.getters` 来获取 state 和 getters。

需要调用 commit 很多次的时候,可以简写成:

```javascript
actions: {
  increment ({ commit }) {
    commit('increment')
  }
}
```

### 2.4.1 分发 Action

Action 通过 `store.dispatch` 方法触发：

```javascript
store.dispatch('increment')
```

Action 就不受约束！在Mutation无法执行的异步操作，可以在action内部进行使用:

```javascript
actions: {
  incrementAsync ({ commit }) {
    setTimeout(() => {
      commit('increment')
    }, 1000)
  }
}
```

**Actions 支持同样的载荷方式和对象方式进行分发：**

```javascript
// 以载荷形式分发
store.dispatch('incrementAsync', {
  amount: 10
})

// 以对象形式分发
store.dispatch({
  type: 'incrementAsync',
  amount: 10
})
```

**调用异步 API 和分发多重 mutation：**

```javascript
actions: {
  checkout ({ commit, state }, products) {
    // 把当前购物车的物品备份起来
    const savedCartItems = [...state.cart.added]
    // 发出结账请求，然后乐观地清空购物车
    commit(types.CHECKOUT_REQUEST)
    // 购物 API 接受一个成功回调和一个失败回调
    shop.buyProducts(
      products,
      // 成功操作
      () => commit(types.CHECKOUT_SUCCESS),
      // 失败操作
      () => commit(types.CHECKOUT_FAILURE, savedCartItems)
    )
  }
}
```

### 2.4.2 在组件中分发 Action

你在组件中使用 `this.$store.dispatch('xxx')` 分发 action，或者使用 `mapActions` 辅助函数将组件的 methods 映射为 `store.dispatch` 调用（需要先在根节点注入 `store`）：

```javascript
import { mapActions } from 'vuex'

export default {
  // ...
  methods: {
    ...mapActions([
      'increment', // 将 `this.increment()` 映射为 `this.$store.dispatch('increment')`

      // `mapActions` 也支持载荷：
      'incrementBy' // 将 `this.incrementBy(amount)` 映射为 `this.$store.dispatch('incrementBy', amount)`
    ]),
    ...mapActions({
      add: 'increment' // 将 `this.add()` 映射为 `this.$store.dispatch('increment')`
    })
  }
}
```

### 2.4.3 组合 Action

> Action 通常是异步的，那么如何知道 action 什么时候结束呢？更重要的是，我们如何才能组合多个 action，以处理更加复杂的异步流程？

首先，你需要明白 `store.dispatch` 可以处理被触发的 `action` 的处理函数返回的 `Promise`，并且 `store.dispatch` 仍旧返回 `Promise`：

```javascript
actions: {
  actionA ({ commit }) {
    return new Promise((resolve, reject) => {
      setTimeout(() => {
        commit('someMutation')
        resolve()
      }, 1000)
    })
  }
}
```

现在可以直接使用:

```javascript
store.dispatch('actionA').then(() => {
  // ...
})
```

在另外一个 action 中也可以：

```javascript
actions: {
  // ...
  actionB ({ dispatch, commit }) {
    return dispatch('actionA').then(() => {
      commit('someOtherMutation')
    })
  }
}
```

最后，如果我们利用 `async / await`，我们可以如下组合 action：

```javascript
// 假设 getData() 和 getOtherData() 返回的是 Promise

actions: {
  async actionA ({ commit }) {
    commit('gotData', await getData())
  },
  async actionB ({ dispatch, commit }) {
    await dispatch('actionA') // 等待 actionA 完成
    commit('gotOtherData', await getOtherData())
  }
}
```

> 一个 `store.dispatch` 在不同模块中可以触发多个 action 函数。在这种情况下，只有当所有触发函数完成后，返回的 Promise 才会执行。

## 2.5 Module

由于使用单一状态树，应用的所有状态会集中到一个比较大的对象。当应用变得非常复杂时，store 对象就有可能变得相当臃肿。

为了解决以上问题，Vuex 允许我们将 store 分割成模块（module)。每个模块拥有自己的 state、mutation、action、getter、甚至是嵌套子模块——从上至下进行同样方式的分割：

```javascript
const moduleA = {
  state: { ... },
  mutations: { ... },
  actions: { ... },
  getters: { ... }
}

const moduleB = {
  state: { ... },
  mutations: { ... },
  actions: { ... }
}

const store = new Vuex.Store({
  modules: {
    a: moduleA,
    b: moduleB
  }
})

store.state.a // -> moduleA 的状态
store.state.b // -> moduleB 的状态

假设模块A state 中 有 ‘city’，在外界访问时，则用 store.state.a.city
```

### 2.5.1 模块的局部状态

对于模块内部的 mutation 和 getter，接收的第一个参数是**模块的局部状态对象。**

```javascript
const moduleA = {
  state: { count: 0 },
  mutations: {
    increment (state) {
      // 这里的 `state` 对象是模块的局部状态
      state.count++
    }
  },

  getters: {
    doubleCount (state) {
      return state.count * 2
    }
  }
}
```

同样，对于模块内部的 `action`，局部状态通过 `context.state` 暴露出来，根节点状态则为 `context.rootState`：

```javascript
const moduleA = {
  // ...
  actions: {
    incrementIfOddOnRootSum ({ state, commit, rootState }) {
      if ((state.count + rootState.count) % 2 === 1) {
        commit('increment')
      }
    }
  }
}
```

对于模块内部的 getter，根节点状态会作为第三个参数暴露出来：

```javascript
const moduleA = {
  // ...
  getters: {
    sumWithRootCount (state, getters, rootState) {
      return state.count + rootState.count
    }
  }
}
```

### 2.5.2 命名空间

默认情况下，模块内部的 action、mutation 和 getter 是注册在**全局命名空间**的——这样使得多个模块能够对同一 mutation 或 action 作出响应。

1. 如果希望你的模块具有更高的封装度和复用性，你可以通过添加 namespaced: true 的方式使其成为带命名空间的模块。
2. 当模块被注册后，它的所有 getter、action 及 mutation 都会自动根据模块注册的路径调整命名。

例如：

```javascript
const store = new Vuex.Store({
  modules: {
    account: {
      namespaced: true,

      // 模块内容（module assets）
      state: { ... }, // 模块内的状态已经是嵌套的了，使用 `namespaced` 属性不会对其产生影响
      getters: {
        isAdmin () { ... } // -> getters['account/isAdmin']
      },
      actions: {
        login () { ... } // -> dispatch('account/login')
      },
      mutations: {
        login () { ... } // -> commit('account/login')
      },

      // 嵌套模块
      modules: {
        // 继承父模块的命名空间
        myPage: {
          state: { ... },
          getters: {
            profile () { ... } // -> getters['account/profile']
          }
        },

        // 进一步嵌套命名空间
        posts: {
          namespaced: true,

          state: { ... },
          getters: {
            popular () { ... } // -> getters['account/posts/popular']
          }
        }
      }
    }
  }
})
```

启用了命名空间的 getter 和 action 会收到局部化的 `getter`，`dispatch` 和 `commit`。换言之，你在使用模块内容（module assets）时不需要在同一模块内额外添加空间名前缀。更改 `namespaced`属性后不需要修改模块内的代码。

# 3. `Vuex`项目开发中常见的文件布局

## 3.1 项目结构

![](https://gitee.com/krislin_zhao/IMGcloud/raw/master/img/20200520125609.png)

## 3.2 文件的说明

1、一般会在vue的项目下src文件中创建一个store存放项目中使用的vuex相关的文件
2、 actions存放全部的异步的或者多个mutations的方法
3、getters存放全部的getter方法
4、index对外暴露的文件
5、mutations-type存放一些常量
6、mutations存放全部修改state的方法
7、state项目中全部的状态

# 4. Vuex的简单案例

## 4.1 目录结构

![](https://gitee.com/krislin_zhao/IMGcloud/raw/master/img/20200521115616.png)

## 4.2 新建store存储于vuex相关

### 4.2.1 state.js

```javascript
/**
 * 定义项目中state状态的文件
 */
const state = {
  count: 0,
  show: ''
};

export default state
```

### 4.2.2 getters.js

```javascript
/**
 * 定义项目中的getters,这个里面设置的是获取store中的状态
 * 其实都是些函数,从state状态中返回数据,
 * 然后在一般的组件中使用mapGetters就可以获取到数据,
 * 里面可以对state进行操作,然后返回出去
 */

export const counts = state => state.count
export const show = state => state.show
```

### 4.2.3 mutations-types.js

```javascript
/**
 * 定义项目中mutations-types的常量
 */
// 增加
export const INCREMENT = 'INCREMENT'
// 减少
export const DECREMENT = 'DECREMENT'
// 改变文本
export const CHANGE_TEXT = 'CHANGE_TEXT'
```

### 4.2.4 mutations.js

```javascript
import * as types from "./mutations-types"

const mutations = {
  [types.INCREMENT](state){
    state.count++
  },
  [types.DECREMENT](state){
    state.count--
  },
  [types.CHANGE_TEXT](state,v){
    state.show = v
  }
}

export  default mutations
```

### 4.2.5 index.js

```javascript
import Vue from 'vue'
import Vuex from 'vuex'
import * as getters from "./getters"
import state from "./state"
import mutations from "./mutations"

//使用插件vuex
Vue.use(Vuex)

export default new Vuex.Store({
  getters,
  state,
  mutations
})
```

## 4.3 在main.js中注册store

```javascript
import Vue from 'vue'
import App from './App.vue'
import store from './store/index'

Vue.config.productionTip = false

new Vue({
  store,
  render: h => h(App)
}).$mount('#app')
```

## 4.4 在App.vue中使用

```javascript
<template>
  <div id="app">
    <div class="store">
      <p>
        {{counts}}
      </p>
      <button @click="handleIncrement"><strong>+</strong></button>
      <button @click="handleDecrement"><strong>-</strong></button>
      <hr>
      <h3>{{show}}</h3>
      <input
              placeholder="请输入内容"
              v-model="obj"
              @change="changObj"
              clearable>
      </input>
    </div>
  </div>
</template>
<script>
  // 获取状态
  import {mapGetters,mapMutations} from 'vuex';
  import * as types from './store/mutations-types';
  export default {
    name: 'app',
    data(){
      return {
        obj: ''
      }
    },
    computed:{
      ...mapGetters([
        'counts',
        'show'
      ])
    },
    methods:{
      handleIncrement(){
        this.setIncrement()
      },
      handleDecrement(){
        this.setDecrement()
      },
      changObj(){
        this.setChangeText(this.obj)
      },
      ...mapMutations({
        setIncrement: types.INCREMENT,
        setDecrement: types.DECREMENT,
        setChangeText: types.CHANGE_TEXT,
      })
    }
  }
</script>
<style>
  .store{
    text-align: center;
  }
</style>
```

## 4.5 结果

![](https://gitee.com/krislin_zhao/IMGcloud/raw/master/img/20200521120732.png)

# 5. Vuex工作原理详解

## 5.1 理解computed

Computed 计算属性是 Vue 中常用的一个功能，但你理解它是怎么工作的吗？

拿官网简单的例子来看一下：

```html
<div id="example">
  <p>Original message: "{{ message }}"</p>
  <p>Computed reversed message: "{{ reversedMessage }}"</p>
</div>
```

```javascript
var vm = new Vue({
  el: '#example',
  data: {
    message: 'Hello'
  },
  computed: {
    // 计算属性的 getter
    reversedMessage: function () {
      // `this` 指向 vm 实例
      return this.message.split('').reverse().join()
    }
  }
})
```

vue的computed是如何更新的，为什么当vm.message发生变化时，vm.reversedMessage也会自动发生变化？

### vue中data属性和computed相关的源代码

```javascript
// src/core/instance/state.js
// 初始化组件的state
export function initState (vm: Component) {
  vm._watchers = []
  const opts = vm.$options
  if (opts.props) initProps(vm, opts.props)
  if (opts.methods) initMethods(vm, opts.methods)
  // 当组件存在data属性
  if (opts.data) {
    initData(vm)
  } else {
    observe(vm._data = {}, true /* asRootData */)
  }
  // 当组件存在 computed属性
  if (opts.computed) initComputed(vm, opts.computed)
  if (opts.watch && opts.watch !== nativeWatch) {
    initWatch(vm, opts.watch)
  }
}
```

`initState`方法当组件实例化时会自动触发，该方法主要完成了初始化data,methods,props,computed,watch这些我们常用的属性，我们来看看我们需要关注的`initData`和`initComputed`

#### `initData`

```javascript
// src/core/instance/state.js
function initData (vm: Component) {
  let data = vm.$options.data
  data = vm._data = typeof data === 'function'
    ? getData(data, vm)
    : data || {}
  // .....省略无关代码
  
  // 将vue的data传入observe方法
  observe(data, true /* asRootData */)
}

// src/core/observer/index.js
export function observe (value: any, asRootData: ?boolean): Observer | void {
  if (!isObject(value)) {
    return
  }
  let ob: Observer | void
  // ...省略无关代码
  ob = new Observer(value)
  if (asRootData && ob) {
    ob.vmCount++
  }
  return ob
}
```

在初始化的时候observe方法本质上是实例化了一个Observer对象，这个对象的类是这样的

```javascript
// src/core/observer/index.js
export class Observer {
  value: any;
  dep: Dep;
  vmCount: number; // number of vms that has this object as root $data

  constructor (value: any) {
    this.value = value
    // 关键代码 new Dep对象
    this.dep = new Dep()
    this.vmCount = 0
    def(value, '__ob__', this)
    // ...省略无关代码
    this.walk(value)
  }

  walk (obj: Object) {
    const keys = Object.keys(obj)
    for (let i = 0; i < keys.length; i++) {
      // 给data的所有属性调用defineReactive
      defineReactive(obj, keys[i], obj[keys[i]])
    }
  }
}
```

在对象的构造函数中，最后调用了**walk**方法，该方法即遍历data中的所有属性，并调用`defineReactive`方法，`defineReactive`方法是**vue**实现 MDV(Model-Driven-View)的基础，本质上就是代理了数据的set,get方法，当数据修改或获取的时候，能够感知。我们具体看看`defineReactive`的源代码

```javascript
// src/core/observer/index.js
export function defineReactive (
  obj: Object,
  key: string,
  val: any,
  customSetter?: ?Function,
  shallow?: boolean
) {
  // 重点，在给具体属性调用该方法时，都会为该属性生成唯一的dep对象
  const dep = new Dep()

  // 获取该属性的描述对象
  // 该方法会返回对象中某个属性的具体描述
  // api地址https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/Object/getOwnPropertyDescriptor
  const property = Object.getOwnPropertyDescriptor(obj, key)
  // 如果该描述不能被更改，直接返回，因为不能更改，那么就无法代理set和get方法，无法做到响应式
  if (property && property.configurable === false) {
    return
  }

  // cater for pre-defined getter/setters
  const getter = property && property.get
  const setter = property && property.set
  
  let childOb = !shallow && observe(val)
  // 重新定义data当中的属性，对get和set进行代理。
  Object.defineProperty(obj, key, {
    enumerable: true,
    configurable: true,
    get: function reactiveGetter () {
      const value = getter ? getter.call(obj) : val
      // 收集依赖， reversedMessage为什么会跟着message变化的原因
      if (Dep.target) {
        dep.depend()
        if (childOb) {
          childOb.dep.depend()
        }
        if (Array.isArray(value)) {
          dependArray(value)
        }
      }
      return value
    },
    set: function reactiveSetter (newVal) {
      const value = getter ? getter.call(obj) : val
      /* eslint-disable no-self-compare */
      if (newVal === value || (newVal !== newVal && value !== value)) {
        return
      }
      if (setter) {
        setter.call(obj, newVal)
      } else {
        val = newVal
      }
      childOb = !shallow && observe(newVal)
      // 通知依赖进行更新
      dep.notify()
    }
  })
}

```

我们可以看到，在`所代理的属性`的`get`方法中，当dep.Target存在的时候会调用`dep.depend()`方法，这个方法非常的简单，不过在说这个方法之前，我们要认识一个新的类`Dep`

Dep 是 vue 实现的一个处理依赖关系的对象， 主要起到一个纽带的作用，就是连接 reactive data 与 watcher,代码非常的简单

```javascript
// src/core/observer/dep.js
export default class Dep {
  static target: ?Watcher;
  id: number;
  subs: Array<Watcher>;

  constructor () {
    this.id = uid++
    this.subs = []
  }

  addSub (sub: Watcher) {
    this.subs.push(sub)
  }

  removeSub (sub: Watcher) {
    remove(this.subs, sub)
  }

  depend () {
    if (Dep.target) {
      Dep.target.addDep(this)
    }
  }

  notify () {
    const subs = this.subs.slice()
    for (let i = 0, l = subs.length; i < l; i++) {
      // 更新 watcher 的值，与 watcher.evaluate() 类似，
      // 但 update 是给依赖变化时使用的，包含对 watch 的处理
      subs[i].update()
    }
  }
}

// 当首次计算 computed 属性的值时，Dep 将会在计算期间对依赖进行收集
Dep.target = null
const targetStack = []

export function pushTarget (_target: Watcher) {
  // 在一次依赖收集期间，如果有其他依赖收集任务开始（比如：当前 computed 计算属性嵌套其他 computed 计算属性），
  // 那么将会把当前 target 暂存到 targetStack，先进行其他 target 的依赖收集，
 if (Dep.target) targetStack.push(Dep.target)
  Dep.target = _target
}

export function popTarget () {
  // 当嵌套的依赖收集任务完成后，将 target 恢复为上一层的 Watcher，并继续做依赖收集
  Dep.target = targetStack.pop()
}
```

代码非常的简单，回到调用`dep.depend()`方法的时候，当`Dep.Target`存在，就会调用，而`depend方法`则是将该dep加入`watcher`的`newDeps`中,同时，将`所访问当前属性`的`dep`对象中的`subs`插入当前Dep.target的watcher.看起来有点绕，不过没关系，我们一会跟着例子讲解一下就清楚了。

讲完了代理的get,方法，我们讲一下代理的set方法，set方法的最后调用了`dep.notify()`,当设置data中具体属性值的时候，就会调用该属性下面的`dep.notify()`方法，通过`class Dep`了解到，notify方法即将加入该dep的watcher全部更新，也就是说，当你修改**data**中某个属性值时，会同时调用`dep.notify()`来更新依赖该值的所有`watcher`。

#### `initComputed`

`initComputed`这条线，这条线主要解决了什么时候去设置`Dep.target`的问题

```javascript
// src/core/instance/state.js
const computedWatcherOptions = { lazy: true }
function initComputed (vm: Component, computed: Object) {
  // 初始化watchers列表
  const watchers = vm._computedWatchers = Object.create(null)
  const isSSR = isServerRendering()

  for (const key in computed) {
    const userDef = computed[key]
    const getter = typeof userDef === 'function' ? userDef : userDef.get
    if (!isSSR) {
      // 关注点1，给所有属性生成自己的watcher, 可以在this._computedWatchers下看到
      watchers[key] = new Watcher(
        vm,
        getter || noop,
        noop,
        computedWatcherOptions
      )
    }

    if (!(key in vm)) {
      // 关注点2
      defineComputed(vm, key, userDef)
    }
  }
}
```

在初始化computed时，有2个地方需要去关注

1. 对每一个属性都生成了一个属于自己的Watcher实例，并将 **{ lazy: true }**作为options传入
2. 对每一个属性调用了defineComputed方法(本质和data一样，代理了自己的set和get方法，我们重点关注代理的**get**方法)

我们看看**Watcher**的构造函数

```javascript
// src/core/observer/watcher.js
constructor (
    vm: Component,
    expOrFn: string | Function,
    cb: Function,
    options?: Object
  ) {
    this.vm = vm
    vm._watchers.push(this)
    if (options) {
      this.deep = !!options.deep
      this.user = !!options.user
      this.lazy = !!options.lazy
      this.sync = !!options.sync
    } else {
      this.deep = this.user = this.lazy = this.sync = false
    }    
    this.cb = cb
    this.id = ++uid // uid for batching
    this.active = true
    this.dirty = this.lazy // 如果初始化lazy=true时（暗示是computed属性），那么dirty也是true,需要等待更新
    this.deps = []
    this.newDeps = []
    this.depIds = new Set()
    this.newDepIds = new Set()
    this.getter = expOrFn // 在computed实例化时，将具体的属性值放入this.getter中
    // 省略不相关的代码
    this.value = this.lazy
      ? undefined
      : this.get()
  }

```

除了日常的初始化外，还有2行重要的代码

```javascript
this.dirty = this.lazy this.getter = expOrFn
```

在**computed**生成的**watcher**，会将watcher的lazy设置为true,以减少计算量。因此，实例化时，`this.dirty`也是true,标明数据需要更新操作。我们先记住现在**computed中初始化对各个属性生成的watcher的dirty和lazy都设置为了true**。同时，将computed传入的属性值**（一般为`funtion`）**,放入**watcher**的**getter**中保存起来。

### `defineComputed`所代理属性的get方法

```javascript
// src/core/instance/state.js
function createComputedGetter (key) {
  return function computedGetter () {
    const watcher = this._computedWatchers && this._computedWatchers[key]
    // 如果找到了该属性的watcher
    if (watcher) {
      // 和上文对应，初始化时，该dirty为true,也就是说，当第一次访问computed中的属性的时候，会调用 watcher.evaluate()方法；
      if (watcher.dirty) {
        watcher.evaluate()
      }
      if (Dep.target) {
        watcher.depend()
      }
      return watcher.value
    }
  }
}
```

当`第一次`访问computed中的值时，会因为初始化`watcher.dirty = watcher.lazy`的原因，从而调用`evalute()`方法，`evalute()`方法很简单,就是调用了watcher实例中的**get**方法以及设置**dirty = false**,我们将这两个方法放在一起

```javascript
// src/core/instance/state.js
evaluate () {
  this.value = this.get()
  this.dirty = false
}
  
get () {  
// 重点1，将当前watcher放入Dep.target对象
  pushTarget(this)
  let value
  const vm = this.vm
  try {
    // 重点2，当调用用户传入的方法时，会触发什么？
    value = this.getter.call(vm, vm)
  } catch (e) {
  } finally {
    popTarget()
    // 去除不相关代码
  }
  return value
}
```

在get方法中中，第一行就调用了**pushTarget**方法，其作用就是将**Dep.target**设置为所传入的watcher,即所访问的**computed**中属性的**watcher**,
然后调用了`value = this.getter.call(vm, vm)`方法，想一想，调用这个方法会发生什么？

**this.getter** 在Watcher构建函数中提到，本质就是用户传入的方法，也就是说，**this.getter.call(vm, vm)**就会调用用户自己声明的方法，那么如果方法里面用到了 **this.data**中的值或者其他被用**defineReactive**包装过的对象，那么，访问this.data.或者其他被**defineReactive**包装过的属性，是不是就会访问被代理的该属性的get方法。我们在回头看看
**get**方法是什么样子的。

> 注意:我讲了其他被用defineReactive，这个和后面的vuex有关系，我们后面在提

```javascript
get: function reactiveGetter () {
      const value = getter ? getter.call(obj) : val
      // 这个时候，有值了
      if (Dep.target) {
        // computed的watcher依赖了this.data的dep
        dep.depend()
        if (childOb) {
          childOb.dep.depend()
        }
        if (Array.isArray(value)) {
          dependArray(value)
        }
      }
      return value
    }
```

代码注释已经写明了，就不在解释了，这个时候我们走完了一个依赖收集流程，知道了computed是如何知道依赖了谁。最后根据`this.data`所代理的**set**方法中调用的**notify**,就可以改变`this.data`的值，去更新所有依赖`this.data`值的computed属性value了。

### 获取依赖并更新的过程

那么，我们根据下面的代码，来简易拆解获取依赖并更新的过程

```javascript
var vm = new Vue({
  el: '#example',
  data: {
    message: 'Hello'
  },
  computed: {
    // 计算属性的 getter
    reversedMessage: function () {
      // `this` 指向 vm 实例
      return this.message.split('').reverse().join()
    }
  }
})
vm.reversedMessage // =>  olleH
vm.message = 'World' // 
vm.reversedMessage // =>  dlroW
```

1. 初始化 data和computed,分别代理其set以及get方法, 对data中的所有属性生成唯一的dep实例。
2. 对computed中的reversedMessage生成唯一watcher,并保存找vm._computedWatchers中
3. 访问 **reversedMessage**，设置Dep.target指向reversedMessage的watcher,调用该属性具体方法**reversedMessage**。
4. 方法中访问this.message，即会调用this.message代理的get方法，将this.message的**dep**加入输入reversedMessage的**watcher**,同时该dep中的**subs**添加这个**watcher**
5. 设置**vm.message = 'World'**，调用message代理的set方法触发**dep的notify**方法
6. 因为是computed属性，只是将**watcher**中的**dirty**设置为true
7. 最后一步**vm.reversedMessage**，访问其get方法时，得知**reversedMessage**的**watcher.dirty**为true,调用**watcher.evaluate()**方法获取新的值。

这样，也可以解释了为什么有些时候当computed没有被访问（或者没有被模板依赖），当修改了`this.data`值后，通过vue-tools发现其**computed**中的值没有变化的原因，因为没有触发到其**get**方法。

## 5.2 vuex插件

我们知道，vuex仅仅是作为vue的一个插件而存在，不像Redux,MobX等库可以应用于所有框架，vuex只能使用在vue上，很大的程度是因为其高度依赖于vue的computed依赖检测系统以及其插件系统，

通过[官方文档](https://cn.vuejs.org/v2/guide/plugins.html)我们知道，每一个vue插件都需要有一个公开的install方法，vuex也不例外。其代码比较简单，调用了一下applyMixin方法，该方法主要作用就是在所有组件的**beforeCreate**生命周期注入了设置**this.$store**这样一个对象。

```javascript
// src/store.js
export function install (_Vue) {
  if (Vue && _Vue === Vue) {
    return
  }
  Vue = _Vue
  applyMixin(Vue)
}
```

```javascript
// src/mixins.js
// 对应applyMixin方法
export default function (Vue) {
  const version = Number(Vue.version.split('.')[0])

  if (version >= 2) {
    Vue.mixin({ beforeCreate: vuexInit })
  } else {
    const _init = Vue.prototype._init
    Vue.prototype._init = function (options = {}) {
      options.init = options.init
        ? [vuexInit].concat(options.init)
        : vuexInit
      _init.call(this, options)
    }
  }

  /**
   * Vuex init hook, injected into each instances init hooks list.
   */
    
  function vuexInit () {
    const options = this.$options
    // store injection
    if (options.store) {
      this.$store = typeof options.store === 'function'
        ? options.store()
        : options.store
    } else if (options.parent && options.parent.$store) {
      this.$store = options.parent.$store
    }
  }
}
```

我们在业务中使用vuex需要类似以下的写法

```javascript
const store = new Vuex.Store({
    state,
    mutations,
    actions,
    modules
});
```

那么 **Vuex.Store**到底是什么样的东西呢？我们先看看他的构造函数

```javascript
// src/store.js
constructor (options = {}) {
  const {
    plugins = [],
    strict = false
  } = options

  // store internal state
  this._committing = false
  this._actions = Object.create(null)
  this._actionSubscribers = []
  this._mutations = Object.create(null)
  this._wrappedGetters = Object.create(null)
  this._modules = new ModuleCollection(options)
  this._modulesNamespaceMap = Object.create(null)
  this._subscribers = []
  this._watcherVM = new Vue()

  const store = this
  const { dispatch, commit } = this
  this.dispatch = function boundDispatch (type, payload) {
    return dispatch.call(store, type, payload)
}
  this.commit = function boundCommit (type, payload, options) {
    return commit.call(store, type, payload, options)
}

  // strict mode
  this.strict = strict

  const state = this._modules.root.state

  // init root module.
  // this also recursively registers all sub-modules
  // and collects all module getters inside this._wrappedGetters
  installModule(this, state, [], this._modules.root)

  // 重点方法 ，重置VM
  resetStoreVM(this, state)

  // apply plugins
  plugins.forEach(plugin => plugin(this))

}
```

除了一堆初始化外，我们注意到了这样一行代码`resetStoreVM(this, state)` 他就是整个vuex的关键

```javascript
// src/store.js
function resetStoreVM (store, state, hot) {
  // 省略无关代码
  Vue.config.silent = true
  store._vm = new Vue({
    data: {
      $$state: state
    },
    computed
  })
}
```

去除了一些无关代码后我们发现，其本质就是将我们传入的state作为一个隐藏的vue组件的data,也就是说，我们的commit操作，本质上其实是修改这个组件的data值，结合上文的computed,修改被**defineReactive**代理的对象值后，会将其收集到的依赖的**watcher**中的**dirty**设置为true,等到下一次访问该watcher中的值后重新获取最新值。

这样就能解释了为什么vuex中的state的对象属性必须提前定义好，如果该**state**中途增加**一个属性**，因为该**属性**没有被**defineReactive**，所以其依赖系统没有检测到，自然不能更新。

由上所说，我们可以得知`store._vm.$data.$$state === store.state`, 我们可以在任何含有vuex框架的工程得到这一点

![](https://gitee.com/krislin_zhao/IMGcloud/raw/master/img/20200521124912.png)

vuex整体思想诞生于**flux**,可其的实现方式完完全全的使用了vue自身的响应式设计，依赖监听、依赖收集都属于vue对对象Property set get方法的代理劫持。最后一句话结束vuex工作原理，`vuex中的store本质就是没有`template`的隐藏着的vue组件；`