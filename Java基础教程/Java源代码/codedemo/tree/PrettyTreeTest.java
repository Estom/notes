package cn.aofeng.demo.tree;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import cn.aofeng.demo.tree.PrettyTree.Node;

public class PrettyTreeTest {

    @Before
    public void setUp() throws Exception {
    }

    @After
    public void tearDown() throws Exception {
    }

    @Test
    public void testPrintRoot() {
        Node p11 = new Node("p1-1");
        Node p12 = new Node("p1-2");
        Node p1 = new Node("p1");
        p1.add(p11);
        p1.add(p12);
        
        Node p21 = new Node("p21");
        Node p2 = new Node("p2");
        p12.add(p21);
        
        Node root = new Node("Root");
        root.add(p1);
        root.add(p2);
        
        StringBuilder buffer = new StringBuilder(256);
        PrettyTree pt = new PrettyTree();
        pt.renderRoot(root, buffer);
        System.out.print(buffer.toString());
    }

}
