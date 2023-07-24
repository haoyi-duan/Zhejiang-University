









# Project 3 - Beautiful Subsequence - Report

#### Group 5 (Zhai, Duan and Chen) Date: 2021-5-1







## Algorithm Specification

### Overview

------

The algorithm consists of the following three steps:

1. Read in the data.
2. Use Dynamic-Programming to compute the number **"ans"** of subsequences that don't meet the requirement of the question.
4. Subtract the total number of the subsequences from **"ans"** to get the answer, and output the final answer.

### Definition

------

To start with, let's have a rough sketch of some significant definitions in the code.

| name | value            | description                                                  |
| ---- | ---------------- | ------------------------------------------------------------ |
| MAXN | $1\times10^5+20$ | The maximum number of the positive integers is $1\times10^5$. |
| MAXV | $1\times10^5+10$ | The maximum upper bound of the interval.                     |
| SIZE | $1\times10^7+20$ | The number of maximum nodes in the segment tree.             |
| mod  | $1\times10^9+7$  | Since the answer might be too large, output the result modulo $1\times10^9+7$. |
| ll   | *long loog*      | ll is used to store big number.                              |

### Data Structure

------

The following structure is used in the code:

```c
struct node {
	int left, right;
	ll data;
} segment[SIZE];
```

As you can see, it is the structure of **Segment Tree**. Under this circumstance, the meaning of the structure is that, of all the subsequences that are currently found, there is a "**data**" number of sequences where the **value** of the **last element** is in **[left, right]**.

### Data Read-in

------

This stage comprises the following steps:

1. Read in two positive integers **n** and **m**, which represents the length of the sequence and the maximum difference of the 2 neighbors in a beautiful subsequence, respectively.
2. Read-in the sequence containing **n** integers in the next line. The sequence is stored in the integer array **a[MAXN]**.

### The *build* function

------

*build* function initializes the segment tree. All the number of sequences where the value of the last element is in $[left^*, right^*]$ is set as 0.

```c
void build(int i, int left, int right){
	segment[i].left = left;
	segment[i].right = right;
	segment[i].data = 0;
	
	if(left == right) return;
	
	int mid = (left + right) / 2;
	build(i * 2, left, mid);
	build(i * 2 + 1, mid + 1, right);
}
```

As we can see in the above code, every time we call the function $build$, we set the section [left, right] and set the data as 0. Then we calculate ***(left + right)/2*** as mid, and divide the section into two parts, [left, mid] and [mid+1, right], call *build* respectively, until left equals to right.

Take the result of build(1, 1, 7) as an example, which may help you get a better understanding.

![image-20210501173713751](C:\Users\lenovo\AppData\Roaming\Typora\typora-user-images\image-20210501173713751.png)

***build* calls in the *main***

```c
build(1, 1, MAXV);
```

### The *query* function

------

The *query* function is used to get the number of subsequences where the value of the last element is in [left, right], of all the answers that are currently found.

In this function, first we need to do some judges:

1. If left > right, there is absolutely no subsequences in the section, so return 0.
2. If there is no intersection between **[left, right]** and **[segment[i].left, segment[i].right]**, exit.
3. If **[left, right]** is equal to **[segment[i].left, segment[i].right]**, that means segment[i].data is exactly what needs to return.
4. Otherwise, we need to do the recursion through the tree until we find the answer. The integer **mid** here is to judge whether the answer is in the left child or the right child, or both.

```c
int mid = (segment[i].left + segment[i].right) / 2;
if(right <= mid) return query(i * 2, left, right) % mod;
if(left > mid) return query(i * 2 + 1, left, right) % mod;
return (query(i * 2, left, mid) + query(i * 2 + 1, mid + 1, right)) % mod;
```

***query* calls in main**

```c
dp[i] = ((query(1, 1, a[i] - m - 1) + query(1, a[i] + m + 1, MAXV)) % mod + 1) % mod;
```

Each time in the for-loop begins from 0 to n, **dp[i]** means the number of subsequences with a[i] as their last element that meet the requirement. If the distance between a[i] and its neighbor is lager than m, that is what we need, and that is **query(1, 1, a[i] - m - 1)** and **query(1, a[i] + m + 1, MAXV)**. 

Furthermore, the **a[i]** itself does not meet the requirement, so we **add 1** at the end.

Since the answer might be too large, also remember to modulo the result by $1\times10^9+7$.

### The *add* function

------

The function of $add$ is to update the data in the segment tree.

1. if the **point**, **which is a[i]**, does not in the section **[segment[i].left, segment[i].right]**, there is nothing we need to update, so just return.

```c
if(segment[i].right < point || segment[i].left > point) return;
```

### Data output

------

After we calculate the number of subsequences that  don't meet the requirement of the question, in other word, **ans**. As we known, the total number of the subsequences of a sequence with length **n** is $2^n-1$. So with the following code, we can obtain the final answer print  it.

```c
ll total = 1;
for(int i = 0; i < n; i++) total = (total << 1) % mod;
printf("%lld", total - ans - 1);
```

## Analysis and Comments

First we restate the great effect that Segment Tree has made in this project, without witch the time complexity could be $O(n^2)$. The Segment Tree stores the answer dp[i] in the nodes in advance so that we don't need to do a $O(n)$ time complexity search every time we calculate dp[i]. As the Segment Tree is a binary-tree, the search complexity is $O(\log n)$.

### **Time Complexity**

- ------

  **Data Read-in**

  Reading each positive integer takes $O(1)$ time, amounting to $O(n)$ in total.

- **Build**

  As is mentioned before, the Segment Tree is a kind of binary tree, so the initialization of a segment tree with x nodes needs $O(x)$ complexity. Under this circumstance, the maximum upper bound is **MAXV**, so the height of the tree is $log(MAXV)$, the number of nodes is **2<sup>(log(MAXV)-1)</sup>​**, witch is approximately **MAXV**. So the time complexity of this part is $O(MAXV)$.

- **Query**

  The job of *query* is basically searching in a binary tree. So the time complexity is $O(height)$. In this project, we call query(1, 1, a[i] - m - 1) and query(1, a[i] + m + 1, MAXV), so in each for-loop, the time complexity is $O(log (a[i]-m-2)) + O(log(MAXV-a[i]-m-1))$.

- **Add**

  Same as *query*, do the binary search in the segment tree. But every time it search from the root, so the time complexity of this part is $O(MAXV)$.

In main, the functions query and add is called like this:

```c
for(int i = 0; i < n; i++) {
	dp[i] = ((query(1, 1, a[i] - m - 1) + query(1, a[i] + m + 1, MAXV)) % mod + 1) % mod;
	ans = (ans + dp[i]) % mod;
	add(1, a[i], dp[i]);
}
```

For each loop, the time complexity is $max(O(log (a[i]-m-2)) + O(log(MAXV-a[i]-m-1)), O(MAXV))=O(MAXV)$. So, for n loops, the time complexity is $O(n\times MAXV)$.

**To sum up, the total time complexity consists of three parts: data read-in, build, and for-loop, witch is $O(n)+O(MAXV)+O(n\times MAXV)$.**

### Space Complexity

------

- **Sequence**

  The sequence consists of n positive integers is stored in the integer array **a[MAXN]**. Hence the space complexity is $O(MAXN)$.

- **Number of Subsequences**

  dp[MAXN] is an integer array. The number of subsequences with a[i] as their last element is stored in dp[i]. So the complexity is $O(MAXN)$.

- **Structure** 

  The data structure is used to store the segment tree with $SIZE$ nodes. So the space complexity is $O(SIZE)$.

Summing up, we have a space complexity of $O(SIZE)$.

