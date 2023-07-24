#include<stdio.h>
#include<string.h>
#include<time.h>
#include<windows.h>

#define MAXN 102
#define MAXID 1002

#define FASTER_VERSION

struct fruit_array{
	int p, value;
	int fruit[MAXN];
} maxPath, curPath, v[MAXID];

int K, N;
int mark[MAXID]={0};
int dp[MAXN] = {0};
unsigned int ind[MAXN];

void min_sort(unsigned int *a, int n){
	for(int i = 0; i < n; i++){
		int mini = i;
		for(int j = i + 1; j < n; j++){
			if(a[j] < a[mini]) mini = j;
		}
		int temp = a[i]; a[i] = a[mini]; a[mini] = temp;
	}
}

void dfs(int round) {
    for (int i = round; i <= N + 1; i++) {
    	
        if (i == N + 1) {
	        if (curPath.p > maxPath.p || (curPath.p == maxPath.p && curPath.value < maxPath.value))
	            memcpy(&maxPath, &curPath, sizeof(struct fruit_array)); 
	        break;
	    }
	    
	    int ii = ind[i];

        if (N - i + 1 < maxPath.p - curPath.p
#ifdef FASTER_VERSION
			|| dp[i+1] + 1 < maxPath.p - curPath.p
#endif
			)
		break;
        if (mark[ii] > 0 || v[ii].value <= 0) continue;
        
        curPath.fruit[curPath.p++] = ii;
        curPath.value += v[ii].value;
        for(int it = 0; it < v[ii].p; it++) mark[v[ii].fruit[it]] += 1;
        
        dfs(i + 1);
        
        for(int it = 0; it < v[ii].p; it++) mark[v[ii].fruit[it]] -= 1;
        curPath.value -= v[ii].value;
        curPath.p--;
    }
}

int main() {
	system("color f4");
	maxPath.value = 1e8;
	memset(ind, -1, sizeof(unsigned int)*MAXN);
	
    scanf("%d %d", &K, &N);
    int i1, i2;
    for (int i = 0; i < K; i++) {
        scanf("%d %d",&i1,&i2);
        if(i1 > i2) v[i2].fruit[v[i2].p++] = i1;
        else v[i1].fruit[v[i1].p++] = i2;
    }
    for (int i = 0; i < N; i++) {
        scanf("%d %d",&i1,&i2);
        v[i1].value = i2;
        ind[i+1] = i1;
    }
    min_sort(ind+1, MAXN - 1);
    
    clock_t start, end;
    start = clock();
#ifdef FASTER_VERSION
    for(int i = N; i > 0; i--){
    	dfs(i);
    	dp[i] = maxPath.p;
    	printf("%d done\n", i);
	}
#else 
	dfs(1);
#endif
	end = clock();
	printf("%g secs\n", double(end-start)/CLOCKS_PER_SEC);
    
    printf("%d\n", maxPath.p);
    for (int i = 0; i < maxPath.p; i++) printf("%s%03d", i == 0 ? "" : " ", maxPath.fruit[i]);
    printf("\n%d\n", maxPath.value);
}
