/**
 * Alipay.com Inc.
 * Copyright (c) 2004-2022 All Rights Reserved.
 */
package com.ykl.collectiontype;

import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * @author yinkanglong
 * @version : Student, v 0.1 2022-10-08 16:01 yinkanglong Exp $
 */
public class Student {
    private String[] courses;

    private List<String> list;

    private Map<String,String> maps;

    private Set<String> sets;

    private List<Course> courseList;


    public void setCourseList(List<Course> courseList) {
        this.courseList = courseList;
    }

    public Student() {
    }

    public void setList(List<String> list) {
        this.list = list;
    }

    public void setMaps(Map<String, String> maps) {
        this.maps = maps;
    }

    public void setSets(Set<String> sets) {
        this.sets = sets;
    }

    public void setCourses(String[] courses) {
        this.courses = courses;
    }

    @Override
    public String toString() {
        return "Student{" +
                "courses=" + Arrays.toString(courses) +
                ", list=" + list +
                ", maps=" + maps +
                ", sets=" + sets +
                ", courseList=" + courseList +
                '}';
    }
}
