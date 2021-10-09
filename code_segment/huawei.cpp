#include<iostream>
#include<vector>
using namespace std;



vector<vector<int>> gameOfLife(vector<vector<int>> board) {
    vector<vector<int>> res(board.size(),vector<int>(board[0].size(),0));
    for(int i=0;i<board.size();i++){
        for(int j=0;j<board[0].size();j++){
            int count =0;
            for(int k=0;k<9;k++){
                int x = i-1+k/3;
                int y = j-1+k%3;
                if(x==i&&y==j){
                    continue;
                }
                if(x>=0 && x<board.size() && y>=0 && y<board[0].size()&&board[x][y]==1){
                    count++;
                }
            }

            if(count<2 ||count>3){
                res[i][j]=0;
            }
            else if(count==3){
                res[i][j]=1;
            }
            else if(count==2 && board[i][j]==1){
                res[i][j]=1;
            }
        }
    }
    return res;
}

int main(){
    vector<vector<int>> vec = {
        {0,1,0},
        {0,0,1},
        {1,1,1},
        {0,0,0}
    };
    vector<vector<int>> res= gameOfLife(vec);
    for(auto a:res){
        for(auto b:a){
            cout<<b<<" ";
        }
        cout<<endl;
    }
}