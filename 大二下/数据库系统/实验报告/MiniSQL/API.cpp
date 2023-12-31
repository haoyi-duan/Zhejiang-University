
#include "API.h"
#include "IndexManager.h"
// #API api.cpp
API::~API()
{
}

Table API::Select(Table& tableIn, vector<int> attrSelect,vector<int>mask, vector<where> w)
{
//    throw std::bad_alloc();
	return rm.Select(tableIn, attrSelect,mask, w);
}

int API::Delete(Table& tableIn, vector<int>mask, vector<where> w)
{
	int res;
	res = rm.Delete(tableIn, mask, w);
	return res;
}

void API::Insert(Table& tableIn, tuper& singleTuper)
{
	rm.InsertWithIndex(tableIn, singleTuper);
}

bool API::DropTable(Table& tableIn)
{
	bool res;
	res = rm.DropTable(tableIn);
	for (int i = 0; i < tableIn.index.num;i++) {
		DropIndex(tableIn, tableIn.index.location[i]);
	}
	return res;
}

void API::DropIndex(Table& tableIn, int i)
{
	IndexManager indexMA;
	string iname;
	iname = tableIn.index.indexname[i]  + ".index";
	indexMA.Drop(iname);

}

bool API::CreateTable(Table& tableIn)
{
	IndexManager indexMA;
	bool res;
	int i;
	res = rm.CreateTable(tableIn);
	return true;	
}

bool API::CreateIndex(Table &tableIn, int attr)
{
	IndexManager indexMA;
	string file_name;
	file_name = tableIn.getname() + to_string(attr) + ".index";
	indexMA.Establish(file_name);

	rm.CreateIndexCatalog(tableIn.index.indexname[tableIn.index.num - 1], attr, tableIn.Tname, tableIn);
	//CreateIndexCatalog(const string & indexname, int attr, const string & tablename, Table& tableIn);
	// vector<int> attrSelect;
	// attrSelect.push_back(attr);
	// Table tableForindex(rm.Select(tableIn, attrSelect));
	// for (int i = 0; i < tableForindex.T.size(); i++) {
	// 	indexMA.Insert(file_name, tableForindex.T[i]->data[attr], i);
	// }
	return true;
}
