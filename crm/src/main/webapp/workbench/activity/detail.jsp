<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
%>
<!DOCTYPE html>
<html>
<head>
	<base href="<%=basePath%>">
<meta charset="UTF-8">

<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>

<script type="text/javascript">

	//默认情况下取消和保存按钮是隐藏的
	var cancelAndSaveBtnDefault = true;

	$(function(){
		$("#remark").focus(function(){
			if(cancelAndSaveBtnDefault){
				//设置remarkDiv的高度为130px
				$("#remarkDiv").css("height","130px");
				//显示
				$("#cancelAndSaveBtn").show("2000");
				cancelAndSaveBtnDefault = false;
			}
		});
		
		$("#cancelBtn").click(function(){
			//显示
			$("#cancelAndSaveBtn").hide();
			//设置remarkDiv的高度为130px
			$("#remarkDiv").css("height","90px");
			cancelAndSaveBtnDefault = true;
		});
		
		$(".remarkDiv").mouseover(function(){
			$(this).children("div").children("div").show();
		});
		
		$(".remarkDiv").mouseout(function(){
			$(this).children("div").children("div").hide();
		});
		
		$(".myHref").mouseover(function(){
            $(this).children("span").css("color","red");
        });
		
		$(".myHref").mouseout(function(){
			$(this).children("span").css("color","#E6E6E6");
		});

        // 添加和删除图标的动画效果
        $("#remarkBody").on("mouseover",".remarkDiv",function(){
            $(this).children("div").children("div").show();
        })
        $("#remarkBody").on("mouseout",".remarkDiv",function(){
            $(this).children("div").children("div").hide();
        })

        // 页面加载完毕后，展示市场活动备注列表
        showRemarkList();

        // 为编辑按钮绑定事件，打开修改市场活动的模态窗口
        $("#editBtn").click(function () {
                // 发送ajax请求，为下拉列表框和选中的记录铺值
                $.ajax({
                    url:"workbench/activity/getUserListAndActivity.do",
                    type:"get",
                    data:{
                        // 根据id选中记录
                        "id":"${activity.id}"
                    },
                    dataType:"json",
                    success:function(result){
                        // result包括用户列表和市场活动对象

                        /*
                            result{"userList":[{用户1},{2},{3}],"activity":市场活动对象}
                        */

                        // 拼接html命令为下拉列表框铺值
                        var html = "";
                        $.each(result.userList,function (index,element) {
                            html += "<option value='"+element.id+"'>"+element.name+"</option>";
                        })
                        $("#edit-owner").html(html);

                        // 为选中的记录铺值
                        $("#edit-owner").val(result.activity.owner);
                        $("#edit-name").val(result.activity.name);
                        $("#edit-startDate").val(result.activity.startDate);
                        $("#edit-endDate").val(result.activity.endDate);
                        $("#edit-cost").val(result.activity.cost);
                        $("#edit-description").val(result.activity.description);
                    }
                })

                // 铺完值，打开修改市场活动的模态窗口
                $("#editActivityModal").modal("show");
        })

        // 为更新按钮绑定事件，修改市场活动
        $("#updateBtn").click(function () {
            $.ajax({
                url:"workbench/activity/update.do",
                type:"post",
                data:{
                    "id":"${activity.id}",
                    "owner":$.trim($("#edit-owner").val()),
                    "name":$.trim($("#edit-name").val()),
                    "startDate":$.trim($("#edit-startDate").val()),
                    "endDate":$.trim($("#edit-endDate").val()),
                    "cost":$.trim($("#edit-cost").val()),
                    "description":$.trim($("#edit-description").val())
                },
                dataType:"json",
                success:function(result){
                    // result{"isSuccess":true/false}
                    if (result.isSuccess){
                        // 修改市场活动成功后

                        // 关闭修改市场活动的模态窗口
                        $("#editActivityModal").modal("hide");

                        // 跳转到详细信息页
                        window.location.href="workbench/activity/detail.do?id=${activity.id}";
                    } else {
                        alert("修改市场活动失败！");
                    }
                }
            })
        })

        // 为删除按钮绑定事件，删除市场活动
        $("#deleteBtn").click(function () {
            if(confirm("确定删除本记录吗？")){
                // 发送ajax请求
                $.ajax({
                    url:"workbench/activity/delete.do",
                    type:"post",
                    data:{
                        "id":"${activity.id}"
                    },
                    dataType:"json",
                    success:function(result){
                        if (result.isSuccess){
                            // result{"isSuccess":true/false}

                            // 跳转到市场活动首页
                            window.location.href="workbench/activity/index.jsp";
                        } else {
                            alert("删除市场活动失败！");
                        }
                    }
                })
            }
        })

        // 为保存按钮绑定事件，添加市场活动备注
        $("#saveRemarkBtn").click(function () {
            $.ajax({
                url:"workbench/activity/saveRemark.do",
                type:"post",
                data:{
                    // 文本域textarea虽然是标签对，没有value属性，但是和文本框text一样使用val()取值
                    "noteContent":$.trim($("#remark").val()),
                    "activityId": "${activity.id}"
                },
                dataType:"json",
                success:function(result){
                    // result{"isSuccess":true/false,"activityRemark":{市场活动备注}}
                    if (result.isSuccess){
                        // 添加市场活动备注成功后
                        // 清空文本域textarea中的内容
                        $("#remark").val("");
                        // 在remarkDiv的上方新增一个div
                        var html = "";

                        html += '<div id="'+result.activityRemark.id+'" class="remarkDiv" style="height: 60px;">';
                        // 如果当前用户添加市场活动备注之后直接点击修改，那么此时添加人一定和修改人相同
                        html += '<img title="'+result.activityRemark.createBy+'" src="image/user-thumbnail.png" style="width: 30px; height:30px;">';
                        html += '<div style="position: relative; top: -40px; left: 40px;">';
                        html += '<h5 id="h5'+result.activityRemark.id+'">'+result.activityRemark.noteContent+'</h5>';
                        html += '<font color="gray">市场活动</font> <font color="gray">-</font> <b>${a.name}</b> <small style="color: gray;" id="s'+result.activityRemark.id+'">'+(result.activityRemark.createTime)+'由'+(result.activityRemark.createBy)+'</small>';
                        html += '<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
                        html += '<a class="myHref" href="javascript:void(0);" onclick="editRemark(\''+result.activityRemark.id+'\')"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #FF0000;"></span></a>';
                        html += '&nbsp;&nbsp;&nbsp;&nbsp;';
                        html += '<a class="myHref" href="javascript:void(0);" onclick="deleteRemark(\''+result.activityRemark.id+'\')"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #FF0000;"></span></a>';
                        html += '</div>';
                        html += '</div>';
                        html += '</div>';

                        $("#remarkDiv").before(html);
                    } else {
                        alert("添加市场活动备注失败！");
                    }
                }
            })
        })

        // 为更新按钮绑定事件，修改市场活动备注
        $("#updateRemarkBtn").click(function () {
            // 从隐藏域中取得id
            var id = $("#remarkId").val();
            $.ajax({
                url:"workbench/activity/updateRemark.do",
                type:"post",
                data:{
                    "id":id,
                    // 从文本域中取得备注内容
                    "noteContent": $.trim($("#noteContent").val())
                },
                dataType:"json",
                success:function(result){
                    // result{"isSuccess":true/false,"activityRemark":{市场活动备注}}
                    if (result.isSuccess){
                        // 修改市场活动备注成功后
                        // 更新h5标签对中的市场活动备注内容
                        $("#h5"+id).html(result.activityRemark.noteContent);
                        // 更新small标签对中的市场活动备注内容
                        $("#s"+id).html(result.activityRemark.editTime+"由"+result.activityRemark.editBy);
                        // 关闭修改市场活动备注的模态窗口
                        $("#editRemarkModal").modal("hide");
                    } else {
                        alert("修改市场活动备注失败！")
                    }
                }
            })
        })

    });

    // 展示市场活动备注列表
    function showRemarkList(){

        $.ajax({
            url:"workbench/activity/getRemarkListByActivityId.do",
            type:"get",
            data:{
                "activityId":"${activity.id}"
            },
            dataType:"json",
            success:function(result){
                // result[{市场活动1},{2},{3}]
                var html = "";
                $.each(result,function (index,element) {
                    html += '<div id="'+element.id+'" class="remarkDiv" style="height: 60px;">';
                    html += '<img title="'+(element.editFlag==0?element.createBy:element.editBy)+'" src="image/user-thumbnail.png" style="width: 30px; height:30px;">';
                    html += '<div style="position: relative; top: -40px; left: 40px;">';
                    html += '<h5 id="h5'+element.id+'">'+element.noteContent+'</h5>';
                    html += '<font color="gray">市场活动</font> <font color="gray">-</font> <b>${activity.name}</b> <small style="color: gray;" id="s'+element.id+'">'+(element.editFlag==0?element.createTime:element.editTime)+'由'+(element.editFlag==0?element.createBy:element.editBy)+'</small>';
                    html += '<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
                    html += '<a class="myHref" href="javascript:void(0);" onclick="editRemark(\''+element.id+'\')"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #FF0000;"></span></a>';
                    html += '&nbsp;&nbsp;&nbsp;&nbsp;';
                    // javascript:void(0);表示禁用超链接
                    // 这里在标签中直接绑定事件
                    html += '<a class="myHref" href="javascript:void(0);" onclick="deleteRemark(\''+element.id+'\')"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #FF0000;"></span></a>';
                    html += '</div>';
                    html += '</div>';
                    html += '</div>';
                })

                // 使用before()方法在remarkDiv的上方追加
                $("#remarkDiv").before(html);
            }
        })
    }

    // 删除市场活动备注
    function deleteRemark(id) {
        $.ajax({
            url:"workbench/activity/deleteRemark.do",
            type:"post",
            data:{
                "id":id
            },
            dataType:"json",
            success:function(result){
                // result{"isSuccess":true/false}
                if (result.isSuccess){
                    // 删除市场活动备注成功后，移除与之对应的div
                    $("#"+id).remove();
                } else {
                    alert("删除市场活动备注失败！");
                }
            }
        })
    }

    // 打开修改市场活动备注的模态窗口，铺上原来的市场活动备注
    function editRemark(id) {
        // 将要修改的市场活动备注id保存到隐藏域
        $("#remarkId").val(id);
        // 将h5标签对中的内容赋值给该模态窗口的文本域
        $("#noteContent").val($("#h5"+id).html());
        // 铺完值后，打开模态窗口
        $("#editRemarkModal").modal("show");
    }
</script>
</head>
<body>
	
	<!-- 修改市场活动备注的模态窗口 -->
	<div class="modal fade" id="editRemarkModal" role="dialog">
		<!-- 备注的id -->
		<input type="hidden" id="remarkId">
        <div class="modal-dialog" role="document" style="width: 40%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel1">修改备注</h4>
                </div>
                <div class="modal-body">
                    <form class="form-horizontal" role="form">
                        <div class="form-group">
                            <label for="edit-description" class="col-sm-2 control-label">内容</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="noteContent"></textarea>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button type="button" class="btn btn-primary" id="updateRemarkBtn">更新</button>
                </div>
            </div>
        </div>
    </div>

    <!-- 修改市场活动的模态窗口 -->
    <div class="modal fade" id="editActivityModal" role="dialog">
        <div class="modal-dialog" role="document" style="width: 85%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
                </div>
                <div class="modal-body">

                    <form class="form-horizontal" role="form">

                        <div class="form-group">
                            <label for="edit-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <select class="form-control" id="edit-owner">
                                </select>
                            </div>
                            <label for="edit-name" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-name">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="edit-startDate" class="col-sm-2 control-label">开始日期</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-startDate">
                            </div>
                            <label for="edit-endDate" class="col-sm-2 control-label">结束日期</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-endDate">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="edit-cost" class="col-sm-2 control-label">成本</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-cost">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="edit-description" class="col-sm-2 control-label">描述</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="edit-description"></textarea>
                            </div>
                        </div>

                    </form>

                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button type="button" class="btn btn-primary" id="updateBtn">更新</button>
                </div>
            </div>
        </div>
    </div>

	<!-- 返回按钮 -->
	<div style="position: relative; top: 35px; left: 10px;">
		<a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>
	
	<!-- 大标题 -->
	<div style="position: relative; left: 40px; top: -30px;">
		<div class="page-header">
			<h3>市场活动-${activity.name} <small>${activity.startDate} ~ ${activity.endDate}</small></h3>
		</div>
		<div style="position: relative; height: 50px; width: 250px;  top: -72px; left: 700px;">
			<button type="button" class="btn btn-default" id="editBtn"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
			<button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
		</div>
	</div>
	
	<!-- 详细信息 -->
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${activity.owner}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${activity.name}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>

		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">开始日期</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${activity.startDate}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">结束日期</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${activity.endDate}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">成本</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${activity.cost}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${activity.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${activity.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${activity.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${activity.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${activity.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
	</div>
	
	<!-- 备注 -->
	<div id="remarkBody" style="position: relative; top: 30px; left: 40px;">
		<div class="page-header">
			<h4>备注</h4>
		</div>

		<div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
			<form role="form" style="position: relative;top: 10px; left: 10px;">
				<textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="添加备注..."></textarea>
				<p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
					<button id="cancelBtn" type="button" class="btn btn-default">取消</button>
					<button type="button" class="btn btn-primary" id="saveRemarkBtn">保存</button>
				</p>
			</form>
		</div>

	</div>
	<div style="height: 200px;"></div>
</body>
</html>