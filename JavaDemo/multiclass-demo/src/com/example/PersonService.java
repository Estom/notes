package com.example;

import java.util.ArrayList;
import java.util.List;

public class PersonService {
    private List<Person> persons;
    
    public PersonService() {
        this.persons = new ArrayList<>();
    }
    
    public void addPerson(Person person) {
        persons.add(person);
    }
    
    public List<Person> getAllPersons() {
        return new ArrayList<>(persons);
    }
    
    public Person findPersonByName(String name) {
        return persons.stream()
                .filter(p -> p.getName().equals(name))
                .findFirst()
                .orElse(null);
    }
}