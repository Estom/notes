package cn.aofeng.demo.xml;

import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpressionException;
import javax.xml.xpath.XPathFactory;

import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;

/**
 * XPath语法实践。
 * 
 * @author <a href="mailto:aofengblog@163.com">聂勇</a>
 */
public class XPathDemo {

    public static void main(String[] args) throws XPathExpressionException {
        InputSource ins = new InputSource(XPathDemo.class.getResourceAsStream("/cn/aofeng/demo/xml/BookStore.xml"));
        XPathFactory factory = XPathFactory.newInstance();
        XPath xpath = factory.newXPath();
        NodeList result = (NodeList) xpath.evaluate("//title[@lang='de']", ins, XPathConstants.NODESET);
        for (int i = 0; i < result.getLength(); i++) {
            Node node = result.item(i);
            StringBuilder buffer = new StringBuilder()
                .append("NodeName=").append(node.getNodeName()).append(", ")
                .append("NodeValue=").append(node.getNodeValue()).append(", ")
                .append("Text=").append(node.getTextContent());
            System.out.println(buffer.toString());
        }
    }

}
