#include "fraction.h"
#include "fraction.cpp"

int main ()
{   
 	//default ctor
	try 
    {
        fraction a;
	    cout << "-------default ctor-------" << endl;
	    cout << "a = " << a << endl;
    }
	catch (err &e) { e.what(); }

    //ctor takes two integers as parameters
	cout << "-------ctor takes two integers as parameters-------" << endl;
	cout << "Input two integers as parameters:" << endl;
	int m, n;
	cin >> m >> n;
	try
    {
        fraction b(m, n);
	    cout << "b = " << b << endl;
    } 
    catch (err &e) { e.what(); }
    try
    {
        fraction b(3, 0);
	    cout << "b = " << b << endl;
    } 
    catch (err &e) { e.what(); }

	//copy ctor
	cout << "-------copy ctor b to c-------" << endl;
	fraction b(12, 38);
    try 
    {
        fraction c(b);
	    cout << "c = " << c << endl;
    }
    catch (err &e) { e.what(); }

	//inserter and extractor for streams
	cout << "-------inserter and extractor for streams-------" << endl;
	fraction x, y;
	cout << "Input two fractions x, y (example:1/3):" << endl;
	cout << "Nonminimalist fractions will be automatically simplified." << endl;
	cin >> x >> y;
	cout << "x = " << x << endl;
	cout << "y = " << y << endl;

	//arithmetical operators: + - * /
	cout << "-------arithmetical operators-------" << endl;
	cout << "x + y = " << x + y << endl;
	cout << "x - y = " << x - y << endl;
	cout << "x * y = " << x * y << endl;
	cout << "x / y = " << x / y << endl;

	//relational operators : < <= == != >= >
	cout << "-------relational operators-------" << endl;
	cout << "x < y is " << (x < y) << endl;
	cout << "x <= y is " << (x <= y) << endl;
	cout << "x == y is " << (x == y) << endl;
	cout << "x != y is " << (x != y) << endl;
	cout << "x >= y is " << (x >= y) << endl;
	cout << "x > y is " << (x > y) << endl;

	//type cast to double
	cout << "-------type cast to double-------" << endl;
	double p = x.castToDouble();
	cout << "x type cast to double p." << endl << "p = " << p << endl;
	//type cast to string
	cout << "-------type cast to string-------" << endl;
	string q = x.castToString();
	cout << "x type cast to string q." << endl << "q = " << q << endl;

	//conversion from a finite decimal string like : 1.414
	cout << "-------conversion from a finite decimal string-------" << endl;
	cout << "Input a finite decimal string like 1.414:" << endl;
	string str;
	cin >> str;
	try
    {
        fraction d(str);
	    cout << "d = " << d << endl;
    }
    catch(err & e)
    {
        e.what();
    }
    
	system("pause");
	return 0;
}