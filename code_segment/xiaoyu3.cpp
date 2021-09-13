#include<iostream>
#include<vector>

using namespace std;

int change(int amount, vector<int>& coins) {
    vector<int> dp(amount + 1);
    dp[0] = 1;
    for (int& coin : coins) {
        for (int i = coin; i <= amount; i++) {
            dp[i] += dp[i - coin];
        }
    }
    return dp[amount];
}
int main(){

    vector<int> vec{1,5,10,20,50,100};
    cout<<change(100,vec)<<endl;

}