package com.ykl;

import java.util.Properties;
import java.util.Set;

/**
 * Hello world!
 *
 */
public class App 
{
    public static void main( String[] args )
    {
        System.out.println( "Hello World!" );
        Properties properties = System.getProperties();

        Set<Object> properitesSet = properties.keySet();

        for (Object propName :properitesSet){
            String propValue = properties.getProperty((String)propName);
            System.out.println(propName + ": " + propValue);
        }
    }
}
