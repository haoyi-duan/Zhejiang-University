# 关于运行测试的一些说明

测试代码全部集成在 *test.cpp* 文件中，通过宏定义进行测试功能的变化。

- **宏定义**

```c++
#define _TEST_STD_SIMPLE_ //检验替换sdt::allocator对vector的push_back性能的代码段
#define _TEST_SIMPLE_ //检验替换allocator后vector的push_back性能的代码段
#define _TEST_CORRECTNESS_ //测试程序正确性的代码段
#define _TEST_STD_ //测试std::allocator运行速度的代码段
#define _TEST_MYALLOCATOR_ //测试myallocator运行速度的代码段
#define _TEST_STD_PTA_ //PTA提供的测试代码段测试std的运行速度
#define _TEST_MYALLOCATOR_PTA_ //PTA提供的测试代码段测试myallocator的运行速度
#define _TEST_FILE_ //将结果写入文件的代码段，测试速度
#define _TEST_WITH_FILE_ //用文件测试的代码段，测试速度
```

说明：

8个宏定义分别代码具有8个测试功能的*main*函数代码段，所以每次运行*test*的时候，有且仅有一行宏定义是有效的，其余必须保证注释掉。

- 文件读

有2个代码段是可以进行文件的读写的，一个是将结果写会文件，这个命名可以随意，但是原则上还是保持命名为"test0.txt"和"test10.txt"之间，方便进行管理；另外一个代码段是文件的读，就务必保证文件事先存在文件夹test目录下，否则会读文件失败。

