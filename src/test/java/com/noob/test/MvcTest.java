package com.noob.test;

import com.github.pagehelper.PageInfo;
import com.noob.bean.Employee;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.result.MockMvcResultHandlers;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import java.util.List;

/**
 * 使用 Spring 测试模块提供的测试请求功能，测试 crud 请求的正确性
 */
@RunWith(SpringJUnit4ClassRunner.class)
@WebAppConfiguration //传入 ioc 容器本身
@ContextConfiguration(locations = {"classpath:applicationContext.xml", "classpath:springmvc.xml"})
public class MvcTest {

    //虚拟 mvc 请求，获取到处理结果
    MockMvc mockMvc;

    /**
     * 传入 springmvc 的 ioc
     *  注意，可以自动装配 ioc 容器内的对象
     *  但对于 ioc 容器本身，需要其他注解
     */
    @Autowired
    WebApplicationContext context;

    @Before
    public void initMockMvc() {
        mockMvc = MockMvcBuilders.webAppContextSetup(context).build();
    }

    @Test
    public void testPage() throws Exception {
        //模拟请求拿到返回值
        MvcResult mvcResult = mockMvc.perform(MockMvcRequestBuilders.get("/emps")
                .param("pn", "5")).andReturn();

        //请求成功以后，请求域中会有 PageInfo：我们可以取出 PageInfo 进行验证
        MockHttpServletRequest request = mvcResult.getRequest();
        PageInfo attribute = (PageInfo)request.getAttribute("pageInfo");
        System.out.println("当前页码：" + attribute.getPageNum());
        System.out.println("总页码：" + attribute.getPages());
        System.out.println("总记录数：" + attribute.getTotal());
        System.out.println("在页面需要连续显示的页码");
        int[] nums = attribute.getNavigatepageNums();
        for (int num : nums) {
            System.out.print(" " + num);
        }
        System.out.println();

        //获取员工数据
        List<Employee> list = attribute.getList();
        for (Employee employee : list) {
            System.out.println("ID: " + employee.getEmpId() + "==>Name: " + employee.getEmpName());
        }
    }
}
