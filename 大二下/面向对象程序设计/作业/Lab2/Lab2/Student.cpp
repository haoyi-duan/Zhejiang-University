#include <iostream>
#include <string>
#include <vector>
#include <cstdlib>
#include <fstream>
#include <iomanip>
#include "Student.h"

using namespace std;

/*
Set the name of the class student.
*/
void student::SetName(string inputName)
{
	name = inputName;
}

/*
Set the num of the student.
*/
void student::SetNum(int inputNum)
{
	num = inputNum;
}

/*
Set a structure course to the vector courses.
*/
void student::SetCourse(string inputCourseName, int innputCourseScore)
{
	course course;
	course.courseName = inputCourseName;
	course.courseScore = innputCourseScore;
	courses.push_back(course);
}

/*
Get the name of the student.
*/
string student::GetName(void)
{
	return name;
}

/*
Get the average score of the student.
*/
double student::GetAverage(void)
{
	int sum = 0;
	for (unsigned int i = 0; i < courses.size(); i++)
		sum += courses[i].courseScore;
	return (1.0*sum) / courses.size();
}

/*
Print the result of each student.
*/
void student::print(vector<string> courseList)
{
	int flag, index;
	for (int i = 0; i < courseList.size(); i++)
	{
		for (int j = 0; j < courses.size(); j++)
		{
			flag = 0;
			if (courseList[i] == courses[j].courseName)
			{
				flag = 1;
				index = j;
				break;
			}
		}
		if (flag) cout << setw(10) << courses[index].courseScore;
		else cout << setw(10) << "*";
	}
	cout << setw(10) << GetAverage() << endl;
}