这一部分的学习还是要通过大量的代码阅读吧。在这里可以截取有用的代码并添加注释。

**进程定义**

正在运行的程序，拥有自己的虚拟地址空间拥有自己的代码、数据和其他资源。

组成：进程内核对象，操作系统使用内核对象来管理该进程。私有的虚拟地址空间。

**应用程序启动过程**

操作系统通过CreateProcess
函数来创建新的进程，分配虚拟地址空间，加载代码和数据；然后创建一个主线程，调用main函数。

CreateProcess(

>   LPCSTR lpApplicationName, // 可执行文件的名称

>   LPSTR lpCommandLine, // 指定了要传递给执行模块的参数。

>   LPSECURITY_ATTRIBUTES lpProcessAttributes,// 进程安全性，值为 NULL
>   的话表示使用默认的安全属性

>   LPSECURITY_ATTRIBUTES lpThreadAttributes,// 线程安全性，值为 NULL
>   的话表示使用默认的安全属性

>   BOOL bInheritHandles, // 指定了当前进程中的可继承句柄是否可被新进程继承。

>   DWORD dwCreationFlags, // 指定了新进程的优先级以及其他创建标志

>   LPVOID lpEnvironment, // 指定新进程使用的环境变量

>   LPCSTR lpCurrentDirectory, // 新进程使用的当前目录

>   LPSTARTUPINFO lpStartupInfo, // 指定新进程中主窗口的位置、大小和标准句柄等

>   LPPROCESS_INFORMATION lpProcessInformation
>   //【out】返回新建进程的标志信息，如 ID 号、句柄等

);

对创建进程中用到的结构体进行简单说明。通过STARTUPINFO类型的变量，指定新的进程的相关信息。通过GetStartupInfo函数来获取父进程创建自己时使用的变量：

typedef struct {

>   DWORD cb; // 本结构的长度，总是应该被设为 sizeof(STARTUPINFO)

>   LPSTR lpReserved; // 保留（Reserve）字段，即程序不使用这个参数

>   LPSTR lpDesktop; // 指定桌面名称

>   LPSTR lpTitle; // 控制台应用程序使用，指定控制台窗口标题

>   DWORD dwX; // 指定新创建窗口的位置坐标（dwX,dwY）和大小信息

>   DWORD dwY;

>   DWORD dwXSize;

>   DWORD dwYSize;

>   DWORD dwXCountChars; // 控制台程序使用，指定控制台窗口的行数

>   DWORD dwYCountChars;

>   DWORD dwFillAttribute; // 控制台程序使用，指定控制台窗口的背景色

>   DWORD dwFlags; // 标志。它的值决定了 STARTUPINFO
>   结构中哪些成员的值是有效的。

>   WORD wShowWindow; // 窗口的显示方式

>   WORD cbReserved2;

>   LPBYTE lpReserved2;

>   HANDLE hStdInput; // 控制台程序使用, 几个标准句柄

>   HANDLE hStdOutput;

>   HANDLE hStdError;

} STARTUPINFO, \*LPSTARTUPINFO;

通过pROCESS_INFORMATION结构体来获取进程创建后的信息

typedef struct{

>   HANDLE hProcess; // 新建进程的内核句柄

>   HANDLE hThread; // 新建进程中主线程的内核句柄

>   DWORD dwProcessId; // 新建进程的 ID

>   DWORD dwThreadId; // 新建进程的主线程 ID

} PROCESS_INFORMATION, \*LPPROCESS_INFORMATION;

**解决了字符集的问题**

发现内核对象的方法中W表示的宽字符，一般对应的是utf8，工程如果是用unicode进行编码的时候，就会使用W结尾的内核方法。（非Unicode编码的时候链接A结尾的方法）。所以在工程中可以配置为多字符编码，这样可以调用程序设计中的大部分代码，不存在编码问题。

**进程控制**

**获取进程快照的方法**

>   \#include \<windows.h\>

>   \#include \<tlhelp32.h\> // 声明快照函数的头文件

>   int main(int argc, char\* argv[])

>   {

>   //这是一个进程的记录变量

>   PROCESSENTRY32 pe32;

>   // 在使用这个结构之前，先设置它的大小

>   pe32.dwSize = sizeof(pe32);

>   //
>   给系统内的所有进程拍一个快照，这个对象是一个列表，需要用专门的函数进行遍历

>   HANDLE hProcessSnap = ::CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);

>   if(hProcessSnap == INVALID_HANDLE_VALUE)

>   {

>   printf(" CreateToolhelp32Snapshot 调用失败！ \\n");

>   return -1;

>   }

>   // 遍历进程快照，轮流显示每个进程的信息

>   BOOL bMore = ::Process32First(hProcessSnap, \&pe32);

>   while(bMore)

>   {

>   printf(" 进程名称： %s \\n", pe32.szExeFile);

>   printf(" 进程 ID 号： %u \\n\\n", pe32.th32ProcessID);

>   bMore = ::Process32Next(hProcessSnap, \&pe32);

>   }

>   // 不要忘记清除掉 snapshot 对象

>   ::CloseHandle(hProcessSnap);

>   return 0;

>   }

CreateToolhelp32Snapshot()也可以获取其他类型的快照。TH32CS_SNAPPROCESS、TH32CS_SNAPHEAPLIST、TH32CS_SNAPMOUDULE、TH32CS_SNAPMOUDULE。

储存进程信息的结构体PROCESSENTRY32

typedef struct

>   { DWORD dwSize; // 结构的长度，必须预先设置

>   DWORD cntUsage; // 进程的引用记数

>   DWORD th32ProcessID; // 进程 ID

>   DWORD th32DefaultHeapID; // 进程默认堆的 ID

>   DWORD th32ModuleID; // 进程模块的 ID

>   DWORD cntThreads; // 进程创建的线程数

>   DWORD th32ParentProcessID; // 进程的父线程 ID

>   LONG pcPriClassBase; // 进程创建的线程的基本优先级

>   DWORD dwFlags; // 内部使用

>   CHAR szExeFile[MAX_PATH]; // 进程对应的可执行文件名

>   } PROCESSENTRY32;

**终止当前进程**

主线程的入口函数返回。

进程中一个线程调用了ExitProcess函数。

此进程中的所有线程都结束了。

其他进程中的一个线程调用了TerminateProcess函数

说明：

退出当前进程

void ExitProcess(UINT uExitCode); // 参数 uExitCode
为此程序的退出代码，当期那进程力科技术。

终止其他进程

BOOL TerminateProcess(

>   HANDLE hProcess, // 要结束的进程（目标进程）的句柄

>   UINT uExitCode // 指定目标进程的退出代码，你可以使用 GetExitCodeProcess
>   取得一个进程的退出代码

>   );//用来结束其他进程。

获取某个进程的句柄，方便对一个进程进行操作

HANDLE OpenProcess(

>   DWORD dwDesiredAccess, // 想得到的访问权限，可以是
>   PROCESS_ALL_ACCESS，所有可以进行的权限，PROCESS_QUERY_INFORMATION
>   查看该进程信息的权限……

>   BOOL bInheritHandle, // 指定返回的句柄是否可以被继承

>   DWORD dwProcessId // 指定要打开的进程的 ID 号

>   );

>   终止其他进程的代码示例

>   BOOL TerminateProcessFromId(DWORD dwId)

>   { BOOL bRet = FALSE;

>   // 打开目标进程，取得进程句柄

>   HANDLE hProcess = ::OpenProcess(PROCESS_ALL_ACCESS, FALSE, dwId);

>   if(hProcess != NULL)

>   { // 终止进程

>   bRet = ::TerminateProcess(hProcess, 0);

>   }

>   CloseHandle(hProcess);//注意句柄类型需要使用这个函数进行关闭

>   return bRet;

>   }

>   进程终止后会发生的事情

>   1\. 相关对象句柄都被关闭

>   2\. 进程内的线程终止执行

>   3\. 集成内核对象变为受信状态，所有等待在此对象上的线程开始运行。

>   4\. 系统将进程对象中退出代码的值由STILL_ACTIVE改为退出码。

**保护进程**

>   以下函数用来实现进程内存的读写。

>   BOOL ReadProcessMemory(

>   HANDLE hProcess, // 待读进程的句柄

>   LPCVOID lpBaseAddress, // 目标进程中待读内存的起始地址

>   LPVOID lpBuffer, // 用来接受读取数据的缓冲区

>   DWORD nSize, // 要读取的字节数

>   LPDWORD lpNumberOfBytesRead // 用来供函数返回实际读取的字节数

>   );

>   WriteProcessMemory( hProcess, lpBaseAddress, lpBuffer, nSize,
>   lpNumberOfBytesRead); // 参数含义同上

>   以下函数用来获取当前系统的版本信息

>   BOOL GetVersionEx(LPOSVERSIONINFO lpVersionInfo);

>   系统会将操作系统的版本信息返回到参数 lpVersionInfo 指向的 OSVERSIONINFO
>   结构中。

>   typedef struct OSVERSIONINFO {

>   DWORD dwOSVersionInfoSize; // 本结构的大小，必须在调用之前设置

>   DWORD dwMajorVersion; // 操作系统的主版本号

>   DWORD dwMinorVersion; // 操作系统的次版本号

>   DWORD dwBuildNumber; // 操作系统的编译版本号

>   DWORD dwPlatformId; // 操作系统平台。可以是 VER_PLATFORM_WIN32_NT（2000
>   系列）等

>   TCHAR szCSDVersion[128]; // 指定安装在系统上的最新服务包，例如“Service Pack
>   3”等

>   } OSVERSIONINFO;

**Windows程序设计中常见的类型。**

| BOOL/BOOLEAN                                                                                                                                                                                                                                                                      | 8bit,TRUE/FALSE                                | 布尔型                                                                            |   |
|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------|-----------------------------------------------------------------------------------|---|
| BYTE                                                                                                                                                                                                                                                                              | unsigned 8 bit                                 |                                                                                   |   |
| BSTR CComBSTR \_bstr_t                                                                                                                                                                                                                                                            | 32 bit                                         | BSTR是指向字符串的32位指针 是对BSTR的封装 是对BSTR的封装                          |   |
| CHAR                                                                                                                                                                                                                                                                              | 8 bit                                          | (ANSI）字符类型                                                                   |   |
| COLORREF                                                                                                                                                                                                                                                                          | 32 bit                                         | RGB颜色值 整型                                                                    |   |
| DWORD                                                                                                                                                                                                                                                                             | unsigned 32 bit                                | 整型                                                                              |   |
| FLOAT                                                                                                                                                                                                                                                                             | float型                                        | float型                                                                           |   |
| HANDLE                                                                                                                                                                                                                                                                            |                                                | Object句柄                                                                        |   |
| HBITMAP                                                                                                                                                                                                                                                                           |                                                | bitmap句柄                                                                        |   |
| HBRUSH                                                                                                                                                                                                                                                                            |                                                | brush句柄                                                                         |   |
| HCURSOR                                                                                                                                                                                                                                                                           |                                                | cursor句柄                                                                        |   |
| HDC                                                                                                                                                                                                                                                                               |                                                | 设备上下文句柄                                                                    |   |
| HFILE                                                                                                                                                                                                                                                                             |                                                | OpenFile打开的File句柄                                                            |   |
| HFONT                                                                                                                                                                                                                                                                             |                                                | font句柄                                                                          |   |
| HHOOK                                                                                                                                                                                                                                                                             |                                                | hook句柄                                                                          |   |
| HKEY                                                                                                                                                                                                                                                                              |                                                | 注册表键句柄                                                                      |   |
| HPEN                                                                                                                                                                                                                                                                              |                                                | pen句柄                                                                           |   |
| HWND                                                                                                                                                                                                                                                                              |                                                | window句柄                                                                        |   |
| INT                                                                                                                                                                                                                                                                               | 不同系统长度不同                               | 一般为32位                                                                        |   |
| LONG                                                                                                                                                                                                                                                                              | 不同系统长度不同                               | 一般为32位                                                                        |   |
| LONGLONG                                                                                                                                                                                                                                                                          |                                                | 64位带符号整型                                                                    |   |
| LPARAM                                                                                                                                                                                                                                                                            | 32 bit                                         | 消息参数                                                                          |   |
| LPBOOL                                                                                                                                                                                                                                                                            |                                                | BOOL型指针                                                                        |   |
| LPBYTE                                                                                                                                                                                                                                                                            |                                                | BYTE型指针                                                                        |   |
| LPCOLOREF                                                                                                                                                                                                                                                                         |                                                | COLORREF型指针                                                                    |   |
| LPCSTR/LPSTR/PCSTR                                                                                                                                                                                                                                                                |                                                | 指向8位（ANSI）字符串类型指针                                                     |   |
| LPCWSTR/LPWSTR/PCWSTR                                                                                                                                                                                                                                                             |                                                | 指向16位Unicode字符串类型                                                         |   |
| LPCTSTR/LPTSTR/PCTSTR                                                                                                                                                                                                                                                             |                                                | 指向一8位或16位字符串类型指针                                                     |   |
| LPVOID                                                                                                                                                                                                                                                                            |                                                | 指向一个未指定类型的32位指针                                                      |   |
| LPDWORD                                                                                                                                                                                                                                                                           |                                                | 指向一个DWORD型指针                                                               |   |
| 其他相似类型: LPHANDLE、LPINT、LPLONG、LPWORD、LPRESULT PBOOL、PBOOLEAN、PBYTE、PCHAR、PDWORD、PFLOAT、PHANDLE、PINT、PLONG、PSHORT…… 说明:(1)在16位系统中 LP为16bit,P为8bit,在32位系统中都是32bit(此时等价) (2)LPCSTR等 中的C指Const,T表示TCHAR模式即可以工作在ANSI下也可UNICODE |                                                |                                                                                   |   |
| SHORT                                                                                                                                                                                                                                                                             | usigned                                        | 整型                                                                              |   |
| 其他UCHAR、UINT、ULONG、ULONGLONG、USHORT为无符号相应类型                                                                                                                                                                                                                         |                                                |                                                                                   |   |
| TBYTE                                                                                                                                                                                                                                                                             |                                                | WCHAR型或者CHAR型                                                                 |   |
| TCHAR                                                                                                                                                                                                                                                                             |                                                | ANSI与unicode均可                                                                 |   |
| VARIANT \_variant_t COleVariant                                                                                                                                                                                                                                                   |                                                | 一个结构体参考OAIDL.H \_variant_t是VARIANT的封装类 COleVariant也是VARIANT的封装类 |   |
|                                                                                                                                                                                                                                                                                   |                                                |                                                                                   |   |
|                                                                                                                                                                                                                                                                                   |                                                |                                                                                   |   |
| WNDPROC                                                                                                                                                                                                                                                                           |                                                | 指向一个窗口过程的32位指针                                                        |   |
| WCHAR                                                                                                                                                                                                                                                                             |                                                | 16位Unicode字符型                                                                 |   |
| WORD                                                                                                                                                                                                                                                                              |                                                | 16位无符号整型                                                                    |   |
| WPARAM                                                                                                                                                                                                                                                                            |                                                | 消息参数                                                                          |   |
| MFC 独有 数据 类型                                                                                                                                                                                                                                                                | 下面两个数据类型是微软基础类库中独有的数据类型 |                                                                                   |   |
|                                                                                                                                                                                                                                                                                   | POSITION                                       | 标记集合中一个元素的位置的值 被MFC中的集合类所使用                                |   |
|                                                                                                                                                                                                                                                                                   | LPCRECT                                        | 指向一个RECT结构体常量（不能修改） 的32位指针                                     |   |
|                                                                                                                                                                                                                                                                                   | CString                                        | 其实是MFC中的一个类                                                               |   |
|                                                                                                                                                                                                                                                                                   |                                                |                                                                                   |   |

**Windows数据类型命名规律**

-   基本数据类型包括：BYTE、CHAR、WORD、SHORT、INT等。

-   指针类型的命令方式一般是在其指向的数据类型前加“LP”或“P”，比如指向DWORD的指针类型为“LPDWORD”和“PDWORD”

-   各种句柄类型的命名方式一般都是在对象名前加“H”，比如位图（BITMAP）对应的句柄类型为“HBITMAP”。

-   无符号类型一般是以“U”开头，比如“INT”是符号类型，“UINT”是无符号类型

-   DWORD实质上就是 unsigned long 数据类型，32位无符号整型。

-   而经常要用到的HANDLE类型实质上是无类型指针void,HANDLE定义为：

    typedof PVOID HANDLE;

    HANDLE实际上就是一个PVOID，那PVOID又是什么呢？

    Typeof void \*PVOID;

    PVOID就是指向void的指针。
