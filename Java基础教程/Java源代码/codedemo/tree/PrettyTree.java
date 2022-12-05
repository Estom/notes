package cn.aofeng.demo.tree;

import java.util.LinkedList;
import java.util.List;

/**
 * 输出类似目录树的结构。
 * 
 * @author <a href="mailto:aofengblog@163.com">聂勇</a>
 */
public class PrettyTree {

    private final static String NODE_INDENT_PREFIX = "|  ";
    private final static String NODE_PARENT_PREFIX = "├── ";
    private final static String NODE_LEAF_PREFIX = "└── ";
    private final static String LINE_SEPARATOR = System.getProperty("line.separator", "\n");

    public void renderRoot(Node root, StringBuilder buffer) {
        renderParentNode(root, 0, buffer);
    }
    
    private void renderParentNode(Node node, int indent, StringBuilder buffer) {
        addIndent(indent, buffer);
        buffer.append(NODE_PARENT_PREFIX)
            .append(node.getName())
            .append(LINE_SEPARATOR);
        List<Node> childList = node.getChild();
        if (null == childList) {
            return;
        }
        for (Node child : childList) {
            if (child.isLeaf()) {
                renderLeafNode(child, indent+1, buffer);
            } else {
                renderParentNode(child, indent+1, buffer);
            }
        }
    }

    private void renderLeafNode(Node node, int indent, StringBuilder buffer) {
        addIndent(indent, buffer);
        buffer.append(NODE_LEAF_PREFIX)
            .append(node.getName())
            .append(LINE_SEPARATOR);
    }

    private void addIndent(int indent, StringBuilder buffer) {
        for (int i = 0; i < indent; i++) {
            buffer.append(NODE_INDENT_PREFIX);
        }
    }

    public static class Node {

        /** 节点名称。 */
        private String name;

        /** 子节点列表 */
        private List<Node> child = new LinkedList<Node>();

        public Node(String name) {
            this.name = name;
        }

        public Node(String name, List<Node> child) {
            this.name = name;
            this.child = child;
        }

        /**
         * 判断当前节点是否为叶子节点。
         * 
         * @return 如果是叶子节点返回true；否则返回false。
         */
        public boolean isLeaf() {
            if (null == child || child.isEmpty()) {
                return true;
            }

            return false;
        }
        
        /**
         * 批量添加子节点。
         * 
         * @param child 子节点列表。
         */
        public void addAll(List<Node> nodeList) {
            this.child.addAll(nodeList);
        }
        
        /**
         * 添加单个子节点。
         * 
         * @param node 子节点。
         */
        public void add(Node node) {
            this.child.add(node);
        }

        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }

        public List<Node> getChild() {
            return child;
        }

        public void setChild(List<Node> child) {
            this.child = child;
        }
    } // end of Node

}
