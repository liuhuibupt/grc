package com.charmingglobe.gr.controller;

import com.charmingglobe.gr.constants.RequestStatus;
import com.charmingglobe.gr.cri.UserRequestCri;
import com.charmingglobe.gr.entity.Cavalier;
import com.charmingglobe.gr.entity.UserRequest;
import com.charmingglobe.gr.entity.UserRequestSatellites;
import com.charmingglobe.gr.geo.GeometryTools;
import com.charmingglobe.gr.service.UserRequestService;
import com.vividsolutions.jts.geom.Geometry;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.ServletRequestDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

/**
 * Created by PANZHENG on 2017/11/18.
 * Edit by Liuhui on 2018/3/25
 * Edited by PanSN on 2018/4/
 */
@Controller
public class UserRequestController {

    @Autowired
    private UserRequestService userRequestService;

    @Autowired
    private GeometryTools geometryTools;

    @InitBinder
    public void InitBinder(HttpServletRequest request, ServletRequestDataBinder binder) {
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        dateFormat.setLenient(false);
        binder.registerCustomEditor(Date.class, null, new CustomDateEditor(
                dateFormat, true));
    }

    @RequestMapping("/userRequest-add")
    public String addUserRequest(Model model) {
        UserDetails userDetails = (UserDetails) SecurityContextHolder.getContext().getAuthentication() .getPrincipal();
        if (userDetails instanceof Cavalier) {
            Cavalier submitter = (Cavalier) userDetails;
            model.addAttribute("submitter", submitter);
        }
        return "user_request";
    }

    @RequestMapping("/submitUserRequest")
    public String submitUserRequest(UserRequest userRequest, int submitterId,String  isSubmit) {
        if(isSubmit.equals("下一步")) {
            userRequestService.submitUserRequest(userRequest, submitterId);
            int userRequestId = userRequest.getId();
            int count = 0;
            UserRequest replica = null;
            do {
                count++;
                replica = userRequestService.getUserRequest(userRequestId);
                if (count > 10)
                    return "error";
            } while (replica == null);
            return "redirect:userRequestSatellite?userRequestId=" + userRequestId;
        }
        else{
            int userRequestId = userRequest.getNum();
            userRequestService.editUserRequest(userRequestId,userRequest);
            return "redirect:userRequestSatellite?userRequestId=" + userRequestId;
        }
    }

    @RequestMapping("/userRequestSatellite")
    public String UserRequestSatellite(int userRequestId, Model model ,UserRequestSatellites userRequestSatellites) {
        UserRequest userRequest=userRequestService.getUserRequest(userRequestId);
        Cavalier submitter = userRequest.getSubmitter();
        model.addAttribute("submitter", submitter);
        model.addAttribute("userRequest", userRequest);
        model.addAttribute("userRequestSatellites", userRequestSatellites);
        UserDetails author = (UserDetails) SecurityContextHolder.getContext().getAuthentication() .getPrincipal();
        model.addAttribute("author", author);
        List<UserRequestSatellites> userSatelliteList = userRequestService.getUsersSatellitesByRequestNum(userRequestId);
        model.addAttribute("userSatelliteList", userSatelliteList);

        return "user_request_satellite";
    }

    @RequestMapping("/cancelUserRequest")
    public String cancelUserRequest(int userRequestId) throws InterruptedException {
        userRequestService.cancelUserRequest(userRequestId);
        Thread.sleep(500);
        return "redirect:userRequest?userRequestId=" + userRequestId;
    }

    @RequestMapping("/cancelRequestInList")
    public String cancelRequestInList(int userRequestId) throws InterruptedException {
        userRequestService.cancelUserRequest(userRequestId);
        Thread.sleep(500);

        return "redirect:userRequest-list";
    }

    @RequestMapping("/userRequest")
    public String viewUserRequest(int userRequestId, Model model) {
        UserRequest userRequest = userRequestService.getUserRequest(userRequestId);

        Cavalier submitter = userRequest.getSubmitter();
        model.addAttribute("submitter", submitter);

        Geometry imagingGeometry = userRequest.getImagingGeometry();
        String imagingGeojson = geometryTools.getGeoJsonFromGeometry(imagingGeometry);
        model.addAttribute("imagingGeojson", imagingGeojson);

        model.addAttribute("userRequest", userRequest);

        UserDetails author = (UserDetails) SecurityContextHolder.getContext().getAuthentication() .getPrincipal();
        model.addAttribute("author", author);
        return "user_request";
    }


    @RequestMapping("/userRequest-list")
    public String getUserRequestList(Model model,UserRequestCri cri) {
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

    @RequestMapping("/lastStepEditUserRequest")
    public String lastStepEditUserRequest(int userRequestId ) {
        return"redirect:userRequest?userRequestId="+userRequestId;
    }

    @RequestMapping("/addUserRequestSatellites")
    public String addUserRequestSatellites(UserRequestSatellites userRequestSatellites,int requestNum,Model model,String  isSubmit,String imagingMode101A,String imagingMode103B){
        String satellites=userRequestSatellites.getRequestSatellites();
        String imagingMode;
        if(satellites.equals("JL101A"))
            imagingMode = imagingMode101A;
        else if(satellites.equals("JL103B"))
            imagingMode = imagingMode103B;
        else
            imagingMode = userRequestSatellites.getImagingMode();

        if(isSubmit.equals("添加卫星")) {
            userRequestService.setUserRequestStatus(requestNum, RequestStatus.WAITINGFOR_SATELLITE);
            userRequestService.addUserRequestSatellites(userRequestSatellites,requestNum,imagingMode);
            List<UserRequestSatellites> userSatelliteList = userRequestService.getUsersSatellitesByRequestNum(requestNum);
            model.addAttribute("userSatelliteList", userSatelliteList);
            UserRequest userRequest = userRequestService.getUserRequest(requestNum);
            model.addAttribute("userRequest", userRequest);
            Cavalier submitter = userRequest.getSubmitter();
            model.addAttribute("submitter", submitter);
            return "user_request_satellite";
        }
        else {
            userRequestService.setUserRequestStatus(requestNum, RequestStatus.USER_REQUEST_SUBMITED);
            userRequestService.addUserRequestSatellites(userRequestSatellites,requestNum,imagingMode);
            return "redirect:user_request_detail?requestNum="+requestNum;
        }
    }

    @RequestMapping("/user_request_detail")
    public String user_request_detail(int requestNum,Model model) {
        List<UserRequestSatellites> userSatelliteList=userRequestService.getUsersSatellites();
        model.addAttribute("userSatelliteList", userSatelliteList);
        UserRequest userRequest = userRequestService.getUserRequest(requestNum);
        model.addAttribute("userRequest", userRequest);
        return "user_request_detail";
    }

    @RequestMapping("/DeleteUserRequest")
    public String deleteUserRequest(int userRequestId) {
        userRequestService.deleteUserRequest(userRequestId);
        return "user_request";
    }

    @RequestMapping("/DeleteUserRequestSatellite")
    public String deleteUserRequestSatellite(int userRequestSatelliteId, Model model) {
        UserRequestSatellites userRequestSatellites = userRequestService.getUserRequestSatellites(userRequestSatelliteId);
        UserRequest userRequest = userRequestSatellites.getUserRequest();
        model.addAttribute("userRequest", userRequest);
        Cavalier submitter = userRequest.getSubmitter();
        model.addAttribute("submitter", submitter);
        int userRequestNum=userRequest.getId();
        userRequestService.deleteUserRequestSatellite(userRequestSatelliteId);
        List<UserRequestSatellites> userSatelliteList = userRequestService.getUsersSatellitesByRequestNum(userRequestNum);
        model.addAttribute("userSatelliteList", userSatelliteList);
        return "user_request_satellite";
    }

    @RequestMapping("/cancelADDAndSubmitUserRequest")
    public String cancelADDAndSubmitUserRequest(int userRequestId) {

        userRequestService.cancelAndSubmit(userRequestId);
        return "redirect:user_request_detail?requestNum="+userRequestId;
    }

    @RequestMapping("/EditUserRequestSatellite")
    public String editUserRequestSatellite(int userRequestSatelliteId, Model model){
        UserRequestSatellites userRequestSatellites = userRequestService.getUserRequestSatellites(userRequestSatelliteId);
        UserRequest userRequest =userRequestSatellites.getUserRequest();
        model.addAttribute("userRequestSatellites", userRequestSatellites);
        model.addAttribute("userRequest", userRequest);
    return "modify_satellite_item";
    }


    @RequestMapping("/lastStepEditUserRequestSatellite")
    public String lastStepEditUserRequestSatellite(int userRequestId,Model model) {


        List<UserRequestSatellites> userSatelliteList = userRequestService.getUsersSatellitesByRequestNum(userRequestId);
        model.addAttribute("userSatelliteList", userSatelliteList);
        UserRequest userRequest = userRequestService.getUserRequest(userRequestId);
        model.addAttribute("userRequest", userRequest);
        Cavalier submitter = userRequest.getSubmitter();
        model.addAttribute("submitter", submitter);
        return "user_request_satellite";
    }



    @RequestMapping("/saveUserRequestSatellitesChanges")
    public String saveUserRequestSatellitesChanges(UserRequestSatellites userRequestSatellites,int requestNum,int userRequestSatelliteId) {


        UserRequest userRequest=userRequestService.getUserRequest(requestNum);
       userRequestService.editUserRequestSatellites(userRequestSatelliteId,userRequestSatellites,userRequest);

       int userRequestId=0;
        if(userRequest!=null) {
           userRequestId = userRequest.getId();
        }

        return "redirect:lastStepEditUserRequestSatellite?userRequestId="+userRequestId;

    }

    @RequestMapping("/test")
    public String test() {
        //return "testbutton";
        return "test";
    }
    @RequestMapping("/test2")
    public String test2() {
       return "testbutton";
       // return "test";
    }

}
