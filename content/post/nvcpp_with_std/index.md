---
title: "std::excution介绍及其在nvidia gpu中的使用"
description: 
date: 2024-06-23T19:46:35+08:00
image: 119683453_p0.jpg
math: 
license: 
hidden: false
comments: true
draft: false 
catrgories:
    - coding
tags:
    - hpc -cpp -nvidia
---

# 文前

老板叫我去查查标准库离有没有类似openmp那种并行方法，在查阅了相关资料后冰箱老板汇报后，这个方法并没有被采用。我把在此期间所查的资料整理于此作为知识备份，以便日后查阅使用。

值得一提的是，笔者并没有实际编写或执行过相应的代码，所以本文仅供参考，一切以实际为准。如有错误，烦请指出。

# 标准库

在cpp17中，标准库中增加了`std::execution`，并引入了执行策略（`execution_policy`），粗略来说，一些执行策略可以使一部分算法和循环操作并行运行并自动向量化。以下为四种执行策略类型（最后一种是cpp20引入的）

> `
> std::execution::sequenced_policy
> `
> 最基本的串行策略，不表。
> 
> `
> std::execution::parallel_policy
> `
> 并行策略，类似openmp的并行化操作，值得一提的是，线程的执行顺序是不确定的。
> 
> `
> std::execution::parallel_unsequenced_policy
> `
> 同上，但是明确指出了循环顺序不确定，指示编译器可以向量化。
> 
> `
> std::execution::unsequenced_policy
> `
> 不会进行并行操作，但是指示编译器可以向量化

如果使用并行化策略，那么线程安全是由程序员自己负责的。

值得一提的是，我们传入算法的执行策略并不是一个类型，而是一个实例，标准库并没有告诉我们如何创建一个实例，只是提供了以上四种类型所对应的实例，如下所示。

> `
> std::execution::seq
> `
> 
> `
> std::execution::par
> `
> 
> `
> std::execution::par_unseq
> `
> 
> `
> std::execution::unseq
> `

如果想使用执行策略，常见的话可以在`for_each`和`for_each_n`中的第一个参数中传入执行策略。如果你需要规约和扫描操作，可以在`reduce`和`inclusive_scan`中使用即可。事实上，大部分[algorithm](https://zh.cppreference.com/w/cpp/header/algorithm)中和[numeric](https://zh.cppreference.com/w/cpp/header/numeric)的算法都是允许传入执行策略的。

[cppreference](https://zh.cppreference.com/w/cpp/algorithm/execution_policy_tag)中暗示以后可能会有更丰富的策略（比如`std::parallel::cuda` 和 `std::parallel::opencl`）。但是笔者对此抱有怀疑态度。

涉及到执行策略的两篇主要提案，分别是[P2300R9](https://www.open-std.org/jtc1/sc22/wg21/docs/papers/2024/p2300r9.html#design-schedulers)和[P0443R14](https://www.open-std.org/jtc1/sc22/wg21/docs/papers/2020/p0443r14.html)。其中前者是对后者更近一步的意见。笔者想在其中找到关于如何管理调度策略和管理并行资源的更近一步的资料，由于时间关系，我只看了前一篇，但奈何是在太长太长，而且其中大部分都是在谈`sender`和`recevier`机制，和老板要求没啥关系，而提案中关于我想要的部分仅仅只有一[小部分](https://www.open-std.org/jtc1/sc22/wg21/docs/papers/2024/p2300r9.html#design-schedulers),没有更进一步的尝试，所以我只能就此作罢。

# gpu上并行

那么标准库里的方法可不可以把线程放进gpu中执行呢，就像opanacc那样？答案是可以的，但是目前笔者查到的相关资料仅限于nvidia的gpu，至于另外两家我就不知道了。想要在gpu上并行可以使用nvidia的nvc++编译器，在编译选项中加上`-stdpar`即可，编译器会自动完成其中的操作。其中要注意的点如下：

- 只支持前三种策略，其中使用第一种不会进行并行化。

- 主机和设备之间的数据移动是自动进行的，但是移动方式又有两种方式，分别为Managed Memory Mode和Unified Memory Mode，具体区别可以参考[这里](https://docs.nvidia.com/hpc-sdk/archive/24.5/compilers/hpc-compilers-user-guide/index.html#acc-mem-unified)，粗略来说，前者是由程序手动完成数据移动，而后者是硬件上有一块cpu和gpu都可以访问的内存。

- 如果你不想引入额外的数据传输开销，就不要在[cpu部分的代码碰数据](https://developer.nvidia.com/blog/multi-gpu-programming-with-standard-parallel-c-part-2/#do_not_touch_data_on_the_cpu)

- 如果想要多卡运算，需要与MPI结合

- 申请内存是不需要`__device__`之类的指示符的

- 尽管使用正常编写cpp方式来分配内存就好了，但是如果想要更快的效率，可以考虑使用[pinned memory](https://developer.nvidia.com/blog/multi-gpu-programming-with-standard-parallel-c-part-2/#communicate_through_pinned_memory)

- 如果使用Managed Memory Mode的话，循环内只能访问在堆上分配的内存，而不能访问在栈上分配的内存（全局变量也不可以）。因此`std::vector`中的元素可以被访问，但是`std::array`中的反而不行。Unified Memory Mode则没有这种限制。具体差别[在这](https://docs.nvidia.com/hpc-sdk/archive/24.5/compilers/hpc-compilers-user-guide/index.html#stdpar-cpp-unified-memory)，总体来说，推荐后一种方式。

- 不能传入函数指针，只能传入lambda表达式，因为使用函数指针调用函数时会传入一个多态object，会调用虚表。（这里我也很疑惑，但是官网就是这么[写的](https://docs.nvidia.com/hpc-sdk/archive/24.5/compilers/hpc-compilers-user-guide/index.html#stdpar-cpp-function-pointers)）

- 计算能力由编译器自动指定。

除此之位，nvc++还支持不少很新的东西，比如多维数组，线性函数库，或者自己实现一个sender和receiver，可以在文档中查看。

# 参考

1. [cppreference](https://en.cppreference.com/w/cpp/header/execution) 

2. [nvc++ pragram guide](https://docs.nvidia.com/hpc-sdk/archive/24.5/compilers/hpc-compilers-user-guide/index.html#stdpar-use) 

3. [nvidia blog](https://developer.nvidia.com/blog/multi-gpu-programming-with-standard-parallel-c-part-2/)