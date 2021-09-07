/*
 * @Author: jiejie
 * @Github: https://github.com/jiejieTop
 * @Date: 2020-04-22 20:22:38
 * @LastEditTime: 2020-04-29 00:15:55
 * @Description: the code belongs to jiejie, please keep the author information and source code according to the license.
 */
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <uv.h>


int main(void) 
{
    uv_write_t req;
    uv_buf_t buf;
    uv_loop_t *loop;
    uv_tty_t tty;

    loop = uv_default_loop();

    uv_tty_init(loop, &tty, STDOUT_FILENO, 0);
    uv_tty_set_mode(&tty, UV_TTY_MODE_NORMAL);
    
    if (uv_guess_handle(STDOUT_FILENO) == UV_TTY) {

        buf.base = "\033[41;37m";
        buf.len = strlen(buf.base);

        uv_write(&req, (uv_stream_t*) &tty, &buf, 1, NULL);
    }

    buf.base = "Hello TTY\n";
    buf.len = strlen(buf.base);

    uv_write(&req, (uv_stream_t*) &tty, &buf, 1, NULL);

    uv_tty_reset_mode();
    
    return uv_run(loop, UV_RUN_DEFAULT);
}


