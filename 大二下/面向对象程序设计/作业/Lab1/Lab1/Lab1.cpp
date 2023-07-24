#include <iostream>
#include <cstdlib>
#include <fstream>
#include <iomanip>

using namespace std;

/*
The data structrue that is used 
to store the data of each student.
*/
struct data {
	int score1, score2, score3;
	char name[10];
}student[10];

int main()
{
	/*
	The integer num is used to store the number of the student 
	in the data.txt, whitch is not useful in the later print operation, though.
	*/
	int num;

	/*
	Create the file pointer named "fin", 
	whitch will then point to "data.txt".
	*/
	ifstream fin;
	fin.open("data.txt");
	/*
	To check whether the file is opened successfully.
	*/
	if (!fin.is_open()) {
		cout << "Error opening file input" << endl;
		exit(1);
	}
	int i = 0;
	/*
	While the file is not in the end,
	read the file "data.txt" and store 
	relavant infomation in the data structrue.
	*/
	while (!fin.eof())
	{
		fin >> num >> student[i].name >> student[i].score1 
			>> student[i].score2 >> student[i].score3;
		i++;
		if (i == 10)
			break;
	}
	/*
	Read process is over, now it's time to close the file
	in order to free memory space.
	*/
	fin.close();
	/*
	Define some integers for later use.
	*/
	double average1 = 0, average2 = 0, average3 = 0;
	int min1 = student[0].score1, min2 = student[0].score2, min3 = student[0].score3;
	int max1 = student[0].score1, max2 = student[0].score2, max3 = student[0].score3;
	/*
	Caculate the average, min, and max.
	*/
	for (int i = 0; i < 10; i++)
	{
		average1 += student[i].score1;
		average2 += student[i].score2;
		average3 += student[i].score3;
		if (i)
		{
			if (student[i].score1 < min1)
				min1 = student[i].score1;
			if (student[i].score2 < min2)
				min2 = student[i].score2;
			if (student[i].score3 < min3)
				min3 = student[i].score3;
			if (student[i].score1 > max1)
				max1 = student[i].score1;
			if (student[i].score2 > max2)
				max2 = student[i].score2;
			if (student[i].score3 > max3)
				max3 = student[i].score3;
		}
	}
	average1 /= 10.0;
	average2 /= 10.0;
	average3 /= 10.0;

	/*
	Print the result in the right format.
	*/
	cout << left;
	cout << setw(8) << "no" << setw(8) << "name" << setw(8) << "score1" <<
		setw(8) << "score2" << setw(8) << "score3" << setw(8) << "average" << endl;
	for (int i = 0; i < 10; i++)
	{
		cout << setw(8) << i+1 << setw(8) << student[i].name << setw(8) << student[i].score1 <<
			setw(8) << student[i].score2 << setw(8) << student[i].score3 
			<< setw(8) << (student[i].score1 + student[i].score2 + student[i].score3) / 3.0 << endl;
	}

	cout << setw(8) << ' ' << setw(8) << "average" << setw(8) << setprecision(2) << average1 << setw(8) << average2 << setw(8) << average3 << endl;
	cout << setw(8) << ' ' << setw(8) << "min" << setw(8) << min1 << setw(8) << min2 << setw(8) << min3 << endl;
	cout << setw(8) << ' ' << setw(8) << "max" << setw(8) << max1 << setw(8) << max2 << setw(8) << max3 << endl;

	system("pause");
	return 0;
}