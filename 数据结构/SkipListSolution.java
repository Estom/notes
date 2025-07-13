import java.util.Random;

class Node {
    public Integer value;
    public Node next;
    public Node down;

    public Node(int val) {
        this.value = val;
    }

    @Override
    public String toString() {
        return String.valueOf(this.value);
    }
}

class SkipList {

    private Integer MAX_LEVEL = 10;

    private Node curHead;

    private Integer curLevel = 0;

    private Random random = new Random();

    private double ratio = 0.5;

    // 做了一层优化，层数不需要预先创建好，而是在插入过程中动态扩展
    public SkipList() {
        // 初始化节点，只有一层
        Node head = new Node(-1);
        Node end = new Node(Integer.MAX_VALUE);
        head.next = end;
        curHead = head;
    }

    public Node find(int val) {
        Node point = curHead;
        while (point != null) {
            if (point.next.value == val) {
                return point.next;
            }
            if (point.next.value < val) {
                point = point.next;
            } else {
                point = point.down;
            }
        }
        // 没有找到节点
        return null;
    }

    public void insert(int val) {
        int level = getLevel();
        expandLevel(level);
        Node point = curHead;
        // 定位要插入的level
        for (int i = 0; i < curLevel - level; i++) {
            point = curHead.down;
        }

        // 逐层插入
        Node upNode = null;
        while(point != null){
            // 创建节点
            Node newNode = new Node(val);
            // 定位要插入的元素
            while(point.next.value < val){
                point = point.next;
            }
            newNode.next = point.next;
            point.next = newNode;
            if (upNode !=null) {
                upNode.down = newNode;
            }
            upNode = newNode;
            point = point.down;
        }
    }

    public void expandLevel(int level) {
        while (curLevel < level) {
            Node newHead = new Node(-1);
            Node newEnd = new Node(Integer.MAX_VALUE);
            newHead.next = newEnd;
            Node curEnd = curHead.next;
            while (curEnd.next != null) {
                curEnd = curEnd.next;
            }
            newHead.down = curHead;
            newEnd.down = curEnd;
            curHead = newHead;
            curLevel += 1;
        }
    }
    public void delete(int val) {
        // 查找元素节点
        Node point = curHead;
        while (point != null) {
            if (point.next.value == val) {
                break;
            }
            if (point.next.value < val) {
                point = point.next;
            } else {
                point = point.down;
            }
        }

        if (point == null) {
            return;
        }

        // 删除下一个元素
        while (point != null) {
            // 找到当前层的目标节点
            while (point.next.value < val) {
                point = point.next;
            }
            point.next = point.next.next;
            point = point.down;
        }
    }

    private int getLevel() {
        int level = 0;
        while (random.nextDouble() < ratio && level <= MAX_LEVEL) {
            level += 1;
        }
        return level;
    }


    public void printSkipList(){
        Node level = curHead;
        int i = curLevel;
        while (level != null) {
            Node point = level.next;
            System.out.print("level " + i + ":");
            while(point != null){
                System.out.print(point + ",");
                point = point.next;
            }
            System.out.println("");
            i--;
            level = level.down;
        }
    }
}

public class SkipListSolution{

    public static void main(String[] args) {
        SkipList skipList = new SkipList();

        // 创建skiplist
        int[] testVal = {1,8,4,6,7,3,2};
        for (int i = 0; i < testVal.length; i++) {
            skipList.insert(testVal[i]);
        }

        skipList.printSkipList();

        // 查找元素
        Node result = skipList.find(3);
        System.out.println(result);

        result = skipList.find(11);
        System.out.println(result);

        skipList.delete(7);
        skipList.printSkipList();

        skipList.delete(11);
        skipList.printSkipList();
    }

}