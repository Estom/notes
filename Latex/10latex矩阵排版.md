# latex矩阵排版


## matrix环境

### 导入amsmath宏包

/usepackage{smsmath}

### matrix环境

begin{matrix} 
end{matrix}


begin{bmatrix}
中括号
end{bmatrix}


begin{Bmatrix}
大括号
end{Bmatrix}

begin{vmatrix}
单竖线
end{vmatrix}


begin{Vmatrix}
双竖线
end{Vmatrix}

### 省略号实现

\dots

\vdots

\ddots

### 分块矩阵

begin{pmatrix}
分块矩阵
end{pmatrix}

### 行内矩阵
begin{smallmatrix}
end{smallmatrix}

### 行列合并

\multicolumn{2}{c}\raisebox{调整高度}

### 跨行括号
\left(  \right)

### array环境实现矩阵

同tabular环境
begin{array}
end{array}

可以使用array环境的嵌套实现更高级的矩阵。