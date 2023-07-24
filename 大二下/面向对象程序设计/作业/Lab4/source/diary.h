#ifndef DIARY_H
#define DIARY_H
#include <iostream>
#include <string>
#include <fstream>
#include <vector>
#include <algorithm>
#include <stdio.h>
using namespace std;

class diary //Class diary is used to store the information of each diary.
{
private:
	string date; //Store the date of the entity.
	vector<string> text; //Store the text of the entity.
public:
	void setDate(string inputDate);
	void writeLine(string line);
	void clearText();
	string getDate();
	vector<string> getText();
	bool operator>(diary& c);
	bool operator<(diary& c);
};

void readFile(string fileName, vector<diary> &temp_diaries); //Read the file and the store the information of the diaries in vector<diary> &temp_diaries.
vector<diary> setNewDiaries(vector<diary> &A, vector<diary> &B); //Merge the two vector<diary> &A and &B together.
void writeFile(string fileName, vector<diary> &temp_diaries); //Write the result in the vector<diary> &temp_diaries in the file with filName.
vector<diary> serchDiaries(string date1, string date2, vector<diary> &diariesOld); //Search the entities between date1 and date2.
#endif //DIARY_H