/*
 * @Author: jiejie
 * @Github: https://github.com/jiejieTop
 * @Date: 2020-04-17 19:44:48
 * @LastEditTime: 2020-04-18 09:47:00
 * @Description: the code belongs to jiejie, please keep the author information and source code according to the license.
 */
#include <stdio.h>
#include <stdlib.h>
#include <uv.h>

int64_t num = 0;

void my_idle_cb(uv_idle_t* handle)
{
    num++;
    if (num >= 10e6) {
        printf("data: %s\n", (char*)handle->data);
        printf("idle stop, num = %ld\n", num);
        uv_idle_stop(handle);
    }
}

int main() 
{
    uv_idle_t idler;

    uv_idle_init(uv_default_loop(), &idler);

    idler.data = (void*)"this is a public data...";

    printf("idle start, num = %ld\n", num);
    uv_idle_start(&idler, my_idle_cb);

    uv_run(uv_default_loop(), UV_RUN_DEFAULT);

    return 0;
}
