#ifndef FRACTION_H
#define FRACTION_H
#include <iostream>
#include <vector>
#include <algorithm>
#include <string>
#include <cmath>
#include <exception>

using namespace std;

// If the input is invalid, catch the class err and return error.
class err
{
public:
    err(int i):i(i) { };
    void what();
private:
    int i;
};

class fraction
{
public:
    fraction():a(0), b(1){ }; //default ctor
    fraction(int a, int b):a(a), b(b) //ctor takes twe integers as parameters
    {
        if (b == 0) 
        {
            throw err(0); //"Denominator should not be zero.";
        }
        int gcdNum = gcd(a, b);
        this->a /= gcdNum;
        this->b /= gcdNum;
    };
    fraction(const fraction & c); //copy ctor
    ~fraction();
    //arithmetical operators : + - * /
    fraction operator+(fraction & b);
    fraction operator-(fraction & b);
    fraction operator*(fraction & b);
    fraction operator/(fraction & b);
    //relational operators : < <= == != >= >
    bool operator<(fraction & b);
    bool operator<=(fraction & b);
    bool operator==(fraction & b);
    bool operator!=(fraction & b);
    bool operator>=(fraction & b);
    bool operator>(fraction & b);
    //type cast to double
    double castToDouble();
    //type cast to string
    string castToString();
    static int gcd(int a, int b); //greatest common divisor
    //inserter and extractor for streams
    friend istream & operator>>(istream &is, fraction &obj);
	friend ostream & operator<<(ostream &os, const fraction &obj);
    //conversion from a finite decimal string like : 1.414
    fraction(string str); //convert from string. 
    void strDiv(string str);
private:
    int a; //numerator of the fraction.
    int b; //denominator of the fraction.
};

#endif