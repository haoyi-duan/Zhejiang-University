#pragma once
#ifndef _API_H
#define _API_H
#include "base.h"
#include "RecordManager.h"

using namespace std;
extern class BufferManager bf;

class API
{
private:
	class RecordManager rm;	
public:
	API() :rm(&bf){}
	~API();
	Table Select(Table& tableIn, vector<int> attrSelect, vector<int>mask, vector<where> w);//return a table containing select results
	int Delete(Table& tableIn, vector<int>mask, vector<where> w);
	void Insert(Table& tableIn, tuper& singleTuper);
	bool DropTable(Table& tableIn);
	void DropIndex(Table& tableIn, int attr);
	bool CreateTable(Table& tableIn);
	bool CreateIndex(Table& tableIn, int attr);
};

#endif //end of _API_H
