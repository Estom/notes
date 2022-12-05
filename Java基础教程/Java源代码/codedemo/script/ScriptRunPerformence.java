package cn.aofeng.demo.script;

import java.util.HashMap;
import java.util.Map;

import javax.script.Bindings;
import javax.script.Compilable;
import javax.script.CompiledScript;
import javax.script.ScriptEngine;
import javax.script.ScriptEngineManager;
import javax.script.ScriptException;

/**
 * 脚本语言运行性能测试：
 * <pre>
 * 1、每次运行脚本都解释的执行性能。
 * 2、编译脚本后再运行的性能。
 * </pre>
 * 
 * @author 聂勇 <aofengblog@163.com>
 */
public class ScriptRunPerformence {

    private final static int COUNT = 100000;
    
    /**
     * 每次解释脚本并运行<code>COUNT</code>次。
     * 
     * @param script 脚本表达式
     * @param vars 用于替换<code>script</code>中变量的Key=>Value集合
     * @throws ScriptException 如果解释或运行脚本出错
     */
    public void parse(String script, Map<String, Object> vars) throws ScriptException {
        ScriptEngine scriptEngine = getScriptEngine("javascript");
        long startTime = System.currentTimeMillis();
        for (int i = 0; i < COUNT; i++) {
            Bindings binds = createBinding(vars, scriptEngine);
            scriptEngine.eval(script, binds);
        }
        long usedTime = System.currentTimeMillis() - startTime;
        System.out.println( String.format("每次都解释脚本执行%d次消耗%d毫秒", COUNT, usedTime) );
    }
    
    /**
     * 编译脚本后运行<code>COUNT</code>次。
     * 
     * @param script 脚本表达式
     * @param vars 用于替换<code>script</code>中变量的Key=>Value集合
     * @throws ScriptException 如果编译或运行脚本出错
     */
    public void compile(String script, Map<String, Object> vars) throws ScriptException {
        ScriptEngine scriptEngine = getScriptEngine("javascript");
        Compilable compileEngine = (Compilable) scriptEngine;
        CompiledScript compileScript = compileEngine.compile(script);
        long startTime = System.currentTimeMillis();
        for (int i = 0; i < COUNT; i++) {
            Bindings binds = createBinding(vars, scriptEngine);
            compileScript.eval(binds);
        }
        long usedTime = System.currentTimeMillis() - startTime;
        System.out.println( String.format("编译脚本后执行%d次消耗%d毫秒", COUNT, usedTime) );
    }
    
    private ScriptEngine getScriptEngine(String name) {
        ScriptEngineManager sem = new ScriptEngineManager();
        return sem.getEngineByName(name);
    }
    
    private Bindings createBinding(Map<String, Object> vars,
            ScriptEngine scriptEngine) {
        Bindings binds = scriptEngine.createBindings();
        if (null != vars && !vars.isEmpty()) {
            binds.putAll(vars);
        }
        
        return binds;
    }
    
    public static void main(String[] args) throws ScriptException {
        if ( args.length != 1) {
            System.err.println("参数错误。使用示例：\n    java cn.aofeng.demo.script.ScriptRunPerformence [parse|compile]");
            System.exit(-1);
        }
        String runType = args[0];
        if ( !"parse".equals(runType) && !"compile".equals(runType) ) {
            System.err.println("参数错误。使用示例：\n    java cn.aofeng.demo.script.ScriptRunPerformence [parse|compile]");
            System.exit(-1);
        }
        
        String script = "function run(a, b) {" +
        		"var c = a + b;" +
        		"var d = a * b;" +
        		"var e = a / b;" +
        		"var f = a % b;" +
        		"var g = a - b;" +
        		"var  express = ((a * 5) > b || b * 10 >= 100) && (a * b > 99);" +
        		"}" +
        		"" +
        		"run(x, y);";
        Map<String, Object> vars = new HashMap<String, Object>(2);
        vars.put("x", 20);
        vars.put("y", 9);
        
        ScriptRunPerformence srp = new ScriptRunPerformence();
        if ("parse".equals(runType)) {
            srp.parse(script, vars);
        } else {
            srp.compile(script, vars);
        }
    }

}
