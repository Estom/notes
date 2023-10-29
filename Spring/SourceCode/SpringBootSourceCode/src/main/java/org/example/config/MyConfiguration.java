package org.example.config;

import lombok.Data;
import org.apache.catalina.Group;
import org.apache.catalina.Role;
import org.apache.catalina.User;
import org.apache.catalina.UserDatabase;
import org.springframework.boot.autoconfigure.web.ResourceProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.Iterator;
@Data
@Configuration
public class MyConfiguration {

    @Bean
    public User getUser(){
        ResourceProperties resourceProperties = new ResourceProperties();

        resourceProperties.getChain();

        return new User() {
            @Override
            public String getFullName() {
                return null;
            }

            @Override
            public void setFullName(String s) {

            }

            @Override
            public Iterator<Group> getGroups() {
                return null;
            }

            @Override
            public String getPassword() {
                return null;
            }

            @Override
            public void setPassword(String s) {

            }

            @Override
            public Iterator<Role> getRoles() {
                return null;
            }

            @Override
            public UserDatabase getUserDatabase() {
                return null;
            }

            @Override
            public String getUsername() {
                return null;
            }

            @Override
            public void setUsername(String s) {

            }

            @Override
            public void addGroup(Group group) {

            }

            @Override
            public void addRole(Role role) {

            }

            @Override
            public boolean isInGroup(Group group) {
                return false;
            }

            @Override
            public boolean isInRole(Role role) {
                return false;
            }

            @Override
            public void removeGroup(Group group) {

            }

            @Override
            public void removeGroups() {

            }

            @Override
            public void removeRole(Role role) {

            }

            @Override
            public void removeRoles() {

            }

            @Override
            public String getName() {
                return null;
            }
        };
    }
}
