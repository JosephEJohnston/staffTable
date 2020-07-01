package com.noob.test;

import com.noob.bean.Department;
import com.noob.bean.Employee;
import com.noob.dao.DepartmentMapper;
import com.noob.dao.EmployeeMapper;
import org.apache.ibatis.session.SqlSession;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import java.util.UUID;

/**
 * 1. 导入 SpringTest 模块
 * 2. @ContextConfiguration 指定 Spring 配置文件的位置
 * 3. 直接 autowired 要使用的组件即可
 */

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:applicationContext.xml"})
public class MapperTest {

    /**
     * Dao 注入
     */
    @Autowired
    DepartmentMapper departmentMapper;

    @Autowired
    EmployeeMapper employeeMapper;

    @Autowired
    SqlSession sqlSession;

    /**
     * 测试 DepartmentMapper
     * 推荐 Spring 的项目就可以使用 Spring 的单元测试
     *  可以自动注入我们需要的组件
     */
    @Test
    public void testCRUD() {
        /*//1. 创建 SpringIOC 容器
        ApplicationContext ioc = new ClassPathXmlApplicationContext("applicationContext.xml");
        //2. 从容器中获取 Mapper
        DepartmentMapper bean = ioc.getBean(DepartmentMapper.class);*/

        System.out.println(departmentMapper);

        //1. 插入几个部门
        /*departmentMapper.insertSelective(new Department(null, "开发部"));
        departmentMapper.insertSelective(new Department(null, "测试部"));*/

        //2. 生成员工数据，测试员工插入
        //employeeMapper.insertSelective(new Employee(null, "Jerry", "M", "Jerry@qq.com", 1));
        
        /*//3. 批量插入多个员工：使用可以执行批量操作的 sqlSession
        //批量生产：
        EmployeeMapper mapper = sqlSession.getMapper(EmployeeMapper.class);
        for (int i = 0; i < 1000; i++) {
            String uid = UUID.randomUUID().toString().substring(0, 5) + i;
            mapper.insertSelective(new Employee(null, uid, "M", uid + "@qq.com", 1));
        }
        System.out.println("批量生产");*/
    }
}
