package org.example.controller;


import org.example.bean.Person;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.HashMap;
import java.util.Map;

@Controller
public class TestController {

    @GetMapping("/params")
    public String helloWorld(Map<String,String> map,
                             Model model,
                             HttpServletRequest request,
                             HttpServletResponse response){

        map.put("map","123");
        model.addAttribute("model","model123");
        request.setAttribute("request","request123");

        Cookie cookie = new Cookie("cookie","cookie123");

        return "forward:/success";
    }

    @ResponseBody
    @GetMapping("/success")
    public Map<String,Object> success(HttpServletRequest request){
        Map<String,Object> map= new HashMap<>();
        map.put("map",request.getAttribute("map"));
        map.put("model",request.getAttribute("model"));
        map.put("request",request.getAttribute("request"));

        return map;
    }

    @ResponseBody
    @GetMapping("/person")
    public Person getPerson(){
        return Person.builder().name("hello").age(12).build();
    }
}
