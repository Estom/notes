
<template>
    <div class="person">
        <h2>知识点1：ref/reactive支持</h2>
        <h3>姓名:{{ person.name }}</h3>
        <h3>年龄:{{ person.age }}</h3>
        <button @click="changeNameToRef">改变姓名</button>
        <button @click="changeAgeToRef">改变年龄</button>
        <button @click="changeNameAndAge">改变人物</button>

        <h2>知识点2：computed 计算属性</h2>
        <h3>姓名:<input type="text" v-model="person.name" /> </h3>
        <h3>年龄:<input type="text" v-model="person.age" /> </h3>
        <h3>姓名-年龄：{{ nameAge }}</h3>


        <h2>知识点3：watch 监控变化</h2>
        <h2>reactiveVal:{{reactiveVal.a.b.c}}</h2>
        <button @click="changeReactiveVal">修改变量</button>

    </div>
</template>
<!--  -->
<script lang="ts" setup >
// js与java一样，所有的变量都是指针，你可以修改指针绑定的地址然后指向其他对象，也可以修改指针指向的对象的内容，不会改变地址值。
//如果你修改指针本身，让变量指向了另一个对象，指针相当于该表。
//const对象的地址不能修改,即你不能修改指针已经绑定的地址，不能修改指向其他对象
//let对象的地址是能修改的，你能修改指针绑定的地址。即修改指向其他对象

//reactive的局限性。重新分配创建指向响应式数据对象是没有意义的。原有的响应式数据对象已经绑定到template中的数据，新创建的响应式数据对象并不会绑定到template中的数据。
// 由于reactive没有像ref一样重新包装一层，其直接指向响应式数据，所以你无法直接更新reactive绑定的指针地址，只能修改其指向的对象。
// 因为你一旦修改绑定的地址，就相当于指向了一个新的对象，而原来的响应式数据对象就丢失了，你新建的响应式数据并没有被vue接管，也无法被接管。
// ref变量同理，你也无法直接修改ref变量绑定新的指针地址，这会导致原来的响应式数据对象丢失，无法实现响应式的过程
// 但就巧妙在ref是在原对象外包装了一层，你直接修改其.value指向的对象，并不会修改ref变量指向的对象，所以能更好的应对各种情况。
import { ref, reactive, computed, watch, toRefs } from 'vue'
let person = ref({
    name: '张三',
    age: 18
})

//ToRefs toRef能够结构赋值
const { name, age } = toRefs(person.value)
function changeNameToRef() {
    name.value += '~'
}

function changeAgeToRef() {
    age.value += 1
}

// 不修改指针绑定的地址，修改指向的对象的内容
const changeName = () => {
    person.value.name += '~'
}

// 不修改指针绑定的地址，修改指向的对象的内容
const changeAge = () => {
    person.value.age += 1
}

// 修改指针绑定的地址，指向其他对象。
function changeNameAndAge(){
    person.value = {name: "李四",age:99}
}

const nameAge = computed(() => {
    return person.value.name + '-' + person.value.age
})


// 满足条件后停止监视,deep能够监视内部数据的变化
// watch也只能监视响应式对象数据内容的变化，而不是地址的变化。如果创建一个新的对象或赋予新的地址都监视不到。
const stopWatch = watch(person, (newVal, oldVal) => {
    console.log("watched:",newVal,oldVal);
    // stopWatch();
},{deep:true})


let reactiveVal = reactive({
    a:{
        b:{
            c:123
        }
    }
})

function changeReactiveVal(){
    reactiveVal.a.b.c = 456;
}
//当监视的是reactive对象的时候，默认开启深度监视,并且无法关闭
watch(reactiveVal,(newVal,oldVal)=>{
    console.log("watched",newVal,oldVal)
})

// 可以通过函数监视某个其中的属性，通过监视一个函数返回值的地址值是否发生变化来决定是否执行回到函数
watch(() => reactiveVal.a.b.c,(newVal,oldVal)=>{
    console.log("watched",newVal,oldVal)
})
import {watchEffect,defineExpose} from 'vue'
//快速监视，不需要声明监视什么变量，自动监视
watchEffect(()=>{
  reactiveVal.a.b.c = 1999
})

//导出一些对象，当前的组件实例
defineExpose({reactiveVal})


//接收外部变量
let x = defineProps(['a'])

// 接收list+限制类型+必要值+默认值
import {withDefaults} from 'vue'
withDefaults(defineProps<{list?:string}>(),{
    list:()=>'a'
})

</script>


<style scoped>
.person {
    background-color: skyblue;
    box-shadow: 0 0 10px;
    border-radius: 10px;
    padding: 10px;
}

button {
    margin: 5px;
}
</style>