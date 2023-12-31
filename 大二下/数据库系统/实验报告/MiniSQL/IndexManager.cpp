
#include"IndexManager.h"


void IndexManager::Establish(string file)
{
	index i(file);
}

void IndexManager::Insert(const string &file, Data *key, int Addr)
{
	index i(file);
	if (i.Number == 0)
	{
		int ktype;
		if (key->flag == -1)
			ktype = 0;
		else if (key->flag == 0)
			ktype = 1;
		else ktype = 2;
		i.initialize(key, Addr, ktype);
	}
	else
	{
		i.insert(key, Addr);
	}
}

void IndexManager::Delete(string file, Data* key)
{
	fstream _file;
	_file.open(file, ios::in);

	if (!_file) {
		return;
	} else {
	//index i(file);
	//static int cnt=0;
	// if (i.Number == 0)
	// {
	// 	//throw TableException("The index is empty!");
	// }
	// else
	// {
	// 	if(i.find(key)!=-1){
	// 		i.Delete(key);
	// 		cnt++;
	// 		if (i.find(key)!=-1)
	// 		{
	// 			cout<<"problem"<<endl;
	// 		}
	// 		else
	// 			cout<<"success"<<cnt<<endl;
	// 	}
	// }
	}
}

int IndexManager::Find(string file, Data* key)
{
	index i(file);
	int re;
	if (i.Number == 0)
	{
		return -1;
		
	}
	else
	{
		re = i.find(key);
	}
	return re;
}

void IndexManager::Drop(string file)
{
	remove(file.c_str());
}
int* IndexManager::Range(string file, Data* key1, Data* key2)
{
	index i(file);
	int* re;
	if (i.Number == 0)
	{
		return NULL;
	}
	else
	{
		re = i.Range(key1, key2);
	}
	return re;
}