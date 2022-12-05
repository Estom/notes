package cn.aofeng.demo.script;

import java.util.List;

import javax.script.ScriptEngineFactory;
import javax.script.ScriptEngineManager;

/**
 * 支持的脚本引擎列表。 
 * 
 * @author <a href="mailto:aofengblog@163.com">聂勇</a>
 */
public class SupportScriptEngine {
    
    public void listScriptEngine() {
        ScriptEngineManager sem = new ScriptEngineManager();
        List<ScriptEngineFactory> sefList = sem.getEngineFactories();
        for (ScriptEngineFactory factory : sefList) {
            printScriptEngineInfo(factory);
        }
    }
    
    private void printScriptEngineInfo(ScriptEngineFactory factory) {
        System.out.println("ScriptEngineName:" + factory.getEngineName() 
                + ", Names:" + factory.getNames() 
                + ", ScriptEngineVersion:" + factory.getEngineVersion()
                + ", LanguageName:" + factory.getLanguageName()
                + ", LanguageVersion:" + factory.getLanguageVersion() );
    }
    
    public static void main(String[] args) {
        SupportScriptEngine msep = new SupportScriptEngine();
        msep.listScriptEngine();
    }

}
