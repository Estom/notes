package cn.aofeng.demo.java.lang.instrument;

import java.lang.instrument.Instrumentation;

import org.apache.commons.lang.StringUtils;

import cn.aofeng.demo.util.LogUtil;

/**
 * Instrument入口类。
 * 
 * @author <a href="mailto:aofengblog@163.com">聂勇</a>
 */
public class FirstInstrumentation {

    public static void premain(String options, Instrumentation ins) {
        if (StringUtils.isBlank(options)) {
            LogUtil.log("instrument without options");
        } else {
            LogUtil.log("instrument with options:%s", options);
        }
        
        ins.addTransformer(new FirstTransformer());
    }
}
