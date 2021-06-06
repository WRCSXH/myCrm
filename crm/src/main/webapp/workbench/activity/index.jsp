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

        // 自定义函数pageList()，用于分页查询+条件查询
        /*
                对于所有的关系型数据库，与前端分页操作相关的基本属性就是pageNo和pageSize
                    pageNo：页码，即第几页
                    pageSize：每页展示的记录条数

                pageList()函数：
                    用于发送ajax请求到后台，从后台取得最新的市场活动列表的数据，
                    通过响应回来的数据，局部刷新市场活动列表

                我们需要在哪些情况下调用pageList()函数，即什么情况下需要刷新一下市场活动列表？
                    1、点击左侧菜单中的“市场活动”超链接时
                    2、创建、修改、删除市场活动后
                    3、点击查询按钮时
                    4、点击分页组件时

                以上为调用pageList()函数的六个路口，也就是说，在以上六个操作执行完毕之后，
                我们必须调用pageLis()函数，刷新市场活动列表

            */
        function pageList(pageNo,pageSize) {

            // 每次刷新页面前都要将全选的复选框的勾干掉
            $("#qx").prop("checked",false);

            // 发送ajax请求之前，将隐藏域中保存的信息取出来，重新赋值给搜索框
            /*
                这样做确保了只有点击查询按钮，市场活动列表才会更新，
                   不点击查询按钮，市场活动列表则展示上一次的查询结果
               */
            $("#search-name").val($.trim($("#hidden-name").val()));
            $("#search-owner").val($.trim($("#hidden-owner").val()));
            $("#search-startDate").val($.trim($("#hidden-startDate").val()));
            $("#search-endDate").val($.trim($("#hidden-endDate").val()));

            // 发送ajax请求，查询市场活动列表并展示
            $.ajax({
                url:"workbench/activity/pageList.do",
                type:"get",
                data:{
                    "pageNo":pageNo,
                    "pageSize":pageSize,
                    "name": $.trim($("#search-name").val()),
                    "owner": $.trim($("#search-owner").val()),
                    "startDate": $.trim($("#search-startDate").val()),
                    "endDate": $.trim($("#search-endDate").val()),
                },
                dataType:"json",
                success:function(result) {
                    /*
                         result = {"total":总的记录条数,"dataList":[{市场活动1},{市场活动2}...]}
                     */
                    var html = "";
                    $.each(result.dataList, function (index, element) {
                        html += '<tr class="active">';
                        html += '<td><input type="checkbox" name="xz" value="' + element.id + '" /></td>';
                        html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/activity/detail.do?id='+element.id+'\';">' + element.name + '</a></td>';
                        html += '<td>' + element.owner + '</td>';
                        html += '<td>' + element.startDate + '</td>';
                        html += '<td>' + element.endDate + '</td>';
                        html += '</tr>';
                    })

                    $("#activityBody").html(html);

                    // 计算总页数
                    var totalPages = result.total%pageSize == 0 ? result.total/pageSize : parseInt(result.total/pageSize) + 1;

                    // 数据处理完毕后，结合分页插件，展示分页信息
                    $("#activityPage").bs_pagination({
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
                        onChangePage : function(event, data){
                            pageList(data.currentPage , data.rowsPerPage);
                        }
                    })
                }
            })
        }

        // 自定义函数：全选和取消全选
        function checked(){
            // 为全选的复选框绑定事件，触发全选操作
            $("#qx").click(function () {
                // jQuery的属性过滤选择器：标签名[属性名=属性值]表示选中含有 特定属性 且 该属性的值固定 的标签
                // this.checked，表示当前jQuery对象，即$("#qx")的checked属性的值 true or false
                $("input[name=xz]").prop("checked",this.checked);
            })

            // 为单选的复选框绑定事件，当单选框全部选中时，全选框选中
            /*
                以下这种写法错误
                    $("input[name=xz]").click(function () {
                        $("#qx").prop("checked",this.checked);
                    })
                因为动态生成的元素，不能以普通绑定事件的方式操作

                动态生成的元素，我们要以on()方法的方式操作
                语法如下：
                $(需要绑定元素的静态外层元素).on(绑定事件的方式,需要绑定元素的jQuery对象,回调函数)
            */
            $("#activityBody").on("click",$("input[name=xz]"),function () {

                /*
                    jQuery的prop()函数，设置指定属性的指定值，作用类似于attr()函数，
                    用法：jQuery对象.prop("指定属性名",指定属性值)
                */

                /*
                    attr()实际上是对html元素上的属性进行设置或者获取，
                    而prop()是对我们用js/jQuery获取到的dom对象的属性进行设置或者获取
                    例如：
                        $("#qx").attr("checked","checked"); 设置的是 "checked" (字符型)
    　　				$("#qx").prop("checked",true); 设置的是 true (布尔型)
                */

                // jQuery对象本质上是一个dom数组，所以有length属性
                // input[name=xz]:checked，在属性过滤选择器的基础上再加一个表单属性过滤器

                /*
                     $("input[name=xz]").length == $("input[name=xz]:checked").length，
                    这段代码返回一个布尔值，true or false
                */
                $("#qx").prop("checked",$("input[name=xz]").length == $("input[name=xz]:checked").length);
            })
        }

        $(function(){

            // 引入bootstrap日历控件
            $(".time").datetimepicker({
                minView: "month",
                language:  'zh-CN',
                format: 'yyyy-mm-dd',
                autoclose: true,
                todayBtn: true,
                pickerPosition: "bottom-left"
            });

            /*
             点击左侧菜单中的“市场活动”超链接，页面加载完毕后，触发pageList()函数，
             默认展示市场活动列表的第一页，每一页两条记录
             */
            pageList(1,10);

            // 全选和取消全选
            checked();

            // 为创建按钮绑定事件，打开创建市场活动的模态窗口
            $("#createBtn").click(function () {
                /*
                操作模态窗口的方式：
                    需要操作模态窗口的jQuery对象，调用modal()函数，为该函数传递string参数："show"或者"hide"
                        "show"表示打开模态窗口
                        "hide"表示关闭模态窗口
                 */
                // 使用js代码可以在打开模态窗口之前执行其它操作
                // alert(123);
                // $("#createActivityModal").modal("show");

                // 打开模态窗口之前，先走后台，为“所有者”下拉列表框铺值
                $.ajax({
                    url:"workbench/activity/getUserList.do",
                    // 登录、增删改使用post请求，其它使用get请求
                    type:"get",
                    dataType:"json",
                    success:function (result) {
                        /*
                        result接收json数组：[{用户1},{2},{3}...]
                         */
                        var html = "";
                        // 循环遍历数组，index表示数组下标，element表示数组中的元素
                        $.each(result,function (index,element) {
                            // 给用户展示的是用户姓名，option标签中存的值是用户id，代表整条用户记录
                            // 不能使用append()函数添加option标签，会使记录重复
                            // $("#create-marketActivityOwner").append("<option value='"+element.id+"'>"+element.name+"</option>");
                            // 只能拼字符串
                            html += "<option value='"+element.id+"'>"+element.name+"</option>";
                        })

                        // 将字符串填入select标签中
                        $("#create-owner").html(html);

                        // 将当前用户的姓名设置为所有者下拉列表框的默认值，这个过程属于ajax请求中的一部分
                        /*
                        模板：
                            <select>
                                <option value='"+element.id+"'>"+element.name+"</option>
                            </select>
                            $("#create-marketActivityOwner").val("element.id")
                         */
                        // 获取当前用户的id，在js中可以使用EL表达式，但是要用""括起来
                        $("#create-owner").val("${user.id}");
                    }
                })

                // 铺完值，再打开模态窗口
                $("#createActivityModal").modal("show");
            })

            // 为保存按钮绑定事件，创建市场活动
            $("#saveBtn").click(function () {
                $.ajax({
                    url:"workbench/activity/save.do",
                    type:"post",
                    data:{
                        "owner":$.trim($("#create-owner").val()),
                        "name":$.trim($("#create-name").val()),
                        "startDate":$.trim($("#create-startDate").val()),
                        "endDate":$.trim($("#create-endDate").val()),
                        "cost":$.trim($("#create-cost").val()),
                        "description":$.trim($("#create-description").val())
                    },
                    dataType:"json",
                    success:function(result){
                        /*
                            result{"isSuccess":true/false}
                         */
                        if (result.isSuccess){
                            // 创建市场活动成功后
                            // 刷新市场活动列表（局部刷新）
                            /*
                                $("#activityPage").bs_pagination('getOption', 'currentPage')
                                    操作后停留在当前页
                                $("#activityPage").bs_pagination('getOption', 'rowsPerPage')
                                    操作后维持已经设置好的每页展现的记录数
                                这两个参数不需要我们进行任何的修改操作，直接使用即可
                            */

                            // 做完创建操作后，应该回到第一页，因为要展现最新创建的市场活动，维持每页展现的记录数
                            pageList(1,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));

                            // 清空创建市场活动的模态窗口
                            /*
                                注意：
                                    当我们拿到form表单的jQuery对象时，
                                    jQuery库提供了submit()方法让我们提交表单
                                    $("#activityAddForm").submit();
                                    但是没有提供reset()方法让我们重置表单
                                    （坑：idea为我们提示了bootstrap框架中的reset()方法）

                                    虽然jQuery库没有为我们提供reset()方法，
                                    但是原生js为我们提供了reset()方法，
                                    所以我们要将jQuery对象转换成原生js中的dom对象

                                    jQuery对象转换为dom对象
                                        jQuery对象[数组下标]
                                    dom对象转换为jQuery对象
                                        $(dom对象)
                             */
                            $("#activityCreateForm")[0].reset();

                            // 关闭创建市场活动的模态窗口
                            $("#createActivityModal").modal("hide");
                        } else {
                            alert("创建市场活动失败！");
                        }
                    }
                })
            })

            // 为修改按钮绑定事件，打开修改市场活动的模态窗口
            $("#editBtn").click(function () {
                // 找到挑勾的复选框的jQuery对象
                var $cxz = $("input[name=xz]:checked");
                if ($cxz.length == 0){
                    alert("请选择需要修改的记录！");
                } else if ($cxz.length > 1){
                    alert("一次只能修改一条记录！")
                } else {
                    // 肯定只有一个挑勾的复选框，拿到这个复选框对应记录的id
                    var id = $cxz.val();

                    // 发送ajax请求，为下拉列表框和选中的记录铺值
                    $.ajax({
                        url:"workbench/activity/getUserListAndActivity.do",
                        type:"get",
                        data:{
                            // 根据id选中记录
                            "id":id
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
                            $("#edit-id").val(result.activity.id);
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
                }
            })

            /*
                在实际项目开发中，一定是按照先做添加，再做修改的顺序，
                所以为了节省开发时间，修改操作一般都是复制添加操作
            */
            // 为更新按钮绑定事件，修改市场活动
            $("#updateBtn").click(function () {
                $.ajax({
                    url:"workbench/activity/update.do",
                    type:"post",
                    data:{
                        "id":$.trim($("#edit-id").val()),
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
                            // 刷新市场活动列表（局部刷新）
                            // 做完修改操作后，应该维持在当前页，因为要展现刚刚修改的市场活动，维持每页展现的记录数
                            pageList($("#activityPage").bs_pagination('getOption', 'currentPage')
                                ,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));

                            // 关闭修改市场活动的模态窗口
                            $("#editActivityModal").modal("hide");
                        } else {
                            alert("修改市场活动失败！");
                        }
                    }
                })

            })

            // 为删除按钮绑定事件，删除市场活动
            $("#deleteBtn").click(function () {

                // 找到挑勾的复选框的jQuery对象
                var $cxz = $("input[name=xz]:checked");
                if($cxz.length == 0){
                    alert("请选择需要删除的记录！");
                } else if (confirm("确定删除选中的所有记录吗？")){
                    // 肯定选了，有可能是一条，有可能是多条
                    // url:workbench/activity/delete.do?id=xxx&id=xxx&id=xxx

                    // 拼接参数
                    var param = "";
                    // 将$cxz中的每一个dom对象遍历出来，取其value值，就相当于取得了需要被删除的记录的id
                    for (var i = 0;i < $cxz.length;i++){

                        param += "id="+$($cxz[i]).val();

                        // 如果不是最后一个元素，需要在后面追加一个&符
                        if(i < $cxz.length-1){
                            param += "&";
                        }
                    }

                    // 发送ajax请求
                    $.ajax({
                        url:"workbench/activity/delete.do",
                        type:"post",
                        data:param,
                        dataType:"json",
                        success:function(result){
                            if (result.isSuccess){
                                // result{"isSuccess":true/false}

                                // 做完删除操作后，应该回到第一页，因为要展现删除市场活动后最新的市场活动，维持每页展现的记录数
                                pageList(1,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
                            } else {
                                alert("删除市场活动失败！");
                            }
                        }
                    })
                }
            })

            // 为查询按钮绑定事件，触发pageList()函数
            $("#searchBtn").click(function () {

                // 每一次点击查询按钮之后，我们都应该将搜索框中的信息保存到隐藏域中
                $("#hidden-name").val($.trim($("#search-name").val()));
                $("#hidden-owner").val($.trim($("#search-owner").val()));
                $("#hidden-startDate").val($.trim($("#search-startDate").val()));
                $("#hidden-endDate").val($.trim($("#search-endDate").val()));

                // 做完查询操作后，应该回到第一页，因为要展现条件查询后最新的市场活动，维持每页展现的记录数
                pageList(1,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
            })
        });

    </script>
</head>
<body>
<!-- 使用隐藏域保存搜索框中的信息 -->
<input type="hidden" id="hidden-name" />
<input type="hidden" id="hidden-owner" />
<input type="hidden" id="hidden-startDate" />
<input type="hidden" id="hidden-endDate" />

<!-- 创建市场活动的模态窗口 -->
<div class="modal fade" id="createActivityModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
            </div>
            <div class="modal-body">

                <form id="activityCreateForm" class="form-horizontal" role="form">

                    <div class="form-group">
                        <label for="create-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-owner">
                            </select>
                        </div>
                        <label for="create-name" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-name">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-startDate" class="col-sm-2 control-label">开始日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <!--
                                css样式中一个标签同时属于多个类
                                class="类1 类2 类3" 类与类之间用空格隔开
                            -->
                            <input type="text" class="form-control time" id="create-startDate" readonly>
                        </div>
                        <label for="create-endDate" class="col-sm-2 control-label">结束日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control time" id="create-endDate" readonly>
                        </div>
                    </div>
                    <div class="form-group">

                        <label for="create-cost" class="col-sm-2 control-label">成本</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-cost">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="create-description" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="create-description"></textarea>
                        </div>
                    </div>

                </form>

            </div>
            <div class="modal-footer">
                <!--
                    data-dismiss="modal" 表示关闭模态窗口
                -->
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="saveBtn">保存</button>
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
                    <!-- 使用隐藏域保存被选中记录的id，这个字段由开发人员操作，不对用户公开，用于识别需要被修改的市场活动 -->
                    <input type="hidden" id="edit-id">
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
                            <input type="text" class="form-control time" id="edit-startDate" readonly>
                        </div>
                        <label for="edit-endDate" class="col-sm-2 control-label">结束日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control time" id="edit-endDate" readonly>
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
                            <!--
                                关于文本域textarea：
                                （1）一定要以标签对的形式来呈现，正常状态下标签对要紧紧地挨着
                                （2）textarea虽然是以标签对的形式来呈现的，但是它也属于表单元素范畴
                                我们对于textarea所有的取值和赋值操作，应该统一使用val()方法，而不是html()方法
                            -->
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

<!-- 标题 -->
<div>
    <div style="position: relative; left: 10px; top: -10px;">
        <div class="page-header">
            <h3>市场活动列表</h3>
        </div>
    </div>
</div>

<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
    <div style="width: 100%; position: absolute;top: 5px; left: 10px;">

        <!-- 搜索框 -->
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
                        <div class="input-group-addon">开始日期</div>
                        <input class="form-control time" type="text" id="search-startDate" readonly>
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">结束日期</div>
                        <input class="form-control time" type="text" id="search-endDate" readonly>
                    </div>
                </div>

                <button type="button" class="btn btn-default" id="searchBtn">查询</button>

            </form>
        </div>

        <!-- 创建、修改、删除按钮 -->
        <div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
            <div class="btn-group" style="position: relative; top: 18%;">
                <!--
                    点击创建按钮，观察两个属性和属性值

                    data-toggle="modal"
                        表示点击该按钮，打开一个模态窗口

                    data-target="#createActivityModal"
                        表示要打开哪个模态窗口，通过#id的形式找到该窗口

                    现在我们是以属性和属性值的形式写入button元素中，用来打开模态窗口，
                    但是这样做是有问题的：
                        问题在于没有办法对按钮的功能进行扩充

                    所以在未来的实际项目开发中，对于触发模态窗口的操作，一定不要写死在元素中
                    应该由我们自己来写js代码来操作

                    关于id的命名约定
                        create/add：跳转到添加页，或者打开执行添加操作的模态窗口
                        save：执行添加操作
                        edit：跳转到修改页，或者打开执行修改操作的模态窗口
                        update：执行修改操作
                        search：执行查询操作，或者是get/find/select/query。。。
                        特殊操作，如login
                -->
                <button type="button" class="btn btn-primary" id="createBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
                <button type="button" class="btn btn-default" id="editBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
                <button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
            </div>
        </div>

        <!-- 市场活动列表 -->
        <div style="position: relative;top: 10px;">
            <table class="table table-hover">
                <!--表头-->
                <thead>
                <tr style="color: #B3B3B3;">
                    <td><input type="checkbox" id="qx" /></td>
                    <td>名称</td>
                    <td>所有者</td>
                    <td>开始日期</td>
                    <td>结束日期</td>
                </tr>
                </thead>

                <!--表体-->
                <tbody id="activityBody"></tbody>

            </table>
        </div>

        <!-- 分页插件 -->
        <div style="height: 50px; position: relative;top: 30px;">

            <div id="activityPage"></div>

        </div>

    </div>

</div>
</body>
</html>
