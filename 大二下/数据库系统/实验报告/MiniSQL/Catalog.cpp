#include "Catalog.h"
#include "Interpreter.h"
#include <map>

extern map<string, bool> tablelist;
void CataManager::LoadInfo(string s, Attribute atb, short primary, Index index, char* head, int bn) {
	//*Table
	strcpy(head, s.c_str());
	head += sizeof(char) * (s.length() + 1);
	*(int*)head = bn;  //*blockNum
	head += sizeof(int);
	//*Attr
	*(int*)head = atb.num;
	head += sizeof(int);
	for (int i = 0; i < atb.num; i++) {
		*(short*)head = atb.flag[i];
		head += sizeof(short);
		strcpy(head, atb.name[i].c_str());
		head += sizeof(char) * (atb.name[i].length() + 1);
		*head = atb.unique[i];
		head += sizeof(bool);
	}
	*(short*)head = primary;
	head += sizeof(short);
	//*index
	*(int*)head = index.num;
	head += sizeof(int);
	for (int i = 0; i < index.num; i++) {
		*(short*)head = index.location[i];
		head += sizeof(short);
		strcpy(head, index.indexname[i].c_str());
		head += sizeof(char) * (index.indexname[i].length() + 1);
	}
}

void CataManager::create_table_NoApi(string s, Attribute atb, short primary, Index index, int bn) {
	//*Name T_s
	int bufferIdx = bf.GiveMeABlock(TABLE_DEFINITION, 0);
	bf.writeBlock(bufferIdx);
	char* head = bf.bufferBlock[bufferIdx].values;
	//*Slotted Page Strategy
	//*# Blocks all block will have this, but only the first one us used
	//*8
	//*# entries
	//*4
	//*free space pointer(ALL in Byte)
	//*4

	//*record:
	//*table name, block num, attribute num
	//*string 8 8
	//* attribute data sqprated by \0 (only for string)
	//*4 char* 1
	//*primaty key
	//*4

	//*index num
	//*8
	//*index location, indexname
	//*4 string
	//*record size short include \0
	//! size < 4096
	//*record location short
	//*4

	//*check if the first block is new[]
	if (hasTable(s)) {
		throw TableException("CreateTable() Redefinition of:" + s);
		return;
	}

	int blockN;
	short entryN;
	short freeP;
	if (*head == '#') {
		blockN = 1;
		entryN = 0;
		freeP = BlockSize - 1;
		//*write
		*(int*)head = blockN;
		head += sizeof(int);
		*(short*)head = entryN;
		head += sizeof(short);
		*(short*)head = freeP;
		head -= sizeof(int) + sizeof(short);
	}
	//*calculate size
	short size = 0;
	//*Table
	size += s.length() + 1;
	size += 2 * sizeof(int);  //*blocknum and atb.num
	for (int i = 0; i < atb.num; i++) {
		size += sizeof(short);
		size += atb.name[i].length() + 1;  //*char is 1
		size += sizeof(bool);
	}
	size += sizeof(short);	//*primary
	size += sizeof(int);
	for (int i = 1; i < index.num; i++) {
		size += sizeof(short);
		size += index.indexname[i].length() + 1;
	}
	//*which block can insert, linear search
	//*for deletion and change, we will update all records' position immediately
	int blockIdx;
	blockN = *(int*)head;
	for (blockIdx = 0; blockIdx < blockN; blockIdx++) {
		bufferIdx = bf.GiveMeABlock(TABLE_DEFINITION, blockIdx);
		head = bf.bufferBlock[bufferIdx].values;
		head += sizeof(int);
		entryN = *(short*)head;
		head += sizeof(short);
		freeP = *(short*)head;
		short headsize = sizeof(int) + 2 * sizeof(short) + (entryN + 1) * (2 * sizeof(short));
		if (freeP - headsize + 1 > size) {
			*(short*)head -= size;	//*entryN and freeP
			head -= sizeof(short);
			*(short*)head += 1;
			head += 2 * (entryN + 1) * sizeof(short);  //*find last record ptr
			*(short*)head = size;
			head += sizeof(short);
			*(short*)head = freeP - size + 1;  //*record's head
			head = bf.bufferBlock[bufferIdx].values + freeP - size + 1;
			LoadInfo(s, atb, primary, index, head, bn);
			break;
		}
	}
	//*insert update block info
	//*or new a block
	if (blockIdx == blockN) {
		bufferIdx = bf.GiveMeABlock(TABLE_DEFINITION, 0);
		head = bf.bufferBlock[bufferIdx].values;
		blockN += 1;
		*(int*)head = blockN;

		bufferIdx = bf.GiveMeABlock(TABLE_DEFINITION, blockIdx);
		head = bf.bufferBlock[bufferIdx].values;
		*(int*)head = blockN;
		entryN = 1;
		head += sizeof(int);
		*(short*)head = entryN;	 //*entryN and freeP
		freeP = BlockSize - 1;	 //! size<4096
		head += sizeof(short);
		*(short*)head = freeP - size;
		head += sizeof(short);	//*find last record ptr
		*(short*)head = size;
		head += sizeof(short);
		*(short*)head = freeP - size + 1;  //*record's head
		head = bf.bufferBlock[bufferIdx].values + freeP - size + 1;
		LoadInfo(s, atb, primary, index, head, bn);
	}
}

void CataManager::create_table(string s, Attribute atb, short primary, Index index) {
	create_table_NoApi(s, atb, primary, index, 0);
	Table* t = getTable(s);
	API api;
	api.CreateTable(*t);
	delete t;
}

char* CataManager::FindPtrPosition(string s, char*& base, short& recIdx) {	//*return the address of the data of entry
	int bufferIdx = bf.GiveMeABlock(TABLE_DEFINITION, 0);
	char* head = bf.bufferBlock[bufferIdx].values;
	//*if new file, initialize it and return NULL
	int blockN;
	short entryN;
	short freeP;
	if (*head == '#') {
		blockN = 1;
		entryN = 0;
		freeP = BlockSize - 1;
		//*write
		*(int*)head = blockN;
		head += sizeof(int);
		*(short*)head = entryN;
		head += sizeof(short);
		*(short*)head = freeP;

		return NULL;
	}
	//*
	blockN = *(int*)head;
	int blockIdx;
	for (blockIdx = 0; blockIdx < blockN; blockIdx++) {
		int bufferIdx = bf.GiveMeABlock(TABLE_DEFINITION, blockIdx);
		char* head = bf.bufferBlock[bufferIdx].values;
		short entryN;
		head += sizeof(int);  //*place to store bn, but without ture value
		entryN = *(short*)head;
		short entryIdx;
		char* pos0 = head + 2 * sizeof(short);	//*entry freeP
		for (entryIdx = 0; entryIdx < entryN; entryIdx++, pos0 += sizeof(short)) {
			pos0 += sizeof(short);	//*size ahh GOOD
			short addr;
			addr = *(short*)pos0;
			char* pos = head - sizeof(int) + addr;
			if ((string)pos == s) {
				base = head - sizeof(int);
				recIdx = entryIdx;
				return pos0;
			}
		}
	}
	return NULL;
}

// char* FindPosition(string s) {
// 	char* base;
// 	char* pos0 = FindPtrPostion(s, base,);
// 	short addroffset = *(short*)pos0;
// 	return base + addroffset;
// }

bool CataManager::hasTable(std::string s) {
	char* base;
	short idx;
	return !!FindPtrPosition(s, base, idx);
}

Table* CataManager::getTable(std::string s) {
	int bufferIdx = bf.GiveMeABlock(TABLE_DEFINITION, 0);
	char* head = bf.bufferBlock[bufferIdx].values;
	//*if new file, initialize it and return NULL
	int blockN;
	short entryN;
	short freeP;
	if (*head == '#') {
		blockN = 1;
		entryN = 0;
		freeP = BlockSize - 1;
		//*write
		*(int*)head = blockN;
		head += sizeof(int);
		*(short*)head = entryN;
		head += sizeof(short);
		*(short*)head = freeP;

		throw TableException("GetTable() can't find such table name:" + s + "Becacuse there is no table in the CataMannger.");
		return NULL;
	}
	//*
	blockN = *(int*)head;
	int blockIdx;
	for (blockIdx = 0; blockIdx < blockN; blockIdx++) {
		int bufferIdx = bf.GiveMeABlock(TABLE_DEFINITION, blockIdx);
		head = bf.bufferBlock[bufferIdx].values;
		short entryN;
		entryN = *(short*)(head + sizeof(int));	 //*Not bn
		short entryIdx;
		char* pos0 = head + sizeof(int) + 2 * sizeof(short);  //*entry freeP
		for (entryIdx = 0; entryIdx < entryN; entryIdx++) {
			pos0 += sizeof(short);	//*size ahh GOOD
			// todo dont implement drop index with drop table
			short addr;
			addr = *(short*)pos0;
			char* pos;
			pos = head + addr;
			if ((string)pos == s) {
				//*primary short
				//* index.num int
				//* attr num int
				//*blockN int
				//*all other thing is short
				pos += sizeof(char) * (((string)pos).length() + 1);
				int bn = *(int*)(pos);
				pos += sizeof(int);

				Attribute aa;
				aa.num = *(int*)pos;
				pos += sizeof(int);
				for (int i = 0; i < aa.num; i++) {
					aa.flag[i] = *(short*)pos;	//-1-int 0-float 1~255-char.
					pos += sizeof(short);
					aa.name[i] = pos;
					pos += sizeof(char) * (1 + ((string)pos).length());
					aa.unique[i] = *pos;
					pos += sizeof(bool);
				}

				short primary = *(short*)pos;
				pos += sizeof(short);

				Index index;
				index.num = *(int*)pos;
				pos += sizeof(int);
				for (int i = 0; i < index.num; i++) {
					index.location[i] = *(short*)pos;
					pos += sizeof(short);
					index.indexname[i] = pos;
					pos += sizeof(char) * (1 + ((string)pos).length());
				}

				Table* t = new Table(s, aa, bn);
				t->Copyindex(index);
				t->setprimary(primary);
				return t;
			}
			pos0 += sizeof(short);
		}
	}

	throw TableException("GetTable() can't find such table name:" + s);
	return NULL;
}

//*The dependencies
//*create_index->
//*drop_index->
// todo ENSURE COMPACT
void CataManager::drop_table_NoApi(std::string t) {
	//*find table
	char* base;
	short recIdx;
	char* pos0 = FindPtrPosition(t, base, recIdx);
	if (!pos0) {
		throw TableException("drop_table(): No such table:" + t);
		return;
	}
	//*maintain data area
	short& entryN = *(short*)(base + sizeof(int));
	short& freeP = *(short*)(base + sizeof(int) + sizeof(short));
	short moveSize = *(short*)pos0 - freeP - 1;
	short deltaSize = *(short*)(pos0 - sizeof(short));
	char* cpyaddr = base + freeP + 1 + deltaSize;
	memcpy(cpyaddr, base + freeP + 1, moveSize * sizeof(char));
	//*maintain entry;
	short deltasize2 = 2 * sizeof(short);
	short movesize2 = 2 * sizeof(short) * (entryN - recIdx - 1);
	char* cpyaddr2 = pos0;
	memcpy(cpyaddr2, cpyaddr2 + deltasize2, movesize2 * sizeof(char));
	for (int i = recIdx; i < entryN - 1; i++) {
		*(short*)(pos0 + (i - recIdx) * 2 * sizeof(short)) += deltaSize * sizeof(char);
	}
	//*maintain header
	entryN--;
	freeP += deltaSize * sizeof(char);
}

void CataManager::drop_table(std::string t) {
	Table* ta = getTable(t);
	drop_table_NoApi(t);
	API api;
	api.DropTable(*ta);
}

short CataManager::FindLocation(string aname, string tname) {
	Table* t = getTable(tname);
	for (int i = 0; i < t->attr.num; i++) {
		if (aname == t->attr.name[i]) return i;
	}
	return -1;
}

void CataManager::create_index(std::string tname, std::string aname, std::string iname) {
	//*check valid
	Table* t = getTable(tname);
	short loc;
	for (loc = 0; loc < t->attr.num; loc++) {
		if (aname == t->attr.name[loc]) break;
	}
	if (loc == t->attr.num) {
		throw TableException("create_index() table " + tname + "no such attr name " + aname);
		return;
	}
	for (int i = 0; i < t->index.num; i++) {
		if (iname == t->index.indexname[i]) {
			throw TableException("create_index() table " + tname + "already have a index called" + iname);
			return;
		}
		// if (aname == t->attr.name[t->index.location[i]]) {
		// 	throw TableException("create_index() table " + tname + "already have a index on" + aname);
		// 	return;
		// }
	}
	//*chage table
	t->index.indexname[t->index.num++] = iname;
	t->index.location[t->index.num] = loc;

	//index
	
	//*block access
	char* base;
	short entryIdx;
	char* pos0 = FindPtrPosition(tname, base, entryIdx);
	//*check size
	short delta_size = sizeof(short) + sizeof(char) * (iname.length() + 1);
	int& blockN = *(int*)base;
	short& entryN = *(short*)(base + sizeof(int));
	short& freeP = *(short*)(base + sizeof(int) + sizeof(short));
	short headTail = sizeof(int) + 2 * sizeof(short) * (1 + entryN);

	if (delta_size <= freeP - headTail + 1) {
		//*I change data area
		char* pointer = pos0;
		char* size = pos0 - sizeof(short);
		//*move actual data, give space to insert
		char* begin = base + freeP + 1;
		short movesize = *(short*)pointer + *(short*)size - freeP - 1;
		memcpy(begin - delta_size, begin, movesize * sizeof(char));
		//*aname-->laocation, ++num, iname
		char* dataOfEntry;	//*after change
		dataOfEntry = base + *(short*)pos0 - delta_size;
		char* idxBeg;
		idxBeg = dataOfEntry + sizeof(char) * (t->Tname.length() + 1) + sizeof(int) + sizeof(int);	//*Tname
																									//*attr num
		for (int i = 0; i < t->attr.num; i++) {														//*attrs
			idxBeg += sizeof(char) * (t->attr.name[i].length() + 1) + sizeof(bool) + sizeof(short);
		}
		idxBeg += sizeof(short);  //*primary key
		*(int*)idxBeg += 1;		  //*idx num, new index will be add to the end
		char* idxEnd = dataOfEntry + *(short*)size;
		*(short*)idxEnd = loc;
		idxEnd += __SIZEOF_SHORT__;	 //*;)
		strcpy(idxEnd, iname.c_str());

		//*II change entry
		*(short*)size += delta_size;
		//*and the entries after that
		for (; entryIdx < entryN; entryIdx++, pointer += 2 * sizeof(short)) {
			*(short*)pointer -= delta_size;	 //*move forward
		}
		//*modify block or add a block
		freeP -= delta_size;
	} else {
		drop_table_NoApi(tname);
		create_table_NoApi(t->Tname, t->attr, t->primary, t->index, t->blockNum);
	}
}

void CataManager::drop_index(std::string tname, std::string iname) {
	
	Table *t = getTable(tname);
	drop_table_NoApi(tname);
	short i;

	for (i = 0; i < t->index.num; i++) {
		if (iname == t->index.indexname[i]) break;
	}
	if (i < t->index.num)
	{
		API api;
		api.DropIndex(*t, i);
	}
	if (i == t->index.num) {
		throw TableException("drop_index() table " + tname + "no such index name " + iname);
		return;
	}
	t->index.num--;
	for (; i < t->index.num; i++) {
		t->index.location[i] = t->index.location[i + 1];
		t->index.indexname[i] = t->index.indexname[i + 1];
	}
	
	create_table_NoApi(t->Tname, t->attr, t->primary, t->index, t->blockNum);
}

void CataManager::show_table(std::string tname) {
	Table* t = getTable(tname);
	cout << "table " + t->Tname + "(" << endl;
	cout << "\tattrbutes:" << endl;
	for (int i = 0; i < t->attr.num; i++) {
		cout << "\t\t" + t->attr.name[i];
		switch (t->attr.flag[i]) {
			case -1:
				cout << "\tint";
				break;
			case 0:
				cout << "\tfloat";
				break;
			default:
				cout << "\tchar[" << t->attr.flag[i] << "]";
		}
		if (t->attr.unique[i] == 1) cout << "\tunique";
		if (i == t->primary) cout << "\tprimary";
		cout << endl;
	}
	if (t->index.num > 0) {
		cout << "\tindices:" << endl;
		for (int i = 0; i < t->index.num; i++) {
			cout << "\t\t" + t->index.indexname[i] + " on " + t->attr.name[t->index.location[i]] + " (" << t->index.location[i] << ")" << endl;
		}
	}
	cout << ");" << endl;
}

void CataManager::changeblock(std::string tname, int bn) {
	char* base;
	short recIdx;
	char* pos0 = FindPtrPosition(tname, base, recIdx);
	char* pos = base + *(short*)(pos0);
	pos += sizeof(char) * (((string)pos).length() + 1);
	*(int*)pos = bn;
}
