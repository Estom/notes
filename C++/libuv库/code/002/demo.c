/*
 * @Author: jiejie
 * @Github: https://github.com/jiejieTop
 * @Date: 2020-04-17 19:44:48
 * @LastEditTime: 2020-04-17 19:52:40
 * @Description: the code belongs to jiejie, please keep the author information and source code according to the license.
 */
#include <stdio.h>
#include <stdlib.h>
#include <uv.h>

int main() 
{
    uv_loop_t *loop = malloc(sizeof(uv_loop_t));
    uv_loop_init(loop);

    uv_run(loop, UV_RUN_DEFAULT);

    printf("quit...\n");

    uv_loop_close(loop);
    free(loop);
    return 0;
}
