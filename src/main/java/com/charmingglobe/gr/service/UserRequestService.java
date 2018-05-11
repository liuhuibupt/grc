package com.charmingglobe.gr.service;

import com.alibaba.fastjson.JSON;
import com.charmingglobe.gr.constants.RequestStatus;
import com.charmingglobe.gr.cri.UserRequestCri;
import com.charmingglobe.gr.dao.UserDao;
import com.charmingglobe.gr.dao.UserRequestDao;
import com.charmingglobe.gr.entity.Cavalier;
import com.charmingglobe.gr.entity.ImageRequest;
import com.charmingglobe.gr.entity.UserRequest;
import com.charmingglobe.gr.entity.UserRequestSatellites;
import com.charmingglobe.gr.geo.GeometryTools;
import com.charmingglobe.gr.json.ImagingRequirement;
import com.charmingglobe.gr.json.QueryRequestStatusInfo;
import com.charmingglobe.gr.json.UserRequestInfo;
import com.charmingglobe.gr.utils.ImagingParaConverter;
import com.charmingglobe.gr.utils.TimeUtils;
import com.charmingglobe.gr.webservice.ImagingRequestWebService;
import com.vividsolutions.jts.geom.Geometry;
import org.apache.cxf.endpoint.Client;
import org.apache.cxf.jaxws.endpoint.dynamic.JaxWsDynamicClientFactory;
import org.hibernate.Session;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.ArrayList;


/**
 * Created by PANZHENG on 2017/12/4.
 * Edited by PanSN on 2018/4/
 */
@Service
public class UserRequestService {

    final int MAX_RESULT = 10;
    String userRequestInfoJson="";
    int imgNum=1;

    @Autowired
    private UserRequestDao userRequestDao;

    @Autowired
    private UserDao userDao;

    @Autowired
    private GeometryTools geometryTools;

    @Autowired
    private UserActionService userActionService;

    @Autowired
    private ImagingRequestWebService imagingRequestWebService;

    public void submitUserRequest(UserRequest userRequest, int submitterId) {
        Cavalier submitter = userDao.getUser(submitterId);
        String requestId = getNextRequestId();
        userRequest.setRequestId(requestId);

        String imagingParaTxt= userRequest.getImagingParaTxt();
        Map<String, String> imagingPara = ImagingParaConverter.toMap(imagingParaTxt);
        userRequest.setImagingPara(imagingPara);

        if (imagingPara != null && imagingPara.containsKey("imagingWkt")) {
            String imagingWkt = imagingPara.get("imagingWkt");
            Geometry imagingGeometry = geometryTools.getGeometryFromWKT(imagingWkt);
            userRequest.setImagingGeometry(imagingGeometry);
        }
        userRequest.setSubmitter(submitter);
        userRequest.setSubmitTime(new Date());
        userRequest.setEditTime(new Date());
        userRequest.setRequestFrom("内部需求");
        userRequest.setStatus(RequestStatus.INCOMPLETENESS_REQUEST);


        userRequestDao.saveUserRequest(userRequest);
        userActionService.addUserAction(userRequest);
    }

    public void addUserRequestSatellites(UserRequestSatellites userRequestSatellites,int requestNum,String imagingMode,String  isSubmit ) {
        UserRequest userRequest = userRequestDao.getUserRequestForWriting(requestNum);
        userRequestSatellites.setImagingMode(imagingMode);
        userRequestSatellites.setUserRequest(userRequest);
        String requestID=userRequest.getRequestId();
        userRequestSatellites.setImagingId(requestID+"_IMA_"+imgNum++);
        if(userRequestSatellites.getImagingDuration() == ""){
            if(userRequestSatellites.getRequestSatellites() == "JL101A")
                userRequestSatellites.setImagingDuration("无");
            else
                userRequestSatellites.setImagingDuration("30");
        }
        Date date=new Date();
        if(userRequestSatellites.getRequestStart()== null){
            userRequestSatellites.setRequestStart(date);
        }
        if(!(isSubmit.equals("添加卫星")))
        {
            transformUserRequestInfo(userRequest,userRequestSatellites,requestNum);
            imgNum=0;
        }
        userRequestDao.saveUserRequestSatellites(userRequestSatellites);
        userActionService.addUserAction(userRequest);
    }

    public void deleteUserRequest(int userRequestId){
        userRequestDao.deleteUserRequest(userRequestId);
    }

    public void deleteUserRequestSatellite(int userRequestSatelliteId){
        userRequestDao.deleteUserRequestSatellite(userRequestSatelliteId);
    }

    public void cancelUserRequest(int userRequestId) {
        userRequestDao.saveUserRequest(userRequestId, "Cancelled");
    }

    public void cancelAndSubmit(int userRequestId){
        userRequestDao.saveUserRequest(userRequestId,"已提交需求");
        UserRequest userRequest= getUserRequest(userRequestId);
        UserRequestSatellites userRequestSatellites = new UserRequestSatellites();
        transformUserRequestInfo(userRequest,userRequestSatellites,userRequestId);
    }

    public void setUserRequestStatus(int requestId,String status){
        userRequestDao.saveUserRequest(requestId,status);
    }

    public void  editUserRequest(int userRequestId,UserRequest userRequestInfo){
        UserRequest userRequest=userRequestDao.getUserRequestForWriting(userRequestId);
        Date date=new Date();
        userRequest.setEditTime(date);
        if(userRequestInfo.getRequestName()!= userRequest.getRequestName()){
            userRequest.setRequestName(userRequestInfo.getRequestName());
        }
        userRequest.setSensitive(userRequestInfo.isSensitive());
        userRequest.setPriority(userRequestInfo.getPriority());
        userRequest.setRequestUser(userRequestInfo.getRequestUser());
        userRequest.setResolution(userRequestInfo.getResolution());
        userRequest.setSideAngel(userRequestInfo.getSideAngel());
        userRequest.setCloud(userRequestInfo.getCloud());
        userRequest.setGeometryRequest(userRequestInfo.getGeometryRequest());
        userRequest.setRadiationRequest(userRequestInfo.getRadiationRequest());
        userRequest.setCoverage(userRequestInfo.getCoverage());

        String imagingParaTxt= userRequestInfo.getImagingParaTxt();
        Map<String, String> imagingPara = ImagingParaConverter.toMap(imagingParaTxt);
        if (imagingPara != null && imagingPara.containsKey("imagingWkt")) {
            String imagingWkt = imagingPara.get("imagingWkt");
            Geometry imagingGeometry = geometryTools.getGeometryFromWKT(imagingWkt);
            userRequest.setImagingGeometry(imagingGeometry);
        }

        userRequest.setRequestType(userRequestInfo.getRequestType());
        userRequest.setImagingPara(imagingPara);

        userRequestDao.updateUserRequest(userRequest);
    }

    private String getNextRequestId() {
        int count = userRequestDao.countUserRequestByDate(new Date());
        SimpleDateFormat f = new SimpleDateFormat("yyyyMMdd");
        String timestamp = f.format(new Date());
        return "REQ_USR_" + timestamp + "_" + (new String(10001 + count + "").substring(1, 5));
    }

    public UserRequest getUserRequest(int userRequestId) {
        UserRequest userRequest = userRequestDao.getUserRequest(userRequestId);
        Map<String, String> para = userRequest.getImagingPara();
        String paraTxt = ImagingParaConverter.toSring(para);
        userRequest.setImagingParaTxt(paraTxt);
        return userRequest;
    }

    public UserRequestSatellites getUserRequestSatellites(int userRequestSatellitesId) {
        UserRequestSatellites userRequestSatellites = userRequestDao.getUserRequestSatellites(userRequestSatellitesId);
        return userRequestSatellites;
    }

    public List<UserRequest> getUserRequestByDate(int day) {
        Calendar c = Calendar.getInstance();
        c.add(Calendar.DATE, day);
        Date date = c.getTime();
        return userRequestDao.selectUserRequestByDate(date);
    }

    public List<UserRequest> getUserRequestList(UserRequestCri cri) {
        cri.setMaxResult(MAX_RESULT);
        int pageNum = cri.getCurPageNum();
        if (pageNum < 0) {
            pageNum = 0;
            cri.setCurPageNum(pageNum);
        }

        int resultCount = userRequestDao.countUserRequestByConditions(cri);

        int totalPageNum = resultCount % MAX_RESULT == 0 ? resultCount / MAX_RESULT : resultCount / MAX_RESULT + 1;
        if (pageNum > totalPageNum) {
            pageNum = totalPageNum;
            cri.setCurPageNum(totalPageNum);
        }
        cri.setTotalPageNum(totalPageNum);
        cri.setResultCount(resultCount);
        //edited by PanSN on 0414
        List<UserRequest> userRequestList=userRequestDao.selectUserRequestByConditions(cri);
        //edited by PanSN on 0414
        return beautifyUserRequestList(userRequestList, pageNum);
    }

    public List<UserRequestSatellites> getUsersSatellites() {
        return userRequestDao.getAllUsersSatellites();
    }

    public List<UserRequestSatellites> getUsersSatellitesByRequestNum(int requestNum) {
        return userRequestDao.getUsersSatellitesByRequestNum(requestNum);
    }

    private List<UserRequest> beautifyUserRequestList(List<UserRequest> userRequestList, int pageNum) {
        int num = 1;
        Date zeroOfToday = TimeUtils.getZeroOfToday();
        for (UserRequest userRequest : userRequestList) {
            userRequest.setNum(pageNum * MAX_RESULT + num++);
            Date submitTime = userRequest.getSubmitTime();
            if (submitTime != null && submitTime.getTime() > zeroOfToday.getTime()) {
                userRequest.setLabel("today");
            }
        }
        return userRequestList;
    }

    public void  editUserRequestSatellites(int userRequestSatellitesId,UserRequestSatellites userRequestSatellites,UserRequest userRequest) {
        userRequestDao.deleteUserRequest(userRequestSatellitesId);
        userRequestSatellites.setId(userRequestSatellitesId);
        userRequestSatellites.setUserRequest(userRequest);
        userRequestDao.saveUserRequestSatellitesByMerge(userRequestSatellites);
    }

    public void  transformUserRequestInfo(UserRequest userRequest,UserRequestSatellites userRequestSatellites,int requestNum)
    {

        SimpleDateFormat formatyyyyMMddHHmmss = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        UserRequestInfo userRequestInfo=new UserRequestInfo();
        userRequestInfo.setRequestID(userRequest.getRequestId());
        userRequestInfo.setRequestName(userRequest.getRequestName());
        userRequestInfo.setPriority( Integer.parseInt(userRequest.getPriority()));
        userRequestInfo.setCloudPecent(userRequest.getCloud());
        userRequestInfo.setResolution(userRequest.getResolution());
        userRequestInfo.setSideAngel(userRequest.getSideAngel());
        userRequestInfo.setGeometryRequest(userRequest.getGeometryRequest());
        userRequestInfo.setRadiationRequest(userRequest.getRadiationRequest());
        userRequestInfo.setRequestType(userRequest.getRequestType());
        Map imagingGeometry=userRequest.getImagingPara();
        userRequestInfo.setImagingGeometry(imagingGeometry.toString());
        //
        userRequestInfo.setImagingMode(userRequestSatellites.getImagingMode());
        userRequestInfo.setImagingDuration(userRequestSatellites.getImagingDuration());
        userRequestInfo.setRequestStartTime(formatyyyyMMddHHmmss.format(userRequestSatellites.getRequestStart()));
        userRequestInfo.setRequestEndTime(formatyyyyMMddHHmmss.format(userRequestSatellites.getRequestEnd()));
        userRequestInfo.setShootNum(userRequestSatellites.getShootNum());
        //
        List<UserRequestSatellites> userRequestSatellitesList=getUsersSatellitesByRequestNum(requestNum);
        List<ImagingRequirement> imagingRequirementList=new ArrayList<ImagingRequirement>();

        ImagingRequirement imagingRequirement=new ImagingRequirement();
        imagingRequirement.setImagingID(userRequestSatellites.getImagingId());
        imagingRequirement.setSatelliteID(userRequestSatellites.getRequestSatellites());
        imagingRequirement.setStartTime(formatyyyyMMddHHmmss.format(userRequestSatellites.getRequestStart()));
        imagingRequirement.setEndTime(formatyyyyMMddHHmmss.format(userRequestSatellites.getRequestEnd()));
        imagingRequirement.setTimes(userRequestSatellites.getShootNum());
        imagingRequirementList.add(imagingRequirement);
        for (UserRequestSatellites requestSatellites : userRequestSatellitesList) {
            ImagingRequirement imagingRequirementTmp=new ImagingRequirement();
            imagingRequirementTmp.setImagingID(requestSatellites.getImagingId());
            imagingRequirementTmp.setSatelliteID(requestSatellites.getRequestSatellites());
            imagingRequirementTmp.setStartTime(formatyyyyMMddHHmmss.format(requestSatellites.getRequestStart()));
            imagingRequirementTmp.setEndTime(formatyyyyMMddHHmmss.format(requestSatellites.getRequestEnd()));
            imagingRequirementTmp.setTimes(requestSatellites.getShootNum());
            imagingRequirementList.add(imagingRequirementTmp);
        }
        userRequestInfo.setImagingRequirement(imagingRequirementList);
        String userRequestInfoJson = JSON.toJSONString(userRequestInfo);
        String result= imagingRequestWebService.submitUserRequirement(userRequestInfoJson);
    }


    public void  invokingQueryRequestStatusInfo(UserRequest userRequest,int requestNum)
    {

        String queryRequestStatusInfoInput=imagingRequestWebService.getImagingRequirementList(userRequest.getRequestId());
        QueryRequestStatusInfo queryRequestStatusInfo=JSON.parseObject(queryRequestStatusInfoInput, QueryRequestStatusInfo.class);
        userRequestDao.insertUserRequestReturnStatus(requestNum, queryRequestStatusInfo);

    }

}
