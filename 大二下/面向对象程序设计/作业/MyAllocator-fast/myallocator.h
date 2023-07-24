#ifndef MYALLOCATOR_H
#define MYALLOCATOR_H
#include <iostream>
using namespace std;

enum {__ALIGN = 8}; // 小型区块的上调边界
enum {__MAX_BYTES = 128}; // 小型区块的上限
enum {__NFREELISTS = __MAX_BYTES/__ALIGN}; // free-lists个数

// 维护16个free-lists, 各自管理大小分别为8, 16, 24, 32, 40, 48, 56, 64, 72, 80, 88, 96, 104, 112, 120, 128bytes的小额区块
union obj
{
    union obj * free_list_link;
    char client_data[1];
};

// 以下是MemoryPool, 参考stl源码的第二级配置器
// 注意，无"template型别参数"
class MemoryPool
{
public:
    typedef void _Not_user_specialized;
    typedef size_t size_type;

    static _Not_user_specialized * allocate(size_type n)
    {
        obj * volatile * my_free_list;
        obj * result;
        // 大于128就调用一级配置器
        if(n > (size_type) __MAX_BYTES) 
            return malloc(n);
        
        // 寻找16个free lists中适当的一个
        my_free_list = free_list + FREELIST_INDEX(n);
        result = *my_free_list;
        if(result == nullptr){
            // 未找到可用的free list，准备重新填充free list
            return refill(ROUND_UP(n));
        }
        // 调整free list
        *my_free_list = result->free_list_link;
        return result;        
    }

    static _Not_user_specialized deallocate(_Not_user_specialized * p, size_type n)
    {
        obj * q = (obj*)p;
        obj * volatile * my_free_list;

        // 大于128就调用第一级配置器
        if(n > (size_type) __MAX_BYTES)
        {
            free(p);
			return;
        }

        // 寻找对应的free list
        my_free_list = free_list + FREELIST_INDEX(n);
        //调整free list，回收区块
        q->free_list_link = *my_free_list;
        *my_free_list = q;      
    }
    
    static _Not_user_specialized * reallocate(_Not_user_specialized * p, size_type old_sz, size_type new_sz);    
private:
    // 内存池起始位置
	static char *begin;
    // 内存池结束位置
	static char *end;
	static size_type memSize;

    // 将bytes上调至8的倍数
	static size_type ROUND_UP(size_type bytes)
    {
        return (((bytes) + __ALIGN - 1) & ~(__ALIGN - 1));
    }
    // 16个free_list
	static obj * volatile free_list[__NFREELISTS];
	// 以下函数根据数据区块大小，决定使用第n号free-list。n从1起算
    static size_type FREELIST_INDEX(size_type bytes)
    {
        return ((bytes + __ALIGN - 1)/ __ALIGN - 1);
    }

    // 返回一个大小为n的对象，并可能加入大小为n的其他区块到free-list
	static _Not_user_specialized* refill(size_type n)
    {
		int nobjs = 20;
        // 调用chunk_alloc()，尝试取得nobjs个区块作为free list的新节点
		// 注意参数nobjs是pass by reference
        char* chunk = chunk_alloc(n, nobjs);
		
        obj * volatile * my_free_list;
		obj * result;
		obj * current_obj, * next_obj;
        int i;

        // 如果只获得一个区块，这个区块就分配给调用者用，free list无新节点
		if (1 == nobjs) 
            return chunk;
        // 否则调整free list，纳入新节点
		my_free_list = free_list + FREELIST_INDEX(n);

        // 以下在chunk空间内建立free list
		result = (obj *)chunk; //这一块准备返回客端
		// 以下导引free list指向新配置的空间（取自内存池）
        *my_free_list = next_obj = (obj *)(chunk + n);
        // 以下将free list的各节点串联起来
		for (i = 1; ; i++) { // 从1开始，因为第0个将分会给客端
			current_obj = next_obj;
			next_obj = (obj *)((char *)next_obj + n);
			if (nobjs - 1 == i) 
            {
                current_obj->free_list_link = nullptr;
                break;
            }
			else current_obj->free_list_link = next_obj;
		}
		return result;        
    }

    // 假设size已经适当上调至8的倍数
    // 注意参数nobjs是pass by reference
    static char * chunk_alloc(size_type size, int& nobjs)
    {
		char * result;
		size_type total_bytes = size * nobjs;
		size_type bytes_left = end_free - start_free; //内存池剩余空间
		
        if (bytes_left >= total_bytes) {
            // 内存池剩余空间满足需求量
			result = start_free;
			start_free += total_bytes;
			return result;
		} else if (bytes_left >= size) {
            // 内存池剩余空间不能完全满足需求量，但足够供应一个及以上的区块
			nobjs = bytes_left / size;
			total_bytes = size * nobjs;
			result = start_free;
			start_free += total_bytes;
			return result;
		} else {
            // 内存池剩余空间连一个区块的大小都无法提供
			size_type bytes_to_get = 2 * total_bytes + ROUND_UP(heap_size >> 4);
            // 以下试着让内存池中的残余零头还有利用价值
            if (bytes_left > 0) {
                // 内存池内还有一些零头，先配给适当的free list
                // 首先寻找适当的free list
                obj * volatile * my_free_list = free_list + FREELIST_INDEX(bytes_left);
                // 调整free list，将内存池中的剩余空间编入
                ((obj *)start_free)->free_list_link = *my_free_list;
                *my_free_list = (obj *)start_free;
            }

            // 配置heap空间，用来补充内存池
			start_free = (char *)malloc(bytes_to_get);
			if (0 == start_free) {
                // heap空间不足，malloc()失败
                int i;
                obj * volatile * my_free_list, *p;
                // 以下搜寻“尚未用区块，且区块足够大”之free list
                for (i = size; i < __MAX_BYTES; i += __ALIGN) {
                    my_free_list = free_list + FREELIST_INDEX(i);
                    p = *my_free_list;
                    if (0 != p) { // free list内尚有未用区块
                        // 调整free list以释放出为用区块
                        *my_free_list = p->free_list_link;
                        start_free = (char *)p;
                        end_free = start_free + i;
                        // 递归调用自己，为了修正nobjs
                        return(chunk_alloc(size, nobjs));
                        // 注意，任何残余零头终将被编入适当的free-list中备用
                    }
                }
                end_free = nullptr;
                start_free = (char *)malloc(bytes_to_get);
            }
            heap_size += bytes_to_get;
			end_free = start_free + bytes_to_get;
			// 递归调用自己，为了修正nobjs
            return chunk_alloc(size, nobjs);
		}
    }

    // Chunk allocation state
    static char * start_free; // 内存池起始位置，只在chunk_alloc()中变化
    static char * end_free; // 内存池结束位置，只在chunk_alloc()中变化
    static size_type heap_size; 
};

char * MemoryPool::start_free = nullptr;
char * MemoryPool::end_free = nullptr;
size_t MemoryPool::heap_size = 0;
obj * volatile MemoryPool::free_list[__NFREELISTS] = {nullptr};

template <class T>
class MyAllocator
{
public:
    typedef void _Not_user_specialized;
    typedef T value_type;
    typedef value_type *pointer;
    typedef const value_type *const_pointer;
    typedef value_type &reference;
    typedef const value_type &const_reference;
    typedef size_t size_type;
    typedef ptrdiff_t difference_type;

    template <typename U> struct rebind
    {
        typedef MyAllocator<U> Other;
    };
    MyAllocator() = default;
    MyAllocator(const MyAllocator &myallocator) = default;
    MyAllocator(MyAllocator &&myallocator) = default;
    template <class U>
    MyAllocator(const MyAllocator<U> &myallocator) noexcept;
    pointer address(reference _Val) const noexcept{
        //return address of value
        return &_Val;
    }
    const_pointer address(const_reference _Val) const noexcept{
        return &_Val;
    }
    void deallocate(pointer _Ptr, size_type _Count){
        MemoryPool::deallocate(_Ptr,_Count* sizeof(value_type));
    }
    pointer allocate(size_type _Count) {
        if(auto res = static_cast<pointer>(MemoryPool::allocate(_Count * sizeof(value_type))))
            return res;
        else throw bad_alloc();
    }
    template <class _Uty>
    void destroy(_Uty *_Ptr){
        _Ptr->~_Uty();
    } 
    template <class _Objty, class... _Types>
    void construct(_Objty *_Ptr, _Types &&... _Args){
    new(_Ptr) _Objty(forward<_Types>(_Args)...);
    return;
    }
};

#endif
