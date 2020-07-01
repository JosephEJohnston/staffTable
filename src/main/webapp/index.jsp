<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib uri ="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html lang="zh-CN">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <title>员工列表</title>
        <%
            pageContext.setAttribute("APP_PATH", request.getContextPath());
        %>

        <!-- 引入 bootstrap，需要 jquery -->
        <script type="text/javascript" src="${APP_PATH}/static/js/jquery-3.4.1.min.js" ></script>
        <!-- 缺了 rel 就没有样式 -->
        <link href="${APP_PATH}/static/css/bootstrap.min.css" rel="stylesheet"/>
        <script type="text/javascript" src="${APP_PATH}/static/js/bootstrap.min.js" ></script>
    </head>
    <body>
        <!-- 模态框（员工修改） -->
        <!-- 里面多数是复制粘贴的 -->
        <div id="empUpdateModal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                        <h4 class="modal-title">员工修改</h4>
                    </div>
                    <div class="modal-body">
                        <form class="form-horizontal">
                            <!-- 姓名组 -->
                            <div class="form-group">
                                <label for="empName_add_input" class="col-sm-2 control-label">员工姓名</label>
                                <div class="col-sm-10">
                                    <!-- 静态显示员工姓名 -->
                                    <p class="form-control-static" id="empName_update_static"></p>
                                </div>
                            </div>
                            <!-- 电子邮件组 -->
                            <div class="form-group">
                                <label for="email_add_input" class="col-sm-2 control-label">电子邮件</label>
                                <div class="col-sm-10">
                                    <input type="text" class="form-control" name="email" id="email_update_input" placeholder="请输入电子邮件">

                                    <!-- 输入后的提示信息 -->
                                    <span class="help-block"></span>
                                </div>
                            </div>
                            <!-- 性别组 -->
                            <div class="form-group">
                                <label class="col-sm-2 control-label">性别</label>
                                <div class="col-sm-10">
                                    <label class="radio-inline">
                                        <input type="radio" name="gender" id="gender1_update_input" value="M" checked="checked"> 男
                                    </label>
                                    <label class="radio-inline">
                                        <input type="radio" name="gender" id="gender2_update_input" value="F"> 女
                                    </label>
                                </div>
                            </div>
                            <!-- 部门组（提交部门 id），下拉列表 -->
                            <div class="form-group">
                                <label class="col-sm-2 control-label">部门</label>
                                <div class="col-sm-4">
                                    <select class="form-control" name="dId" id="dept_update_select"></select>
                                </div>
                            </div>
                        </form>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                        <button type="button" class="btn btn-primary" id="emp_update_btn">更新</button>
                    </div>
                </div>
            </div>
        </div>


        <!-- 模态框（员工添加） -->
        <!-- 里面多数是复制粘贴的 -->
        <div id="empAddModal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                        <h4 class="modal-title" id="myModalLabel">员工添加</h4>
                    </div>
                    <div class="modal-body">
                        <form class="form-horizontal">
                            <!-- 姓名组 -->
                            <div class="form-group">
                                <label for="empName_add_input" class="col-sm-2 control-label">员工姓名</label>
                                <div class="col-sm-10">
                                    <input type="text" class="form-control" name="empName" id="empName_add_input" placeholder="请输入姓名">

                                    <!-- 输入后的提示信息 -->
                                    <span class="help-block"></span>
                                </div>
                            </div>
                            <!-- 电子邮件组 -->
                            <div class="form-group">
                                <label for="email_add_input" class="col-sm-2 control-label">电子邮件</label>
                                <div class="col-sm-10">
                                    <input type="text" class="form-control" name="email" id="email_add_input" placeholder="请输入电子邮件">

                                    <!-- 输入后的提示信息 -->
                                    <span class="help-block"></span>
                                </div>
                            </div>
                            <!-- 性别组 -->
                            <div class="form-group">
                                <label class="col-sm-2 control-label">性别</label>
                                <div class="col-sm-10">
                                    <label class="radio-inline">
                                        <input type="radio" name="gender" id="gender1_add_input" value="M" checked="checked"> 男
                                    </label>
                                    <label class="radio-inline">
                                        <input type="radio" name="gender" id="gender2_add_input" value="F"> 女
                                    </label>
                                </div>
                            </div>
                            <!-- 部门组（提交部门 id），下拉列表 -->
                            <div class="form-group">
                                <label class="col-sm-2 control-label">部门</label>
                                <div class="col-sm-4">
                                    <select class="form-control" name="dId" id="dept_add_select"></select>
                                </div>
                            </div>
                        </form>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                        <button type="button" class="btn btn-primary" id="emp_save_btn">保存</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- 搭建显示页面 -->
        <div class="container">
            <!-- 一共分为四行 -->
            <!-- 标题 -->
            <div class="row">
                <!-- 占 12 列 -->
                <div class="col-md-12">萌新项目</div>
            </div>
            <!-- 按钮 -->
            <div class="row">
                <div class="col-md-4 col-md-offset-8">
                    <button class="btn btn-primary" id="emp_add_Modal_btn">新增</button>
                    <button class="btn btn-danger" id="emp_delete_all_btn">删除</button>
                </div>
            </div>
            <!-- 显示表格数据 -->
            <div class="row">
                <div class="col-md-12">
                    <table class="table table-hover" id="emps_table">
                        <thead>
                            <tr>
                                <!-- 勾选框 -->
                                <th>
                                    <input type="checkbox" id="check_all"/>
                                </th>

                                <th>id</th>
                                <th>名字</th>
                                <th>性别</th>
                                <th>email</th>
                                <th>所在部门</th>
                                <th>操作</th>
                            </tr>
                        </thead>
                        <!-- 在其中装入员工信息 -->
                        <tbody>
                        </tbody>

                    </table>
                </div>
            </div>
            <!-- 显示分页信息 -->
            <div class="row">
                <!-- 分页文字信息 -->
                <!-- 信息由构建函数导入 -->
                <div class="col-md-6" id="page_info_area"></div>
                <!-- 分页条 -->
                <!-- 信息由构建函数导入 -->
                <div class="col-md-6" id="page_nav_area"></div>
            </div>
        </div>

        <script type="text/javascript">
            var totalRecord, currentPage;

            //1. 页面加载完成以后，直接去发送一个 ajax 请求，要到分页数据
            $(function () {
                //去首页
                to_page(1);
            });

            function to_page(pn) {
                $.ajax({
                    url:"${APP_PATH}/emps",
                    data:"pn=" + pn,
                    type:"GET",
                    //回调函数
                    success:function (result) {
                        //在控制台中打印数据
                        //console.log(result);

                        //1. 在页面解析并显示员工数据
                        build_emps_table(result);

                        //2. 解析并显示分页信息
                        build_page_info(result);

                        //3. 构建导航条
                        build_page_nav(result);
                    }
                });
            }

            //构建员工表
            function build_emps_table(result) {
                //清空 table 表格
                $("#emps_table tbody").empty();
                //list 中装载着员工数据
                var emps = result.extend.pageInfo.list;

                //遍历员工数据
                $.each(emps, function(index, item) {
                    //构建员工行
                    var checkBoxTd = $("<td><input type='checkbox' class='check_item'/></td>");
                    var empIdTd = $("<td></td>").append(item.empId);
                    var empNameTd = $("<td></td>").append(item.empName);
                    var genderTd = $("<td></td>").append(item.gender == 'M' ? "男" : "女");
                    var emailTd = $("<td></td>").append(item.email);
                    var deptNameTd = $("<td></td>").append(item.department.deptName);

                    //创建员工表时，生成两个按钮
                    var editBtn = $("<button></button>").addClass("btn btn-primary btn-sm edit_btn")
                        .append($("<span></span>").addClass("glyphicon glyphicon-pencil")).append("编辑");
                    //为编辑按钮添加一个自定义的属性，来表示当前员工的 id
                    editBtn.attr("edit-id", item.empId);
                    var delBtn = $("<button></button>").addClass("btn btn-danger btn-sm delete_btn")
                        .append($("<span></span>").addClass("glyphicon glyphicon-trash")).append("删除")
                    //为删除按钮添加一个自定义的属性来表示当前删除的员工 id
                    delBtn.attr("del-id", item.empId);
                    //两个按钮置于一行
                    var btnTd = $("<td></td>").append(editBtn).append(" ").append(delBtn);

                    //append 方法执行完成后，还是返回原来的元素
                    $("<tr></tr>").append(checkBoxTd)
                        .append(empIdTd)
                        .append(empNameTd)
                        .append(genderTd)
                        .append(emailTd)
                        .append(deptNameTd)
                        .append(btnTd)
                        .appendTo("#emps_table tbody");
                });
            }

            //构建分页信息
            function build_page_info(result) {
                //先清空分页信息
                $("#page_info_area").empty();
                $("#page_info_area").append("当前 " + result.extend.pageInfo.pageNum +
                    " 页，共 " + result.extend.pageInfo.pages +
                    " 页，共 " + result.extend.pageInfo.total + " 条记录");
                totalRecord = result.extend.pageInfo.total;
                currentPage = result.extend.pageInfo.pageNum;
            }

            //构建导航条，点击分页能够跳转
            function build_page_nav(result) {
                //清空导航条
                $("#page_nav_area").empty();

                //配置到前一页的按钮
                var ul = $("<ul></ul>").addClass("pagination");
                var firstPageLi = $("<li></li>").append($("<a></a>").append("首页").attr("href", "#"));
                var prePageLi = $("<li></li>").append($("<a></a>").append("&laquo;"));
                //若没有前一页，设置按钮禁用
                if (result.extend.pageInfo.hasPreviousPage == false) {
                    firstPageLi.addClass("disabled");
                    prePageLi.addClass("disabled");
                    //分页合理化配置在 mybatis-config 的插件配置中
                } else {
                    //为元素添加翻页的事件
                    firstPageLi.click(function () {
                        to_page(1);
                    });
                    prePageLi.click(function () {
                        to_page(result.extend.pageInfo.pageNum - 1);
                    });
                }

                var lastPageLi = $("<li></li>").append($("<a></a>").append("末页").attr("href", "#"));
                var nextPageLi = $("<li></li>").append($("<a></a>").append("&raquo;"));
                if (result.extend.pageInfo.hasNextPage == false) {
                    lastPageLi.addClass("disabled");
                    nextPageLi.addClass("disabled");
                } else {
                    lastPageLi.click(function () {
                        to_page(result.extend.pageInfo.pages);
                    });
                    nextPageLi.click(function () {
                        to_page(result.extend.pageInfo.pageNum + 1);
                    });
                }

                //添加首页和前一页的提示
                ul.append(firstPageLi).append(prePageLi);
                //遍历页码号
                $.each(result.extend.pageInfo.navigatepageNums, function (index, item) {
                    var numLi = $("<li></li>").append($("<a></a>").append(item));
                    if(result.extend.pageInfo.pageNum == item) {
                        numLi.addClass("active");
                    }
                    numLi.click(function () {
                        //点击时到对应的页
                        to_page(item);
                    });
                    ul.append(numLi);
                });
                //添加末页和后一页的提示
                ul.append(nextPageLi).append(lastPageLi);

                //把 ul 加入到 nav 标签中
                var navEle = $("<nav></nav>").append(ul);
                navEle.appendTo("#page_nav_area")
            }

            //清除表单数据（表单完整重置（表单数据和样式））
            function reset_form(ele) {
                $(ele)[0].reset();

                //清空表单样式
                $(ele).find("*").removeClass("has-error has-success");
                $(ele).find(".help-block").text("");
            }

            //点击新增按钮，弹出模态框
            $("#emp_add_Modal_btn").click(function () {
                //清除表单数据（表单完整重置（表单数据和样式））
                reset_form("#empAddModal form")
                // $("#empAddModal form")[0].reset();

                //发送 ajax 请求，查出部门信息，显示在下拉列表中
                getDepts("#empAddModal select");

                //弹出模态框
                $("#empAddModal").modal({
                    //点击框外面就不会收回去
                    backdrop:"static"
                });
            });

            //查出所有的部门信息，并显示在下拉列表中
            function getDepts(ele) {
                //清空之前下拉列表的值
                $(ele).empty();
                $.ajax({
                   url: "${APP_PATH}/depts",
                    type: "GET",
                    success:function (result) {
                       //部门信息
                       //console.log(result);

                        //显示信息在下拉列表中
                        // $("#dept_add_select").append("")
                        $.each(result.extend.depts, function () {
                            var optionEle = $("<option></option>").append(this.deptName).attr("value", this.deptId);
                            optionEle.appendTo(ele);
                        });
                    }
                });
            }

            //校验方法
            function validate_add_form() {
                //1. 拿到要校验的数据，使用正则表达式
                var empName = $("#empName_add_input").val();
                //允许字母，数字和中文
                var regName = /(^[a-zA-Z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]{2,5})/;

                if (!regName.test(empName)) {
                    // alert("用户名可以是 2-5 位中文或 6-16 位英文和数字的组合");
                    show_validate_msg("#empName_add_input", "error", "用户名可以是 2-5 位中文或 6-16 位英文和数字的组合");

                    return false;
                } else {
                    show_validate_msg("#empName_add_input", "success", "")
                };

                //2. 校验邮箱信息
                var email = $("#email_add_input").val();
                var regEmail = /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;

                if (!regEmail.test(email)) {
                    // alert("邮箱格式不正确");
                    //应该清空这个元素之前的样式
                    show_validate_msg("#email_add_input", "error", "邮箱格式不正确");
                    /*$("#email_add_input").parent().addClass("has-error");
                    $("#email_add_input").next("span").text("邮箱格式不正确");*/
                    return false;
                } else {
                    show_validate_msg("#email_add_input", "success", "");
                    /*$("#email_add_input").parent().addClass("has-success");
                    $("#email_add_input").next("span").text("");*/
                }

                return true;
            }

            //显示校验结果的提示信息
            function show_validate_msg(ele, status, msg) {
                //清楚当前元素的校验状态
                $(ele).parent().removeClass("has-success has-error");
                $(ele).next("span").text();
                if ("success" == status) {
                    $(ele).parent().addClass("has-success");
                    $(ele).next("span").text(msg);
                } else if("error" == status) {
                    $(ele).parent().addClass("has-error");
                    $(ele).next("span").text(msg);
                }
            }

            //用户名查重
            $("#empName_add_input").change(function () {
                //发送 ajax 请求，校验用户名是否可用
                let empName = this.value;
                $.ajax({
                   url:"${APP_PATH}/checkUser",
                    data:"empName=" + empName,
                    type:"POST",
                    success:function (result) {
                       if (result.code == 100) {
                           show_validate_msg("#empName_add_input", "success", "用户名可用");
                           $("#emp_save_btn").attr("ajax-va", "success");
                       } else {
                           show_validate_msg("#empName_add_input", "error", result.extend.va_msg);
                           $("#emp_save_btn").attr("ajax-va", "error");
                       }
                    }
                });
            });


            //点击保存，保存员工
            $("#emp_save_btn").click(function () {
                //1. 模态框中填写的表单数据提交给服务器进行保存
                //2. 先对要提交给服务器的数据进行校验
                if (!validate_add_form()) {
                    return false;
                };
                //3. 判断之前的 ajax 用户名校验是否成功
                //成功才往下继续
                if ($(this).attr("ajax-va") == "error") {
                    return false;
                }

                //4. 发送 ajax 请求，保存员工

                $.ajax({
                   url:"${APP_PATH}/emp",
                    type:"POST",
                    //将提交的表单数据序列化为 key 和 value 数据
                    data:$("#empAddModal form").serialize(),
                    success:function (result) {
                       // alert(result.msg);

                        if (result.code == 100) {
                            //员工保存成功：
                            //1. 关闭模态框
                            $("#empAddModal").modal('hide');
                            //2. 来到最后一页，显示刚才保存的数据
                            //发送 ajax 请求显示最后一页数据即可
                            to_page(totalRecord);
                        } else {
                             //显示失败信息
                             console.log();
                             //有哪个字段的错误信息就显示哪个字段的
                            if (undefined != result.extend.errorFields.email) {
                                //显示邮箱错误信息
                                show_validate_msg("#email_add_input", "error", result.extend.errorFields.email);
                            }
                            if (undefined != result.extend.errorFields.empName) {
                                //显示员工名字的错误信息
                                show_validate_msg("#empName_add_input", "error", result.extend.errorFields.empName);
                            }
                        }
                    }
                });
            });




            //1. 我们是按钮创建之前就绑定了 click，所以绑定不上
            //1）可以在创建按钮的时候绑定
            //2）绑定点击：live（）
            //jquery 新版没有 live，使用 on 进行替代
            /*$(".edit_btn").click(function () {
                alert("edit");
            });*/
            $(document).on("click", ".edit_btn", function () {
                // alert("edit");
                //1. 查出部门信息，并显示部门列表
                getDepts("#empUpdateModal select")

                //2. 查出员工信息，显示员工信息
                getEmp($(this).attr("edit-id"));

                //3. 把员工的 id 传递给模态框的更新按钮
                $("#emp_update_btn").attr("edit-id", $(this).attr("edit-id"));
                //弹出模态框
                $("#empUpdateModal").modal({
                    backdrop: "static"
                });
            });
            
            function getEmp(id) {
                $.ajax({
                    url:"${APP_PATH}/emp/" + id,
                    type:"GET",
                    success:function (result) {
                        // console.log(result);
                        var empData = result.extend.emp;
                        //拿出员工名字
                        $("#empName_update_static").text(empData.empName);
                        $("#email_update_input").val(empData.email);
                        $("#empUpdateModal input[name=gender]").val([empData.gender]);
                        $("#empUpdateModal select").val([empData.dId]);
                    }
                });
            }

            //点击更新，更新员工信息
            $("#emp_update_btn").click(function () {
                //验证邮箱是否合法
                //1. 校验邮箱信息
                var email = $("#email_update_input").val();
                var regEmail = /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;

                if (!regEmail.test(email)) {
                    //应该清空这个元素之前的样式
                    show_validate_msg("#email_update_input", "error", "邮箱格式不正确");
                    return false;
                } else {
                    show_validate_msg("#email_update_input", "success", "");
                }

                //2. 发送 ajax 请求保存更新的员工信息
                $.ajax({
                   url:"${APP_PATH}/emp/" + $(this).attr("edit-id"),
                    type:"PUT",
                    data:$("#empUpdateModal form").serialize(),
                    success:function (result) {
                       // alert(result.msg);
                        //1. 关闭对话框
                        $("#empUpdateModal").modal("hide");
                        //2. 回到本页面
                        to_page(currentPage);
                    }
                });
            });

            //单个删除
            $(document).on("click", ".delete_btn", function () {
                //1. 弹出是否确认删除对话框
                //td:eq(2)：第三个
                var empName = $(this).parents("tr").find("td:eq(2)").text();
                var empId = $(this).attr("del-id");

                if (confirm("确认删除" + empName + "吗？")) {
                    //确认，发送 ajax 请求，删除即可
                    $.ajax({
                       url:"${APP_PATH}/emp/" + empId,
                        type:"DELETE",
                        success:function (result) {
                           alert(result.msg);
                           //回到本页
                            to_page(currentPage);
                        }
                    });
                }
            });

            //完成全选/全不选功能
            $("#check_all").click(function () {
                //attr 获取 checked 是 undefined
                //我们这些 dom 原生的属性不建议用 attr 获取
                //用 attr 获取自定义的属性值
                //用 prop 来修改和读取 dom 原生属性的值
                $(this).prop("checked");
                $(".check_item").prop("checked", $(this).prop("checked"));
            });

            //check_item，单选框点击事件配置
            $(document).on("click", ".check_item", function () {
                //判断当前选中的元素是否选满了
                let flag = $(".check_item:checked").length == $(".check_item").length;
                $("#check_all").prop("checked", flag);
            })

            //点击全部删除，就批量删除
            $("#emp_delete_all_btn").click(function () {
                var empNames = "";
                var del_idstr = "";
                $.each($(".check_item:checked"), function () {
                    //要删除的员工姓名
                    empNames += $(this).parents("tr").find("td:eq(2)").text() + ", ";

                    //组装员工 id 字符串
                    del_idstr += $(this).parents("tr").find("td:eq(1)").text() + "-";
                });
                //去除 empNames 多余的逗号
                empNames = empNames.substring(0, empNames.length - 2);
                //删除字符串多于的“-”
                del_idstr = del_idstr.substring(0, del_idstr.length - 1);
                if (confirm("确认删除"+ empNames +"吗？")) {
                    //发送 ajax 请求删除
                    $.ajax({
                        url:"${APP_PATH}/emp/" + del_idstr,
                        type:"DELETE",
                        success:function (result) {
                            alert(result.msg);
                            //回到当前页面
                            to_page(currentPage);
                        }
                    });
                }
            });
        </script>
    </body>
</html>
