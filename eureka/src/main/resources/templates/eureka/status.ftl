<#import "/spring.ftl" as spring />
<!doctype html>
<!--[if lt IE 7]>      <html class="no-js lt-ie9 lt-ie8 lt-ie7"> <![endif]-->
<!--[if IE 7]>         <html class="no-js lt-ie9 lt-ie8"> <![endif]-->
<!--[if IE 8]>         <html class="no-js lt-ie9"> <![endif]-->
<!--[if gt IE 8]><!--> <html class="no-js"> <!--<![endif]-->
<head>
    <base href="<@spring.url basePath/>">
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>Eureka</title>
    <meta name="description" content="">
    <meta name="viewport" content="width=device-width">
    <link rel="stylesheet" href="eureka/css/wro.css">
    <style type="text/css">
        .mask {
            position: absolute; top: 0px;
            filter: alpha(opacity=60);
            background-color: #777;
            z-index: 10;
            left: 0px;
            opacity:0.5;
            -moz-opacity:0.1;
        }
        .pop {
            padding: 10px 6px;
            position: fixed;
        　　-moz-border-radius: 32px;
        　　-webkit-border-radius: 32px;
        　　border-radius: 32px;
            left: 50%;
            top: 50%;
            width:800px;
            height:400px;
            margin-left:-400px;
            margin-top:-200px;
            background-color: #fff;
            z-index: 100;
            display: none;
        }

        .close{
            font-size:12px;
        }
    </style>
</head>

<body id="one">
<#include "header.ftl">
<div class="container-fluid xd-container">
<#include "navbar.ftl">
    <h1>Instances currently registered with Eureka</h1>
    <table id='app-instance' class="table table-striped table-hover" border="1">
        <thead>
        <tr>
            <th>Application</th>
            <th>Instance</th>
            <th>AMIs</th>
            <th>Availability Zones</th>
            <th>Status</th>
            <th>元数据</th>
            <th>操作</th>
        </tr>
        </thead>
        <tbody>

        <#if apps?has_content>
            <#list apps as app>
                <#list app.instanceInfos as instanceInfo>
                    <#list instanceInfo.instances as instance>
                    <tr>
                        <td><b>${app.name}</b></td>
                        <td><b>${instance.id}</b></td>
                        <td>
                            <#list app.amiCounts as amiCount>
                                <b>${amiCount.key}</b> (${amiCount.value})<#if amiCount_has_next>,</#if>
                            </#list>
                        </td>
                        <td>
                            <#list app.zoneCounts as zoneCount>
                                <b>${zoneCount.key}</b> (${zoneCount.value})<#if zoneCount_has_next>,</#if>
                            </#list>
                        </td>
                        <td>
                            <#if instanceInfo.isNotUp>
                            <font color=red size=+1><b>
                            </#if>
                            <b>${instanceInfo.status}</b>
                            <#if instanceInfo.isNotUp>
                                </b></font>
                            </#if>
                        </td>
                        <td class="metadata">EMPTY</td>
                        <td>
                         <#if instanceInfo.isNotUp>
                             <a href="javascript:void(0)"
                                data-action="UP"
                                data-instance-id="${instance.id}"
                                data-app-name="${app.name}"
                                class="status-mgr">上线实例</a>
                            <#else>
                                <a href="javascript:void(0)"
                                   data-instance-id="${instance.id}"
                                   data-app-name="${app.name}"
                                   class="meta-mgr"
                                >元数据管理</a>
                                <a href="javascript:void(0)"
                                   data-action="OUT_OF_SERVICE"
                                   data-instance-id="${instance.id}"
                                   data-app-name="${app.name}"
                                   class="status-mgr">下线实例</a>
                            </#if>
                        </td>
                    </tr>
                    </#list>
            </#list>
            </#list>
        <#else>
        <tr><td colspan="4">没有可用实例</td></tr>
        </#if>


        </tbody>
    </table>

    <h1>General Info</h1>

    <table id='generalInfo' class="table table-striped table-hover">
        <thead>
        <tr><th>Name</th><th>Value</th></tr>
        </thead>
        <tbody>
        <#list statusInfo.generalStats?keys as stat>
        <tr>
            <td>${stat}</td><td>${statusInfo.generalStats[stat]!""}</td>
        </tr>
        </#list>
        <#list statusInfo.applicationStats?keys as stat>
        <tr>
            <td>${stat}</td><td>${statusInfo.applicationStats[stat]!""}</td>
        </tr>
        </#list>
        </tbody>
    </table>

    <h1>Instance Info</h1>

    <table id='instanceInfo' class="table table-striped table-hover">
        <thead>
        <tr><th>Name</th><th>Value</th></tr>
        <thead>
        <tbody>
        <#list instanceInfo?keys as key>
        <tr>
            <td>${key}</td><td>${instanceInfo[key]!""}</td>
        </tr>
        </#list>
        </tbody>
    </table>
</div>
<div id="mask" class="mask"></div>
<div class="pop">
    <div class="close">关闭</div>
    <input type="hidden" name="instanceId" id="instanceId"/>
    <input type="hidden" name="appName" id="appName"/>
    <h1>元数据管理(实例名:<span class="instance"></span>)</h1>
    <table id="metadata-table" class="table table-striped table-hover">
        <thead>
        <tr>
            <th>名称</th>
            <th>值</th>
            <th>#</th>
        </tr>
        </thead>
        <tbody></tbody>
    </table>
    <a href="javascript:void(0)" onclick="addMetadataRow()">添加一行</a>
    <a href="javascript:void(0)" onclick="updateMetadata()">更新元数据</a>
</div>
<script type="text/javascript" src="eureka/js/wro.js" ></script>
<script type="text/javascript">
    function addMetadataRow() {
        $("<tr><td><input /></td><td><input /></td><td><a class='metadata-del'>删除</a></td></tr>").appendTo("#metadata-table tbody");
    }
    function updateMetadata() {
        var params = new Array();
        $("#metadata-table tbody tr").each(function (i,n) {
            var name=$("input:eq(0)",n).val();
            if(name){
                var value=$("input:eq(1)",n).val();
                params.push(name+"="+value);
            }
        });
        var appName=$("#appName").val();
        var instanceId= $("#instanceId").val();
        $.ajax({
            url:"/eureka/apps/"+appName+"/"+instanceId+"/metadata?"+params.join("&"),
            type:"PUT",
            dataType:"text",
            success:function(result){
                alert("操作成功");
                window.location.reload();
            }
        });
    }

    $(document).ready(function() {
        $('table.stripeable tr:odd').addClass('odd');
        $('table.stripeable tr:even').addClass('even');
        $("#app-instance>tbody>tr").each(function (i,n) {
            var $td=$(n).children("td");
            if($td.length>=6){
                var appId=$td.eq(0).text();
                var instanceId=$td.eq(1).text();
                $.getJSON("/eureka/apps/"+appId+"/"+instanceId,function (resp) {
                    var  metadata=resp.instance.metadata;
                    var items= new Array();
                    for( name in metadata ) {
                        items.push("<p>"+name+"="+metadata[name]+"</p>");
                    }
                    var $metadataTd=$(".metadata",n);
                    $metadataTd.html(items);
                    //                   $(items).appendTo($metadataTd);
                });
            }
        });
        
        //上线 下线
        $(".status-mgr").click(function () {
            var instanceId=$(this).attr("data-instance-id");
            var appName=$(this).attr("data-app-name");
            var action=$(this).attr("data-action");
            $.ajax({
                url:"/eureka/apps/"+appName+"/"+instanceId+"/status?value="+action,
                type:"PUT",
                dataType:"text",
                success:function(result){
                    alert("操作成功");
                    window.location.reload();
                }
            });
        });
        
        $(".meta-mgr").click(function () {
            var $pop=$(".pop");
            var instanceId=$(this).attr("data-instance-id");
            var appName=$(this).attr("data-app-name");
            $("#appName").val(appName);
            $("#instanceId").val(instanceId);
            $(".instance",$pop).text(instanceId);
            $.getJSON("/eureka/apps/"+appName+"/"+instanceId,function (resp) {
                var  metadata=resp.instance.metadata;
                var items= new Array();
                for( name in metadata ) {
                    var name_td=null;
                    var value_td=null;
                    var action_td=null;
                    if (name=="management.port"){
                        name_td="<td>"+name+"</td>"
                        value_td="<td>"+metadata[name]+"</td>"
                        action_td="<td></td>"
                    }else {
                        name_td="<td><input value='"+name+"' /></td>";
                        value_td="<td><input value='"+metadata[name]+"' /></td>";
                        action_td="<td><a class='metadata-del'>删除</a></td>"
                    }
                    items.push("<tr>"+name_td+value_td+action_td+"</tr>");
                }
                var $metadataBody=$("tbody",$pop);
                $metadataBody.html(items);
            });
            $("#mask").css("height",$(document).height());
            $("#mask").css("width",$(document).width());
            $("#mask,.pop").show();
        });

        $(document).on("click",".metadata-del",function () {
            $(this).parent("td").parent("tr").remove();
        });

        $(".close").click(function () {
            $(".pop,#mask").hide();
        });
    });
</script>
</body>
</html>