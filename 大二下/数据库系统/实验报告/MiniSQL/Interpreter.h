#ifndef Interpreter_h
#define Interpreter_h
#include <iostream>
#include <string>
#include <cmath>
#include <fstream>
#include <vector>

using namespace std;
//extern map <string, bool> tablelist;

class InterManager
{
public:    
    string qs;
    void getQueryString();
    void normolize();

    bool Exec();
    void ExecDrop();
    void ExecCreate();
    void ExecCreateTable(int lastPos);
    void ExecCreateIndex(int lastPos);
    void ExecDelete();
    void ExecSelect();
    void ExecInsert();
    void ExecFile();
	void ExecQuit();
    inline int readElement(int pos);
    void interWhere(int& pos1, vector<int> &attrwhere, vector<struct where> &w, struct Attribute A, class Table* t, bool& selectOr);
};

class QueryException:exception
{
private:
    string text;
public:
    QueryException(string s):text(s){ }
    string what() {return text;}
};

bool isCharacter(char a);
bool isValidAttribute(const string& a);
bool toFloat(const string& s, float& a);
bool toInt(const string& s, int& a);

#endif
