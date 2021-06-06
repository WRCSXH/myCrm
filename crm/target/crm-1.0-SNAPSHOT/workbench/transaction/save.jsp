<%@ page import="java.util.Map" %>
<%@ page import="java.util.Set" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
	// 从服务器缓存中获取spMap
	Map<String,String> stagePossibilityMap = (Map<String, String>) application.getAttribute("stagePossibilityMap");
	// 获取spMap中所有的key
	Set<String> set = stagePossibilityMap.keySet();
%>
<!DOCTYPE html>
<html>
<head>
	<base href="<%=basePath%>">
<meta charset="UTF-8">

<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
<script type="text/javascript" src="jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>
<script type="text/javascript">

	// 如果js中变量名已经定义好了是json，那么最后一个逗号不用去掉也会被判定为json串
	var json = {
		<%
			for(String key:set){
				String value = stagePossibilityMap.get(key);

		%>
			"<%=key%>":"<%=value%>",
		<%
			}
		%>
	};

	// [Object object]
	// alert(json);

	/*
		关于阶段和可能性
			是一种一一对应的关系
			一个阶段对应一个可能性
			我们现在可以将阶段和可能性想象成一种键值对之间的对应关系
			以阶段为key，通过选中阶段，来触发value

			stage				possibility
			key					value
			01资质审查			10
			02需求分析			25
			03价值建议			40
			......				......
			07成交				100
	        08丢失的线索			0
			09因竞争而丢失关闭	0

			对于以上的数据，通过观察得到结论：
			（1）数据量不是很大
			（2）这是一种键值对之间的对应关系

			如果同时满足以上两种结论，那么我们将这样的数据保存到数据表中就没有什么意义了
			如果遇到这种情况，我们需要用到.properties属性配置文件来进行保存
			Stage2Possibility.properties
			01资质审查=10
			02需求分析=25
			......

			.properties属性配置文件中文需要转成unicode编码来保存
			01资质审查			01\u8d44\u8d28\u5ba1\u67e5
			02需求分析			02\u9700\u6c42\u5206\u6790
			......				......
			07成交				07\u6210\u4ea4

			Stage2Possibility.properties这个文件表示的是阶段和键值对之间的对应关系，将来我们通过stage这个键以及对应关系，来获取possibility这个值
			这种需求在交易模块中需要被大量的用到

			所以我们就需要将该文件解析在服务器缓存中
			application.setAttribute(Stage2Possibility.properties文件中的内容);
	 */
	$(function () {

		// 自动补全
		$("#create-customerName").typeahead({
			source: function (query, process) {
				$.get(
						"workbench/transaction/getCustomerName.do",
						{ "name" : query },
						function (data) {
							//alert(data);

							// data[{客户名称1},{2},{3}]，data接收的是字符串而不是整个客户对象
							process(data);
						},
						"json"
				);
			},

			// 展示的延迟，用于等待用户输入字符的时间和减缓数据库查询的压力
			delay: 1500
		});

		$(".time1").datetimepicker({
			minView: "month",
			language:  'zh-CN',
			format: 'yyyy-mm-dd',
			autoclose: true,
			todayBtn: true,
			pickerPosition: "bottom-left"
		});

		$(".time2").datetimepicker({
			minView: "month",
			language:  'zh-CN',
			format: 'yyyy-mm-dd',
			autoclose: true,
			todayBtn: true,
			pickerPosition: "top-left"
		});

		// 为阶段的下拉框，绑定选中下拉框事件，根据选中的阶段填写可能性
		$("#create-stage").change(function () {
			// 取得选中的阶段
			var stage = $("#create-stage").val();

			/*
				目标：填写可能性
				阶段有了stage，
				阶段和可能性之间的对应关系spMap，但是spMap是java语言中的键值对关系（java中的Map集合对象）
				我们首先得将spMap转换为js中的键值对关系json

				即将
				spMap.put("01资质审查",10);
				spMap.put("02需求分析",25);
				......
				转换为
				var json = {"01需求分析":10,"02资质审查":25,......}

				以上将json处理好之后，取可能性
			 */

			// alert(stage);

			/*
				我们现在以json.key的形式不能取得value，因为今天的stage是一个可变的变量，
				如果是这样的key，我们不能以传统形式的json.key的方式来取值，
				我们要使用的取值方式为json[key]
			 */
			var possibility = json[stage];

			// alert(possibility);

			// 将possibility赋值给可能性文本框，向用户展示
			$("#create-possibility").val(possibility);
		})

		// 为保存按钮绑定事件，添加交易
		$("#saveBtn").click(function () {
			// 发出传统请求，提交表单
			$("#tranForm").submit();
		})
	})
</script>
</head>
<body>

	<!-- 查找市场活动 -->	
	<div class="modal fade" id="findMarketActivity" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">查找市场活动</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input type="text" class="form-control" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable3" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td><input type="radio" name="activity"/></td>
								<td>发传单</td>
								<td>2020-10-10</td>
								<td>2020-10-20</td>
								<td>zhangsan</td>
							</tr>
							<tr>
								<td><input type="radio" name="activity"/></td>
								<td>发传单</td>
								<td>2020-10-10</td>
								<td>2020-10-20</td>
								<td>zhangsan</td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>

	<!-- 查找联系人 -->	
	<div class="modal fade" id="findContacts" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">查找联系人</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input type="text" class="form-control" style="width: 300px;" placeholder="请输入联系人名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>邮箱</td>
								<td>手机</td>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td><input type="radio" name="activity"/></td>
								<td>李四</td>
								<td>lisi@bjpowernode.com</td>
								<td>12345678901</td>
							</tr>
							<tr>
								<td><input type="radio" name="activity"/></td>
								<td>李四</td>
								<td>lisi@bjpowernode.com</td>
								<td>12345678901</td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>
	
	
	<div style="position:  relative; left: 30px;">
		<h3>创建交易</h3>
	  	<div style="position: relative; top: -40px; left: 70%;">
			<button type="button" class="btn btn-primary" id="saveBtn">保存</button>
			<button type="button" class="btn btn-default">取消</button>
		</div>
		<hr style="position: relative; top: -40px;">
	</div>
	<form class="form-horizontal" role="form" style="position: relative; top: -30px;" id="tranForm" action="workbench/transaction/save.do" method="post">
		<div class="form-group">
			<label for="create-transactionOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-transactionOwner" name="owner">
				  <c:forEach items="${requestScope.userList}" var="user">
					  <!-- 如果session域中的user.id和request域中的userList的一个user.id相同，就选中 -->
					  <option value="${user.id}" ${sessionScope.user.id eq user.id ? "selected" : ""}>${user.name}</option>
				  </c:forEach>
				</select>
			</div>
			<label for="create-amountOfMoney" class="col-sm-2 control-label">金额</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-amountOfMoney" name="money">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-transactionName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-transactionName" name="name">
			</div>
			<label for="create-expectedClosingDate" class="col-sm-2 control-label">预计成交日期<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control time1" id="create-expectedClosingDate" name="expectedDate" readonly>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-customerName" class="col-sm-2 control-label">客户名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-customerName" name="customerName" placeholder="支持自动补全，输入客户不存在则新建">
			</div>
			<label for="create-stage" class="col-sm-2 control-label">阶段<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
			  <select class="form-control" id="create-stage" name="stage">
			  	<option></option>
				  <c:forEach items="${stageList}" var="stage">
					  <option value="${stage.value}">${stage.text}</option>
				  </c:forEach>
			  </select>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-transactionType" class="col-sm-2 control-label">类型</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-transactionType" name="type">
				  <option></option>
					<c:forEach items="${transactionTypeList}" var="transactionType">
						<option value="${transactionType.value}">${transactionType.text}</option>
					</c:forEach>
				</select>
			</div>
			<label for="create-possibility" class="col-sm-2 control-label">可能性</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-possibility" name="possibility">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-clueSource" class="col-sm-2 control-label">来源</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-clueSource" name="source">
				  <option></option>
					<c:forEach items="${sourceList}" var="source">
						<option value="${source.value}">${source.text}</option>
					</c:forEach>
				</select>
			</div>
			<!-- 查询市场活动源和联系人名称已经写过了，这里写死 -->
			<label for="create-activitySrc" class="col-sm-2 control-label">市场活动源&nbsp;&nbsp;<a href="javascript:void(0);" data-toggle="modal" data-target="#findMarketActivity"><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-activitySrc" value="聚餐1">
				<input type="hidden" value="1f6f914be33d4850a797a43e1301c577" name="activityId">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-contactsName" class="col-sm-2 control-label">联系人名称&nbsp;&nbsp;<a href="javascript:void(0);" data-toggle="modal" data-target="#findContacts"><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-contactsName" value="马云">
				<input type="hidden" value="cf1b5dd8c4d64d0dad01e45530101d03" name="contactsId">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-describe" class="col-sm-2 control-label">描述</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="create-describe" name="description"></textarea>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="create-contactSummary" name="contactSummary"></textarea>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control time2" id="create-nextContactTime" name="nextContactTime" readonly>
			</div>
		</div>
		
	</form>
</body>
</html>