package cn.aofeng.demo.aspectj;

import org.apache.commons.lang.ArrayUtils;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.After;
import org.aspectj.lang.annotation.AfterReturning;
import org.aspectj.lang.annotation.AfterThrowing;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * 拦截器。
 * 
 * @author <a href="mailto:aofengblog@163.com">聂勇</a>
 */
@Aspect
public class BusinessServiceInterceptor {

    private static Logger _logger = LoggerFactory.getLogger(BusinessServiceInterceptor.class);
    
    private char _style = '-';
    
    /**
     * <pre>
     * Before通知不能修改方法传入的参数。
     * </pre>
     */
    @Before("execution(public * cn.aofeng.demo.aspectj.BusinessService.add(..))")
    public void beforeAdd(JoinPoint joinPoint) {
        _logger.info( String.format("拦截到方法：%s, 传入参数：%s", 
                joinPoint.getSignature().getName(), 
                ArrayUtils.toString(joinPoint.getArgs()) ) );
        BusinessService.printLine(_style);
    }

    /**
     * <pre>
     * After通知不能修改方法的返回值。
     * 如果被拦截的方法抛出异常，拦截代码仍然正常执行。
     * </pre>
     */
    @After("execution(public * cn.aofeng.demo.aspectj.BusinessService.join(..))")
    public void beforeAddSupportMultiArgs(JoinPoint joinPoint) {
        _logger.info("Signature.name："+joinPoint.getSignature().getName());
        _logger.info("Args：" + ArrayUtils.toString(joinPoint.getArgs()));
        _logger.info("Target：" + ArrayUtils.toString(joinPoint.getTarget()));
        _logger.info("This：" + ArrayUtils.toString(joinPoint.getThis()));
        _logger.info("Kind：" + ArrayUtils.toString(joinPoint.getKind()));
        _logger.info("SourceLocation：" + ArrayUtils.toString(joinPoint.getSourceLocation()));
        
        // 试图修改传入的参数
        joinPoint.getArgs()[0] = "100";
        
        BusinessService.printLine(_style);
    }
    
    /**
     * <pre>
     * AfterReturning通知不能修改方法的返回值。
     * 如果被拦截的方法抛出异常，拦截代码不再执行。
     * </pre>
     */
    @AfterReturning(pointcut="execution(public * cn.aofeng.demo.aspectj.BusinessService.join(..))", returning="result")
    public void afterReturnAdd(JoinPoint joinPoint, Object result) {
        _logger.info( String.format("拦截到方法：%s, 传入参数：%s, 执行结果：%s", 
                joinPoint.getSignature().getName(), 
                ArrayUtils.toString(joinPoint.getArgs()), 
                result) );
        
        // 试图修改返回值
        result = "hello, changed";
        
        BusinessService.printLine(_style);
    }
    
    /**
     * <pre>
     * 只在被拦截的方法抛出异常时才执行。
     * </pre>
     */
    @AfterThrowing(pointcut="execution(public * cn.aofeng.demo.aspectj.BusinessService.join(..))", throwing="ex")
    public void afterThrowingAdd(JoinPoint joinPoint, Exception ex) {
        _logger.info( String.format("拦截到方法：%s, 传入参数：%s", 
                joinPoint.getSignature().getName(), 
                ArrayUtils.toString(joinPoint.getArgs()) ) );
        if (null != ex) {
            _logger.info("拦截到异常：", ex);
        }
        
        BusinessService.printLine(_style);
    }

    /**
     * <pre>
     * {@link ProceedingJoinPoint}只能在Around通知中使用。
     * Around通知可以修改被拦截方法的传入参数和返回值。
     * </pre>
     */
    @Around("execution(public * cn.aofeng.demo.aspectj.BusinessService.addPrefix(..))")
    public Object afterAround(ProceedingJoinPoint joinPoint) throws Throwable {
        _logger.info( String.format("拦截到方法：%s, 传入参数：%s", 
                joinPoint.getSignature().getName(), 
                ArrayUtils.toString(joinPoint.getArgs()) ) );
        
        Object result = null;
        try {
            result = joinPoint.proceed();
            _logger.info("执行结果：" + result);
        } catch (Throwable e) {
            throw e;
        } finally {
            BusinessService.printLine(_style);
        }
        
        return result;
    }

}
