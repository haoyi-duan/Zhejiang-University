#include<iostream>
#include<cstdio>
#include<cmath>
#include<cstring>
#include<algorithm>
#include<ctime>
#define ll long long
using namespace std;
int vis[105],vis2[105];
int main()
{
	srand(time(0));
	long double pi=acos(-1.0);
	int n;long double len1,len2;
	cin>>n;
	long double angle=2.0*pi/n;
	freopen("triangle_point2.txt","w",stdout);
	int num=0,num2=0;
	for(int i=1;i<=n;i++)
	{
		vis[i]=rand()%2;
		if(vis[i]) num++;
	}
	for(int i=1;i<=n;i++)
	{
		vis2[i]=rand()%2;
		if(vis2[i]) num2++;
	 } 
	num+=3;num2+=3;
	cout<<num<<" "<<num2<<endl;
	cout<<"0 0\n0 1\n"<<n+1<<" "<<0<<endl;
	for(int i=n;i;i--)
	{
		if(vis[i]) cout<<i<<" "<<0<<endl;
	}
	cout<<"0 0\n0 1\n"<<n+1<<" "<<0<<endl;
	for(int i=n;i;i--)
	{
		if(vis2[i]) cout<<i<<" "<<0<<endl;
	}
	
	
}

