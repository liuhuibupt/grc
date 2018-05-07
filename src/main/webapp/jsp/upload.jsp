<%--
  Created by IntelliJ IDEA.
  User: victory
  Date: 2018/4/24
  Time: 8:55
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>上传</title>
</head>
<body>
<div style="margin: 100px auto 0;">
    <form action="/oneUpload" method="post" enctype="multipart/form-data"><%--定义enctype来用于文件上传--%>
        <p>
            <span>文件</span>
            <input type="file" name="imageFile">
            <input type="submit">
        </p>
    </form>
</div>

</body>
</html>
