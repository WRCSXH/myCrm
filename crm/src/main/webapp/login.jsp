<!-- 中文乱码过滤器不用过滤jsp文件，因为jsp文件自己过滤了响应体中的中文乱码-->
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
        $(function () {
        	// 让登录页面始终以顶层窗口的形式打开
        	if (window.top != window){
        		window.top.location = window.location;
			}
            // 页面加载完毕后，清空用户名文本框中的内容
            $("#loginAct").val("");

            // 页面加载完毕后，用户名文本框自动获得焦点
            /*
            关于jQuery中的focus()事件函数，
                无参focus()相当于原生js中的focus()函数，自动触发focus事件
                有参focus(function(){})相当于原生js中的onfocus属性，需要用户手动触发focus事件
            其它事件函数同理
           */
            $("#loginAct").focus();

            // 为登录按钮绑定登录事件，点击登录按钮登录
            $("#submitBtn").click(function () {
                // 多处使用的代码应该封装成函数
                // alert("执行登录操作！");
                login();
            })

            // 为当前窗口绑定敲键盘事件，敲回车键登录
            /*
                window是原生js中顶级bom对象，$(window)表示将window这个dom对象转换成jQuery对象，$(document)同理
            */
            // event参数可以获取用户敲击的键盘对象
            $(window).keydown(function (event) {
                // alert(event.keyCode);
                // 回车键键值：13
                if (event.keyCode == 13){
                    // alert("执行登录操作！");
                    login();
                }
            })
        })

        // 为了不影响bootstrap框架的使用，养成自定义function函数写在$(function(){})页面加载函数外面的习惯
        function login(){
            // alert("执行登录操作！");

            // $.trim()，去除字符串前后空白，删除用户的输入空格
            var loginAct = $.trim($("#loginAct").val());
            var loginPwd = $.trim($("#loginPwd").val());

            // 用户名和密码两个中有一个为空，返回错误提示信息，
            if (loginAct == ""||loginPwd == ""){
                $("#msg").html("账号密码不能为空！");
                // 并终止方法的执行，不再向浏览器发送ajax请求
                return;
            }

            // 程序能执行到此处，可以发送ajax请求与服务器交互
            $.ajax({
                // 请求地址，使用同级相对路径
                url: "settings/user/login.do",
                // 请求方式
                type:"post",
				// 请求参数
				data:{
                	"loginAct":loginAct,
					"loginPwd":loginPwd
				},
                // 结果数据类型
                dataType:"json",
				// 处理结果数据的函数，result是负责接收结果数据的参数
				success:function (result) {
					/*
					result可能接收的两种结果
						result={"isSuccess":true}
						result={"isSuccess":false,"errorMsg":"?"}
					 */
					if (result.isSuccess){
						// 跳转到工作台的欢迎页
						window.location.href = "workbench/index.jsp";
					} else {
						$("#msg").html(result.errorMsg);
					}
				}
            })
        }
    </script>
</head>
<body>
	<div style="position: absolute; top: 0px; left: 0px; width: 60%;">
		<img src="image/IMG_7114.JPG" style="width: 100%; height: 90%; position: relative; top: 50px;">
	</div>
	<div id="top" style="height: 50px; background-color: #3C3C3C; width: 100%;">
		<div style="position: absolute; top: 5px; left: 0px; font-size: 30px; font-weight: 400; color: white; font-family: 'times new roman'">CRM &nbsp;<span style="font-size: 12px;">&copy;2017&nbsp;动力节点</span></div>
	</div>
	
	<div style="position: absolute; top: 120px; right: 100px;width:450px;height:400px;border:1px solid #D5D5D5">
		<div style="position: absolute; top: 0px; right: 60px;">
			<div class="page-header">
				<h1>登录</h1>
			</div>
			<form action="workbench/index.jsp" class="form-horizontal" role="form">
				<div class="form-group form-group-lg">
					<div style="width: 350px;">
						<input class="form-control" type="text" id="loginAct" placeholder="用户名">
					</div>
					<div style="width: 350px; position: relative;top: 20px;">
						<input class="form-control" type="password" id="loginPwd" placeholder="密码">
					</div>
					<div class="checkbox"  style="position: relative;top: 30px; left: 10px;">
						
							<span id="msg" style="color: red"></span>
						
					</div>
                    <!--
                        button标签只要放在form标签中，type属性值就是submit，
                        为了达到点击登录按钮不提交表单的效果，同时不改变button标签的位置，维护原有UI界面，
                        把type属性值改成button即可
                    -->
					<button type="button" id="submitBtn" class="btn btn-primary btn-lg btn-block"  style="width: 350px; position: relative;top: 45px;">登录</button>
				</div>
			</form>
		</div>
	</div>
</body>
</html>