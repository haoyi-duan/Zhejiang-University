#include "diary.h"
#include "diary.cpp"

int main()
{	
	vector<diary> diaries, diariesTemp;
	readFile("personal_diary.txt", diaries); //Read the diary and store the information in vector<diary> didaries.
	readFile("pdadd_test1.txt", diariesTemp); //Read the diary to be added and store in vector<diary> diariesTemp.
	sort(diariesTemp.begin(), diariesTemp.end()); //Sort the diariesTemp by date.
	diaries = setNewDiaries(diaries, diariesTemp); //Merge the diaries and diariesTemp together, result is stored in diaries.
	writeFile("personal_diary.txt", diaries); //Write the new diary in the file "personal_diary.txt", with new entities added.
	return 0;
}
