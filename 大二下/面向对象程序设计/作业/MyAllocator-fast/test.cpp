// testallocator.cpp : 定义控制台应用程序的入口点。
//
#include <iostream>
#include <chrono>
#include <random>
#include <random>
#include <vector>
#include <limits>
#include <ctime>
#include <memory>
#include <fstream>
#include <cstring> 
#include <cstdlib>
#include <string>

using namespace std;
using Point2D = std::pair<int, int>;

#define INT 1
#define FLOAT 2
#define DOUBLE 3
#define CLASS  4

#define TESTSIZE 10000
#define PICKSIZE 1000

#define _FAST_ // myallocator_fast.h是后来的较快的版本

#ifdef _FAST_ 
#include "myallocator_fast.h"
#endif
#ifndef _FAST_
#include "myallocator.h"
#endif

// #define _TEST_STD_SIMPLE_ // 检验替换sdt::allocator对vector的push_back性能
// #define _TEST_SIMPLE_ // 检验替换allocator后vector的push_back性能
// #define _TEST_CORRECTNESS_ // 测试程序正确性的代码段
// #define _TEST_STD_ // 测试std::allocator运行速度的代码段
 #define _TEST_MYALLOCATOR_ // 测试myallocator运行速度的代码段
// #define _TEST_STD_PTA_ // PTA提供的测试代码段测试std的运行速度
// #define _TEST_MYALLOCATOR_PTA_ // PTA提供的测试代码段测试myallocator的运行速度
// #define _TEST_FILE_ // 自动生成测试样例文件的代码段
// #define _TEST_WITH_FILE_ // 用自动生成的文件测试的代码段

class vecWrapper {
public:
	vecWrapper() {
		m_pVec = NULL;
		m_type = INT;
	}
	virtual ~vecWrapper() {}
public:
	void setPointer(int type, void* pVec) { m_type = type; m_pVec = pVec; }
	virtual void visit(int index) = 0;
	virtual int size() = 0;
	virtual void resize(int size) = 0;
	virtual bool checkElement(int index, void* value) = 0;
	virtual void setElement(int idex, void* value) = 0;
protected:
	int m_type;
	void* m_pVec;
};

#ifdef _TEST_STD_
template<class T>
class vecWrapperT : public vecWrapper {
public:
	vecWrapperT(int type, vector<T, allocator<T> >* pVec) {
		m_type = type;
		m_pVec = pVec;
	}
	virtual ~vecWrapperT() {
		if (m_pVec)
			delete ((vector<T, allocator<T> > *)m_pVec);
	}
public:
	virtual void visit(int index) {
		T temp = (*(vector<T, allocator<T> > *)m_pVec)[index];
	}
	virtual int size() {
		return ((vector<T, allocator<T> > *)m_pVec)->size();
	}
	virtual void resize(int size) {
		((vector<T, allocator<T> > *)m_pVec)->resize(size);
	}
	virtual bool checkElement(int index, void* pValue) {
		T temp = (*(vector<T, allocator<T> > *)m_pVec)[index];
		if (temp == (*((T*)pValue)))
			return true;
		else
			return false;
	}

	virtual void setElement(int index, void* value) {
		(*(vector<T, allocator<T> > *)m_pVec)[index] = *((T*)value);
	}
};
#endif

#ifndef _TEST_STD_
template<class T>
class vecWrapperT : public vecWrapper
{
public:
	vecWrapperT(int type, std::vector<T, MyAllocator<T> > *pVec)
	{
		m_type = type;
		m_pVec = pVec;
	}
	virtual ~vecWrapperT() {
		if (m_pVec)
			delete ((std::vector<T, MyAllocator<T> > *)m_pVec);
	}
public:
	virtual void visit(int index)
	{
		T temp = (*(std::vector<T, MyAllocator<T> > *)m_pVec)[index];
	}
	virtual int size()
	{
		return ((std::vector<T, MyAllocator<T> > *)m_pVec)->size();
	}
	virtual void resize(int size)
	{
		((std::vector<T, MyAllocator<T> > *)m_pVec)->resize(size);
	}
	virtual bool checkElement(int index, void *pValue)
	{
		T temp = (*(std::vector<T, MyAllocator<T> > *)m_pVec)[index];
		if (temp == (*((T *)pValue)))
			return true;
		else
			return false;
	}

	virtual void setElement(int index, void *value)
	{
		(*(std::vector<T, MyAllocator<T> > *)m_pVec)[index] = *((T *)value);
	}
};
#endif

class myObject {
public:
	myObject() : m_X(0), m_Y(0) {}
	myObject(int t1, int t2) :m_X(t1), m_Y(t2) {}
	myObject(const myObject& rhs) { m_X = rhs.m_X; m_Y = rhs.m_Y; }
	~myObject() { /*cout << "my object destructor called" << endl;*/ }
	bool operator == (const myObject& rhs) {
		if ((rhs.m_X == m_X) && (rhs.m_Y == m_Y))
			return true;
		else
			return false;
	}
protected:
	int m_X;
	int m_Y;
};

#ifdef _TEST_STD_SIMPLE_

int main ()
{
	clock_t begin, end;
	std::vector<int> integer;
	
	cout << "std::llocator" << endl;
	begin = clock();
	for (auto i = 0; i < TESTSIZE; i++)
		integer.push_back(i); 
	end = clock();
	cout << "The runtime of " << TESTSIZE << " push operations is " << (double)(end - begin) / CLOCKS_PER_SEC << "s" << endl;

	std::vector<vector<int>> vectorTmp;
	cout << "std::llocator" << endl;
	begin = clock();
	for (auto i = 0; i < TESTSIZE; i++)
		vectorTmp.push_back(integer); 
	end = clock();
	cout << "The runtime of " << TESTSIZE << " push operations is " << (double)(end - begin) / CLOCKS_PER_SEC << "s" << endl;

	return 0;
}
#endif

#ifdef _TEST_SIMPLE_

int main ()
{
	clock_t begin, end;
	std::vector<int, MyAllocator<int> > integer;
	
	cout << "MyAllocator" << endl;
	begin = clock();
	for (auto i = 0; i < TESTSIZE; i++)
		integer.push_back(i); 
	end = clock();
	cout << "The runtime of " << TESTSIZE << " push operations is " << (double)(end - begin) / CLOCKS_PER_SEC << "s" << endl;

	std::vector<vector<int, MyAllocator<int> >, MyAllocator<vector<int, MyAllocator<int> > > > vectorTmp;
	cout << "MyAllocator" << endl;
	begin = clock();
	for (auto i = 0; i < TESTSIZE; i++)
		vectorTmp.push_back(integer); 
	end = clock();
	cout << "The runtime of " << TESTSIZE << " push operations is " << (double)(end - begin) / CLOCKS_PER_SEC << "s" << endl;

	return 0;
}
#endif

#ifdef  _TEST_CORRECTNESS_

int main()
{
	vecWrapper **testVec;
	testVec = new vecWrapper*[TESTSIZE];

	int tIndex, tSize;
	//test allocator
	for (int i = 0; i < TESTSIZE - 4; i++)
	{
		tSize = (int)((float)rand() / (float)RAND_MAX * 10000);
		vecWrapperT<int> *pNewVec = new vecWrapperT<int>(INT, new std::vector<int, MyAllocator<int>>(tSize));
		testVec[i] = (vecWrapper *)pNewVec;
	}

	for (int i = 0; i < 4; i++)
	{
		tSize = (int)((float)rand() / (float)RAND_MAX * 10000);
		vecWrapperT<myObject> *pNewVec = new vecWrapperT<myObject>(CLASS, new std::vector<myObject, MyAllocator<myObject>>(tSize));
		testVec[TESTSIZE - 4 + i] = (vecWrapper *)pNewVec;
	}

	//test resize
	for (int i = 0; i < 100; i++)
	{
		tIndex = (int)((float)rand() / (float)RAND_MAX * (float)TESTSIZE);
		tSize = (int)((float)rand() / (float)RAND_MAX * (float)TESTSIZE);
		testVec[tIndex]->resize(tSize);
	}

	//test assignment
	tIndex = (int)((float)rand() / (float)RAND_MAX * (TESTSIZE - 4 - 1));
	int tIntValue = 10;
	testVec[tIndex]->setElement(testVec[tIndex]->size() / 2, &tIntValue);
	if (!testVec[tIndex]->checkElement(testVec[tIndex]->size() / 2, &tIntValue))
		std::cout << "incorrect assignment in vector %d\n" << tIndex << std::endl;

	tIndex = TESTSIZE - 4 + 3;
	myObject tObj(11, 15);
	testVec[tIndex]->setElement(testVec[tIndex]->size() / 2, &tObj);
	if (!testVec[tIndex]->checkElement(testVec[tIndex]->size() / 2, &tObj))
		std::cout << "incorrect assignment in vector %d\n" << tIndex << std::endl;

	myObject tObj1(13, 20);
	if (!testVec[tIndex]->checkElement(testVec[tIndex]->size() / 2, &tObj1))
		std::cout << "incorrect assignment in vector " << tIndex << " for object (13,20)" << std::endl;

	for (int i = 0; i < TESTSIZE; i++)
		delete testVec[i];

	delete[]testVec;
	system("pause");
	return 0;

}
#endif

#ifdef _TEST_STD_

int main() {
	vecWrapper** testVec;
	testVec = new vecWrapper *[TESTSIZE];
	clock_t begin, end;
	int tIndex, tSize;

	cout << "std::allocator" << endl;
	begin = clock();
	for (int i = 0; i < TESTSIZE - 4; i++) {
		tSize = (int)((float)rand() / (float)RAND_MAX * 10000);
		vecWrapperT<int>* pNewVec = new vecWrapperT<int>(INT, new vector<int, allocator<int>>(tSize));
		testVec[i] = (vecWrapper*)pNewVec;
	}

	for (int i = 0; i < 4; i++) {
		tSize = (int)((float)rand() / (float)RAND_MAX * 10000);
		vecWrapperT<myObject>* pNewVec = new vecWrapperT<myObject>(CLASS, new vector<myObject, allocator<myObject>>(tSize));
		testVec[TESTSIZE - 4 + i] = (vecWrapper*)pNewVec;
	}
	end = clock();
	cout << "The runtime of " << TESTSIZE << " allocate operations is " << (double)(end - begin) / CLOCKS_PER_SEC << "s" << endl;

	//test resize
	begin = clock();
	for (int i = 0; i < PICKSIZE; i++) {
		tIndex = (int)((float)rand() / (float)RAND_MAX * (float)TESTSIZE);
		tSize = (int)((float)rand() / (float)RAND_MAX * (float)TESTSIZE);
		testVec[tIndex]->resize(tSize);
	}
	end = clock();
	cout << "The runtime of " << PICKSIZE << " resize operations is " << (double)(end - begin) / CLOCKS_PER_SEC << "s" << endl;

	//test assignment
	tIndex = (int)((float)rand() / (float)RAND_MAX * (TESTSIZE - 4 - 1));
	int tIntValue = 10;
	testVec[tIndex]->setElement(testVec[tIndex]->size() / 2, &tIntValue);
	if (!testVec[tIndex]->checkElement(testVec[tIndex]->size() / 2, &tIntValue))
		cout << "incorrect assignment in vector %d\n" << tIndex << endl;

	tIndex = TESTSIZE - 4 + 3;
	myObject tObj(11, 15);
	testVec[tIndex]->setElement(testVec[tIndex]->size() / 2, &tObj);
	if (!testVec[tIndex]->checkElement(testVec[tIndex]->size() / 2, &tObj))
		cout << "incorrect assignment in vector %d\n" << tIndex << endl;

	myObject tObj1(13, 20);
	testVec[tIndex]->setElement(testVec[tIndex]->size() / 2, &tObj1);
	if (!testVec[tIndex]->checkElement(testVec[tIndex]->size() / 2, &tObj1))
		cout << "incorrect assignment in vector " << tIndex << " for object (13,20)" << endl;

	begin = clock();
	for (int i = 0; i < TESTSIZE; i++)
		delete testVec[i];
	delete[]testVec;
	end = clock();
	cout << "The runtime of " << TESTSIZE << " delete operations is " << (double)(end - begin) / CLOCKS_PER_SEC << "s" << endl;
	cout << "Well done!" << endl;
	return 0;

}
#endif

#ifdef _TEST_MYALLOCATOR_

int main()
{
	vecWrapper** testVec;
	testVec = new vecWrapper *[TESTSIZE];
	clock_t begin, end;
	int tIndex, tSize;

	cout << "Myallocator" << endl;
	begin = clock();
	//test MyAllocator
	for (int i = 0; i < TESTSIZE - 4; i++)
	{
		tSize = (int)((float)rand() / (float)RAND_MAX * 10000);
		vecWrapperT<int> *pNewVec = new vecWrapperT<int>(INT, new std::vector<int, MyAllocator<int> >(tSize));
		testVec[i] = (vecWrapper *)pNewVec;
	}

	for (int i = 0; i < 4; i++)
	{
		tSize = (int)((float)rand() / (float)RAND_MAX * 10000);
		vecWrapperT<myObject> *pNewVec = new vecWrapperT<myObject>(CLASS, new std::vector<myObject, MyAllocator<myObject> >(tSize));
		testVec[TESTSIZE - 4 + i] = (vecWrapper *)pNewVec;
	}
	end = clock();
	cout << "The runtime of " << TESTSIZE << " allocate operations is " << (double)(end - begin) / CLOCKS_PER_SEC << "s" << endl;

	//test resize
	begin = clock();
	for (int i = 0; i < 100; i++)
	{
		tIndex = (int)((float)rand() / (float)RAND_MAX * (float)TESTSIZE);
		tSize = (int)((float)rand() / (float)RAND_MAX * (float)TESTSIZE);
		testVec[tIndex]->resize(tSize);
	}
	end = clock();
	cout << "The runtime of " << PICKSIZE << " resize operations is " << (double)(end - begin) / CLOCKS_PER_SEC << "s" << endl;

	//test assignment
	tIndex = (int)((float)rand() / (float)RAND_MAX * (TESTSIZE - 4 - 1));
	int tIntValue = 10;
	testVec[tIndex]->setElement(testVec[tIndex]->size() / 2, &tIntValue);
	if (!testVec[tIndex]->checkElement(testVec[tIndex]->size() / 2, &tIntValue))
		cout << "incorrect assignment in vector %d\n" << tIndex << std::endl;

	tIndex = TESTSIZE - 4 + 3;
	myObject tObj(11, 15);
	testVec[tIndex]->setElement(testVec[tIndex]->size() / 2, &tObj);
	if (!testVec[tIndex]->checkElement(testVec[tIndex]->size() / 2, &tObj))
		cout << "incorrect assignment in vector %d\n" << tIndex << std::endl;

	myObject tObj1(13, 20);
	if (!testVec[tIndex]->checkElement(testVec[tIndex]->size() / 2, &tObj1))
		std::cout << "incorrect assignment in vector " << tIndex << " for object (13,20)" << std::endl;

	begin = clock();
	for (int i = 0; i < TESTSIZE; i++)
		delete testVec[i];
	delete[]testVec;

	end = clock();
	cout << "The runtime of " << TESTSIZE << " delete operations is " << (double)(end - begin) / CLOCKS_PER_SEC << "s" << endl;
	cout << "Well done!" << endl;

	system("pause");
	return 0;

}

#endif

#ifdef _TEST_STD_PTA_

int main()
{
	std::random_device rd;
	std::mt19937 gen(rd());
	std::uniform_int_distribution<> dis(1, TESTSIZE);

	clock_t begin, end;

	cout << "std::allocator" << endl;
	begin = clock();

	// vector creation
	using IntVec = std::vector<int, allocator<int>>;
	std::vector<IntVec, allocator<IntVec>> vecints(TESTSIZE);
	for (int i = 0; i < TESTSIZE; i++)
		vecints[i].resize(dis(gen));

	using PointVec = std::vector<Point2D, allocator<Point2D>>;
	std::vector<PointVec, allocator<PointVec>> vecpts(TESTSIZE);
	for (int i = 0; i < TESTSIZE; i++)
		vecpts[i].resize(dis(gen));
	end = clock();
	cout << "The runtime of " << TESTSIZE << " allocate operations is " << (double)(end - begin) / CLOCKS_PER_SEC << "s" << endl;

	// vector resize
	begin = clock();
	for (int i = 0; i < PICKSIZE; i++)
	{
		int idx = dis(gen) - 1;
		int size = dis(gen);
		vecints[idx].resize(size);
		vecpts[idx].resize(size);
	}
	end = clock();
	cout << "The runtime of " << PICKSIZE << " resize operations is " << (double)(end - begin) / CLOCKS_PER_SEC << "s" << endl;

	// vector element assignment
	{
		int val = 10;
		int idx1 = dis(gen) - 1;
		int idx2 = vecints[idx1].size() / 2;
		vecints[idx1][idx2] = val;
		if (vecints[idx1][idx2] == val)
			std::cout << "correct assignment in vecints: " << idx1 << std::endl;
		else
			std::cout << "incorrect assignment in vecints: " << idx1 << std::endl;
	}
	{
		Point2D val(11, 15);
		int idx1 = dis(gen) - 1;
		int idx2 = vecpts[idx1].size() / 2;
		vecpts[idx1][idx2] = val;
		if (vecpts[idx1][idx2] == val)
			std::cout << "correct assignment in vecpts: " << idx1 << std::endl;
		else
			std::cout << "incorrect assignment in vecpts: " << idx1 << std::endl;
	}

	return 0;
}
#endif

#ifdef _TEST_MYALLOCATOR_PTA_

int main()
{
	std::random_device rd;
	std::mt19937 gen(rd());
	std::uniform_int_distribution<> dis(1, TESTSIZE);
	clock_t begin, end;

	// vector creation
	cout << "Myllocator" << endl;
	begin = clock();
	using IntVec = std::vector<int, allocator<int>>;
	std::vector<IntVec, MyAllocator<IntVec>> vecints(TESTSIZE);
	for (int i = 0; i < TESTSIZE; i++)
		vecints[i].resize(dis(gen));

	using PointVec = std::vector<Point2D, allocator<Point2D>>;
	std::vector<PointVec, MyAllocator<PointVec>> vecpts(TESTSIZE);
	for (int i = 0; i < TESTSIZE; i++)
		vecpts[i].resize(dis(gen));
	end = clock();
	cout << "The runtime of " << TESTSIZE << " allocate operations is " << (double)(end - begin) / CLOCKS_PER_SEC << "s" << endl;

	// vector resize
	begin = clock();
	for (int i = 0; i < PICKSIZE; i++)
	{
		int idx = dis(gen) - 1;
		int size = dis(gen);
		vecints[idx].resize(size);
		vecpts[idx].resize(size);
	}
	end = clock();
	cout << "The runtime of " << PICKSIZE << " resize operations is " << (double)(end - begin) / CLOCKS_PER_SEC << "s" << endl;

	// vector element assignment
	{
		int val = 10;
		int idx1 = dis(gen) - 1;
		int idx2 = vecints[idx1].size() / 2;
		vecints[idx1][idx2] = val;
		if (vecints[idx1][idx2] == val)
			std::cout << "correct assignment in vecints: " << idx1 << std::endl;
		else
			std::cout << "incorrect assignment in vecints: " << idx1 << std::endl;
	}
	{
		Point2D val(11, 15);
		int idx1 = dis(gen) - 1;
		int idx2 = vecpts[idx1].size() / 2;
		vecpts[idx1][idx2] = val;
		if (vecpts[idx1][idx2] == val)
			std::cout << "correct assignment in vecpts: " << idx1 << std::endl;
		else
			std::cout << "incorrect assignment in vecpts: " << idx1 << std::endl;
	}

	return 0;
}
#endif

#ifdef _TEST_FILE_

int main() {
	int test_size, pick_size;
	int tIndex, tSize;
	int type;
	string stype;
	string filename;
	cout << "Input the filename: ";
	cin >> filename;
	cout << "Input the number to be allocated: ";
	cin >> test_size;
	cout << "Input the number to be resized: ";
	cin >> pick_size;

	ofstream fout(("test//" + filename).c_str(), ios::out);
	if (!fout) {
		cout << "Error opening file." << endl;
		return 0;
	}
	fout << test_size << endl;
	srand(time(0));
	for (int i = 0; i < test_size; i++) {
		tSize = (int)((float)rand() / (float)RAND_MAX * 10000);
		type = (int)((float)rand() / (float)RAND_MAX * 4) + 1;
		switch (type) {
			case 1: stype = "int"; break;
			case 2: stype = "float"; break;
			case 3: stype = "double"; break;
			case 4: stype = "class"; break;
			default: break;
		}
		fout << tSize << " " << stype << endl;
		cout << tSize << " " << stype << endl;
	}
	fout << pick_size << endl;
	for (int i = 0; i < pick_size; i++) {
		tIndex = (int)((float)rand() / (float)RAND_MAX * 10000);
		tSize = (int)((float)rand() / (float)RAND_MAX * 10000);
		if (i == pick_size - 1) fout << tIndex << " " << tSize;
		else fout << tIndex << " " << tSize << endl;
		cout << tIndex << " " << tSize << endl;
	}
	fout.close();
	cout << "Finish successfully!" << endl;
	system("pause");
	return 0;
}
#endif 

#ifdef _TEST_WITH_FILE_

int main()
{
	int TestSize;
	string filename;
	cout << "Input the filename: ";
	cin >> filename;
	ifstream file(("test\\" + filename).c_str(), ios::in);
	if (!file)//test if the file is opened successfully
	{
		cout << "Error opening file." << endl;
		return 0;
	}
	file >> TestSize;

	vecWrapper **testVec;
	testVec = new vecWrapper*[TestSize];
	clock_t start, stop;//the start and end of the runtime
	double runtime = 0.0;

	int tIndex, tSize;
	string type;

	//test allocator
	for (int i = 0; i < TestSize; i++)
	{
		file >> tSize >> type;
		if ((!strcmp(type.c_str(), "int")) || (!strcmp(type.c_str(), "Int")))
		{
			start = clock();
			vecWrapperT<int> *pNewVec = new vecWrapperT<int>(INT, new std::vector<int, MyAllocator<int>>(tSize));
			testVec[i] = (vecWrapper *)pNewVec;
			stop = clock();
			runtime += (double)(stop - start) / CLOCKS_PER_SEC;
		}
		else if ((!strcmp(type.c_str(), "float")) || (!strcmp(type.c_str(), "Float")))
		{
			start = clock();
			vecWrapperT<float> *pNewVec = new vecWrapperT<float>(INT, new std::vector<float, MyAllocator<float>>(tSize));
			testVec[i] = (vecWrapper *)pNewVec;
			stop = clock();
			runtime += (double)(stop - start) / CLOCKS_PER_SEC;
		}
		else if ((!strcmp(type.c_str(), "double")) || (!strcmp(type.c_str(), "Double")))
		{
			start = clock();
			vecWrapperT<double> *pNewVec = new vecWrapperT<double>(INT, new std::vector<double, MyAllocator<double>>(tSize));
			testVec[i] = (vecWrapper *)pNewVec;
			stop = clock();
			runtime += (double)(stop - start) / CLOCKS_PER_SEC;
		}
		else if ((!strcmp(type.c_str(), "class")) || (!strcmp(type.c_str(), "Class")))
		{
			start = clock();
			vecWrapperT<myObject> *pNewVec = new vecWrapperT<myObject>(CLASS, new std::vector<myObject, MyAllocator<myObject>>(tSize));
			testVec[i] = (vecWrapper *)pNewVec;
			stop = clock();
			runtime += (double)(stop - start) / CLOCKS_PER_SEC;
		}
	}
	std::cout << "The runtime of " << TESTSIZE << " allocate operations is " << runtime << " s" << endl;

	//test resize
	double runtime2 = 0.0;
	int count = 0;
	while (!file.eof())
	{
		file >> tIndex >> tSize;
		if (tSize == 0) break;
		start = clock();
		testVec[tIndex]->resize(tSize);
		stop = clock();
		runtime2 += (double)(stop - start) / CLOCKS_PER_SEC;
		count++;
	}
	std::cout << "The runtime of " << count << " resize operations is " << runtime2 << " s" << endl;

	file.close();//close the file

	double runtime3 = 0.0;
	for (int i = 0; i < TESTSIZE; i++)
		delete testVec[i];
	std::cout << "circle delete OK!" << endl;
	delete[]testVec;

	std::cout << "delete OK!" << endl;
	stop = clock();
	runtime3 += (double)(stop - start) / CLOCKS_PER_SEC;
	std::cout << "The runtime of delete operations is " << runtime3 << " s" << endl;

	system("pause");
	return 0;
}
#endif
