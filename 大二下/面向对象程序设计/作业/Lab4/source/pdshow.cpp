#include "diary.h"
#include "diary.cpp"

int main ()
{
    vector<diary> diaries, temp;
	readFile("personal_diary.txt", diaries); //Read the diary and store information in vector<diary> diaries.

    freopen("pdshow_test1.txt", "r", stdin); //stdin<-pdshow_test1.txt.
    string date;
    getline(cin, date); //Get the date of the entity to be shown.
    fclose(stdin);
    
    if (date.empty()) cout << "Empty file." << endl;
    else 
    {
        for (int i = 0; i < diaries.size(); i++) //Check if the date has an entity in the diary.
        {
            if (diaries[i].getDate() == date)
            {
                temp.push_back(diaries[i]);
                break;
            }
        }
        if (temp.empty()) cout << "There is no diary on " << date << "." << endl;
        else 
        {
            cout << "Show the diary successfully in pdshow_out.txt." << endl;
            writeFile("pdshow_out.txt", temp); //Write the result in the file "pdshow_test1.txt".
        }
    }
    return 0;
}