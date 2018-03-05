package com.charmingglobe.gr.webservice;

import com.charmingglobe.gr.entity.UserRequest;
import com.charmingglobe.gr.service.UserRequestService;
import com.charmingglobe.gr.webservice.result.ImagingPlanResult;
import com.charmingglobe.gr.webservice.result.ImagingTaskResult;
import com.charmingglobe.gr.webservice.result.UserRequestResult;
import org.springframework.beans.factory.annotation.Autowired;

import javax.jws.WebMethod;
import javax.jws.WebService;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by PANZHENG on 2018/1/23.
 */
@WebService
public class MissionPlanWebService {

    @Autowired
    UserRequestService userRequestService;

    @WebMethod
    public List<UserRequestResult> getUserRequestList(int day) {
        List<UserRequest> userRequestList =  userRequestService.getUserRequestByDate(day);
        List<UserRequestResult> resultList = new ArrayList<UserRequestResult>();
        for (UserRequest userRequest:userRequestList) {
            resultList.add(new UserRequestResult(userRequest));
        }
        return resultList;
    }

    @WebMethod
    public String inputImagingPlans(String json) {
        return "";
    }

    @WebMethod
    public List<ImagingPlanResult> getImagingPlanList(int day) {

        return null;
    }

    @WebMethod
    public String inputImaingTasks(String json) {

        return null;
    }

    @WebMethod
    public List<ImagingTaskResult> getImagingTaskList(int day) {

        return null;
    }
}
