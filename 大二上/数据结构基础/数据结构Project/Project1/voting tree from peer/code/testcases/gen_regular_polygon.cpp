#include<iostream>
#include<cstdio>
#include<cmath>
#include<cstring>
#include<algorithm>
#define ll long long
using namespace std;
int main()
{
	long double pi=acos(-1.0);
	int n;long double len1,len2;
	cin>>n>>len1>>len2;
	long double angle=2.0*pi/n;
	freopen("time_test10.txt","w",stdout);
	long double x=0,y=0,anx=0;
	cout<<n<<" "<<n<<endl;
	for(int i=1;i<=n;i++)
	{
		printf("%.15Lf %.15Lf\n",x,y);
		x=x+len1*cos(anx);
		y=y+len1*sin(anx);
		anx-=angle;
	}
	x=233,y=233,anx=1;
	for(int i=1;i<=n;i++)
	{
		printf("%.15Lf %.15Lf\n",x,y);
		x=x+len2*cos(anx);
		y=y+len2*sin(anx);
		anx-=angle;
	}
}

