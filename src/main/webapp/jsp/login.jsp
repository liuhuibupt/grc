<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <!-- Standard Meta -->
    <meta charset="utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0">

    <!-- Site Properties -->
    <title>Login - Ground Resources</title>

    <link rel="icon" href="./images/favicon.ico" mce_href="./images/favicon.ico" type="image/x-icon">
    <link rel="stylesheet" type="text/css" href="css/semantic.css">

    <script src="js/jquery-3.2.1.min.js"></script>
    <script src="js/semantic.js"></script>

    <style type="text/css">
        body {
            background-color: #DADADA;
            background-image: url("./images/backgroundLoginPage.jpg");
            z-index:-1;
            position:absolute;
            width:100%;
            height:100%;
        }

        body > .grid {
            height: 100%;
        }

        .image {
            margin-top: -100px;
        }

        .column {
            max-width: 450px;
        }

        .app_name {
            font-family: "Microsoft YaHei";
        }

        .ui.message.submit_error {
            background-color: #FFF6F6;
            color: #9F3A38;
            position: relative;
            min-height: 1em;
            margin: 1em 0em;
            padding: 1em 1.5em;
            line-height: 1.4285em;
        }

        .ui.message.submit_error .list:not(.ui) {
            text-align: left;
            padding: 0em;
            opacity: 0.85;
            list-style-position: inside;
            margin: 0.5em 0em 0em;
        }

        .ui.message.submit_error .list:not(.ui) li {
            display: list-item;
            text-align: -webkit-match-parent;
            position: relative;
            list-style-type: none;
            margin: 0em 0em 0.3em 1em;
            padding: 0em;
        }
    </style>
    <script>
        $(document).ready(function () {
            $('.ui.form').form({
                    fields: {
                        username: {
                            identifier: 'username',
                            rules: [
                                {
                                    type: 'empty',
                                    prompt: 'Please enter your username'
                                }
                            ]
                        },
                        password: {
                            identifier: 'password',
                            rules: [
                                {
                                    type: 'empty',
                                    prompt: 'Please enter your password'
                                },
                                {
                                    type: 'length[6]',
                                    prompt: 'Your password must be at least 6 characters'
                                }
                            ]
                        }
                    }
                });

            $('#username').focus();
        });
    </script>
</head>
<body>
<div class="ui middle aligned center aligned grid">
    <div class="column">
        <h2 class="ui teal image header">
            <img src="images/logo_35BDB2.png" class="image">
            <div class="content app_name">
                长光卫星 - 用户需求管理中心
            </div>
        </h2>
        <form class="ui large form" action="login" method="post">
            <div class="ui stacked segment">
                <div class="field">
                    <div class="ui left icon input">
                        <i class="user icon"></i>
                        <input type="text" id="username" name="username" placeholder="Username">
                    </div>
                </div>
                <div class="field">
                    <div class="ui left icon input">
                        <i class="lock icon"></i>
                        <input type="password" name="password" placeholder="Password">
                    </div>
                </div>
                <input type="submit" class="ui fluid large teal submit button" value="Login"/>
            </div>
            <div class="ui error message">
            </div>
            <c:if test="${'true' eq param.error}">
                <div class="ui message submit_error ">
                    <ul class="list">
                        <li> ${SPRING_SECURITY_LAST_EXCEPTION.message}</li>
                    </ul>
                </div>
            </c:if>
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
        </form>

        <div class="ui message">
            没有账户? <a href="goRegister">注册新用户</a>
        </div>
    </div>
</div>
</body>
</html>
