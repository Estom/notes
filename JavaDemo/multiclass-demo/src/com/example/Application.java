package com.example;

public class Application {
    public static void main(String[] args) {
        // 创建PersonService实例
        PersonService service = new PersonService();
        
        // 添加一些Person对象，注意名字的大小写会被自动规范化
        service.addPerson(new Person("alice", 25));
        service.addPerson(new Person("BOB", 30));
        service.addPerson(new Person("cHaRlIe", 35));
        
        // 显示所有人员
        System.out.println("All persons (with names properly capitalized):");
        for (Person person : service.getAllPersons()) {
            System.out.println(person);
        }
        
        // 查找特定人员
        Person found = service.findPersonByName("Bob");
        System.out.println("\nFound person: " + found);
        
        // 测试修改人员名字
        if (found != null) {
            found.setName("david");
            System.out.println("After name change: " + found);
        }
    }
}