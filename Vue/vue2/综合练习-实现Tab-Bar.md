![](https://gitee.com/krislin_zhao/IMGcloud/raw/master/img/20200518092031.gif)

# 1. 实现Tab-Bar思路

1. 下方单独的`Tab-Bar`组件如何封装？
   - 自定义`Tab-Bar`组件，在APP中使用
   - 让`Tab-Bar`位置在底部，并设置你需要的样式
2. `Tab-Bar`中显示的内容由外部决定
   - 定义插槽
   - flex布局平分`Tab-Bar`
3. 自定义`Tab-Bar-Item`，可以传入图片和文字
   - 定义`Tab-Bar-Item`，并定义两个插槽：图片和文字
   - 给插槽外层包装`div`，设置样式
   - 填充插槽，实现底部`Tab-Bar`的效果
4. 传入高亮图片
   - 定义另一个插槽，插入`active-icon`的数据
   - 定义一个变量`isActicve`，通过`v-show`来决定是否显示对应的icon
5. `Tab-Bar-Item`绑定路由数据
   - 安装路由：`npm install vue-router --save`
   - 在`router/index.js`配置路由信息，并创建对应的组件
   - `main.js`中注册`router`
   - `App.vue`中使用`router-link`和`router-view`
6. 点击item跳转到对应的路由，并且动态决定`isActive`
   - 监听`item`的点击，通过`this.$router.replace()`替换路由路径
   - 通过`this.$route.path.indexOf(this.link)!==-1`来判断是否使`active`
7. 动态计算active样式
   - 封装新的计算属性：`this.isActive?{'color': 'red'}:{}`

# 2. 代码实现

使用`vue init webpack 02-vue-router-tabbar-v1`新建一个项目工程(使用`vuecli2`)。

1. 在文件夹assest下新建css/base.css,用于初始化css

   > base.css



   ```css
   body {
     padding: 0;
     margin: 0;
   }
   ```

   > 修改App.vue，添加初步样式

   ```vue
   <template>
     <div id="app">
       <div id="tar-bar">
         <div class="tar-bar-item">首页</div>
         <div class="tar-bar-item">分类</div>
         <div class="tar-bar-item">购物车</div>
         <div class="tar-bar-item">我的</div>
       </div>
     </div>
   </template>

   <script>
   export default {
     name: 'App'
   }
   </script>

   <style>
       /* style中引用使用@import */
     @import url('./assets/css/base.css');

     #tar-bar {
       display: flex;
       background-color: #f6f6f6;

       position: fixed;
       left: 0;
       right: 0;
       bottom: 0;

       box-shadow: 0 -1px  1px rgba(100, 100, 100, .2);
     }

     .tar-bar-item {
       flex: auto;
       text-align: center;
       height: 49px;
       font-size: 20px;
     }
   </style>

   ```

   > 使用npm run dev，查看网页效果

   												![](https://gitee.com/krislin_zhao/IMGcloud/raw/master/img/20200518092055.png)

   > 思考：如果每次都要复用tabbar，那每次都需要复制粘贴，应该要把tabbar抽离出来，vue就是组件化思想。



2. 将tabbar抽离成组件

   在components下新建tabbar文件夹，新建`TarBar.vue`和`TabBarItem.vue`,`TabBarItem`组件是在组件`TarBar`中抽取出来的，可以传入图片和文字（比如首页），所有需要使用插槽`<slot>`代替。

   > TarBar.vue

   
   
   ```vue
   <template>
          <div id="tab-bar">
            <!-- 插槽代替tabbaritem -->
            <slot></slot>
          </div>
      </template>
      <script type="text/ecmascript-6">
      export default {
        name: 'TabBar'
      }
      </script>
      <style scoped>
        #tab-bar {
          display: flex;
          background-color: #f6f6f6;
          position: fixed;
          left: 0;
          right: 0;
          bottom: 0;
   
          box-shadow: 0 -1px  1px rgba(100, 100, 100, .2);
         }
    </style>
   ```

   TabBar弄一个slot插槽用于插入TabBarItem组件（可能插入多个）.
   
   
   
   > TabBarItem.vue

```vue
<template>
    <div class="tab-bar-item">
      <!-- item-icon表示图片插槽 item-text表示文字插槽，例如首页 -->
      <slot name="item-icon"></slot>
      <slot name="item-text"></slot>
    </div>
</template>
<script type="text/ecmascript-6">
  export default {
    name: 'TabBarItem'
  }
</script>
<style scoped>
  .tab-bar-item {
    flex: auto;
    text-align: center;
    height: 49px;
    font-size: 14px;
  }
  .tab-bar-item img {
    height: 24px;
    width: 24px;
    margin-top: 3px;
    vertical-align: middle;
    margin-bottom: 2px;
  }
</style>
```

TabBarItem组件中插入2个插槽一个用于插入图片一个用于插入文字。



> MainTabBar.vue



```vue
<template>
  <div class="main-tab-bar">
    <TabBar>
      <TabBarItem path="/home" activeColor="blue">
        <img slot="item-icon" src="~assets/img/tabbar/home.png" alt="" srcset="">
        <template v-slot:item-text>
          <div>首页</div>
        </template>
      </TabBarItem>
      <TabBarItem path="/categories">
        <template #item-icon>
          <img src="~assets/img/tabbar/categories.png" alt="" srcset="">
        </template>
        <template #item-text>
          <div>分类</div>
        </template>
      </TabBarItem>
      <TabBarItem path="/shop">
        <template #item-icon>
          <img src="~assets/img/tabbar/shopcart.png" alt="" srcset="">
        </template>
        <template #item-text>
          <div>购物车</div>
        </template>
      </TabBarItem>
      <TabBarItem path="/me">
        <template #item-icon>
          <img src="~assets/img/tabbar/profile.png" alt="" srcset="">
        </template>
        <template #item-text>
          <div>我的</div>
        </template>
      </TabBarItem>
    </TabBar>
  </div>
</template>
<script type="text/ecmascript-6">
  import TabBar from "@/components/tabbar/TabBar"
  import TabBarItem from "@/components/tabbar/TabBarItem"
  export default {
    name: "MainTabBar",
    components: {
      TabBar,
      TabBarItem
    }
  }
</script>
<style scoped>
</style>

```

在MainTabBar组件中加入另外2个组件。

> 注意此处使用`~assets`和`@/components`是使用了别名配置，[详情请看3.别名配置](#3.别名配置)



最后在app.vue中导入MainTabBar组件。

```vue
<template>
  <div id="app">
    <MainTabBar></MainTabBar>
  </div>
</template>
<script>
  import MainTabBar from '@/components/MainTabBar'
  export default {
    name: 'App',
    components: {
      MainTabBar
    }
  }
</script>
<style>
    /* style中引用使用@import */
  @import url('./assets/css/base.css');
</style>

```

效果如图所示，将组件进行了分离重组，只要修改MainTabBar组件就可以修改图片和文字描述，可以复用。

![](https://gitee.com/krislin_zhao/IMGcloud/raw/master/img/20200518092125.png)

3. 如何实现点击首页首页字体变红图片变红色

   这里需要用到路由的`active-class`。

   > 思路：引用2张图片，一张是正常颜色一张是红色，使用`v-if`和`v-else`来处理是否变色，在路由处于活跃状态的时候，变红色。

   引入路由使用路由就不细说了，这里仅贴上tabbar的修改代码。

   > TabBarItem.vue组件

   ```vue
   <template>
       <div class="tab-bar-item" :style="activeStyle" @click="itemClick">
         <!-- item-icon表示图片插槽 item-text表示文字插槽，例如首页 -->
         <div v-if="!isActive">
           <slot  name="item-icon"></slot>
         </div>
         <div  v-else>
           <slot name="item-icon-active"></slot>
         </div>
         <div :class="{active:isActive}">
           <slot name="item-text"></slot>
         </div>
       </div>
   </template>
   
   <script type="text/ecmascript-6">
     export default {
       name: 'TabBarItem',
       props:{
         path:String,
         activeColor:{
           type:String,
           default:'red'
         }
       },
       computed: {
         isActive(){
           return this.$route.path.indexOf(this.path) !== -1
         },
         activeStyle(){
           return this.isActive ? {color: this.activeColor} : {}
         }
       },
       methods: {
         itemClick(){
           this.$router.push(this.path)
         }
       }
     }
   </script>
   
   <style scoped>
     .tab-bar-item {
       flex: auto;
       text-align: center;
       height: 49px;
       font-size: 14px;
     }
   
     .tab-bar-item img {
       height: 24px;
       width: 24px;
       margin-top: 3px;
       vertical-align: middle;
       margin-bottom: 2px;
     }
   </style>
   ```

   

   1. 使用`props`获取传递的值，这里传递是激活颜色，默认是红色
   2. 设置计算属性`isActive`和`activeStyle`，分别表示激活状态和激活的样式
   3. 定义`itemClick()`方法用于获取点击事件，点击后使用代码实现路由跳转，这里使用默认的hash模式
   4. 使用`v-if`和`v-else`来进行条件判断

   > MainTabBar.vue组件

   ```vue
         <TabBarItem path="/home">
           <img slot="item-icon" src="~assets/img/tabbar/home.png" alt="" srcset="">
           <img slot="item-icon-active" src="~assets/img/tabbar/home_active.png" alt="" srcset="">
           <template v-slot:item-text>
             <div>首页</div>
           </template>
         </TabBarItem>
   ```

   添加激活状态的图片与未激活的图片并列。

4. 配置路由信息，参考之前的代码

   ```js
   import Vue from 'vue'
   import Router from 'vue-router'
   
   
   Vue.use(Router)
   
   const routes = [
     {
       path: '/',
       redirect: '/home'//缺省时候重定向到/home
     },
     {
       path: '/home',
       component: () => import ('../views/home/Home.vue')
     },
     {
       path: '/categories',
       component: () => import ('../views/categories/Categories.vue')
     },
     {
       path: '/shop',
       component: () => import ('../views/shop/Shop.vue')
     },
     {
       path: '/profile',
       component: () => import ('../views/profile/Profile.vue')
     },
   ]
   
   export default new Router({
     routes,
     // linkActiveClass:"active"
   })
   ```

   ![](https://gitee.com/krislin_zhao/IMGcloud/raw/master/img/20200518092146.png)

5. 修改main.js和App.vue

   ```js
   import Vue from 'vue'
   import App from './App'
   import router from './router'
   
   Vue.config.productionTip = false
   
   /* eslint-disable no-new */
   new Vue({
     el: '#app',
     router,
     render: h => h(App)
   })
   ```

   

   ```vue
   <template>
     <div id="app">
       <router-view></router-view>
       <MainTabBar></MainTabBar>
     </div>
   </template>
   
   <script>
     import MainTabBar from '@/components/MainTabBar'
     export default {
       name: 'App',
       components: {
         MainTabBar
       }
     }
   </script>
   
   <style>
       /* style中引用使用@import */
     @import url('./assets/css/base.css');
   
   </style>
   
   ```

# 3. 别名配置

经常的我们向引入图片文件等资源的时候使用相对路径，诸如`../assets/xxx`这样的使用`../`获取上一层，如果有多个上层就需要`../../xxx`等等这样不利于维护代码。此时就需要一个能获取到指定目录的资源的就好了。

> 配置

在`webpack.base.config`中配置使用别名，找到resolve:{}模块，增加配置信息

```js
  resolve: {
    extensions: ['.js', '.vue', '.json'],
    alias: {
      '@': resolve('src'),
      'assets': resolve('src/assets'),
      'components': resolve('src/components'),
      'views': resolve('scr/views')
    }
  },
```

这里`@`指定目录是`src`，例如`@/components`表示`src/components`目录，`assets`表示`src/assets`前缀，如果是`assets/img`就表示`src/assets/img`目录。
