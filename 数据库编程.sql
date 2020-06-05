-- 1. 数据库编程的必备条件
-- 编程语言，如Java，C、C++、Python等
-- 数据库，如Oracle，MySQL，SQL Server等
-- 数据库驱动包：不同的数据库，对应不同的编程语言提供了不同的数据库驱动包，如：MySQL提
-- 供了Java的驱动包mysql-connector-java，需要基于Java操作MySQL即需要该驱动包。同样的，
-- 要基于Java操作Oracle数据库则需要Oracle的数据库驱动包ojdbc。


-- MySQL是一个CS结构的系统
--        MySQL的客户端                      -->SQL                  MySQL服务器（本体）
--    （系统自带的客户端是一个控制台程序）    执行结果<--               管理和组织数据的部分  
--                                         通过网络                      |             ^
--                                                              执行结果 |通过网络      |
--                                                                      v              | SQL
--                                                           通过代码自己实现一个MySQL客户端
--                                                           同样是通过网络和服务器进行交互

-- 客户端不是凭空就能实现的，而是数据库会给我们提供一组API来方便咋们实现
-- 数据库的种类很多，不同数据提供的API都不太一样
--                             API: application programming interface 提供了一组函数/类/方法，让用户直接使用
--                             API有时候也可以成为“接口”（此处的接口和java中的interface没有直接关系）

-- MySQL的API和Oracle的API以及SQL Server的API都差异很大
-- 在java中，为了解决这个问题，引入'JDBC',可以理解成java自带的一组数据库操作的API，这组API相当于涵盖了各种数据库的操作方式，把不同数据库的API给统一到一起了
-- java自身来完成JDBC API和具体数据库API之间的转换
-- 程序猿只需要学习JDBC这一套就够用了，具体某个数据库的API的细节都不需要程序猿来考虑

--         MySQL API           Oracle API           SQL Server API
--        -----------        --------------        -----------------
--              |                    ||                  ||                -- 相当于手机的“转接头”，把不用种类的API转换成JBDC风格的统一API
--        ------------------------------------------------------------                  数据库驱动程序
--                                   JDBC的API                                      不同的数据库需要分别提供不同的驱动程序
                                                        
-- 在java中这样的驱动程序是一个独立的“jar包”
--                               jar包： .java => .class => 打一个压缩包（类似于.rar/.zip）就为.jar包
--                                       发布java程序的常见方式  


-- 数据库连接connection
-- connection 接口实现类由数据库提供，获取connection对象通常有两种方式：
-- 一种是通过DriverManger（驱动管理类）的静态方法获取：
-- // 加载JDBC驱动程序
-- Class.forName("com.mysql.jdbc.Driver");
-- // 创建数据库连接
-- Connection connection = DriverManager.getConnection(url);
-- 一种是通过DataSource（数据源）对象获取。实际应用中会使用DataSource对象。
-- DataSource ds = new MysqlDataSource();
-- ((MysqlDataSource) ds).setUrl("jdbc:mysql://localhost:3306/test");
-- ((MysqlDataSource) ds).setUser("root");
-- ((MysqlDataSource) ds).setPassword("root");
-- Connection connection = ds.getConnection();

-- JBDC里面提供了两套API:
-- 1.创建DataSource对象（准备工作）
-- 2.基于DataSource对象，创建Connection对象，和数据库建立连接（打开了客户端，输入了密码，连接成功了）
-- 3.PrepareStatement对象拼装一个具体的SQL语句（客户端中输入了SQL的过程）
-- 4.拼装好SQL之后，需要执行SQL(客户端中敲下回车，此时SQL就被发到服务器)
-- 5.查看服务器返回的结果（客户端显示出结果）
-- 6.关闭连接，释放资源（退出客户端）
 

-- JDBC编程中主要用到的类/对象
-- 1.DataSource用于配置如何连接MySQL
-- 2.Connection 表示建立好的一次连接（操作数据库之前需要先建立连接）
-- 3.PrepareStatement对应到一个SQL语句