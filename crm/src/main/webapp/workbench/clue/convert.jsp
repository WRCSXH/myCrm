<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="static javax.servlet.jsp.PageContext.REQUEST_SCOPE" %>
<%@ page import="static javax.servlet.jsp.PageContext.SESSION_SCOPE" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
/*
	关于jsp中的九大内置对象：
		request、response、session、application、out、pageContext、config、page、exception
 */

// 在jsp中使用java命令获取参数并铺值，不方便
/*
	String fullname = request.getParameter("fullname");
	String appellation = request.getParameter("appellation");
	String company = request.getParameter("company");
	String owner = request.getParameter("owner");
*/

/*
	关于在jsp和EL表达式中的pageContext内置对象的区别

		在EL表达式中，只有pageContext内置对象，要想使用其它内置对象，必须通过${pageContext.属性}的方式获取，如取得request域对象：${pageContext.request}
			常用命令：${pageContext.request.contextPath}，取出所部署项目的名字
		但是在EL表达式中可以通过pageScope、requestScope、sessionScope、applicationScope来获取jsp中pageContext、request、session、application等域对象中保存的值

		在jsp中，有九大内置对象（request、response、session、application、out、pageContext、config、page、exception），可以直接拿来使用，
		也可以通过pageContext.方法的方式获取其它八大内置对象，如取得request域对象：pageContext.getRequest()，但没必要

		当存取值时，在jsp和EL表达式中的pageContext内置对象都可以传入常量参数XXX_SCOPE，
		任意转换成其它域对象来扩大使用的范围，如转换成request域对象和session域对象
			pageContext.setAttribute("key","value",REQUEST_SCOPE);
			pageContext.getAttribute("key",SESSION_SCOPE);

			${pageContext.setAttribute("key","value",REQUEST_SCOPE)}
			${pageContext.getAttribute("key",SESSION_SCOPE)}
*/
%>
<!DOCTYPE html>
<html>
<head>
	<base href="<%=basePath%>">
<meta charset="UTF-8">

<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>


<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

<script type="text/javascript">
	$(function(){

		$(".time").datetimepicker({
			minView: "month",
			language:  'zh-CN',
			format: 'yyyy-mm-dd',
			autoclose: true,
			todayBtn: true,
			pickerPosition: "bottom-left"
		});

		$("#isCreateTransaction").click(function(){
			if(this.checked){
				$("#create-transaction2").show(200);
			}else{
				$("#create-transaction2").hide(200);
			}
		});

		// 为搜索图标绑定事件
		$("#openSearchActivityModal").click(function () {
			// 清空搜索框
			$("#searchByActivityName").val("");
			// 清空上次查询生成的市场活动列表
			$("#activitySearchBody").html("");
			// 打开搜索市场活动的模态窗口
			$("#searchActivityModal").modal("show");
		})

		// 为搜索市场活动的搜索框绑定敲回车事件，搜索市场活动
		$("#searchByActivityName").keydown(function (event) {
			if (event.keyCode == 13){
				$.ajax({
					url:"workbench/clue/getActivityListByActivityName.do",
					type:"get",
					data:{
						"activityName": $.trim($("#searchByActivityName").val())
					},
					dataType:"json",

					success:function(result){
						// result[{市场活动1},{2},{3}]
						var html = "";
						$.each(result,function (index,element) {
							html += '<tr>';
							html += '<td><input type="radio" name="xz" value="'+element.id+'"/></td>';
							html += '<td id="td'+element.id+'">'+element.name+'</td>';
							html += '<td>'+element.startDate+'</td>';
							html += '<td>'+element.endDate+'</td>';
							html += '<td>'+element.owner+'</td>';
							html += '</tr>';
						})
						$("#activitySearchBody").html(html);
					}
				})
				// 禁用在模态窗口中默认按下回车键会清空当前页面的行为
				return false;
			}
		})

		// 为保存按钮绑定事件，填充市场活动源文本框（市场活动名称）和隐藏域（市场活动id）
		$("#saveBtn").click(function () {
			// 不需要走后台
			$cxz = $("input[name=xz]:checked");
			var id = $cxz.val();
			var name = $("#td"+id).html();
			$("#activityName").val(name);
			$("#activityId").val(id);
			// 关闭搜索市场活动的模态窗口
			$("#searchActivityModal").modal("hide");
		})

		// 为转换按钮绑定事件，转换线索
		$("#convertBtn").click(function () {
			// 发出传统请求到后台，转换线索，请求结束后，响应到线索列表页
			// 根据“为客户创建交易”的复选框是否挑勾，来判断是否需要创建交易
			if ($("#isCreateTransaction").prop("checked")){
				// alert("需要创建交易！");
				// 在需要创建交易时，除了要为后台传递clueId之外，还得为后台传递交易表单中的信息：金额、交易名称、预计成交日期、阶段、市场活动源（市场活动id）
				// window.location.href = "workbench/clue/convert.do?clueId=xxx&money=xxx&name=xxx&expectedDate=xxx&stage=xxx&activityId=xxx";

				// 以上传递参数的方式很麻烦，而且表单一旦需要扩充，挂载的参数极有可能超出浏览器地址栏的上限
				// 所以我们采用提交交易表单的方式来发出本次传统请求，提交表单的参数不需要我们手动去挂载（表单中填写name属性即可）
				// 另外提交表单可以使用post请求（保证了参数的安全性，参数在请求体中，长度也没有上限）

				// 提交表单
				$("#tranForm").submit();
			} else {
				// alert("不需要创建交易！");
				// 在不需要创建交易时，传一个clueId即可
				window.location.href = "workbench/clue/convert.do?clueId=${param.id}";
			}

			// 一旦点击了转换按钮，最后都必须跳转到客户首页
			// window.location.href = "workbench/customer/index.jsp";
		})

		// 为取消按钮绑定事件，跳转到详细信息页
		$("#cancelBtn").click(function () {
			// 返回到上一个页面
			window.history.back();
		})
	});
</script>

</head>
<body>
	
	<!-- 搜索市场活动的模态窗口 -->
	<div class="modal fade" id="searchActivityModal" role="dialog" >
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">搜索市场活动</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input type="text" class="form-control" id="searchByActivityName" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
								<td></td>
							</tr>
						</thead>
						<tbody id="activitySearchBody"></tbody>
					</table>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button type="button" class="btn btn-primary" id="saveBtn">保存</button>
				</div>
			</div>
		</div>
	</div>

	<%--<div id="title" class="page-header" style="position: relative; left: 20px;">
		<h4>转换线索 <small><%=fullname%><%=appellation%>-<%=company%></small></h4>
	</div>
	<div id="create-customer" style="position: relative; left: 40px; height: 35px;">
		新建客户：<%=company%>
	</div>
	<div id="create-contact" style="position: relative; left: 40px; height: 35px;">
		新建联系人：<%=fullname%><%=appellation%>
	</div>
	<div id="create-transaction1" style="position: relative; left: 40px; height: 35px; top: 25px;">
		<input type="checkbox" id="isCreateTransaction"/>
		为客户创建交易
	</div>
	<div id="create-transaction2" style="position: relative; left: 40px; top: 20px; width: 80%; background-color: #F7F7F7; display: none;" >

		<form>
		  <div class="form-group" style="width: 400px; position: relative; left: 20px;">
		    <label for="amountOfMoney">金额</label>
		    <input type="text" class="form-control" id="amountOfMoney">
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="tradeName">交易名称</label>
		    <input type="text" class="form-control" id="tradeName" value="动力节点-">
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="expectedClosingDate">预计成交日期</label>
		    <input type="text" class="form-control" id="expectedClosingDate">
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="stage">阶段</label>
		    <select id="stage"  class="form-control">
		    	<option></option>
		    	<option>资质审查</option>
		    	<option>需求分析</option>
		    	<option>价值建议</option>
		    	<option>确定决策者</option>
		    	<option>提案/报价</option>
		    	<option>谈判/复审</option>
		    	<option>成交</option>
		    	<option>丢失的线索</option>
		    	<option>因竞争丢失关闭</option>
		    </select>
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="activity">市场活动源&nbsp;&nbsp;<a href="javascript:void(0);" data-toggle="modal" data-target="#searchActivityModal" style="text-decoration: none;"><span class="glyphicon glyphicon-search"></span></a></label>
		    <input type="text" class="form-control" id="activity" placeholder="点击上面搜索" readonly>
		  </div>
		</form>

	</div>

	<div id="owner" style="position: relative; left: 40px; height: 35px; top: 50px;">
		记录的所有者：<br>
		<b><%=owner%></b>
	</div>--%>

	<!-- 直接使用EL表达式内置对象param铺值 -->
	<!--
		EL表达式提供了多个内置对象，但是只有xxxScope系列（pageScope、requestScope、sessionScope、applicationScope）的域对象可以省略，
		其它所有的内置对象（包括pageContext）一概不能省略，如果省略，会变成从这些域对象中搜索值
	-->
	<div id="title" class="page-header" style="position: relative; left: 20px;">
		<h4>转换线索 <small>${param.fullname}${param.appellation}-${param.company}</small></h4>
	</div>
	<div id="create-customer" style="position: relative; left: 40px; height: 35px;">
		新建客户：${param.company}
	</div>
	<div id="create-contact" style="position: relative; left: 40px; height: 35px;">
		新建联系人：${param.fullname}${param.appellation}
	</div>
	<div id="create-transaction1" style="position: relative; left: 40px; height: 35px; top: 25px;">
		<input type="checkbox" id="isCreateTransaction"/>
		为客户创建交易
	</div>
	<div id="create-transaction2" style="position: relative; left: 40px; top: 20px; width: 80%; background-color: #F7F7F7; display: none;" >
		<!--
			提交表单产生的结果：
				workbench/clue/convert.do?clueId=xxx&money=xxx&name=xxx&expectedDate=xxx&stage=xxx&activityId=xxx&flag=a
		-->
		<form id="tranForm" action="workbench/clue/convert.do" method="post">

			<!-- 使用隐藏域保存是否需要创建交易的标记 -->
			<input type="hidden" name="flag" value="a">

			<!-- 使用隐藏域保存需要创建交易时的clueId -->
			<input type="hidden" name="clueId" value="${param.id}">

		  <div class="form-group" style="width: 400px; position: relative; left: 20px;">
		    <label for="amountOfMoney">金额</label>
		    <input type="text" class="form-control" id="amountOfMoney" name="money">
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="tradeName">交易名称</label>
		    <input type="text" class="form-control" id="tradeName" name="name">
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="expectedClosingDate">预计成交日期</label>
		    <input type="text" class="form-control time" id="expectedClosingDate" name="expectedDate" readonly>
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="stage">阶段</label>
		    <select id="stage"  class="form-control" name="stage">
		    	<option></option>
				<!-- 使用数据字典填充阶段信息 -->
				<c:forEach items="${stageList}" var="stage">
					<option value="${stage.value}">${stage.text}</option>
				</c:forEach>
		    </select>
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="activityName">市场活动源&nbsp;&nbsp;<a href="javascript:void(0);" id="openSearchActivityModal" style="text-decoration: none;"><span class="glyphicon glyphicon-search"></span></a></label>
		    <input type="text" class="form-control" id="activityName" placeholder="点击上面搜索" readonly>
			<input type="hidden" id="activityId" name="activityId">
		  </div>
		</form>

	</div>

	<div id="owner" style="position: relative; left: 40px; height: 35px; top: 50px;">
		记录的所有者：<br>
		<b>${param.owner}</b>
	</div>
	<div id="operation" style="position: relative; left: 40px; height: 35px; top: 100px;">
		<input class="btn btn-primary" type="button"  id="convertBtn" value="转换">
		&nbsp;&nbsp;&nbsp;&nbsp;
		<input class="btn btn-default" type="button" id="cancelBtn" value="取消">
	</div>
</body>
</html>