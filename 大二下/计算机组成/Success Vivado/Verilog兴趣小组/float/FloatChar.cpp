#include <iostream>
#include <string.h>
#include <algorithm>
using namespace std;

int debug = 0;
int binary = 1;

class Float8{
public:
	int s;//1
	int E;//4
	int M;//3
	Float8(int _s, int _E, int _M):s(_s), E(_E), M(_M){}
	void print_F8(){
		Float8 f = *this;
		if(binary){
			cout << f.s;
			int exp[4];
			for(int i=0; i<4; ++i) exp[i] = f.E%2, f.E /= 2;
			cout << exp[3];
			cout << exp[2];
			cout << exp[1];
			cout << '_' << exp[0];
			int frac[3];
			for(int i=0; i<3; ++i) frac[i] = f.M%2, f.M /= 2;
			for(int i=2; i>=0; --i) cout << frac[i];
			cout << endl;
		} else {
			cout << s << " " << E << " " << M << endl;
		}
	}
};


class B1{
public:
	bool is_inf;
	bool is_nan; 
	Float8 big;
	Float8 small;
	bool trueSub;
	int s;
	B1(bool i, bool n, Float8 b, Float8 s, bool sub, int _s):
		is_inf(i), is_nan(n), big(b), small(s), trueSub(sub), s(_s){}
}; 

B1 A1(Float8 a, Float8 b, bool sub){
	Float8 big = a;
	Float8 small = b;
	int change = 0;
	//printf("%d %d", a.s, b.s);
	if(b.E>a.E || (b.E==a.E && b.M>a.M)){ // ��ʾ b �ľ���ֵ���� a �ľ���ֵ 
		swap(big, small);
		change = 1;
	}
	//printf("%d %d", a.s, b.s);
	int s = change? sub^b.s : a.s;
	if(debug) cout << "final sign " << s << endl;
	printf("#%d\n", s);
	bool NanBig = big.E==15 && big.M!=0;
	bool InfBig = big.E==15 && big.M==0;
	
	bool NanSmall = small.E==15 && small.M!=0;
	bool InfSmall = small.E==15 && small.M==0;
	
	if(debug) cout << "nan big " << NanBig << endl;
	if(debug) cout << "nan small " << NanSmall << endl;
	if(debug) cout << "inf big " << InfBig << endl;
	if(debug) cout << "inf small " << InfSmall << endl;
	
	bool trueSub = (!sub&&big.s!=small.s) || (sub&&big.s==small.s);
	if(debug) cout << "true Sub " << trueSub << endl;
	
	
	bool is_nan = NanBig || NanSmall || (trueSub&&InfBig&&InfSmall);// ��ʾ���ս���Ƿ��� NaN
	if(debug) cout << "is nan " << is_nan << endl;
	
	bool is_inf = InfBig || InfSmall;
	if(debug) cout << "is inf " << is_inf << endl;
	
	if(big.E == 0){} // ��ʾ big ���Ƿǹ����
	else big.M += 8; // ��ʾ big �ǹ��������ô�������ص� 1. ��Ҳ�����ڷ����� +8 
	
	if(small.E == 0){}
	else small.M += 8;
	
	if(debug) cout << big.s << " " << big.E << " " << big.M << endl;
	if(debug) cout << small.s << " " << small.E << " " << small.M << endl;
	printf("**%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d**\n", big.E, small.E, big.M, small.M, big.s, small.s, s, change, NanBig, InfBig, NanSmall, InfSmall, trueSub, is_nan, is_inf); 
	return B1(is_inf, is_nan, big, small, trueSub, s);
}

class B2{
public:
	bool is_inf;
	bool is_nan; 
	int large;
	int small;
	int exp;
	int s;
	bool trueSub;
	B2(bool i, bool n, int l, int s, int e, bool sub, int _s):
		is_inf(i), is_nan(n), large(l), small(s), exp(e), trueSub(sub), s(_s){}
}; 

B2 A2(B1 b){
	Float8 big = b.big;
	Float8 small = b.small;
	bool is_inf = b.is_inf;
	bool is_nan = b.is_nan;
	bool trueSub = b.trueSub;
	int sign = b.s;
	
	int exp_diff = big.E - small.E; // ��������
	 
	int shift = (big.E!=0&&small.E==0) ? exp_diff-1 : exp_diff; // ����ǹ�����ͷǹ��������ô����Ĳ���Ҫ -1 
	
	if(debug) cout << "shift " << shift << endl;
	
	int l = (big.M << 3);   // ���ں����������� 
	int s = (small.M << 3) >> shift;
	
	if(debug) cout << "large M " << (l>>3) << " ,small M " << (s>>3) << endl;
	if(debug) cout << "exp big " << big.E << endl;
	
	//printf("**%d %d %d %d**\n", exp_diff, shift, l, s);
	return B2(is_inf, is_nan, l, s, big.E, trueSub, sign);
}


class B3{
public:
	bool is_inf;
	bool is_nan; 
	int result;
	int exp;
	int s;
	B3(bool i, bool n, int r, int e, int _s):
		is_inf(i), is_nan(n), result(r), exp(e), s(_s){}
};
B3 A3(B2 b){
	bool is_inf = b.is_inf;
	bool is_nan = b.is_nan;
	bool trueSub = b.trueSub;
	int large = b.large;
	int small = b.small;
	int exp = b.exp;
	int s = b.s;
	int result;
	if(!trueSub){
		result = large+small;
	} else {
		result = large-small;
	}
	if(debug) cout << "result 1 : " << (result>>3) << endl;
	//printf("result:**%d**\n", result);
	return B3(is_inf, is_nan, result, exp, s);
}

class B4{
public:
	bool is_inf;
	bool is_nan;
	int result;
	int exp;
	int s;
	B4(bool i, bool n, int r, int e, int _s):
		is_inf(i), is_nan(n), result(r), exp(e), s(_s){}
};
B4 A4(B3 b){
	int result = b.result;
	int exp = b.exp;
	int s = b.s;
	bool is_inf = b.is_inf;
	bool is_nan = b.is_nan;
	if((result>>3)&(1<<4)){ // ���Ϊ 15+15������ж� 1<<4��     
	// (1)111 + (1)111 = 11110
	// ����Ȼ 11110 ����һ�����򻯵����������Ҫ����һ�����淶�� 
		result >>= 1;
		exp += 1;
		if(debug) cout << "��Ҫ���� " << " result " << (result>>3) << " exp " << exp << endl; 
	} 
	else {
		if((result>>3)&(1<<3)){ // �Ѿ��ǹ�񻯵�����
			if(exp == 0) exp += 1; // ��������Ƿǹ��������ôҪ�����ɹ���� 
		}
		
		else{
			bool z3 = (result>>3)&(1<<3);
			bool z2 = (result>>3)&(1<<2);
			bool z1 = (result>>3)&(1<<1);
			bool z0 = (result>>3)&(1<<0);
			int shift = 0; // ��Ҫ�ƶ����ٲ��ܱ�ɹ�񻯵�������δ�����ƶ� 
			if(!z3){
				shift += 1;
				if(!z2){
					shift += 1;
					if(!z1){
						shift += 1;
						if(!z0){
							shift += 1;
						}
					}
				}
			}
			//printf("**z3210: %d %d %d %d %d\n", z3, z2, z1, z0, shift);
			cout << shift << endl;
			if(exp > shift){  // ��ʾ���Թ�� 
				if(debug) cout << "��ʾ���Թ��" << endl;
				result <<= shift;
				exp -= shift;
			} else {  // ���ܣ������� 
				if(debug) cout << "���ܣ�������" << endl;
				if(exp != 0){ // ����ӹ�񻯣����絽�ǹ�� 
					result <<= (exp-1); 
				} else {} // �����Ƿǹ�񻯵ģ�����Ҳ�Ƿǹ�񻯣�����Ҫ�ƶ� 
				exp = 0;
			}
		}
	}
	//printf("**%d %d**\n", result, exp);
	return B4(is_inf, is_nan, result, exp, s);
}



Float8 A5(B4 b){
	int result = b.result;
	int exp = b.exp;
	int s = b.s;
	bool is_inf = b.is_inf;
	bool is_nan = b.is_nan;
	
	if(debug) cout << "result 2 " << (result>>3) << " " << (result&7) << endl;
	
	bool last3 = (result&(1<<3))!=0 ? true : false;
	bool last2 = (result&(1<<2))!=0 ? true : false;
	bool last1 = (result&(1<<1))!=0 ? true : false;
	bool last0 = (result&(1<<0))!=0 ? true : false;
	
	//printf("last: %d %d %d %d\n", last3, last2, last1, last0);
	
	if(debug) cout << last2 << !last1 << !last0 << last3 << endl;
	bool carry = (last2&&(last1||last0)) || (last2&& !last1&& !last0&& last3); // ��ż������ 
	
	if(debug) cout << "carry " << carry << endl;
	
	int round_result = (result>>3) + (carry?1:0);

	if(debug) cout << "round_result " << round_result << endl;
	
	int round_exp = exp;
	if(round_result&(1<<4)) round_exp += 1; // ����󣬿��ܳ��ֽ�λ��������� 
											// �����ֽ�λ���Ƿ���Ҫ���ƣ�
											// ����Ҫ����ԭ����Ȼ�� 1111 �Ľ�λ����ô��λ��β�� 0000�������ƶ�
											// ������Ҫ����ԭ����ȻС�ڵ��� 1110����λ��Ҳ����Ҫ�ƶ�β�� 
	
	int over_flow = (exp>=15)|(round_exp>=15) ? 1 : 0; // ��������� 
		
	int final_exp = over_flow==1 ? 15 : round_exp;
	int final_result = over_flow==1 ? 0 : round_result&7;
	if(is_nan){
		final_exp = 15;
		final_result = 7;
		if(debug) cout << "nan" << endl;
	} else if(is_inf){
		final_exp = 15;
		final_result = 0;
		if(debug) cout << "nan" << endl;
	}
	
	//printf("**%d %d %d**\n", s, final_exp, final_result);
	return Float8(s, final_exp, final_result);
}


Float8 A(Float8 a1, Float8 a2, bool sub){
	B1 b1 = A1(a1, a2, sub);
	B2 b2 = A2(b1);
	B3 b3 = A3(b2);
	B4 b4 = A4(b3);
	return A5(b4);
}

void test(int s1, int e1, int m1, int s2, int e2, int m2, bool sub){
	Float8 f1(s1, e1, m1);
	Float8 f2(s2, e2, m2);
	Float8 f3 = A(f1, f2, sub);
	
	f1.print_F8();
	cout << (sub?"   -":"   +") << endl;
	f2.print_F8();
	cout << "   =" << endl;
	f3.print_F8();

	cout << "-----------------------------------------" << endl;
}

//void print_float8(Float8 f){
//	cout << f.s;
//	int exp[4];
//	for(int i=0; i<4; ++i) exp[i] = f.E%2, f.E /= 2;
//	for(int i=3; i>=0; --i) cout << exp[i];
//	int frac[3];
//	for(int i=0; i<3; ++i) frac[i] = f.M%2, f.M /= 2;
//	for(int i=2; i>=0; --i) cout << frac[i];
//	cout << endl;
//}

int main() {
//	test(0, 0, 0, 0, 0, 7,  false); // �ǹ���� + �ǹ���� = �ǹ���� 
//	test(0, 0, 4, 0, 0, 6,  false); // �ǹ���� + �ǹ���� = ����� 
//	test(0, 2, 3, 0, 0, 4, false);  // �ǹ���� + ����� = ����� 
//	test(0, 4, 0, 0, 4, 0, false);  // ����� + ����� = ����� 
//	test(0, 9, 2, 0, 4, 7, false);  // ������ + С����� = ������  
//	test(0, 14, 3, 0, 14, 5, false); // ������ + ������ = ����� 
//	test(0, 15, 0, 0, 0, 5, false);  // ����� + �ǹ���� = ����� 
//	test(0, 13, 7, 0, 15, 0, false); // ����� + ����� = ����� 
//	test(0, 15, 1, 0, 0, 0, false); // Inf + �ǹ���� = Inf 
//	test(0, 2, 1, 0, 15, 2, false); // Inf + ����� = Inf 
//	test(0, 15, 3, 0, 15, 2, false); // Inf + Inf = Inf 
//	
//	test(0, 12, 6, 0, 9, 4, false); // �ٽ��λ 
//	test(0, 12, 3, 0, 9, 4, false); // �ٽ粻��λ 
//
//
//	test(0, 0, 2, 0, 0, 5,  true);  // �ǹ���� - �ǹ���� = ��
//	test(1, 0, 2, 0, 0, 5,  true);  // �ǹ���� - �ǹ���� = ��
//	test(0, 0, 6, 0, 0, 1,  true);  // �ǹ���� - �ǹ���� = �� 
	test(0, 0, 6, 1, 0, 1,  true);  // �ǹ���� - �ǹ���� = ��
//	
//
//	test(0, 1, 2, 0, 0, 7,  true);  // ����� - �ǹ���� = ��
//	test(0, 2, 0, 0, 1, 7,  true);  // ����� - ����� = ��
//	test(1, 9, 3, 1, 8, 5,  true);  // ����� - ����� = ��    //  test(0, 8, 1, 0, 8, 5,  false);
//	test(0, 9, 3, 1, 8, 5,  true);  // ����� - ����� = �� 
//	test(1, 9, 3, 0, 8, 5,  true);  // ����� - ����� = �� 
//
//	test(0, 13, 7, 1, 15, 0, true); // �� - -����� = ����� 
//	test(1, 15, 0, 1, 14, 0, true); // -����� - �� = -����� 
//	test(0, 15, 0, 1, 14, 0, true); // ����� - �� = ����� 
//	test(0, 15, 0, 0, 14, 7, true); // ����� - �� = ����� 
//	test(0, 15, 0, 0, 15, 0, true); // ����� - ����� = +Inf 
//	 
//	test(0, 12, 4, 0, 10, 7, false);
//	test(0, 10, 7, 0, 12, 4, false);
//	test(0, 10, 7, 1, 12, 4, true);
//	test(1, 10, 7, 1, 12, 4, false);
//	test(1, 12, 4, 0, 10, 7, true);
//	
	return 0;
}


