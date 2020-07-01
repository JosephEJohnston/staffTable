<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib uri ="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!-- 旧的分页实现 -->
<html lang="zh-CN">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <title>员工列表</title>
        <%
            pageContext.setAttribute("APP_PATH", request.getContextPath());
        %>

        <!-- web 路径：
                不以 / 开始的相对路径：
                    找资源，以当前资源的路径为基准，经常容易出问题
                以 / 开始的相对路径：
                    找资源，以服务器的路径为标准：
                        http://localhost:80/03staff/(注意，与 tomcat 的 url 配置有关）
        -->
        <!-- 引入 bootstrap，需要 jquery -->
        <script type="text/javascript" src="${APP_PATH}/static/js/jquery-3.4.1.min.js" ></script>
        <!-- 缺了 rel 就没有样式 -->
        <link href="${APP_PATH}/static/css/bootstrap.min.css" rel="stylesheet"/>
        <script type="text/javascript" src="${APP_PATH}/static/js/bootstrap.min.js" ></script>
    </head>
    <body>
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
                    <button class="btn btn-primary">新增</button>
                    <button class="btn btn-danger">删除</button>
                </div>
            </div>
            <!-- 显示表格数据 -->
            <div class="row">
                <div class="col-md-12">
                    <table class="table table-hover">
                        <tr>
                            <th>id</th>
                            <th>名字</th>
                            <th>性别</th>
                            <th>email</th>
                            <th>所在部门</th>
                            <th>操作</th>
                        </tr>
                        <!-- 取出数据库中所有的元素 -->
                        <c:forEach items="${pageInfo.list}" var="emp">
                            <tr>
                                <th>${emp.empId}</th>
                                <th>${emp.empName}</th>
                                <th>${emp.gender == "M" ? "男" : "女"}</th>
                                <th>${emp.email}</th>
                                <th>${emp.department.deptName}</th>
                                <th>
                                    <!--
                                        btn-primary：按钮颜色
                                        btn-sm：按钮大小
                                    -->
                                    <button class="btn btn-primary btn-sm">
                                        <!-- 这个 span 内装的是图标 -->
                                        <span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>
                                        编辑
                                    </button>
                                    <button class="btn btn-danger btn-sm">
                                        <span class="glyphicon glyphicon-trash" aria-hidden="true"></span>
                                        删除
                                    </button>
                                </th>
                            </tr>
                        </c:forEach>
                    </table>
                </div>
            </div>
            <!-- 显示分页信息 -->
            <div class="row">
                <!-- 分页文字信息 -->
                <div class="col-md-6">
                    当前 ${pageInfo.pageNum} 页，共 ${pageInfo.pages} 页，共 ${pageInfo.total} 条记录
                </div>
                <!-- 分页条 -->
                <div class="col-md-6">
                    <nav aria-label="Page navigation">
                        <ul class="pagination">
                            <li><a href="${APP_PATH}/emps?pn=1">首页</a></li>
                            <!-- 在某页有上一页时，显示向前按钮 -->
                            <c:if test="${pageInfo.hasPreviousPage}">
                                <li>
                                    <a href="${APP_PATH}/emps?pn=${pageInfo.pageNum - 1}" aria-label="Previous">
                                        <span aria-hidden="true">&laquo;</span>
                                    </a>
                                </li>
                            </c:if>

                            <c:forEach items="${pageInfo.navigatepageNums}" var="iterPage">
                                <!-- 若当前迭代页与所在页相同，在分页条高亮此页 -->
                                <c:if test="${iterPage == pageInfo.pageNum}">
                                    <li class="active"><a href="#">${iterPage}</a></li>
                                </c:if>
                                <!-- 若当前迭代页与所在页不同，链接指向迭代页 -->
                                <c:if test="${iterPage != pageInfo.pageNum}">
                                    <li><a href="${APP_PATH}/emps?pn=${iterPage}">${iterPage}</a></li>
                                </c:if>

                            </c:forEach>
                            <!-- 在某页有下一页时，显示向后按钮 -->
                            <c:if test="${pageInfo.hasNextPage}">
                                <li>
                                    <a href="${APP_PATH}/emps?pn=${pageInfo.pageNum + 1}" aria-label="Next">
                                        <span aria-hidden="true">&raquo;</span>
                                    </a>
                                </li>
                            </c:if>
                            <li><a href="${APP_PATH}/emps?pn=${pageInfo.pages}">末页</a></li>
                        </ul>
                    </nav>
                </div>
            </div>
        </div>
    </body>
</html>
