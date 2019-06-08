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
                                <a href="javascript:void(0)">元数据管理</a>
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
<script type="text/javascript" src="eureka/js/wro.js" ></script>
<script type="text/javascript">
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

        //
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
    });
</script>
</body>
</html>