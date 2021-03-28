#include<iostream>
#include<vector>
#include<string>
using namespace std;

vector<int> mul_mul(vector<int>& a, vector<int>& b);
// 大数加法
vector<int> mul_divided(vector<int> x, vector<int> y);
vector<int> mul_sum(vector<int> a, vector<int>b);
vector<int> mul_minus(vector<int>a, vector<int>b);
vector<int> mul_pow(vector<int>a, int n);
// 以字符串形式给出。还是得把这个形式改成整数数组比较好
int main() {
    string a = "999999999999999999999999999999999999999999";
    string b = "777777777777777777777777777777777777777777777777";
    // 将字符串转换为整形数组。C的方法可以使用memset分配空间C++直接pushback
    // 将大数数组反向存储。个位存在最开始的位置。方便数组增长。
    vector<int> aa;
    for (int i = a.size() - 1; i >= 0; i--) {
        aa.push_back((int)(a[i] - '0'));
    }
    vector<int> bb;
    for (int i = b.size() - 1; i >= 0; i--) {
        bb.push_back((int)(b[i] - '0'));
    }
    // vector<int> result = mul_mul(aa,bb);
    vector<int> result = mul_divided(aa, bb);
    // 将最终的整数数组转换成字符串。并输出
    string res;
    for (int i = result.size() - 1; i >= 0; i--) {
        res += to_string(result[i]);
    }
    // 去除前边多余的0
    // res = res.substr(res.find_first_not_of('0'));
    cout << res << endl;
    return 0;
}

// 模拟小学竖式。反转的字符串。个位在前边。
vector<int> mul_mul(vector<int>& a, vector<int>& b) {
    vector<int> a_b(a.size() + b.size(), 0);
    // 小学乘法，i位置×j位置。在i+j位置保存结果。最后处理进位。
    for (int i = 0; i < a.size(); i++) {
        for (int j = 0; j < b.size(); j++) {
            a_b[i + j] += a[i] * b[j];
        }
    }
    // 对a_b中的数值进行处理（进位处理）
    for (int i = 0; i < a_b.size(); i++) {
        a_b[i + 1] += a_b[i] / 10;
        a_b[i] %= 10;
    }
    //去除高位的0
    int i = a_b.size() - 1;
    while (a_b[i] == 0) {
        a_b.pop_back();
        i--;
    }
    return a_b;
}

// 分治法。
//反转的字符串。个位在前边。
//假设等长只有等长的数据划分才会方便。
// 如果等长情况下的处理
//关于是相乘结果是0的情况应该特殊处理。
vector<int> mul_divided(vector<int> x, vector<int> y) {
    //对x,y短的进行补齐.高位补齐0
    while (x.size() < y.size()) {
        x.push_back(0);
    }
    while (y.size() < x.size()) {
        y.push_back(0);
    }
    // 只在末端做一次乘法
    vector<int> result(x.size() + y.size());
    if (x.size() == 1 && y.size() == 1) {
        result[0] = x[0] * y[0];
        result[1] = result[0] / 10;
        result[0] = result[0] % 10;
        //去除高位的0
        int i = result.size() - 1;
        //但是保留唯一的0；用来表示这是一个0
        while (result.size()>0 && result[i] == 0) {
            result.pop_back();
            i--;
        }
        return result;
    }

    int n = x.size() / 2;
    // 分割成a,b,c,d四个部分
    vector<int> b(x.begin(), x.begin() + n);
    vector<int> a(x.begin() + n, x.end());
    vector<int> d(y.begin(), y.begin() + n);
    vector<int> c(y.begin() + n, y.end());

    // 进行递归
    vector<int> mul1 = mul_divided(a, c);
    vector<int> mul2 = mul_divided(b, d);
    vector<int> mul_ab_cd = mul_divided(mul_sum(a, b), mul_sum(c, d));

    // 加法。个位在前边。
    vector<int> sum_ac_bd = mul_sum(mul1, mul2);
    vector<int> mul3 = mul_minus(mul_ab_cd, sum_ac_bd);


    result = mul_sum(mul_sum(mul_pow(mul1, 2 * n), mul2), mul_pow(mul3, n));
    return result;
}

// 大数加法。
vector<int> mul_sum(vector<int> a, vector<int> b) {
    vector<int> result(max(a.size(), b.size()) + 1, 0);
    for (int i = 0; i < result.size() - 1; i++) {
        if (i < a.size()) {
            result[i] += a[i];
        }
        if (i < b.size()) {
            result[i] += b[i];
        }
        // 处理进位
        result[i + 1] += result[i] / 10;
        result[i] %= 10;
    }
    //去除高位的0
    int i = result.size() - 1;
    while (result.size() > 0 && result[i] == 0) {
        result.pop_back();
        i--;
    }
    return result;
}
// 大数减法（结果不可能是负数）
vector<int> mul_minus(vector<int> a, vector<int>b) {
    vector<int> result(a.size(), 0);
    // 做减法
    for (int i = 0; i < a.size(); i++) {
        if (i < b.size()) {
            result[i] += a[i] - b[i];
        }
        else {
            result[i] += a[i];
        }
        // 处理借位
        if (result[i] < 0) {
            result[i] += 10;
            result[i + 1] -= 1;
        }
    }
    //去除高位的0
    int i = result.size() - 1;
    while (result.size() > 0 && result[i] == 0) {
        result.pop_back();
        i--;
    }
    return result;
}
// 向右移位
vector<int> mul_pow(vector<int> a, int n) {
    vector<int> result(n, 0);
    result.insert(result.end(), a.begin(), a.end());
    //去除高位的0
    int i = result.size() - 1;
    while (result.size() > 0 && result[i] == 0) {
        result.pop_back();
        i--;
    }
    return result;
}
