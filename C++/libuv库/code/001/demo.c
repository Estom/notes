/*
 * @Author: jiejie
 * @Github: https://github.com/jiejieTop
 * @Date: 2020-04-17 14:59:21
 * @LastEditTime: 2020-04-17 17:16:02
 * @Description: the code belongs to jiejie, please keep the author information and source code according to the license.
 */
#include <stdio.h>
#include <stdlib.h>
#include <uv.h>

int main() 
{
    char *version;
    
    version = (char*) uv_version_string();

    printf("libuv version is %s\n", version);

    return 0;
}