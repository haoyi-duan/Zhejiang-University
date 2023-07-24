#include "diary.h"
#include "diary.cpp"

int main()
{
    vector<diary> diaries;
    readFile("personal_diary.txt", diaries); //Read the diary and store the information in vector<diary> diaries.

    freopen("pdremove_test1.txt", "r", stdin); //stdin<-pdremove_test1.txt
    string date;
    getline(cin, date); //Get the date of the entity to be removed.
    fclose(stdin);

    bool flag = false;
    for (vector<diary>::iterator iter = diaries.begin(); iter != diaries.end(); iter++)
        if ((*iter).getDate() == date) //Check if the date of entity is in the diary.
        {
            flag = true;
            diaries.erase(iter);
            break;
        }
    if (date.empty()) cout << "Empty file." << endl;
    else if (!flag) cout << "There is no diary on date " << date << "." << endl;
    else
    {
        cout << "Successfully remove the diary on " << date << "." << endl;
        writeFile("personal_diary.txt", diaries); //Write the file "personal_diary,txt" with the date of entity removedd.
    }
    return 0;
}