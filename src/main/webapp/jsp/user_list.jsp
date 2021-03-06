<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri='http://www.springframework.org/security/tags' prefix='sec' %>
<html>
<head>
    <title>用户列表</title>
</head>
<body>
<h2 class="ui header">用户列表</h2>
<div class="ui divider"></div>
<sec:authorize access="hasRole('ROLE_ADMIN')">
<div class="field">
    <div class="two fields">
        <div class="field">
            <a class="ui teal submit button" href="newUser" >添加新用户</a>
        </div>
    </div>
</div>
</sec:authorize>
<table class="ui celled table">
    <thead>
    <tr>
        <th width="5%">ID</th>
        <th width="10%">User Name</th>
        <th>Display Name</th>
        <th width="10%">User Role</th>
        <th width="10%">Department Name</th>
        <th width="15%">Last Request Time</th>
        <th width="10%">Enable</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach items="${userList}" var="user">
        <tr>
            <td>${user.id}</td>
            <td><a href="user?userId=${user.id}">${user.username}</a></td>
            <td>${user.displayName}</td>
            <td>${user.role}</td>
            <td>${user.departmentName}</td>
            <td><fmt:formatDate value="${user.lastRequestTime}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
            <td>${user.enable}</td>
        </tr>
    </c:forEach>
    </tbody>
</table>
</body>
</html>
