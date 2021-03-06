<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
<link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css">
<script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
<script type="text/javascript" src="jquery/bs_pagination/en.js"></script>

<script type="text/javascript">
	function pageList(pageNo,pageSize){
		$("#qx").prop("checked",false);

		$("#search-fullname").val($.trim($("#hidden-fullname").val()));
		$("#search-company").val($.trim($("#hidden-company").val()));
		$("#search-phone").val($.trim($("#hidden-phone").val()));
		$("#search-source").val($.trim($("#hidden-source").val()));
		$("#search-owner").val($.trim($("#hidden-owner").val()));
		$("#search-mphone").val($.trim($("#hidden-mphone").val()));
		$("#search-state").val($.trim($("#hidden-state").val()));

		$.ajax({
			url:"workbench/clue/pageList.do",
			type:"get",
			data:{
				"pageNo":pageNo,
				"pageSize":pageSize,
				"fullname": $.trim($("#search-fullname").val()),
				"company": $.trim($("#search-company").val()),
				"phone":$.trim($("#search-phone").val()),
				"source":$.trim($("#search-source").val()),
				"owner":$.trim($("#search-owner").val()),
				"mphone":$.trim($("#search-mphone").val()),
				"state": $.trim($("#search-state").val())
			},
			dataType:"json",
			success:function(result){
				/*
				 	result = {"total":??????????????????,"dataList":[{??????1},{??????2}...]}
				 */
				var html = "";
				$.each(result.dataList,function (index,element) {
					html += '<tr>';
					html += '<td><input type="checkbox" name="xz" value="'+element.id+'"/></td>';
					html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/clue/detail.do?id='+element.id+'\';">'+element.fullname+'</a></td>';
					html += '<td>'+element.company+'</td>';
					html += '<td>'+element.phone+'</td>';
					html += '<td>'+element.mphone+'</td>';
					html += '<td>'+element.source+'</td>';
					html += '<td>'+element.owner+'</td>';
					html += '<td>'+element.state+'</td>';
					html += '</tr>';
				})

				$("#clueBody").html(html);

				// ???????????????
				var totalPages = result.total % pageSize == 0 ? result.total/pageSize : parseInt(result.total/pageSize)+1;

				// ???????????????????????????????????????????????????????????????
				$("#cluePage").bs_pagination({
					currentPage: pageNo, // ??????
					rowsPerPage: pageSize, // ???????????????????????????
					maxRowsPerPage: 20, // ?????????????????????????????????
					totalPages: totalPages, // ?????????
					totalRows: result.total, // ???????????????
					visiblePageLinks: 3, // ??????????????????
					showGoToPage: true,
					showRowsPerPage: true,
					showRowsInfo: true,
					showRowsDefaultInfo: true,

					// ????????????????????????????????????????????????
					onChangePage : function(event, data){
						pageList(data.currentPage , data.rowsPerPage);
					}
				})
			}
		})
	}

	function checked(){
		$("#qx").click(function () {
			$("input[name=xz]").prop("checked",this.checked);
		})

		$("#clueBody").on("click",$("input[name=xz]"),function () {
			$("#qx").prop("checked",$("input[name=xz]").length==$("input[name=xz]:checked").length);
		})
	}

	$(function(){

		// ??????bootstrap????????????
		$(".time").datetimepicker({
			minView: "month",
			language:  'zh-CN',
			format: 'yyyy-mm-dd',
			autoclose: true,
			todayBtn: true,
			pickerPosition: "top-left"
		});

		pageList(1,10);

		checked();

		// ???????????????????????????????????????????????????????????????
		$("#createBtn").click(function () {
			// ??????ajax????????????????????????????????????
			$.ajax({
				url:"workbench/clue/getUserList.do",
				type:"get",
				dataType:"json",
				success:function(result) {
					// result[{??????1}???{2}???{3}]
					var html = "";
					$.each(result, function (index, element) {
						html += "<option value='" + element.id + "'>" + element.name + "</option>"
					})
					$("#create-owner").html(html);
					// ?????????????????????????????????????????????????????????
					$("#create-owner").val("${user.id}");
				}
			})
			// ?????????????????????????????????
			$("#createClueModal").modal("show");
		})

		// ??????????????????????????????????????????
		$("#saveBtn").click(function () {
			$.ajax({
				url:"workbench/clue/save.do",
				type:"post",
				data:{
					"fullname":$.trim($("#create-fullname").val()),
					"appellation":$.trim($("#create-appellation").val()),
					"owner":$.trim($("#create-owner").val()),
					"company":$.trim($("#create-company").val()),
					"job":$.trim($("#create-job").val()),
					"email":$.trim($("#create-email").val()),
					"phone":$.trim($("#create-phone").val()),
					"website":$.trim($("#create-website").val()),
					"mphone":$.trim($("#create-mphone").val()),
					"state":$.trim($("#create-state").val()),
					"source":$.trim($("#create-source").val()),
					"description":$.trim($("#create-description").val()),
					"contactSummary":$.trim($("#create-contactSummary").val()),
					"nextContactTime":$.trim($("#create-nextContactTime").val()),
					"address":$.trim($("#create-address").val())
				},
				dataType:"json",
				success:function(result){
					// result{"isSuccess":true/false}
					if (result.isSuccess){
						// ?????????????????????
						// ??????????????????
						pageList(1,$("#cluePage").bs_pagination('getOption', 'rowsPerPage'));
						// ?????????????????????????????????
						$("#clueCreateForm")[0].reset();
						// ?????????????????????????????????
						$("#createClueModal").modal("hide");
					} else {
						alert("?????????????????????");
					}
				}
			})
		})

		// ???????????????????????????????????????????????????????????????
		$("#editBtn").click(function () {

			var $cxz = $("input[name=xz]:checked");

			if ($cxz.length == 0){
				alert("?????????????????????????????????");
			} else if($cxz.length > 1){
				alert("?????????????????????????????????");
			} else {
				$.ajax({
					url:"workbench/clue/getUserListAndClue.do",
					type:"get",
					data:{
						"id":$cxz.val()
					},
					dataType:"json",
					success:function(result){
						/*
							result{"userList":[{??????1},{2},{3}],"clue":????????????}
						*/
						var html = "";
						$.each(result.userList,function (index,element) {
							html += '<option value="'+element.id+'">'+element.name+'</option>';
						})
						$("#edit-owner").html(html);

						$("#edit-id").val(result.clue.id);
						$("#edit-fullname").val(result.clue.fullname);
						$("#edit-appellation").val(result.clue.appellation);
						$("#edit-owner").val(result.clue.owner);
						$("#edit-company").val(result.clue.company);
						$("#edit-job").val(result.clue.job);
						$("#edit-email").val(result.clue.email);
						$("#edit-phone").val(result.clue.phone);
						$("#edit-website").val(result.clue.website);
						$("#edit-mphone").val(result.clue.mphone);
						$("#edit-state").val(result.clue.state);
						$("#edit-source").val(result.clue.source);
						$("#edit-description").val(result.clue.description);
						$("#edit-contactSummary").val(result.clue.contactSummary);
						$("#edit-nextContactTime").val(result.clue.nextContactTime);
						$("#edit-address").val(result.clue.address);
					}
				})

				$("#editClueModal").modal("show");
			}
		})

		// ??????????????????????????????????????????
		$("#updateBtn").click(function () {
			$.ajax({
				url:"workbench/clue/update.do",
				type:"post",
				data:{
					"id":$.trim($("#edit-id").val()),
					"fullname":$.trim($("#edit-fullname").val()),
					"appellation":$.trim($("#edit-appellation").val()),
					"owner":$.trim($("#edit-owner").val()),
					"company":$.trim($("#edit-company").val()),
					"job":$.trim($("#edit-job").val()),
					"email":$.trim($("#edit-email").val()),
					"phone":$.trim($("#edit-phone").val()),
					"website":$.trim($("#edit-website").val()),
					"mphone":$.trim($("#edit-mphone").val()),
					"state":$.trim($("#edit-state").val()),
					"source":$.trim($("#edit-source").val()),
					"description":$.trim($("#edit-description").val()),
					"contactSummary":$.trim($("#edit-contactSummary").val()),
					"nextContactTime":$.trim($("#edit-nextContactTime").val()),
					"address":$.trim($("#edit-address").val())
				},
				dataType:"json",
				success:function(result){
					// result{"isSuccess":true/false}
					if (result.isSuccess){
						pageList($("#cluePage").bs_pagination('getOption', 'currentPage')
								,$("#cluePage").bs_pagination('getOption', 'rowsPerPage'));
						$("#editClueModal").modal("hide");
					} else {
						alert("?????????????????????");
					}
				}
			})
		})

		// ??????????????????????????????????????????
		$("#deleteBtn").click(function () {
			var $cxz = $("input[name=xz]:checked");
			if ($cxz.length == 0){
				alert("?????????????????????????????????");
			} else if (confirm("???????????????????????????????????????")){
				var param = "";
				for(var i=0;i<$cxz.length;i++){
					param += "id="+$($cxz[i]).val();
					if (i<$cxz.length-1){
						param += "&";
					}
				}

				$.ajax({
					url:"workbench/clue/delete.do",
					type:"post",
					data:param,
					dataType:"json",
					success:function (result) {
						// result{"isSuccess":true/false}
						if (result.isSuccess){
							pageList(1,$("#cluePage").bs_pagination('getOption', 'rowsPerPage'));
						} else {
							alert("?????????????????????");
						}
					}
				})
			}
		})

		// ???????????????????????????
		$("#searchBtn").click(function () {

			$("#hidden-fullname").val($.trim($("#search-fullname").val()));
			$("#hidden-company").val($.trim($("#search-company").val()));
			$("#hidden-phone").val($.trim($("#search-phone").val()));
			$("#hidden-source").val($.trim($("#search-source").val()));
			$("#hidden-owner").val($.trim($("#search-owner").val()));
			$("#hidden-mphone").val($.trim($("#search-mphone").val()));
			$("#hidden-state").val($.trim($("#search-state").val()));

			pageList(1,$("#cluePage").bs_pagination('getOption', 'rowsPerPage'));
		})
	});

</script>
</head>
<body>

<!-- ?????????????????????????????????????????? -->
<input type="hidden" id="hidden-fullname" />
<input type="hidden" id="hidden-company" />
<input type="hidden" id="hidden-phone" />
<input type="hidden" id="hidden-source" />
<input type="hidden" id="hidden-owner" />
<input type="hidden" id="hidden-mphone" />
<input type="hidden" id="hidden-state" />

	<!-- ??????????????????????????? -->
	<div class="modal fade" id="createClueModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">??</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">????????????</h4>
				</div>
				<div class="modal-body">
					<form  id="clueCreateForm" class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="create-owner" class="col-sm-2 control-label">?????????<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-owner">
								</select>
							</div>
							<label for="create-company" class="col-sm-2 control-label">??????<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-company">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-appellation" class="col-sm-2 control-label">??????</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-appellation">
									<option></option>
									<c:forEach items="${appellationList}" var="appellation">
										<option value="${appellation.value}">${appellation.text}</option>
									</c:forEach>
								</select>
							</div>
							<label for="create-fullname" class="col-sm-2 control-label">??????<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-fullname">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-job" class="col-sm-2 control-label">??????</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-job">
							</div>
							<label for="create-email" class="col-sm-2 control-label">??????</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-email">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-phone" class="col-sm-2 control-label">????????????</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-phone">
							</div>
							<label for="create-website" class="col-sm-2 control-label">????????????</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-website">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-mphone" class="col-sm-2 control-label">??????</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-mphone">
							</div>
							<label for="create-state" class="col-sm-2 control-label">????????????</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-state">
									<option></option>
									<c:forEach items="${clueStateList}" var="clueState">
										<option value="${clueState.value}">${clueState.text}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-source" class="col-sm-2 control-label">????????????</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-source">
									<option></option>
									<c:forEach items="${sourceList}" var="source">
										<option value="${source.value}">${source.text}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						

						<div class="form-group">
							<label for="create-description" class="col-sm-2 control-label">????????????</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-description"></textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="create-contactSummary" class="col-sm-2 control-label">????????????</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="create-nextContactTime" class="col-sm-2 control-label">??????????????????</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control time" id="create-nextContactTime" readonly>
								</div>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>
						
						<div style="position: relative;top: 20px;">
							<div class="form-group">
                                <label for="create-address" class="col-sm-2 control-label">????????????</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="create-address"></textarea>
                                </div>
							</div>
						</div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">??????</button>
					<button type="button" class="btn btn-primary" id="saveBtn">??????</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- ??????????????????????????? -->
	<div class="modal fade" id="editClueModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">??</span>
					</button>
					<h4 class="modal-title">????????????</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
						<input type="hidden" id="edit-id">
						<div class="form-group">
							<label for="edit-owner" class="col-sm-2 control-label">?????????<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-owner"></select>
							</div>
							<label for="edit-company" class="col-sm-2 control-label">??????<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-company">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-appellation" class="col-sm-2 control-label">??????</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-appellation">
								  <option></option>
								  <c:forEach items="${appellationList}" var="appellation">
									  <option value="${appellation.value}">${appellation.text}</option>
								  </c:forEach>
								</select>
							</div>
							<label for="edit-fullname" class="col-sm-2 control-label">??????<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-fullname">
							</div>
						</div>
						<div class="form-group">
							<label for="edit-job" class="col-sm-2 control-label">??????</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-job">
							</div>
							<label for="edit-email" class="col-sm-2 control-label">??????</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-email">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-phone" class="col-sm-2 control-label">????????????</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-phone">
							</div>
							<label for="edit-website" class="col-sm-2 control-label">????????????</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-website">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-mphone" class="col-sm-2 control-label">??????</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-mphone">
							</div>
							<label for="edit-state" class="col-sm-2 control-label">????????????</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-state">
								  <option></option>
									<c:forEach items="${clueStateList}" var="clueState">
										<option value="${clueState.value}">${clueState.text}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-source" class="col-sm-2 control-label">????????????</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-source">
								  <option></option>
								  <c:forEach items="${sourceList}" var="source">
									  <option value="${source.value}">${source.text}</option>
								  </c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-description" class="col-sm-2 control-label">??????</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-description"></textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="edit-contactSummary" class="col-sm-2 control-label">????????????</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="edit-contactSummary"></textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="edit-nextContactTime" class="col-sm-2 control-label">??????????????????</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control time" id="edit-nextContactTime" readonly>
								</div>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="edit-address" class="col-sm-2 control-label">????????????</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="edit-address"></textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">??????</button>
					<button type="button" class="btn btn-primary" data-dismiss="modal" id="updateBtn">??????</button>
				</div>
			</div>
		</div>
	</div>




	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>????????????</h3>
			</div>
		</div>
	</div>
	
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
	
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
			<!--????????????-->
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">??????</div>
				      <input class="form-control" type="text" id="search-fullname">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">??????</div>
				      <input class="form-control" type="text" id="search-company">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">????????????</div>
				      <input class="form-control" type="text" id="search-phone">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">????????????</div>
					  <select class="form-control" id="search-source">
					  	  <option></option>
					  	  <c:forEach items="${sourceList}" var="source">
							  <option value="${source.value}">${source.text}</option>
						  </c:forEach>
					  </select>
				    </div>
				  </div>
				  
				  <br>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">?????????</div>
				      <input class="form-control" type="text" id="search-owner">
				    </div>
				  </div>
				  
				  
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">??????</div>
				      <input class="form-control" type="text" id="search-mphone">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">????????????</div>
					  <select class="form-control" id="search-state">
					  	<option></option>
						  <c:forEach items="${clueStateList}" var="clueState">
							  <option value="${clueState.value}">${clueState.text}</option>
						  </c:forEach>
					  </select>
				    </div>
				  </div>

				  <button type="button" class="btn btn-default" id="searchBtn">??????</button>
				  
				</form>
			</div>
			<!--??????-->
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 40px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="createBtn"><span class="glyphicon glyphicon-plus"></span> ??????</button>
				  <button type="button" class="btn btn-default" id="editBtn"><span class="glyphicon glyphicon-pencil"></span> ??????</button>
				  <button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> ??????</button>
				</div>
			</div>
			<!--????????????-->
			<div style="position: relative;top: 50px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="qx" /></td>
							<td>??????</td>
							<td>??????</td>
							<td>????????????</td>
							<td>??????</td>
							<td>????????????</td>
							<td>?????????</td>
							<td>????????????</td>
						</tr>
					</thead>
					<tbody id="clueBody"></tbody>
				</table>
			</div>
			<!--??????-->
			<div style="height: 50px; position: relative;top: 60px;">
				<div id="cluePage"></div>
			</div>
			
		</div>
		
	</div>
</body>
</html>