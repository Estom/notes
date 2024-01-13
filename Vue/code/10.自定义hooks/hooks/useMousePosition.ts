import { ref, onMounted, onUnmounted } from 'vue'

export default function() {
  const x = ref(0)
  const y = ref(0)

  // 点击事件的回调函数
  const onHandlerClick = (event: MouseEvent) => {
    x.value = event.pageX
    y.value = event.pageY
  }

  // 页面已经加载完毕了,再进行点击的操作
  // 页面加载完毕的生命周期组合API
  onMounted(() => {
    window.addEventListener('click', onHandlerClick)
  })

  // 页面卸载之前的生命周期组合API
  onUnmounted(() => {
    window.removeEventListener('click', onHandlerClick)
  })

  return {
    x,
    y
  }
}
