package com.charmingglobe.gr.controller;

import com.charmingglobe.gr.cri.UserRequestCri;
import com.charmingglobe.gr.entity.Cavalier;
import com.charmingglobe.gr.entity.UserRequest;
import com.charmingglobe.gr.service.UserRequestService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

@Controller
public class MyController {

    @Autowired
    UserRequestService userRequestService;
    @Autowired
    UserRequestController userRequestController;

    @RequestMapping("/today")
    public String today(Model model,UserRequestCri cri){
        UserDetails userDetails = (UserDetails) SecurityContextHolder.getContext().getAuthentication() .getPrincipal();
        if (userDetails instanceof Cavalier) {
            Cavalier submitter = (Cavalier) userDetails;
            model.addAttribute("submitter", submitter);
        }
        List<UserRequest> userRequestList = userRequestService.getUserRequestList(cri);
        model.addAttribute("resultSet", userRequestList);
        model.addAttribute("cri", cri);
        return "user_request_list";
    }

    @RequestMapping("/sticky")
    public String sticky(Model model) {

        return "sticky";
    }

}
