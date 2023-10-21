/**
 * 
 */
package cn.aofeng.demo.java.lang.instrument;

import java.lang.instrument.ClassFileTransformer;
import java.lang.instrument.IllegalClassFormatException;
import java.security.ProtectionDomain;

import cn.aofeng.demo.util.LogUtil;

/**
 * 只输出问候语，不进行字节码修改的Class转换器。
 * 
 * @author <a href="mailto:aofengblog@163.com">聂勇</a>
 */
public class FirstTransformer implements ClassFileTransformer {

    @Override
    public byte[] transform(ClassLoader loader, String className, Class<?> classBeingRedefined, 
            ProtectionDomain protectionDomain, byte[] classfileBuffer) throws IllegalClassFormatException {
        LogUtil.log(">>> %s", className);
        return null;
    }

}
