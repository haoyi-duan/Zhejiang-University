#ifndef _INDEX_H_
#define _INDEX_H_
#include <iostream>
#include <fstream>
#include <string>
#include <cstdlib>
#include "BufferManager.h"

#define INFORMATION 24
#define POINTERLENGTH 20
#define CHAR2INT(array) *(int*)(array)
#define CHAR2FLOAT(array) *(float*)(array)

using namespace std;

enum nodetype { Internal, Leaf };
extern BufferManager bf;
class index {
public:
	int Number;
	int keylength[3];

private:
	int maxchild;
	int order;
	int type;//0 int; 1 double; 2 string
	string name;
public:
	index(string filename);
	~index() {};
	void initialize(Data* key, int Addr, int ktype);
	int find(Data* key);
	void insert(Data* key, int Addr);
	int* split(char* currentBlock, Data* mid, Data* key, int Addr, int leftpos, int rightpos);
	void Internal_insert(char* currentBlock, Data* mid, int leftpos, int rightpos);
	void SplitLeaf(char* block1, char* block2, char* currentBlock, Data* key, int Addr);
	void SplitInternal(char* block1, char* block2, char* currentBlock, Data* mid, int leftpos, int rightpos);
	void Delete(Data *key);
	void delete_entry(char *currentBlock, Data *key,int p);//0代表前指针，1代表后指针
	int* Range(Data* key1, Data* key2);
};

#endif