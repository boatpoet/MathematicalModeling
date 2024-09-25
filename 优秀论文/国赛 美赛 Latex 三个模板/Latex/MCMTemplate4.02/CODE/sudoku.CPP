//============================================================================
// Name        : Sudoku.cpp
// Author      : wzlf11
// Version     : a.0
// Copyright   : Your copyright notice
// Description : Sudoku in C++.
//============================================================================

#include <iostream>
#include <cstdlib>
#include <ctime>

using namespace std;

int table[9][9];

void shuffle(int arr[], int n){
    
    int tmp, rd;

    //打乱数组顺序
    for(int i = 0; i < n; i++){
        rd = rand() % 9;
        tmp = arr[rd];
        arr[rd] = arr[i];
        arr[i] = tmp;
    }
}

bool test(int x, int y, int v){
    
    int _x = x / 3 * 3;
    int _y = y / 3 * 3;

    //测试3 * 3矩阵内是否有重复的数
    for(int i=_x; i<_x + 3; i++)
    {
        for(int j = _y; j < _y + 3; j++)
        {
            if(table[i][j] == v)
            {
                return false;
            }
        }
    }

    //测试横向、纵向是否有重复的数
    for(int m= 0; m< 9; m++)
    {
        if(table[x][m] == v || table[m][y] == v)
            return false;
    }
    
    return true;
}

bool put(int line, int index){
    
    if(index > 8)
        return true;
    
    //如果当前方格内不等于0，则跳过处理下一个方格
    if(table[line][index] != 0){
        return put(line, index + 1);
    }
    
    int num[] = {1,2,3,4,5,6,7,8,9};
    //打乱当前准备写入数字的前后顺序
    shuffle(num, 9);
    
    for(int i = 0; i < 9; i++){
        
        //测试数字是否允许填入当前方格
        if( test(line, index, num[i]) == true ){

            table[line][index] = num[i];
            
            //填入成功则处理下一个方格
            if( put(line, index + 1) == true ){
                return true;
            }
        }
    }

    table[line][index] = 0; //失败后复位

    return false;
}

bool put_line(int line){

    if(line > 8)
        return true;
    
    int b[9];
    
    //备份当前一行
    for(int i = 0; i < 9; i++){
        b[i] = table[line][i];
    }

    if( put(line, 0) == true ){
        //当前一行添入完成后，进入下一行再重复处理。
        if( put_line(line + 1) == true )
            return true;
    }
    
    //恢复当前一行的值
    for(int n = 0; n < 9; n++){
        table[line][n] = b[n];
    }
    
    return false;
}

int main() {

    //表格首行填入初始值
    for(int i = 0; i < 9; i++){
        table[0][i] = i + 1;
    }

    srand((unsigned int)time(NULL));
    //打乱表格首行次序
    shuffle((int *)&table[0], 9);

    //从第二行开始添入数字
    while(!put_line(1))
    {
        //失败重新开始
        shuffle((int *)&table[0], 9);
    }
    
    //最后显示
    for(int x = 0; x < 9; x++){
        for(int y = 0; y < 9; y++){
            cout << table[x][y] << " ";
        }
        
        cout << endl;
    }

    return 0;
}