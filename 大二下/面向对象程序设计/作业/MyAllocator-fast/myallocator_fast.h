#ifndef _MYALLOCATOR_FAST_H
#define _MYALLOCATOR_FAST_H

#include <iostream>
#include <limits>

enum {K = 1024};
enum {BLOCK_NUM = 64};
enum {BLOCK_SIZE = 4 * K};

using block_ptr = struct block *;
struct block{
    block_ptr prev = nullptr;
    block_ptr next = nullptr;
};

class MemoryPool {
public:
    typedef void _Not_user_specialized;
    typedef size_t size_type;

    MemoryPool();
    MemoryPool(size_type num, size_type size);
    ~MemoryPool();
    _Not_user_specialized * allocate(size_type size);
    MemoryPool * deallocate(MemoryPool * cursor, MemoryPool * end, _Not_user_specialized * ptr, size_type size);

    block_ptr free_Header = nullptr;
    block_ptr alloc_Header = nullptr;
    _Not_user_specialized * Pool_Header = nullptr;
    size_type block_size; // 每个块的大小
    size_type block_num; // 块的数目
    size_type pool_size; // (block的大小 + 维护block结构体大小) * block 数目
    
    int id = 0;
    MemoryPool * Next;
    MemoryPool * Prev;
};

class MemoryPool_List{
public:
    typedef void _Not_user_specialized;
    typedef size_t size_type;

    MemoryPool * free_pool = nullptr;
    MemoryPool * first_pool = nullptr;
    MemoryPool_List() {
        MemoryPool * p = new MemoryPool();
        free_pool = p;
        first_pool = p;
    };
    _Not_user_specialized * allocate (size_type size) {
        if(free_pool->free_Header == nullptr){
            //当前内存池满了
            if(free_pool->Next == nullptr){
                //下一个内存池还没分配好
                free_pool->Next = new MemoryPool();
                free_pool->Next->id = free_pool->id + 1;
            }
            //下一个内存池已经分配好了
            //移除空闲内存池链表头
            MemoryPool * curr = free_pool;
            free_pool = free_pool->Next;
            free_pool->Prev = curr;
        }
        return free_pool->allocate(size);
    };
    void deallocate(_Not_user_specialized * ptr, size_type size) {
        MemoryPool * cursor = first_pool->deallocate(first_pool, free_pool, ptr, size); // 从第一个pool中开始查找
        if (cursor == nullptr){
            // 不在内存池中
            operator delete(ptr);
            return;
        }
        else if(cursor->alloc_Header == nullptr) {
            if (cursor != free_pool) {
                if (cursor != first_pool) {
                    cursor->Prev->Next = cursor->Next;
                    cursor->Next->Prev = cursor->Prev;
                } else {
                    first_pool = first_pool->Next;
                    first_pool->Prev = nullptr;
                }
                cursor->Next = free_pool->Next;
                if (free_pool->Next != nullptr) 
                    free_pool->Next->Prev = cursor;
                cursor->Prev = free_pool;
                free_pool->Next = cursor;
            }
        }
    }
};

MemoryPool::MemoryPool(size_type bn, size_type bs) {
    if (bn < BLOCK_NUM) block_num = BLOCK_NUM;
    else block_num = bn;
    if(bs < BLOCK_SIZE) block_size = BLOCK_SIZE;
    else block_size = bs;
    pool_size = block_num * (block_size + sizeof(block));
    Pool_Header = operator new(pool_size);
    Next = nullptr;
    // succeess create the pool
    if (Pool_Header != nullptr) { 
        for (auto i = 0; i < block_num; ++i) {
            block_ptr curr = reinterpret_cast<block_ptr>(static_cast<char*>(Pool_Header) + i * (block_size + sizeof(block)));
            curr->prev = nullptr;
            curr->next = free_Header;
            if (free_Header != nullptr) 
                free_Header->prev = curr;
            free_Header = curr;
        }
    }
}

MemoryPool::MemoryPool() : MemoryPool(BLOCK_NUM, BLOCK_SIZE) {
}

void * MemoryPool::allocate(size_type sz) {
    // 大于block_size，直接从os分配
    if( sz > block_size){
        //std::cout<<"allocat memory of size "<<sz<<" directly from os "<<std::endl;
        return ::operator new(sz);
    }
    else{
        //当前内存池还可以放入
        //std::cout<<"allocat memory of size "<<sz<<" in id "<<this->id<<std::endl;
        block_ptr curr = free_Header;

        free_Header = curr->next;
        if (free_Header != nullptr) 
            free_Header->prev = nullptr;

        curr->next = alloc_Header;
        if (alloc_Header != nullptr) 
            alloc_Header->prev = curr;
        alloc_Header = curr;
        return static_cast<void *>(reinterpret_cast<char*>(curr) + sizeof(block));
    }
}

MemoryPool* MemoryPool::deallocate(MemoryPool* cursor,MemoryPool* end,void* ptr,size_t sz) {
    // 指针在内存池中
    if (cursor != nullptr) {
        void *Pool_Header = cursor->Pool_Header;
        // 指针在内存池中
        if (Pool_Header < ptr && ptr < (void *) ((char *) Pool_Header + cursor->pool_size)) {
            block_ptr curr = reinterpret_cast<block_ptr>(static_cast<char *>(ptr) - sizeof(block));
            if (curr != cursor->alloc_Header) {
                curr->prev->next = curr->next;
                if (curr->next != nullptr)curr->next->prev = curr->prev;
            } else {
                cursor->alloc_Header = curr->next;
                if (curr->next != nullptr)curr->next->prev = nullptr;
            }
            // 加到空块链表中
            curr->next = cursor->free_Header;
            if (cursor->free_Header != nullptr) {
                cursor->free_Header->prev = curr;
            }
            cursor->free_Header = curr;
            //已经移除指针,返回当前内存池的首地址
            return cursor;
        } else if (cursor != end && cursor->Next!= nullptr) {
            //还有下一块,查找下一块
            return deallocate(cursor->Next, end, ptr, sz);
        } else{
            //没有空的内存池了
            return nullptr;
        }
    }
    return nullptr;
}
MemoryPool::~MemoryPool() {
    if (Pool_Header != nullptr)
        ::operator delete(Pool_Header);
}

template <typename T>
class MyAllocator {
public :
    //    typedefs
    using value_type = T;
    using pointer = value_type* ;
    using const_pointer =  const value_type* ;
    using reference = value_type&;
    using const_reference = const value_type&;
    using size_type = std::size_t;
    using difference_type = std::ptrdiff_t;

public :
    //    convert an allocator<T> to allocator<U>
    template<typename U>
    struct rebind { typedef MyAllocator<U> other; };

public :
    inline MyAllocator() = default;
    inline ~MyAllocator() = default;
    inline MyAllocator(MyAllocator const&) = default;
    template<typename U>
    inline explicit MyAllocator(MyAllocator<U> const&) {}

    //    地址信息
    inline pointer address(reference r) { return &r; }
    inline const_pointer address(const_reference r) { return &r; }

    //   内存分配
    inline pointer allocate(size_type cnt, typename std::allocator<void>::const_pointer = 0) {
        return reinterpret_cast<pointer>(Mempool.allocate(cnt * sizeof(T)));
    }
    inline void deallocate(pointer p, size_type n) {
        Mempool.deallocate(p, n);
    }

    //  返回大小
    inline size_type max_size() const {
        return std::numeric_limits<size_type>::max() / sizeof(T);
    }

    // 构造函数/析构函数
    inline void construct(pointer p, const T& t) { new(p) T(t); }
    inline void destroy(pointer p) { p->~T(); }

    inline bool operator==(MyAllocator const&) { return true; }
    inline bool operator!=(MyAllocator const& a) { return !operator==(a); }
private:
    static MemoryPool_List Mempool;
};   

template <typename T> MemoryPool_List MyAllocator<T>::Mempool;

#endif