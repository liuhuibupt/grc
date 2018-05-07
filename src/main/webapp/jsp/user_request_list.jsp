<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="serverUrl" value="${pageContext.request.scheme}${'://'}${pageContext.request.serverName}${':'}${pageContext.request.serverPort}${pageContext.request.contextPath}" />
<html>
<head>
    <title>需求检索</title>
    <link rel="stylesheet" type="text/css" href="${serverUrl}/css/calendar.min.css">
    <script src="${serverUrl}/js/calendar.js"></script>

    <script>
        $(document).ready(function() {
            $('.ui.selection.dropdown').dropdown();
            $('.ui.dropdown').dropdown();
            $('.ui.menu.dropdown').dropdown();
            $('.ui.checkbox').checkbox();

            $(document).ready(function() {
                $('#searchCriteria').popup({
                    hoverable: true,
                    delay: {
                        show: 100,
                        hide: 100
                    }
                });
            });

            $('#dateStartDiv').calendar({
                type: 'date'
            });

            $('#dateEndDiv').calendar({
                type: 'date'
            });

            $('div[name="moredetail"]').popup({
                hoverable: true,
                delay: {
                    show: 100,
                    hide: 100
                }
            });

            $('div[name="moredetail2"]').popup({
                hoverable: true,
                delay: {
                    show: 100,
                    hide: 100
                }
            });

            var criList = ['requestSatellite', 'imagingMode', 'requestName', 'keyword', 'dateStart', 'dateEnd', 'onlyme'];
            for (var i in criList){
                initCri(criList[i]);
            }
        });

        function initCri(criName) {

            if (criName == 'dateStart' || criName == 'dateEnd') {
                $('#' + criName).blur(function () {
                    addCri(criName)
                });
            } else if (criName == 'requestSatellite' || criName == 'imagingMode') {
                $('#' + criName + 'CriList > div > a').each(function() {
                    $(this).click(function() {
                        var value = $(this).attr("data-value");
                        $('#' + criName).val(value);
                        addCri(criName);
                    });
                });

            } else {
                $('#' + criName).keyup(function() {
                    addCri(criName)
                });
            }

            $('#' + criName).ready(function() {
                var value = $('#' + criName).val();
                if (value != '') {
                    var color = getRandomColor();
                    $('#cri-' + criName).removeClass();
                    $('#cri-' + criName).addClass('ui label ' + color);
                    $('#cri-' + criName).show();
                    $('#cri-' + criName + '-value').text(value);
                }
            });
            $('#cri-' + criName + ' > .delete').click(function() {
                $('#cri-' + criName).hide();
                $('#' + criName).val('');
            });
        }

        function addCri(criName) {
            var value = $('#' + criName).val();
            if (value != '') {
                var color = getRandomColor();
                $('#cri-' + criName).removeClass();
                $('#cri-' + criName).addClass('ui label ' + color);
                $('#cri-' + criName).show();
                $('#cri-' + criName + '-value').text(value);
            } else {
                clearCri(criName);
            }
        }

        function clearCri(criName) {
            $('#cri-'+ criName).hide();
            $('#' + criName).val('');
        }

        function requestResult(pageNum) {
            var locationHref = "userRequest-list?&curPageNum=" + pageNum;
            var dateStart = $("#dateStart").val();
            if ('' != dateStart) {
                locationHref += "&dateStart=" + dateStart + " 00:00:01";
            }
            var dateEnd = $("#dateEnd").val();
            if ('' != dateEnd) {
                locationHref += "&dateEnd=" + dateEnd + " 23:59:59";
            }

            var requestSatellite = $("#requestSatellite").val();
            if ('' != requestSatellite) {
                locationHref += "&requestSatellite=" + requestSatellite;
            }

            var imagingMode = $("#imagingMode").val();
            if ('' != imagingMode) {
                locationHref += "&imagingMode=" + imagingMode;
            }

            var requestName = $("#requestName").val();
            if ('' != requestName) {
                locationHref += "&requestName=" + requestName;
            }

            var keyword = $("#keyword").val();
            if ('' != keyword) {
                locationHref += "&keyword=" + keyword;
            }

            var onlyme = $("#onlyme").val();
            if  ('' != onlyme) {
                locationHref += '&onlyme=true';
            }

            var orderby = $("#orderby").val();
            if  ('' != orderby) {
                locationHref += '&orderby=' + orderby;
            }

            window.location.href = locationHref;
        }

        function clearAllCri() {
            var dateStart = $("#dateStart").val('');
            var dateEnd = $("#dateEnd").val('');
            var requestSatellite = $("#requestSatellite").val('');
            var imagingMode = $("#imagingMode").val('');
            var requestName = $("#requestName").val('');
            var keyword = $("#keyword").val('');
            var onlyme = $("#onlyme").val('');
        }

        function setSatelliteCri(satelliteId) {
            $('#requestSatellite').val(satelliteId);
            var value = $('#requestSatellite').val();
        }

        function searchToday() {
            clearAllCri();
            var today = getDate(0);
            $("#dateStart").val(today);
            $("#dateEnd").val(today);
            $("#onlyme").val('');
            requestResult(0);
        }

        function searchMyToday() {
            clearAllCri();
            var today = getDate(0);
            $("#dateStart").val(today);
            $("#dateEnd").val(today);

            $("#onlyme").val('TRUE');
            requestResult(0);
        }

        function searchMyAll() {
            clearAllCri();
            $("#dateStart").val('');
            $("#dateEnd").val('');
            $("#onlyme").val('TRUE');
            requestResult(0);
        }

        function searchYesterday() {
            clearAllCri();
            var today = getDate(-1);
            $("#dateStart").val(today);
            $("#dateEnd").val(today);
            $("#onlyme").val('');
            requestResult(0);
        }

        function setOrderby(orderby) {
            $("#orderby").val(orderby);
            requestResult(0);
        }
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
<h2 class="ui header">需求检索</h2>
<div class="ui divider"></div>
<div class="ui tiny grid segment">
    <div class="twelve wide column" id="searchCriteria">
        <a class="ui large right pointing label" ><i class="grid layout icon"></i>按条件选择</a>
        <a class="ui label" id="cri-requestSatellite" style="display: none">Satellite<div class="detail" id="cri-requestSatellite-value"></div> <i class="delete icon" ></i></a>
        <a class="ui label" id="cri-imagingMode" style="display: none">Imaging Mode<div class="detail" id="cri-imagingMode-value"></div> <i class="delete icon" ></i></a>
        <a class="ui label" id="cri-requestName" style="display: none">Request Name<div class="detail" id="cri-requestName-value"></div><i class="delete icon"></i></a>
        <a class="ui label" id="cri-dateStart" style="display: none">Date from<div class="detail" id="cri-dateStart-value"></div><i class="delete icon"></i></a>
        <a class="ui label" id="cri-dateEnd" style="display: none">Date to<div class="detail" id="cri-dateEnd-value"></div><i class="delete icon"></i></a>
        <a class="ui label" id="cri-onlyme" style="display: none">Only Me<div class="detail" id="cri-onlyme-value"></div><i class="delete icon"></i></a>
    </div>
    <div class="ui fluid popup top left transition hidden">
        <div class="ui mini form">
            <input type="hidden" id="onlyme" <c:if test="${cri.onlyme == true}">value="true"</c:if>>
            <input type="hidden" id="orderby" <c:if test="${cri.orderby == true}">value="true"</c:if>>
            <div class="sixteen fields">
                <div class="field"> <label class="ui ribbon label">快速检索</label></div>
                <div class="field"> <a class="ui green label" href="javascript:searchToday()">今日全部需求</a></div>
                <div class="field"> <a class="ui green label" href="javascript:searchMyToday()">今日我的需求</a></div>
                <div class="field"> <a class="ui blue label" href="javascript:searchMyAll()">我的全部需求</a></div>
                <div class="field"> <a class="ui yellow label" href="javascript:searchYesterday()">昨日需求</a></div>
            </div>
            <div class="ui divider"></div>
            <div class="sixteen fields" id="requestSatelliteCriList">
                <input type="hidden" id="requestSatellite" value="${cri.requestSatellite}" >
                <div class="field"> <label class="ui ribbon label">选择卫星</label></div>
                <div class="field"> <a class="ui tag label" data-value="JL101A">光学A星</a></div>
                <div class="field"> <a class="ui tag label" data-value="JL101B">视频01星</a></div>
                <div class="field"> <a class="ui tag label" data-value="JL102B">视频02星</a></div>
                <div class="field"> <a class="ui tag label" data-value="JL103B">视频03星</a></div>
                <div class="field"> <a class="ui tag label" data-value="JL104B">视频04星</a></div>
                <div class="field"> <a class="ui tag label" data-value="JL105B">视频05星</a></div>
                <div class="field"> <a class="ui tag label" data-value="JL106B">视频06星</a></div>
                <div class="field"> <a class="ui tag label" data-value="JL107B">视频07星</a></div>
                <div class="field"> <a class="ui tag label" data-value="JL108B">视频08星</a></div>
            </div>
            <div class="ui flowing popup top left transition hidden">
                <div class="field"><label class="ui ribbon label">Keyword</label></div>
                <div class="six wide field"><input type="text" id="keyword" placeholder="Keyword" value="${cri.keyword}"></div>
            </div>
            <div class="ui divider"></div>
            <div class="sixteen fields" id="imagingModeCriList">
                <input type="hidden" id="imagingMode" value="${cri.imagingMode}" >
                <div class="field"> <label class="ui ribbon label">成像模式</label></div>
                <div class="field"> <a class="ui tag label" data-value="推扫成像">推扫成像</a></div>
                <div class="field"> <a class="ui tag label" data-value="凝视成像">凝视成像</a></div>
                <div class="field"> <a class="ui tag label" data-value="夜光凝视成像">夜光凝视成像</a></div>
            </div>
            <div class="ui divider"></div>
            <div class="sixteen fields">
                <div class="field"> <label class="ui ribbon label">需求名称</label></div>
                <div class="six wide field">  <input type="text" id="requestName" placeholder="Request Name" value="${cri.requestName}"></div>
            </div>
            <div class="ui divider"></div>
            <div class="sixteen fields">
                <div class="field"><label class="ui ribbon label">提交日期</label></div>
                <div class="field">
                    <div class="ui calendar">
                        <div class="ui input left icon" id="dateStartDiv">
                            <i class="calendar icon"></i>
                            <input type="text" id="dateStart" name="dateStart" placeholder="From" value="${cri.dateStart}">
                        </div>
                    </div>
                </div>
                <div class="field">
                    <div class="ui calendar">
                        <div class="ui input left icon" id="dateEndDiv">
                            <i class="calendar icon"></i>
                            <input type="text" id="dateEnd" placeholder="To" value="${cri.dateEnd}">
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="two wide right floated column">
        <a class="ui right floated teal labeled icon button" href="javascript:requestResult(0)"> <i class="search icon"></i>Search</a>
    </div>
</div>
<div class="ui pagination menu">
    <a class="icon item"  href="javascript:requestResult(${cri.curPageNum - 1})">
        <i class="left chevron icon"></i>
    </a>
    <c:if test="${cri.curPageNum == 0}">
        <span class="item active blue">1</span>
    </c:if>
    <c:if test="${cri.curPageNum != 0}">
        <a class="item" href="javascript:requestResult(0)">1</a>
    </c:if>
    <c:if test="${cri.curPageNum > 5}">
        <span class="item">...</span>
    </c:if>
    <c:if test="${cri.totalPageNum > 1}">
        <c:forEach begin="${(cri.curPageNum - 4)  < 1 ? 1 : cri.curPageNum - 4}" end="${cri.curPageNum < cri.totalPageNum - 5 ? cri.curPageNum + 4 : cri.totalPageNum - 2}" var="i">
            <c:if test="${cri.curPageNum == i}">
                <span class="item active blue">${i + 1}</span>
            </c:if>
            <c:if test="${cri.curPageNum != i}">
                <a class="item" href="javascript:requestResult(${i})">${i + 1}</a>
            </c:if>
        </c:forEach>
    </c:if>
    <c:if test="${cri.curPageNum < cri.totalPageNum - 6}">
        <span class="item">...</span>
    </c:if>
    <c:if test="${cri.totalPageNum > 1}">
        <c:if test="${cri.curPageNum + 1 == cri.totalPageNum}">
            <span class="item active blue">${cri.totalPageNum}</span>
        </c:if>
        <c:if test="${cri.curPageNum + 1 != cri.totalPageNum}">
            <a class="item" href="javascript:requestResult(${cri.totalPageNum - 1})">${cri.totalPageNum}</a>
        </c:if>
    </c:if>
    <a class="icon item"  href="javascript:requestResult(${cri.curPageNum + 1})">
        <i class="right chevron icon"></i>
    </a>
</div>
<table class="ui celled striped table">
    <thead>
    <tr>
        <th colspan="8">
            <div class="ui grid">
                <div class="six column row">
                    <div class="left floated column">
                        <div class="ui label">
                            <i class="list icon"></i>
                            共检索${cri.resultCount}条记录
                        </div>
                    </div>
                    <div class="right floated column">
                        <div class="right aligned">
                            <c:if test="${cri.orderby eq 'submitTimeAsc'}">
                                <a class="ui right floated mini teal label" href="javascript:setOrderby('submitTimeDesc')">
                                    <i class="arrow up icon"></i>
                                    时间升序
                                </a></c:if>
                            <c:if test="${cri.orderby ne 'submitTimeAsc'}">
                                <a class="ui right floated mini teal label" href="javascript:setOrderby('submitTimeAsc')">
                                    <i class="arrow down icon"></i>
                                    时间降序
                                </a></c:if>
                        </div>
                    </div>
                </div>
            </div>
        </th>
    </tr>
    <tr>
        <th width="10%" style="text-align:center">序号</th>
        <th width="10%" style="text-align:center">需求名称</th>
        <th width="10%" style="text-align:center">优先级</th>
        <th width="10%" style="text-align:center">需求状态</th>
        <th width="10%" style="text-align:center">提交日期</th>
        <th width="10%" style="text-align:center">需求状态</th>
        <th width="10%" style="text-align:center">更多细节</th>
        <th width="20%" style="text-align:center">更多操作</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach items="${resultSet}" var="userRequest">
    <tr>
        <td style="text-align:center">
            <c:if test="${userRequest.label eq 'today'}"><div class="ui teal ribbon label">Today</div></c:if>
                ${userRequest.num}
        </td>
        <td style="text-align:center">${userRequest.requestName}</td>
        <td style="text-align:center">${userRequest.priority}</td>
        <td style="text-align:center">${userRequest.status}</td>
        <td style="text-align:center"><fmt:formatDate value="${userRequest.submitTime}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
        <td style="text-align:center">待交接</td>

        <td style="text-align:center">
            <div class="ui label" name="moredetail"><i class="list icon"></i>More</div>
            <div class="ui flowing popup top left transition hidden" style="text-align:left">
                 <div class="ui divided selection list">
                    <div class="item">
                        <div class="ui teal horizontal icon label">
                            <i class="in cart icon"></i>需求编号</div>
                            ${userRequest.requestId}
                    </div>
                    <div class="item">
                        <div class="ui teal horizontal icon label">
                            <i class="in cart icon"></i>需求来源</div>
                            ${userRequest.requestFrom}
                    </div>
                    <div class="item">
                        <div class="ui teal horizontal icon label">
                            <i class="user icon"></i>&nbsp;实际需求人</div>
                            ${userRequest.requestUser}
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
                            <i class="camera retro icon"></i>分辨率要求</div>
                            ${userRequest.resolution}
                    </div>
                    <div class="item">
                        <div class="ui teal horizontal icon label">
                            <i class="camera retro icon"></i>成像坐标</div>
                            ${userRequest.imagingPara}
                    </div>
                </div>
            </div>
        </td>
        <td style="text-align:center">
            <a class="ui  button"  href="user_request_detail?requestNum=${userRequest.id}">更多细节</a>
            <a class="ui   button"  href="userRequest?userRequestId=${userRequest.id}">修改需求</a>
            <a class="ui button"  href="cancelRequestInList?userRequestId=${userRequest.id}">取消需求</a>
        </td>
    </tr>
    </c:forEach>
    <tfoot>
    <tr>
        <th colspan="8">
            <div class="ui left floated pagination menu">
                <a class="icon item"  href="javascript:requestResult(${cri.curPageNum - 1})">
                    <i class="left chevron icon"></i>
                </a>
                <c:if test="${cri.curPageNum == 0}">
                    <span class="item active blue">1</span>
                </c:if>
                <c:if test="${cri.curPageNum != 0}">
                    <a class="item" href="javascript:requestResult(0)">1</a>
                </c:if>
                <c:if test="${cri.curPageNum > 5}">
                    <span class="item">...</span>
                </c:if>
                <c:if test="${cri.totalPageNum > 1}">
                    <c:forEach begin="${(cri.curPageNum - 4)  < 1 ? 1 : cri.curPageNum - 4}" end="${cri.curPageNum < cri.totalPageNum - 5 ? cri.curPageNum + 4 : cri.totalPageNum - 2}" var="i">
                        <c:if test="${cri.curPageNum == i}">
                            <span class="item active blue">${i + 1}</span>
                        </c:if>
                        <c:if test="${cri.curPageNum != i}">
                            <a class="item" href="javascript:requestResult(${i})">${i + 1}</a>
                        </c:if>
                    </c:forEach>
                </c:if>
                <c:if test="${cri.curPageNum < cri.totalPageNum - 6}">
                    <span class="item">...</span>
                </c:if>
                <c:if test="${cri.totalPageNum > 1}">
                    <c:if test="${cri.curPageNum + 1 == cri.totalPageNum}">
                        <span class="item active blue">${cri.totalPageNum}</span>
                    </c:if>
                    <c:if test="${cri.curPageNum + 1 != cri.totalPageNum}">
                        <a class="item" href="javascript:requestResult(${cri.totalPageNum - 1})">${cri.totalPageNum}</a>
                    </c:if>
                </c:if>
                <a class="icon item"  href="javascript:requestResult(${cri.curPageNum + 1})">
                    <i class="right chevron icon"></i>
                </a>
            </div>
        </th>
    </tr>
    </tfoot>
    </tbody>
</table>
</body>
</html>

