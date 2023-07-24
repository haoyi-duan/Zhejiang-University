
#include "bptree.h"

index::index(string filename) : name(filename) {
	keylength[0] = sizeof(int);
	keylength[1] = sizeof(int);
	keylength[2] = 5 * sizeof(int);
	fstream _file;
	_file.open(filename, ios::in);

	if (!_file) {
		_file.open(filename, ios::out);
		Number = 0;
	} else {
		_file.seekp(0, ios::end);
		Number = (int)(_file.tellg() / BLOCKSIZE);
		_file.close();

		if (Number == 0) {
			return;
		}
		char* currentBlock = new char[BLOCKSIZE];
		int buffernum = bf.GiveMeABlock(name, 0);
		bf.useBlock(buffernum);
		::memcpy(currentBlock, bf.bufferBlock[buffernum].values, BLOCKSIZE);
		type = CHAR2INT(currentBlock + 5 * sizeof(int));
		maxchild = (BLOCKSIZE - INFORMATION) / (keylength[type] + POINTERLENGTH) - 1;
		order = maxchild;
	}
}

void index::initialize(Data* key, int Addr, int ktype) {
	char* root = new char[BLOCKSIZE];
	CHAR2INT(root) = Internal;
	CHAR2INT(root + sizeof(int)) = 0;		   // node position
	CHAR2INT(root + 2 * sizeof(int)) = -1;	   // father node position
	CHAR2INT(root + 3 * sizeof(int)) = 1;	   // number of keys
	CHAR2INT(root + 4 * sizeof(int)) = 0;	   // delete or not
	CHAR2INT(root + 5 * sizeof(int)) = ktype;  // type
	int NumOfKeys = CHAR2INT(root + 3 * sizeof(int));
	type = ktype;
	int KL = keylength[type];
	CHAR2INT(root + INFORMATION + KL) = NumOfKeys;	// first member position
	if (key->flag == -1)
		CHAR2INT(root + INFORMATION + NumOfKeys * (KL + POINTERLENGTH)) = ((Datai*)key)->x;
	else if (key->flag == 0)
		CHAR2FLOAT(root + INFORMATION + NumOfKeys * (KL + POINTERLENGTH)) = ((Dataf*)key)->x;
	else {
		::memcpy((char*)(root + INFORMATION + NumOfKeys * (KL + POINTERLENGTH)), ((Datac*)key)->x.c_str(), ((Datac*)key)->x.length() + 1);
	}

	CHAR2INT(root + INFORMATION + NumOfKeys * (KL + POINTERLENGTH) + KL) = -1;
	CHAR2INT(root + INFORMATION + NumOfKeys * (KL + POINTERLENGTH) + KL + sizeof(int)) = -1;
	CHAR2INT(root + INFORMATION + NumOfKeys * (KL + POINTERLENGTH) + KL + 2 * sizeof(int)) = NumOfKeys;
	CHAR2INT(root + INFORMATION + NumOfKeys * (KL + POINTERLENGTH) + KL + 3 * sizeof(int)) = 1;
	CHAR2INT(root + INFORMATION + NumOfKeys * (KL + POINTERLENGTH) + KL + 4 * sizeof(int)) = 0;	 // delete or not
	int buffernum = bf.GiveMeABlock(name, 0);
	::memcpy(bf.bufferBlock[buffernum].values, root, BLOCKSIZE);
	bf.writeBlock(buffernum);
	bf.flashBack(buffernum);
	// writebuffer

	char* newBlock = new char[BLOCKSIZE];
	CHAR2INT(newBlock) = Leaf;
	CHAR2INT(newBlock + sizeof(int)) = 1;	   // node position
	CHAR2INT(newBlock + 2 * sizeof(int)) = 0;  // father node position
	CHAR2INT(newBlock + 3 * sizeof(int)) = 1;  // number of keys
	CHAR2INT(newBlock + 4 * sizeof(int)) = 0;  // delete or not

	NumOfKeys = CHAR2INT(newBlock + 3 * sizeof(int));
	CHAR2INT(newBlock + INFORMATION + KL) = NumOfKeys;
	if (key->flag == -1)
		CHAR2INT(newBlock + INFORMATION + NumOfKeys * (KL + POINTERLENGTH)) = ((Datai*)key)->x;
	else if (key->flag == 0)
		CHAR2FLOAT(newBlock + INFORMATION + NumOfKeys * (KL + POINTERLENGTH)) = ((Dataf*)key)->x;
	else {
		::memcpy((char*)(newBlock + INFORMATION + NumOfKeys * (KL + POINTERLENGTH)), ((Datac*)key)->x.c_str(), ((Datac*)key)->x.length() + 1);
	}

	CHAR2INT(newBlock + INFORMATION + NumOfKeys * (KL + POINTERLENGTH) + KL) = -1;
	CHAR2INT(newBlock + INFORMATION + NumOfKeys * (KL + POINTERLENGTH) + KL + sizeof(int)) = Addr;
	CHAR2INT(newBlock + INFORMATION + NumOfKeys * (KL + POINTERLENGTH) + KL + 2 * sizeof(int)) = NumOfKeys;
	CHAR2INT(newBlock + INFORMATION + NumOfKeys * (KL + POINTERLENGTH) + KL + 4 * sizeof(int)) = 0;	 // delete or not
	buffernum = bf.GiveMeABlock(name, 1);
	::memcpy(bf.bufferBlock[buffernum].values, newBlock, BLOCKSIZE);
	bf.writeBlock(buffernum);
	bf.flashBack(buffernum);

	maxchild = (BLOCKSIZE - INFORMATION) / (KL + POINTERLENGTH) - 1;
	order = maxchild;
	Number = 2;
	type = ktype;
	delete[] newBlock;
	delete[] root;
}

int index::find(Data* key) {
	char* currentBlock = new char[BLOCKSIZE];

	int buffernum = bf.GiveMeABlock(name, 0);
	bf.useBlock(buffernum);
	::memcpy(currentBlock, bf.bufferBlock[buffernum].values, BLOCKSIZE);
	// readbuffer;
	int LeafType = CHAR2INT(currentBlock);
	int KL = keylength[type];
	int bro = CHAR2INT(currentBlock + INFORMATION + KL);
	int tempbro, position;

	while (LeafType == Internal) {
		int NumOfKeys = CHAR2INT(currentBlock + 3 * sizeof(int));
		int i = 0;

		for (i = 0; i < NumOfKeys; i++) {
			if (type == 0) {
				int NowKey = CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH));
				tempbro = bro;
				position = CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL + sizeof(int));
				bro = CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL);
				if ((((Datai*)key)->x < NowKey)) break;
			} else if (type == 1) {
				float NowKey = CHAR2FLOAT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH));
				tempbro = bro;
				position = CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL + sizeof(int));
				bro = CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL);
				if ((((Dataf*)key)->x < NowKey)) break;
			} else {
				string NowKey((char*)(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH)));
				tempbro = bro;
				position = CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL + sizeof(int));
				bro = CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL);
				if ((((Datac*)key)->x.compare(NowKey)) < 0) break;
			}
		}
		if (i == NumOfKeys) position = CHAR2INT(currentBlock + INFORMATION + tempbro * (KL + POINTERLENGTH) + KL + 3 * sizeof(int));
		if (position == -1) {
			return -1;
		}
		int buffernum = bf.GiveMeABlock(name, position);
		bf.useBlock(buffernum);
		::memcpy(currentBlock, bf.bufferBlock[buffernum].values, BLOCKSIZE);
		LeafType = CHAR2INT(currentBlock);
		bro = CHAR2INT(currentBlock + INFORMATION + KL);
		// readbuffer
	}

	int NumOfKeys = CHAR2INT(currentBlock + 3 * sizeof(int));
	bro = CHAR2INT(currentBlock + INFORMATION + KL);
	for (int i = 0; i < NumOfKeys; i++) {
		if (type == 0) {
			int NowKey = CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH));
			tempbro = bro;
			int Addr = CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL + sizeof(int));
			position = CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL + sizeof(int));
			bro = CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL);
			if ((((Datai*)key)->x == NowKey) && CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL + 4 * sizeof(int)) != 1) {
				delete[] currentBlock;
				return Addr;
			}
		} else if (type == 1) {
			float NowKey = CHAR2FLOAT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH));
			tempbro = bro;
			int Addr = CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL + sizeof(int));
			position = CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL + sizeof(int));
			bro = CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL);
			if ((((Dataf*)key)->x == NowKey) && CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL + 4 * sizeof(int)) != 1) {
				delete[] currentBlock;
				return Addr;
			}
		} else {
			string NowKey((char*)(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH)));
			tempbro = bro;
			int Addr = CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL + sizeof(int));
			position = CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL + sizeof(int));
			bro = CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL);
			if ((((Datac*)key)->x.compare(NowKey)) == 0 && CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL + 4 * sizeof(int)) != 1) {
				delete[] currentBlock;
				return Addr;
			}
		}
	}
	return -1;
	delete[] currentBlock;
}

void index::insert(Data* key, int Addr) {
	char* currentBlock = new char[BLOCKSIZE];

	if (find(key) != -1) {
		throw TableException("The key is duplicate!");
		return;
	}
	int buffernum = bf.GiveMeABlock(name, 0);
	bf.useBlock(buffernum);
	::memcpy(currentBlock, bf.bufferBlock[buffernum].values, BLOCKSIZE);
	// readbuffer;
	int LeafType = CHAR2INT(currentBlock);
	int KL = keylength[type];
	int bro = CHAR2INT(currentBlock + INFORMATION + KL);
	int tempbro, position;

	while (LeafType == Internal) {
		int NumOfKeys = CHAR2INT(currentBlock + 3 * sizeof(int));
		int i = 0;

		for (i = 0; i < NumOfKeys; i++) {
			if (type == 0) {
				int NowKey = CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH));
				tempbro = bro;
				position = CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL + sizeof(int));
				bro = CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL);
				if ((((Datai*)key)->x < NowKey)) break;
			} else if (type == 1) {
				float NowKey = CHAR2FLOAT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH));
				tempbro = bro;
				position = CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL + sizeof(int));
				bro = CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL);
				if ((((Dataf*)key)->x < NowKey)) break;
			} else {
				string NowKey((char*)(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH)));
				tempbro = bro;
				position = CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL + sizeof(int));
				bro = CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL);
				if ((((Datac*)key)->x.compare(NowKey)) < 0) break;
			}
		}
		if (i == NumOfKeys) position = CHAR2INT(currentBlock + INFORMATION + tempbro * (KL + POINTERLENGTH) + KL + 3 * sizeof(int));
		if (position == -1) {
			char* newBlock = new char[BLOCKSIZE];
			CHAR2INT(newBlock) = Leaf;
			CHAR2INT(newBlock + sizeof(int)) = Number++;
			CHAR2INT(newBlock + 2 * sizeof(int)) = CHAR2INT(currentBlock + sizeof(int));
			CHAR2INT(newBlock + 3 * sizeof(int)) = 1;
			CHAR2INT(newBlock + 4 * sizeof(int)) = 0;

			CHAR2INT(newBlock + INFORMATION + KL) = CHAR2INT(newBlock + 3 * sizeof(int));
			if (key->flag == -1)
				CHAR2INT(newBlock + INFORMATION + (KL + POINTERLENGTH)) = ((Datai*)key)->x;
			else if (key->flag == 0)
				CHAR2FLOAT(newBlock + INFORMATION + (KL + POINTERLENGTH)) = ((Dataf*)key)->x;
			else {
				::memcpy((char*)(newBlock + INFORMATION + (KL + POINTERLENGTH)), ((Datac*)key)->x.c_str(), ((Datac*)key)->x.length() + 1);
			}
			CHAR2INT(newBlock + INFORMATION + KL + POINTERLENGTH + KL) = -1;
			CHAR2INT(newBlock + INFORMATION + KL + POINTERLENGTH + KL + sizeof(int)) = Addr;
			CHAR2INT(newBlock + INFORMATION + KL + POINTERLENGTH + KL + 2 * sizeof(int)) = 1;
			CHAR2INT(newBlock + INFORMATION + (KL + POINTERLENGTH) + KL + 4 * sizeof(int)) = 0;	 // delete or not
			position = Number - 1;
			int buffernum = bf.GiveMeABlock(name, position);
			::memcpy(bf.bufferBlock[buffernum].values, newBlock, BLOCKSIZE);
			bf.writeBlock(buffernum);
			bf.flashBack(buffernum);

			CHAR2INT(currentBlock + INFORMATION + tempbro * (KL + POINTERLENGTH) + KL + sizeof(int)) = Number - 1;
			buffernum = bf.GiveMeABlock(name, CHAR2INT(currentBlock + sizeof(int)));
			::memcpy(bf.bufferBlock[buffernum].values, currentBlock, BLOCKSIZE);
			bf.writeBlock(buffernum);
			bf.flashBack(buffernum);
			// writebuffer
			return;
		}
		int buffernum = bf.GiveMeABlock(name, position);
		bf.useBlock(buffernum);
		::memcpy(currentBlock, bf.bufferBlock[buffernum].values, BLOCKSIZE);
		LeafType = CHAR2INT(currentBlock);
		bro = CHAR2INT(currentBlock + INFORMATION + KL);
		// readbuffer;
	}

	int NumOfKeys = CHAR2INT(currentBlock + 3 * sizeof(int));
	bro = CHAR2INT(currentBlock + INFORMATION + KL);
	if (NumOfKeys < maxchild)  //直接插入
	{
		CHAR2INT(currentBlock + 3 * sizeof(int)) += 1;
		NumOfKeys++;
		int LastBro = 0;
		int i = 0;

		for (i = 0; i < NumOfKeys; i++)	 //找到最后一个key
		{
			if (type == 0) {
				if (bro == -1 && i == NumOfKeys - 1) break;
				int NowKey = CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH));
				if ((((Datai*)key)->x < NowKey)) break;
				else if ((((Datai*)key)->x == NowKey) && CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL + 4 * sizeof(int)) == 1)
				{
					CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL + 4 * sizeof(int)) = 0;
					int buffernum = bf.GiveMeABlock(name, CHAR2INT(currentBlock + sizeof(int)));
					::memcpy(bf.bufferBlock[buffernum].values, currentBlock, BLOCKSIZE);
					return;
				}
				
			} else if (type == 1) {
				if (bro == -1 && i == NumOfKeys - 1) break;
				float NowKey = CHAR2FLOAT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH));
				if ((((Dataf*)key)->x < NowKey)) break;
				else if ((((Dataf*)key)->x == NowKey) && CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL + 4 * sizeof(int)) == 1) {
				CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL + 4 * sizeof(int)) = 0;
				int buffernum = bf.GiveMeABlock(name, CHAR2INT(currentBlock + sizeof(int)));
				::memcpy(bf.bufferBlock[buffernum].values, currentBlock, BLOCKSIZE);
				return;
			} 
			} else {
				if (bro == -1 && i == NumOfKeys - 1) break;
				string NowKey((char*)(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH)));
				if ((((Datac*)key)->x.compare(NowKey)) < 0) break;
				else if ((((Datac*)key)->x.compare(NowKey)) == 0 && CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL + 4 * sizeof(int)) == 1) {
				//delete_entry(currentBlock, key, 0);
				CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL + 4 * sizeof(int)) = 0;
				int buffernum = bf.GiveMeABlock(name, CHAR2INT(currentBlock + sizeof(int)));
				::memcpy(bf.bufferBlock[buffernum].values, currentBlock, BLOCKSIZE);
				return;
			}
			}
			LastBro = bro;
			bro = CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL);
		}

		if (key->flag == -1)
			CHAR2INT(currentBlock + INFORMATION + NumOfKeys * (KL + POINTERLENGTH)) = ((Datai*)key)->x;
		else if (key->flag == 0)
			CHAR2FLOAT(currentBlock + INFORMATION + NumOfKeys * (KL + POINTERLENGTH)) = ((Dataf*)key)->x;
		else {
			::memcpy((char*)(currentBlock + INFORMATION + NumOfKeys * (KL + POINTERLENGTH)), ((Datac*)key)->x.c_str(), ((Datac*)key)->x.length() + 1);
		}

		CHAR2INT(currentBlock + INFORMATION + NumOfKeys * (KL + POINTERLENGTH) + KL) = CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL + 2 * sizeof(int));
		CHAR2INT(currentBlock + INFORMATION + NumOfKeys * (KL + POINTERLENGTH) + KL + sizeof(int)) = Addr;
		CHAR2INT(currentBlock + INFORMATION + NumOfKeys * (KL + POINTERLENGTH) + KL + 2 * sizeof(int)) = NumOfKeys;
		CHAR2INT(currentBlock + INFORMATION + LastBro * (KL + POINTERLENGTH) + KL) = NumOfKeys;

		if (i == NumOfKeys - 1) CHAR2INT(currentBlock + INFORMATION + NumOfKeys * (KL + POINTERLENGTH) + KL) = -1;

		int buffernum = bf.GiveMeABlock(name, CHAR2INT(currentBlock + sizeof(int)));
		::memcpy(bf.bufferBlock[buffernum].values, currentBlock, BLOCKSIZE);
		bf.writeBlock(buffernum);
		bf.flashBack(buffernum);
		// writebuffer
	} else	//分裂
	{
		CHAR2INT(currentBlock + 3 * sizeof(int)) += 1;
		Data* mid = NULL;
		split(currentBlock, mid, key, Addr, 0, 0);
		bf.GiveMeABlock(name, 2 * sizeof(int));
	}

	delete[] currentBlock;
}

int* index::split(char* currentBlock, Data* mid, Data* key, int Addr, int leftpos, int rightpos) {
	int NumOfKeys = CHAR2INT(currentBlock + 3 * sizeof(int));
	int LeafType = CHAR2INT(currentBlock);
	int* father = new int[2];
	father[0] = 0;
	father[1] = 0;
	int KL = keylength[type];
	if ((CHAR2INT(currentBlock + 2 * sizeof(int)) == -1) && NumOfKeys >= maxchild - 1)	//分裂根节点
	{
		char* newBlock1 = new char[BLOCKSIZE];
		char* newBlock2 = new char[BLOCKSIZE];
		SplitInternal(newBlock1, newBlock2, currentBlock, mid, leftpos, rightpos);	// mid need change
		leftpos = CHAR2INT(newBlock1 + sizeof(int));
		rightpos = CHAR2INT(newBlock2 + sizeof(int));

		CHAR2INT(newBlock1 + 2 * sizeof(int)) = 0;
		CHAR2INT(newBlock2 + 2 * sizeof(int)) = 0;

		if (type == 0) {
			mid = new Datai(CHAR2INT(newBlock2 + INFORMATION + KL + POINTERLENGTH));
		} else if (type == 1) {
			mid = new Dataf(CHAR2FLOAT(newBlock2 + INFORMATION + KL + POINTERLENGTH));
		} else {
			mid = new Datac((char*)(newBlock2 + INFORMATION + KL + POINTERLENGTH));
		}

		int buffernum = bf.GiveMeABlock(name, CHAR2INT(newBlock1 + sizeof(int)));
		::memcpy(bf.bufferBlock[buffernum].values, newBlock1, BLOCKSIZE);
		bf.writeBlock(buffernum);
		bf.flashBack(buffernum);
		// writebuffer
		buffernum = bf.GiveMeABlock(name, CHAR2INT(newBlock2 + sizeof(int)));
		::memcpy(bf.bufferBlock[buffernum].values, newBlock2, BLOCKSIZE);
		bf.writeBlock(buffernum);
		bf.flashBack(buffernum);
		// writebuffer
		char* root = new char[BLOCKSIZE];
		CHAR2INT(root) = Internal;
		CHAR2INT(root + sizeof(int)) = 0;		  // node position
		CHAR2INT(root + 2 * sizeof(int)) = -1;	  // father node position
		CHAR2INT(root + 3 * sizeof(int)) = 1;	  // number of keys
		CHAR2INT(root + 4 * sizeof(int)) = 0;	  // delete or not
		CHAR2INT(root + 5 * sizeof(int)) = type;  // type

		int NumOfKeys = CHAR2INT(root + 3 * sizeof(int));
		CHAR2INT(root + INFORMATION + KL) = NumOfKeys;
		if (key->flag == -1)
			CHAR2INT(root + INFORMATION + NumOfKeys * (KL + POINTERLENGTH)) = ((Datai*)mid)->x;
		else if (key->flag == 0)
			CHAR2FLOAT(root + INFORMATION + NumOfKeys * (KL + POINTERLENGTH)) = ((Dataf*)mid)->x;
		else {
			::memcpy((char*)(root + INFORMATION + NumOfKeys * (KL + POINTERLENGTH)), ((Datac*)mid)->x.c_str(), ((Datac*)mid)->x.length() + 1);
		}
		CHAR2INT(root + INFORMATION + NumOfKeys * (KL + POINTERLENGTH) + KL) = -1;
		CHAR2INT(root + INFORMATION + NumOfKeys * (KL + POINTERLENGTH) + KL + sizeof(int)) = leftpos;
		CHAR2INT(root + INFORMATION + NumOfKeys * (KL + POINTERLENGTH) + KL + 2 * sizeof(int)) = NumOfKeys;
		CHAR2INT(root + INFORMATION + NumOfKeys * (KL + POINTERLENGTH) + KL + 3 * sizeof(int)) = rightpos;
		CHAR2INT(root + INFORMATION + NumOfKeys * (KL + POINTERLENGTH) + KL + 4 * sizeof(int)) = 0;	 // delete or not

		buffernum = bf.GiveMeABlock(name, CHAR2INT(root + sizeof(int)));
		::memcpy(bf.bufferBlock[buffernum].values, root, BLOCKSIZE);
		bf.writeBlock(buffernum);
		bf.flashBack(buffernum);
		// writebuffer;root

		father[0] = CHAR2INT(newBlock1 + sizeof(int));
		father[1] = CHAR2INT(newBlock2 + sizeof(int));

		delete[] root;
		delete[] newBlock1;
		delete[] newBlock2;
		return father;
	} else	//分裂非根节点
	{
		if (LeafType == Leaf && NumOfKeys >= maxchild)	//分裂叶节点
		{
			char* newBlock1 = new char[BLOCKSIZE];
			char* newBlock2 = new char[BLOCKSIZE];
			int* temp = NULL;
			SplitLeaf(newBlock1, newBlock2, currentBlock, key, Addr);
			CHAR2INT(currentBlock + 4 * sizeof(int)) = 1;
			leftpos = CHAR2INT(newBlock1 + sizeof(int));
			rightpos = CHAR2INT(newBlock2 + sizeof(int));

			if (type == 0) {
				mid = new Datai(CHAR2INT(newBlock2 + INFORMATION + KL + POINTERLENGTH));
			} else if (type == 1) {
				mid = new Dataf(CHAR2FLOAT(newBlock2 + INFORMATION + KL + POINTERLENGTH));
			} else {
				mid = new Datac((char*)(newBlock2 + INFORMATION + KL + POINTERLENGTH));
			}

			int buffernum = bf.GiveMeABlock(name, CHAR2INT(currentBlock + 2 * sizeof(int)));
			bf.useBlock(buffernum);
			char* fatherBlock = new char[BLOCKSIZE];
			::memcpy(fatherBlock, bf.bufferBlock[buffernum].values, BLOCKSIZE);
			// readbuffer;

			temp = split(fatherBlock, mid, key, Addr, leftpos, rightpos);

			CHAR2INT(newBlock1 + 2 * sizeof(int)) = temp[0];
			CHAR2INT(newBlock2 + 2 * sizeof(int)) = temp[1];

			buffernum = bf.GiveMeABlock(name, CHAR2INT(currentBlock + sizeof(int)));
			::memcpy(bf.bufferBlock[buffernum].values, currentBlock, BLOCKSIZE);
			bf.writeBlock(buffernum);
			bf.flashBack(buffernum);
			// writebuffer

			buffernum = bf.GiveMeABlock(name, CHAR2INT(newBlock1 + sizeof(int)));
			::memcpy(bf.bufferBlock[buffernum].values, newBlock1, BLOCKSIZE);
			bf.writeBlock(buffernum);
			bf.flashBack(buffernum);
			// writebuffer
			buffernum = bf.GiveMeABlock(name, CHAR2INT(newBlock2 + sizeof(int)));
			::memcpy(bf.bufferBlock[buffernum].values, newBlock2, BLOCKSIZE);
			bf.writeBlock(buffernum);
			bf.flashBack(buffernum);
			// writebuffer

			father[0] = CHAR2INT(newBlock1 + sizeof(int));
			father[1] = CHAR2INT(newBlock2 + sizeof(int));

			delete[] newBlock1;
			delete[] newBlock2;
			delete[] fatherBlock;
			return father;
		} else if (LeafType == Internal && NumOfKeys >= maxchild - 1)  //分裂非根内部节点
		{
			char* newBlock1 = new char[BLOCKSIZE];
			char* newBlock2 = new char[BLOCKSIZE];
			SplitInternal(newBlock1, newBlock2, currentBlock, mid, leftpos, rightpos);	// mid need be change
			leftpos = CHAR2INT(newBlock1 + sizeof(int));
			rightpos = CHAR2INT(newBlock2 + sizeof(int));
			CHAR2INT(currentBlock + 4 * sizeof(int)) = 1;
			int* temp = NULL;

			if (type == 0) {
				mid = new Datai(CHAR2INT(newBlock2 + INFORMATION + KL + POINTERLENGTH));
			} else if (type == 1) {
				mid = new Dataf(CHAR2FLOAT(newBlock2 + INFORMATION + KL + POINTERLENGTH));
			} else {
				mid = new Datac((char*)(newBlock2 + INFORMATION + KL + POINTERLENGTH));
			}

			int buffernum = bf.GiveMeABlock(name, CHAR2INT(currentBlock + 2 * sizeof(int)));
			bf.useBlock(buffernum);
			char* fatherBlock = new char[BLOCKSIZE];
			::memcpy(fatherBlock, bf.bufferBlock[buffernum].values, BLOCKSIZE);
			// readbuffer;

			temp = split(fatherBlock, mid, key, Addr, leftpos, rightpos);

			CHAR2INT(newBlock1 + 2 * sizeof(int)) = temp[0];
			CHAR2INT(newBlock2 + 2 * sizeof(int)) = temp[1];

			buffernum = bf.GiveMeABlock(name, CHAR2INT(currentBlock + sizeof(int)));
			::memcpy(bf.bufferBlock[buffernum].values, currentBlock, BLOCKSIZE);
			bf.writeBlock(buffernum);
			bf.flashBack(buffernum);
			// writebuffer

			buffernum = bf.GiveMeABlock(name, CHAR2INT(newBlock1 + sizeof(int)));
			::memcpy(bf.bufferBlock[buffernum].values, newBlock1, BLOCKSIZE);
			bf.writeBlock(buffernum);
			bf.flashBack(buffernum);
			// writebuffer
			buffernum = bf.GiveMeABlock(name, CHAR2INT(newBlock2 + sizeof(int)));
			::memcpy(bf.bufferBlock[buffernum].values, newBlock2, BLOCKSIZE);
			bf.writeBlock(buffernum);
			bf.flashBack(buffernum);
			// writebuffer

			father[0] = CHAR2INT(newBlock1 + sizeof(int));
			father[1] = CHAR2INT(newBlock2 + sizeof(int));

			delete[] newBlock1;
			delete[] newBlock2;
			delete[] fatherBlock;
			return father;
		} else if (LeafType == Internal && NumOfKeys < maxchild - 1) {
			CHAR2INT(currentBlock + 3 * sizeof(int)) += 1;

			Internal_insert(currentBlock, mid, leftpos, rightpos);	// insert into internal

			int buffernum = bf.GiveMeABlock(name, 2 * sizeof(int));
			buffernum = bf.GiveMeABlock(name, CHAR2INT(currentBlock + sizeof(int)));
			::memcpy(bf.bufferBlock[buffernum].values, currentBlock, BLOCKSIZE);
			bf.writeBlock(buffernum);
			bf.flashBack(buffernum);
			// writebuffer
			buffernum = bf.GiveMeABlock(name, 2 * sizeof(int));
			father[0] = CHAR2INT(currentBlock + sizeof(int));
			father[1] = CHAR2INT(currentBlock + sizeof(int));

			return father;
		}
	}
}

void index::Internal_insert(char* currentBlock, Data* mid, int leftpos, int rightpos) {
	int NumOfKeys = CHAR2INT(currentBlock + 3 * sizeof(int));
	int KL = keylength[type];
	int bro = CHAR2INT(currentBlock + INFORMATION + KL);
	int LastBro = 0;
	int i = 0;

	for (i = 0; i < NumOfKeys; i++) {
		if (type == 0) {
			if (bro == -1 && i == NumOfKeys - 1) break;
			int NowKey = CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH));
			if ((((Datai*)mid)->x < NowKey)) break;
		} else if (type == 1) {
			if (bro == -1 && i == NumOfKeys - 1) break;
			float NowKey = CHAR2FLOAT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH));
			if ((((Dataf*)mid)->x < NowKey)) break;
		} else {
			if (bro == -1 && i == NumOfKeys - 1) break;
			string NowKey;
			NowKey = (char*)(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH));
			if ((((Datac*)mid)->x.compare(NowKey)) < 0) break;
		}
		LastBro = bro;
		bro = CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL);
	}
	if (type == 0)
		CHAR2INT(currentBlock + INFORMATION + NumOfKeys * (KL + POINTERLENGTH)) = ((Datai*)mid)->x;
	else if (type == 1)
		CHAR2FLOAT(currentBlock + INFORMATION + NumOfKeys * (KL + POINTERLENGTH)) = ((Dataf*)mid)->x;
	else {
		::memcpy((char*)(currentBlock + INFORMATION + NumOfKeys * (KL + POINTERLENGTH)), ((Datac*)mid)->x.c_str(), ((Datac*)mid)->x.length() + 1);
	}

	if (i == NumOfKeys - 1) {
		CHAR2INT(currentBlock + INFORMATION + NumOfKeys * (KL + POINTERLENGTH) + KL) = -1;
		CHAR2INT(currentBlock + INFORMATION + NumOfKeys * (KL + POINTERLENGTH) + KL + sizeof(int)) = leftpos;
		CHAR2INT(currentBlock + INFORMATION + NumOfKeys * (KL + POINTERLENGTH) + KL + 2 * sizeof(int)) = NumOfKeys;
		CHAR2INT(currentBlock + INFORMATION + NumOfKeys * (KL + POINTERLENGTH) + KL + 3 * sizeof(int)) = rightpos;
		CHAR2INT(currentBlock + INFORMATION + LastBro * (KL + POINTERLENGTH) + KL) = NumOfKeys;
		CHAR2INT(currentBlock + INFORMATION + LastBro * (KL + POINTERLENGTH) + KL + 3 * sizeof(int)) = leftpos;
	} else {
		CHAR2INT(currentBlock + INFORMATION + NumOfKeys * (KL + POINTERLENGTH) + KL) = bro;
		CHAR2INT(currentBlock + INFORMATION + NumOfKeys * (KL + POINTERLENGTH) + KL + sizeof(int)) = leftpos;
		CHAR2INT(currentBlock + INFORMATION + NumOfKeys * (KL + POINTERLENGTH) + KL + 2 * sizeof(int)) = NumOfKeys;
		CHAR2INT(currentBlock + INFORMATION + NumOfKeys * (KL + POINTERLENGTH) + KL + 3 * sizeof(int)) = rightpos;
		CHAR2INT(currentBlock + INFORMATION + LastBro * (KL + POINTERLENGTH) + KL) = NumOfKeys;
		CHAR2INT(currentBlock + INFORMATION + LastBro * (KL + POINTERLENGTH) + KL + 3 * sizeof(int)) = leftpos;
		CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL + sizeof(int)) = rightpos;
	}
}

void index::SplitLeaf(char* block1, char* block2, char* currentBlock, Data* key, int Addr) {
	int NumOfKeys = CHAR2INT(currentBlock + 3 * sizeof(int));
	int KL = keylength[type];
	int bro = CHAR2INT(currentBlock + INFORMATION + KL);
	int Address, flag = 1;
	int i, position = 1;

	CHAR2INT(block1) = Leaf;
	CHAR2INT(block1 + sizeof(int)) = Number++;
	CHAR2INT(block1 + 2 * sizeof(int)) = 0;
	CHAR2INT(block1 + 3 * sizeof(int)) = NumOfKeys / 2;
	CHAR2INT(block1 + 4 * sizeof(int)) = 0;

	CHAR2INT(block2) = Leaf;
	CHAR2INT(block2 + sizeof(int)) = Number++;
	CHAR2INT(block2 + 2 * sizeof(int)) = 0;
	CHAR2INT(block2 + 3 * sizeof(int)) = NumOfKeys - (int)(NumOfKeys / 2);
	CHAR2INT(block2 + 4 * sizeof(int)) = 0;

	CHAR2INT(block1 + INFORMATION + KL) = 1;
	CHAR2INT(block2 + INFORMATION + KL) = 1;

	for (i = 0; i < NumOfKeys / 2; i++) {
		if (type == 0) {
			int NowKey = CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH));
			Address = CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL + sizeof(int));
			if ((((Datai*)key)->x < NowKey) && flag) {
				CHAR2INT(block1 + INFORMATION + position * (KL + POINTERLENGTH)) = ((Datai*)key)->x;
				CHAR2INT(block1 + INFORMATION + position * (KL + POINTERLENGTH) + KL) = position + 1;
				CHAR2INT(block1 + INFORMATION + position * (KL + POINTERLENGTH) + KL + sizeof(int)) = Addr;
				CHAR2INT(block1 + INFORMATION + position * (KL + POINTERLENGTH) + KL + 2 * sizeof(int)) = position;
				CHAR2INT(block1 + INFORMATION + position * (KL + POINTERLENGTH) + KL + 4 * sizeof(int)) = 0;  // delete or not
				position++;
				flag = 0;
			} else {
				CHAR2INT(block1 + INFORMATION + position * (KL + POINTERLENGTH)) = NowKey;
				CHAR2INT(block1 + INFORMATION + position * (KL + POINTERLENGTH) + KL) = position + 1;
				CHAR2INT(block1 + INFORMATION + position * (KL + POINTERLENGTH) + KL + sizeof(int)) = Address;
				CHAR2INT(block1 + INFORMATION + position * (KL + POINTERLENGTH) + KL + 2 * sizeof(int)) = position;
				CHAR2INT(block1 + INFORMATION + position * (KL + POINTERLENGTH) + KL + 4 * sizeof(int)) = 0;  // delete or not
				position++;
				bro = CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL);
			}
		} else if (type == 1) {
			float NowKey = CHAR2FLOAT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH));
			Address = CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL + sizeof(int));
			if ((((Dataf*)key)->x < NowKey) && flag) {
				CHAR2FLOAT(block1 + INFORMATION + position * (KL + POINTERLENGTH)) = ((Dataf*)key)->x;
				CHAR2INT(block1 + INFORMATION + position * (KL + POINTERLENGTH) + KL) = position + 1;
				CHAR2INT(block1 + INFORMATION + position * (KL + POINTERLENGTH) + KL + sizeof(int)) = Addr;
				CHAR2INT(block1 + INFORMATION + position * (KL + POINTERLENGTH) + KL + 2 * sizeof(int)) = position;
				CHAR2INT(block1 + INFORMATION + position * (KL + POINTERLENGTH) + KL + 4 * sizeof(int)) = 0;  // delete or not
				position++;
				flag = 0;
			} else {
				CHAR2FLOAT(block1 + INFORMATION + position * (KL + POINTERLENGTH)) = NowKey;
				CHAR2INT(block1 + INFORMATION + position * (KL + POINTERLENGTH) + KL) = position + 1;
				CHAR2INT(block1 + INFORMATION + position * (KL + POINTERLENGTH) + KL + sizeof(int)) = Address;
				CHAR2INT(block1 + INFORMATION + position * (KL + POINTERLENGTH) + KL + 2 * sizeof(int)) = position;
				CHAR2INT(block1 + INFORMATION + position * (KL + POINTERLENGTH) + KL + 4 * sizeof(int)) = 0;  // delete or not
				position++;
				bro = CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL);
			}
		} else {
			string NowKey;
			NowKey = (char*)(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH));
			Address = CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL + sizeof(int));
			if ((((Datac*)key)->x.compare(NowKey)) < 0 && flag) {
				::memcpy((char*)(block1 + INFORMATION + position * (KL + POINTERLENGTH)), ((Datac*)key)->x.c_str(), ((Datac*)key)->x.length() + 1);
				CHAR2INT(block1 + INFORMATION + position * (KL + POINTERLENGTH) + KL) = position + 1;
				CHAR2INT(block1 + INFORMATION + position * (KL + POINTERLENGTH) + KL + sizeof(int)) = Addr;
				CHAR2INT(block1 + INFORMATION + position * (KL + POINTERLENGTH) + KL + 2 * sizeof(int)) = position;
				CHAR2INT(block1 + INFORMATION + position * (KL + POINTERLENGTH) + KL + 4 * sizeof(int)) = 0;  // delete or not
				position++;
				flag = 0;
			} else {
				::memcpy((char*)(block1 + INFORMATION + position * (KL + POINTERLENGTH)), NowKey.c_str(), NowKey.length() + 1);
				CHAR2INT(block1 + INFORMATION + position * (KL + POINTERLENGTH) + KL) = position + 1;
				CHAR2INT(block1 + INFORMATION + position * (KL + POINTERLENGTH) + KL + sizeof(int)) = Address;
				CHAR2INT(block1 + INFORMATION + position * (KL + POINTERLENGTH) + KL + 2 * sizeof(int)) = position;
				CHAR2INT(block1 + INFORMATION + position * (KL + POINTERLENGTH) + KL + 4 * sizeof(int)) = 0;  // delete or not
				position++;
				bro = CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL);
			}
		}
	}
	CHAR2INT(block1 + INFORMATION + (position - 1) * (KL + POINTERLENGTH) + KL) = -1;

	position = 1;
	for (; i < NumOfKeys; i++) {
		if (type == 0) {
			if (bro == -1 && i == NumOfKeys - 1) break;
			int NowKey = CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH));
			Address = CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL + sizeof(int));
			if ((((Datai*)key)->x < NowKey) && flag) {
				CHAR2INT(block2 + INFORMATION + position * (KL + POINTERLENGTH)) = ((Datai*)key)->x;
				CHAR2INT(block2 + INFORMATION + position * (KL + POINTERLENGTH) + KL) = position + 1;
				CHAR2INT(block2 + INFORMATION + position * (KL + POINTERLENGTH) + KL + sizeof(int)) = Addr;
				CHAR2INT(block2 + INFORMATION + position * (KL + POINTERLENGTH) + KL + 2 * sizeof(int)) = position;
				CHAR2INT(block2 + INFORMATION + position * (KL + POINTERLENGTH) + KL + 4 * sizeof(int)) = 0;  // delete or not
				position++;
				flag = 0;
			} else {
				CHAR2INT(block2 + INFORMATION + position * (KL + POINTERLENGTH)) = NowKey;
				CHAR2INT(block2 + INFORMATION + position * (KL + POINTERLENGTH) + KL) = position + 1;
				CHAR2INT(block2 + INFORMATION + position * (KL + POINTERLENGTH) + KL + sizeof(int)) = Address;
				CHAR2INT(block2 + INFORMATION + position * (KL + POINTERLENGTH) + KL + 2 * sizeof(int)) = position;
				CHAR2INT(block2 + INFORMATION + position * (KL + POINTERLENGTH) + KL + 4 * sizeof(int)) = 0;  // delete or not
				position++;
				bro = CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL);
			}
		} else if (type == 1) {
			if (bro == -1 && i == NumOfKeys - 1) break;
			float NowKey = CHAR2FLOAT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH));
			Address = CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL + sizeof(int));
			if ((((Dataf*)key)->x < NowKey) && flag) {
				CHAR2FLOAT(block2 + INFORMATION + position * (KL + POINTERLENGTH)) = ((Dataf*)key)->x;
				CHAR2INT(block2 + INFORMATION + position * (KL + POINTERLENGTH) + KL) = position + 1;
				CHAR2INT(block2 + INFORMATION + position * (KL + POINTERLENGTH) + KL + sizeof(int)) = Addr;
				CHAR2INT(block2 + INFORMATION + position * (KL + POINTERLENGTH) + KL + 2 * sizeof(int)) = position;
				CHAR2INT(block2 + INFORMATION + position * (KL + POINTERLENGTH) + KL + 4 * sizeof(int)) = 0;  // delete or not
				position++;
				flag = 0;
			} else {
				CHAR2FLOAT(block2 + INFORMATION + position * (KL + POINTERLENGTH)) = NowKey;
				CHAR2INT(block2 + INFORMATION + position * (KL + POINTERLENGTH) + KL) = position + 1;
				CHAR2INT(block2 + INFORMATION + position * (KL + POINTERLENGTH) + KL + sizeof(int)) = Address;
				CHAR2INT(block2 + INFORMATION + position * (KL + POINTERLENGTH) + KL + 2 * sizeof(int)) = position;
				CHAR2INT(block2 + INFORMATION + position * (KL + POINTERLENGTH) + KL + 4 * sizeof(int)) = 0;  // delete or not
				position++;
				bro = CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL);
			}
		} else {
			if (bro == -1 && i == NumOfKeys - 1) break;
			string NowKey;
			NowKey = (char*)(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH));
			Address = CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL + sizeof(int));
			if ((((Datac*)key)->x.compare(NowKey)) < 0 && flag) {
				::memcpy((char*)(block2 + INFORMATION + position * (KL + POINTERLENGTH)), ((Datac*)key)->x.c_str(), ((Datac*)key)->x.length() + 1);
				CHAR2INT(block2 + INFORMATION + position * (KL + POINTERLENGTH) + KL) = position + 1;
				CHAR2INT(block2 + INFORMATION + position * (KL + POINTERLENGTH) + KL + sizeof(int)) = Addr;
				CHAR2INT(block2 + INFORMATION + position * (KL + POINTERLENGTH) + KL + 2 * sizeof(int)) = position;
				CHAR2INT(block2 + INFORMATION + position * (KL + POINTERLENGTH) + KL + 4 * sizeof(int)) = 0;  // delete or not
				position++;
				flag = 0;
			} else {
				::memcpy((char*)(block2 + INFORMATION + position * (KL + POINTERLENGTH)), NowKey.c_str(), NowKey.length() + 1);
				CHAR2INT(block2 + INFORMATION + position * (KL + POINTERLENGTH) + KL) = position + 1;
				CHAR2INT(block2 + INFORMATION + position * (KL + POINTERLENGTH) + KL + sizeof(int)) = Address;
				CHAR2INT(block2 + INFORMATION + position * (KL + POINTERLENGTH) + KL + 2 * sizeof(int)) = position;
				CHAR2INT(block2 + INFORMATION + position * (KL + POINTERLENGTH) + KL + 4 * sizeof(int)) = 0;  // delete or not
				position++;
				bro = CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL);
			}
		}
	}
	if (flag) {
		if (key->flag == -1)
			CHAR2INT(block2 + INFORMATION + position * (KL + POINTERLENGTH)) = ((Datai*)key)->x;
		else if (key->flag == 0)
			CHAR2FLOAT(block2 + INFORMATION + position * (KL + POINTERLENGTH)) = ((Dataf*)key)->x;
		else {
			::memcpy((char*)(block2 + INFORMATION + position * (KL + POINTERLENGTH)), ((Datac*)key)->x.c_str(), ((Datac*)key)->x.length() + 1);
		}
		CHAR2INT(block2 + INFORMATION + position * (KL + POINTERLENGTH) + KL) = -1;
		CHAR2INT(block2 + INFORMATION + position * (KL + POINTERLENGTH) + KL + sizeof(int)) = Addr;
		CHAR2INT(block2 + INFORMATION + position * (KL + POINTERLENGTH) + KL + 4 * sizeof(int)) = 0;  // delete or not
		CHAR2INT(block2 + INFORMATION + position * (KL + POINTERLENGTH) + KL + 2 * sizeof(int)) = position;
		position++;
	}
	CHAR2INT(block2 + INFORMATION + (position - 1) * (KL + POINTERLENGTH) + KL) = -1;
}

void index::SplitInternal(char* block1, char* block2, char* currentBlock, Data* mid, int leftpos, int rightpos) {
	CHAR2INT(currentBlock + 3 * sizeof(int)) += 1;
	int NumOfKeys = CHAR2INT(currentBlock + 3 * sizeof(int));
	int KL = keylength[type];
	int bro = CHAR2INT(currentBlock + INFORMATION + KL);
	int Addr1, Addr2;
	int i, position = 1, flag = 1, LastBro = 0;

	CHAR2INT(block1) = Internal;
	CHAR2INT(block1 + sizeof(int)) = Number++;
	CHAR2INT(block1 + 2 * sizeof(int)) = 0;
	CHAR2INT(block1 + 3 * sizeof(int)) = NumOfKeys / 2;
	CHAR2INT(block1 + 4 * sizeof(int)) = 0;

	CHAR2INT(block2) = Internal;
	CHAR2INT(block2 + sizeof(int)) = Number++;
	CHAR2INT(block2 + 2 * sizeof(int)) = 0;
	CHAR2INT(block2 + 3 * sizeof(int)) = NumOfKeys - (int)(NumOfKeys / 2);
	CHAR2INT(block2 + 4 * sizeof(int)) = 0;

	CHAR2INT(block1 + INFORMATION + KL) = 1;
	CHAR2INT(block2 + INFORMATION + KL) = 1;

	for (i = 0; i < NumOfKeys / 2; i++) {
		if (type == 0) {
			int NowKey = CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH));
			Addr1 = CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL + sizeof(int));
			Addr2 = CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL + 3 * sizeof(int));
			if ((((Datai*)mid)->x <= NowKey) && flag) {
				CHAR2INT(block1 + INFORMATION + position * (KL + POINTERLENGTH)) = ((Datai*)mid)->x;
				CHAR2INT(block1 + INFORMATION + position * (KL + POINTERLENGTH) + KL) = position + 1;
				CHAR2INT(block1 + INFORMATION + position * (KL + POINTERLENGTH) + KL + sizeof(int)) = leftpos;
				CHAR2INT(block1 + INFORMATION + position * (KL + POINTERLENGTH) + KL + 2 * sizeof(int)) = position;
				CHAR2INT(block1 + INFORMATION + position * (KL + POINTERLENGTH) + KL + 3 * sizeof(int)) = rightpos;
				CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL + sizeof(int)) = rightpos;
				CHAR2INT(block1 + INFORMATION + (position - 1) * (KL + POINTERLENGTH) + KL + 3 * sizeof(int)) = leftpos;
				CHAR2INT(block1 + INFORMATION + position * (KL + POINTERLENGTH) + KL + 4 * sizeof(int)) = 0;  // delete or not
				position++;
				flag = 0;
			} else {
				CHAR2INT(block1 + INFORMATION + position * (KL + POINTERLENGTH)) = NowKey;
				CHAR2INT(block1 + INFORMATION + position * (KL + POINTERLENGTH) + KL) = position + 1;
				CHAR2INT(block1 + INFORMATION + position * (KL + POINTERLENGTH) + KL + sizeof(int)) = Addr1;
				CHAR2INT(block1 + INFORMATION + position * (KL + POINTERLENGTH) + KL + 2 * sizeof(int)) = position;
				CHAR2INT(block1 + INFORMATION + position * (KL + POINTERLENGTH) + KL + 3 * sizeof(int)) = Addr2;
				CHAR2INT(block1 + INFORMATION + position * (KL + POINTERLENGTH) + KL + 4 * sizeof(int)) = 0;  // delete or not
				LastBro = bro;
				bro = CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL);
				position++;
			}
		} else if (type == 1) {
			int NowKey = CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH));
			Addr1 = CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL + sizeof(int));
			Addr2 = CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL + 3 * sizeof(int));
			if ((((Dataf*)mid)->x <= NowKey) && flag) {
				CHAR2INT(block1 + INFORMATION + position * (KL + POINTERLENGTH)) = ((Dataf*)mid)->x;
				CHAR2INT(block1 + INFORMATION + position * (KL + POINTERLENGTH) + KL) = position + 1;
				CHAR2INT(block1 + INFORMATION + position * (KL + POINTERLENGTH) + KL + sizeof(int)) = leftpos;
				CHAR2INT(block1 + INFORMATION + position * (KL + POINTERLENGTH) + KL + 2 * sizeof(int)) = position;
				CHAR2INT(block1 + INFORMATION + position * (KL + POINTERLENGTH) + KL + 3 * sizeof(int)) = rightpos;
				CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL + sizeof(int)) = rightpos;
				CHAR2INT(block1 + INFORMATION + (position - 1) * (KL + POINTERLENGTH) + KL + 3 * sizeof(int)) = leftpos;
				CHAR2INT(block1 + INFORMATION + position * (KL + POINTERLENGTH) + KL + 4 * sizeof(int)) = 0;  // delete or not
				position++;
				flag = 0;
			} else {
				CHAR2INT(block1 + INFORMATION + position * (KL + POINTERLENGTH)) = NowKey;
				CHAR2INT(block1 + INFORMATION + position * (KL + POINTERLENGTH) + KL) = position + 1;
				CHAR2INT(block1 + INFORMATION + position * (KL + POINTERLENGTH) + KL + sizeof(int)) = Addr1;
				CHAR2INT(block1 + INFORMATION + position * (KL + POINTERLENGTH) + KL + 2 * sizeof(int)) = position;
				CHAR2INT(block1 + INFORMATION + position * (KL + POINTERLENGTH) + KL + 3 * sizeof(int)) = Addr2;
				CHAR2INT(block1 + INFORMATION + position * (KL + POINTERLENGTH) + KL + 4 * sizeof(int)) = 0;  // delete or not
				LastBro = bro;
				bro = CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL);
				position++;
			}
		}

		else {
			string NowKey;
			NowKey = (char*)(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH));
			Addr1 = CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL + sizeof(int));
			Addr2 = CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL + 3 * sizeof(int));
			if ((((Datac*)mid)->x.compare(NowKey)) <= 0 && flag) {
				::memcpy((char*)(block1 + INFORMATION + position * (KL + POINTERLENGTH)), ((Datac*)mid)->x.c_str(), ((Datac*)mid)->x.length() + 1);
				CHAR2INT(block1 + INFORMATION + position * (KL + POINTERLENGTH) + KL) = position + 1;
				CHAR2INT(block1 + INFORMATION + position * (KL + POINTERLENGTH) + KL + sizeof(int)) = leftpos;
				CHAR2INT(block1 + INFORMATION + position * (KL + POINTERLENGTH) + KL + 2 * sizeof(int)) = position;
				CHAR2INT(block1 + INFORMATION + position * (KL + POINTERLENGTH) + KL + 3 * sizeof(int)) = rightpos;
				CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL + sizeof(int)) = rightpos;
				CHAR2INT(block1 + INFORMATION + (position - 1) * (KL + POINTERLENGTH) + KL + 3 * sizeof(int)) = leftpos;
				CHAR2INT(block1 + INFORMATION + position * (KL + POINTERLENGTH) + KL + 4 * sizeof(int)) = 0;  // delete or not
				position++;
				flag = 0;
			} else {
				::memcpy((char*)(block1 + INFORMATION + position * (KL + POINTERLENGTH)), NowKey.c_str(), NowKey.length() + 1);
				CHAR2INT(block1 + INFORMATION + position * (KL + POINTERLENGTH) + KL) = position + 1;
				CHAR2INT(block1 + INFORMATION + position * (KL + POINTERLENGTH) + KL + sizeof(int)) = Addr1;
				CHAR2INT(block1 + INFORMATION + position * (KL + POINTERLENGTH) + KL + 2 * sizeof(int)) = position;
				CHAR2INT(block1 + INFORMATION + position * (KL + POINTERLENGTH) + KL + 3 * sizeof(int)) = Addr2;
				CHAR2INT(block1 + INFORMATION + position * (KL + POINTERLENGTH) + KL + 4 * sizeof(int)) = 0;  // delete or not
				LastBro = bro;
				bro = CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL);
				position++;
			}
		}
	}

	position = 1;
	int j = i;
	for (; i < NumOfKeys; i++) {
		if (type == 0) {
			if (bro == -1 && i == NumOfKeys - 1) break;
			int NowKey = CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH));
			Addr1 = CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL + sizeof(int));
			Addr2 = CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL + 3 * sizeof(int));
			if ((((Datai*)mid)->x <= NowKey) && flag) {
				CHAR2INT(block2 + INFORMATION + position * (KL + POINTERLENGTH)) = ((Datai*)mid)->x;
				CHAR2INT(block2 + INFORMATION + position * (KL + POINTERLENGTH) + KL) = position + 1;
				CHAR2INT(block2 + INFORMATION + position * (KL + POINTERLENGTH) + KL + sizeof(int)) = leftpos;
				CHAR2INT(block2 + INFORMATION + position * (KL + POINTERLENGTH) + KL + 2 * sizeof(int)) = position;
				CHAR2INT(block2 + INFORMATION + position * (KL + POINTERLENGTH) + KL + 3 * sizeof(int)) = rightpos;
				CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL + sizeof(int)) = rightpos;
				if (i == j) {
					CHAR2INT(block1 + INFORMATION + CHAR2INT(block1 + 3 * sizeof(int)) * (KL + POINTERLENGTH) + KL + 3 * sizeof(int)) = leftpos;
				} else
					CHAR2INT(block2 + INFORMATION + (position - 1) * (KL + POINTERLENGTH) + KL + 3 * sizeof(int)) = leftpos;
				CHAR2INT(block2 + INFORMATION + position * (KL + POINTERLENGTH) + KL + 4 * sizeof(int)) = 0;  // delete or not
				position++;
				flag = 0;
			} else {
				CHAR2INT(block2 + INFORMATION + position * (KL + POINTERLENGTH)) = NowKey;
				CHAR2INT(block2 + INFORMATION + position * (KL + POINTERLENGTH) + KL) = position + 1;
				CHAR2INT(block2 + INFORMATION + position * (KL + POINTERLENGTH) + KL + sizeof(int)) = Addr1;
				CHAR2INT(block2 + INFORMATION + position * (KL + POINTERLENGTH) + KL + 2 * sizeof(int)) = position;
				CHAR2INT(block2 + INFORMATION + position * (KL + POINTERLENGTH) + KL + 3 * sizeof(int)) = Addr2;
				CHAR2INT(block2 + INFORMATION + position * (KL + POINTERLENGTH) + KL + 4 * sizeof(int)) = 0;  // delete or not
				LastBro = bro;
				bro = CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL);
				position++;
			}
		} else if (type == 1) {
			if (bro == -1 && i == NumOfKeys - 1) break;
			int NowKey = CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH));
			Addr1 = CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL + sizeof(int));
			Addr2 = CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL + 3 * sizeof(int));
			if ((((Dataf*)mid)->x <= NowKey) && flag) {
				CHAR2INT(block2 + INFORMATION + position * (KL + POINTERLENGTH)) = ((Dataf*)mid)->x;
				CHAR2INT(block2 + INFORMATION + position * (KL + POINTERLENGTH) + KL) = position + 1;
				CHAR2INT(block2 + INFORMATION + position * (KL + POINTERLENGTH) + KL + sizeof(int)) = leftpos;
				CHAR2INT(block2 + INFORMATION + position * (KL + POINTERLENGTH) + KL + 2 * sizeof(int)) = position;
				CHAR2INT(block2 + INFORMATION + position * (KL + POINTERLENGTH) + KL + 3 * sizeof(int)) = rightpos;
				CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL + sizeof(int)) = rightpos;
				if (i == j) {
					CHAR2INT(block1 + INFORMATION + CHAR2INT(block1 + 3 * sizeof(int)) * (KL + POINTERLENGTH) + KL + 3 * sizeof(int)) = leftpos;
				} else
					CHAR2INT(block2 + INFORMATION + (position - 1) * (KL + POINTERLENGTH) + KL + 3 * sizeof(int)) = leftpos;
				CHAR2INT(block2 + INFORMATION + position * (KL + POINTERLENGTH) + KL + 4 * sizeof(int)) = 0;  // delete or not
				position++;
				flag = 0;
			} else {
				CHAR2INT(block2 + INFORMATION + position * (KL + POINTERLENGTH)) = NowKey;
				CHAR2INT(block2 + INFORMATION + position * (KL + POINTERLENGTH) + KL) = position + 1;
				CHAR2INT(block2 + INFORMATION + position * (KL + POINTERLENGTH) + KL + sizeof(int)) = Addr1;
				CHAR2INT(block2 + INFORMATION + position * (KL + POINTERLENGTH) + KL + 2 * sizeof(int)) = position;
				CHAR2INT(block2 + INFORMATION + position * (KL + POINTERLENGTH) + KL + 3 * sizeof(int)) = Addr2;
				CHAR2INT(block2 + INFORMATION + position * (KL + POINTERLENGTH) + KL + 4 * sizeof(int)) = 0;  // delete or not
				LastBro = bro;
				bro = CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL);
				position++;
			}
		}

		else {
			if (bro == -1 && i == NumOfKeys - 1) break;
			string NowKey;
			NowKey = (char*)(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH));
			Addr1 = CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL + sizeof(int));
			Addr2 = CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL + 3 * sizeof(int));
			if ((((Datac*)mid)->x.compare(NowKey)) <= 0 && flag) {
				::memcpy((char*)(block2 + INFORMATION + position * (KL + POINTERLENGTH)), ((Datac*)mid)->x.c_str(), ((Datac*)mid)->x.length() + 1);
				CHAR2INT(block2 + INFORMATION + position * (KL + POINTERLENGTH) + KL) = position + 1;
				CHAR2INT(block2 + INFORMATION + position * (KL + POINTERLENGTH) + KL + sizeof(int)) = leftpos;
				CHAR2INT(block2 + INFORMATION + position * (KL + POINTERLENGTH) + KL + 2 * sizeof(int)) = position;
				CHAR2INT(block2 + INFORMATION + position * (KL + POINTERLENGTH) + KL + 3 * sizeof(int)) = rightpos;
				CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL + sizeof(int)) = rightpos;
				if (i == j) {
					CHAR2INT(block1 + INFORMATION + CHAR2INT(block1 + 3 * sizeof(int)) * (KL + POINTERLENGTH) + KL + 3 * sizeof(int)) = leftpos;
				} else
					CHAR2INT(block2 + INFORMATION + (position - 1) * (KL + POINTERLENGTH) + KL + 3 * sizeof(int)) = leftpos;
				CHAR2INT(block2 + INFORMATION + position * (KL + POINTERLENGTH) + KL + 4 * sizeof(int)) = 0;  // delete or not
				position++;
				flag = 0;
			} else {
				::memcpy((char*)(block2 + INFORMATION + position * (KL + POINTERLENGTH)), NowKey.c_str(), NowKey.length() + 1);
				CHAR2INT(block2 + INFORMATION + position * (KL + POINTERLENGTH) + KL) = position + 1;
				CHAR2INT(block2 + INFORMATION + position * (KL + POINTERLENGTH) + KL + sizeof(int)) = Addr1;
				CHAR2INT(block2 + INFORMATION + position * (KL + POINTERLENGTH) + KL + 2 * sizeof(int)) = position;
				CHAR2INT(block2 + INFORMATION + position * (KL + POINTERLENGTH) + KL + 3 * sizeof(int)) = Addr2;
				CHAR2INT(block2 + INFORMATION + position * (KL + POINTERLENGTH) + KL + 4 * sizeof(int)) = 0;  // delete or not
				LastBro = bro;
				bro = CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL);
				position++;
			}
		}
	}
	if (flag) {
		if (mid->flag == -1)
			CHAR2INT(block2 + INFORMATION + position * (KL + POINTERLENGTH)) = ((Datai*)mid)->x;
		else if (mid->flag == 0)
			CHAR2FLOAT(block2 + INFORMATION + position * (KL + POINTERLENGTH)) = ((Dataf*)mid)->x;
		else {
			::memcpy((char*)(block2 + INFORMATION + position * (KL + POINTERLENGTH)), ((Datac*)mid)->x.c_str(), ((Datac*)mid)->x.length() + 1);
		}
		CHAR2INT(block2 + INFORMATION + position * (KL + POINTERLENGTH) + KL) = -1;
		CHAR2INT(block2 + INFORMATION + position * (KL + POINTERLENGTH) + KL + sizeof(int)) = leftpos;
		CHAR2INT(block2 + INFORMATION + position * (KL + POINTERLENGTH) + KL + 2 * sizeof(int)) = position;
		CHAR2INT(block2 + INFORMATION + position * (KL + POINTERLENGTH) + KL + 4 * sizeof(int)) = 0;  // delete or not
		CHAR2INT(block2 + INFORMATION + position * (KL + POINTERLENGTH) + KL + 3 * sizeof(int)) = rightpos;
		CHAR2INT(block2 + INFORMATION + (position - 1) * (KL + POINTERLENGTH) + KL + 3 * sizeof(int)) = leftpos;
		position++;
	}
}

void index::Delete(Data* key) {
	char* currentBlock = new char[BLOCKSIZE];

	int buffernum = bf.GiveMeABlock(name, 0);
	bf.useBlock(buffernum);
	::memcpy(currentBlock, bf.bufferBlock[buffernum].values, BLOCKSIZE);
	// readbuffer;
	int LeafType = CHAR2INT(currentBlock);
	int KL = keylength[type];
	int bro = CHAR2INT(currentBlock + INFORMATION + KL);
	int tempbro, position;

	while (LeafType == Internal) {
		int NumOfKeys = CHAR2INT(currentBlock + 3 * sizeof(int));
		int i = 0;

		for (i = 0; i < NumOfKeys; i++) {
			if (type == 0) {
				int NowKey = CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH));
				tempbro = bro;
				position = CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL + sizeof(int));
				bro = CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL);
				if ((((Datai*)key)->x < NowKey)) break;
			} else if (type == 1) {
				float NowKey = CHAR2FLOAT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH));
				tempbro = bro;
				position = CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL + sizeof(int));
				bro = CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL);
				if ((((Dataf*)key)->x < NowKey)) break;
			} else {
				string NowKey((char*)(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH)));
				tempbro = bro;
				position = CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL + sizeof(int));
				bro = CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL);
				if ((((Datac*)key)->x.compare(NowKey)) < 0) break;
			}
		}
		if (i == NumOfKeys) position = CHAR2INT(currentBlock + INFORMATION + tempbro * (KL + POINTERLENGTH) + KL + 3 * sizeof(int));
		if (position == -1) {
			//throw TableException("Wrong delete!");
			return;
		}
		int buffernum = bf.GiveMeABlock(name, position);
		bf.useBlock(buffernum);
		::memcpy(currentBlock, bf.bufferBlock[buffernum].values, BLOCKSIZE);
		LeafType = CHAR2INT(currentBlock);
		bro = CHAR2INT(currentBlock + INFORMATION + KL);
		// readbuffer
	}

	int NumOfKeys = CHAR2INT(currentBlock + 3 * sizeof(int));
	bro = CHAR2INT(currentBlock + INFORMATION + KL);
	int i = 0;
	for (i = 0; i < NumOfKeys; i++) {
		if (type == 0) {
			int NowKey = CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH));
			tempbro = bro;
			int Addr = CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL + sizeof(int));
			position = CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL + sizeof(int));
			bro = CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL);
			if ((((Datai*)key)->x == NowKey) && CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL + 4 * sizeof(int)) != 1) {
				CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL + 4 * sizeof(int)) = 1;
				int buffernum = bf.GiveMeABlock(name, CHAR2INT(currentBlock + sizeof(int)));
				::memcpy(bf.bufferBlock[buffernum].values, currentBlock, BLOCKSIZE);
				break;
			} 
			// else {
			// 	//throw TableException("Wrong delete!");
			// 	return;
		} else if (type == 1) {
			float NowKey = CHAR2FLOAT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH));
			tempbro = bro;
			int Addr = CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL + sizeof(int));
			position = CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL + sizeof(int));
			bro = CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL);
			if ((((Dataf*)key)->x == NowKey) && CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL + 4 * sizeof(int)) != 1) {
				//delete_entry(currentBlock, key, 0);
				CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL + 4 * sizeof(int)) = 1;
				int buffernum = bf.GiveMeABlock(name, CHAR2INT(currentBlock + sizeof(int)));
				::memcpy(bf.bufferBlock[buffernum].values, currentBlock, BLOCKSIZE);
				break;
			} 
			// else {
			// 	//throw TableException("Wrong delete!");
			// 	return;
			// }
		} else {
			string NowKey;
			NowKey = (char*)(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH));
			tempbro = bro;
			int Addr = CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL + sizeof(int));
			position = CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL + sizeof(int));
			bro = CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL);
			if ((((Datac*)key)->x.compare(NowKey)) == 0 && CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL + 4 * sizeof(int)) != 1) {
				//delete_entry(currentBlock, key, 0);
				CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL + 4 * sizeof(int)) = 1;
				int buffernum = bf.GiveMeABlock(name, CHAR2INT(currentBlock + sizeof(int)));
				::memcpy(bf.bufferBlock[buffernum].values, currentBlock, BLOCKSIZE);
				break;
			}
		}

		if (i == NumOfKeys) {
			//throw TableException("Wrong delete!");
			return;
		}
	}
	delete[] currentBlock;
}

void index::delete_entry(char* currentBlock, Data* key, int p)	//
{
	int NumOfKeys = CHAR2INT(currentBlock + 3 * sizeof(int));
	int nodetype = CHAR2INT(currentBlock);
	int father = CHAR2INT(currentBlock + 2 * sizeof(int));
	int KL = keylength[type];
	int bro = CHAR2INT(currentBlock + INFORMATION + KL);
	int lp, rp;
	int tempbro, position;
	int i = 0;
	for (i = 0; i < NumOfKeys; i++) {
		if (type == 0) {
			int NowKey = CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH));
			tempbro = bro;
			int Addr = CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL + sizeof(int));
			position = CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL + sizeof(int));
			bro = CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL);
			lp = CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL + sizeof(int));
			rp = CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL + 3 * sizeof(int));
			if ((((Datai*)key)->x == NowKey) && CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL + 4 * sizeof(int)) != 1) {
				CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL + 4 * sizeof(int)) = 1;
				NumOfKeys--;
				CHAR2INT(currentBlock + 3 * sizeof(int)) = NumOfKeys;
				if (father < 0 && NumOfKeys == 1)  // N是根节点且只剩一个子节点
				{
					if (lp == p) {
						int buffernum = bf.GiveMeABlock(name, rp);
						::memcpy(bf.bufferBlock[buffernum].values, currentBlock, BLOCKSIZE);
					} else {
						int buffernum = bf.GiveMeABlock(name, lp);
						::memcpy(bf.bufferBlock[buffernum].values, currentBlock, BLOCKSIZE);
					}
					CHAR2INT(currentBlock + 2 * sizeof(int)) == -1;
					Number--;
				} else if (NumOfKeys < maxchild / 2)  //值太少
				{
					char* parent = new char[BLOCKSIZE];
					int buffernum = bf.GiveMeABlock(name, CHAR2INT(currentBlock + 2 * sizeof(int)));
					::memcpy(bf.bufferBlock[buffernum].values, parent, BLOCKSIZE);
					char* newleaf = new char[BLOCKSIZE];
					buffernum = bf.GiveMeABlock(name, bro);
					::memcpy(bf.bufferBlock[buffernum].values, newleaf, BLOCKSIZE);
					int newleafnum = CHAR2INT(newleaf + 3 * sizeof(int));
					int x = CHAR2INT(newleaf + INFORMATION + newleafnum * (keylength[type] + POINTERLENGTH));
					// Data* nkey;
					//(*(Datai*)nkey).x = x;
					Datai nkey(x);
					int np = CHAR2INT(newleaf + INFORMATION + newleafnum * (keylength[type] + POINTERLENGTH) + keylength[type] + sizeof(int));
					if (newleafnum + NumOfKeys < maxchild)	//可以合并
					{
						CHAR2INT(newleaf + 2 * sizeof(int)) = newleafnum + NumOfKeys;
						::memcpy(newleaf + INFORMATION + (newleafnum + 1) * (keylength[type] + POINTERLENGTH), currentBlock + INFORMATION + (keylength[type] + POINTERLENGTH),
								 NumOfKeys * (keylength[type] + POINTERLENGTH));
						CHAR2INT(newleaf + INFORMATION + (newleafnum + 1) * (keylength[type] + POINTERLENGTH) + keylength[type]) = newleafnum;
					}
					delete_entry(parent, &nkey, np);
				} else	//从后面借一个索引项
				{
					char* newleaf = new char[BLOCKSIZE];
					int buffernum = bf.GiveMeABlock(name, bro);
					::memcpy(bf.bufferBlock[buffernum].values, newleaf, BLOCKSIZE);
					int newleafnum = CHAR2INT(newleaf + 3 * sizeof(int));
					CHAR2INT(newleaf + INFORMATION + (newleafnum - 1) * (keylength[type] + POINTERLENGTH) + keylength[type]) = -1;
					CHAR2INT(newleaf + INFORMATION + newleafnum * (keylength[type] + POINTERLENGTH) + keylength[type] + 4 * sizeof(int)) = 1;  // delete
					char temp[BLOCKSIZE];
					::memcpy(temp, currentBlock + INFORMATION + keylength[type] + POINTERLENGTH, NumOfKeys * (keylength[type] + POINTERLENGTH));
					::memcpy(currentBlock + INFORMATION + keylength[type] + POINTERLENGTH, newleaf + INFORMATION + newleafnum * (keylength[type] + POINTERLENGTH), keylength[type] + POINTERLENGTH);
					::memcpy(currentBlock + INFORMATION + 2 * keylength[type] + 2 * POINTERLENGTH, temp, NumOfKeys * (keylength[type] + POINTERLENGTH));
					CHAR2INT(currentBlock + 3 * sizeof(int)) = NumOfKeys + 1;
					char* parent = new char[BLOCKSIZE];
					buffernum = bf.GiveMeABlock(name, CHAR2INT(currentBlock + 2 * sizeof(int)));
					::memcpy(bf.bufferBlock[buffernum].values, parent, BLOCKSIZE);
					int x = CHAR2INT(newleaf + INFORMATION + newleafnum * (keylength[type] + POINTERLENGTH));
					int p = CHAR2INT(newleaf + INFORMATION + newleafnum * (keylength[type] + POINTERLENGTH) + keylength[type]);
					CHAR2INT(parent + INFORMATION + keylength[type] + POINTERLENGTH) = x;
					CHAR2INT(parent + INFORMATION + 2 * keylength[type] + POINTERLENGTH) = p;
				}

			} else {
				throw TableException("Wrong delete!");
			}
		} else if (type == 1) {
			int NowKey = CHAR2FLOAT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH));
			tempbro = bro;
			int Addr = CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL + sizeof(int));
			position = CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL + sizeof(int));
			bro = CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL);
			lp = CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL + sizeof(int));
			rp = CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL + 3 * sizeof(int));
			if ((((Dataf*)key)->x == NowKey) && CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL + 4 * sizeof(int)) != 1) {
				CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL + 4 * sizeof(int)) = 1;
				NumOfKeys--;
				CHAR2INT(currentBlock + 3 * sizeof(int)) = NumOfKeys;
				if (father < 0 && NumOfKeys == 1)  // N是根节点且只剩一个子节点
				{
					if (lp == p) {
						int buffernum = bf.GiveMeABlock(name, rp);
						::memcpy(bf.bufferBlock[buffernum].values, currentBlock, BLOCKSIZE);
					} else {
						int buffernum = bf.GiveMeABlock(name, lp);
						::memcpy(bf.bufferBlock[buffernum].values, currentBlock, BLOCKSIZE);
					}
					CHAR2INT(currentBlock + 2 * sizeof(int)) == -1;
					Number--;
				} else if (NumOfKeys < maxchild / 2)  //值太少
				{
					char* parent = new char[BLOCKSIZE];
					int buffernum = bf.GiveMeABlock(name, CHAR2INT(currentBlock + 2 * sizeof(int)));
					::memcpy(bf.bufferBlock[buffernum].values, parent, BLOCKSIZE);
					char* newleaf = new char[BLOCKSIZE];
					buffernum = bf.GiveMeABlock(name, bro);
					::memcpy(bf.bufferBlock[buffernum].values, newleaf, BLOCKSIZE);
					int newleafnum = CHAR2INT(newleaf + 3 * sizeof(int));
					float x = CHAR2FLOAT(newleaf + INFORMATION + newleafnum * (keylength[type] + POINTERLENGTH));
					// Data* nkey;
					//(*(Dataf*)nkey).x = x;
					Dataf nkey(x);
					int np = CHAR2INT(newleaf + INFORMATION + newleafnum * (keylength[type] + POINTERLENGTH) + keylength[type] + sizeof(int));
					if (newleafnum + NumOfKeys < maxchild)	//可以合并
					{
						CHAR2INT(newleaf + 2 * sizeof(int)) = newleafnum + NumOfKeys;
						::memcpy(newleaf + INFORMATION + (newleafnum + 1) * (keylength[type] + POINTERLENGTH), currentBlock + INFORMATION + (keylength[type] + POINTERLENGTH),
								 NumOfKeys * (keylength[type] + POINTERLENGTH));
						CHAR2INT(newleaf + INFORMATION + (newleafnum + 1) * (keylength[type] + POINTERLENGTH) + keylength[type]) = newleafnum;
					}
					delete_entry(parent, &nkey, np);
				} else	//从后面借一个索引项
				{
					char* newleaf = new char[BLOCKSIZE];
					int buffernum = bf.GiveMeABlock(name, bro);
					::memcpy(bf.bufferBlock[buffernum].values, newleaf, BLOCKSIZE);
					int newleafnum = CHAR2INT(newleaf + 3 * sizeof(int));
					CHAR2INT(newleaf + INFORMATION + (newleafnum - 1) * (keylength[type] + POINTERLENGTH) + keylength[type]) = -1;
					CHAR2INT(newleaf + INFORMATION + newleafnum * (keylength[type] + POINTERLENGTH) + keylength[type] + 4 * sizeof(int)) = 1;  // delete
					char temp[BLOCKSIZE];
					::memcpy(temp, currentBlock + INFORMATION + keylength[type] + POINTERLENGTH, NumOfKeys * (keylength[type] + POINTERLENGTH));
					::memcpy(currentBlock + INFORMATION + keylength[type] + POINTERLENGTH, newleaf + INFORMATION + newleafnum * (keylength[type] + POINTERLENGTH), keylength[type] + POINTERLENGTH);
					::memcpy(currentBlock + INFORMATION + 2 * keylength[type] + 2 * POINTERLENGTH, temp, NumOfKeys * (keylength[type] + POINTERLENGTH));
					CHAR2INT(currentBlock + 3 * sizeof(int)) = NumOfKeys + 1;
					char* parent = new char[BLOCKSIZE];
					buffernum = bf.GiveMeABlock(name, CHAR2INT(currentBlock + 2 * sizeof(int)));
					::memcpy(bf.bufferBlock[buffernum].values, parent, BLOCKSIZE);
					float x = CHAR2INT(newleaf + INFORMATION + newleafnum * (keylength[type] + POINTERLENGTH));
					int p = CHAR2INT(newleaf + INFORMATION + newleafnum * (keylength[type] + POINTERLENGTH) + keylength[type]);
					CHAR2FLOAT(parent + INFORMATION + keylength[type] + POINTERLENGTH) = x;
					CHAR2INT(parent + INFORMATION + 2 * keylength[type] + POINTERLENGTH) = p;
				}
			} else {
				throw TableException("Wrong delete!");
			}
		} else {
			string NowKey = *(string*)(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH));
			tempbro = bro;
			int Addr = CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL + sizeof(int));
			position = CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL + sizeof(int));
			bro = CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL);
			lp = CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL + sizeof(int));
			rp = CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL + 3 * sizeof(int));
			if ((((Datac*)key)->x == NowKey) && CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL + 4 * sizeof(int)) != 1) {
				CHAR2INT(currentBlock + INFORMATION + bro * (KL + POINTERLENGTH) + KL + 4 * sizeof(int)) = 1;
				NumOfKeys--;
				CHAR2INT(currentBlock + 3 * sizeof(int)) = NumOfKeys;
				if (father < 0 && NumOfKeys == 1)  // N是根节点且只剩一个子节点
				{
					if (lp == p) {
						int buffernum = bf.GiveMeABlock(name, rp);
						::memcpy(bf.bufferBlock[buffernum].values, currentBlock, BLOCKSIZE);
					} else {
						int buffernum = bf.GiveMeABlock(name, lp);
						::memcpy(bf.bufferBlock[buffernum].values, currentBlock, BLOCKSIZE);
					}
					CHAR2INT(currentBlock + 2 * sizeof(int)) == -1;
					Number--;
				} else if (NumOfKeys < maxchild / 2)  //值太少
				{
					char* parent = new char[BLOCKSIZE];
					int buffernum = bf.GiveMeABlock(name, CHAR2INT(currentBlock + 2 * sizeof(int)));
					::memcpy(bf.bufferBlock[buffernum].values, parent, BLOCKSIZE);
					char* newleaf = new char[BLOCKSIZE];
					buffernum = bf.GiveMeABlock(name, bro);
					::memcpy(bf.bufferBlock[buffernum].values, newleaf, BLOCKSIZE);
					int newleafnum = CHAR2INT(newleaf + 3 * sizeof(int));
					string x = *(string*)(newleaf + INFORMATION + newleafnum * (keylength[type] + POINTERLENGTH));
					// Data* nkey;
					//(*(Datac*)nkey).x = x;
					Datac nkey(x);
					int np = CHAR2INT(newleaf + INFORMATION + newleafnum * (keylength[type] + POINTERLENGTH) + keylength[type] + sizeof(int));
					if (newleafnum + NumOfKeys < maxchild)	//可以合并
					{
						CHAR2INT(newleaf + 2 * sizeof(int)) = newleafnum + NumOfKeys;
						::memcpy(newleaf + INFORMATION + (newleafnum + 1) * (keylength[type] + POINTERLENGTH), currentBlock + INFORMATION + (keylength[type] + POINTERLENGTH),
								 NumOfKeys * (keylength[type] + POINTERLENGTH));
						CHAR2INT(newleaf + INFORMATION + (newleafnum + 1) * (keylength[type] + POINTERLENGTH) + keylength[type]) = newleafnum;
					}
					delete_entry(parent, &nkey, np);
				} else	//从后面借一个索引项
				{
					char* newleaf = new char[BLOCKSIZE];
					int buffernum = bf.GiveMeABlock(name, bro);
					::memcpy(bf.bufferBlock[buffernum].values, newleaf, BLOCKSIZE);
					int newleafnum = CHAR2INT(newleaf + 3 * sizeof(int));
					CHAR2INT(newleaf + INFORMATION + (newleafnum - 1) * (keylength[type] + POINTERLENGTH) + keylength[type]) = -1;
					CHAR2INT(newleaf + INFORMATION + newleafnum * (keylength[type] + POINTERLENGTH) + keylength[type] + 4 * sizeof(int)) = 1;  // delete
					char temp[BLOCKSIZE];
					::memcpy(temp, currentBlock + INFORMATION + keylength[type] + POINTERLENGTH, NumOfKeys * (keylength[type] + POINTERLENGTH));
					::memcpy(currentBlock + INFORMATION + keylength[type] + POINTERLENGTH, newleaf + INFORMATION + newleafnum * (keylength[type] + POINTERLENGTH), keylength[type] + POINTERLENGTH);
					::memcpy(currentBlock + INFORMATION + 2 * keylength[type] + 2 * POINTERLENGTH, temp, NumOfKeys * (keylength[type] + POINTERLENGTH));
					CHAR2INT(currentBlock + 3 * sizeof(int)) = NumOfKeys + 1;
					char* parent = new char[BLOCKSIZE];
					buffernum = bf.GiveMeABlock(name, CHAR2INT(currentBlock + 2 * sizeof(int)));
					::memcpy(bf.bufferBlock[buffernum].values, parent, BLOCKSIZE);
					string x = *(string*)(newleaf + INFORMATION + newleafnum * (keylength[type] + POINTERLENGTH));
					int p = CHAR2INT(newleaf + INFORMATION + newleafnum * (keylength[type] + POINTERLENGTH) + keylength[type]);
					*(string*)(parent + INFORMATION + keylength[type] + POINTERLENGTH) = x;
					CHAR2INT(parent + INFORMATION + 2 * keylength[type] + POINTERLENGTH) = p;
				}
			} else {
				throw TableException("Wrong delete!");
			}
		}
	}
}

int* index::Range(Data* key1, Data* key2) {
	char* currentBlock = new char[BLOCKSIZE];

	int* re = new int[1000];
	re[0] = -1;
	int buffernum = bf.GiveMeABlock(name, 0);
	bf.useBlock(buffernum);
	memcpy(currentBlock, bf.bufferBlock[buffernum].values, BLOCKSIZE);
	// readbuffer;
	int LeafType = *(int*)(currentBlock);
	int Brother = *(int*)(currentBlock + INFORMATION + keylength[type]);
	int tempBro, position;

	while (LeafType == Internal) {
		int NumOfKeys = *(int*)(currentBlock + 12);
		int i = 0;

		for (i = 0; i < NumOfKeys; i++) {
			if (type == 0) {
				int NowKey = *(int*)(currentBlock + INFORMATION + Brother * (keylength[type] + POINTERLENGTH));
				tempBro = Brother;
				position = *(int*)(currentBlock + INFORMATION + Brother * (keylength[type] + POINTERLENGTH) + keylength[type] + 4);
				Brother = *(int*)(currentBlock + INFORMATION + Brother * (keylength[type] + POINTERLENGTH) + keylength[type]);
				if ((((Datai*)key1)->x < NowKey)) break;
			} else if (type == 1) {
				float NowKey = *(float*)(currentBlock + INFORMATION + Brother * (keylength[type] + POINTERLENGTH));
				tempBro = Brother;
				position = *(int*)(currentBlock + INFORMATION + Brother * (keylength[type] + POINTERLENGTH) + keylength[type] + 4);
				Brother = *(int*)(currentBlock + INFORMATION + Brother * (keylength[type] + POINTERLENGTH) + keylength[type]);
				if ((((Dataf*)key1)->x < NowKey)) break;
			} else {
				string NowKey((char*)(currentBlock + INFORMATION + Brother * (keylength[type] + POINTERLENGTH)));
				tempBro = Brother;
				position = *(int*)(currentBlock + INFORMATION + Brother * (keylength[type] + POINTERLENGTH) + keylength[type] + 4);
				Brother = *(int*)(currentBlock + INFORMATION + Brother * (keylength[type] + POINTERLENGTH) + keylength[type]);
				if ((((Datac*)key1)->x.compare(NowKey)) < 0) break;
			}
		}
		if (i == NumOfKeys) position = *(int*)(currentBlock + INFORMATION + tempBro * (keylength[type] + POINTERLENGTH) + keylength[type] + 12);
		if (position == -1) {
			return re;
		}
		int buffernum = bf.GiveMeABlock(name, position);
		bf.useBlock(buffernum);
		memcpy(currentBlock, bf.bufferBlock[buffernum].values, BLOCKSIZE);
		LeafType = *(int*)(currentBlock);
		Brother = *(int*)(currentBlock + INFORMATION + keylength[type]);
		// readbuffer
	}
	int NumOfKeys = *(int*)(currentBlock + 12);
	Brother = *(int*)(currentBlock + INFORMATION + keylength[type]);
	for (int i = 0; i < NumOfKeys; i++) {
		if (type == 0) {
			int NowKey = *(int*)(currentBlock + INFORMATION + Brother * (keylength[type] + POINTERLENGTH));
			tempBro = Brother;
			int Addr = *(int*)(currentBlock + INFORMATION + Brother * (keylength[type] + POINTERLENGTH) + keylength[type] + 4);
			position = *(int*)(currentBlock + INFORMATION + Brother * (keylength[type] + POINTERLENGTH) + keylength[type] + 4);
			Brother = *(int*)(currentBlock + INFORMATION + Brother * (keylength[type] + POINTERLENGTH) + keylength[type]);
			if ((((Datai*)key1)->x == NowKey) && *(int*)(currentBlock + INFORMATION + Brother * (keylength[type] + POINTERLENGTH) + keylength[type] + 16) != 1) {
				int j = 0;
				while (Brother != -1 && NowKey <= ((Datai*)key2)->x) {
					re[j++] = Addr;
					Brother = *(int*)(currentBlock + INFORMATION + Brother * (keylength[type] + POINTERLENGTH) + keylength[type]);
					NowKey = *(int*)(currentBlock + INFORMATION + Brother * (keylength[type] + POINTERLENGTH));
					Addr = *(int*)(currentBlock + INFORMATION + Brother * (keylength[type] + POINTERLENGTH) + keylength[type] + 4);
				}
				re[j] = -1;
				delete[] currentBlock;
				return re;
			}
		} else if (type == 1) {
			float NowKey = *(float*)(currentBlock + INFORMATION + Brother * (keylength[type] + POINTERLENGTH));
			tempBro = Brother;
			int Addr = *(int*)(currentBlock + INFORMATION + Brother * (keylength[type] + POINTERLENGTH) + keylength[type] + 4);
			position = *(int*)(currentBlock + INFORMATION + Brother * (keylength[type] + POINTERLENGTH) + keylength[type] + 4);
			Brother = *(int*)(currentBlock + INFORMATION + Brother * (keylength[type] + POINTERLENGTH) + keylength[type]);
			if ((((Dataf*)key1)->x == NowKey) && *(int*)(currentBlock + INFORMATION + Brother * (keylength[type] + POINTERLENGTH) + keylength[type] + 16) != 1) {
				int j = 0;
				while (Brother != -1 && NowKey <= ((Dataf*)key2)->x) {
					re[j++] = Addr;
					Brother = *(int*)(currentBlock + INFORMATION + Brother * (keylength[type] + POINTERLENGTH) + keylength[type]);
					NowKey = *(int*)(currentBlock + INFORMATION + Brother * (keylength[type] + POINTERLENGTH));
					Addr = *(int*)(currentBlock + INFORMATION + Brother * (keylength[type] + POINTERLENGTH) + keylength[type] + 4);
				}
				re[j] = -1;
				delete[] currentBlock;
				return re;
			}
		} else {
			string NowKey((char*)(currentBlock + INFORMATION + Brother * (keylength[type] + POINTERLENGTH)));
			tempBro = Brother;
			int Addr = *(int*)(currentBlock + INFORMATION + Brother * (keylength[type] + POINTERLENGTH) + keylength[type] + 4);
			position = *(int*)(currentBlock + INFORMATION + Brother * (keylength[type] + POINTERLENGTH) + keylength[type] + 4);
			Brother = *(int*)(currentBlock + INFORMATION + Brother * (keylength[type] + POINTERLENGTH) + keylength[type]);
			if ((((Datac*)key1)->x.compare(NowKey)) == 0 && *(int*)(currentBlock + INFORMATION + Brother * (keylength[type] + POINTERLENGTH) + keylength[type] + 16) != 1) {
				int j = 0;
				while (Brother != -1 && (((Datac*)key2)->x.compare(NowKey)) >= 0) {
					re[j++] = Addr;
					Brother = *(int*)(currentBlock + INFORMATION + Brother * (keylength[type] + POINTERLENGTH) + keylength[type]);
					NowKey = *(int*)(currentBlock + INFORMATION + Brother * (keylength[type] + POINTERLENGTH));
					Addr = *(int*)(currentBlock + INFORMATION + Brother * (keylength[type] + POINTERLENGTH) + keylength[type] + 4);
				}
				re[j] = -1;
				delete[] currentBlock;
				return re;
			}
		}
	}
	return re;
	delete[] currentBlock;
}
