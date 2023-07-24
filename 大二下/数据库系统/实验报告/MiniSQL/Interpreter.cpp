#include "Interpreter.h"
#include "base.h"
#include "Catalog.h"
#include "API.h"
#include<string>
#include <map>

using namespace std;

static map <string, bool > answer;  

map <string, bool> tablelist;
static int t = 0;

void InterManager::getQueryString()
{
    string line;
    qs = "";
    do {
        getline(cin, line);
        qs = qs  + " " + line;
    } while (qs[qs.length() - 1] != ';');
}

void InterManager::normolize()
{
    for (int i = 0; i < qs.length(); i++)
        if (isCharacter(qs[i]))
        {
            if (qs[i-1] != ' ') qs.insert(i++, " ");
            if (qs[i+1] != ' ') qs.insert(++i, " ");
        }

    bool flag = false;
    string::iterator it;
    for(it=qs.begin(); it<qs.end(); it++){
        if(!flag && *it==' ')
        {
            flag = true;
            continue;
        }
        if(flag && *it==' '){
            qs.erase(it);
            if(it!=qs.begin())
                it--;
            continue;
        }
        if(*it != ' ')
            flag = false;
    }
    
    for(string::iterator it = qs.begin(); it < qs.end() && *it == ' '; it++)
        qs.erase(it);
        
    for(string::iterator it = qs.end(); it > qs.begin() && *it == ' '; it--)
        qs.erase(it);      
}

bool InterManager::Exec()
{
    normolize();
    int pos = readElement(0);
    string str = qs.substr(0, pos);
    if (str == "drop")
    {
        ExecDrop();
        cout << "Interpreter: successful drop!" << endl;
        return true;
    }
    else if (str == "quit")
    {
        ExecQuit();
        return false;
    }
    else if (str == "select")
    {
        ExecSelect();
        cout << "Interpreter: successful select!" << endl;
        return true;
    }
    else if (str == "insert")
    {
        ExecInsert();
        cout << t++ << " Interpreter: successful insert!" << endl;
        return true;
    }
    else if (str == "create")
    {
        ExecCreate();
        cout << "Interpreter: successful create!" << endl;
        return true;
    }
    else if (str == "delete")
    {
        ExecDelete();
        cout << "Interpreter: successful delete!" << endl;
        return true;
    }
    else if (str == "execfile")
    {
        ExecFile();
        cout << "Interpreter: successful execfile!" << endl;
        return true;
    }
    else throw QueryException("ERROR:, invalid query syntax!");
}

void InterManager::ExecDrop()
{
    int pos = 4, pos1;
    string tmp;
    while (qs[pos] == ' ') pos++;
    CataManager cm;
    pos1 = readElement(pos);
	
    if (qs.substr(pos, pos1-pos) == "table")
    {
        pos = pos1;
        while (qs[pos] == ' ') pos++;
        pos1 = readElement(pos);
        string tableName = qs.substr(pos, pos1-pos);

        pos = pos1;
        while (qs[pos] == ' ') pos++;
        pos1 = readElement(pos);
        tmp = qs.substr(pos, pos1-pos);
        if (tmp != ";")
            throw QueryException("ERROR: invalid query syntax!");

        Table* t = cm.getTable(tableName);
        if (t->index.num > 0)
            for (int j = 0; j < t->index.num; j++) cm.drop_index(tableName, t->index.indexname[j]);
        delete t;
        cm.drop_table(tableName);
		answer[tableName] = 0;
		tablelist[tableName] = 0;
    }

    else if (qs.substr(pos, pos1-pos) == "index")
    {
        pos = pos1;
        while (qs[pos] == ' ') pos++;
        pos1 = readElement(pos);
        string tmpIndex = qs.substr(pos, pos1-pos);
		
		string fname = tmpIndex + ".index";
		ifstream in(fname);
		if (!in)
			throw QueryException("No index named " + tmpIndex);
        
		pos = pos1;
        while (qs[pos] == ' ') pos++;
        pos1 = readElement(pos);
        tmp = qs.substr(pos, pos1-pos);
        if (tmp != "on")
            throw QueryException("ERROR: invalid query syntax!");
        
        pos = pos1;
        while (qs[pos] == ' ') pos++;
        pos1 = readElement(pos);
        string tmpTable = qs.substr(pos, pos1-pos);
        
        pos = pos1;
        while (qs[pos] == ' ') pos++;
        pos1 = readElement(pos);
        tmp = qs.substr(pos, pos1-pos);
        if (tmp != ";")
            throw QueryException("ERROR: invalid query syntax!");
        cm.drop_index(tmpTable, tmpIndex);
    }
    else throw QueryException("ERROR: invalid query syntax!");
}

void InterManager::ExecSelect()
{
	CataManager cm;
	int pos = 6;
	vector<int> attrSelect;//the index of selected attributes
	vector<int> attrWhere;//the index of where attributes
	vector<where> w;
    while (qs[pos] == ' ') pos++;
	int pos1 = readElement(pos);
    string tmp = qs.substr(pos, pos1-pos);
    
    bool selectAll = false;
    bool isAttribute = true;
    bool isRestraint = false;
    vector<string> attribute;
    string tableName;

    if (tmp == "*")
        selectAll = true;
    else 
    {
        while (qs.substr(pos, pos1-pos) != "from")
        {
            if (isAttribute) 
            {
                attribute.push_back(qs.substr(pos, pos1-pos));
				isAttribute = false;
            }
            else 
            {
                if (qs.substr(pos, pos1-pos) != ",")
                {
                    if (qs.substr(pos, pos1-pos) == "from") break;
                    else throw QueryException("ERROR: invalid query syntax!");
                }
				isAttribute = true;
            }
            pos = pos1;
            while (qs[pos] == ' ') pos++;
            pos1 = readElement(pos);
        }
    }
    

    pos = pos1;
    while(qs[pos] == ' ') pos++;
    pos1 = readElement(pos);
    if (selectAll)
	{
		if (qs.substr(pos, pos1-pos) != "from")
			throw QueryException("ERROR: invalid syntax syntax!");
		pos = pos1;
		while (qs[pos] == ' ') pos++;
		pos1 = readElement(pos);
	}
	tableName = qs.substr(pos, pos1-pos);
	Table* t = cm.getTable(tableName);
    
    pos = pos1;
    while(qs[pos] == ' ') pos++;
    pos1 = readElement(pos);

	if (selectAll) for (int i = 0; i < t->attr.num; i++) attrSelect.push_back(i);
    else {
		for (int i = 0; i < attribute.size(); i++)
		{
			string tmp = attribute[i];
			bool flag = false;
			for (int j = 0; j < t->attr.num; j++)
			{
				if (tmp == t->attr.name[j])
				{
					flag = true;
					attrSelect.push_back(j);
					break;
				}			
			}
			if (!flag) throw QueryException("No attribute named " + tmp + "!");
		}
    }

	bool selectOr = false;
   	if (qs.substr(pos, pos1-pos) != ";")  
   	{
        tmp = qs.substr(pos, pos1-pos);
        if (tmp != "where") 
            throw QueryException("ERROR: invalid query syntax!");
		pos = pos1;
		while (qs[pos] == ' ') pos++;
		interWhere(pos, attrWhere, w, t->attr, t, selectOr);
    }

	API api;
	if (answer[tableName] == 0)
	{
		for(auto i = 0; i < (*t).attr.num; i++)
        	std::cout << (*t).attr.name[i] << "\t";
			cout << endl;
	}
	else 
	{
		//t->blockNum = 1;
		if (selectOr == false)
		{
			Table output = api.Select(*t, attrSelect, attrWhere, w);
			output.disp();
		}
		else
		{	
			vector<int> attrWhere1, attrWhere2;//the index of where attributes
			vector<where> w1, w2;
			attrWhere1.push_back(attrWhere[0]);
			w1.push_back(w[0]);

			attrWhere2.push_back(attrWhere[1]);
			w2.push_back(w[1]);
			
			Table output1 = api.Select(*t, attrSelect, attrWhere1, w1);
			output1.disp();
			Table output2 = api.Select(*t, attrSelect, attrWhere2, w2);
			output2.dispNo();
		}
	}

}

void InterManager::ExecQuit()
{
	;
}

//when pos1 is point to the space after "where".
void InterManager::interWhere(int& pos1, vector<int> &attrwhere, vector<where> &w, Attribute A, Table* t, bool& selectOr)
{
	int flag = 0;
	int x = 0;
	float y = 0;
	string z;
	Data* m;

	int pos = pos1;
	while (qs[pos] == ' ') pos++;
	pos1 = readElement(pos);
	string temp0;
	int j;
	where temp;
	while (1) {
		temp0 = qs.substr(pos, pos1 - pos);
		for (j = 0; j < t->attr.num; j++)
			if (A.name[j] == temp0) {
				flag = A.flag[j];
				attrwhere.push_back(j);
				break;
			}
		
		if (j == t->attr.num)
			throw QueryException("No attribute named " + temp0);
		pos = pos1;
		while (qs[pos] == ' ') pos++;
		pos1 = readElement(pos);

		if (qs.substr(pos, pos1 - pos) == "=") {
			temp.flag = eq;
			pos = pos1;
			while (qs[pos] == ' ') pos++;
			pos1 = readElement(pos);
			temp0 = qs.substr(pos, pos1 - pos);

			if (flag == -1 && toInt(temp0, x)) {
				m = new Datai(x);
				temp.d = m;
				w.push_back(temp);
			}

			else if (flag == 0 && toFloat(temp0, y)) {
				m = new Dataf(y);
				temp.d = m;
				w.push_back(temp);
			}

			else if (flag > 0 && ((temp0[0] == '\'' && temp0[temp0.length() - 1] == '\'') || (temp0[0] == '\"' && temp0[temp0.length() - 1] == '\"'))  && temp0.length() - 2 <= flag)
			{
				m = new Datac(temp0.substr(1, temp0.length() - 2));
				temp.d = m;
				w.push_back(temp);
			}
			else throw QueryException("ERROR: Values in where clause is invalid!");

		}
		else if (qs.substr(pos, pos1 - pos) == ">") {
			temp.flag = g;
			pos = pos1;
			while (qs[pos] == ' ') pos++;
			pos1 = readElement(pos);
			temp0 = qs.substr(pos, pos1 - pos);

			if (temp0 == "=") {
				temp.flag = geq;
				pos = pos1;
				while (qs[pos] == ' ') pos++;
				pos1 = readElement(pos);
				temp0 = qs.substr(pos, pos1 - pos);
			}

			if (flag == -1 && toInt(temp0, x)) {
				m = new Datai(x);
				temp.d = m;
				w.push_back(temp);
			}

			else if (flag == 0 && toFloat(temp0, y)) {
				m = new Dataf(y);
				temp.d = m;
				w.push_back(temp);
			}

			else if (flag > 0 && ((temp0[0] == '\'' && temp0[temp0.length() - 1] == '\'') || (temp0[0] == '\"' && temp0[temp0.length() - 1] == '\"')) && temp0.length() - 2 <= flag)
			{
				m = new Datac(temp0.substr(1, temp0.length() - 2));
				temp.d = m;
				w.push_back(temp);
			}
			else throw QueryException("ERROR: Values in where clause is invalid!");

		}

		else if (qs.substr(pos, pos1 - pos) == "<") {
			temp.flag = l;
			pos = pos1;
			while (qs[pos] == ' ') pos++;
			pos1 = readElement(pos);
			temp0 = qs.substr(pos, pos1 - pos);

			if (temp0 == "=") {
				temp.flag = leq;
				pos = pos1;
				while (qs[pos] == ' ') pos++;
				pos1 = readElement(pos);
				temp0 = qs.substr(pos, pos1 - pos);
			}
			else if (temp0 == ">") {
				temp.flag = neq;
				pos = pos1;
				while (qs[pos] == ' ') pos++;
				pos1 = readElement(pos);
				temp0 = qs.substr(pos, pos1 - pos);
			}

			if (flag == -1 && toInt(temp0, x)) {
				m = new Datai(x);
				temp.d = m;
				w.push_back(temp);
			}

			else if (flag == 0 && toFloat(temp0, y)) {
				m = new Dataf(y);
				temp.d = m;
				w.push_back(temp);
			}

			else if (flag > 0 && ((temp0[0] == '\'' && temp0[temp0.length() - 1] == '\'') || (temp0[0] == '\"' && temp0[temp0.length() - 1] == '\"')) && temp0.length() - 2 <= flag)
			{
				m = new Datac(temp0.substr(1, temp0.length() - 2));
				temp.d = m;
				w.push_back(temp);
			}
			else throw QueryException("ERROR: Values in where clause is invalid!");
		}
		else throw QueryException("ERROR: invalid query format!");

		pos = pos1;
		while (qs[pos] == ' ') pos++;
		pos1 = readElement(pos);
		if (qs.substr(pos, pos1 - pos) == ";")
			break;

		if (qs.substr(pos, pos1 - pos) != "and")
		{
			if (qs.substr(pos, pos1 - pos) == "or")
			{
				selectOr = true;
			}
			else
				throw QueryException("ERROR: invalid query format!");
		}
			
		pos = pos1;
		while (qs[pos] == ' ') pos++;
		pos1 = readElement(pos);
	}
}


/// insert into student values (��12345678��,��wy��,22,��M��);
void InterManager::ExecInsert()
{
	int pos = 6, pos1;
	int i;
	while (qs[pos] == ' ') pos++;
	pos1 = readElement(pos);

	if (qs.substr(pos, pos1-pos) != "into")
		throw QueryException("ERROR: invalid syntax format!");
	pos = pos1;
	while (qs[pos] == ' ') pos++;
	pos1 = readElement(pos);
	string tableName = qs.substr(pos, pos1 - pos);

	pos = pos1;
	while (qs[pos] == ' ') pos++;
	pos1 = readElement(pos);
	if (qs.substr(pos, pos1 - pos) != "values")
		throw QueryException("ERROR: invalid syntax format!");

	pos = pos1;
	while (qs[pos] == ' ') pos++;
	pos1 = readElement(pos);
	if (qs.substr(pos, pos1 - pos) != "(")
		throw QueryException("ERROR: invalid syntax format!");
	
	pos = pos1;
	while (qs[pos] == ' ') pos++;
	pos1 = readElement(pos);

	tuper* tp = new tuper();
	string temp;
	CataManager cm;
	float p;
	Table* tb = cm.getTable(tableName);
	Attribute attr = tb->attr;

	Data* dtemp;
	bool isValue = true;
	try {
		while (1) {
			if (isValue)
			{
				//int
				temp = qs.substr(pos, pos1 - pos);
				if (attr.flag[tp->length()] == -1) {
					if (!toInt(temp, i))
						throw QueryException("ERROR: " + temp + " is not a (int)!");
					dtemp = new Datai(i);
					dtemp->flag = -1;
					tp->addData(dtemp);
				}

				//float
				else if (attr.flag[tp->length()] == 0) {
					if (!toFloat(temp, p))
						throw QueryException("ERROR: " + temp + "is not a (float)!");
					dtemp = new Dataf(p);
					dtemp->flag = 0;
					tp->addData(dtemp);
				}
				//char
				else { 
					if (!((temp[0] == '\'' && temp[temp.length() - 1] == '\'') || (temp[0] == '\"' && temp[temp.length() - 1] == '\"')))
						throw QueryException("ERROR: " + temp + " is not a (string)");
						
					temp = qs.substr(pos+1, pos1 - pos - 2);
					dtemp = new Datac(temp);
					dtemp->flag = temp.length();
					if (dtemp->flag > attr.flag[tp->length()])
						throw QueryException("ERROR: " + temp + "is too long!");
					tp->addData(dtemp);
				}

				pos = pos1;
				while (qs[pos] == ' ') pos++;
				pos1 = readElement(pos);
				isValue = false;
			}
			else
			{
				temp = qs.substr(pos, pos1 - pos);
				if (temp != ",")
				{
					if (temp != ")") 
						throw QueryException("ERROR: invalid syntax format!");
					pos = pos1;
					while (qs[pos] == ' ') pos++;
					pos1 = readElement(pos);
					break;
				}
				pos = pos1;
				while (qs[pos] == ' ') pos++;
				pos1 = readElement(pos);
				isValue = true;
			}
		}
		
		if (qs.substr(pos, pos1-pos) != ";")
			throw QueryException("ERROR: invalid syntax format!");

	}
	catch (QueryException qe) {
		delete tb;
		delete tp;
		throw qe;
	}

	API api;
	api.Insert(*tb, *tp);

	delete tb;
	answer[tableName] = 1;
	//delete tp;
}

void InterManager::ExecCreate()
{
	int pos = 6, pos1;
	while (qs[pos] == ' ') pos++;
	pos1 = readElement(pos);
	string tmp = qs.substr(pos, pos1 - pos);
	if (tmp == "table")
		ExecCreateTable(pos1);
	else if (tmp == "index")
		ExecCreateIndex(pos1);
	else
		throw QueryException("ERROR: invalid syntax format!");
}

/*
create table student (
		sno char(8),
		sname char(16) unique,
		sage int,
		sgender char (1),
		primary key ( sno )
);
*/
void InterManager::ExecCreateTable(int lastPos)
{
	int i, k;
	int pos = lastPos;
	while (qs[pos] == ' ') pos++;
	int pos1 = readElement(pos);
	string tableName = qs.substr(pos, pos1 - pos);


	pos = pos1;
	while (qs[pos] == ' ') pos++;
	pos1 = readElement(pos);

	if (qs.substr(pos, pos1 - pos) != "(")
		throw QueryException("ERROR: invalid syntax format!");
	
	Attribute attr;
	attr.num = 0;
	for (i = 0; i < 32; i++)
		attr.unique[i] = false;
	
	pos = pos1;
	while (qs[pos] == ' ') pos++;
	pos1 = readElement(pos);

	string temp;
	bool priflag = false;
	
	while (true) 
	{
		temp = qs.substr(pos, pos1 - pos);
		if (temp == "primary") {
			priflag = true;
			break;
		}

		attr.name[attr.num] = temp;
		pos = pos1;
		while (qs[pos] == ' ') pos++;
		pos1 = readElement(pos);
		temp = qs.substr(pos, pos1 - pos); //char int float
		
		if (temp == "int") {
			attr.flag[attr.num] = -1;
			pos = pos1;
			while (qs[pos] == ' ') pos++;
			pos1 = readElement(pos);
		}
		else if (temp == "float") {
			attr.flag[attr.num] = 0;
			pos = pos1;
			while (qs[pos] == ' ') pos++;
			pos1 = readElement(pos);
		}
		else if (temp == "char") {
			pos = pos1;
			while (qs[pos] == ' ') pos++;
			pos1 = readElement(pos);
			if (qs[pos] != '(')
				throw QueryException("ERROR: invalid syntax format!");
			pos = pos1;
			while (qs[pos] == ' ') pos++;
			pos1 = readElement(pos);
			temp = qs.substr(pos, pos1 - pos);
			k = 0;
			for (i = 0; i < temp.length(); i++) {
				if (temp[i] <= '9' && temp[i] >= '0')
				{
					k *= 10;
					k += temp[i] - '0';
				}
				else
					throw QueryException("ERROR: invalid syntax format!");
			}
			attr.flag[attr.num] = k;
			pos = pos1;
			while (qs[pos] == ' ') pos++;
			pos1 = readElement(pos);
			if (qs.substr(pos, pos1-pos) != ")")
				throw QueryException("ERROR: invalid syntax format!");
			pos = pos1;
			while (qs[pos] == ' ') pos++;
			pos1 = readElement(pos);

		}
		else {
			throw QueryException("ERROR: invalid syntax format!");
		}

		if (qs.substr(pos, pos1-pos) == ")") {
			attr.num++;
			break;
		}
		else if (qs.substr(pos, pos1 - pos) == "unique") {
			attr.unique[attr.num] = 1;
			pos = pos1;
			while (qs[pos] == ' ') pos++;
			pos1 = readElement(pos);
			if (qs.substr(pos, pos1 - pos) == ")") {
				attr.num++;
				break;
			}
			else if (qs.substr(pos, pos1 - pos) == ",") {
				attr.num++;
				pos = pos1;
				while (qs[pos] == ' ') pos++;
				pos1 = readElement(pos);
				continue;
			}
			else throw QueryException("ERROR: invalid syntax format!");
		}
		else if (qs.substr(pos, pos1 - pos) == ",") {
			attr.num++;
			pos = pos1;
			while (qs[pos] == ' ') pos++;
			pos1 = readElement(pos);
			continue;
		}
		else {
			throw QueryException("ERROR: invalid syntax format!");
		}
	}

	//cout << attr.num << endl; ////
	//Table T(tname,attr,0);
	string pmk;
	if (priflag) {
		pos = pos1;
		while (qs[pos] == ' ') pos++;
		pos1 = readElement(pos);
		if (qs.substr(pos, pos1 - pos) != "key")
			throw QueryException("ERROR: invalid syntax format!");
		pos = pos1;
		while (qs[pos] == ' ') pos++;
		pos1 = readElement(pos);
		if (qs.substr(pos, pos1-pos) != "(")
			throw QueryException("ERROR: invalid syntax format!");
		pos = pos1;
		while (qs[pos] == ' ') pos++;
		pos1 = readElement(pos);
		pmk = qs.substr(pos, pos1 - pos);

		pos = pos1;
		while (qs[pos] == ' ') pos++;
		pos1 = readElement(pos);
		if (qs.substr(pos, pos1-pos) != ")")
			throw QueryException("ERROR: invalid syntax format!");
		pos = pos1;
		while (qs[pos] == ' ') pos++;
		pos1 = readElement(pos);
		if (qs.substr(pos, pos1-pos) != ")")
			throw QueryException("ERROR: invalid syntax format!");
	}

	pos = pos1;
	while (qs[pos] == ' ') pos++;
	pos1 = readElement(pos);
	if (qs.substr(pos, pos1-pos) != ";")
		throw QueryException("ERROR: invalid syntax format!");

	short pid;
	if (priflag) {
		for (pid = 0; pid < attr.num; pid++) {
			if (attr.name[pid] == pmk)
				break;
		}
	}
	else pid = -1;

	CataManager cm;
	Index ind;
	if (pid == attr.num || !priflag)
		pid = -1;
	else
		attr.unique[pid] = 1;
	ind.num = 0;
	cm.create_table(tableName, attr, pid, ind);
	if (pid != -1) {
		cm.create_index(tableName, attr.name[pid], tableName+ to_string(pid));
	}
	for(int i=0;i<attr.num;i++)
	{
		if(i!=pid&&attr.unique[i])
		{
			cm.create_index(tableName, attr.name[i], tableName + to_string(i));
		}
	}
	answer[tableName] = false; 
	tablelist[tableName] = 1;
}


void InterManager::ExecCreateIndex(int lastPos)
{
	int pos = lastPos;
	while (qs[pos] == ' ') pos++;
	CataManager cm;
	int pos1 = readElement(pos);
	string iname = qs.substr(pos, pos1 - pos);
	pos = pos1;
	while (qs[pos] == ' ') pos++;
	pos1 = readElement(pos);
	if (qs.substr(pos, pos1 - pos) != "on")
		throw QueryException("ERROR: invalid syntax format!");
	pos = pos1;
	while (qs[pos] == ' ') pos++;
	pos1 = readElement(pos);
	string tname = qs.substr(pos, pos1 - pos);
	pos = pos1;
	while (qs[pos] == ' ') pos++;
	pos1 = readElement(pos);
	if (qs.substr(pos, pos1 - pos) != "(")
		throw QueryException("ERROR: invalid syntax format!");
	pos = pos1;
	while (qs[pos] == ' ') pos++;
	pos1 = readElement(pos);
	string aname = qs.substr(pos, pos1 - pos);
	pos = pos1;
	while (qs[pos] == ' ') pos++;
	pos1 = readElement(pos);
	if (qs.substr(pos, pos1 - pos) != ")")
		throw QueryException("ERROR: invalid syntax format!");
	pos = pos1;
	while (qs[pos] == ' ') pos++;
	pos1 = readElement(pos);
	if (qs.substr(pos, pos1 - pos) != ";")
		throw QueryException("ERROR: invalid syntax format!");
	cm.create_index(tname, aname, iname);
	Table *t = cm.getTable(tname);
	API api;
	api.CreateIndex(*t, (*t).index.location[(*t).index.num - 1]);
}

void InterManager::ExecDelete(){
	int pos = 7;
	while (qs[pos] == ' ') pos++;
	int pos1 = readElement(pos);
	if (qs.substr(pos, pos1 - pos) != "from")
		throw QueryException("ERROR: invalid syntax format!");

	pos = pos1;
	while (qs[pos] == ' ') pos++;
	pos1 = readElement(pos);
	string tname = qs.substr(pos, pos1 - pos);
	CataManager cm;
	Table* t = cm.getTable(tname);
	vector<int> attrwhere;
	vector<where> w;
	Attribute A = t->attr;

	pos = pos1;
	while (qs[pos] == ' ') pos++;
	pos1 = readElement(pos);

	bool selectOr = false;
	if (qs.substr(pos, pos1-pos) == ";")
	{
		answer[tname] = 0;
	}
	if (qs.substr(pos, pos1-pos) != ";") {
		if (qs.substr(pos, pos1 - pos) != "where")
			throw  QueryException("ERROR: invalid syntax format!");
		interWhere(pos1, attrwhere, w, A, t, selectOr);
	}
	API api;
	//t->blockNum = 1;
	if (selectOr)
	{
		vector<int> attrwhere1, attrwhere2;
		vector<where> w1, w2;
		attrwhere1.push_back(attrwhere[0]);
		w1.push_back(w[0]);
		attrwhere2.push_back(attrwhere[1]);
		w2.push_back(w[1]);
		api.Delete(*t, attrwhere1, w1);
		api.Delete(*t, attrwhere2, w2);
	}
	else 
	{
		api.Delete(*t, attrwhere, w);
	}
	delete t;
}

void InterManager::ExecFile(){
	int pos = 8;
	while (qs[pos] == ' ') pos++;
	int pos1 = readElement(pos);
	string fname = qs.substr(pos, pos1-pos);
	ifstream in(fname);
	if (!in)
		throw QueryException("No file named " + fname);
	pos = pos1;
	while (qs[pos] == ' ') pos++;
	pos1 = readElement(pos);
	if (qs.substr(pos, pos1-pos) != ";")
		throw  QueryException("ERROR: invalid syntax format!");
	string temp;
	qs = "";
	while (in.peek() != EOF) {
		try {
			in >> temp;
			qs = qs + temp + " ";
			if (temp[temp.length() - 1] == ';') {
				Exec();
				qs = "";
			}
		}
		catch (TableException te) {
			//cout << qs << endl;
			//cout << te.what() << endl;
			qs = "";
		}
		catch (QueryException qe) {
			//cout << qs << endl;
			//cout << qe.what() << endl;
			qs = "";
		}
	}
	in.close();
}

int InterManager::readElement(int pos)
{
    while (pos < qs.length() && qs[pos] != ' ') pos++;
    return pos;
}

bool isCharacter(char a)
{
    return a=='>' || a=='<' || a=='=' || a=='(' || a==')' || a==',' || a==';' || a=='*';
}

bool isValidAttribute(const string& a)
{
    for (int i = 0; i < a.length(); i++)
    {
        if (i == 0) 
        {
            if (isalpha(a[i]) || a[i] == '_') continue;
            else return false;
        }
        else 
        {
            if (isalpha(a[i]) || a[i] == '_' || isalnum(a[i])) continue;
            else return false;
        }
    }
    return true;
}

bool toInt(const string& s, int& a) {
	int i;
	a = 0;
	for (i = 0; i < s.length(); i++) {
		if (s[i] <= '9' && s[i] >= '0')
		{
			a *= 10;
			a += s[i]-'0';
		}
		else return false;
	}
	return true;
}

bool toFloat(const string& s, float& a) {
	int i;
	a = 0;
	int dot;
	for (i = 0; i < s.length(); i++)
		if (s[i] == '.')
			break;
	int j = 0;
	if (i == s.length()) {
		if (toInt(s, j))
		{
			a = j;
			return true;
		}
		else return false;
	}

	dot = i;
	for (i = 0; i < dot; i++) {
		if (s[i] <= '9' && s[i] >= '0')
			a += pow(10, dot - i - 1)*(s[i] - '0');
		else return false;
	}
	for (i = dot + 1; i < s.length(); i++) {
		if (s[i] <= '9' && s[i] >= '0')
			a += pow(0.1, i - dot)*(s[i] - '0');
		else return false;
	}
	return true;
}