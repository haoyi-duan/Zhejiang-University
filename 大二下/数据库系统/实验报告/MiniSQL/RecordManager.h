#ifndef _RECORDMANAGER_H
#define _RECORDMANAGER_H
#include "BufferManager.h"

#include "base.h"
#include "const.h"

class RecordManager {
   public:
	RecordManager(class BufferManager* bf) : buf_ptr(bf) {}
	~RecordManager();
	bool isSatisfied(Table& tableinfor, tuper& row, vector<int> mask, vector<where> w);
	Table Select(Table& tableIn, vector<int> attrSelect, vector<int> mask, vector<where>& w);
	Table Select(Table& tableIn, vector<int> attrSelect);
	void CreateIndexCatalog(string iname, int attr, string tname, Table &tableIn);
	int FindWithIndex(Table& tableIn, tuper& row, int mask);
	tuper* Char2Tuper(Table& tableIn, char* stringRow);
	void InsertWithIndex(Table& tableIn, tuper& singleTuper);
	char* Tuper2Char(Table& tableIn, tuper& singleTuper);
	int Delete(Table& tableIn, vector<int> mask, vector<where> w);
	bool DropTable(Table& tableIn);
	bool CreateTable(Table& tableIn);
	Table SelectProject(Table& tableIn, vector<int> attrSelect);
	bool UNIQUE(Table& tableinfo, where w, int loca);

   private:
	RecordManager() {}
	class BufferManager* buf_ptr;
};

#endif
