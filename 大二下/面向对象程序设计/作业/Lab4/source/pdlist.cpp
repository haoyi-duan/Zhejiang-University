#include "diary.h"
#include "diary.cpp"

int main()
{
	vector<diary> diariesOld;
	readFile("personal_diary.txt", diariesOld); //Read the diary and store the information in vector<diary> diariesOld.
	
	freopen("pdlist_test1.txt", "r", stdin); //stdin<-pdlist_test1.txt
	string date1, date2;
	getline(cin, date1);
	if (!date1.empty()) //If date1 is not empty, read date2, and search the entities between date1 and date2.
	{
		getline(cin, date2);
		diariesOld = serchDiaries(date1, date2, diariesOld);
	}
	writeFile("pdlist_out.txt", diariesOld);
	return 0;
}