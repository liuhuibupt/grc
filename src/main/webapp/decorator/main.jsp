<%@ page language="java" pageEncoding="UTF-8" %>
<%@ taglib uri='http://www.springframework.org/security/tags' prefix='sec' %>
<c:set var="serverUrl" value="${pageContext.request.scheme}${'://'}${pageContext.request.serverName}${':'}${pageContext.request.serverPort}${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
    <!-- Standard Meta -->
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0">

    <!-- Site Properties -->
    <title><sitemesh:write property='title'/></title>

    <link rel="icon" href="./images/favicon.ico" mce_href="./images/favicon.ico" type="image/x-icon">
    <link rel="stylesheet" type="text/css" href="./css/semantic.css">
    <link rel="stylesheet" type="text/css" href="./css/app.css">

    <script src="./js/jquery-3.2.1.min.js" ></script>
    <script src="./js/semantic.js" ></script>
    <script src="./js/grc.js" ></script>

    <style type="text/css">
        body {
            background-color: #FFFFFF;
        }
        .ui.menu .item img.logo {
            margin-right: 1.5em;
            height: auto;
            width: auto;
        }
        .main.container {
            margin-top: 5em;
        }
        .wireframe {
            margin-top: 2em;
        }
        .ui.footer.segment {
            margin: 5em 0em 0em;
            padding: 5em 0em;
        }

        .app_left_menu {
            width: 5rem;
            display: inline;
        }

        .app_content{
            /*width: calc(100% - 10rem);*/
            width: calc(100%);
        }

        .ui.vertical.menu {
            width: 19rem;
            margin-left: 1.0rem;
            margin-right: 1.0rem;
        }
    </style>
    <sitemesh:write property='head'/>
</head>
<body>
<div class="ui fixed inverted menu">
    <div class="ui container">
        <a href="#" class="item">
            <img class="logo" src="./images/CG_logo_teal.png">
            <!--长光卫星 - 地面资源中心的图片，，日后要更换！！！！！！-->
        </a>
        <a class="item" href="userRequest-list">用户需求</a>
        <a class="item" href="userRequest-add">新建需求</a>
        <%--<a class="item" href="test">测试123</a>--%>
        <%--暂停开发--%>
        <%--<div class="menu">--%>
            <%--<div class="ui simple dropdown item">未完成--%>
                <%--<i class="dropdown icon"></i>--%>
                <%--<div class="menu">--%>
                <%--<a class="item" href=""/>规划列表</a>--%>
                <%--<a class="item" href=""/>光学A星</a>--%>
                <%--<a class="item" href="">视频03星</a>--%>
                <%--<a class="item" href="">视频04星</a>--%>
                <%--<a class="item" href="">视频05星</a>--%>
                <%--<a class="item" href="">视频06星</a>--%>
                <%--<a class="item" href="">视频07星</a>--%>
                <%--<a class="item" href="">视频08星</a>--%>
                 <%--</div>--%>
            <%--</div>--%>
        <%--</div>--%>
        <%--<div class="menu">--%>
            <%--<div class="ui simple dropdown item">未完成--%>
                <%--<i class="dropdown icon "></i>--%>
                <%--<div class="menu">--%>
                    <%--<a class="item" href=""/>产品交付</a>--%>
                <%--</div>--%>
            <%--</div>--%>
        <%--</div>--%>

        <%--<a class="item" href="test">test</a>--%>
        <%--<a class="item" href="test2">test2</a>--%>
        <%--暂停开发--%>
        <div class="right menu">
            <div class="ui simple dropdown item">
                <i class="user icon"></i>您好，<sec:authentication property="principal.displayName"/>
                <i class="dropdown icon"></i>
                <div class="menu">
                    <a class="item" href="user?userId=<sec:authentication property="principal.id"/>">账号信息</a>
                    <a class="item" href="grc_logout">Logout</a>
                </div>
            </div>
            <sec:authorize access="hasRole('ROLE_ADMIN')">
            <a class="item" href="user-list">用户列表</a>
            <a class="item" href="userAction-list">用户操作</a> </sec:authorize>
        </div>
    </div>
</div>
<div class="ui main container" style="min-height: 100px">
    <div class="ui grid">
        <%--<div class="app_left_menu">--%>
        <%--</div>--%>
        <div class="app_content">
            <sitemesh:write property='body'/>
        </div>
    </div>
</div>

</body>
</html>
