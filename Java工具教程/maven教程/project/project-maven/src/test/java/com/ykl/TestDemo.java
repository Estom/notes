package com.ykl;

import org.junit.Test;
import org.junit.Assert;
public class TestDemo {
    @Test
    public void testSay(){
        Demo d = new Demo();
        String ret = d.say("world");
        Assert.assertEquals("hello world", ret);
    }
}
