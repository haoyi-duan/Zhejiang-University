#include <iostream>
#include <cstdlib>
#include <fstream>
#include <vector>
#include <iomanip>
#include "Student.h"

using namespace std;

/*
The vector is used to store the name of the courses. 
*/
vector<string> courseList;

/*
The vector below is used to store the max, min, and the average score of each course.
*/
vector<double> average;
vector<int> number;
vector<int> max;
vector<int> min;

/*
The function is used to devide the string into pieces,
including the name of the student, the number of the courses
that the student has taken, the name of the courses,
and the score the student has got.
*/
vector<string> DevideString(string str);

/*
This function is used to insert new course record to the vector "courseList".
*/
void InsertString(string courseName, int courseScore);

int main()
{
	int numOfCourses, cnt = 0;
	vector<student> stu;
	string s;
	vector<string> record;

	/*
	Open "data.txt" which store the information that a CLI programm needs.
	*/
	ifstream fin;
	fin.open("data.txt");
	if (!fin.is_open()) {
		cout << "error opening file input" << endl;
		exit(1);
	}

	/*
	Get each line of the "data.txt" and store the data into the right place.
	*/
	while (getline(fin, s))
	{
		student oneStudent;
		record = DevideString(s);
		oneStudent.SetNum(cnt + 1);
		oneStudent.SetName(record[0]);
		numOfCourses = record[1][0] - '0';
		for (int i = 0; i < numOfCourses; i++)
		{
			oneStudent.SetCourse(record[2 + 2*i], record[3 + 2*i][0]-'0');
			InsertString(record[2 + 2*i], record[3 + 2*i][0]-'0');
		}
		stu.push_back(oneStudent);
		cnt++;
	}
	fin.close();
	
	/*
	Output the result. 
	First we need to print out the heaedline.
	*/
	cout << left;
	cout << setw(10) << "no" << setw(8) << "name";
	for (int i = 0; i < courseList.size(); i++)
		cout << setw(10) << courseList[i];
	cout << setw(10) << "average" << endl;
	
	/*
	After that, we need to print out the information of each student.
	*/
	for (int i = 0; i < stu.size(); i++)
	{
		cout << setw(10) << i + 1 << setw(10) << stu[i].GetName();
		stu[i].print(courseList);
	}

	/*
	Last, wew need to print out the average, min, and max of each course.
	*/
	cout << setw(10) << ' ' << setw(10) << "average";
	for (int i = 0; i < courseList.size(); i++)
		cout << setw(10) << setprecision(2) << average[i] / number[i];
	cout << endl;
	cout << setw(10) << ' ' << setw(10) << "min";
	for (int i = 0; i < courseList.size(); i++)
		cout << setw(10) << min[i];
	cout << endl;
	cout << setw(10) << ' ' << setw(10) << "max";
	for (int i = 0; i < courseList.size(); i++)
		cout << setw(10) << max[i];
	cout << endl;

	system("pause");
	return 0;
}

vector<string> DevideString(string str)
{
	vector<string> record;
	string tmp = "";
	int flag = 0;
	for (int i = 0; i < str.length(); i++)
	{
		if (str[i] == ' ' && !flag)
		{
			record.push_back(tmp);
			tmp = "";
			flag = 1;
		}
		else if (str[i] != ' ')
		{
			tmp += str[i];
			flag = 0;
		}
	}
	if (tmp != "") record.push_back(tmp);
	return record;
}

void InsertString(string courseName, int courseScore)
{
	int flag = 0, i;
	for (i = 0; i < courseList.size(); i++)
	{
		if (courseName == courseList[i])
		{
			flag = 1;
			break;
		}
	}
	if (!flag)
	{
		courseList.push_back(courseName);
		max.push_back(courseScore);
		min.push_back(courseScore);
		average.push_back(courseScore);
		number.push_back(1);
	}
	else
	{
		if (max[i] < courseScore) max[i] = courseScore;
		if (min[i] > courseScore) min[i] = courseScore;
		average[i] += courseScore;
		number[i]++;
 	}
}