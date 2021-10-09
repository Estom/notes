#include<vector>
#include<iostream>
#include<sstream>
using namespace std;


int main(){
    
    int n,m;
    cin>>n>>m;
    vector<vector<int>> vec(n,vector<int>(m,0));
    int x,y,d=0;
    for(int i=0;i<n;i++){
        for(int j=0;j<m;j++){
            char c = cin.get();
            if(c=='B'){
                vec[i][j]=0;
            }
            else if(c=='O'){
                vec[i][j]=1;
            }
            else if(c=='R'){
                vec[i][j]=2;
                x=i,y=j;
            }
            else if(c=='\n'){
                j--;
            }
        }
    }
    int num=0;
    cin>>num;
    cin.ignore();
    int ox=x,oy=y;
    while(num--){
        string line;
        getline(cin,line);
        if(line=="Turn right"){
            d=(d+1)%4;
        }
        else if(line=="Turn left"){
            d=((d-1)+4)%4;
        }
        else if(line[0]=='F'){
            istringstream is(line);
            string temp;
            is>>temp;
            int step;
            is>>step;
            
                while(step--){
                    if(d==0){
                        if(x-1>=0 && vec[x-1][y]==0){
                            x=x-1;
                        }
                        else{
                            break;
                        }
                    }
                    else if(d==1){
                        if(y+1<m && vec[x][y+1]==0){
                            y = y+1;
                        }
                        else{
                            break;
                        }
                    }
                    else if(d==2){
                        if(x+1<n && vec[x+1][y]==0){
                            x=x+1;
                        }
                        else{
                            break;
                        }
                    }
                    else if(d==3){
                        if(y-1>0 && vec[x][y-1]==0){
                            y=y-1;
                        }
                        else{
                            break;
                        }
                    }

                }
        }
    }
    cout<<x-ox<<y-oy<<endl;
    return 0;
}