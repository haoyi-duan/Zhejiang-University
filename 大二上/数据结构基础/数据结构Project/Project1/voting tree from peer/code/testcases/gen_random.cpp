#include<iostream>
#include<cstdio>
#include<cmath>
#include<cstring>
#include<algorithm>
#include<ctime>
#define ll long long
using namespace std;
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
}a[105];
int num[105],cou[105];
bool vis[105];
int main()
{
	srand(time(0));
	long double pi=acos(-1.0);
	int n,m,inv;long double len1,len2;
	cin>>n>>m>>inv>>len1>>len2;
	long double angle=2.0*pi/n;
	//freopen("random10.txt","w",stdout);
	long double x=332,y=332,anx=2.33;
	cout<<n<<" "<<n<<endl;
	for(int i=1;i<=n-m;i++)
	{
		num[i]=rand()%m+1;
		while(cou[num[i]]==inv-1) num[i]=rand()%m+1;
		cou[num[i]]++;
	}
	for(int i=1;i<=m;i++)
	{
		a[i].x=x;a[i].y=y;
		printf("%.15Lf %.15Lf\n",x,y);
		x=x+len1*cos(anx);
		y=y+len1*sin(anx);
		anx-=angle;
		if(i==m) x=a[1].x,y=a[1].y;
		memset(vis,0,sizeof(vis));
		for(int j=1;j<=cou[i];j++)
		{
			int x=rand()%(inv-1)+1;
			while(vis[x]) x=rand()%(inv-1)+1;
			vis[x]=1;
		}
		for(int j=1;j<=inv-1;j++)
		{
			if(vis[j])
			{
				printf("%.15Lf %.15Lf\n",a[i].x+(x-a[i].x)/inv*j,a[i].y+(y-a[i].y)/inv*j);
			}
		}
	}
	x=233,y=233,anx=1;
	memset(cou,0,sizeof(cou));
	for(int i=1;i<=n-m;i++)
	{
		num[i]=rand()%m+1;
		while(cou[num[i]]==inv-1) num[i]=rand()%m+1;
		cou[num[i]]++;
	}
	for(int i=1;i<=m;i++)
	{
		a[i].x=x;a[i].y=y;
		printf("%.15Lf %.15Lf\n",x,y);
		x=x+len2*cos(anx);
		y=y+len2*sin(anx);
		anx-=angle;
		if(i==m) x=a[1].x,y=a[1].y;
		memset(vis,0,sizeof(vis));
		for(int j=1;j<=cou[i];j++)
		{
			int x=rand()%(inv-1)+1;
			while(vis[x]) x=rand()%(inv-1)+1;
			vis[x]=1;
		}
		for(int j=1;j<=inv-1;j++)
		{
			if(vis[j])
			{
				printf("%.15Lf %.15Lf\n",a[i].x+(x-a[i].x)/inv*j,a[i].y+(y-a[i].y)/inv*j);
			}
		}
	}
}

