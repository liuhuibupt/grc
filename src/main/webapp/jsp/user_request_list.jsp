<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<html>
<head>
    <title>用户需求</title>
    <script>
        $(document)
            .ready(function() {
                $('.ui.selection.dropdown').dropdown();
                $('.ui.menu .ui.dropdown').dropdown({
                    on: 'hover'
                });
            })
        ;
    </script>
</head>
<body>
<h2 class="ui header">用户需求</h2>
<div class="ui divider"></div>
<div class="ui styled fluid accordion">
    <div class="title active"><i class="search icon"></i> Search Criteria </div>
    <div class="content active">
        <div class="ui mini form">
            <div class="two fields">
                <div class="field">
                    <label>需求名称</label>
                    <input placeholder="Request Name" type="text">
                </div>
                <div class="field">
                    <label>需求用户</label>
                    <input placeholder="Request User" type="text">
                </div>
            </div>
            <div class="ui submit button">Search</div>
        </div>
    </div>
</div>
<div class="ui mini blue message">共检索1024条记录</div>
<table class="ui celled table">
    <thead>
    <tr>
        <th width="10%">No.</th>
        <th width="10%">需求代码</th>
        <th>需求名称</th>
        <th width="10%">提交者</th>
        <th width="10%">提交时间</th>
        <th width="10%">状态</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach items="${resultSet}" var="userRequest">
        <tr>
            <td>01</td>
            <td><a href="userRequest?userRequestId=${userRequest.id}">${userRequest.requestCode}</a></td>
            <td>${userRequest.requestName}</td>
            <td>${userRequest.submitter.displayName}</td>
            <td>${userRequest.submitTime}</td>
            <td>Status</td>
        </tr>
    </c:forEach>
    <tfoot>
    <tr>
        <th colspan="6">
            <div class="ui left floated pagination menu">
                <a class="icon item">
                    <i class="left chevron icon"></i>
                </a>
                <a class="item">1</a>
                <a class="item">2</a>
                <a class="item">3</a>
                <a class="item">4</a>
                <a class="icon item">
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

