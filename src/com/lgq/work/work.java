package com.lgq.work;

import com.lgq.work.obj.TableColumn;
import com.mysql.jdbc.Driver;
import freemarker.template.Configuration;
import freemarker.template.Template;

import java.io.*;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


public class work {

    private static final String TEMPLATE_PATH = "src/com/lgq/work/templates"; //模板文件位置
    private static final String MYSQL_PATH = "jdbc:mysql://47.100.226.134:3306/information_schema"; //数据库information_schema地址
    private static final String USER = "lgq"; //用户
    private static final String PASSWORD = "1234"; //密码
    private static final String TABLE_SCHEMA = "blog"; //对应生成的数据库名

    public static void main(String[] args) throws SQLException {
        // 1.加载驱动
        DriverManager.registerDriver(new Driver());
        // 2.获取数据库连接
        Connection con = DriverManager.getConnection(MYSQL_PATH, USER, PASSWORD);
        // 3.获取Statement对象
        Statement st = con.createStatement();
        // 4.执行sql语句，获取结果集
        String sql = "select TABLE_NAME from TABLES where TABLE_SCHEMA = '" + TABLE_SCHEMA + "' and ENGINE = 'InnoDB'";//获取某个数据库所有表名
        ResultSet rs = st.executeQuery(sql);

        while (rs.next()) {
            String tableName = rs.getString("TABLE_NAME");
            System.out.println("处理" + tableName);
            Statement st1 = con.createStatement();
            String sql1 = "select * from COLUMNS where TABLE_NAME = '" + tableName + "'";//根据表明获取字段
            ResultSet rs1 = st1.executeQuery(sql1);
            List<TableColumn> columnList = new ArrayList<>();
            while (rs1.next()) {
                TableColumn tableColumn = new TableColumn();
                columnList.add(tableColumn);
            }
            rs1.close();
            st1.close();
            System.out.println("生成Obj文件");

            System.out.println("生成SQL文件");

            System.out.println("生成Controller文件");

            System.out.println("生成Vue文件");

            if ("t_systemmenu".equals(tableName)) {
                System.out.println("生成Router文件");
            }
        }
        rs.close();
        st.close();
        con.close();

    }

    //生成Obj文件
    public static void generateObj(List<TableColumn> columnList, String tableName, String pathName, String objName) {
        try {
            // step1 创建freeMarker配置实例
            Configuration configuration = new Configuration();
            Writer out = null;
            // step2 获取模版路径
            configuration.setDirectoryForTemplateLoading(new File(TEMPLATE_PATH));

            // step3 创建数据模型
            Map<String, Object> dataMap = new HashMap<String, Object>();
            dataMap.put("packageName", pathName);
            dataMap.put("tableName", tableName);
            dataMap.put("objName", objName);
            dataMap.put("modelColumn", columnList);

            // step4 加载模版文件
            Template template = configuration.getTemplate("xxxObj.ftl");

            // step5 生成数据
            File docFile = new File(pathName.replaceAll(".", "/") + "/" + objName + ".java");
            out = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(docFile)));

            // step6 输出文件
            template.process(dataMap, out);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}
