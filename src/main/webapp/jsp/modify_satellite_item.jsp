<%--
  Created by PanSN.
  User: victory
  Date: 2018/4/18
  Time: 10:30
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri='http://www.springframework.org/security/tags' prefix='sec' %>
<c:set var="serverUrl" value="${pageContext.request.scheme}${'://'}${pageContext.request.serverName}${':'}${pageContext.request.serverPort}${pageContext.request.contextPath}" />
<html>
<head>
    <title>修改拍摄卫星参数</title>
    <link rel="stylesheet" type="text/css" href="${serverUrl}/css/calendar.min.css">
    <script src="${serverUrl}/Cesium/Cesium.js"></script>
    <script src="${serverUrl}/Cesium/DrawTool.js"></script>
    <script src="${serverUrl}/Cesium/DrawHelper.js"></script>
    <script src="${serverUrl}/js/calendar.js"></script>
    <script>
        $(document).ready(function () {
            $('.ui.selection.dropdown').dropdown();
            $('.ui.dropdown').dropdown();

            $('#testPopup').popup({
                hoverable: true,
                delay: {
                    show: 100,
                    hide: 100
                }
            });
            $('.ui.form').form({
                fields: {
                    requestSatellites: {
                        identifier: 'requestSatellites',
                        rules: [
                            {
                                type: 'empty',
                                prompt: 'Please enter [Satellites]'
                            }
                        ]
                    },
                    imagingMode: {
                        identifier: 'imagingMode',
                        rules: [
                            {
                                type: 'empty',
                                prompt: 'Please enter [imagingMode]'
                            }
                        ]
                    }
                }
            });

            $('#requestStartDiv').calendar({
                type: 'datetime'
            });
            $('#requestEndDiv').calendar({
                type: 'datetime'
            });


            $('#requestSatellites').change(function () {
                $('#imagingMode').show();
                $('imagingModeOthersDataToolTip').hide();
                $('imagingModeJL101ADataToolTip').hide();
                $('imagingModeJL103BDataToolTip').hide();
                var val = $(this).val();
                if(val == 'JL101A'){
                    $('imagingModeJL101ADataToolTip').show();
                }
                if(val == 'JL103B'){
                    $('imagingModeJL103BDataToolTip').hide();
                }
                if(val != 'JL101A' && val != 'JL103B'){
                    $('imagingModeOthersDataToolTip').hide();
                }

            });
            $('#imagingModeId').change(function () {
                $('#Duration_isMultiGrid').hide();
                var val = $(this).val();
                if (val == '凝视成像' || val == '夜光凝视成像') {
                    $('#Duration_isMultiGrid').show();
                }
            });

        });
        function setRequestDate(obj, future) {
            var today = new Date();
            var year = today.getFullYear();
            var month = today.getMonth() + 1;
            var date = today.getDate() + future;

            month = month > 9 ? month : '0' + month;
            date = date > 9 ? date : '0' + date;

            if ('start' == obj) {
                $('#requestStart').val(year + '-' + month + '-' + date + ' 00:00:00');
            }
            if ('end' == obj) {
                $('#requestEnd').val(year + '-' + month + '-' + date + ' 23:59:59');
            }
        }
    </script>
</head>
<body>

    <h2>修改卫星参数</h2>

<div class="ui divider"></div>

<form class="ui form" action="saveUserRequestSatellitesChanges" method="post">

    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
    <input type="hidden" id="productDeliveryModel" name="productDeliveryModel" >
    <input type="hidden" id="productDeliveryURL" name="productDeliveryURL">
    <input type="hidden" id="requestNum" name="requestNum" value="${userRequest.id}">
    <input type="hidden" id="userRequestSatelliteId" name="userRequestSatelliteId" value="${userRequestSatellites.id}">
    <%--拍摄卫星&成像模式&成像时长&是否多宫格拍摄--%>
    <div class="four fields">
        <%--拍摄卫星--%>
        <div class="field" data-tooltip="请选择执行拍摄的卫星">
            <label>需求卫星</label>
            <div class="ui fluid dropdown selection" tabindex="0">
                <select id="requestSatellites" name="requestSatellites">
                    <option value=""></option>
                    <option value="JL101A" <c:if test="${userRequestSatellites.requestSatellites == 'JL101A'}">selected</c:if>>光学A星</option>
                    <option value="JL103B" <c:if test="${userRequestSatellites.requestSatellites == 'JL103B'}">selected</c:if>>视频03星</option>
                    <option value="JL104B" <c:if test="${userRequestSatellites.requestSatellites == 'JL104B'}">selected</c:if>>视频04星</option>
                    <option value="JL105B" <c:if test="${userRequestSatellites.requestSatellites == 'JL105B'}">selected</c:if>>视频05星</option>
                    <option value="JL106B" <c:if test="${userRequestSatellites.requestSatellites == 'JL106B'}">selected</c:if>>视频06星</option>
                    <option value="JL107B" <c:if test="${userRequestSatellites.requestSatellites == 'JL107B'}">selected</c:if>>视频07星</option>
                    <option value="JL108B" <c:if test="${userRequestSatellites.requestSatellites == 'JL108B'}">selected</c:if>>视频08星</option>
                </select><i class="dropdown icon"></i>
                <div class="default text">需求卫星</div>
                <div class="menu transition hidden" tabindex="-1">
                    <div class="item" data-value="JL101A">光学A星</div>
                    <div class="item" data-value="JL103B">视频03星</div>
                    <div class="item" data-value="JL104B">视频04星</div>
                    <div class="item" data-value="JL105B">视频05星</div>
                    <div class="item" data-value="JL106B">视频06星</div>
                    <div class="item" data-value="JL107B">视频07星</div>
                    <div class="item" data-value="JL108B">视频08星</div>
                </div>
            </div>
        </div>
        <%--成像模式--%>
        <div class="field" id="imagingMode" >
            <div id="imagingModeOthersDataToolTip"data-tooltip="请选择成像模式,A星目前只能选择推扫模式，03星只能选择凝视成像或夜光凝视成像">
                <label>成像模式</label>
                <div class="ui fluid dropdown selection" tabindex="0">
                    <select id="imagingModeId" name="imagingMode">
                        <option value=""></option>
                        <option value="推扫成像" <c:if test="${userRequestSatellites.imagingMode == '推扫成像'}">selected</c:if>>推扫成像</option>
                        <option value="凝视成像" <c:if test="${userRequestSatellites.imagingMode == '凝视成像'}"> selected</c:if>>凝视成像</option>
                        <option value="夜光凝视成像" <c:if test="${userRequestSatellites.imagingMode == '夜光凝视成像'}">selected</c:if>>夜光凝视成像</option>
                    </select><i class="dropdown icon"></i>
                    <div class="default text">成像模式</div>
                    <div class="menu transition hidden" tabindex="-1">
                        <div class="item" data-value="推扫成像">推扫成像</div>
                        <div class="item" data-value="凝视成像">凝视成像</div>
                        <div class="item" data-value="夜光凝视成像">夜光凝视成像</div>
                    </div>
                </div>
            </div>
        </div>


        <%--成像时长&多宫格--%>
        <div class="two fields" id="Duration_isMultiGrid">
            <div class="field" data-tooltip="请输入视频要求成像时长,单位是s,默认为30s">
                <label>成像时长</label>
                <input type="text" id="imagingDuration" name="imagingDuration" placeholder="成像时长" value="${userRequestSatellites.imagingDuration}">
            </div>
            <div class="field" data-tooltip="请选择是否多宫格拍摄,默认为否" >
                <label>是否选择多宫格</label>
                <div class="ui fluid dropdown selection" tabindex="0">
                    <select id="isMultiGrid" name="multiGrid">
                        <option value=""></option>
                        <option value="true" <c:if test="${userRequestSatellites.multiGrid eq true}">selected</c:if>>是</option>
                        <option value="false" <c:if test="${userRequestSatellites.multiGrid eq false}">selected</c:if>>否</option>
                    </select><i class="dropdown icon"></i>
                    <div class="default text">否</div>
                    <div class="menu transition hidden" tabindex="-1">
                        <div class="item" data-value="true">是</div>
                        <div class="item" data-value="false">否</div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <%--开始时间&结束时间&次数--%>
    <div class="field">
        <div class="four fields">
            <div class="field">
                <label>需求开始时间</label>
                <div class="ui calendar" id="requestStartDiv">
                    <div class="ui input left icon">
                        <i class="calendar icon"></i>
                        <input type="texts" id="requestStart" name="requestStart" placeholder="Request Start" value="${userRequestSatellites.requestStart}">
                    </div>
                </div>
            </div>
            <div class="field">
                <label>需求结束时间</label>
                <div class="ui calendar" id="requestEndDiv">
                    <div class="ui input left icon">
                        <i class="calendar icon"></i>
                        <input type="text" id="requestEnd" name="requestEnd" placeholder="Request End" value="${userRequestSatellites.requestEnd}">
                    </div>
                </div>
            </div>
            <div class="four wide field" data-tooltip="请填写拍摄次数,默认次数为1">
                <label>拍摄次数</label>   <%----%>
                <input type="number" id="shootNum" name="shootNum" placeholder="拍摄次数" value="${userRequestSatellites.shootNum}">
            </div>
        </div>
    </div>
    <div class="field">
        <div class="four fields">
            <div class="field">
                <a class="mini ui teal labeled icon button" href="javascript:setRequestDate('start', 0)">
                    <i class="checked calendar icon"></i>
                    Enter Today
                </a>
                <div class="mini ui floating teal labeled icon dropdown button">
                    <i class="right arrow icon"></i>
                    <span>More Selection</span>
                    <div class="left menu">
                        <div class="item" onclick="javascript:setRequestDate('start', 2)">2 days later</div>
                        <div class="item" onclick="javascript:setRequestDate('start', 3)">3 days later</div>
                        <div class="item" onclick="javascript:setRequestDate('start', 4)">4 days later</div>
                        <div class="item" onclick="javascript:setRequestDate('start', 5)">5 days later</div>
                        <div class="item" onclick="javascript:setRequestDate('start', 6)">6 days later</div>
                        <div class="item" onclick="javascript:setRequestDate('start', 7)">7 days later</div>
                    </div>
                </div>
            </div>
            <div class="field">
                <a class="mini ui teal labeled icon button" href="javascript:setRequestDate('end', 1)">
                    <i class="checked calendar icon"></i>
                    Enter Tomorrow
                </a>
                <div class="mini ui floating teal labeled icon dropdown button">
                    <i class="right arrow icon"></i>
                    <span>More Selection</span>
                    <div class="left menu">
                        <div class="item" onclick="javascript:setRequestDate('end', 2)">2 days later</div>
                        <div class="item" onclick="javascript:setRequestDate('end', 3)">3 days later</div>
                        <div class="item" onclick="javascript:setRequestDate('end', 4)">4 days later</div>
                        <div class="item" onclick="javascript:setRequestDate('end', 5)">5 days later</div>
                        <div class="item" onclick="javascript:setRequestDate('end', 6)">6 days later</div>
                        <div class="item" onclick="javascript:setRequestDate('end', 7)">7 days later</div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="field">
        <div class="sixteen fields">
            <div class="field">
                <input type="submit" class="ui teal submit button" value="保存修改"/>
            </div>
            <div class="sixteen fields">
                <a class="ui teal submit button"  href="lastStepEditUserRequestSatellite?userRequestId=${userRequestId}">上一步</a>
            </div>
        </div>
    </div>

</form>

</body>

