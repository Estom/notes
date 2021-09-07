/*
 * @Author: jiejie
 * @Github: https://github.com/jiejieTop
 * @Date: 2020-04-22 20:22:38
 * @LastEditTime: 2020-04-25 01:29:52
 * @Description: the code belongs to jiejie, please keep the author information and source code according to the license.
 */
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <uv.h>

uv_loop_t *loop;
uv_process_t child_req;
uv_process_options_t options;

void process_on_exit(uv_process_t *req, int64_t exit_status, int term_signal) {
    printf("process exited with status %ld, signal %d\n", exit_status, term_signal);
    uv_close((uv_handle_t*) req, NULL);
}

int main() 
{
    int r;

    char* args[3];
    args[0] = "mkdir";
    args[1] = "dir";
    args[2] = NULL;

    loop = uv_default_loop();
    options.exit_cb = process_on_exit;
    options.file = "mkdir";
    options.args = args;


    if ((r = uv_spawn(loop, &child_req, &options))) {
        printf("%s\n", uv_strerror(r));
        return 1;
    } else {
        printf("Launched process with ID %d\n", child_req.pid);
    }

    return uv_run(loop, UV_RUN_DEFAULT);
}

