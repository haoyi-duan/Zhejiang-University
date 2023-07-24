#include<iostream>
#include<cstdio>
#include<cmath>
#include<cstring>
#include<algorithm>
#include<cstdlib>
#include<ctime>
#define MAXN 105
#define pii pair<int,int>
using namespace std;
//It is recommended to read the code and the report at the same time
struct point
{
	double x,y;
	point(double x,double y):x(x),y(y){}//point(x,y)means a point located at (x,y)
	point(){}
	point operator - (const point &a) const
	{
		return point(x-a.x,y-a.y);//subtraction of vectors 
	}
	double operator * (const point &a) const
	{
		return x*a.y-y*a.x;//vector cross product
	}
	double operator ^ (const point &a) const
	{
		return x*a.x+y*a.y;//vector dot product
	}
	double length() const
	{
		return sqrt(x*x+y*y);//vector's length
	}
}a[MAXN*2],b[MAXN*2];//two initial polygons
bool keya[MAXN],keyb[MAXN];//1 if the point is a keypoint of the polygon
int posa[MAXN],posb[MAXN],cnta,cntb,match[MAXN];
/* 
posa,posb:the position of keypoints in a and b
cnta,cntb:the number of keypoints in a and b
match:match[i] means the i-th point in b matches the match[i]-th point in a,0 if the point is not matched.
*/
int voting_tree[MAXN][MAXN];
//voting_tree[x][y] means the maximum matches if we only consider the point numbered larger than x in a and numbered larger than y in b. 
pii path[MAXN][MAXN];
// path[x][y] means the son of node (x,y) in voting trees which has the maximum value.
const double pi=acos(-1.0);
// calculate pi(3.1415926....)
const double eps=1e-6;
//set precision
double angle(const point &x,const point &y)// calculate angle of two vectors
{
	double sinx=(x*y)/x.length()/y.length();//|x*y|=|x||y|sina
	double cosx=(x^y)/x.length()/y.length();//|x^y|=|x||y|cosa
	double ans;//angle
	
	ans=atan2(sinx,cosx);//use arctan to calculate the angle,atan2() can return an angle range [-pi,pi]
	return ans;
}

	
double dis(const point &x,const point &y)//calculate distance from x to y
{
	return sqrt((x.x-y.x)*(x.x-y.x)+(x.y-y.y)*(x.y-y.y));
}
int main()
{
	int n,m;
	scanf("%d%d",&m,&n);//read n and m
	for(int i=1;i<=m;i++)
	{
		scanf("%lf%lf",&a[i].x,&a[i].y);// read a
	}
	for(int i=1;i<=n;i++)
	{
		scanf("%lf%lf",&b[i].x,&b[i].y);// read b
	}
	a[0]=a[m];b[0]=b[n];// decrease some corner cases(a[1],a[m],b[1],b[n])
	a[m+1]=a[1];b[n+1]=b[1];
	double area=0;
	for(int i=1;i<=m;i++)
	{
		area+=a[i]*a[i+1];//if the sum of cross product>0, the input is read in counterclockwise order which is illegal in the statement
	}
	if(area>0)
	{
		puts("please input in clockwise order!");
		return 0;
	}
	area=0;
	for(int i=1;i<=n;i++)
	{
		area+=b[i]*b[i+1];//if the sum of cross product>0, the input is read in counterclockwise order which is illegal in the statement
	}
	if(area>0)
	{
		puts("please input in clockwise order!");
		return 0;
	}
	
	for(int i=1;i<=m;i++)
	{
		if(fabs((a[i-1]-a[i])*(a[i+1]-a[i]))>eps) keya[i]=1,posa[++cnta]=i;
		//if cross product equal to 0, the three points are in the same line,else it is a keypoint
	}
	for(int i=1;i<=n;i++)
	{
		if(fabs((b[i-1]-b[i])*(b[i+1]-b[i]))>eps) keyb[i]=1,posb[++cntb]=i;
		//if cross product equal to 0, the three points are in the same line,else it is a keypoint
	}
	posa[0]=posa[cnta];posb[0]=posb[cntb];// decrease some corner cases(posa[1],posa[cnta],posb[1],posb[cntb])
	posa[cnta+1]=posa[1];posb[cntb+1]=posb[1];
	if(cnta!=cntb)// the number of keypoint is not equal
	{
		puts("invalid input!");
		return 0;// finish the program
	}
	for(int i=1;i<=cnta;i++)
	{
		bool flag=1;//flag:A and B can matched completely
		point a1=a[posa[i]]-a[posa[i+1]];
		point b1=b[posb[1]]-b[posb[2]];//two corresponding lines
		double ratio=b1.length()/a1.length();//similarity ratio
		//cout<<b1.length()<<" "<<a1.length()<<endl;
		//cout<<ratio<<endl;
		for(int j=1;j<=cntb;j++)
		{
			int id=i+j-1;if(id>cnta) id-=cnta;//corresponding nodes in A
			if(fabs(angle(a[posa[id]]-a[posa[id-1]],a[posa[id+1]]-a[posa[id]])
			-angle(b[posb[j]]-b[posb[j-1]],b[posb[j+1]]-b[posb[j]]))>eps)
			//if two angles are different
			{
				flag=0;//illegal
				break;
			}
			if(fabs(dis(b[posb[j]],b[posb[j-1]])-ratio*dis(a[posa[id]],a[posa[id-1]]))>eps)
			//if two lines are not propotional
			{
				flag=0;//illegal
				break;
			}
		}
		if(flag)//if it is a completely matching
		{
			memset(match,0,sizeof(match));//clear match
			//cout<<"ok";
			for(int j=1;j<=cntb;j++)
			{
				int id=i+j-1;//corresponding nodes in A
				match[posb[j]]=posa[id];//posb[j] matches posa[id]
			}
			
			int now=posa[i]+1,pre=posb[1];
			//now:now places of A pre:previous corner node
			for(int j=posb[1]+1;j<=n;j++)
			{
				if(match[j])//corner node
				{
					while(now!=posa[i])//not at the last node
					{
						if(match[j]!=now)//now is not at the next line
						{
							now++;//move now
							if(now>m) now-=m;// because it is a circle,we should change now to 1 if now is larger than m.
						}
						else break;//finished
					}
					pre=j;//change previous corner node
				}
				else
				{
					while(now!=posa[i])// not at the last node
					{
						//cout<<dis(b[j],b[pre])<<" "<< dis(a[now],a[match[pre]])<<endl;
						if(fabs(dis(b[j],b[pre])-dis(a[now],a[match[pre]])*ratio)<eps)
						//at the same point
						{
							match[j]=now;// add a match
							now++;if(now>m) now-=m;
							// because it is a circle,we should change now to 1 if now is larger than m.
						}
						else if(dis(b[j],b[pre])-dis(a[now],a[match[pre]])*ratio>0)
						// a is in front of b
						{
							now++;
							if(now>m) now-=m;
							// because it is a circle,we should change now to 1 if now is larger than m.
						}
						else break;// a is beind b, there is no need to move because now maybe math with other nodes
					}
				}
			}
			for(int j=1;j<posb[1];j++)//corner case: some point in front of posb[1] is not calculated
			{
				while(now!=posa[i])// not at the last node
				{
					if(fabs(dis(b[j],b[pre])-dis(a[now],a[match[pre]])*ratio)<eps)
					//at the same point
					{
						match[j]=now;//add a match
						now++;if(now>m) now-=m;
						// because it is a circle,we should change now to 1 if now is larger than m.
					}
					else if(dis(b[j],b[pre])-dis(a[now],a[match[pre]])*ratio>0)
					{
						now++;
						if(now>m) now-=m;
						// because it is a circle,we should change now to 1 if now is larger than m.
					}
					else break;// a is beind b, there is no need to move because now maybe math with other nodes
				}
			}
			int tmp=0;//vote value
			pre=n+1;// the previous match node
			for(int j=n;j;j--)
			{
				if(!match[j]) continue;//ignore 0
				tmp++;//vote value plus 1
				if(match[j]>match[pre]) tmp=1;// set vote value to 1
				voting_tree[match[j]][j]=tmp;//change voting tree
				if(tmp!=1)
				{
					path[match[j]][j]=pii(match[pre],pre);//change path
				}
				pre=j;//set the previous match node
			}
		}
	}
	pii max_place;//where we can get the answer
	int ans=0;//answer
	for(int i=1;i<=m;i++)
	{
		for(int j=1;j<=n;j++)
		{
			if(ans<voting_tree[i][j])//this place is larger than answer
			{
				ans=voting_tree[i][j];//set answer
				max_place=pii(i,j);//set position
			}
		}
	}
	while(max_place!=pii(0,0))
	{
		printf("(%d, %d)\n",max_place.first,max_place.second);// print the answer
		max_place=path[max_place.first][max_place.second];// walk along the path
	}
	if(ans==0)//means two polygons are not similar
	{
		puts("Two polygons are no similar!");
	}
	return 0;
}
