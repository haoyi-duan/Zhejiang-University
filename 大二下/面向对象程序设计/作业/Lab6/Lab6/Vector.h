#ifndef _VECTOR_H_
#define _VECTOR_H_
#include <iostream>
#include <cstdio>
#include <string>
using namespace std;

#define BLOCKSIZE     16 // The default BlockSize of the container.
#define DECONSTRUCT      // Print message when ~Vector() called.
template <typename T>
class Vector {
public:
	Vector();                      // creates an empty vector
	Vector(int size);              // creates a vector for holding 'size' elements
	Vector(const Vector& r);       // the copy ctor
	~Vector();                     // destructs the vector 
	T& operator[](int index);      // accesses the specified element without bounds checking
	T& at(int index);              // accesses the specified element, throws an exception of type 'std::out_of_range' when index <0 or >=m_nSize
	int size() const;              // return the size of the container
	void push_back(const T& x);    // adds an element to the end 
	void clear();                  // clears the contents
	bool empty() const;            // checks whether the container is empty 
private:
	void inflate();                // expand the storage of the container to a new capacity, e.g. 2*m_nCapacity
	T *m_pElements;                // pointer to the dynamically allocated storage
	int m_nSize;                   // the number of elements in the container
	int m_nCapacity;               // the number of elements that can be held in currently allocated storage
	T* allocator(const int size);  // allocate space for pointer m_pElements
	void deallocator(T* arr);      // deallocate space for pointer arr
	void free();                   // free(m_pElements)
};

// ERROR exception class is used when the index in the function at() is out of range.
class ERROR :exception {
public:
	ERROR(string s) :text(s) {}
	string what() 
	{
		return text;
	};
private:
	string text;
};

template <typename T>
Vector<T>::Vector()
{
	m_pElements = nullptr; // The m_pElements is set to be nullptr.
	m_nSize = 0; // default number for m_nSize.
	m_nCapacity = 0; // default number for m_nCapacity.
}

template <typename T>
Vector<T>::Vector(int size)
{
	m_pElements = allocator(size); // allocate the space of sizeof (size) * T
	m_nSize = size;
	m_nCapacity = size;
}

template <typename T>
Vector<T>::Vector(const Vector& r)
{   // copy r to this.
	this->m_pElements = allocator(r.m_nCapacity);
	this->m_nCapacity = r.m_nCapacity;
	this->m_nSize = r.m_nSize;
	for (auto i = 0; i < r.m_nSize; i++)
		this->m_pElements[i] = r.m_pElements[i];
}

template <typename T>
Vector<T>::~Vector()
{
	free();
#ifdef DECONSTRUCT
	cout << "~Vector():called." << endl;
#endif // DECONSTRUCT
}

template <typename T>
T& Vector<T>::operator[](int index)
{
	if (index >= 0 && index < m_nSize) return m_pElements[index];
	return m_pElements[0];
}

template <typename T>
T& Vector<T>::at(int index)
{
	if (index >= 0 && index < m_nSize)
		return m_pElements[index];
	throw ERROR("std::out_of_range");
}

template <typename T>
int Vector<T>::size() const
{
	return m_nSize;
}

template <typename T>
void Vector<T>::push_back(const T& x)
{   // if m_nSize is above or equal with the m_nCapacity, allocator bigger space for m_pElements.
	if (m_nSize >= m_nCapacity)
		inflate();
	m_pElements[m_nSize++] = x;
}

template <typename T>
void Vector<T>::clear()
{   // Same as the c++ standard class vector, the clear() function
	// sets the m_nSize to be 0, while the m_nCapacity remains the same.
	m_nSize = 0;
}

template <typename T>
bool Vector<T>::empty() const
{   // Judge whether the vector is empty.
	return m_nSize == 0;
}

template <typename T>
void Vector<T>::inflate()
{
	int count = (m_nCapacity > 0) ? m_nCapacity * 2 : BLOCKSIZE;
	T* old_pElements = m_pElements;
	m_nCapacity = count;
	m_pElements = allocator(m_nCapacity);

	for (auto i = 0; i < m_nSize; i++)
		m_pElements[i] = old_pElements[i];
	deallocator(old_pElements);
}

template <typename T>
T* Vector<T>::allocator(const int size)
{
	return new T[size];
}

template <typename T>
void Vector<T>::deallocator(T* arr)
{
	if (arr)
		delete[] arr;
}

template <typename T>
void Vector<T>::free()
{
	deallocator(m_pElements);
	m_pElements = nullptr;
	m_nSize = 0;
	m_nCapacity = 0;
}

#endif