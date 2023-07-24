#include<stdio.h>
#include<stdlib.h>
#include<math.h>

#define MAXN 100020
#define MAXV (1e5+10)
#define SIZE 10000020
#define mod 1000000007

#define ll long long

struct node { /* �߶��������ݽṹ��������Ŀǰ�ҵ����������У�
                 ĩβԪ��ֵ������[left, right]�����ڵ�������data��. */ 
	int left, right;
	ll data;
} segment[SIZE];
/* ��ʼ��һ�������ΪMAXV���߶�����data�ĳ�ʼֵ��Ϊ0. */ 
void build(int i, int left, int right){
	segment[i].left = left;
	segment[i].right = right;
	segment[i].data = 0;
	
	if(left == right) return;
	
	int mid = (left + right) / 2;
	build(i * 2, left, mid);
	build(i * 2 + 1, mid + 1, right);
}
/* �����������dp[i]�ӵ��߶�������Ӧλ��. */
void add(int i, int point, int inc){
	if(segment[i].right < point || segment[i].left > point) return; /* �����ǰ��ĩβԪ�ز���[segment[i].left, segment[i].right]�ڣ��ͷ���. */
	
	segment[i].data = (segment[i].data + inc) % mod; /* ��dp[i]�ӵ���ǰ��node. */
	
	if(segment[i].left == point && segment[i].right == point) return; /* ����ߵ�Ҷ�ӽ�㣬����. */
	
	/* û���ߵ�Ҷ�ӽ�㣬��Ҫ�ݹ飬ȷ���ӽ���dataֵҲ������. */
	if (point <= (segment[i].left + segment[i].right) / 2) add(i * 2, point, inc);
	else add(i * 2 + 1, point, inc);
}
/* ����[left, right]�����dataֵ. */ 
int query(int i, int left, int right){
	if(left > right) return 0; /* ��Ч���䣬ֱ�ӷ���0. */ 
	if(segment[i].right < left || segment[i].left > right) exit(7); /* ���䲻�ڷ��ʷ�Χ�ڣ�����. */ 
	if(segment[i].left == left && segment[i].right == right) return segment[i].data; /* ����պ���ҪѰ�ҵ����䣬ֱ�ӷ���data. */ 
	
	/* ͨ���Ƚ�Ѱ�������뵱ǰ�������Ĺ�ϵ��
	   ����֮��ݹ�Ĳ���. */
	int mid = (segment[i].left + segment[i].right) / 2;
	if(right <= mid) return query(i * 2, left, right) % mod;
	if(left > mid) return query(i * 2 + 1, left, right) % mod;
	return (query(i * 2, left, mid) + query(i * 2 + 1, mid + 1, right)) % mod;
}

ll dp[MAXN] = { 0 }; /* �洢��������Ŀ�����������и���������.
                        dp[i]�ĺ����ǣ��ڵ�ǰѰ�ҵ��������У�ĩβԪ��ֵ��a[i]�������и���. */

int main(){
	int n, m, a[MAXN];
	scanf("%d %d", &n, &m);
	for(int i = 0; i < n; i++) scanf("%d", &a[i]); /* ��n��������Ԫ�ض�������a[MAXN]��. */
	
	build(1, 1, MAXV);
	
	ll ans = 0;
	for(int i = 0; i < n; i++) {
		/* dp[i]�������������������У�a[i]��ǰһ��Ԫ����֮����Ҫ����m. */ 
		dp[i] = ((query(1, 1, a[i] - m - 1) + query(1, a[i] + m + 1, MAXV)) % mod + 1) % mod;
		/* ans������ǰ����Ĳ����������Ĵ�����. */
		ans = (ans + dp[i]) % mod;
		/* ������ѭ�������dp[i]�����߶��������λ�ã��������ѭ���ܹ�ֱ��ȡ��ʹ��. */ 
		add(1, a[i], dp[i]);
	}
	
	ll total = 1;
	for(int i = 0; i < n; i++) total = (total << 1) % mod;
	/* total-1=2^n-1, ��ΪnԪ���е���������������ȥ��������������������ans���͵ó������ս�. */
	printf("%lld", total - ans - 1);
}

