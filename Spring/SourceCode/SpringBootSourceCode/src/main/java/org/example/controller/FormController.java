package org.example.controller;


import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class FormController {

    @GetMapping("pages/forms/general.html")
    private String getForm(){
        return "pages/forms/general.html";
    }



    @GetMapping("pages/forms/advanced.html")
    private String getAdvanceForm(){
        return "pages/forms/advanced.html";
    }
}
