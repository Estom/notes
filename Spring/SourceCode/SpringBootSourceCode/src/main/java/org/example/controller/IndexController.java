package org.example.controller;

import org.example.bean.User;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import javax.servlet.http.HttpSession;

/**
 * 1. 模板引擎下的模板都放在templates下边：首先templates下边所有的页面都不在静态页面路径下，无法通过前端直接访问，也避免了前端直接访问，
 * 只能经过模板引擎渲染后返回给前端，增强了安全性。
 * 2. return一个页面是选择一个视图进行渲染。redirect一个页面是前端重新发起一个请求，会修改前端的地址栏路径。防止刷新表单重复提交的方式就是
 * 表单提交后重定向到另外一个页面，而不是停留在表单页。
 */
@Controller
public class IndexController {

    @GetMapping(value = {"/login"})
    public String getIndex(){
        return "pages/examples/login";
    }

    //转发意味着地址栏还是原来的页面。
    @PostMapping("/login")
    public String login(User user, HttpSession session, Model model){
        if (StringUtils.isEmpty(user.getUserName()) || StringUtils.isEmpty(user.getPassword())){
            model.addAttribute("msg","username or password is error");
            return "pages/examples/login";
        }
        session.setAttribute("user",user);
        return "redirect:index";
    }

    @GetMapping({"/","/index"})
    public String index(){
        return "index";
    }
}
