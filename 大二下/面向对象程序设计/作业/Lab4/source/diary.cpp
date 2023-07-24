#include "diary.h"

void diary::setDate(string inputDate)
{
	date = inputDate;
}

void diary::writeLine(string line)
{
	text.push_back(line);
}

string diary::getDate()
{
	return date;
}

bool diary::operator>(diary& c) //Reload of ">".
{
	return this->date > c.date;
}

bool diary::operator<(diary& c)
{
	return c > *this; //Use reload of ">".
}

void diary::clearText()
{
	text.clear();
}

vector<string> diary::getText()
{
	return text;
}

void readFile(string fileName, vector<diary> &temp_diaries)
{
	diary temp;
	string line;
	freopen(fileName.c_str(), "r", stdin); //stdin<-filename.c_str().
	
	while (getline(cin, line))
	{
		temp.setDate(line);
		temp.clearText();
		getline(cin, line);
		while (line != ".")
		{
			temp.writeLine(line);
			getline(cin, line);
		}
		temp_diaries.push_back(temp);
	}
	fclose(stdin);
	cin.clear(); //clear the stdin and avoid the program crashes.
}

vector<diary> setNewDiaries(vector<diary> &A, vector<diary> &B)
{ //Merge A and B with increasing order.
	vector<diary> temp;
	unsigned int iA, iB;
	for (iA = 0, iB = 0; iA < A.size() && iB < B.size(); )
	{
		if (A[iA].getDate() < B[iB].getDate()) temp.push_back(A[iA++]);
		else if (A[iA].getDate() > B[iB].getDate()) temp.push_back(B[iB++]);
		else 
		{ //If date(A) = date(B), add B to the new diary.
		  //(If an entity of the same date is in the diary, the existing one will be replaced.)
			temp.push_back(B[iB++]);
			iA++;
		}
	}
	//Push the remaining entities into the new diary.
	while (iA < A.size()) temp.push_back(A[iA++]);
	while (iB < B.size()) temp.push_back(B[iB++]);
	return temp;
}

void writeFile(string fileName, vector<diary> &temp_diaries)
{ //Write the diaries in the file, one by one.
	freopen(fileName.c_str(), "w", stdout);
	for (int i = 0; i < temp_diaries.size(); i++)
	{
		cout << temp_diaries[i].getDate() << endl;
		for (int j = 0; j < temp_diaries[i].getText().size(); j++)
			cout << temp_diaries[i].getText()[j] << endl;
		cout << "." << endl;
	}
	fclose(stdout);
	cout.clear();
}

vector<diary> serchDiaries(string date1, string date2, vector<diary> &diariesOld)
{
	vector<diary> temp;
 	for (int i = 0; i < diariesOld.size(); i++)
	{ //Push the diaries between date1 and date2.
		if (diariesOld[i].getDate() >= date1 && diariesOld[i].getDate() <= date2) temp.push_back(diariesOld[i]);
		else if (diariesOld[i].getDate() > date2) break;
	}
	return temp;
}