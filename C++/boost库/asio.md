 本章介绍了 Boost C++ 库 Asio，它是异步输入输出的核心。 名字本身就说明了一切：Asio 意即异步输入/输出。 该库可以让 C++ 异步地处理数据，且平台独立。 异步数据处理就是指，任务触发后不需要等待它们完成。 相反，Boost.Asio 会在任务完成时触发一个应用。 异步任务的主要优点在于，在等待任务完成时不需要阻塞应用程序，可以去执行其它任务。
 
 异步任务的典型例子是网络应用。 如果数据被发送出去了，比如发送至 Internet，通常需要知道数据是否发送成功。 如果没有一个象 Boost.Asio 这样的库，就必须对函数的返回值进行求值。 但是，这样就要求待至所有数据发送完毕，并得到一个确认或是错误代码。 而使用 Boost.Asio，这个过程被分为两个单独的步骤：第一步是作为一个异步任务开始数据传输。 一旦传输完成，不论成功或是错误，应用程序都会在第二步中得到关于相应的结果通知。 主要的区别在于，应用程序无需阻塞至传输完成，而可以在这段时间里执行其它操作。
 7.2. I/O 服务与 I/O 对象
 
 使用 Boost.Asio 进行异步数据处理的应用程序基于两个概念：I/O 服务和 I/O 对象。 I/O 服务抽象了操作系统的接口，允许第一时间进行异步数据处理，而 I/O 对象则用于初始化特定的操作。 鉴于 Boost.Asio 只提供了一个名为 boost::asio::io_service 的类作为 I/O 服务，它针对所支持的每一个操作系统都分别实现了优化的类，另外库中还包含了针对不同 I/O 对象的几个类。 其中，类 boost::asio::ip::tcp::socket 用于通过网络发送和接收数据，而类  boost::asio::deadline_timer 则提供了一个计时器，用于测量某个固定时间点到来或是一段指定的时长过去了。 以下第一个例子中就使用了计时器，因为与 Asio 所提供的其它 I/O 对象相比较而言，它不需要任何有关于网络编程的知识。


 #include <boost/asio.hpp> 
 #include <iostream> 
 
 void handler(const boost::system::error_code &ec) 
 { 
   std::cout << "5 s." << std::endl; 
 } 
 
 int main() 
 { 
   boost::asio::io_service io_service; 
   boost::asio::deadline_timer timer(io_service, boost::posix_time::seconds(5)); 
   timer.async_wait(handler); 
   io_service.run(); 
 } 
 
函数 main() 首先定义了一个 I/O 服务 io_service，用于初始化 I/O 对象 timer。 就象 boost::asio::deadline_timer 那样，所有 I/O 对象通常都需要一个 I/O 服务作为它们的构造函数的第一个参数。 由于 timer 的作用类似于一个闹钟，所以 boost::asio::deadline_timer 的构造函数可以传入第二个参数，用于表示在某个时间点或是在某段时长之后闹钟停止。 以上例子指定了五秒的时长，该闹钟在 timer 被定义之后立即开始计时。
 
 虽然我们可以调用一个在五秒后返回的函数，但是通过调用方法 async_wait() 并传入 handler() 函数的名字作为唯一参数，可以让 Asio 启动一个异步操作。 请留意，我们只是传入了 handler() 函数的名字，而该函数本身并没有被调用。
 
 async_wait() 的好处是，该函数调用会立即返回，而不是等待五秒钟。 一旦闹钟时间到，作为参数所提供的函数就会被相应调用。 因此，应用程序可以在调用了 async_wait() 之后执行其它操作，而不是阻塞在这里。
 
 象 async_wait() 这样的方法被称为是非阻塞式的。 I/O 对象通常还提供了阻塞式的方法，可以让执行流在特定操作完成之前保持阻塞。 例如，可以调用阻塞式的 wait() 方法，取代 boost::asio::deadline_timer 的调用。 由于它会阻塞调用，所以它不需要传入一个函数名，而是在指定时间点或指定时长之后返回。
 
 再看看上面的源代码，可以留意到在调用 async_wait() 之后，又在 I/O 服务之上调用了一个名为 run() 的方法。这是必须的，因为控制权必须被操作系统接管，才能在五秒之后调用 handler() 函数。
 
 async_wait() 会启动一个异步操作并立即返回，而 run() 则是阻塞的。因此调用 run() 后程序执行会停止。 具有讽刺意味的是，许多操作系统只是通过阻塞函数来支持异步操作。 以下例子显示了为什么这个限制通常不会成为问题。


 #include <boost/asio.hpp> 
 #include <iostream> 
 
 void handler1(const boost::system::error_code &ec) 
 { 
   std::cout << "5 s." << std::endl; 
 } 
 
 void handler2(const boost::system::error_code &ec) 
 { 
   std::cout << "10 s." << std::endl; 
 } 
 
 int main() 
 { 
   boost::asio::io_service io_service; 
   boost::asio::deadline_timer timer1(io_service, boost::posix_time::seconds(5)); 
   timer1.async_wait(handler1); 
   boost::asio::deadline_timer timer2(io_service, boost::posix_time::seconds(10)); 
   timer2.async_wait(handler2); 
   io_service.run(); 
 } 
 
上面的程序用了两个 boost::asio::deadline_timer 类型的 I/O 对象。 第一个 I/O 对象表示一个五秒后触发的闹钟，而第二个则表示一个十秒后触发的闹钟。 每一段指定时长过去后，都会相应地调用函数 handler1() 和 handler2()。
 
 在 main() 的最后，再次在唯一的 I/O 服务之上调用了 run() 方法。 如前所述，这个函数将阻塞执行，把控制权交给操作系统以接管异步处理。 在操作系统的帮助下，handler1() 函数会在五秒后被调用，而 handler2() 函数则在十秒后被调用。
 
 乍一看，你可能会觉得有些奇怪，为什么异步处理还要调用阻塞式的 run() 方法。 然而，由于应用程序必须防止被中止执行，所以这样做实际上不会有任何问题。 如果 run() 不是阻塞的，main() 就会结束从而中止该应用程序。 如果应用程序不应被阻塞，那么就应该在一个新的线程内部调用 run()，它自然就会仅仅阻塞那个线程。
 
 一旦特定的 I/O 服务的所有异步操作都完成了，控制权就会返回给 run() 方法，然后它就会返回。 以上两个例子中，应用程序都会在闹钟到时间后马上结束。
 7.3. 可扩展性与多线程
 
 用 Boost.Asio 这样的库来开发应用程序，与一般的 C++ 风格不同。 那些可能需要较长时间才返回的函数不再是以顺序的方式来调用。 不再是调用阻塞式的函数，Boost.Asio 是启动一个异步操作。 而那些需要在操作结束后调用的函数则实现为相应的句柄。 这种方法的缺点是，本来顺序执行的功能变得在物理上分割开来了，从而令相应的代码更难理解。
 
 象 Boost.Asio 这样的库通常是为了令应用程序具有更高的效率。 应用程序不需要等待特定的函数执行完成，而可以在期间执行其它任务，如开始另一个需要较长时间的操作。
 
 可扩展性是指，一个应用程序从新增资源有效地获得好处的能力。 如果那些执行时间较长的操作不应该阻塞其它操作的话，那么建议使用 Boost.Asio. 由于现今的PC机通常都具有多核处理器，所以线程的应用可以进一步提高一个基于 Boost.Asio 的应用程序的可扩展性。
 
 如果在某个 boost::asio::io_service 类型的对象之上调用 run() 方法，则相关联的句柄也会在同一个线程内被执行。 通过使用多线程，应用程序可以同时调用多个 run() 方法。 一旦某个异步操作结束，相应的 I/O 服务就将在这些线程中的某一个之中执行句柄。 如果第二个操作在第一个操作之后很快也结束了，则 I/O 服务可以在另一个线程中执行句柄，而无需等待第一个句柄终止。


 #include <boost/asio.hpp> 
 #include <boost/thread.hpp> 
 #include <iostream> 
 
 void handler1(const boost::system::error_code &ec) 
 { 
   std::cout << "5 s." << std::endl; 
 } 
 
 void handler2(const boost::system::error_code &ec) 
 { 
   std::cout << "5 s." << std::endl; 
 } 
 
 boost::asio::io_service io_service; 
 
 void run() 
 { 
   io_service.run(); 
 } 
 
 int main() 
 { 
   boost::asio::deadline_timer timer1(io_service, boost::posix_time::seconds(5)); 
   timer1.async_wait(handler1); 
   boost::asio::deadline_timer timer2(io_service, boost::posix_time::seconds(5)); 
   timer2.async_wait(handler2); 
   boost::thread thread1(run); 
   boost::thread thread2(run); 
   thread1.join(); 
   thread2.join(); 
 } 
上一节中的例子现在变成了一个多线程的应用。 通过使用在 boost/thread.hpp 中定义的 boost::thread 类，它来自于 Boost C++ 库 Thread，我们在 main() 中创建了两个线程。 这两个线程均针对同一个 I/O 服务调用了 run() 方法。 这样当异步操作完成时，这个 I/O 服务就可以使用两个线程去执行句柄函数。
 
 这个例子中的两个计时数均被设为在五秒后触发。 由于有两个线程，所以 handler1() 和 handler2() 可以同时执行。 如果第二个计时器触发时第一个仍在执行，则第二个句柄就会在第二个线程中执行。 如果第一个计时器的句柄已经终止，则 I/O 服务可以自由选择任一线程。
 
 线程可以提高应用程序的性能。 因为线程是在处理器内核上执行的，所以创建比内核数更多的线程是没有意义的。 这样可以确保每个线程在其自己的内核上执行，而没有同一内核上的其它线程与之竞争。
 
 要注意，使用线程并不总是值得的。 以上例子的运行会导致不同信息在标准输出流上混合输出，因为这两个句柄可能会并行运行，访问同一个共享资源：标准输出流 std::cout。 这种访问必须被同步，以保证每一条信息在另一个线程可以向标准输出流写出另一条信息之前被完全写出。 在这种情形下使用线程并不能提供多少好处，如果各个独立句柄不能独立地并行运行。
 
 多次调用同一个 I/O 服务的 run() 方法，是为基于 Boost.Asio 的应用程序增加可扩展性的推荐方法。 另外还有一个不同的方法：不要绑定多个线程到单个 I/O 服务，而是创建多个 I/O 服务。 然后每一个 I/O 服务使用一个线程。 如果 I/O 服务的数量与系统的处理器内核数量相匹配，则异步操作都可以在各自的内核上执行。


 #include <boost/asio.hpp> 
 #include <boost/thread.hpp> 
 #include <iostream> 
 
 void handler1(const boost::system::error_code &ec) 
 { 
   std::cout << "5 s." << std::endl; 
 } 
 
 void handler2(const boost::system::error_code &ec) 
 { 
   std::cout << "5 s." << std::endl; 
 } 
 
 boost::asio::io_service io_service1; 
 boost::asio::io_service io_service2; 
 
 void run1() 
 { 
   io_service1.run(); 
 } 
 
 void run2() 
 { 
   io_service2.run(); 
 } 
 
 int main() 
 { 
   boost::asio::deadline_timer timer1(io_service1, boost::posix_time::seconds(5)); 
   timer1.async_wait(handler1); 
   boost::asio::deadline_timer timer2(io_service2, boost::posix_time::seconds(5)); 
   timer2.async_wait(handler2); 
   boost::thread thread1(run1); 
   boost::thread thread2(run2); 
   thread1.join(); 
   thread2.join(); 
 } 
 
前面的那个使用两个计时器的例子被重写为使用两个 I/O 服务。 这个应用程序仍然基于两个线程；但是现在每个线程被绑定至不同的 I/O 服务。 此外，两个 I/O 对象 timer1 和 timer2 现在也被绑定至不同的 I/O 服务。
 
 这个应用程序的功能与前一个相同。 在一定条件下使用多个 I/O 服务是有好处的，每个 I/O 服务有自己的线程，最好是运行在各自的处理器内核上，这样每一个异步操作连同它们的句柄就可以局部化执行。 如果没有远端的数据或函数需要访问，那么每一个 I/O 服务就象一个小的自主应用。 这里的局部和远端是指象高速缓存、内存页这样的资源。 由于在确定优化策略之前需要对底层硬件、操作系统、编译器以及潜在的瓶颈有专门的了解，所以应该仅在清楚这些好处的情况下使用多个 I/O 服务。
 7.4. 网络编程
 
 虽然 Boost.Asio 是一个可以异步处理任何种类数据的库，但是它主要被用于网络编程。 这是由于，事实上 Boost.Asio 在加入其它 I/O 对象之前很久就已经支持网络功能了。 网络功能是异步处理的一个很好的例子，因为通过网络进行数据传输可能会需要较长时间，从而不能直接获得确认或错误条件。
 
 Boost.Asio 提供了多个 I/O 对象以开发网络应用。 以下例子使用了 boost::asio::ip::tcp::socket 类来建立与中另一台PC的连接，并下载 'Highscore' 主页；就象一个浏览器在指向 www.highscore.de 时所要做的。


 #include <boost/asio.hpp> 
 #include <boost/array.hpp> 
 #include <iostream> 
 #include <string> 
 
 boost::asio::io_service io_service; 
 boost::asio::ip::tcp::resolver resolver(io_service); 
 boost::asio::ip::tcp::socket sock(io_service); 
 boost::array<char, 4096> buffer; 
 
 void read_handler(const boost::system::error_code &ec, std::size_t bytes_transferred) 
 { 
   if (!ec) 
   { 
     std::cout << std::string(buffer.data(), bytes_transferred) << std::endl; 
     sock.async_read_some(boost::asio::buffer(buffer), read_handler); 
   } 
 } 
 
 void connect_handler(const boost::system::error_code &ec) 
 { 
   if (!ec) 
   { 
     boost::asio::write(sock, boost::asio::buffer("GET / HTTP 1.1\r\nHost: highscore.de\r\n\r\n")); 
     sock.async_read_some(boost::asio::buffer(buffer), read_handler); 
   } 
 } 
 
 void resolve_handler(const boost::system::error_code &ec, boost::asio::ip::tcp::resolver::iterator it) 
 { 
   if (!ec) 
   { 
     sock.async_connect(*it, connect_handler); 
   } 
 } 
 
 int main() 
 { 
   boost::asio::ip::tcp::resolver::query query("www.highscore.de", "80"); 
   resolver.async_resolve(query, resolve_handler); 
   io_service.run(); 
 } 
这个程序最明显的部分是三个句柄的使用：connect_handler() 和 read_handler() 函数会分别在连接被建立后以及接收到数据后被调用。 那么为什么需要 resolve_handler() 函数呢？
 
 互联网使用了所谓的IP地址来标识每台PC。 IP地址实际上只是一长串数字，难以记住。 而记住象 www.highscore.de 这样的名字就容易得多。 为了在互联网上使用类似的名字，需要通过一个叫作域名解析的过程将它们翻译成相应的IP地址。 这个过程由所谓的域名解析器来完成，对应的 I/O 对象是：boost::asio::ip::tcp::resolver。
 
 域名解析也是一个需要连接到互联网的过程。 有些专门的PC，被称为DNS服务器，其作用就象是电话本，它知晓哪个IP地址被赋给了哪台PC。 由于这个过程本身的透明的，只要明白其背后的概念以及为何需要 boost::asio::ip::tcp::resolver I/O 对象就可以了。 由于域名解析不是发生在本地的，所以它也被实现为一个异步操作。 一旦域名解析成功或被某个错误中断，resolve_handler() 函数就会被调用。
 
 因为接收数据需要一个成功的连接，进而需要一次成功的域名解析，所以这三个不同的异步操作要以三个不同的句柄来启动。 resolve_handler() 访问 I/O 对象 sock，用由迭代器 it 所提供的解析后地址创建一个连接。 而 sock 也在 connect_handler() 的内部被使用，发送 HTTP 请求并启动数据的接收。 因为所有这些操作都是异步的，各个句柄的名字被作为参数传递。 取决于各个句柄，需要相应的其它参数，如指向解析后地址的迭代器 it 或用于保存接收到的数据的缓冲区 buffer。
 
 开始执行后，该应用将创建一个类型为 boost::asio::ip::tcp::resolver::query 的对象 query，表示一个查询，其中含有名字 www.highscore.de 以及互联网常用的端口80。 这个查询被传递给 async_resolve() 方法以解析该名字。 最后，main() 只要调用 I/O 服务的 run() 方法，将控制交给操作系统进行异步操作即可。
 
 当域名解析的过程完成后，resolve_handler() 被调用，检查域名是否能被解析。 如果解析成功，则存有错误条件的对象 ec 被设为0。 只有在这种情况下，才会相应地访问 socket 以创建连接。 服务器的地址是通过类型为 boost::asio::ip::tcp::resolver::iterator 的第二个参数来提供的。
 
 调用了 async_connect() 方法之后，connect_handler() 会被自动调用。 在该句柄的内部，会访问 ec 对象以检查连接是否已建立。 如果连接是有效的，则对相应的 socket 调用 async_read_some() 方法，启动读数据操作。 为了保存接收到的数据，要提供一个缓冲区作为第一个参数。 在以上例子中，缓冲区的类型是 boost::array，它来自 Boost C++ 库 Array，定义于 boost/array.hpp.
 
 每当有一个或多个字节被接收并保存至缓冲区时，read_handler() 函数就会被调用。 准确的字节数通过 std::size_t 类型的参数 bytes_transferred 给出。 同样的规则，该句柄应该首先看看参数 ec 以检查有没有接收错误。 如果是成功接收，则将数据写出至标准输出流。
 
 请留意，read_handler() 在将数据写出至 std::cout 之后，会再次调用 async_read_some() 方法。 这是必需的，因为无法保证仅在一次异步操作中就可以接收到整个网页。 async_read_some() 和 read_handler() 的交替调用只有当连接被破坏时才中止，如当 web 服务器已经传送完整个网页时。 这种情况下，在 read_handler() 内部将报告一个错误，以防止进一步将数据输出至标准输出流，以及进一步对该 socket 调用 async_read()  方法。 这时该例程将停止，因为没有更多的异步操作了。
 
 上个例子是用来取出 www.highscore.de 的网页的，而下一个例子则示范了一个简单的 web 服务器。 其主要差别在于，这个应用不会连接至其它PC，而是等待连接。


 #include <boost/asio.hpp> 
 #include <string> 
 
 boost::asio::io_service io_service; 
 boost::asio::ip::tcp::endpoint endpoint(boost::asio::ip::tcp::v4(), 80); 
 boost::asio::ip::tcp::acceptor acceptor(io_service, endpoint); 
 boost::asio::ip::tcp::socket sock(io_service); 
 std::string data = "HTTP/1.1 200 OK\r\nContent-Length: 13\r\n\r\nHello, world!"; 
 
 void write_handler(const boost::system::error_code &ec, std::size_t bytes_transferred) 
 { 
 } 
 
 void accept_handler(const boost::system::error_code &ec) 
 { 
   if (!ec) 
   { 
     boost::asio::async_write(sock, boost::asio::buffer(data), write_handler); 
   } 
 } 
 
 int main() 
 { 
   acceptor.listen(); 
   acceptor.async_accept(sock, accept_handler); 
   io_service.run(); 
 } 
类型为 boost::asio::ip::tcp::acceptor 的 I/O 对象 acceptor - 被初始化为指定的协议和端口号 - 用于等待从其它PC传入的连接。 初始化工作是通过 endpoint 对象完成的，该对象的类型为 boost::asio::ip::tcp::endpoint，将本例子中的接收器配置为使用端口80来等待 IP v4 的传入连接，这是 WWW 通常所使用的端口和协议。
 
 接收器初始化完成后，main() 首先调用 listen() 方法将接收器置于接收状态，然后再用 async_accept() 方法等待初始连接。 用于发送和接收数据的 socket 被作为第一个参数传递。
 
 当一个PC试图建立一个连接时，accept_handler() 被自动调用。 如果该连接请求成功，就执行自由函数 boost::asio::async_write() 来通过 socket 发送保存在 data 中的信息。 boost::asio::ip::tcp::socket 还有一个名为 async_write_some() 的方法也可以发送数据；不过它会在发送了至少一个字节之后调用相关联的句柄。 该句柄需要计算还剩余多少字节，并反复调用 async_write_some() 直至所有字节发送完毕。 而使用  boost::asio::async_write() 可以避免这些，因为这个异步操作仅在缓冲区的所有字节都被发送后才结束。
 
 在这个例子中，当所有数据发送完毕，空函数 write_handler() 将被调用。 由于所有异步操作都已完成，所以应用程序终止。 与其它PC的连接也被相应关闭。
 7.5. 开发 Boost.Asio 扩展
 
 虽然 Boost.Asio 主要是支持网络功能的，但是加入其它 I/O 对象以执行其它的异步操作也非常容易。 本节将介绍 Boost.Asio 扩展的一个总体布局。 虽然这不是必须的，但它为其它扩展提供了一个可行的框架作为起点。
 
 要向 Boost.Asio 中增加新的异步操作，需要实现以下三个类：
 
     一个派生自 boost::asio::basic_io_object 的类，以表示新的 I/O 对象。使用这个新的 Boost.Asio 扩展的开发者将只会看到这个 I/O 对象。
 
     一个派生自 boost::asio::io_service::service 的类，表示一个服务，它被注册为 I/O 服务，可以从 I/O 对象访问它。 服务与 I/O 对象之间的区别是很重要的，因为在任意给定的时间点，每个 I/O 服务只能有一个服务实例，而一个服务可以被多个 I/O 对象访问。
 
     一个不派生自任何其它类的类，表示该服务的具体实现。 由于在任意给定的时间点每个 I/O 服务只能有一个服务实例，所以服务会为每个 I/O 对象创建一个其具体实现的实例。 该实例管理与相应 I/O 对象有关的内部数据。
 
 本节中开发的 Boost.Asio 扩展并不仅仅提供一个框架，而是模拟一个可用的 boost::asio::deadline_timer 对象。 它与原来的 boost::asio::deadline_timer 的区别在于，计时器的时长是作为参数传递给 wait() 或 async_wait() 方法的，而不是传给构造函数。

#include <boost/asio.hpp> 
 #include <cstddef> 
 
 template <typename Service> 
 class basic_timer 
   : public boost::asio::basic_io_object<Service> 
 { 
   public: 
     explicit basic_timer(boost::asio::io_service &io_service) 
       : boost::asio::basic_io_object<Service>(io_service) 
     { 
     } 
 
     void wait(std::size_t seconds) 
     { 
       return this->service.wait(this->implementation, seconds); 
     } 
 
     template <typename Handler> 
     void async_wait(std::size_t seconds, Handler handler) 
     { 
       this->service.async_wait(this->implementation, seconds, handler); 
     } 
 }; 
每个 I/O 对象通常被实现为一个模板类，要求以一个服务来实例化 - 通常就是那个特定为此 I/O 对象开发的服务。 当一个 I/O 对象被实例化时，该服务会通过父类 boost::asio::basic_io_object 自动注册为 I/O 服务，除非它之前已经注册。 这样可确保任何 I/O 对象所使用的服务只会每个 I/O 服务只注册一次。
 
 在 I/O 对象的内部，可以通过 service 引用来访问相应的服务，通常的访问就是将方法调用前转至该服务。 由于服务需要为每一个 I/O 对象保存数据，所以要为每一个使用该服务的 I/O 对象自动创建一个实例。 这还是在父类 boost::asio::basic_io_object 的帮助下实现的。 实际的服务实现被作为一个参数传递给任一方法调用，使得服务可以知道是哪个 I/O 对象启动了这次调用。 服务的具体实现是通过 implementation 属性来访问的。
 
 一般一上谕，I/O 对象是相对简单的：服务的安装以及服务实现的创建都是由父类 boost::asio::basic_io_object 来完成的，方法调用则只是前转至相应的服务；以 I/O 对象的实际服务实现作为参数即可。


 #include <boost/asio.hpp> 
 #include <boost/thread.hpp> 
 #include <boost/bind.hpp> 
 #include <boost/scoped_ptr.hpp> 
 #include <boost/shared_ptr.hpp> 
 #include <boost/weak_ptr.hpp> 
 #include <boost/system/error_code.hpp> 
 
 template <typename TimerImplementation = timer_impl> 
 class basic_timer_service 
   : public boost::asio::io_service::service 
 { 
   public: 
     static boost::asio::io_service::id id; 
 
     explicit basic_timer_service(boost::asio::io_service &io_service) 
       : boost::asio::io_service::service(io_service), 
       async_work_(new boost::asio::io_service::work(async_io_service_)), 
       async_thread_(boost::bind(&boost::asio::io_service::run, &async_io_service_)) 
     { 
     } 
 
     ~basic_timer_service() 
     { 
       async_work_.reset(); 
       async_io_service_.stop(); 
       async_thread_.join(); 
     } 
 
     typedef boost::shared_ptr<TimerImplementation> implementation_type; 
 
     void construct(implementation_type &impl) 
     { 
       impl.reset(new TimerImplementation()); 
     } 
 
     void destroy(implementation_type &impl) 
     { 
       impl->destroy(); 
       impl.reset(); 
     } 
 
     void wait(implementation_type &impl, std::size_t seconds) 
     { 
       boost::system::error_code ec; 
       impl->wait(seconds, ec); 
       boost::asio::detail::throw_error(ec); 
     } 
 
     template <typename Handler> 
     class wait_operation 
     { 
       public: 
         wait_operation(implementation_type &impl, boost::asio::io_service &io_service, std::size_t seconds, Handler handler) 
           : impl_(impl), 
           io_service_(io_service), 
           work_(io_service), 
           seconds_(seconds), 
           handler_(handler) 
         { 
         } 
 
         void operator()() const 
         { 
           implementation_type impl = impl_.lock(); 
           if (impl) 
           { 
               boost::system::error_code ec; 
               impl->wait(seconds_, ec); 
               this->io_service_.post(boost::asio::detail::bind_handler(handler_, ec)); 
           } 
           else 
           { 
               this->io_service_.post(boost::asio::detail::bind_handler(handler_, boost::asio::error::operation_aborted)); 
           } 
       } 
 
       private: 
         boost::weak_ptr<TimerImplementation> impl_; 
         boost::asio::io_service &io_service_; 
         boost::asio::io_service::work work_; 
         std::size_t seconds_; 
         Handler handler_; 
     }; 
 
     template <typename Handler> 
     void async_wait(implementation_type &impl, std::size_t seconds, Handler handler) 
     { 
       this->async_io_service_.post(wait_operation<Handler>(impl, this->get_io_service(), seconds, handler)); 
     } 
 
   private: 
     void shutdown_service() 
     { 
     } 
 
     boost::asio::io_service async_io_service_; 
     boost::scoped_ptr<boost::asio::io_service::work> async_work_; 
     boost::thread async_thread_; 
 }; 
 
 template <typename TimerImplementation> 
 boost::asio::io_service::id basic_timer_service<TimerImplementation>::id; 
     为了与 Boost.Asio 集成，一个服务必须符合几个要求：
 
     它必须派生自 boost::asio::io_service::service。 构造函数必须接受一个指向 I/O 服务的引用，该 I/O 服务会被相应地传给 boost::asio::io_service::service 的构造函数。
 
     任何服务都必须包含一个类型为 boost::asio::io_service::id 的静态公有属性 id。在 I/O 服务的内部是用该属性来识别服务的。
 
     必须定义两个名为 construct() 和 destruct() 的公有方法，均要求一个类型为 implementation_type 的参数。 implementation_type 通常是该服务的具体实现的类型定义。 正如上面例子所示，在 construct() 中可以很容易地使用一个 boost::shared_ptr 对象来初始化一个服务实现，以及在 destruct() 中相应地析构它。 由于这两个方法都会在一个 I/O 对象被创建或销毁时自动被调用，所以一个服务可以分别使用 construct()  和 destruct() 为每个 I/O 对象创建和销毁服务实现。
 
     必须定义一个名为 shutdown_service() 的方法；不过它可以是私有的。 对于一般的 Boost.Asio 扩展来说，它通常是一个空方法。 只有与 Boost.Asio 集成得非常紧密的服务才会使用它。 但是这个方法必须要有，这样扩展才能编译成功。
 
 为了将方法调用前转至相应的服务，必须为相应的 I/O 对象定义要前转的方法。 这些方法通常具有与 I/O 对象中的方法相似的名字，如上例中的 wait() 和 async_wait()。 同步方法，如 wait()，只是访问该服务的具体实现去调用一个阻塞式的方法，而异步方法，如 async_wait()，则是在一个线程中调用这个阻塞式方法。
 
 在线程的协助下使用异步操作，通常是通过访问一个新的 I/O 服务来完成的。 上述例子中包含了一个名为 async_io_service_ 的属性，其类型为 boost::asio::io_service。 这个 I/O 服务的 run() 方法是在它自己的线程中启动的，而它的线程是在该服务的构造函数内部由类型为 boost::thread 的 async_thread_ 创建的。 第三个属性 async_work_ 的类型为 boost::scoped_ptr<boost::asio::io_service::work>，用于避免  run() 方法立即返回。 否则，这可能会发生，因为已没有其它的异步操作在创建。 创建一个类型为 boost::asio::io_service::work 的对象并将它绑定至该 I/O 服务，这个动作也是发生在该服务的构造函数中，可以防止 run() 方法立即返回。
 
 一个服务也可以无需访问它自身的 I/O 服务来实现 - 单线程就足够的。 为新增的线程使用一个新的 I/O 服务的原因是，这样更简单： 线程间可以用 I/O 服务来非常容易地相互通信。 在这个例子中，async_wait() 创建了一个类型为 wait_operation 的函数对象，并通过 post() 方法将它传递给内部的 I/O 服务。 然后，在用于执行这个内部 I/O 服务的 run() 方法的线程内，调用该函数对象的重载 operator()()。 post() 提供了一个简单的方法，在另一个线程中执行一个函数对象。
 
 wait_operation 的重载 operator()() 操作符基本上就是执行了和 wait() 方法相同的工作：调用服务实现中的阻塞式 wait() 方法。 但是，有可能这个 I/O 对象以及它的服务实现在这个线程执行 operator()() 操作符期间被销毁。 如果服务实现是在 destruct() 中销毁的，则 operator()() 操作符将不能再访问它。 这种情形是通过使用一个弱指针来防止的，从第一章中我们知道：如果在调用 lock() 时服务实现仍然存在，则弱指针 impl_ 返回它的一个共享指针，否则它将返回0。  在这种情况下，operator()() 不会访问这个服务实现，而是以一个 boost::asio::error::operation_aborted 错误来调用句柄。


 #include <boost/system/error_code.hpp> 
 #include <cstddef> 
 #include <windows.h> 
 
 class timer_impl 
 { 
   public: 
     timer_impl() 
       : handle_(CreateEvent(NULL, FALSE, FALSE, NULL)) 
     { 
     } 
 
     ~timer_impl() 
     { 
       CloseHandle(handle_); 
     } 
 
     void destroy() 
     { 
       SetEvent(handle_); 
     } 
 
     void wait(std::size_t seconds, boost::system::error_code &ec) 
     { 
       DWORD res = WaitForSingleObject(handle_, seconds * 1000); 
       if (res == WAIT_OBJECT_0) 
         ec = boost::asio::error::operation_aborted; 
       else 
         ec = boost::system::error_code(); 
     } 
 
 private: 
     HANDLE handle_; 
 }; 
服务实现 timer_impl 使用了 Windows API 函数，只能在 Windows 中编译和使用。 这个例子的目的只是为了说明一种潜在的实现。
 
 timer_impl 提供两个基本方法：wait() 用于等待数秒。 destroy() 则用于取消一个等待操作，这是必须要有的，因为对于异步操作来说，wait() 方法是在其自身的线程中调用的。 如果 I/O 对象及其服务实现被销毁，那么阻塞式的 wait() 方法就要尽使用 destroy() 来取消。
 
 这个 Boost.Asio 扩展可以如下使用。

 #include <boost/asio.hpp> 
 #include <iostream> 
 #include "basic_timer.hpp" 
 #include "timer_impl.hpp" 
 #include "basic_timer_service.hpp" 
 
 void wait_handler(const boost::system::error_code &ec) 
 { 
   std::cout << "5 s." << std::endl; 
 } 
 
 typedef basic_timer<basic_timer_service<> > timer; 
 
 int main() 
 { 
   boost::asio::io_service io_service; 
   timer t(io_service); 
   t.async_wait(5, wait_handler); 
   io_service.run(); 
 } 
 
与本章开始的例子相比，这个 Boost.Asio 扩展的用法类似于 boost::asio::deadline_timer。 在实践上，应该优先使用 boost::asio::deadline_timer，因为它已经集成在 Boost.Asio 中了。 这个扩展的唯一目的就是示范一下 Boost.Asio 是如何扩展新的异步操作的。
 
 目录监视器(Directory Monitor) 是现实中的一个 Boost.Asio 扩展，它提供了一个可以监视目录的 I/O 对象。 如果被监视目录中的某个文件被创建、修改或是删除，就会相应地调用一个句柄。 当前的版本支持 Windows 和 Linux (内核版本 2.6.13 或以上)。

 7.6. 练习
 
You can buy solutions to all exercises in this book as a ZIP file.

修改 第 7.4 节 “网络编程” 中的服务器程序，不在一次请求后即终止，而是可以处理任意多次请求。

扩展 第 7.4 节 “网络编程” 中的客户端程序，即时在所接收到的HTML代码中分析某个URL。 如果找到，则同时下载相应的资源。 对于本练习，只使用第一个URL。 理想情况下，网站及其资源应被保存在两个文件中而不是同时写出至标准输出流。

创建一个客户端/服务器应用，在两台PC间传送文件。 当服务器端启动后，它应该显示所有本地接口的IP地址并等待客户端连接。 客户端则应将服务器端的某一个IP地址以及某个本地文件的文件名作为命令行参数。 客户端应将该文件传送给服务器，后者则相应地保存它。 在传送过程中，客户端应向用户提供一些进度的可视显示。