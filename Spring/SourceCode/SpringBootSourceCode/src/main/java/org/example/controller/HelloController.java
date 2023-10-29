package org.example.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

@Controller
public class HelloController {


    @ResponseBody
    @RequestMapping(value = "/hello",method = RequestMethod.GET)
    public String hello(){
        return "Hello World!";
    }


}
