/*
Project 2. The 2nd-shortest path

Key point: the algorithm is based on Dijkstra Agorithm. 
We need to find the shortest and the 2nd-shortest paths at the same time.
If there are M points in tatal, then we have to find the 2nd-shortest path
from 1 to M. 
*/

#include <stdio.h>
#include <stdlib.h>

/*
The max num of the vertexs.
*/
#define MaxVertexNum     1001

/*
The MaxRailwayNum of the total graph. 
*/ 
#define MaxRailwayNum    5001 

/*
Use negative number -1 to represent the length of a path is infinity.
*/
#define Infinity         -1

/*
define Vertex as a type to represent the serial number of vertex.
*/
typedef int Vertex;

/*
The struct PtrToAdjVNode is used to store the next point Adjv,
and the length as well.
*/
typedef struct AdjVNode PtrToAdjVNode; 
struct AdjVNode{
    Vertex AdjV;
    int Length;
};

/*
The struct Graph, is used to record the infomation of each point,
which consists of the edges of each node,
and the total number of edges of each node.
*/
typedef struct VNode Graph;
struct VNode{
    PtrToAdjVNode Edge[MaxVertexNum];
    int RailwayNum;
};

/*
The struct List is used to record the shortest and the 2nd-shortest path.
Meanwhile, it also has the function of recording the last points of 
both the shortest and the 2nd-shortest path, respectively.
*/
typedef struct ShortestDistance List; 
struct ShortestDistance{
	int Shortest;
	int Last;
	int Shortest_2nd;
	int Last_2nd;
	int path[MaxVertexNum];
	int path_2nd[MaxVertexNum+2];
};

int main ()
{
	/*
	M: The number of Vertex;
	N: The number of total railways;
	i: used in for-loop. 
	*/
	int M, N, i;
	scanf("%d %d", &M, &N);
	
	/*
	The integer array Queue[N+1] is a circular queue used to store the vertex
	when serching the graph using greedy algorithm.
	It has the basic functions: enqueue and dequeue.
	Moreover, the integers front and rear is used to point at 
	the location of the latest point in the queue and the oldest point remains in the queue. 
	*/
	int Queue[N+1];
	int front, rear;
	front = rear = 0;
	
	/*
	Dis[M+1] here is used to record the infomation of the shortest path
	of each vertex. First, initialize the Dis[1].shortest and the Dis[1].shortest_2nd as 0,
	Dis[1].Last and Dis[1].Last_2nd are initialized as 1. 
	*/
	List Dis[M+1];
	Dis[1].Shortest = 0;
	Dis[1].Shortest_2nd = 0;
	Dis[1].Last = 1;
	Dis[1].Last_2nd = 1;
	
	/*
	Initialize the RailwayNum of railways of each vertex as 0.
	*/
	Graph A[M+1];
	for (i = 0; i < M+1; i++)
		A[i].RailwayNum = 0;
	
	/*
	Initialize both the lengths of the shortest and 2nd-shortest paths 
	from 1 to each vertex as infinity, -1. 
	*/
	for (i = 2; i < M+1; i++)
	{
		Dis[i].Shortest = Infinity;
		Dis[i].Shortest_2nd = Infinity;
	}
	
	/*
	In this N-for-loop, the inputs are the vertex a, b, and the distance between them.
	Then store these information in the Graph A[M+1].
	*/
	
	/*
		indexa: used to store the value of the RailwayNum of the vertex a;
		indexb: used to store the value of the RailwayNum of the vertex b;
		*/
		int a, b, dis, indexa, indexb;
		
	for (i = 0; i < N; i++)
	{
		
		scanf("%d %d %d", &a, &b, &dis);
		
		indexa = A[a].RailwayNum;
		indexb = A[b].RailwayNum;
		
		A[a].Edge[indexa].AdjV = b;	
		A[a].Edge[indexa].Length = dis;
	
		A[b].Edge[indexb].AdjV = a;
		A[b].Edge[indexb].Length = dis;
		
		A[a].RailwayNum++;
		A[b].RailwayNum++;
	}
	
	Queue[front] = 1;
	front++;
	front%=(N+1);	
	
	/*
	temp: store the former value of the shortest path of the point.
	temp_2nd: store the former value of the 2nd-shortest path of the point. 
	point: The point which we are going to deal with.
	distance: the distance from the former point to the point we are going to deal with.
	last: The fomer point.
	*/
	int temp, temp_2nd, point, distance, last; 
	int board[M+1];
	for (i = 0; i < M+1; i++) 
		board[i] = 0;
	/*
	front != rear means the queue is not empty,
	so the circulation is not going to stop. 
	*/
	
	if (M <= 2) 
	{
		printf("%d 1 2 1 2\n", 3*dis);
		system("pause");
		return 0; 	
	}
	
	while(front != rear)
	{	
		last = Queue[rear];
		
		/*
		if the RailwayNum is happens to be 0,
		then we don't have to do anything,
		what we only need to do is to skip it. 
		*/
		if (A[last].RailwayNum != 0)
		{
			/*
			Do the circulation to traverse the next stations of the point "last".
			The total number of the next station is A[last].RailwayNum.
			*/
			for (i = 0; i < A[last].RailwayNum; i++)
			{
				/*
				point and distance are used to store the adjv and length of the last vertex.
				*/
				point = A[last].Edge[i].AdjV;
				distance = A[last].Edge[i].Length;
				
				temp = Dis[point].Shortest;
				temp_2nd = Dis[point].Shortest_2nd;
				if (board[point] == 1)
				{
					continue;
				}
				/*
				If temp is Infinity, means it is the fist time to pass through the point,
				so, any result is considered as the shortest path.
				*/
				if (temp == Infinity && temp_2nd == Infinity) 
				{
					Dis[point].Shortest = distance + Dis[last].Shortest;
					Dis[point].Last = last;
				}
				
				/*
				If temp_2nd is Infinity, means the 2nd-shortest path has not been found.
				so, any result is considered as the 2nd-shortest path.
				But what deserves your attention is that further conparison of
				the 2nd-shortest path and the shortest path is need,
				maybe we have to swap the values of the two.
				*/
				else if (temp != Infinity && temp_2nd == Infinity)
				{
					if (point == M)
					{
						if (temp == distance + Dis[last].Shortest)
						{
							Queue[front] = point;
							front++;
							front%=(N+1);
							continue;
						}
					}
					
					Dis[point].Shortest_2nd = distance + Dis[last].Shortest;
					Dis[point].Last_2nd = last;
					
					/*
					shortest > shortest_2nd,
					swap is needed.
					*/
					if (Dis[point].Shortest > Dis[point].Shortest_2nd)
					{
						int buffer = Dis[point].Shortest;
						Dis[point].Shortest = Dis[point].Shortest_2nd;
						Dis[point].Shortest_2nd = buffer;
					
						buffer = Dis[point].Last;
						Dis[point].Last = Dis[point].Last_2nd;
						Dis[point].Last_2nd = buffer;
					} 
					
					/*
					If shortest <= shortest_2nd,
					then traceback is needed to change the value of the last_2nd
					for every vertex in the path.
					*/
					else 
					{
						int obj = last;
						while (1)
						{
							Dis[obj].Last_2nd = Dis[obj].Last;
							obj = Dis[obj].Last;
							if (obj == 1) break;	
						} 	
					}
				}
				
				/*
				If temp_2nd > the distance in the present,
				swap is needed.
				*/
				else if (temp_2nd > distance + Dis[last].Shortest)
				{
					if (point == M)
					{
						if (temp == distance + Dis[last].Shortest)
						{
							Queue[front] = point;
							front++;
							front%=(N+1);
							continue;
						}
					}
					
					Dis[point].Shortest_2nd = distance + Dis[last].Shortest;
					Dis[point].Last_2nd = last;
					
					/*
					Judge about the value of the shortest and the shortest_2nd
					in case that swap is needed.
					*/
					if (Dis[point].Shortest > Dis[point].Shortest_2nd)
					{
						int buffer = Dis[point].Shortest;
						Dis[point].Shortest = Dis[point].Shortest_2nd;
						Dis[point].Shortest_2nd = buffer;
					
						buffer = Dis[point].Last;
						Dis[point].Last = Dis[point].Last_2nd;
						Dis[point].Last_2nd = buffer;
					} 
				}
				
				Queue[front] = point;
				front++;
				front%=(N+1);
			}
		}
		rear++;
		rear%=(N+1);
		board[last] = 1;
	}
	
	/*
	The codes below is used to print in the right format.
	TraceBack the path, store the value in an integer array
	and print it out from the opposite order.
	*/
	int length = 0;
	int data[M], adj = M, count = 0;
	for (i = 0; ; i++, adj = Dis[adj].Last_2nd)
	{
		data[i] = Dis[adj].Last_2nd;
		int j;
		for (j = 0; j < M; j++)
		{
			if (A[data[i]].Edge[j].AdjV == adj)
				break;
		}
		count += A[data[i]].Edge[j].Length;
		if (data[i] == 1) break;
	}
	
	/*
	The count represents the distance of the 2nd shortest path.
	Meanwhile, the path is printed with each vertex followed by a "space",
	but no extra space is supposed to occur at the beginning or the end of the line.
	So the last element, M, is printed separately from the others. 
	*/
	printf("%d ", count);
	for (;i >= 0; i--)
		printf("%d ", data[i]);
	printf("%d\n", M);
	
	system("pause"); 
	
	return 0;
}

/*
Test Examples
1:
5 6
1 2 50
2 3 100
2 4 150
3 4 130
3 5 70
4 5 40

2:
3 3
1 2 10
3 2 5
1 3 20

3:
3 3
1 2 10
3 2 5
1 3 10

4:
6 7
1 2 2
2 3 3
2 4 3
4 5 2
3 5 8
5 6 3
3 6 4

5:
2 1
1 2 10

6:
4 5
1 2 10
1 3 10
1 4 20
2 4 10
3 4 14

7:
4 5
1 2 10
1 3 10
2 4 10
3 4 10
1 4 24
*/
