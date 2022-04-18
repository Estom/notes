const my_form = document.querySelector('#my-form')
const name_input = document.querySelector('#name')
const email_input = document.querySelector('#email')
const msg = document.querySelector('.msg')
const user_list = document.querySelector('#users')

my_form.addEventListener('submit',onsubmit);

function onsubmit(e){
    e.preventDefault();
    if(name_input.value ==='' || email_input.value===''){
        msg.classList.add('error')
        msg.innerHTML='Please Enter all fields';
        setTimeout(()=>{
            msg.remove()
        },3000) 
        // setTimeout本质上是一个异步的方法，不会阻塞当前线程，而是开启一个线程，执行相关的访问，非常有用
        // 可以用来检测任务执行的状态，动态修改当前任务执行的内容。
    }
    else{
        // console.log('success')
        const li  = document.createElement('li')
        li.appendChild(document.createTextNode(`${name_input.value}:${email_input.value}`));
        user_list.appendChild(li);
        name_input.value=''
        email_input.value=''
    }

    

}
