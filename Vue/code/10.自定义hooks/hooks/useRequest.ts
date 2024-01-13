import { ref } from 'vue'
import axios from 'axios'

// 发送 ajax 请求
export default function<T>(url: string) {
  // 加载的状态
  const loading = ref(true)
  // 请求成功的数据
  const data = ref<T | null>(null) // 坑
  // 错误信息
  const errorMsg = ref('')

  axios
    .get(url)
    .then(response => {
      loading.value = false
      data.value = response.data
    })
    .catch(error => {
      loading.value = false
      errorMsg.value = error.message || '未知错误'
    })

  return {
    loading,
    data,
    errorMsg
  }
}
