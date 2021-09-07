第二节第一个窗口程序

**创建窗口程序**

主函数为WinMain函数

int APIENTRY WinMain(HINSTANCE hInstance, // 本模块的实例句柄

>   HINSTANCE hPrevInstance, // Win16 留下的废物，现在已经不用了

>   LPSTR lpCmdLine, // 命令行参数

>   int nCmdShow) // 主窗口初始化时的显示方式

>   { // 下面这行代码是我添加的，用于弹出一个小对话框

>   ::MessageBox(NULL, "Hello, Win32 Application", "04Win32AppDemo", MB_OK);

>   return 0;

>   }

弹出窗口MessageBox函数

int MessageBox(

>   HWND hWnd, // 一个窗口句柄，它指定了哪一个窗口将拥有要创建的消息框

>   LPCTSTR lpText, // 将要显示的消息

>   LPCTSTR lpCaption, // 对话框的标题

>   UINT uType // 指定对话框的内容和行为

>   );

uType的取值

（1）为了指定希望在消息框中显示的按钮，要指定下组中的一个值：

| MB\_OK              | 消息框包含一个按钮：确定。这是默认按钮。 |
|---------------------|------------------------------------------|
| MB_OKCANCEL         | 消息框包含两个按钮：确定和取消           |
| MB_ABORTRETRYIGNORE | 消息框包含 3 个按钮：终止、重试和忽略    |
| MB_YESNOCANCEL      | 消息框包含 3 个按钮：是、否和取消        |
| MB_YESNO            | 消息框包含两个按钮：是和否               |
| MB_RETRYCANCEL      | 消息框包含两个按钮：重试和取消           |

（2）为了在对话框中显示一个图标，要指定下组中的一个值：

MB_ICONHAND 一个停止标志图标：

MB_ICONQUESTION 一个询问标志图标：

MB_ICONEXCLAMATION 一个感叹号图标：

（3）为了指示默认的选中按钮，要指定下组中的一个值：

MB_DEFBUTTON1 第一个按钮是选中按钮

MB_DEFBUTTON2 第二个按钮是选中按钮

MB_DEFBUTTON3 第三个按钮是选中按钮

MB_DEFBUTTON4 第四个按钮是选中按钮

**窗口应用程序实例**

// 窗口函数的函数原形

LRESULT CALLBACK MainWndProc(HWND, UINT, WPARAM, LPARAM);

int APIENTRY WinMain(HINSTANCE hInstance,

>   HINSTANCE hPrevInstance,

>   LPSTR lpCmdLine,

>   int nCmdShow)

{ char szClassName[] = "MainWClass";

>   WNDCLASSEX wndclass;

>   // 用描述主窗口的参数填充 WNDCLASSEX 结构

>   wndclass.cbSize = sizeof(wndclass); // 结构的大小

>   wndclass.style = CS_HREDRAW\|CS_VREDRAW; // 指定如果大小改变就重画

>   wndclass.lpfnWndProc = MainWndProc; // 窗口函数指针

>   wndclass.cbClsExtra = 0; // 没有额外的类内存

>   wndclass.cbWndExtra = 0; // 没有额外的窗口内存

>   wndclass.hInstance = hInstance; // 实例句柄

>   wndclass.hIcon = ::LoadIcon(NULL, IDI_APPLICATION); // 使用预定义图标

>   wndclass.hCursor = ::LoadCursor(NULL, IDC_ARROW); // 使用预定义的光标

>   wndclass.hbrBackground = (HBRUSH)::GetStockObject(WHITE_BRUSH); //
>   使用白色背景画刷

>   wndclass.lpszMenuName = NULL; // 不指定菜单

>   wndclass.lpszClassName = szClassName ; // 窗口类的名称

>   wndclass.hIconSm = NULL; // 没有类的小图标

>   // 注册这个窗口类

>   ::RegisterClassEx(&wndclass);

>   // 创建主窗口

>   HWND hwnd = ::CreateWindowEx(

>   0, // dwExStyle，扩展样式

>   szClassName, // lpClassName，类名

>   "My first Window!", // lpWindowName，标题

>   WS_OVERLAPPEDWINDOW, // dwStyle，窗口风格

>   CW_USEDEFAULT, // X，初始 X 坐标

>   CW_USEDEFAULT, // Y，初始 Y 坐标

>   CW_USEDEFAULT, // nWidth，宽度

>   CW_USEDEFAULT, // nHeight，高度

>   NULL, // hWndParent，父窗口句柄

>   NULL, // hMenu，菜单句柄

>   hInstance, // hlnstance，程序实例句柄

>   NULL) ; // lpParam，用户数据

>   if(hwnd == NULL)

>   { ::MessageBox(NULL, "创建窗口出错！ ", "error", MB_OK);

>   return -1;

}

>   // 显示窗口，刷新窗口客户区

>   ::ShowWindow(hwnd, nCmdShow);

>   ::UpdateWindow(hwnd);

>   // 从消息队列中取出消息，交给窗口函数处理，直到 GetMessage 返回
>   FALSE，结束消息循环

>   MSG msg;

>   while(::GetMessage(&msg, NULL, 0, 0))

>   { // 转化键盘消息

>   ::TranslateMessage(&msg);

>   // 将消息发送到相应的窗口函数

>   ::DispatchMessage(&msg);

>   }

>   // 当 GetMessage 返回 FALSE 时程序结束

>   return msg.wParam;

}

LRESULT CALLBACK MainWndProc (HWND hwnd, UINT message, WPARAM wParam, LPARAM
lParam)

{ char szText[] = "最简单的窗口程序！ ";

>   switch (message)

>   {

>   case WM_PAINT: // 窗口客户区需要重画

>   { HDC hdc;

>   PAINTSTRUCT ps;

>   // 使无效的客户区变的有效，并取得设备环境句柄

>   hdc = ::BeginPaint (hwnd, &ps) ;

>   // 显示文字

>   ::TextOut(hdc, 10, 10, szText, strlen(szText));

>   ::EndPaint(hwnd, &ps);

>   return 0;

>   }

>   case WM_DESTROY: // 正在销毁窗口

>   // 向消息队列投递一个 WM_QUIT 消息，促使 GetMessage 函数返回 0，结束消息循环

>   ::PostQuitMessage(0) ;

>   return 0 ;

}

// 将我们不处理的消息交给系统做默认处理

return ::DefWindowProc(hwnd, message, wParam, lParam);

}

**创建窗体的步骤说明：**

注册窗口类 RegisterClassEx

创建窗口 CreateWindowEx

在桌面显示窗口 ShowWindow

更新窗口客户区 UpdateWindow，发送了WM_PAINDT 消息更新他的客户区

进入无线的消息获取消息，转化键盘消息，将消息转发给消息处理函数GetMessage
\-\>TranslateMessage-\> DispatchMessage

**注册窗口结构体说明**

typedef struct \_WNDCLASSEX {

>   UINT cbSize; // WNDCLASSEX 结构的大小

>   UINT style; // 从这个窗口类派生的窗口具有的风格,有多种风格

>   WNDPROC lpfnWndProc; // 即 window procedure, 窗口消息处理函数指针

>   int cbClsExtra; // 指定紧跟在窗口类结构后的附加字节数

>   int cbWndExtra; // 指定紧跟在窗口事例后的附加字节数

>   HANDLE hInstance; // 本模块的实例句柄

>   HICON hIcon; // 窗口左上角图标的句柄

>   HCURSOR hCursor; // 光标的句柄

>   HBRUSH hbrBackground; // 背景画刷的句柄

>   LPCTSTR lpszMenuName; // 菜单名

>   LPCTSTR lpszClassName; // 该窗口类的名称

>   HICON hIconSm; // 小图标句柄

} WNDCLASSEX;

**消息结构体说明**

typedef struct tagMSG {

>   HWND hwnd; // 消息要发向的窗口句柄

>   UINT message; // 消息标识符，以 WM\_ 开头的预定义值（意为 Window Message）

>   WPARAM wParam; // 消息的参数之一

>   LPARAM lParam; // 消息的参数之二

>   DWORD time; // 消息放入消息队列的时间

>   POINT pt; // 这是一个 POINT 数据结构，表示消息放入消息队列时的鼠标位置

} MSG, \*PMSG ;

第二节一个简陋的打字程序

**使用资源**

.rc
资源文件的源文件的脚本。由资源编译器RC.exe编译成res为扩展名的二进制文件。在链接的时候由Link.exe链入到可执行文件中。

resource.h
资源文件的生命文件。给资源一个ID好，通过资源的ID进行访问。一般通过资源管理器添加资源，直接生成相应的资源文件的脚本文件和声明文件。

**菜单和图标**

可以直接插入菜单资源。

动态设置菜单的方式：

HMENU hMenu = ::LoadMenu(::GetModuleHandle(NULL),(LPCTSTR)IDR_TYPER);

::SetMenu(hwnd,hMenu)

通过这种方式能够动态改变主窗体的菜单栏。

点击菜单之后会接收到**WM_COMMAND消息**，使用LOWORD宏从wparam参数中能够取出某个菜单的对应ID。单击后会通过SendMessage函数向窗口发送消息。

>   LRESULT CALLBACK WndProc(HWND hWnd, UINT message, WPARAM wParam, LPARAM
>   lParam)

>   {

>   int wmId, wmEvent;

>   PAINTSTRUCT ps;

>   HDC hdc;

>   char szText[] = "最简单的窗口应用程序哈哈哈";

>   switch (message)

>   {

>   case WM_COMMAND:

>   wmId = LOWORD(wParam);

>   wmEvent = HIWORD(wParam);

>   // 分析菜单选择:

>   switch (wmId)

>   {

>   case IDM_ABOUT:

>   DialogBox(hInst, MAKEINTRESOURCE(IDD_ABOUTBOX), hWnd, About);

>   break;

>   case IDM_EXIT:

>   DestroyWindow(hWnd);

>   break;

>   default:

>   return DefWindowProc(hWnd, message, wParam, lParam);

>   }

>   break;

>   case WM_PAINT:

>   //DefWindowProc会进行默认处理

>   hdc = BeginPaint(hWnd, &ps);

>   // TODO: 在此添加任意绘图代码...

>   ::TextOut(hdc, 10, 10,szText,strlen(szText));

>   EndPaint(hWnd, &ps);

>   break;

>   case WM_DESTROY:

>   PostQuitMessage(0);

>   break;

>   default:

>   return DefWindowProc(hWnd, message, wParam, lParam);

>   }

>   return 0;

>   }

发送消息的方式：

SendMessage函数发送消息，并阻塞源程序

PostMessage函数发送消息后立即返回

设置图标

wndclass.hIcon = ::LoadIcon(hInstance, (LPSTR)IDI_TYPER); // 使用自定义图标

**接受键盘的输入**

当一个 WM_KEYDOWN 消息被 TranslateMessage 函数转化以后会有一个 WM_CHAR 消

息产生，此消息的 wParam 参数包含了按键的 ANSI 码。例如，用户敲击一次“Ａ”键，窗口

会顺序地收到以下 3 个消息。

| WM\_KEYDOWN | lParam 的含义为虚拟键码“A” (0x41) |
|-------------|-----------------------------------|
| WM_CHAR     | lParam 的含义为 ANSI 码“a” (0x61) |
| WM_KEYUP    | lParam 的含义为虚拟键码“A” (0x41) |

**接受鼠标输入**

>   应用程序以接收发送或者投递到它的窗口的消息的形式接收鼠标输入。当用户移动鼠标，

>   或按下、释放鼠标的一个键时，鼠标会产生输入事件。系统将鼠标输入事件转化成消息，投递

>   它们到相应线程的消息队列。和处理键盘输入一样， Windows
>   将捕捉鼠标动作，并把它们发

>   送到相关窗口。

>   当用户移动光标到窗口的客户区时，系统投递 WM_MOUSEMOVE 消息到这个窗口。当

>   用户在客户区按下或者释放鼠标的键时，它投递下面的消息：

>   按下 弹起 双击

>   左键 WM_LBUTTONDOWN WM_LBUTTONUP WM_LBUTTONDBLCLK

>   中键 WM_MBUTTONDOWN WM_MBUTTONUP WM_MBUTTONDBLCLK

>   右键 WM_RBUTTONDOWN WM_RBUTTONUP WM_RBUTTONDBLCLK

>   发送这些消息时， lParam 参数包含了鼠标的位置坐标，可以这样读出坐标信息。

>   xPos = LOWORD (lParam);

>   yPos = HIWORD (lParam)

实现坐标转化的函数

>   这些坐标都以客户区的左上角为原点，向右是 x 轴正方向，向下是 y 轴正方向。

>   ClientToScreen 函数可以把坐标转化为以屏幕的左上角为原点的坐标。

>   BOOL ClientToScreen(HWND hWnd, LPPOINT lpPoint) ;

>   BOOL ScreenToClient(HWND hWnd, LPPOINT lpPoint );

wParam 参数包含鼠标按钮的状态，这些状态都以 MK\_（意为 mouse key）为前缀，，取值

如下：

| MK_LBUTTON  |  左键按下       |
|-------------|-----------------|
| MK_MBUTTON  | 中间的键按下    |
| MK_RBUTTON  | 右键按下        |
| MK_SHIFT    | \<Shift\>键按下 |
| MK_CONTROL  | \<Ctrl\>键按下  |

**设置文本和背景**

>   设置背景色为：

>   wcex.hbrBackground = (HBRUSH)(COLOR_3DFACE + 1);

设置文本色

::SetTextColor(hdc, RGB(255, 0, 0));

::SetBkColor(hdc, ::GetSysColor(COLOR_3DFACE));

第四节GDI基本图形

**设备环境**

理解一下几个含义：

应用实例：HINSTANCE，表示整个应用实例

主窗体：hwnd，表示应用实例的主窗体，是一个窗体，不是应用实例

窗口客户区：主窗体客户区指的是窗体中菜单下边的内容，客户区，主要县市区

窗口客户区设备环境句柄：HDC绘图的句柄，可以是主窗体的设备环境也可以是主窗体客户区的设备环境的句柄。

**文本区域绘制**

case WM_LBUTTONDOWN:

>   hdc = ::GetDC(hWnd);

>   // 设置 DC 结构中的文本颜色为红色（下一小节我们再介绍 Windows 下的颜色）

>   ::SetTextColor(hdc, RGB(255, 0, 0));

>   // 设置 DC 结构中的文本背景颜色为蓝色

>   ::SetBkColor(hdc, RGB(0, 0, 255));

>   ::TextOut(hdc, 10, 10, sz, strlen(sz));

>   ::ReleaseDC(hWnd, hdc);

>   break;

在注册窗口类时，向 WNDCLASSEX结构的 style 成员添加一个 CS_OWNDC
标志，可以保存每次修改的内容。如果不设置的话，每次刷新窗口又会变为默认的设置，而不是左键点击后的设置。

wcex.style = CS_HREDRAW \| CS_VREDRAW \| CS_OWNDC;

**颜色和像素点**

**RGB**颜色RGB（255，255，255）

像素点颜色设置

>   COLORREF SetPixel(

>   HDC hdc, // 设备环境句柄

>   int X, // 象素的 X 坐标

>   int Y, // 象素的 Y 坐标

>   COLORREF crColor // 要设置的 COLORREF 值

>   );

>   像素点颜色获取

>   COLORREF GetPixel( HDC hdc, int nXPos, int nYPos);

**绘制线条**

LineTo函数绘制直线。MoveToEx可以设置当前点。

::MoveToEx(hDC, 0, 0, NULL);

::LineTo(hDC, 0, 500);

BOOL MoveToEx(

>   HDC hdc, // 设备环境句柄

>   int X, // 新位置的 X 坐标

>   int Y, // 新位置的 Y 坐标

>   LPPOINT lpPoint //
>   用来返回原来的当前点位置，如果不需要的话，这个参数可以被设为 NULL)

使用GetClientRect函数获取窗口客户区的大小。

使用Polyline函数绘制相连的多条线段。

>   BOOL Polyline(HDC hdc, CONST POINT \*lpPoint, int cPoints);

>   BOOL PolylineTo(HDC hdc, CONST POINT \*lpPoint, DWORD cPoints );

>   lpPoint是指向POINT的数组的指针。

**绘制区域**

Rectangle(hdc, x1, y1, x2, y2); // 画以（x1, y1）和（x2,
y2）为对角坐标的填充矩形

>   Ellipse(hdc, x1, y1, x2, y2); // 以（x1, y1）和（x2,
>   y2）为对角坐标定义一个矩形，然后画矩形相切的椭

>   // 圆并填充

>   Polygon(hdc, lpPoint, 5) // lpPoint 指向存放（x0, y0）到（x4,
>   y4）的内存，函数从（x1, y1）到（x2, y2）...

>   // 到（x4, y4），再回到（x1, y1），一共画 5 条直线并填充

**坐标系统**

**实例：小时钟**

几个缩写的含义说明

WND window

WS window style

CS class style

WM window message
