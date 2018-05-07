<%--
  Created by PanSN.
  User: Pan
  Date: 2018/5/5
  Time: 11:40
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri='http://www.springframework.org/security/tags' prefix='sec' %>
<c:set var="serverUrl" value="${pageContext.request.scheme}${'://'}${pageContext.request.serverName}${':'}${pageContext.request.serverPort}${pageContext.request.contextPath}" />

<html>

<head>
    <title>用户需求详细信息</title>
    <link rel="stylesheet" type="text/css" href="${serverUrl}/css/calendar.min.css">

    <script src="${serverUrl}/Cesium/Cesium.js"></script>
    <script src="${serverUrl}/Cesium/DrawTool.js"></script>
    <script src="${serverUrl}/Cesium/DrawHelper.js"></script>
    <script src="${serverUrl}/js/calendar.js"></script>
    <script>
        $(document).ready(function() {


            $(document).ready(function () {

                $('div[name="moreDetail"]').popup({
                    hoverable: true,
                    delay: {
                        show: 100,
                        hide: 100
                    }
                });
            });
        });

    </script>
    <style>
        body,html {
            margin: 0px 20px 0px 20px;
            padding: 0;
            height: 100%;
        }
    </style>
</head>
<body>

<div class="ui teal submit button">需求详细信息：</div>
<table class="ui celled table">
    <thead>
    <tr>
        <th width="10%">需求名称</th>
        <th width="10%">需求编号</th>
        <th width="10%">优先级</th>
        <th width="10%">需求状态</th>
        <th width="10%">提交日期</th>
        <th width="10%">提交人</th>
        <th width="10%">需求规划状态</th>
        <th width="10%">分辨率</th>
        <th width="10%">更多</th>
    </tr>
    </thead>
    <tbody>
    <tr>
        <td>${userRequest.requestName}</td>
        <td>${userRequest.requestId}</td>
        <td>${userRequest.priority}</td>
        <td>${userRequest.status}</td>
        <td><fmt:formatDate value="${userRequest.submitTime}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
        <td>${userRequest.requestUser}</td>
        <td>${userRequest.returnRequestStatus}</td>
        <td>${userRequest.resolution}</td>
        <td>

            <div class="ui label" name="moreDetail"><i class="list icon"></i>More</div>
            <div class="ui flowing popup top left transition hidden">
                <div class="ui divided selection list">
                    <div class="item">
                        <div class="ui teal horizontal icon label">
                            <i class="in cart icon"></i>需求来源</div>
                        ${userRequest.requestFrom}
                    </div>
                    <div class="item">
                        <div class="ui teal horizontal icon label">
                            <i class="user icon"></i>&nbsp;需求类型</div>
                        ${userRequest.requestType}
                    </div>
                    <div class="item">
                        <div class="ui teal horizontal icon label">
                            <i class="marker icon"></i>&nbsp;&nbsp;侧摆要求</div>
                        ${userRequest.sideAngel}
                    </div>
                    <div class="item">
                        <div class="ui teal horizontal icon label">
                            <i class="camera retro icon"></i>云量要求</div>
                        ${userRequest.cloud}
                    </div>
                    <div class="item">
                        <div class="ui teal horizontal icon label">
                            <i class="camera retro icon"></i>辐射要求</div>
                        ${userRequest.radiationRequest}
                    </div>
                    <div class="item">
                        <div class="ui teal horizontal icon label">
                            <i class="camera retro icon"></i>覆盖要求</div>
                        ${userRequest.coverage}
                    </div>
                    <div class="item">
                        <div class="ui teal horizontal icon label">
                            <i class="camera retro icon"></i>成像坐标</div>
                        ${userRequest.imagingPara}
                    </div>
                </div>
            </div>

        </td>

    </tr>
    </tbody>
</table>
<div class="ui teal submit button">卫星参数信息：</div>
<table class="ui celled table">
    <thead>
    <tr>
        <th width="10%">需求卫星</th>
        <th width="10%">成像模式</th>
        <th width="10%">拍摄开始时间</th>
        <th width="10%">拍摄结束时间</th>
        <th width="10%">需求规划状态</th>
        <th width="10%">拍摄次数</th>
        <th width="10%">拍摄时长，单位s</th>
        <th width="10%">是否多宫格</th>
        <th width="10%">更多</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach items="${userSatelliteList}" var="userSatellite">
        <tr>
            <c:if test="${userSatellite.userRequest.id == userRequest.id}">
                <td>${userSatellite.requestSatellites}</td>
                <td>${userSatellite.imagingMode}</td>
                <td><fmt:formatDate value="${userSatellite.requestStart}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
                <td><fmt:formatDate value="${userSatellite.requestEnd}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
                <td>${userSatellite.returnImagingStatus}</td>
                <td>${userSatellite.shootNum}</td>
                <td>${userSatellite.imagingDuration}</td>
                <td>${userSatellite.multiGrid}</td>

                <td></td>
            </c:if>
        </tr>
    </c:forEach>
    </tbody>
</table>
</body>
</html>
