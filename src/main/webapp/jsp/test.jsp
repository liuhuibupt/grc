<%--CREATED BY LIUHUI ON 2018/3/20--%>
<%--EDITED BY PANSHENGNAN--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri='http://www.springframework.org/security/tags' prefix='sec' %>

<c:set var="serverUrl" value="${pageContext.request.scheme}${'://'}${pageContext.request.serverName}${':'}${pageContext.request.serverPort}${pageContext.request.contextPath}" />
<html>
<head>
    <title>录入客户需求</title>
    <link rel="stylesheet" type="text/css" href="${serverUrl}/css/calendar.min.css">
    <script src="${serverUrl}/Cesium/Cesium.js"></script>
    <script src="${serverUrl}/Cesium/DrawTool.js"></script>
    <script src="${serverUrl}/Cesium/DrawHelper.js"></script>
    <script src="${serverUrl}/js/calendar.js"></script>
    <script>
        $(document).ready(function () {
            var arcgisImageProvider = new Cesium.ArcGisMapServerImageryProvider({
                // url: "http://10.10.20.234:6080/arcgis/rest/services/World14/MapServer"
                url:" http://services.arcgisonline.com/ArcGIS/rest/services/World_Street_Map/MapServer"
            });
            var arcgisImageViewMode = new Cesium.ProviderViewModel({
                name: 'Argis',
                iconUrl: Cesium.buildModuleUrl('Widgets/Images/ImageryProviders/bingAerial.png'),
                tooltip: 'Argis',
                creationFunction: function () {
                    return arcgisImageProvider;
                }
            });
            var imageryViewModels = new Array();
            imageryViewModels.push(arcgisImageViewMode);
            var viewer = new Cesium.Viewer('cesiumContainer', {
                animation: false, //是否创建动画小器件，左下角仪表
                baseLayerPicker: true, //是否显示图层选择器
                imageryProviderViewModels: imageryViewModels,
                //imageryProvider:googleImageProvider,
                // terrainProvider:terrainProvider,
                fullscreenButton: false, //是否显示全屏按钮
                geocoder: false, //是否显示geocoder小器件，右上角查询按钮
                homeButton: false, //是否显示Home按钮
                infoBox: false, //是否显示信息框
                sceneModePicker: false, //是否显示3D/2D选择器
                selectionIndicator: false, //是否显示选取指示器组件
                timeline: false, //是否显示时间轴
                navigationHelpButton: false, //是否显示右上角的帮助按钮
                scene3DOnly: false, //如果设置为true，则所有几何图形以3D模式绘制以节约GPU资源
                navigationInstructionsInitiallyVisible: false,
                showRenderLoopErrors: false,
                shadows: true,
                sceneMode: Cesium.SceneMode.SCENE2D,
            });
            startMap(viewer, loggingPolygon, loggingMark, loggingMessage);

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
                    requestName: {
                        identifier: 'requestName',
                        rules: [
                            {
                                type: 'empty',
                                prompt: 'Please enter [Request Name]'
                            }
                        ]
                    },
                    requestType: {
                        identifier: 'requestType',
                        rules: [
                            {
                                type: 'empty',
                                prompt: 'Please select [Request Type]'
                            }
                        ]
                    },
                    sensitive: {
                        identifier: 'sensitive',
                        rules: [
                            {
                                type: 'empty',
                                prompt: 'Please select [Is Sensitive]'
                            }
                        ]
                    },
                    priority: {
                        identifier: 'priority',
                        rules: [
                            {
                                type: 'empty',
                                prompt: 'Please enter [Priority]'
                            }
                        ]
                    },
                    imagingPara: {
                        identifier: 'imagingPara',
                        rules: [
                            {
                                type: 'empty',
                                prompt: 'Please enter [Imaging Parameter]'
                            }
                        ]
                    }

                }
            });

            $('#requestType').ready(function () {
                var val = $('#requestType').val();
                if (val == 'IN-SPACE') {
                    $('#cesiumContainer').hide();
                }
            });

            $('#requestType').change(function () {
                $('#requestType_point').hide();
                $('#cesiumContainer').show();
                $('#imagingPara').val("");

                var val = $(this).val();
                if (val == 'POINT') {
                    $('#requestType_point1').show();
                    $('#requestType_point2').show();
                    drawPoint(loggingMark);
                }
                if (val == 'AREA') {
                    drawPolygon(loggingPolygon);
                }
                if (val == 'IN-SPACE') {
                    $('#cesiumContainer').hide();
                }
            });

            $('#elevation').change(function () {
                var imagingPara = $('#imagingPara').val();
                if ('' != imagingPara) {
                    updateImagingParameter();
                }
            });

            $("#longitude").on("input propertychange", setPoint);

            $("#latitude").on("input propertychange", setPoint);

            function setPoint() {
                var lon = $("#longitude").val();
                var lat = $("#latitude").val();
                if (lon != "" && lat != "") {
                    setPointPosition(lon, lat);
                    var wkt = "POINT(" + lon + " " + lat + ")";
                    $("#imagingWkt").val(wkt);
                    updateImagingParameter();
                }
            }

            $('#requestStartDiv').calendar({
                type: 'datetime'
            });

            $('#requestEndDiv').calendar({
                type: 'datetime'
            });

            setGeoJson(${imagingGeojson});
        });

        var loggingPolygon = function(positions) {
            var wkt = "POLYGON ((";
            for(var i = 0; i <= positions.length - 2;i++) {
                var position;
                if (i == positions.length - 2) {
                    position = positions[0];
                }else {
                    position = positions[i];
                }
                var cartographic = Cesium.Cartographic.fromCartesian(new Cesium.Cartesian3(position.x, position.y, position.z));
                var longitudeString = Cesium.Math.toDegrees(cartographic.longitude).toFixed(8);
                var latitudeString = Cesium.Math.toDegrees(cartographic.latitude).toFixed(8);
                wkt += longitudeString + " " + latitudeString + ",";
            }
            wkt = wkt.substring(0, wkt.length - 1) + "))";
            $("#imagingWkt").val(wkt);
            updateImagingParameter();
        }

        var loggingMark = function(lon, lat) {
            $("#longitude").val(lon);
            $("#latitude").val(lat);
            var wkt = "POINT(" + lon + " " + lat + ")";
            $("#imagingWkt").val(wkt);
            updateImagingParameter();
        };

        var loggingMessage = function(message) {
            $(".loggingMessage").html(message);
        }

        function setGeoJson(geoJson) {
            var type = geoJson.type;
            if (type == "Point") {
                var lon = geoJson.coordinates[0];
                var lat = geoJson.coordinates[1];
                $('#requestType_point').show();
                loggingMark(lon, lat);
                setPointPosition(lon, lat);
            }else if (type == "Polygon") {
                addPolygonFromGeo(geoJson.coordinates[0]);
            }
        }

        function updateImagingParameter() {
            var imagingPara = '';
            var requestType = $('#requestType').val();

            if ('POINT' == requestType || 'AREA' == requestType) {
                var imagingWkt = $('#imagingWkt').val();
                if (imagingWkt != '') {
                    imagingPara += "imagingWkt=" + imagingWkt;
                }

                var elevation = $('#elevation').val();
                if (elevation != '') {
                    if ('' != imagingPara) {
                        imagingPara += "\n";
                    }
                    imagingPara += "elevation=" + elevation;
                }
            }
            $('#imagingPara').val(imagingPara);
        }
    </script>

    <style>
        @import url(${serverUrl}/Cesium/Widgets/widgets.css);
        @import url(${serverUrl}/Cesium/DrawHelper.css);

        #cesiumContainer {
            height: 65%;
            margin: 0;
            padding: 0;
            overflow: hidden;
            position: relative;
        }
        .loggingMessage {
            z-index: 1;
            position: absolute;
            width: 250px;
            bottom: 0px;
            right: 0;
            display: inline;
            margin: 10px;
            padding: 10px;
            background: white;
        }
        .cesium-viewer-bottom {
            display: none!important;
        }
        #more-constraint-conditions{
            z-index: 1;
        }
        #open-more{
            z-index: 1;
        }
        .always-bottom {
            position:fixed; bottom:0;
        }
        .always-right {
            position:fixed;
            right:5px;
        }
    </style>

</head>
<body>
<h2>添加卫星参数</h2>
<div class="ui divider"></div>
<form class="ui form" action="submitUserRequest" method="post" style="margin-top: 0.5rem">

    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
    <input type="hidden" id="submitTime" name="submitTime" placeholder="Submit Time" value="<fmt:formatDate value="${userRequest.submitTime}" pattern="yyyy-MM-dd HH:mm:ss"/>" readonly>
    <input type="hidden" name="submitterId" value="${submitter.id}" >
    <input type="hidden" id="requestFrom" name="requestFrom" placeholder="Request From" value="${userRequest.requestFrom}">
    <input type="hidden" id="requestId" name="requestId" placeholder="Request ID" value="${userRequest.requestId}">
    <c:if test="${userRequest != null}">
        <input type="hidden" id="num" name="num" value="${userRequest.id}">
    </c:if>

    <div class="eight fields">
            <div class="field" data-tooltip="请填写需求名称，此项为必填选项">
                <label>需求名称</label>
                <input type="text" id="requestName" name="requestName" placeholder="需求名称" value="${userRequest.requestName}">
            </div>
            <div class="field" data-tooltip="请选择您的需求是否敏感，此项为必填选项">
                <label>敏感需求</label>
                <div class="ui fluid dropdown selection" tabindex="0">
                    <select id="sensitive" name="sensitive">
                        <option value=""></option>
                        <option value="false" <c:if test="${userRequest.sensitive eq false}">selected</c:if>>非敏感</option>
                        <option value="true" <c:if test="${userRequest.sensitive eq true}">selected</c:if>>敏感</option>
                    </select><i class="dropdown icon"></i>
                    <div class="default text">需求是否敏感</div>
                    <div class="menu transition hidden" tabindex="-1">
                        <div class="item" data-value="false">非敏感</div>
                        <div class="item" data-value="true">敏感</div>
                    </div>
                </div>
            </div>
            <div class="field" data-tooltip="请选择您需求的优先级">
                <label>优先级</label>
                <div class="ui fluid dropdown selection" tabindex="0">
                    <select id="priority" name="priority">
                        <option value=""></option>
                        <option value="0" <c:if test="${userRequest.priority == '0'}">selected</c:if>>0</option>
                        <option value="1" <c:if test="${userRequest.priority == '1'}">selected</c:if>>1</option>
                        <option value="2" <c:if test="${userRequest.priority == '2'}">selected</c:if>>2</option>
                        <option value="3" <c:if test="${userRequest.priority == '3'}">selected</c:if>>3</option>
                    </select><i class="dropdown icon"></i>
                    <div class="default text">优先级</div>
                    <div class="menu transition hidden" tabindex="-1">
                        <div class="item" data-value="0">0</div>
                        <div class="item" data-value="1">1</div>
                        <div class="item" data-value="2">2</div>
                        <div class="item" data-value="3">3</div>
                    </div>
                </div>
            </div>
            <div class="field" data-tooltip="请选择您需求类型">
                <label>需求类型</label>
                <div class="ui fluid dropdown selection" tabindex="0" >
                    <select id="requestType" name="requestType" >
                        <option value=""></option>
                        <option value="POINT" <c:if test="${userRequest.requestType == 'POINT'}">selected</c:if>>点目标</option>
                        <option value="AREA" <c:if test="${userRequest.requestType == 'AREA'}">selected</c:if>>大区域</option>
                        <option value="IN-SPACE" <c:if test="${userRequest.requestType == 'IN-SPACE'}">selected</c:if>>惯性空间</option>
                    </select><i class="dropdown icon"></i>
                    <div class="default text">需求类型</div>
                    <div class="menu transition hidden" tabindex="-1">
                        <div class="item" data-value="POINT">点目标</div>
                        <div class="item" data-value="AREA">大区域</div>
                        <div class="item" data-value="IN-SPACE">惯性空间</div>
                    </div>
                </div>
            </div>
            <div class="field" id="requestType_point1"style="display: none">
                <label>经度 Longitude</label>
                <input type="text" id="longitude" name="longitude" placeholder="Longitude">
            </div>
            <div class="field" id="requestType_point2"style="display: none" >
                <label>纬度 Latitude</label>
                <input type="text" id="latitude" name="latitude" placeholder="Latitude">
            </div>
            <input type="hidden" id="elevation" name="elevation" placeholder="Elevation">
            <%--更多按钮--%>

    </div>
    <div id="more-constraint-conditions" style="display: none">
        <div class="eight fields">
            <%--真正用户--%>
            <div class="field" data-tooltip="请填写此次需求的客户名，此项为可选项">
                <label>用户名</label>
                <input  type="text" id="requestUser" name="requestUser" placeholder="真正用户名" value="${userRequest.requestUser}">
            </div>
            <%--云量要求--%>
            <div class="field" data-tooltip="请选择您对云量的要求，此项为可选项">
                <label>云量要求</label>
                <div class="ui fluid dropdown selection" tabindex="0">
                    <select id="cloud" name="cloud">
                        <option value=""></option>
                        <option value="10" <c:if test="${userRequest.cloud == '10'}">selected</c:if>>10</option>
                        <option value="20" <c:if test="${userRequest.cloud == '20'}">selected</c:if>>20</option>
                    </select><i class="dropdown icon"></i>
                    <div class="default text">云量要求</div>
                    <div class="menu transition hidden" tabindex="-1">
                        <div class="item" data-value="10">10</div>
                        <div class="item" data-value="20">20</div>

                    </div>
                </div>
            </div>
            <%--覆盖要求--%>
            <div class="field" data-tooltip="请选择您对覆盖拍摄的要求，此项为可选项">
                <label>覆盖要求</label>
                <div class="ui fluid dropdown selection" tabindex="0">
                    <select id="coverage" name="coverage">
                        <option value=""></option>
                        <option value="向东覆盖" <c:if test="${userRequest.coverage == '向东覆盖'}">selected</c:if>>向东覆盖</option>
                        <option value="向西覆盖" <c:if test="${userRequest.coverage == '向西覆盖'}">selected</c:if>>向西覆盖</option>
                        <option value="向东向西覆盖" <c:if test="${userRequest.coverage == '向东向西覆盖'}">selected</c:if>>向东向西覆盖</option>
                    </select><i class="dropdown icon"></i>
                    <div class="default text">覆盖要求</div>
                    <div class="menu transition hidden" tabindex="-1">
                        <div class="item" data-value="向东覆盖">向东覆盖</div>
                        <div class="item" data-value="向西覆盖">向西覆盖</div>
                        <div class="item" data-value="向东向西覆盖">向东向西覆盖</div>
                    </div>
                </div>
            </div>
            <%--图像几何要求--%>
            <div class="field" data-tooltip="请选择您对图像的几何要求，此项为可选项">
                <label>几何要求</label>
                <div class="ui fluid dropdown selection" tabindex="0">
                    <select id="geometry_request" name="geometry_request">
                        <option value=""></option>
                        <option value="小于100" <c:if test="${userRequest.geometryRequest == '小于100'}">selected</c:if>>小于100</option>
                        <option value="小于200" <c:if test="${userRequest.geometryRequest == '小于200'}">selected</c:if>>小于200</option>

                    </select><i class="dropdown icon"></i>
                    <div class="default text">几何要求</div>
                    <div class="menu transition hidden" tabindex="-1">
                        <div class="item" data-value="小于100">小于100</div>
                        <div class="item" data-value="小于200">小于200</div>
                    </div>
                </div>
            </div>
            <%--图像辐射要求--%>
            <div class="field" data-tooltip="请选择您对图像的辐射要求，此项为可选项">
                <label>辐射要求</label>
                <div class="ui fluid dropdown selection" tabindex="0">
                    <select id="radiation_request" name="radiation_request">
                        <option value=""></option>
                        <option value="无明显辐射问题" <c:if test="${userRequest.radiationRequest == '无明显辐射问题'}">selected</c:if>>无明显辐射问题</option>
                        <option value="无辐射问题" <c:if test="${userRequest.radiationRequest == '无辐射问题'}">selected</c:if>>无辐射问题</option>
                    </select><i class="dropdown icon"></i>
                    <div class="default text">辐射要求</div>
                    <div class="menu transition hidden" tabindex="-1">
                        <div class="item" data-value="无明显辐射问题">无明显辐射问题</div>
                        <div class="item" data-value="无辐射问题">无辐射问题</div>
                    </div>
                </div>
            </div>
            <%--分辨率--%>
            <div class="field" data-tooltip="请选择您需求的分辨率，此项为可选项">
                <label>分辨率</label>
                <div class="ui fluid dropdown selection" tabindex="0">
                    <select id="resolution" name="resolution">
                        <option value=""></option>
                        <option value="1m" <c:if test="${userRequest.resolution == '1m'}">selected</c:if>>1m</option>
                        <option value="10m" <c:if test="${userRequest.resolution == '10m'}">selected</c:if>>10m</option>
                    </select>
                    <i class="dropdown icon"></i>
                    <div class="default text">分辨率</div>
                    <div class="menu transition hidden" tabindex="-1">
                        <div class="item" data-value="1m">1m</div>
                        <div class="item" data-value="10m">10m</div>

                    </div>
                </div>
            </div>
            <%--侧摆角--%>
            <div class="field" data-tooltip="请选择您对侧摆角的要求，此项为可选项">
                <label>侧摆要求</label>
                <div class="ui fluid dropdown selection" tabindex="0">
                    <select id="sideAngel" name="sideAngel">
                        <option value=""></option>
                        <option value="-40~40" <c:if test="${userRequest.sideAngel == '-40~40'}">selected</c:if>>-40~40</option>
                        <option value="0~40" <c:if test="${userRequest.sideAngel == '0~40'}">selected</c:if>>0~40</option>
                    </select>
                    <i class="dropdown icon"></i>
                    <div class="default text">侧摆角要求</div>
                    <div class="menu transition hidden" tabindex="-1">
                        <div class="item" data-value="-40~40">-40~40</div>
                        <div class="item" data-value="0~40">0~40</div>
                    </div>
                </div>
            </div>
            <a href="javascript:CloseDiv();">收起</a>
        </div>
    </div>

    <div id="cesiumContainer" style="margin-bottom: 0.75rem">
        <div class="loggingMessage"></div>
    </div>
    <input type="hidden" id="imagingWkt" name="imagingWkt" >
    <textarea  style="display:none" class="ready-only" id="imagingPara" name="imagingParaTxt">${userRequest.imagingParaTxt}</textarea>

    <div class="always-bottom ">
        <div class="field">
            <div class="sixteen fields">
                <c:if test="${userRequest == null}">
                    <div class="field">
                        <input class="ui teal submit button" type="submit" name="isSubmit" value="下一步" >
                    </div>
                </c:if>
                <c:if test="${userRequest != null}">
                    <div class="field">
                        <input class="ui teal submit button" type="submit" name="isSubmit" value="保存修改">
                    </div>
                </c:if>
                <c:if test="${userRequest != null}">
                    <c:if test="${author.id eq submitter.id}">
                        <div class="field">
                            <a class="ui teal submit button"  href="cancelUserRequest?userRequestId=${userRequest.id}">Cancel Request</a>
                        </div>
                    </c:if>
                    <c:if test="${author.id != submitter.id}">
                        <sec:authorize access="hasRole('ROLE_ADMIN')">
                            <div class="field">
                                <a class="ui blue submit button"  href="cancelUserRequest?userRequestId=${userRequest.id}">Cancel Request</a>
                            </div>
                        </sec:authorize>
                    </c:if>
                </c:if>
            </div>
        </div></div>
</form>
</body>
</html>

