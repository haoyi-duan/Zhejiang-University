#include "Vector.h"
#include <iostream>
using namespace std;

int main()
{
	/*****************************/
	cout << "/*Vector()*/" << endl;
	Vector<int> vec;
	cout << "Test whether the vector is empty:" << endl;
	cout << vec.empty() << endl;

	for (auto i = 0; i < 1024; i++)
		vec.push_back(i);
	cout << "Test the size of the vector:" << endl;
	cout << vec.size() << endl;

	cout << "Print the value in the vactor:" << endl;
	for (auto i = 1; i <= 100; i++)
	{
		cout << vec[i] << "\t";
		if (i % 10 == 0) cout << endl;
	}
	cout << endl;
	/*****************************/
	cout << "/*Vector(int size)*/" << endl;
	Vector<int> vec1(100);
	cout << "The size of vec1:" << endl;
	cout << vec1.size() << endl;
	cout << endl;
	/*****************************/
	cout << "/*Vector(const Vector& r)*/" << endl;
	Vector<int> vec2(vec);
	cout << "Test the size of the vector:" << endl;
	cout << vec2.size() << endl;
	cout << "After clearing the vector:" << endl;
	vec2.clear();
	cout << vec2.size() << endl;
	cout << endl;
	/*****************************/
	cout << "/*at(int index)*/" << endl;
	cout << "Test out of range:" << endl;
	try { cout << vec.at(-1) << endl; }
	catch (ERROR & e)
	{   // catch error and print the err message.
		cout << e.what() << endl;
	}
	cout << "Test if in the range:" << endl;
	try { cout << vec.at(99) << endl; }
	catch (ERROR & e)
	{   // catch error and print the err message.
		cout << e.what() << endl;
	}
	cout << "Test whether the vector is empty:" << endl;
	cout << vec.empty() << endl;

	return 0;
}