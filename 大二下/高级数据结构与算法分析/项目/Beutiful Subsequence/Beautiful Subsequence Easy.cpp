#include<stdio.h>
#include<stdlib.h>
#include<math.h>

#define MAXN 9999
#define mod 1000000007

#define ll long long

ll dp[MAXN] = { 0 };

int findNBS(int *a, int end, int diff){
	ll temp = 0;

	for(int i = 0; i < end; i++){
		if(abs(a[end] - a[i]) > diff) temp = (temp + dp[i]) % mod;
	}
	
	return (temp + 1) % mod;
}

int main(){
	int n, m, a[MAXN];
	ll ans = 0;
	scanf("%d %d", &n, &m);
	for(int i = 0; i < n; i++) scanf("%d", &a[i]);
	
	for(int i = 0; i < n; i++) {
		dp[i] = findNBS(a, i, m);
		ans = (ans + dp[i]) % mod;
		printf("%d:%d\n", i, dp[i]);
	}
	
	ll total = 1;
	for(int i = 0; i < n; i++) total = (total << 1) % mod;
	printf("%d %d\n", total, ans);
	printf("%lld", total - ans - 1);
}

/*
4 2
5 3 8 6
*/ 

