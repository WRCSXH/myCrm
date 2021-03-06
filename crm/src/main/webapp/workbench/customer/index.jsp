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
                         result = {"total":??????????????????,"dataList":[{??????1},{2},{3}...]}
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

                    // ???????????????
                    var totalPages = result.total % pageSize == 0 ? result.total / pageSize : parseInt(result.total / pageSize) + 1;

                    // ???????????????????????????????????????????????????????????????
                    $("#customerPage").bs_pagination({
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

            // ??????bootstrap????????????
            $(".time").datetimepicker({
                minView: "month",
                language: 'zh-CN',
                format: 'yyyy-mm-dd',
                autoclose: true,
                todayBtn: true,
                pickerPosition: "top-left"
            });

            //????????????
            $("#definedColumns > li").click(function (e) {
                //????????????????????????
                e.stopPropagation();
            });

            pageList(1,10);

            checked();

            // ???????????????????????????????????????????????????????????????
            $("#createBtn").click(function () {
                // ??????ajax????????????????????????????????????
                $.ajax({
                    url: "workbench/customer/getUserList.do",
                    type: "get",
                    dataType: "json",
                    success: function (result) {
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
                $("#createCustomerModal").modal("show");
            })

            // ??????????????????????????????????????????
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
                            // ?????????????????????
                            // ??????????????????
                            pageList(1, $("#customerPage").bs_pagination('getOption', 'rowsPerPage'));
                            // ?????????????????????????????????
                            $("#customerCreateForm")[0].reset();
                            // ?????????????????????????????????
                            $("#createCustomerModal").modal("hide");
                        } else {
                            alert("?????????????????????");
                        }
                    }
                })
            })

            // ???????????????????????????????????????????????????????????????
            $("#editBtn").click(function () {

                var $cxz = $("input[name=xz]:checked");

                if ($cxz.length == 0) {
                    alert("?????????????????????????????????");
                } else if ($cxz.length > 1) {
                    alert("?????????????????????????????????");
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
                                result{"userList":[{??????1},{2},{3}],"customer":????????????}
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

            // ??????????????????????????????????????????
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
                            alert("?????????????????????");
                        }
                    }
                })
            })

            // ??????????????????????????????????????????
            $("#deleteBtn").click(function () {
                var $cxz = $("input[name=xz]:checked");
                if ($cxz.length == 0) {
                    alert("?????????????????????????????????");
                } else if (confirm("???????????????????????????????????????")) {
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
                                alert("?????????????????????");
                            }
                        }
                    })
                }
            })

            // ???????????????????????????
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

<!-- ?????????????????????????????????????????? -->
<input type="hidden" id="hidden-name" />
<input type="hidden" id="hidden-phone" />
<input type="hidden" id="hidden-owner" />
<input type="hidden" id="hidden-website" />
<!-- ??????????????????????????? -->
<div class="modal fade" id="createCustomerModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">??</span>
                </button>
                <h4 class="modal-title" id="myModalLabel1">????????????</h4>
            </div>
            <div class="modal-body">
                <form id="customerCreateForm" class="form-horizontal" role="form">

                    <div class="form-group">
                        <label for="create-owner" class="col-sm-2 control-label">?????????<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-owner">
                            </select>
                        </div>
                        <label for="create-name" class="col-sm-2 control-label">??????<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-name">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-website" class="col-sm-2 control-label">????????????</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-website">
                        </div>
                        <label for="create-phone" class="col-sm-2 control-label">????????????</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-phone">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="create-description" class="col-sm-2 control-label">??????</label>
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
<div class="modal fade" id="editCustomerModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">??</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">????????????</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form">
                    <input type="hidden" id="edit-id">
                    <div class="form-group">
                        <label for="edit-owner" class="col-sm-2 control-label">?????????<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-owner">
                            </select>
                        </div>
                        <label for="edit-name" class="col-sm-2 control-label">??????<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-name" >
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-website" class="col-sm-2 control-label">????????????</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-website">
                        </div>
                        <label for="edit-phone" class="col-sm-2 control-label">????????????</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-phone">
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
                                <input type="text" class="form-control" id="edit-nextContactTime">
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
                <button type="button" class="btn btn-primary" id="updateBtn">??????</button>
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

        <div class="btn-toolbar" role="toolbar" style="height: 80px;">
            <form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">??????</div>
                        <input class="form-control" type="text" id="search-name">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">?????????</div>
                        <input class="form-control" type="text" id="search-owner">
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
                        <input class="form-control" type="text" id="search-website">
                    </div>
                </div>

                <button type="button" class="btn btn-default" id="searchBtn">??????</button>

            </form>
        </div>
        <div class="btn-toolbar" role="toolbar"
             style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
            <div class="btn-group" style="position: relative; top: 18%;">
                <button type="button" class="btn btn-primary" id="createBtn"><span class="glyphicon glyphicon-plus"></span> ??????
                </button>
                <button type="button" class="btn btn-default" id="editBtn"><span class="glyphicon glyphicon-pencil"></span> ??????
                </button>
                <button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> ??????</button>
            </div>

        </div>

        <!--????????????-->
        <div style="position: relative;top: 10px;">
            <table class="table table-hover">

                <!--??????-->
                <thead>
                <tr style="color: #B3B3B3;">
                    <td><input type="checkbox" id="qx"/></td>
                    <td>??????</td>
                    <td>?????????</td>
                    <td>????????????</td>
                    <td>????????????</td>
                </tr>
                </thead>

                <!--??????-->
                <tbody id="customerBody"></tbody>

            </table>
        </div>

        <!--????????????-->
        <div style="height: 50px; position: relative;top: 30px;">

            <div id="customerPage"></div>

        </div>

    </div>

</div>
</body>
</html>