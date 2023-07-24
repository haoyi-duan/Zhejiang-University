#ifndef STUDENT_H
#define STUDENT_H
#include <vector>
#include <cstdlib>
#include <fstream>
#include <iomanip>
#include <string>

using namespace std;

/*
Class student is used to store the information of each student,
and it also can do some of the output.
*/
class student
{
public:
	void SetName(string inputName);
	void SetNum(int inputNum);
	void SetCourse(string inputCourseName, int inputCourseScore);
	string GetName(void);
	double GetAverage(void);
	void print(vector<string> courseList);
private:
	int num;
	string name;
	struct course
	{
		string courseName;
		int courseScore;
	};
	vector<course> courses;
	double average;
};

#endif // STUDENT_H
