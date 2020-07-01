package com.noob.controller;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.noob.bean.Employee;
import com.noob.bean.ReturnJson;
import com.noob.service.EmployeeService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 处理员工 CRUD 请求
 */
@Controller
public class EmployeeController {

    @Autowired
    private EmployeeService employeeService;

    /**
     * 单个批量二合一
     * 批量删除：1-2-2
     * 单个删除：1
     * @return
     */
    //@PathVariable：获得路径占位符中的值
    @ResponseBody //处理 ajax 请求的注解
    @RequestMapping(value = "/emp/{ids}", method = RequestMethod.DELETE)
    private ReturnJson deleteEmp(@PathVariable("ids") String ids) {
        if (ids.contains("-")) {
            //批量删除
            List<Integer> del_ids = new ArrayList<>();
            String[] str_ids = ids.split("-");
            //组装 id 的集合
            for (String str_id : str_ids) {
                del_ids.add(Integer.parseInt(str_id));
            }
            employeeService.deleteBatch(del_ids);
        } else {
            //单个删除
            int id = Integer.parseInt(ids);
            employeeService.deleteEmp(id);
        }

        return ReturnJson.success();
    }

    /**
     * 如果直接发送 ajax=PUT 形式的请求
     * 封装的数据：
     *  id 不为空，其余全空
     *
     * 问题：
     *  请求体中有数据，但是 Employee 对象封装不上
     *  sql 语句有问题
     *
     * 原因：
     *  tomcat：
     *      1. 将请求体中的数据，封装一个 map
     *      2. request.getParameter("empName") 就会从这个 map 中取值
     *      3. SpringMVC 封装 POJO 对象的时候
     *          会把 POJO 中的每个属性的值，调用 request.getParameter() 得到
     *
     * ajax 送 put 请求引发的血案：
     *  put 请求，请求体中的数据 request.getParameter() 都拿不到
     *  tomcat 一看是 put，就不会封装请求体中的数据为 map
     *  只有 post 形式的请求才封装请求体为 map
     *
     * 在 org.apache.catalina.connector.Request;
     *  parseParameters（）方法（3111 行）
     *
     * protected String parseBodyMethods = "POST";
     * if (!getConnector().isParseBodyMethod(getMethod())) {
     *     success = true;
     *     return;
     * }
     *
     * 解决方案：
     * 我们要能支持直接发送 PUT 之类的请求
     *  还要能封装请求体的数据
     *  配置上 FormContentFilter
     *      作用：将请求体中的数据解析包装成一个 map
     *      request 被重新包装，request.getParameter（）被重写
     *          就会从自己封装的 map 中取数据
     * 员工更新方法
     * @param employee
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/emp/{empId}", method = RequestMethod.PUT)
    public ReturnJson saveEmp(Employee employee) {
        employeeService.updateEmp(employee);
        return ReturnJson.success();
    }

    /**
     * 根据 id 查询员工
     * @param id
     * @return
     */
    @RequestMapping(value = "/emp/{id}", method = RequestMethod.GET)
    @ResponseBody
    public ReturnJson getEmp(@PathVariable("id") Integer id) {
        Employee employee = employeeService.getEmp(id);
        return ReturnJson.success().add("emp", employee);
    }

    /**
     * 检查用户名是否可用
     * @param empName
     * @return
     */
    @ResponseBody
    @RequestMapping("/checkUser")
    public ReturnJson checkUser(@RequestParam("empName") String empName) {
        //先判断用户名是否是合法的表达式
        String regx = "(^[a-zA-Z0-9_-]{6,16}$)|(^[\\u2E80-\\u9FFF]{2,5})";
        if (!empName.matches(regx)) {
            return ReturnJson.fail().add("va_msg", "用户名必须是 2-5 位中文或 6-16 位英文和数字的组合");
        }

        //数据库用户名重复校验
        boolean b = employeeService.checkUser(empName);
        if (b) {
            return ReturnJson.success();
        } else {
            return ReturnJson.fail().add("va_msg", "用户名不可用");
        }
    }

    /**
     * 员工保存
     *  1. 支持 JSR303 校验
     *  2. 导入 Hibernate-Validator 包
     * @return
     */
    @RequestMapping(value = "/emp", method = RequestMethod.POST)
    @ResponseBody
    public ReturnJson saveEmp(@Valid Employee employee, BindingResult result) {
        //@Valid 注解：对信息进行合法性判断
        //BindingResult：封装结果

        if (result.hasErrors()) {
            Map<String, Object> map = new HashMap<>();

            //校验失败，应该返回失败，在模态框中显示校验失败的错误信息
            FieldError errors = result.getFieldError();
            System.out.println("错误的字段名：" + errors.getField());
            System.out.println("错误的信息：" + errors.getDefaultMessage());
            map.put(errors.getField(), errors.getDefaultMessage());

            return ReturnJson.fail().add("errorField", map);
        } else {
            employeeService.saveEmp(employee);
            return ReturnJson.success();
        }
    }

    /**
     * 导入 jackson 包，处理 json 字符串
     * @param pn
     * @return
     */
    //新的用来处理分页的方法
    @RequestMapping("/emps")
    @ResponseBody
    public ReturnJson getEmpsWithJson(
            @RequestParam(value = "pn", defaultValue = "1") Integer pn) {
        PageHelper.startPage(pn, 5);
        List<Employee> emps = employeeService.getAll();

        PageInfo page = new PageInfo(emps, 5);
        return ReturnJson.success().add("pageInfo", page);
    }
    /**
     * 查询员工数据（分页查询，旧）
     */
    //@RequestMapping("/emps")
    public String getEmps(@RequestParam(value = "pn", defaultValue = "1") Integer pn,
                          Model model) {
        //这不是一个分页查询
        //引入 PageHelper 分页插件

        //在查询之前只需要调用，传入页面/当前页面（pn），以及每页的大小（5）
        PageHelper.startPage(pn, 5);
        //startPage 后面紧跟的这个查询就是一个分页查询
        List<Employee> emps = employeeService.getAll();

        //使用 PageInfo 包装查询后的结果，只需要将 PageInfo 交给页面就行了
        //封装了详细的分页信息，包括有我们查询出来的数据
        //传入：连续显示的页数
        PageInfo page = new PageInfo(emps, 5);
        model.addAttribute("pageInfo", page);

        return "list";
    }

}
