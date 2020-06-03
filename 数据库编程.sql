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





