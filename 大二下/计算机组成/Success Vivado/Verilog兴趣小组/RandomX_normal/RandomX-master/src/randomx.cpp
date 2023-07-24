#include <iostream>

int m[16] = { 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15 };
int v[16] = { 8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23 };

void print(){
	for(int i=15;i>=0; --i)
		printf("%02x ", v[i]);
	printf("\n");
}

void printG(int i, int& a, int& b, int& c, int& d){
	a = (a+b+m[2*i+0])%256;
	d = (d^a)%256;
	c = (c+d)%256;
	b = (b^c)%256;
	a = (a+b+m[2*i+1])%256;
	d = (d^a)%256;
	c = (c+d)%256;
	b = (b^c)%256;
	print();
}

int main(){
	print();
	printG(0, v[0], v[4], v[8],  v[12]);
	printG(1, v[1], v[5], v[9],  v[13]);
	printG(2, v[2], v[6], v[10], v[14]);
	printG(3, v[3], v[7], v[11], v[15]);
	printG(4, v[0], v[5], v[10], v[15]);
	printG(5, v[1], v[6], v[11], v[12]);
	printG(6, v[2], v[7], v[8],  v[13]);
	printG(7, v[3], v[4], v[9],  v[14]);
	
	system("pause");
	return 0;
} 


