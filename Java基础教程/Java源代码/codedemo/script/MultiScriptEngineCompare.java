package cn.aofeng.demo.script;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.script.Bindings;
import javax.script.Compilable;
import javax.script.CompiledScript;
import javax.script.ScriptEngine;
import javax.script.ScriptEngineManager;
import javax.script.ScriptException;

/**
 * 多个脚本引擎执行JavaScript的性能比较。
 * 
 * @author <a href="mailto:aofengblog@163.com">聂勇</a>
 */
public class MultiScriptEngineCompare {

    public final static String PARSE = "parse";
    public final static String COMPILE = "compile";
    
    /**
     * 获取指定的脚本引擎执行指定的脚本（解释执行）。
     * 
     * @param scriptEngineName 脚本引擎名称
     * @param script 脚本
     * @param count 脚本的执行次数
     * @param vars 绑定到脚本的变量集合
     * @throws ScriptException 执行脚本出错
     */
    public ExecuteResult parse(String scriptEngineName, String script, int count, 
            Map<String, Object> vars) throws ScriptException {
        ScriptEngine scriptEngine = getScriptEngine(scriptEngineName);
        long startTime = System.currentTimeMillis();
        for (int i = 0; i < count; i++) {
            runSingleScript(script, vars, scriptEngine);
        }
        long usedTime = System.currentTimeMillis() - startTime;
        
        ExecuteResult result = new ExecuteResult();
        result.setEngine(scriptEngine.getFactory().getEngineName());
        result.setScript(script);
        result.setBindParam(vars.toString());
        result.setExecuteCount(count);
        result.setExecuteType(PARSE);
        result.setUsedTime(usedTime);
        
        return result;
    }
    
    private void runSingleScript(String script, Map<String, Object> vars, 
            ScriptEngine scriptEngine) throws ScriptException {
        if (null == vars || vars.isEmpty()) {
            scriptEngine.eval(script);
        } else {
            Bindings binds = createBinding(scriptEngine, vars);
            scriptEngine.eval(script, binds);
        }
    }
    
    public ExecuteResult compile(String scriptEngineName, String script, int count, 
            Map<String, Object> vars) throws ScriptException {
        ScriptEngine scriptEngine = getScriptEngine(scriptEngineName);
        Compilable compileEngine = (Compilable) scriptEngine;
        CompiledScript compileScript = compileEngine.compile(script);
        long startTime = System.currentTimeMillis();
        for (int i = 0; i < count; i++) {
            runSingleScript(compileScript, vars, scriptEngine);
        }
        long usedTime = System.currentTimeMillis() - startTime;
        
        ExecuteResult result = new ExecuteResult();
        result.setEngine(scriptEngine.getFactory().getEngineName());
        result.setScript(script);
        result.setBindParam(vars.toString());
        result.setExecuteCount(count);
        result.setExecuteType(COMPILE);
        result.setUsedTime(usedTime);
        
        return result;
    }
    
    private void runSingleScript(CompiledScript compileScript, Map<String, Object> vars, 
            ScriptEngine scriptEngine) throws ScriptException {
        if (null == vars || vars.isEmpty()) {
            compileScript.eval();
        } else {
            Bindings binds = createBinding(scriptEngine, vars);
            compileScript.eval(binds);
        }
    }
    
    protected void log(String msg) {
        System.out.println(msg);
    }
    
    protected void log(String msg, Object... args) {
        log( String.format(msg, args) );
    }
    
    /**
     * 根据名称获取脚本引擎。
     *  
     * @param name 脚本引擎名称
     * @return 实现了{@link ScriptEngine}的脚本引擎。如果没有对应的脚本引擎，返回null。
     */
    public ScriptEngine getScriptEngine(String name) {
        ScriptEngineManager sem = new ScriptEngineManager();
        return sem.getEngineByName(name);
    }
    
    private Bindings createBinding(ScriptEngine scriptEngine, Map<String, Object> vars) {
        Bindings binds = scriptEngine.createBindings();
        if (null != vars && !vars.isEmpty()) {
            binds.putAll(vars);
        }
        
        return binds;
    }
    
    /**
     * @param args 执行次数
     * @throws ScriptException 
     */
    @SuppressWarnings({ "rawtypes", "unchecked" })
    public static void main(String[] args) throws ScriptException {
        if ( args.length != 2) {
            System.err.println("参数错误。\n语法格式：\n    java cn.aofeng.demo.script.MultiScriptEngineCompare 脚本执行次数 脚本执行方式（parse|compile）\n使用示例：\n    java cn.aofeng.demo.script.MultiScriptEngineCompare 100000 parse");
            System.exit(-1);
        }
        int count = Integer.parseInt(args[0]);
        String executeType = args[1];
        
        String[] scriptEngineList = {"JavaScript", "JEXL"};
        
        String script1 = "var c = a + b;" +
                "var d = a * b;" +
                "var e = a / b;" +
                "var f = a % b;" +
                "var g = a - b;" +
                "var result = ((a * 5) > b || b * 10 >= 100) && (a * b > 99);";
        Map<String, Object> vars1 = new HashMap<String, Object>(2);
        vars1.put("a", 20);
        vars1.put("b", 9);
        
        String script2 = "var result = src.indexOf(b);";
        Map<String, Object> vars2 = new HashMap<String, Object>(2);
        vars2.put("src", "compare performance javascript and jexl");
        vars2.put("b", "script");
        
        String[] scriptList = {script1, script2};
        Map[] varsList = {vars1, vars2};
        
        MultiScriptEngineCompare msec = new MultiScriptEngineCompare();
        List<MultiScriptEngineCompare.ExecuteResult> resultList = new ArrayList<MultiScriptEngineCompare.ExecuteResult>();
        for (int i = 0; i < scriptEngineList.length; i++) {
            for (int j = 0; j < scriptList.length; j++) {
                if (PARSE.equalsIgnoreCase(executeType)) {
                    resultList.add( msec.parse(scriptEngineList[i], scriptList[j], count, varsList[j]) );
                } else if (COMPILE.equalsIgnoreCase(executeType)) {
                    resultList.add( msec.compile(scriptEngineList[i], scriptList[j], count, varsList[j]) );
                } else {
                    msec.log("错误的执行方式：%s", executeType);
                }
            }
        }
        
        List<String[]> arrayList = new ArrayList<String[]>();
        arrayList.add(new String[]{"脚本引擎", "脚本", "脚本绑定参数", "脚本执行次数", "脚本执行类型", "消耗时间（毫秒）", "JDK版本"});
        for (Iterator iterator = resultList.iterator(); iterator.hasNext();) {
            ExecuteResult er = (ExecuteResult) iterator.next();
            arrayList.add(new String[]{er.getEngine(), 
                    er.getScript(), 
                    er.getBindParam(), 
                    String.valueOf(er.getExecuteCount()), 
                    er.getExecuteType(), 
                    String.valueOf(er.getUsedTime()), 
                    er.getJdkVersion()});
        }
        
        String[][] table = new String[arrayList.size()][7];
        arrayList.toArray(table);
        
        PrettyTable prettyTable = new PrettyTable(System.out);
        prettyTable.print(table);
    }

    static class ExecuteResult {
        
        private String engine;
        private String script;
        private String bindParam;
        private int executeCount;
        private String executeType;
        private long usedTime;
        private String jdkVersion;
        
        public ExecuteResult() {
            this.jdkVersion = System.getProperty("java.version");
        }
        
        public String getEngine() {
            return engine;
        }
        public void setEngine(String engine) {
            this.engine = engine;
        }
        public String getScript() {
            return script;
        }
        public void setScript(String script) {
            this.script = script;
        }
        public String getBindParam() {
            return bindParam;
        }
        public void setBindParam(String bindParam) {
            this.bindParam = bindParam;
        }
        public int getExecuteCount() {
            return executeCount;
        }
        public void setExecuteCount(int executeCount) {
            this.executeCount = executeCount;
        }
        public String getExecuteType() {
            return executeType;
        }
        public void setExecuteType(String executeType) {
            this.executeType = executeType;
        }
        public long getUsedTime() {
            return usedTime;
        }
        public void setUsedTime(long usedTime) {
            this.usedTime = usedTime;
        }
        public String getJdkVersion() {
            return jdkVersion;
        }
        public void setJdkVersion(String jdkVersion) {
            this.jdkVersion = jdkVersion;
        }
    }

}
