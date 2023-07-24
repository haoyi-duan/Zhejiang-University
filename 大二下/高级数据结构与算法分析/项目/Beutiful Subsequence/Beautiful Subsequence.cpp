#include<stdio.h>
#include<stdlib.h>
#include<math.h>

#define MAXN 100020
#define MAXV (1e5+10)
#define SIZE 10000020
#define mod 1000000007

#define ll long long

struct node { /* 线段树的数据结构，代表在目前找到的子序列中，
                 末尾元素值处于在[left, right]区间内的序列有data个. */ 
	int left, right;
	ll data;
} segment[SIZE];
/* 初始化一个结点数为MAXV的线段树，data的初始值均为0. */ 
void build(int i, int left, int right){
	segment[i].left = left;
	segment[i].right = right;
	segment[i].data = 0;
	
	if(left == right) return;
	
	int mid = (left + right) / 2;
	build(i * 2, left, mid);
	build(i * 2 + 1, mid + 1, right);
}
/* 将当求出到的dp[i]加到线段树的相应位置. */
void add(int i, int point, int inc){
	if(segment[i].right < point || segment[i].left > point) return; /* 如果当前的末尾元素不在[segment[i].left, segment[i].right]内，就返回. */
	
	segment[i].data = (segment[i].data + inc) % mod; /* 将dp[i]加到当前的node. */
	
	if(segment[i].left == point && segment[i].right == point) return; /* 如果走到叶子结点，返回. */
	
	/* 没有走到叶子结点，需要递归，确保子结点的data值也更新了. */
	if (point <= (segment[i].left + segment[i].right) / 2) add(i * 2, point, inc);
	else add(i * 2 + 1, point, inc);
}
/* 访问[left, right]区间的data值. */ 
int query(int i, int left, int right){
	if(left > right) return 0; /* 无效区间，直接返回0. */ 
	if(segment[i].right < left || segment[i].left > right) exit(7); /* 区间不在访问范围内，报错. */ 
	if(segment[i].left == left && segment[i].right == right) return segment[i].data; /* 如果刚好是要寻找的区间，直接返回data. */ 
	
	/* 通过比较寻找区间与当前结点区间的关系，
	   决定之后递归的策略. */
	int mid = (segment[i].left + segment[i].right) / 2;
	if(right <= mid) return query(i * 2, left, right) % mod;
	if(left > mid) return query(i * 2 + 1, left, right) % mod;
	return (query(i * 2, left, mid) + query(i * 2 + 1, mid + 1, right)) % mod;
}

ll dp[MAXN] = { 0 }; /* 存储不满足题目条件的子序列个数的数组.
                        dp[i]的含义是：在当前寻找的子序列中，末尾元素值是a[i]的子序列个数. */

int main(){
	int n, m, a[MAXN];
	scanf("%d %d", &n, &m);
	for(int i = 0; i < n; i++) scanf("%d", &a[i]); /* 将n个正整数元素读入数组a[MAXN]中. */
	
	build(1, 1, MAXV);
	
	ll ans = 0;
	for(int i = 0; i < n; i++) {
		/* dp[i]：不满足条件的子序列，a[i]的前一个元素与之距离要大于m. */ 
		dp[i] = ((query(1, 1, a[i] - m - 1) + query(1, a[i] + m + 1, MAXV)) % mod + 1) % mod;
		/* ans存贮当前求出的不满足条件的答案总数. */
		ans = (ans + dp[i]) % mod;
		/* 将本次循环求出的dp[i]放入线段树的相对位置，方便后面循环能够直接取出使用. */ 
		add(1, a[i], dp[i]);
	}
	
	ll total = 1;
	for(int i = 0; i < n; i++) total = (total << 1) % mod;
	/* total-1=2^n-1, 即为n元序列的子序列总数，减去不满足条件的子序列数ans，就得出了最终解. */
	printf("%lld", total - ans - 1);
}

