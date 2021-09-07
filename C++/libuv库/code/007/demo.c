/*
 * @Author: jiejie
 * @Github: https://github.com/jiejieTop
 * @Date: 2020-04-17 19:44:48
 * @LastEditTime: 2020-04-20 23:11:23
 * @Description: the code belongs to jiejie, please keep the author information and source code according to the license.
 */
#include <stdio.h>
#include <stdlib.h>
#include <uv.h>

int64_t num = 0;

void my_idle_cb(uv_idle_t* handle)
{
    num++;
    printf("idle callback\n");
    if (num >= 5) {
        printf("idle stop, num = %ld\n", num);
        uv_stop(uv_default_loop());
    }
}

void my_check_cb(uv_check_t *handle) 
{
    printf("check callback\n");
}

int main() 
{
    uv_idle_t idler;
    uv_check_t check;

    uv_idle_init(uv_default_loop(), &idler);
    uv_idle_start(&idler, my_idle_cb);
    
    uv_check_init(uv_default_loop(), &check);
    uv_check_start(&check, my_check_cb);

    uv_run(uv_default_loop(), UV_RUN_DEFAULT);

    return 0;
}
