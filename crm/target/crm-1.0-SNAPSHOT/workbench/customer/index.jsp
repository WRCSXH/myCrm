<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
%>
<!DOCTYPE html>
<html>
<head>
    <base href="<%=basePath%>">
    <meta charset="UTF-8">

    <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet"/>
    <link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet"/>

    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
    <link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css">
    <script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
    <script type="text/javascript" src="jquery/bs_pagination/en.js"></script>

    <script type="text/javascript">

        function pageList(pageNo, pageSize) {
            $("#qx").prop("checked", false);

            $("#search-name").val($.trim($("#hidden-name").val()));
            $("#search-owner").val($.trim($("#hidden-owner").val()));
            $("#search-phone").val($.trim($("#hidden-phone").val()));
            $("#search-website").val($.trim($("#hidden-website").val()));

            $.ajax({
                url: "workbench/customer/pageList.do",
                type: "get",
                data: {
                    "pageNo": pageNo,
                    "pageSize": pageSize,
                    "name": $.trim($("#search-name").val()),
                    "owner": $.trim($("#search-owner").val()),
                    "phone": $.trim($("#search-phone").val()),
                    "website": $.trim($("#search-website").val()),
                },
                dataType: "json",
                success: function (result) {
                    /*
                         result = {"total":总的记录条数,"dataList":[{客户1},{2},{3}...]}
                     */
                    var html = "";
                    $.each(result.dataList, function (index, element) {
                        html += '<tr>';
                        html += '<td><input type="checkbox" name="xz" value="' + element.id + '"/></td>';
                        html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/customer/detail.do?id=' + element.id + '\';">' + element.name + '</a></td>';
                        html += '<td>' + element.owner + '</td>';
                        html += '<td>' + element.phone + '</td>';
                        html += '<td>' + element.website + '</td>';
                        html += '</tr>';
                    })

                    $("#customerBody").html(html);

                    // 计算总页数
                    var totalPages = result.total % pageSize == 0 ? result.total / pageSize : parseInt(result.total / pageSize) + 1;

                    // 数据处理完毕后，结合分页插件，展示分页信息
                    $("#customerPage").bs_pagination({
                        currentPage: pageNo, // 页码
                        rowsPerPage: pageSize, // 每页显示的记录条数
                        maxRowsPerPage: 20, // 每页最多显示的记录条数
                        totalPages: totalPages, // 总页数
                        totalRows: result.total, // 总记录条数
                        visiblePageLinks: 3, // 显示几个卡片
                        showGoToPage: true,
                        showRowsPerPage: true,
                        showRowsInfo: true,
                        showRowsDefaultInfo: true,

                        // 该回调函数，在点击分页插件时触发
                        onChangePage: function (event, data) {
                            pageList(data.currentPage, data.rowsPerPage);
                        }
                    })
                }
            })
        }

        function checked() {
            $("#qx").click(function () {
                $("input[name=xz]").prop("checked", this.checked);
            })

            $("#customerBody").on("click", $("input[name=xz]"), function () {
                $("#qx").prop("checked", $("input[name=xz]").length == $("input[name=xz]:checked").length);
            })
        }

        $(function () {

            // 引入bootstrap日历控件
            $(".time").datetimepicker({
                minView: "month",
                language: 'zh-CN',
                format: 'yyyy-mm-dd',
                autoclose: true,
                todayBtn: true,
                pickerPosition: "top-left"
            });

            //定制字段
            $("#definedColumns > li").click(function (e) {
                //防止下拉菜单消失
                e.stopPropagation();
            });

            pageList(1,10);

            checked();

            // 为创建按钮绑定事件，打开添加客户的模态窗口
            $("#createBtn").click(function () {
                // 发送ajax请求，为所有者下拉框铺值
                $.ajax({
                    url: "workbench/customer/getUserList.do",
                    type: "get",
                    dataType: "json",
                    success: function (result) {
                        // result[{用户1}，{2}，{3}]
                        var html = "";
                        $.each(result, function (index, element) {
                            html += "<option value='" + element.id + "'>" + element.name + "</option>"
                        })
                        $("#create-owner").html(html);
                        // 选择当前用户作为所有者下拉框的默认选项
                        $("#create-owner").val("${user.id}");
                    }
                })
                // 铺完值，再打开模态窗口
                $("#createCustomerModal").modal("show");
            })

            // 为保存按钮绑定事件，添加客户
            $("#saveBtn").click(function () {
                $.ajax({
                    url: "workbench/customer/save.do",
                    type: "post",
                    data: {
                        "owner": $.trim($("#create-owner").val()),
                        "name": $.trim($("#create-name").val()),
                        "website": $.trim($("#create-website").val()),
                        "phone": $.trim($("#create-phone").val()),
                        "description": $.trim($("#create-description").val()),
                        "contactSummary": $.trim($("#create-contactSummary").val()),
                        "nextContactTime": $.trim($("#create-nextContactTime").val()),
                        "address": $.trim($("#create-address").val())
                    },
                    dataType: "json",
                    success: function (result) {
                        // result{"isSuccess":true/false}
                        if (result.isSuccess) {
                            // 添加客户成功后
                            // 刷新客户列表
                            pageList(1, $("#customerPage").bs_pagination('getOption', 'rowsPerPage'));
                            // 清空添加客户的模态窗口
                            $("#customerCreateForm")[0].reset();
                            // 关闭添加客户的模态窗口
                            $("#createCustomerModal").modal("hide");
                        } else {
                            alert("添加客户失败！");
                        }
                    }
                })
            })

            // 为修改按钮绑定事件，打开修改客户的模态窗口
            $("#editBtn").click(function () {

                var $cxz = $("input[name=xz]:checked");

                if ($cxz.length == 0) {
                    alert("请选择需要修改的记录！");
                } else if ($cxz.length > 1) {
                    alert("一次只能修改一条记录！");
                } else {
                    $.ajax({
                        url: "workbench/customer/getUserListAndCustomer.do",
                        type: "get",
                        data: {
                            "id": $cxz.val()
                        },
                        dataType: "json",
                        success: function (result) {
                            /*
                                result{"userList":[{用户1},{2},{3}],"customer":客户对象}
                            */
                            var html = "";
                            $.each(result.userList, function (index, element) {
                                html += '<option value="' + element.id + '">' + element.name + '</option>';
                            })
                            $("#edit-owner").html(html);

                            $("#edit-id").val(result.customer.id);
                            $("#edit-name").val(result.customer.name);
                            $("#edit-owner").val(result.customer.owner);
                            $("#edit-phone").val(result.customer.phone);
                            $("#edit-website").val(result.customer.website);
                            $("#edit-description").val(result.customer.description);
                            $("#edit-contactSummary").val(result.customer.contactSummary);
                            $("#edit-nextContactTime").val(result.customer.nextContactTime);
                            $("#edit-address").val(result.customer.address);
                        }
                    })

                    $("#editCustomerModal").modal("show");
                }
            })

            // 为更新按钮绑定事件，修改客户
            $("#updateBtn").click(function () {
                $.ajax({
                    url: "workbench/customer/update.do",
                    type: "post",
                    data: {
                        "id": $.trim($("#edit-id").val()),
                        "name": $.trim($("#edit-name").val()),
                        "owner": $.trim($("#edit-owner").val()),
                        "phone": $.trim($("#edit-phone").val()),
                        "website": $.trim($("#edit-website").val()),
                        "description": $.trim($("#edit-description").val()),
                        "contactSummary": $.trim($("#edit-contactSummary").val()),
                        "nextContactTime": $.trim($("#edit-nextContactTime").val()),
                        "address": $.trim($("#edit-address").val())
                    },
                    dataType: "json",
                    success: function (result) {
                        // result{"isSuccess":true/false}
                        if (result.isSuccess) {
                            pageList($("#customerPage").bs_pagination('getOption', 'currentPage')
                                , $("#customerPage").bs_pagination('getOption', 'rowsPerPage'));
                            $("#editCustomerModal").modal("hide");
                        } else {
                            alert("修改客户失败！");
                        }
                    }
                })
            })

            // 为删除按钮绑定事件，删除线索
            $("#deleteBtn").click(function () {
                var $cxz = $("input[name=xz]:checked");
                if ($cxz.length == 0) {
                    alert("请选择需要删除的记录！");
                } else if (confirm("确定删除选中的所有记录吗？")) {
                    var param = "";
                    for (var i = 0; i < $cxz.length; i++) {
                        param += "id=" + $($cxz[i]).val();
                        if (i < $cxz.length - 1) {
                            param += "&";
                        }
                    }

                    $.ajax({
                        url: "workbench/customer/delete.do",
                        type: "post",
                        data: param,
                        dataType: "json",
                        success: function (result) {
                            // result{"isSuccess":true/false}
                            if (result.isSuccess) {
                                pageList(1, $("#customerPage").bs_pagination('getOption', 'rowsPerPage'));
                            } else {
                                alert("删除线索失败！");
                            }
                        }
                    })
                }
            })

            // 为查询按钮绑定事件
            $("#searchBtn").click(function () {

                $("#hidden-name").val($.trim($("#search-name").val()));
                $("#hidden-phone").val($.trim($("#search-phone").val()));
                $("#hidden-owner").val($.trim($("#search-owner").val()));
                $("#hidden-website").val($.trim($("#search-website").val()));

                pageList(1, $("#customerPage").bs_pagination('getOption', 'rowsPerPage'));
            })
        });
    </script>
</head>
<body>

<!-- 使用隐藏域保存搜索框中的信息 -->
<input type="hidden" id="hidden-name" />
<input type="hidden" id="hidden-phone" />
<input type="hidden" id="hidden-owner" />
<input type="hidden" id="hidden-website" />
<!-- 创建客户的模态窗口 -->
<div class="modal fade" id="createCustomerModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel1">创建客户</h4>
            </div>
            <div class="modal-body">
                <form id="customerCreateForm" class="form-horizontal" role="form">

                    <div class="form-group">
                        <label for="create-owner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-owner">
                            </select>
                        </div>
                        <label for="create-name" class="col-sm-2 control-label">名称<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-name">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-website" class="col-sm-2 control-label">公司网站</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-website">
                        </div>
                        <label for="create-phone" class="col-sm-2 control-label">公司座机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-phone">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="create-description" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="create-description"></textarea>
                        </div>
                    </div>
                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                    <div style="position: relative;top: 15px;">
                        <div class="form-group">
                            <label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control time" id="create-nextContactTime" readonly>
                            </div>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                    <div style="position: relative;top: 20px;">
                        <div class="form-group">
                            <label for="create-address" class="col-sm-2 control-label">详细地址</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="1" id="create-address"></textarea>
                            </div>
                        </div>
                    </div>
                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="saveBtn">保存</button>
            </div>
        </div>
    </div>
</div>

<!-- 修改客户的模态窗口 -->
<div class="modal fade" id="editCustomerModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">修改客户</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form">
                    <input type="hidden" id="edit-id">
                    <div class="form-group">
                        <label for="edit-owner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-owner">
                            </select>
                        </div>
                        <label for="edit-name" class="col-sm-2 control-label">名称<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-name" >
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-website" class="col-sm-2 control-label">公司网站</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-website">
                        </div>
                        <label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-phone">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-description" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="edit-description"></textarea>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                    <div style="position: relative;top: 15px;">
                        <div class="form-group">
                            <label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="edit-contactSummary"></textarea>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-nextContactTime">
                            </div>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                    <div style="position: relative;top: 20px;">
                        <div class="form-group">
                            <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="1" id="edit-address"></textarea>
                            </div>
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


<div>
    <div style="position: relative; left: 10px; top: -10px;">
        <div class="page-header">
            <h3>客户列表</h3>
        </div>
    </div>
</div>

<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">

    <div style="width: 100%; position: absolute;top: 5px; left: 10px;">

        <div class="btn-toolbar" role="toolbar" style="height: 80px;">
            <form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">名称</div>
                        <input class="form-control" type="text" id="search-name">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">所有者</div>
                        <input class="form-control" type="text" id="search-owner">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">公司座机</div>
                        <input class="form-control" type="text" id="search-phone">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">公司网站</div>
                        <input class="form-control" type="text" id="search-website">
                    </div>
                </div>

                <button type="button" class="btn btn-default" id="searchBtn">查询</button>

            </form>
        </div>
        <div class="btn-toolbar" role="toolbar"
             style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
            <div class="btn-group" style="position: relative; top: 18%;">
                <button type="button" class="btn btn-primary" id="createBtn"><span class="glyphicon glyphicon-plus"></span> 创建
                </button>
                <button type="button" class="btn btn-default" id="editBtn"><span class="glyphicon glyphicon-pencil"></span> 修改
                </button>
                <button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
            </div>

        </div>

        <!--客户列表-->
        <div style="position: relative;top: 10px;">
            <table class="table table-hover">

                <!--表头-->
                <thead>
                <tr style="color: #B3B3B3;">
                    <td><input type="checkbox" id="qx"/></td>
                    <td>名称</td>
                    <td>所有者</td>
                    <td>公司座机</td>
                    <td>公司网站</td>
                </tr>
                </thead>

                <!--表体-->
                <tbody id="customerBody"></tbody>

            </table>
        </div>

        <!--分页插件-->
        <div style="height: 50px; position: relative;top: 30px;">

            <div id="customerPage"></div>

        </div>

    </div>

</div>
</body>
</html>