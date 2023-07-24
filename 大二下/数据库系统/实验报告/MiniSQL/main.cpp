#include <iostream>
#include <string>
#include <ctime>
#include <map>
#include "API.h"
#include "BufferManager.h"
#include "Interpreter.h"
#include "RecordManager.h"
using namespace std;

BufferManager bf;
extern int Number;
int main() {
	remove("Table_Definition");
	remove("student2.table");
	remove("student20.index");
	remove("student21.index");
	remove("stunameidx.index");
	///freopen("student3.txt", "r", stdin);
	int re = 1;
	InterManager itp;
	cout << "Welcome to MiniSQL!" << endl;
	// itp.GetQs();
	// re = itp.EXEC();
	//int i = 0;
	clock_t begin, end;
	begin = clock();
	while (re) {
		try {
			cout << ">>>";
			itp.getQueryString();
			re = itp.Exec();
		} catch (TableException te) {
			cout << te.what() << endl;
		} catch (QueryException qe) {
			cout << qe.what() << endl;
		}
		end = clock();
		cout << "runtime: " << (double)(end - begin) / CLOCKS_PER_SEC << "s" << endl;
	}
	return 0;
}
