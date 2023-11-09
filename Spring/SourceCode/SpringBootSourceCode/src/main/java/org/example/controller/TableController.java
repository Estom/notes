package org.example.controller;


import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@RequestMapping("/pages/tables")
@Controller
public class TableController {

    @RequestMapping("/data.html")
    public String getDataTable(){
        return "pages/tables/data";
    }

    @RequestMapping("/simple.html")
    public String getSimpleTable(){
        return "pages/tables/simple";
    }

    @RequestMapping("/jsgrid.html")
    public String getJsGridTable(){
        return "pages/tables/jsgrid";
    }
}
