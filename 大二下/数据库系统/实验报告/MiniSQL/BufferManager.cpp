#include "BufferManager.h"

#include <stdio.h>

#include <fstream>
#include <iostream>

#include "Catalog.h"
using namespace std;

// todo flash back and get insert postion have some problem with extension

//*Method

//*caller i.e "RecoraManager" need add ".table" before call the funtion
int BufferManager::GiveMeABlock(string filename, int blockOffset)
{
	//*search the memory
	//*if we don't have, get it from disk
	int i = getbufferNum(filename, blockOffset);
	//*and the block is used.
	useBlock(i);
	return i;
}

//*linked list manipulate
//*assure length for each tuple is at least 4 byte
//*we sugget you load the data immediately after call this function
insertPos BufferManager::getInsertPosition(Table &tableinfor)
{
	//*The 1st edition, having fatal ERROR
	// LARGE_INTEGER t1, t2, tc;
	// QueryPerformanceFrequency(&tc);
	// QueryPerformanceCounter(&t1);
	// QueryPerformanceCounter(&t2);
	// cout << (t2.QuadPart - t1.QuadPart) * 1.0 / tc.QuadPart << " ";

	insertPos ret;
	if (tableinfor.blockNum == 0)
	{ //*give a new block, and return the head postion
		ret.bufferNum = addBlockInFile(tableinfor);
		ret.position = 0;
		writeBlock(ret.bufferNum);
		return ret;
	}
	else
	{
		//! ERROR: directly find the last block of the table, rahter search space from the first block
		int blockoffset = tableinfor.blockNum - 1;
		int bufferIdx = getbufferNum(tableinfor.getname() + ".table", blockoffset);
		int recordNum = BLOCKSIZE / (tableinfor.dataSize() + 1);
		int recordSize = tableinfor.dataSize() + 1;
		char *pos = bufferBlock[bufferIdx].values;
		int intPos = 0;

		for (int i = 0; i < recordNum; i++, pos += recordSize, intPos += recordSize)
		{
			char isValid;
			if ((isValid = *pos) == EMPTY)
			{
				ret.bufferNum = bufferIdx;
				ret.position = intPos;
				writeBlock(ret.bufferNum);
				return ret;
			}
		}

		ret.bufferNum = addBlockInFile(tableinfor);
		ret.position = 0;
		writeBlock(ret.bufferNum);
		return ret;
		//*no space, new a block
	}

	//*The 2nd edition, uncomplished
	//*and adjust table
	// int i, j;
	// int bufferidx;
	// insertPos Pos;
	// //*find file and block
	// for (j = 0; j < tableinfor.blockNum; j++) {
	// 	bufferidx = getbufferNum(tableinfor.getname() + ".table", j);

	// 	//*with tuple space
	// 	//*Addr of linked list, position
	// 	short* next = (short*)((bufferBlock[bufferidx].values) + 1);  //*the addr in Byte point to next position(after valid byte)
	// 	if (*next == -1)
	// 		continue;
	// 	else {
	// 		//*find tuple postion
	// 		Pos.bufferNum = bufferidx;
	// 		Pos.position = (*next) * (tableinfor.dataSize() + 1);
	// 		*next = *(short*)(bufferBlock[bufferidx].values + *next);
	// 		return Pos;
	// 	}
	// }
	// //*new a block for table;
	// //*initialize for table
	// bufferidx = getEmptyBuffer();  // todo we don't use 2
	// char* next = ((bufferBlock[bufferidx].values) + 1);
	// short* nextAddr;
	// for (i = 0; ((i + 1) * (tableinfor.dataSize() + 1)) < BlockSize; next += (tableinfor.dataSize() + 1), i++) {
	// 	nextAddr = (short*)next;
	// 	*nextAddr = (i + 1) * (tableinfor.dataSize() + 1) + 1;
	// }
	// nextAddr = (short*)next;
	// *nextAddr = -1;
	// tableinfor.blockNum++;
	// bufferBlock[bufferidx].isInitializedForTable = 1;  //*end initialization
	// //*find tuple postion
	// next = ((bufferBlock[bufferidx].values) + 1);
	// Pos.bufferNum = bufferidx;
	// Pos.position = (*next) * (tableinfor.dataSize() + 1);
	// *next = *(short*)(bufferBlock[bufferidx].values + *next);
	// return Pos;
	// //! set Valid? default ?#
}

void BufferManager::writeBlock(int bufferNum)
{
	bufferBlock[bufferNum].isDirty = 1;
	useBlock(bufferNum);
}

void BufferManager::useBlock(int bufferNum)
{
	//*to perform LRU algo
	//*add the used index to the front of the linked list
	//*may use mutiple, find and place in the front of the linklist
	LinkList tmp;
	for (tmp = tail->prev; tmp != head; tmp = tmp->prev)
		if (tmp->index == bufferNum)
		{
			//*delete
			tmp->prev->next = tmp->next;
			tmp->next->prev = tmp->prev;
			//*reInsert
			tmp->prev = head;
			tmp->next = head->next;
			head->next->prev = tmp;
			head->next = tmp;
			break; //*fxxk!
		}
	if (tmp == head)
		InsertLinkedList(bufferNum);
}

//*Unmentioned
int BufferManager::getbufferNum(string filename, int blockOffset)
{
	int bufferidx = getIfIsInBuffer(filename, blockOffset);
	if (bufferidx == -1)
	{
		bufferidx = getEmptyBufferExcept(filename);
		readBlock(filename, blockOffset, bufferidx);
	}
	return bufferidx;
}
//*should be in private
int BufferManager::getIfIsInBuffer(string filename, int blockOffset)
{
	int i;
	for (i = MAXBLOCKNUM - 1; i >= 0; i--)
		if (bufferBlock[i].isValid && bufferBlock[i].blockOffset == blockOffset && bufferBlock[i].filename == filename)
			break;
	return i;
}

void BufferManager::InsertLinkedList(int i)
{
	LinkList l = new s_LinkedList; //*LRU insert after dummy head
	l->index = i;
	l->prev = head;
	l->next = head->next;
	head->next->prev = l;
	head->next = l;
}

int BufferManager::getEmptyBuffer()
{
	for (int i = 0; i < MAXBLOCKNUM; i++)
	{
		if (!bufferBlock[i].isValid)
		{
			InsertLinkedList(i); //*LRU insert after dummy head
			return i;
		}
	}
	//*fail
	LinkList tmp;
	for (tmp = tail->prev; bufferBlock[tmp->index].islocked; tmp = tmp->prev)
		;

	int index = tmp->index;
	tmp->next->prev = tmp->prev;
	tmp->prev->next = tmp->next;
	free(tmp);
	if (bufferBlock[index].isDirty)
	{
		flashBack(index);
	}
	bufferBlock[index].initialize();
	return index;
}

void BufferManager::readBlock(string filename, int blockOffset, int bufferNum)
{
	bufferBlock[bufferNum].filename = filename;
	bufferBlock[bufferNum].blockOffset = blockOffset;
	bufferBlock[bufferNum].isValid = 1;
	bufferBlock[bufferNum].isDirty = 0;
	bufferBlock[bufferNum].isInitializedForTable = 1;
	bufferBlock[bufferNum].islocked = 0;

	ifstream ifs;
	ifs.open(filename, ios::binary);
	while (!ifs.is_open())
	{
		ofstream ofs(filename, ios::app);
		if (!ofs.is_open())
			cout << "can't create file" << endl;
		ofs.close();
		ifs.open(filename, ios::binary);
	}
	ifs.seekg(blockOffset * BlockSize);
	ifs.read(bufferBlock[bufferNum].values, BlockSize);
}

//*private
// void BufferManager::flashBack(int bufferNum) {
// 	if (!bufferBlock[bufferNum].isDirty) return;
// 	ofstream ofs;
// 	ofs.open(bufferBlock[bufferNum].filename, ios::binary);
// 	if (!ofs.is_open()) {
// 		cout << "flashback invalid file name" << endl;
// 		system("pause");
// 	}
// 	ofs.seekp(BlockSize * bufferBlock[bufferNum].blockOffset);
// 	ofs.write(bufferBlock[bufferNum].values, BlockSize);

// }
void BufferManager::flashBack(int bufferNum)
{
	if (!bufferBlock[bufferNum].isDirty)
		return;
	string filename = bufferBlock[bufferNum].filename;
	// fstream fout;
	FILE *fp;
	if ((fp = fopen(filename.c_str(), "r+b")) == NULL)
	{
		cout << "Open file error!" << endl;
		// #Todo
		return;
	}
	fseek(fp, BLOCKSIZE * bufferBlock[bufferNum].blockOffset, SEEK_SET);
	fwrite(bufferBlock[bufferNum].values, BLOCKSIZE, 1, fp);
	bufferBlock[bufferNum].initialize();
	fclose(fp);
}
//*NO syncornize with disk
void BufferManager::scanIn(Table tableinfo)
{
	//*load all the data of the table in to the memory, but if memory already have a updated one, we don't load it from the disk.
	for (int i = 0; i < tableinfo.blockNum; i++)
	{
		if (getIfIsInBuffer(tableinfo.getname(), i) != -1)
			;
		else
		{
			int index = getEmptyBufferExcept(tableinfo.getname());
			readBlock(tableinfo.getname(), i, index);
		}
	}
}

//*Y U use it?!
void BufferManager::setInvalid(string filename)
{
	// cout << "setInvalid called" << endl;
	// system("pause");
	for (int i = 0; i < MAXBLOCKNUM; i++)
	{
		bufferBlock[i].isValid = 0;
		bufferBlock[i].isDirty = 0;
	}
}

int BufferManager::getEmptyBufferExcept(string filename)
{
	for (int i = 0; i < MAXBLOCKNUM; i++)
	{
		if (!bufferBlock[i].isValid)
		{
			return i;
		}
	}
	//*fail
	LinkList tmp;
	for (tmp = tail->prev; tmp != head && (bufferBlock[tmp->index].filename == filename || bufferBlock[tmp->index].islocked); tmp = tmp->prev)
		;
	if (tmp == head)
		tmp = tail->prev;

	int index = tmp->index;
	tmp->next->prev = tmp->prev;
	tmp->prev->next = tmp->next;
	free(tmp);
	if (bufferBlock[index].isDirty)
		flashBack(index);
	bufferBlock[index].initialize();
	return index;
}

int BufferManager::addBlockInFile(Table &tableinfor)
{
	int bufferIdx = getEmptyBuffer(); //*LRU Algo performed
	bufferBlock[bufferIdx].initialize();
	bufferBlock[bufferIdx].blockOffset = tableinfor.blockNum++;
	bufferBlock[bufferIdx].filename = tableinfor.getname() + ".table";
	bufferBlock[bufferIdx].isValid = 1;
	bufferBlock[bufferIdx].isDirty = 1;
	CataManager cata;
	string debug_param = tableinfor.getname();
	cata.changeblock(debug_param, tableinfor.blockNum);
	return bufferIdx;
}

int BufferManager::addBlockInFile(Index &indexinfor)
{
	cout << "addBlockInFile Index called" << endl;
	system("pause");
	return 0;
}
