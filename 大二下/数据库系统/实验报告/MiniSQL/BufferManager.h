#pragma once
#include <string.h>

#include <iostream>
#include <string>

#include "base.h"
#include "const.h"

#define BlockSize BLOCKSIZE
#define BlockMaxNum MAXBLOCKNUM

using namespace std;
//#define EMPTY '#'

// class insertPos {  //*for tuples
//    public:
// 	int bufferNUM;	//*of block
// 	int position;	//*in the block, unit: Byte
// };
//*Struct for LRU
typedef struct s_LinkedList* LinkList;
struct s_LinkedList {
	int index;
	LinkList prev;
	LinkList next;
};

class buffer {
   private:
	string filename;  //*A block have just one file_name

	bool islocked;
	bool isDirty;
	// bool isUsed;
	int isValid;
	bool isInitializedForTable;
	//*we use a linked list to link all the position remain empty in the values
	//*will be stored in the dummy header's valid byte.
	//*tuple will also have a valid byte,
	//*0 no data but in linked list,1 has data, 2 initialized for table
	// bool isRecentlyUsed;  //*LRU clock algorithm

	friend class BufferManager;

   public:			  // private
	int blockOffset;  //*in disk, not index in memory, Used By record Manager
   public:
	char values[BlockSize + 1];	 //*That should be mixed type of data

	buffer() { initialize(); }
	void initialize() {
		filename = "NULL";
		blockOffset = 0;
		islocked = 0;
		isDirty = 0;
		// isUsed = 0;
		isValid = 0;
		// isRecentlyUsed = 0;
		isInitializedForTable = 0;
		memset(values, EMPTY, BLOCKSIZE);
		values[BLOCKSIZE] = 0;
	}
	string getvalues(int start, int end) {	//*May have performance issue
		string str = "";
		if (start >= 0 && start <= end && end <= BLOCKSIZE)
			for (int i = start; i < end; i++) str += values[i];
		return str;
		// if (start < 0 || end > (BlockSize + 1) || start >= end) cout << "Error string getvalues" << endl;
		// string str(values), substr("");
		// substr.append(str.substr(start, end - start));
		// return substr;
	}
	char getvalues(int pos) {
		if (pos >= 0 && pos < (BlockSize + 1)) return values[pos];
		return '\0';
	}
};

// Method used in RecordManager
// getvalues
// getifisinbuffer
// getemptybuffer
// readblock
// writeblock
class BufferManager {
   public:
	buffer bufferBlock[MAXBLOCKNUM];
	BufferManager() {
		//*initialize linkedlist
		head = new s_LinkedList;
		tail = new s_LinkedList;
		head->next = tail;
		head->prev = NULL;
		tail->prev = head;
		tail->next = NULL;
	};
	~BufferManager() {
		//*delete linked list
		LinkList prev = head;
		for (LinkList ptr = head->next; ptr; prev = ptr, ptr = ptr->next) free(prev);
		free(prev);
		for (int i = 0; i < BlockMaxNum; i++) flashBack(i);
	};
	//*Method
	int GiveMeABlock(string filename, int blockOffset);
	class insertPos getInsertPosition(Table& tableinfor);
	void writeBlock(int bufferNum);
	void useBlock(int bufferNum);
	//*Unmentioned
	int getbufferNum(string filename, int blockOffset);
	//*SHOULD be in private:
	int getIfIsInBuffer(string filename, int blockOffset);
	int getEmptyBuffer();
	void readBlock(string filename, int blockOffset, int bufferNum);

   public:
	void setInvalid(string filename);  //*Used by Record Manager

   private:
	void InsertLinkedList(int i);
	void flashBack(int bufferNum);
	int getEmptyBufferExcept(string filename);
	void scanIn(Table tableinfo);

	int addBlockInFile(Table& tableinfor);
	int addBlockInFile(Index& indexinfor);
	LinkList head, tail;
	//*No friend class, talk to me if U need interface
	friend class index;
};
