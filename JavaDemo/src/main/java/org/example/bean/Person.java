package org.example.bean;


import lombok.Builder;
import lombok.Data;

@Builder
@Data
public class Person {
    String name;
    int age;
}
