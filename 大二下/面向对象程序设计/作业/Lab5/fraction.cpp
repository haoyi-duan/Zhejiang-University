#include "fraction.h"

// Caculate the gcd number for integers a and b.
int fraction::gcd(int a, int b)
{
    if (abs(a) < abs(b)) 
    {
        int temp = a;
        a = b;
        b = temp;
    }
    for (int i = abs(b); i > 0; i--)
        if(a%i == 0 && b%i == 0)
            return i; 
    return 1;
}

//copy ctor.
fraction::fraction(const fraction & c)
{
    this->a = c.a;
    this->b = c.b;
}

fraction::fraction(string str)
{
    fraction f;
    this->strDiv(str);
}

// Divide the string to get the fenzi and fenmu.
void fraction::strDiv(string str)
{
    if (str.length() > 31) throw err(1); //("The decimal string is too long!");
    int cnt = 0;
    for (int i = 0; i < str.length(); i++)
        if (str[i] == '.') cnt++;
    if (cnt != 1) throw err(2); //("Input an illegal character!");

    bool flag = false;
    if (!(str[0] == '+' || str[0] == '-' || str[0] == '.' || (str[0] >= '0' && str[0] <= '9'))) throw err(2); //("Input an illegal character!");
    for (int i = 1; i < str.length(); i++)
        if (!((str[i] >= '0' && str[i] <= '9') || str[i] == '.'))
        {
            flag = true;
            break;
        }
    if (flag) throw err(2); //("Input an illegal character!");
    int sign = 1;
    if (str[0] == '-') sign = -1;
    this->b = pow(10, str.length()-str.find('.')-1);
    this->a = 0;
    for (int i = 0; i < str.length(); i++)
    {
        if (str[i] == '-' || str[i] == '+' || str[i] == '.') continue;
        this->a *= 10;
        this->a += (str[i]-'0');
    }
    int gcdNum = gcd(this->a, this->b);
    this->a /= gcdNum;
    this->a *= sign;
    this->b /= gcdNum;
}

fraction::~fraction()
{

}

// Reload the operator +.
fraction fraction::operator+(fraction & b)
{
    fraction tmp;
    tmp.a = this->a*b.b + this->b*b.a;
    tmp.b = this->b*b.b;
    int gcdNum = gcd(tmp.a, tmp.b);
    tmp.a /= gcdNum;
    tmp.b /= gcdNum;
    return tmp;
}

// Reload the operator -.
fraction fraction::operator-(fraction & b)
{
    fraction tmp;
    tmp.a = this->a*b.b - this->b*b.a;
    tmp.b = this->b*b.b;
    int gcdNum = gcd(tmp.a, tmp.b);
    tmp.a /= gcdNum;
    tmp.b /= gcdNum;
    return tmp;    
}

// Reload the operator *.
fraction fraction::operator*(fraction & b)
{
    fraction tmp;
    tmp.a = this->a*b.a;
    tmp.b = this->b*b.b;
    int gcdNum = gcd(tmp.a, tmp.b);
    tmp.a /= gcdNum;
    tmp.b /= gcdNum;
    return tmp;    
}
// Reload the operator /.
fraction fraction::operator/(fraction & b)
{
    fraction tmp;
    tmp.a = this->a*b.b;
    tmp.b = this->b*b.a;
    int gcdNum = gcd(tmp.a, tmp.b);
    tmp.a /= gcdNum;
    tmp.b /= gcdNum;
    return tmp;    
}

// Reload the operator <.
bool fraction::operator<(fraction & b)
{
    fraction tmp = *this-b;
    return tmp.a*tmp.b < 0;
}

// Reload the operator <=.
bool fraction::operator<=(fraction & b)
{
    return *this < b || *this == b;
}
// Reload the operator ==.
bool fraction::operator==(fraction & b)
{
    fraction tmp = *this-b;
    return tmp.a*tmp.b == 0;    
}

// Reload the operator !=.
bool fraction::operator!=(fraction & b)
{
    return !(*this == b);
}

// Reload the operator >=.
bool fraction::operator>=(fraction & b)
{
    return !(*this < b);
}

// Reload the operator >.
bool fraction::operator>(fraction & b)
{
    fraction tmp = *this-b;
    return tmp.a*tmp.b > 0;
}

// cast the fraction to double type.
// For example, a = 1, b = 4, the double type of the fraction is 0.25.
double fraction::castToDouble()
{
    double tmp = 1.0 * a / b;
    return tmp;
}

// Cast the fraction to string. 
// For example, a = 1, b = 3, the string is "1/3".
string fraction::castToString()
{
    return to_string(a) + '/' + to_string(b);
}

//reload the input function so that we can get the the two parameters of the fraction using "cin << x;" 
istream & operator>>(istream &is, fraction & obj)
{
    int nu, de;
    char c;
    while (is >> nu >> c >> de)
    {
        if (c == '/' && de != 0)
        {
            obj.a = nu;
            obj.b = de;
            break;
        }
        else cout << "Error! Try again!" << endl;
    }
    return is;
}

// reload the cout so that we can print out the fraction like "cout << (fraction type)obj << endl;"
ostream & operator<<(ostream & os, const fraction & obj)
{
    if (obj.a == 0)
        return os << "0";
    else if (obj.a == obj.b)
        return os << "1";
    else if (obj.b == 1) 
        return os << obj.a;
    os << obj.a << "/" << obj.b;
    return os;
}

// return err 
void err::what()
{
    if (!i) cout << "Denominator should not be zero." << endl;
    else if (i == 1) cout << "The decimal string is too long!" << endl;
    else if (i == 2) cout << "Input an illegal character!" << endl;
}