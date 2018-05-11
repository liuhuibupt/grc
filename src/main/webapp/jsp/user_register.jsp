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
        }

        body > .grid {
            height: 100%;
        }

        .image {
            margin-top: -100px;
        }

        .column {
            max-width: 850px;
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
            $('.ui.selection.dropdown').dropdown();

            $('.input').popup({
                on: 'focus'
            });

            $('.ui.form')
                .form({
                    fields: {
                        userName: {
                            identifier: 'userName',
                            rules: [
                                {
                                    type: 'empty',
                                    prompt: 'Please enter your [User Name]'
                                }
                            ]
                        },
                        displayName: {
                            identifier: 'displayName',
                            rules: [
                                {
                                    type: 'empty',
                                    prompt: 'Please enter your [Display Name]'
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
                        },
                        confirmPassword: {
                            identifier: 'confirmPassword',
                            rules: [
                                {
                                    type: 'match[password]',
                                    prompt: 'Confirm is different from [password], please check again'
                                }
                            ]
                        },
                        departmentName: {
                            identifier: 'departmentName',
                            rules: [
                                {
                                    type: 'empty',
                                    prompt: 'Please select your [Department Name]'
                                }
                            ]
                        },
                        cellNum: {
                            identifier: 'cellNum',
                            rules: [
                                {
                                    type: 'empty',
                                    prompt: 'Please enter your [Cell Number]'
                                }
                            ]
                        },
                    }
                })
            ;
        });
    </script>
</head>
<body>
<div class="ui middle aligned center aligned grid">
    <div class="column">
        <h2 class="ui teal image header">
            <img src="images/logo_35BDB2.png" class="image">
            <div class="content app_name">
                长光卫星 - 用户需求中心
            </div>
        </h2>
        <div class="ui attached left aligned message">
            <div class="header">欢迎来到数据中心用户需求中心！</div>
            <p>填写下面的表单来注册新的账户</p>
        </div>
        <form class="ui large form" action="registerUser" method="post">
            <div class="ui left aligned stacked segment">
                <div class="ui error message">
                </div>
                <c:if test="${'true' eq param.error}">
                    <div class="ui message submit_error ">
                        <ul class="list">
                            <li> Invalid username or password</li>
                        </ul>
                    </div>
                </c:if>
                <c:if test="${success == true}">
                    <div class="ui mini blue message">
                        <div class="header">注册成功，请联系数据中心管理员激活账号。</div>
                    </div>
                </c:if>
                <c:if test="${success == false}">
                    <div class="ui mini red message">
                        <div class="header">${errorMessage}</div>
                    </div>
                </c:if>
                <div class="field" data-tooltip="[User Name]应该是您的中文名字的拼音全拼字母，中间无空格并且全小写，[User Name]也将是您的登录名称。" data-inverted="" data-position="top left">
                    <label>User Name</label>
                    <input type="text" id="userName" name="userName" placeholder="User Name" value="${user.userName}">
                </div>
                <div class="field" data-tooltip="[Display Name]应该是您的中文姓名。" data-inverted="" data-position="top left">
                    <label>Display Name</label>
                    <input type="text" id="displayName" name="displayName" placeholder="Display Name" value="${user.displayName}">
                </div>
                <div class="field" data-tooltip="[Password]是您登录系统的密码，请尽量不要使用太简单的密码并且不要让他人知道您的密码，我们对您的每次操作都会有相应的记录，防止他人提您操作。" data-inverted="" data-position="top left">
                    <label>Password</label>
                    <input type="password" id="password" name="password" placeholder="Password" value="${user.password}">
                </div>
                <div class="field" data-tooltip="请确认密码。" data-inverted="" data-position="top left">
                    <label>Password Confirm</label>
                    <input type="password" id="passwordConfirm" placeholder="Password Confirm" value="${user.password}">
                </div>
                <div class="field" data-tooltip="请选择您所在的部门，之后将不能修改。" data-inverted="" data-position="top left">
                    <label>Department Name</label>
                    <div class="ui fluid dropdown selection" tabindex="0" id="departmentNameDiv">
                        <select id="departmentName" name="departmentName">
                            <option value=""></option>
                            <option value="市场部" <c:if test="${user.departmentName == '市场部'}">selected</c:if>>ROLE_DEV</option>
                            <option value="数据中心一室" <c:if test="${user.departmentName == '数据中心一室'}">selected</c:if>>数据中心一室</option>
                            <option value="数据中心二室" <c:if test="${user.departmentName == '数据中心二室'}">selected</c:if>>数据中心二室</option>
                            <option value="数据中心三室" <c:if test="${user.departmentName == '数据中心三室'}">selected</c:if>>数据中心三室</option>
                            <option value="遥感大数据室" <c:if test="${user.departmentName == '遥感大数据室'}">selected</c:if>>遥感大数据室</option>
                        </select><i class="dropdown icon"></i>
                        <div class="default text">Department Name</div>
                        <div class="menu transition hidden" tabindex="-1">
                            <div class="item" data-value="市场部">市场部</div>
                            <div class="item" data-value="数据中心一室">数据中心一室</div>
                            <div class="item" data-value="数据中心二室">数据中心二室</div>
                            <div class="item" data-value="数据中心三室">数据中心三室</div>
                            <div class="item" data-value="遥感大数据室">遥感大数据室</div>
                        </div>
                    </div>
                </div>
                <div class="field" data-tooltip="您的默认用户权限是[ROLE_USER]，如果需要提升权限，请联系管理员。" data-inverted="" data-position="top left">
                    <div class="disabled field" >
                        <label>User Role</label>
                        <div class="ui fluid dropdown selection" tabindex="0"  id="roleDiv">
                            <select id="role" name="role">
                                <option value=""></option>
                                <option value="ROLE_USER"selected>ROLE_USER</option>
                                <option value="ROLE_DEV">ROLE_DEV</option>
                                <option value="ROLE_ADMIN">ROLE_ADMIN</option>
                            </select><i class="dropdown icon"></i>
                            <div class="default text">User Role</div>
                            <div class="menu transition hidden" tabindex="-1">
                                <div class="item" data-value="ROLE_USER">ROLE_USER</div>
                                <div class="item" data-value="ROLE_DEV">ROLE_DEV</div>
                                <div class="item" data-value="ROLE_ADMIN">ROLE_ADMIN</div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="field" data-tooltip="请填写您的手机号码。" data-inverted="" data-position="top left">
                    <label>Cell Number</label>
                    <input type="text" id="cellNum" name="cellNum" placeholder="Cell Number" value="${user.cellNum}">
                </div>
                <div class="three fields" style="margin-top: 2.5rem">
                    <div class="field">
                    </div>
                    <div class="field">
                        <input type="submit" class="ui fluid large teal submit button" value="Register"/>
                    </div>
                </div>
            </div>
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
        </form>
        <div class="ui message">
            <a href="gr_login">返回登录</a>
        </div>
    </div>

</div>

</body>

</html>
