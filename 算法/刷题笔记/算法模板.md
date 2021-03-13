# 算法代码模板

> 算法代码模板即算法的常见套路。熟练记忆，活学活用。

## 递归

```java
public void recursion(int level, int param1, int param2, ...) {
    // 递归终止条件
    if (level > MAX_LEVEL) {
        // print
        return;
    }

    // 当前处理逻辑
    processData(level, param1, param2, ...);

    // 递归
    recursion(level + 1, param1, param2, ...);

    // 如有必要，还原状态
    reverseState(level, data);
}
```

## DFS

```java
Set<Node> visited = new HashSet<>();

public void dfs(Node node, Set<Node> visited) {
    visited.add(node);
    for (Node n : node.children) {
        if (!visited.contains(n)) {
            dfs(n, visited);
        }
    }
}
```

## BFS

```java
public List<List<Integer>> bfs(Node root) {
    List<List<Integer>> list = new ArrayList<>();
    Queue<Node> queue = new LinkedList<>();
    queue.offer(root);
    while (!queue.isEmpty()) {
        List<Integer> levelList = new ArrayList<>();

        int size = queue.size();
        // 遍历当前层级所有节点
        for (int i = 0; i < size; i++) {
            Node n = queue.poll();

            // 对节点 n 做逻辑处理
            levelList.add(n.val);

            // 将 n 的所有节点加入队列
            for (Node c : n.children) {
                queue.offer(c);
            }
        }

        list.add(levelList);
    }

    return list;
}
```

## 二分查找

数组的二分查找：

```java
int left = 0, right = nums.length - 1;
while (left <= right) {
    int mid = left + (right - left) / 2; // 防止数据类型溢出
    if (nums[mid] == target) {
        break or return result;
    } else if (nums[mid] < target) {
        left = mid + 1;
    } else {
        right = mid - 1;
    }
}
```

## 动态规划

```java
// DP 状态定义
int[][] dp = new int[m + 1][n + 1];

// 初始状态
dp[0][0] = x;
dp[0][1] = y;

// DP 状态推导
for (int i = 0; i < m; i++) {
    for (int j = 0; j < n; j++) {
        // 方程根据实际场景推导
        dp[i][j] = max or min { dp[i - 1][j], dp[i][j - 1], ... }
    }
}

// 返回最优解
return dp[m][n];
```

## 位运算

记忆常用位运算公式（无他，背就完事了）

|                | 二进制表达式                  | 等价表达式                    |
| -------------- | ----------------------------- | ----------------------------- |
| 判断奇偶       | `x & 1 == 1`<br/>`x & 1 == 0` | `x % 2 == 1`<br/>`x % 2 == 0` |
| 清零最低位的 1 | `x = x & (x - 1)`             |                               |
| 得到最低位的 1 | `x & -x`                      |                               |



