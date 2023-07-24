#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <math.h>

/*********************************************************************************************/
/*DEFINITION*/

/*The maximum number of points of shape A and shape B, respectively.*/
#define MaxSize 100 

/*The size of the table is an n1*n2 square, 
so it is necessary to define an int array of size 10000, 
which is the square of the MaxSize.*/
#define NodeSize 10000 

/*Define the number of the results of the voting correspondence in case the answers are not acctually unique.*/
#define AnswerNum 10 

/*The deviation coefficient defined to judge whether to terminate.*/
#define epsilon 0.05

/*********************************************************************************************/
/*STRUCTURE*/ 

/*The struct node, in other words, Node, is used to store the coordinates of the points.
Use shapeA[MaxSize] & shapeB[MaxSize] to store the data of each shape.*/
typedef struct node Node; 
struct node
{
	double x, y;
}shapeA[MaxSize], shapeB[MaxSize];

/*This structure plays a vital role in the greedy algorithm, 
which is used to store the index 'i' & 'j' of the chosen node
in a bid to avoid unnecessary repetition later.*/
struct board
{
	int data[MaxSize];
	int length;	
}a, b;

/*This structure is used to build the voting tree 
or connect the expected answer in order to output.*/
typedef struct SearchTreeCDT* SearchTreeADT;
struct SearchTreeCDT
{
    int p1, p2;
    int ChildNum;
    int Level; 
    SearchTreeADT Last;
    SearchTreeADT Next[MaxSize];
};

/*n1 & n2 represent the number of points of the two shapes, 
namely shapeA & shapeB, respectively.*/
int n1, n2, i;

/*the integer MaxLevel represents he maximum of the length of path.*/
int MaxLevel = 0;

int count = 0, error = 0, SizeFinal = 0, AnswerFinal = 0; 

/*This is the voting table, which represents the vote numbers of each node.
The original votes of all the correspondence are 0.*/
int table[NodeSize] = {0}; 

/*********************************************************************************************/
/*FUNCTIONS*/ 

/*MyAbs(double x) is a function
which is able to return the absolute value of the input variable with double type.*/
double MyAbs(double x);

/*Read() is a function to read the input and store the input to the appropriate address.*/
void Read(void);

/*Create() is a function to create a head node of the voting tree.*/
SearchTreeADT Create(void);

/*Build(SearchTreeADT p, int left, int right) is a function to build the voting tree,
what deserves your attention is that it can terminate when the points are not matched,
and the function designed to judge whether the points in the groups are matched or not
is in the following.*/
void Build(SearchTreeADT p, int left, int right);

/*Match(int a1, int b1, int a2, int b2, int a3, int b3):
judge whether the points in the groups are matched or not
using mathematical methods.*/
bool Match(int a1, int b1, int a2, int b2, int a3, int b3);

/*The function Vote(SearchTreeADT p) is designed to vote for each matching.
By caculating the electors of each nodes, we will have somthing to take into consideration
when deciding which pair is the most perfect correspondence.*/
void Vote(SearchTreeADT p);

void PrintVote(void);

/*Function NotIn(struct board a, int x) is used to judge whether integer x is in the a.data[MaxSize]
and returns a bool.*/
bool NotIn(struct board a, int x);

/*Function In(int x) is designed to insert the integer x into the integer array a.data[MaxSize].*/
void In(int x);

/*The function Insert(SearchTreeADT p, int x, int y)
is used to insert the node(x, y) in the right place.
In this program, the node is placed in increasing order.*/
SearchTreeADT Insert(SearchTreeADT p, int x, int y);

/*The functon Greedy(void) includes the principle of greedy method.
for each step, this argorithm always choose a node from the left nodes
which has the maximum number of votes.*/
SearchTreeADT Greedy(void);

/*PrintAnswer(SearchTreeADT p) can print the final answer in increasing order.*/
void PrintAnswer(SearchTreeADT p);
     
/*********************************************************************************************/
/*MAIN*/
int main ()
{
	/*The main function shows the idea of the encapsulation.
	There are several steps included in the main function.
	First, read the input data;
	Second, Build the voting tree;
	Third, vote on the basis of the tree constructed earlier;
	Fourth, make more judegment according to the result;
	Fifth, print the final result, which is a possible match.*/
	
	Read(); //Read the data.
    SearchTreeADT SearchTree = Create(); //Create the head node.
    Build(SearchTree, 0, 0); //Build the voting tree.
    
	/*You can use the printf below to analyze the test cases.
	Notice that MaxLevel represents the length of the possible correspondence, 
	but it may not be the final result.
	The integer count represents the nodes chosen, 
	and the integer error represents the nodes being rejected.*/ 
	//printf("MaxLevel = %d count = %d, error = %d\n", MaxLevel, count, error);
	
	Vote(SearchTree); //Record the vote result on a table.
    
	/*You can use the function PrintVote() to print the vote table.*/
	//PrintVote(); 
    SearchTreeADT Answer = Greedy(); //Use greedy methodn to choose the match result.
    PrintAnswer(Answer); //Print the final answer in increasing order.
    system("pause"); 
	return 0;
}

/*********************************************************************************************/
/*MyAbs*/
double MyAbs(double x)
{
	if (x < 0) return -x;
    return x;
}

/*********************************************************************************************/
/*Read*/
void Read(void)
{
	double xi, yi; //xi & yi temporarily storage the cordinates of the nodes.
	scanf("%d %d", &n1, &n2); 
	for (i = 0; i < n1; i++)
	{
		scanf("%lf %lf", &xi, &yi);
		shapeA[i].x = xi;
		shapeA[i].y = yi;
	}
	for (i = 0; i < n2; i++)
	{
		scanf("%lf %lf", &xi, &yi);
        shapeB[i].x = xi;
        shapeB[i].y = yi;
	}
}

/*********************************************************************************************/
/*Create*/
SearchTreeADT Create(void)
{
    int i;
	SearchTreeADT Head = (SearchTreeADT)malloc(sizeof(struct SearchTreeCDT)); //Open space for the head node.
    Head->ChildNum = 0; 
    Head->Level = 0; 
    for (i = 0; i < MaxSize; i++)
		Head->Next[i] = NULL;
    return Head;
}

/*********************************************************************************************/
/*Match*/
bool Match(int p1, int n1, int p2, int n2, int p3, int n3)
{
    /*The main point in this function is that there are two aspects to define whether the nodes are a match.
	The first rule is whether the ratio of the corresponding side length is close enough;
	The second rule is whether the angles formed by the both sides are close enough.*/
	
	/*The cordinates of each point*/
	double ax1, ay1, ax2, ay2, ax3, ay3, bx1, by1, bx2, by2, bx3, by3;
    
	/*The length triangle side*/
	double aL1, aL2, bL1, bL2;

    ax1 = shapeA[p1-1].x;
    ay1 = shapeA[p1-1].y;
    ax2 = shapeA[p2-1].x;
    ay2 = shapeA[p2-1].y;
    ax3 = shapeA[p3-1].x;
    ay3 = shapeA[p3-1].y;

    bx1 = shapeB[n1-1].x;
    by1 = shapeB[n1-1].y;
    bx2 = shapeB[n2-1].x;
    by2 = shapeB[n2-1].y;
    bx3 = shapeB[n3-1].x;
    by3 = shapeB[n3-1].y;
    
    aL1 = sqrt((ax1-ax2)*(ax1-ax2) + (ay1-ay2)*(ay1-ay2)); //Caculate the length of aL1.
    aL2 = sqrt((ax3-ax2)*(ax3-ax2) + (ay3-ay2)*(ay3-ay2)); //Caculate the length of aL2.
    bL1 = sqrt((bx1-bx2)*(bx1-bx2) + (by1-by2)*(by1-by2)); //Caculate the length of bL1.
    bL2 = sqrt((bx3-bx2)*(bx3-bx2) + (by3-by2)*(by3-by2)); //Caculate the length of bL2.
    if (MyAbs(aL1/bL1-aL2/bL2) > epsilon) return false;
	
    double CosTheta1, CosTheta2;
    CosTheta1 = ((ax1-ax2)*(ax3-ax2)+(ay1-ay2)*(ay3-ay2))/aL1/aL2; //Caculate the value of cos(theta1).
    CosTheta2 = ((bx1-bx2)*(bx3-bx2)+(by1-by2)*(by3-by2))/bL1/bL2; //Caculate the value of cos(theta2).
    if (MyAbs(MyAbs(acos(CosTheta1)/acos(CosTheta2))-1) > epsilon) return false;

    return true;
}

/*********************************************************************************************/
/*Build*/
void Build(SearchTreeADT p, int left, int right)
{
	int j, k;
	for (j = left; j < n1; j++)
	for (k = right; k < n2; k++)
	{
		if (((p->Level + 1) < 3) || ((p->Level + 1) >= 3 && Match(p->Last->p1, p->Last->p2, p->p1, p->p2, j+1, k+1)))
		{
			/*Below are steps to add new node to the p
			The address of the new node is p->Next[p->ChildNum].*/
			p->Next[p->ChildNum] = (SearchTreeADT)malloc(sizeof(struct SearchTreeCDT));
			p->Next[p->ChildNum]->ChildNum = 0;
			p->Next[p->ChildNum]->Level = p->Level+1;
			p->Next[p->ChildNum]->p1 = j+1;
			p->Next[p->ChildNum]->p2 = k+1;
			p->Next[p->ChildNum]->Last = p;
			int t;
			for (t = 0; t < MaxSize; t++)
				p->Next[p->ChildNum]->Next[t] = NULL;
			
			/*The maximum depth of the path is updated in real time.*/
			if (MaxLevel < p->Next[p->ChildNum]->Level) 
               	MaxLevel = p->Next[p->ChildNum]->Level;
            count++; ////////////////////////////////
            /*Use recursion to build the voting tree. 
			The key point is to consider the child node as the root node of the subset.*/
            Build(p->Next[p->ChildNum++], j+1, k+1);
		}
		else error++;
	}
}

/*********************************************************************************************/
/*Vote*/
void Vote(SearchTreeADT p)
{
    int i;
	if (p->ChildNum == 0)
    {
    	/*Ignore the effects of the nodes with level less than 3.
		As similar problems are meaningful only when the number of points is at least 3.*/
        if (p->Level > 2)
        {
        	table[(p->p1-1)*n2+(p->p2-1)] += 1;	
			while (p->Last->Level >= 1)
        	{
        		/*When reaching the leaf, 
				a new path has been found, in other word, 
				the path number of every ancestors of this leaf
				should plus 1.*/
				table[(p->Last->p1-1)*n2+(p->Last->p2-1)] += 1;	
				p = p->Last;	
			}
		}
    }
    /*Recursion is also used.
	Consider the child node as the root node of the subset
	and then repeat the process.*/
    else 
    {
        for (i = 0; i < p->ChildNum; i++)
            Vote(p->Next[i]);
    }
}

/*********************************************************************************************/
/*PrintVote*/
void PrintVote(void)
{
	int i, j;
	for (i = 0; i < n1; i++)
	for (j = 0; j < n2; j++)
	{
		printf("%4d ", table[i*n2+j]);
		if (j == (n2-1)) printf("\n");
	}
}

/*********************************************************************************************/
/*NotIn*/
bool NotIn(struct board a, int x)
{
	/*To judge whether the integer x is in the integer array a.data[MaxSize].*/
	if (!a.length) //There is no integer stored in the a.data[MaxSize] yet.
		return true;
	else
	{
		int i, flag = 0;
		for (i = 0; i < a.length; i++)
		{
			if (x == a.data[i])
			{
				flag = 1;
				break;	
			}	
		}
		if (flag) return false;
		return true;		
	}
}

/*********************************************************************************************/
/*In*/
void In(int t, int x)
{
	/*Add the integer x to the integer array a.data[MaxSize].*/
	if (t == 0)
		a.data[a.length++] = x; //t=0 represents a.data[MaxSize].
	else if (t == 1)
		b.data[b.length++] = x; //t=1 represents b.data[MaxSize].
}

/*********************************************************************************************/
/*Insert*/
SearchTreeADT Insert(SearchTreeADT p, int x, int y)
{
	/*In this part, the data structure SearchTreeADT is used as a linked list.
	When a node is to be inserted, considering the value of p1 & p2 of this node,
	it will be added at the front of the list, in the middle of the list
	or at the end of the list.*/
	SearchTreeADT temp = (SearchTreeADT)malloc(sizeof(struct SearchTreeCDT));
    int i;
    for (i = 0; i < MaxSize; i++)
        temp->Next[i] = NULL;
    temp->p1 = x;
    temp->p2 = y;
    if (!p->Next[0]) //No node has been connected. temp is added at the top.
        p->Next[0] = temp;
    else
    {
        SearchTreeADT obj = p->Next[0], buffer = Create();
        if (obj->p1 > temp->p1)
        {
			/*The node is priority to all the other nodes,
			so it is added right after the root.*/
			if (obj->p2 < temp->p2) return p; /*obj->p1 > temp->p1, but obj->p2 < temp->p2, 
											  it means there is a conflict, so the temp should not be added.*/
			temp->Next[0] = p->Next[0];
            p->Next[0] = temp;
        } else
        {
            /*move the node obj*/
			while (obj->p1 < temp->p1)
            {
                buffer = obj;
                obj = obj->Next[0];
                if (!obj) break;
            }
            if (!obj) //obj=NULL, temp is added to the end of the list.
            {
                if (buffer->p2 > temp->p2) return p;
				buffer->Next[0] = temp;
                free(obj);
            } else 
            {
                if (obj->p2 < temp->p2 || buffer->p2 > temp->p2) return p;
 				/*temp is added btween the two nodes.*/
				temp->Next[0] = obj;
                buffer->Next[0] = temp;
			}
        }
    }
    return p;
}

/*********************************************************************************************/
/*Greedy*/
SearchTreeADT Greedy(void)
{
	/*For each circulation, find the eligible nodes who has the maximum number of electors
	and choose it as a match, when the circulation is over, we will get one or a few results.
	For the 'one result' circumstance, it is the answer;
	But for the 'a few results' condition, futher discussion has to be taken.*/
	
	int i, j, x, y, Max;
	a.length = b.length = 0;
    SearchTreeADT p = Create();
	
	while (true)
	{
		Max = 0; //Max is used to store the maximum of the vote number of the node.
		for (i = 0; i < n1; i++)
		{
			if (!NotIn(a, i)) continue;
			for (j = 0; j < n2; j++)
			{	
				if (!NotIn(b, j)) continue;
				if (Max < table[i*n2+j])
				{
					Max = table[i*n2+j]; //Find the maximum vote value of each term.	
					x = i; //Use x to store i in case it may be used later.
					y = j; //Use y to store j in case it may be used later.
				}      
			}	
		}
		if (Max)
		{
			In(0, x); //Insert x into board a.
			In(1, y); //Insert y into board b.
			p = Insert(p, x+1, y+1); //Insert node (x+1, y+1) to the list p;				
		}
		else
		{
			/*If Max is equal to 0, it means there is no node available on the table, 
			or the rest of the nodes on the table has the vote value 0. 
			Both of the conditions won't make progress any more.
			So it is time to terminate.*/
			break;
		}
	}
	return p;
}

/*********************************************************************************************/
/*PrintAnswer*/
void PrintAnswer(SearchTreeADT p)
{
	/*In this project, the answer is printed in increasing order.*/
	p = p->Next[0];
	while (p)
	{
		printf("(%d, %d)\n", p->p1, p->p2);
		p = p->Next[0];
	}
}
