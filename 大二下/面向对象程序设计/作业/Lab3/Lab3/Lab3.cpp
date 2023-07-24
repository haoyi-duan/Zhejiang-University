// Input "exit" or "quit" to end the program any time you like!
// For faster input version, input 'q' to end the program.

#include <iostream>
#include <cstdlib>
#include <fstream>
#include <vector>
#include <string>
#include <ctime>
#include <iomanip>
#include <cmath>
#include <conio.h>
#include <random>

using namespace std;

#define CHEAT              // if define CHEAT, print the map in every step, else, the map will not be printed.
#define MAP 0 // 0 for random map, 1 for map1, 2 for map2.
#define COLOR // If define COLOR, then the color of the background will change to "color f4". 

// Store som elements of the map.
class Element
{
public:
	int roomLevel; // The level of the map.
	int roomNumPerLevel; // In the map, the number of the rooms in every level will be caculated after reading the "rom.txt".
	int lobbyLocation; // The location of the lobby in the structure is 7.
	int monsterLocation; // The location of the monster in the structure is 14.
	int princessLocation; // The location of the princess in the structure is 22.
	int sqrtRoom;
};

class Adventure: public Element
{
private:
	// Store the information of each room.
	struct room
	{
		int exitNum;
		bool north, south, west, east;
		bool up, down;
	};
	// Store the information of the map.
	vector<room> Castle;
	// Whether we meet the princess or not. 
	bool getPrincess = false;
	// The location of the princess at the moment.
	int princess; 
	// The location of the player at the moment. 
	int location;
	int state = 0; /* state = 0: not the end;
					  state = 1: meet the monster;
					  state = 2: 
				   */
public:
	void begin(void);
	void initial(void);
	void getMap(void);
	void randomMap(void);
	void play(void);
	void printExits(void);
	bool check(void);
	void printMap(void);
};

int main()
{
#ifdef COLOR	
	system("color f4");
#endif // COLOR
	char c;
	do	
	{
		system("cls");
		Adventure game;
		game.initial();
		game.begin();
		game.play();
		// Input "y" or "n".
		while (true)
		{
			c = _getch();
			if (c != 'y' && c != 'n')
				cout << "Sorry, wrong format, please try again!" << endl;
			else break;
		}
	} while (c != 'n');
	system("pause");
	return 0;
}

// Print the word in the beginning of the game.
void Adventure::begin(void)
{
	cout << "Welcome to the Adventure!" << endl << "Press Any Key to Begin!" << endl;
	char c = _getch();
	system("cls");
}

// Initialize the structure. the data of the Castle is read from "rom.txt".
void Adventure::initial(void)
{
	// "map1.txt" and "map2.txt" are two maps of the game, both are working.
	// if MAP = 0, random a map for the player to play.
	
	if (MAP == 0) randomMap();
	else getMap();
}

void Adventure::getMap(void)
{	
	string s = "";
	string c = to_string(MAP);
	s = "map" + c;
	s += ".txt";

	ifstream fin;
	fin.open(s);
	if (!fin.is_open()) {
		cout << "Error opening file input" << endl;
		exit(1);
	}

	bool flag = false;
	while (!fin.eof())
	{
		if (!flag)
		{
			fin >> roomLevel >> roomNumPerLevel >> lobbyLocation >> monsterLocation >> princessLocation;
			flag = true;
			continue;
		}
		room tmp;
		fin >> tmp.exitNum >> tmp.north >> tmp.south >> tmp.west >> tmp.east >> tmp.up >> tmp.down;
		Castle.push_back(tmp);
	}
	fin.close();
	// Get the location of the princess and the initial location of the player from the txt.
	princess = princessLocation;
	location = lobbyLocation;
	sqrtRoom = (int)sqrt(roomNumPerLevel);
}

void Adventure::randomMap(void)
{
	srand((unsigned)time(NULL));
	roomLevel = rand() % 3 + 3; // roomLevel
	roomNumPerLevel = int(pow(rand() % 4 + 2, 2)); // roomNumPerLevel
	lobbyLocation = rand() % roomNumPerLevel; //lobbyLocation
	monsterLocation = rand() % roomNumPerLevel + (roomLevel - 2) * roomNumPerLevel; 
	princessLocation = rand() % roomNumPerLevel + (roomLevel - 1) * roomNumPerLevel;
	princess = princessLocation;
	location = lobbyLocation;
	sqrtRoom = (int)sqrt(roomNumPerLevel);
	// Random the map information.
	for (int i = 0; i < roomNumPerLevel * roomLevel; i++)
	{
		room tmp;
		tmp.north = tmp.south = tmp.west = tmp.east = tmp.up = tmp.down = 1;
		// Judge north
		if (i % roomNumPerLevel < sqrtRoom) tmp.north = 0;
		else tmp.north = 1;
		// Judge south
		if (i % roomNumPerLevel >= sqrtRoom*(sqrtRoom-1)) tmp.south = 0;
		else tmp.south = 1;
		// Judge west
		if (i % sqrtRoom == 0) tmp.west = 0;
		else tmp.west = 1;
		// Judge east
		if ((i+1) % sqrtRoom == 0) tmp.east = 0;
		else tmp.east = 1;
		// Judge up
		if (i / roomNumPerLevel == (roomLevel-1)) tmp.up = 0;
		else tmp.up = 1;
		// Judge down
		if (i / roomNumPerLevel == 0) tmp.down = 0;
		else tmp.down = 1;
 
		tmp.exitNum = tmp.north + tmp.south + tmp.west + tmp.east + tmp.up + tmp.down;
		Castle.push_back(tmp);
	}
}

// The play function reads each input of the player and does some operations.
void Adventure::play(void)
{
	bool isEnd = false;
	while (true)
	{
		system("cls");
		cout << "Welcome to the ";
		if (location == lobbyLocation) cout << "lobby";
		else
			cout << "room " << location / roomNumPerLevel + 1 << "-" << location % roomNumPerLevel + 1;
		cout << ".There are " << Castle[location].exitNum << " exits: ";
		printExits();
		if (location == princessLocation && !getPrincess)
		{
			cout << "By the way, you have found the princess!" << endl;
			getPrincess = true;
		}
#ifdef CHEAT
		Adventure::printMap();
#endif // CHEAT
		cout << "Enter your command :" << endl;

		char s;
		while (true)
		{
			s = _getch();
			if (s == 'w') // Go north
			{
				if (Castle[location].north)
				{
					location -= sqrtRoom;
					break;
				}
				else cout << "There is no north exits. Please choose another one." << endl;
			}
			else if (s == 's') // Go south
			{
				if (Castle[location].south)
				{
					location += sqrtRoom;
					break;
				}
				else cout << "There is no south exits. Please choose another one." << endl;
			}
			else if (s == 'a') // Go west
			{
				if (Castle[location].west)
				{
					location -= 1;
					break;
				}
				else cout << "There is no west exits. Please choose another one." << endl;
			}
			else if (s == 'd') // Go east
			{
				if (Castle[location].east)
				{
					location += 1;
					break;
				}
				else cout << "There is no east exits. Please choose another one." << endl;
			}
			else if (s == 'u') // Go up
			{
				if (Castle[location].up)
				{
					location += roomNumPerLevel;
					break;
				}
				else cout << "There is no up exits. Please choose another one." << endl;
			}
			else if (s == 'n') // Go down
			{
				if (Castle[location].down)
				{
					location -= roomNumPerLevel;
					break;
				}
				else cout << "There is no down exits. Please choose another one." << endl;
			}
			else if (s == 'q') // quit the game
			{
				isEnd = true;
				break;
			}
			else cout << "Sorry, wrong format, please try again!" << endl;
		}
		if (isEnd) break;
		if (Adventure::check()) break;
	}
	if (isEnd);
	else if (state == 1)
	{
		cout << "You Meet the Monster!" << endl;
		cout << "You Lose!" << endl;
	}
	else if (state == 2)
	{
		cout << "Congraduations! You Save the princess, Warrior!" << endl;
		cout << "You Win!" << endl;
	}
#ifdef CHEAT
		Adventure::printMap();
#endif // CHEAT		
	cout << "Do you want to play again?('y' or 'n')" << endl;
}

// Print the exits of the room.
void Adventure::printExits(void)
{
	vector<string> exits;
	if (Castle[location].down) exits.push_back("down");
	if (Castle[location].up) exits.push_back("up");
	if (Castle[location].east) exits.push_back("east");
	if (Castle[location].west) exits.push_back("west");
	if (Castle[location].south) exits.push_back("south");
	if (Castle[location].north) exits.push_back("north");

	string s = "";
	int initSizeEqualsOne = exits.size() == 1;
	while (!exits.empty())
	{
		if (exits.size() == 2)
		{
			s = s + exits.back() + ' ';
			exits.pop_back();
		}
		else if (exits.size() == 1)
		{
			if (initSizeEqualsOne) s = exits.back();
			else s = s + "and " + exits.back();
			exits.pop_back();
		}
		else
		{
			s = s + exits.back() + ", ";
			exits.pop_back();
		}
	}
	cout << s << endl;
}

// Check if the player has met the monster or has taken the princess to the lobby.
bool Adventure::check(void)
{
	if (getPrincess) princess = location;
	if (location == monsterLocation) state = 1;
	if (location == lobbyLocation && princess == lobbyLocation) state = 2;
	if (state) return true;
	return false;
}

// The function of printMap is to print the map and the location of monster, princess, and the player.
void Adventure::printMap(void)
{
	vector<char> a;
	for (int i = 0; i < roomNumPerLevel; i++) a.push_back(' ');
	a[location % roomNumPerLevel] = '1';
	if (location / roomNumPerLevel == monsterLocation / roomNumPerLevel) a[monsterLocation % roomNumPerLevel] = 'M';
	if (location / roomNumPerLevel == princessLocation / roomNumPerLevel && !getPrincess) a[princessLocation % roomNumPerLevel] = 'P';
	else if (getPrincess) a[location % roomNumPerLevel] = 'P';
	if (location / roomNumPerLevel == 0) a[lobbyLocation] = 'L';
	// Print the map.
		cout << "Level " << location / roomNumPerLevel + 1 << ":" <<endl;

		for (int i = 0; i < sqrtRoom-1; i++) cout << "____";
		cout << "___"<< endl;
		for (int i = 0; i < sqrtRoom-1; i++) cout << "   |";
		cout << endl;

		for (int i = 0; i < sqrtRoom; i++)
		{
			for (int j = 0; j < sqrtRoom; j++)
			{
				if (j == sqrtRoom-1) cout << "_" << a[i*sqrtRoom+j] << "_" << endl;
				else cout << "_" << a[i*sqrtRoom+j] << "_|";
			}
			if (i < sqrtRoom-1)
			{
				for (int i = 0; i < sqrtRoom-1; i++) cout << "   |";
				cout << endl;
			}
		}
}