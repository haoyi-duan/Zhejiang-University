#pragma once

#include <string>
#include "base.h"
#include "API.h"
#include "BufferManager.h"
#define TABLE_DEFINITION "Table_Definition"

using namespace std;
extern class BufferManager bf;//?

//*all the function are public
class CataManager {
   public:
	CataManager(){};
	void create_table(string s, Attribute atb, short primary, Index index);
	bool hasTable(std::string s);
	Table* getTable(std::string s);
	void create_index(std::string tname, std::string aname, std::string iname);
	void drop_table(std::string t);
	void drop_index(std::string tname, std::string iname);
	void show_table(std::string tname);
	void changeblock(std::string tname, int bn);

   private:
	void create_table_NoApi(string s, Attribute atb, short primary, Index index, int bn);
	void drop_table_NoApi(std::string t);
	void LoadInfo(string s, Attribute atb, short primary, Index index, char* head,int bn);
	char* FindPtrPosition(string s, char*& base, short& recIdx);
	short FindLocation(string aname, string tname);
};
