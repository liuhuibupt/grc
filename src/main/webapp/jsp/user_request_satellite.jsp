<%--CREATED BY LIUHUI & PANSHENGNAN ON 2018/3/27--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri='http://www.springframework.org/security/tags' prefix='sec' %>
<c:set var="serverUrl" value="${pageContext.request.scheme}${'://'}${pageContext.request.serverName}${':'}${pageContext.request.serverPort}${pageContext.request.contextPath}" />
<html>
<head>
    <title>录入需求-拍摄要求</title>
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

                }
            });

            $('#requestStartDiv').calendar({
                type: 'datetime'
            });
            $('#requestEndDiv').calendar({
                type: 'datetime'
            });

            $('#requestSatellites').change(function () {


                $('#dateAndTime').show();
                $('#timeShortcutButton').show();
                $('#imagingModeOthers').hide();
                $('#imagingModeJL101A').hide();
                $('#imagingModeJL103B').hide();

                var val = $(this).val();

                if (val == 'JL101A') {
                    $('#imagingModeJL101A').show();
                    $('#Duration_isMultiGrid').hide();
                }
                if (val == 'JL103B') {
                    $('#imagingModeJL103B').show();
                    $('#Duration_isMultiGrid').show();
                }
                if (val != 'JL103B' && val != 'JL101A') {
                    $('#imagingModeOthers').show();
                }
            });

            $('#imagingMode').change(function () {
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
    <script type="text/javascript">
        function del(){
            if(!confirm("确认要删除？")){
                window.event.returnValue = false;
            }
        }
    </script>
    <script type="text/javascript">
        window.onbeforeunload = function() {
            return "您还没有提交此需求，确认离开当前页面吗？";
        }
        function destroy(){
            window.onbeforeunload = null;
        }
    </script>
    <style>
        .bottom {
            position:fixed; bottom:0;
        }
        body,html {
            margin: 0px 20px 0px 20px;
            padding: 0;
            height: 100%;
        }
        .left-side {
            float: left;
            width: 20%;
        }
        .right-side {
            float: right;
            width: 78%;
            height: 100%;
        }

    </style>

</head>
<body>
<h2>录入需求-拍摄需求
    <%--标签行--%>
    <div class="sixteen fields">
        <div class="field">
            <c:if test="${userRequest != null}"><a class="ui tag label">
                需求名称<dev class="detail">${userRequest.requestName}</dev>
            </a></c:if>
            <c:if test="${userRequest != null}"><a class="ui tag label">
                需求编号<dev class="detail">${userRequest.requestId}</dev>
            </a></c:if>
            <c:if test="${userRequest != null}"><a class="ui tag label">
                此需求为<dev class="detail">
                <c:if test="${userRequest.sensitive eq false}">非</c:if>
                <c:if test="${userRequest.sensitive eq true}"></c:if>
                敏感需求
            </dev>
            </a></c:if>
            <c:if test="${userRequest != null}"><a class="ui tag label">
                优先级<dev class="detail">${userRequest.priority}</dev>
            </a></c:if>
            <c:if test="${userRequest != null}"><a class="ui tag label">
                提交日期<dev class="detail"><fmt:formatDate value="${userRequest.submitTime}" pattern="yyyy-MM-dd HH:mm:ss"/></dev>
            </a></c:if>
            <a class="ui tag label">
                需求提交人<dev class="detail">${submitter.displayName}</dev>
            </a>
        </div>
    </div>

</h2>
<div class="ui divider"></div>

<div class="left-side">
    <c:if test="${userRequest.status == '需求提交不完整，缺少卫星信息'}">
        <h3>添加卫星参数</h3>
    </c:if>
    <c:if test="${userRequest.status != '需求提交不完整，缺少卫星信息'}">
        <h3>继续添加卫星参数</h3>
    </c:if>
    <div class="ui divider"></div>
    <form class="ui form" action="addUserRequestSatellites" method="post" onsubmit="return destroy()">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
        <input type="hidden" id="productDeliveryModel" name="productDeliveryModel" >
        <input type="hidden" id="productDeliveryURL" name="productDeliveryURL">
        <input type="hidden" id="requestNum" name="requestNum" value="${userRequest.id}">


        <%--拍摄卫星--%>
        <div class="field" data-tooltip="请选择执行拍摄的卫星">
            <label>需求卫星</label>
            <div class="ui fluid dropdown selection" tabindex="0">
                <select id="requestSatellites" name="requestSatellites" >
                    <option value=""></option>
                    <option value="JL101A" <c:if test="${userRequestSatellites.requestSatellites == 'JL101A'}"></c:if>>光学A星</option>
                    <option value="JL103B" <c:if test="${userRequestSatellites.requestSatellites == 'JL103B'}"></c:if>>视频03星</option>
                    <option value="JL104B" <c:if test="${userRequestSatellites.requestSatellites == 'JL104B'}"></c:if>>视频04星</option>
                    <option value="JL105B" <c:if test="${userRequestSatellites.requestSatellites == 'JL105B'}"></c:if>>视频05星</option>
                    <option value="JL106B" <c:if test="${userRequestSatellites.requestSatellites == 'JL106B'}"></c:if>>视频06星</option>
                    <option value="JL107B" <c:if test="${userRequestSatellites.requestSatellites == 'JL107B'}"></c:if>>视频07星</option>
                    <option value="JL108B" <c:if test="${userRequestSatellites.requestSatellites == 'JL108B'}"></c:if>>视频08星</option>
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
        <%--拍摄次数--%>
        <div class="field" data-tooltip="请填写拍摄次数,默认次数为1">
            <label>拍摄次数</label>
            <input type="number" id="shootNum" name="shootNum" value="1" placeholder="拍摄次数" >
        </div>

        <%--成像模式:除A星3星外的其他星--%>
        <div class="field" id="imagingModeOthers" style="display: none">
            <div class="field" data-tooltip="请选择成像模式" >
                <label>成像模式</label>
                <div class="ui fluid dropdown selection" tabindex="0">
                    <select id="imagingMode" name="imagingMode">
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
        <%--成像模式:A星--%>
        <div class="field" id="imagingModeJL101A" style="display: none">
            <div class="field" data-tooltip="A星只能选择推扫">
                <label>成像模式</label>
                <div class="ui fluid dropdown selection" tabindex="0">
                    <select id="imagingMode1" name="imagingMode101A">
                        <option value=""></option>
                        <option value="推扫成像" <c:if test="${userRequestSatellites.imagingMode == '推扫成像'}">selected</c:if>>推扫成像</option>
                    </select><i class="dropdown icon"></i>
                    <div class="default text">成像模式</div>
                    <div class="menu transition hidden" tabindex="-1">
                        <div class="item" data-value="推扫成像">推扫成像</div>
                    </div>
                </div>
            </div>
        </div>
        <%--成像模式:3星--%>
        <div class="field" id="imagingModeJL103B" style="display: none">
            <div class="field" data-tooltip="请选择成像模式" >
                <label>成像模式</label>
                <div class="ui fluid dropdown selection" tabindex="0">
                    <select id="imagingMode2" name="imagingMode103B">
                        <option value=""></option>
                        <option value="凝视成像" <c:if test="${userRequestSatellites.imagingMode == '凝视成像'}"> selected</c:if>>凝视成像</option>
                        <option value="夜光凝视成像" <c:if test="${userRequestSatellites.imagingMode == '夜光凝视成像'}">selected</c:if>>夜光凝视成像</option>
                    </select><i class="dropdown icon"></i>
                    <div class="default text">成像模式</div>
                    <div class="menu transition hidden" tabindex="-1">
                        <div class="item" data-value="凝视成像">凝视成像</div>
                        <div class="item" data-value="夜光凝视成像">夜光凝视成像</div>
                    </div>
                </div>
            </div>
        </div>
        <%--成像时长&多宫格--%>
        <div class="two fields" id="Duration_isMultiGrid" style="display: none">
            <div class="field" data-tooltip="请输入视频要求成像时长,单位是s,默认为30s">
                <label>成像时长</label>
                <input type="text" id="imagingDuration" name="imagingDuration" placeholder="成像时长">
            </div>
            <div class="field" data-tooltip="请选择是否多宫格拍摄,默认为否" >
                <label>是否选择多宫格</label>
                <div class="ui fluid dropdown selection" tabindex="0">
                    <select id="isMultiGrid" name="multiGrid">
                        <option value=""></option>
                        <option value="true">是</option>
                        <option value="false" selected>否</option>
                    </select><i class="dropdown icon"></i>
                    <div class="default text">否</div>
                    <div class="menu transition hidden" tabindex="-1">
                        <div class="item" data-value="true">是</div>
                        <div class="item" data-value="false">否</div>
                    </div>
                </div>
            </div>
        </div>

        <%--开始时间&结束时间&次数--%>
        <div class="field" id="dateAndTime" style="display: none">
            <div class="field">
                <label>需求开始时间</label>
                <div class="ui calendar" id="requestStartDiv">
                    <div class="ui input left icon">
                        <i class="calendar icon"></i>
                        <input type="texts" id="requestStart" name="requestStart" placeholder="Request Start" value="${userRequestSatellites.requestStart}">
                    </div>
                </div>
            </div>
            <div class="field"></div>
            <div class="field">
                <a class="mini ui teal labeled icon button" href="javascript:setRequestDate('start', 0)">
                    <i class="checked calendar icon"></i>
                    Today
                </a>
                <div class="mini ui floating teal labeled icon dropdown button">
                    <i class="right arrow icon"></i>
                    <span>More Date</span>
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
                <label>需求结束时间</label>
                <div class="ui calendar" id="requestEndDiv">
                    <div class="ui input left icon">
                        <i class="calendar icon"></i>
                        <input type="text" id="requestEnd" name="requestEnd" placeholder="Request End" value="${userRequestSatellites.requestEnd}">
                    </div>
                </div>
            </div>
            <div class="field"></div>
            <div class="field">
                <a class="mini ui teal labeled icon button" href="javascript:setRequestDate('end', 1)">
                    <i class="checked calendar icon"></i>
                    Tomorrow
                </a>
                <div class="mini ui floating teal labeled icon dropdown button">
                    <i class="right arrow icon"></i>
                    <span>More Date</span>
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

        <div class="bottom">
            <div class="field">
                <div class="sixteen fields">
                    <div class="field">
                        <input type="submit" class="ui fluid  teal submit button" name="isSubmit" value="添加卫星"/>
                    </div>
                    <div class="field">
                        <c:if test="${author.id != submitter.id}">
                            <sec:authorize access="hasRole('ROLE_ADMIN')">
                                <div class="field">
                                    <a class="ui blue submit button" onclick="return destroy()"  href="cancelADDAndSubmitUserRequest?userRequestId=${userRequest.id}">取消本次添加，并提交</a>
                                </div>
                            </sec:authorize>
                        </c:if>
                    </div>
                    <div class="field">
                        <input type="submit" class="ui fluid  teal submit button" name="isSubmit" value="提交需求"/>
                    </div>
                    <div class="field"></div>
                    <div class="field">
                        <a class="ui teal submit button"  href="lastStepEditUserRequest?userRequestId=${userRequest.id}">返回上一步</a>
                    </div>

                    <div class="field">
                        <c:if test="${userRequest != null}">
                            <c:if test="${author.id eq submitter.id}">
                                <div class="field">
                                    <a class="ui teal submit button"  href="DeleteUserRequest?userRequestId=${userRequest.id}" onclick="return del()">删除需求</a>
                                </div>
                            </c:if>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
    </form>
</div>
<div class="right-side">
    <c:if test="${userRequest.status != '需求提交不完整，缺少卫星信息'}">
        <h3>已添加的卫星参数列表</h3>
        <div class="ui divider"></div>
        <%--需求列表--%>
        <table class="ui celled table">
            <thead>
            <tr>
                <th width="10%">需求卫星</th>
                <th width="10%">成像模式</th>
                <th width="10%">拍摄开始时间</th>
                <th width="10%">拍摄结束时间</th>
                <th width="10%">拍摄次数</th>
                <th width="10%">拍摄时长，单位s</th>
                <th width="10%">是否多宫格</th>
                <th width="10%">更多操作</th>
            </tr>
            </thead>
            <c:forEach items="${userSatelliteList}" var="userSatellite">
                <tr>
                    <td>${userSatellite.requestSatellites}</td>
                    <td>${userSatellite.imagingMode}</td>
                    <td><fmt:formatDate value="${userSatellite.requestStart}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
                    <td><fmt:formatDate value="${userSatellite.requestEnd}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
                    <td>${userSatellite.shootNum}</td>
                    <td>${userSatellite.imagingDuration}</td>
                    <td>${userSatellite.multiGrid}</td>
                    <td>
                        <div class="sixteen fields">
                            <div class="field">
                                <c:if test="${userRequest.status == '已提交需求'}">
                                    <a class="ui teal submit button" href="EditUserRequestSatellite?userRequestSatelliteId=${userSatellite.id}">修改</a>
                                </c:if>
                                <a class="ui blue submit button" href="DeleteUserRequestSatellite?userRequestSatelliteId=${userSatellite.id}">删除</a>
                            </div>
                        </div>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </c:if>
</div>

</body>
