use mysql0528;
show tables;
-- +---------------------+
-- | Tables_in_mysql0528 |
-- +---------------------+
-- | course              |
-- | exam_result         |
-- | score               |
-- | student             |
-- +---------------------+
drop table course;
drop table exam_result;
drop table score;
drop table score;
drop database mysql0528;

create database mysql1;

use mysql1;




-- 子查询
-- 子查询得到的列的数目，顺序，类型都要和被插入的表的列的数目，顺序，类型一致
-- 可以把其他selsct查找的结果作为新增的数据
create table user (
    id int primary key auto_increment,
    name varchar(20),
    decription varchar(20)
);

insert into user values(null, "曹操", '乱世枭雄');
insert into user values(null, "刘备", '仁德之主');
insert into user values(null, "孙权", '年轻有为');

create table user2(
    name varchar(20),
    decription varchar(1000)
);
insert into user2 select name,decription from user;
select name, decription from user;
-- +--------+--------------+
-- | name   | decription   |
-- +--------+--------------+
-- | 曹操   | 乱世枭雄      |
-- | 刘备   | 仁德之主      |
-- | 孙权   | 年轻有为      |
-- +--------+--------------+

select * from user2;
-- +--------+--------------+
-- | name   | decription   |
-- +--------+--------------+
-- | 曹操   | 乱世枭雄      |
-- | 刘备   | 仁德之主      |
-- | 孙权   | 年轻有为      |
-- +--------+--------------+

-- insert into user2 select * from user;   -- 此时会报错
-- ERROR 1136 (21S01): Column count doesn't match value count at row 1
-- 列的数量不匹配





-- 查询
-- 1.聚合查询
-- 一般要搭配mysql中的内置‘函数’

COUNT([DISTINCT] expr) -- 返回查询到的数据的 数量
SUM([DISTINCT] expr) -- 返回查询到的数据的 总和，不是数字没有意义
AVG([DISTINCT] expr) -- 返回查询到的数据的 平均值，不是数字没有意义
MAX([DISTINCT] expr) -- 返回查询到的数据的 最大值，不是数字没有意义
MIN([DISTINCT] expr) -- 返回查询到的数据的 最小值，不是数字没有意义


-- a.  count:计算结果的行数
show tables;
-- +------------------+
-- | Tables_in_mysql1 |
-- +------------------+
-- | user             |
-- | user2            |
-- +------------------+

select * from user;
-- +----+--------+--------------+
-- | id | name   | decription   |
-- +----+--------+--------------+
-- |  1 | 曹操   | 乱世枭雄     |
-- |  2 | 刘备   | 仁德之主     |
-- |  3 | 孙权   | 年轻有为     |
-- +----+--------+--------------+
select count(*) from user;     -- 相当于计算 select * from user 的结果的行数
-- +----------+
-- | count(*) |
-- +----------+
-- |        3 |
-- +----------+
select count(id) from user;    -- 相当于计算select id from user的结果行数
-- +-----------+
-- | count(id) |
-- +-----------+
-- |         3 |
-- +-----------+

-- count 不计算null的值
insert into user values(4, null, null);
select * from user;
-- +----+--------+--------------+
-- | id | name   | decription   |
-- +----+--------+--------------+
-- |  1 | 曹操   | 乱世枭雄     |
-- |  2 | 刘备   | 仁德之主     |
-- |  3 | 孙权   | 年轻有为     |
-- |  4 | NULL   | NULL         |
-- +----+--------+--------------+
select count(name) from user;
-- +-------------+
-- | count(name) |
-- +-------------+
-- |           3 |
-- +-------------+

-- count 本来是一个函数，如果和(name)之间存在空格，此时就相当于把count当成一个列名



-- b.  
create table student (
    id int primary key auto_increment,
    name varchar(20),
    score decimal(3, 1)
);
insert into student values(null, '曹操', 90), (null, '刘备', 85), (null, '孙权', 80);
select * from student;
-- +----+--------+-------+
-- | id | name   | score |
-- +----+--------+-------+
-- |  1 | 曹操   |  90.0 |
-- |  2 | 刘备   |  85.0 |
-- |  3 | 孙权   |  80.0 |
-- +----+--------+-------+
select sum(score) from student;
-- +------------+
-- | sum(score) |
-- +------------+
-- |      255.0 |
-- +------------+
select avg(score) from student;
-- +------------+
-- | avg(score) |
-- +------------+
-- |   85.00000 |
-- +------------+
select max(score) from student;
-- +------------+
-- | max(score) |
-- +------------+
-- |       90.0 |
-- +------------+
select min(score) from student;
-- +------------+
-- | min(score) |
-- +------------+
-- |       80.0 |
-- +------------+

-- 求所有分数小于90的同学的平均分
select avg(score) from student where score < 90;
-- +------------+
-- | avg(score) |
-- +------------+
-- |   82.50000 |
-- +------------+



-- 2.group by 把得到的查询结果集按照一定的规则分组（可能分成多个组）
create table emp(    -- 员工表
    id int primary key auto_increment,
    name varchar(20),
    role varchar(20),
    salary decimal(7, 2)
);

insert into emp values(null, '小王', '教师', 10000), (null, '小红', '教师', 5000);
insert into emp values(null, '小红1', '班主任', 3000), (null, '小红2', '班主任', 2800);
insert into emp values(null, '小红3', '班主任', 280), (null, '小红4', '班主任', 250);
insert into emp values(null, '小王1', '市场', 230), (null, '小王2', '市场', 520), (null, '小王3', '市场', 480);

select * from emp;
-- +----+---------+-----------+----------+
-- | id | name    | role      | salary   |
-- +----+---------+-----------+----------+
-- |  1 | 小王    | 教师      | 10000.00 |
-- |  2 | 小红    | 教师      |  5000.00 |
-- |  3 | 小红1   | 班主任    |  3000.00 |
-- |  4 | 小红2   | 班主任    |  2800.00 |
-- |  5 | 小红3   | 班主任    |   280.00 |
-- |  6 | 小红4   | 班主任    |   250.00 |
-- |  7 | 小王1   | 市场      |   230.00 |
-- |  8 | 小王2   | 市场      |   520.00 |
-- |  9 | 小王3   | 市场      |   480.00 |
-- +----+---------+-----------+----------+        


-- 查询每个岗位的最高工资，最低工资，平均工资
select role from emp;
-- +-----------+
-- | role      |
-- +-----------+
-- | 教师      |
-- | 教师      |
-- | 班主任    |
-- | 班主任    |
-- | 班主任    |
-- | 班主任    |
-- | 市场      |
-- | 市场      |
-- | 市场      |
-- +-----------+
select role from emp group by role;   -- 角色相同的记录会被分到同一组中
-- +-----------+
-- | role      |
-- +-----------+
-- | 市场      |
-- | 教师      |
-- | 班主任    |
-- +-----------+
select role, avg(salary) from emp group by role;
-- 有了group by 之后，就把role相同的记录放到同一组中，avg就是针对每个组分别求平均值
-- +-----------+-------------+
-- | role      | avg(salary) |
-- +-----------+-------------+
-- | 市场      |  410.000000 |
-- | 教师      | 7500.000000 |
-- | 班主任    | 1582.500000 |
-- +-----------+-------------+
select role, avg(salary), max(salary), min(salary) from emp group by role;
-- +-----------+-------------+-------------+-------------+
-- | role      | avg(salary) | max(salary) | min(salary) |
-- +-----------+-------------+-------------+-------------+
-- | 市场      |  410.000000 |      520.00 |      230.00 |
-- | 教师      | 7500.000000 |    10000.00 |     5000.00 |
-- | 班主任    | 1582.500000 |     3000.00 |      250.00 |
-- +-----------+-------------+-------------+-------------+

-- group by 中也可以结合一些条件对数据进行进一步的筛选，不是使用where，而是使用having
-- having是针对group by 之后的结果进行筛选
-- where是针对原始表中的每条记录进行筛选


-- 查找出所有平均工资高于1000的岗位和平均薪资
select role, avg(salary) from emp group by role having avg(salary) > 1000;
-- +-----------+-------------+
-- | role      | avg(salary) |
-- +-----------+-------------+
-- | 教师      | 7500.000000 |
-- | 班主任    | 1582.500000 |
-- +-----------+-------------+









-- 联合查询/多表查询
-- 联合查询的基本机制：笛卡尔积
-- 学生表 id, name, courdeId                课程表id, name
--        1   曹操     1                          1  语文
--        2   刘备     3                          2  数学
--        3   孙权     4                          3  英语
--                                                4  物理 
-- 笛卡尔积的结果为：
--         1   曹操     1   1  语文
--         1   曹操     1   2  数学
--         1   曹操     1   3  英语
--         1   曹操     1   4  物理
--         2   刘备     3   1  语文
--         2   刘备     3   2  数学
--         2   刘备     3   3  英语
--                          ......
-- 笛卡尔积就会得到12条记录，两张表每条记录进行排列组合的结果
-- 多表查询的过程，先计算多个表的笛卡尔积，再基于一些条件针对笛卡尔积中的记录进行筛选
-- 如果针对两个比较大的表进行联合查询，笛卡尔积的计算开销会很大，最终的查询效率也就较低
-- 不应该在生产环境上对大表进行联合查询
-- 面试中考察的SQL语句编写一般都是多表查询



-- 构造多个表
drop table if exists classes;
drop table if exists student;
drop table if exists course;
drop table if exists score;

create table classes (id int primary key auto_increment, name varchar(20), `desc` varchar(100));

create table student (id int primary key auto_increment, sn varchar(20),  
        name varchar(20), qq_mail varchar(20) ,
        classes_id int);

create table course(id int primary key auto_increment, name varchar(20));

create table score(score decimal(3, 1), student_id int, course_id int);

insert into classes(name, `desc`) values 
('计算机系2019级1班', '学习了计算机原理、C和Java语言、数据结构和算法'),
('中文系2019级3班','学习了中国传统文学'),
('自动化2019级5班','学习了机械自动化');

insert into student(sn, name, qq_mail, classes_id) values
('09982','黑旋风李逵','xuanfeng@qq.com',1),
('00835','菩提老祖',null,1),
('00391','白素贞',null,1),
('00031','许仙','xuxian@qq.com',1),
('00054','不想毕业',null,1),
('51234','好好说话','say@qq.com',2),
('83223','tellme',null,2),
('09527','老外学中文','foreigner@qq.com',2);

insert into course(name) values
('Java'),('中国传统文化'),('计算机原理'),('语文'),('高阶数学'),('英文');

insert into score(score, student_id, course_id) values
-- 黑旋风李逵
(70.5, 1, 1),(98.5, 1, 3),(33, 1, 5),(98, 1, 6),
-- 菩提老祖
(60, 2, 1),(59.5, 2, 5),
-- 白素贞
(33, 3, 1),(68, 3, 3),(99, 3, 5),
-- 许仙
(67, 4, 1),(23, 4, 3),(56, 4, 5),(72, 4, 6),
-- 不想毕业
(81, 5, 1),(37, 5, 5),
-- 好好说话
(56, 6, 2),(43, 6, 4),(79, 6, 6),
-- tellme
(80, 7, 2),(92, 7, 6);


select * from classes;
-- +----+-------------------------+------------------------------------------------
-- ---------+
-- | id | name                    | desc
--          |
-- +----+-------------------------+------------------------------------------------
-- ---------+
-- |  1 | 计算机系2019级1班       | 学习了计算机原理、C和Java语言、数据结构和算法
--          |
-- |  2 | 中文系2019级3班         | 学习了中国传统文学
--          |
-- |  3 | 自动化2019级5班         | 学习了机械自动化
--          |
-- +----+-------------------------+------------------------------------------------
select * from course;
-- +----+--------------------+
-- | id | name               |
-- +----+--------------------+
-- |  1 | Java               |
-- |  2 | 中国传统文化       |
-- |  3 | 计算机原理         |
-- |  4 | 语文               |
-- |  5 | 高阶数学           |
-- |  6 | 英文               |
-- +----+--------------------+
select * from student;
-- +----+-------+-----------------+------------------+------------+
-- | id | sn    | name            | qq_mail          | classes_id |
-- +----+-------+-----------------+------------------+------------+
-- |  1 | 09982 | 黑旋风李逵      | xuanfeng@qq.com  |          1 |
-- |  2 | 00835 | 菩提老祖        | NULL             |          1 |
-- |  3 | 00391 | 白素贞          | NULL             |          1 |
-- |  4 | 00031 | 许仙            | xuxian@qq.com    |          1 |
-- |  5 | 00054 | 不想毕业        | NULL             |          1 |
-- |  6 | 51234 | 好好说话        | say@qq.com       |          2 |
-- |  7 | 83223 | tellme          | NULL             |          2 |
-- |  8 | 09527 | 老外学中文      | foreigner@qq.com |          2 |
-- +----+-------+-----------------+------------------+------------+
select * from score;
-- +-------+------------+-----------+
-- | score | student_id | course_id |
-- +-------+------------+-----------+
-- |  70.5 |          1 |         1 |
-- |  98.5 |          1 |         3 |
-- |  33.0 |          1 |         5 |
-- |  98.0 |          1 |         6 |
-- |  60.0 |          2 |         1 |
-- |  59.5 |          2 |         5 |
-- |  33.0 |          3 |         1 |
-- |  68.0 |          3 |         3 |
-- |  99.0 |          3 |         5 |
-- |  67.0 |          4 |         1 |
-- |  23.0 |          4 |         3 |
-- |  56.0 |          4 |         5 |
-- |  72.0 |          4 |         6 |
-- |  81.0 |          5 |         1 |
-- |  37.0 |          5 |         5 |
-- |  56.0 |          6 |         2 |
-- |  43.0 |          6 |         4 |
-- |  79.0 |          6 |         6 |
-- |  80.0 |          7 |         2 |
-- |  92.0 |          7 |         6 |
-- +-------+------------+-----------+


-- 1.内连接
-- select 字段 from 表1 别名1 [inner] join 表2 别名2 on 连接条件 and 其他条件;
-- select 字段 from 表1 别名1,表2 别名2 where 连接条件 and

-- a.查找名字为许仙的同学的所有成绩
-- 姓名包含在student中
-- 分数包含在score中
-- 就需要针对这两个表进行联合查询
-- 笛卡尔积结果：where中没有添加任何条件。得到的结果就是笛卡尔积
-- 多表查询时，写列的时候要写成 表名.列名
select student.id, student.name, score.student_id, score.score from student, score;    -- 两张表的笛卡尔积结果
--  id | name            | student_id | score
-- ----+-----------------+------------+-------
--   1 | 黑旋风李逵      |          1 |  70.5
--   2 | 菩提老祖        |          1 |  70.5      -- student中的id与score中的student_id字段对应才是有意义的记录
--   3 | 白素贞          |          1 |  70.5
--   4 | 许仙            |          1 |  70.5
--   5 | 不想毕业        |          1 |  70.5
--                                 ......
-- 加上where语句去掉无意义的记录
select student.id, student.name, score.student_id, score.score 
from student, score where student.id = score.student_id;    
-- +----+-----------------+------------+-------+
-- | id | name            | student_id | score |
-- +----+-----------------+------------+-------+
-- |  1 | 黑旋风李逵      |          1 |  70.5 |
-- |  1 | 黑旋风李逵      |          1 |  98.5 |
-- |  1 | 黑旋风李逵      |          1 |  33.0 |
-- |  1 | 黑旋风李逵      |          1 |  98.0 |
-- |  2 | 菩提老祖        |          2 |  60.0 |
-- |  2 | 菩提老祖        |          2 |  59.5 |
-- |  3 | 白素贞          |          3 |  33.0 |
-- |  3 | 白素贞          |          3 |  68.0 |
-- |  3 | 白素贞          |          3 |  99.0 |
-- |  4 | 许仙            |          4 |  67.0 |
--                                    ......

-- 为了查找许仙的成绩信息，在上面where基础上再加一个条件，删选姓名
select student.id, student.name, score.student_id, score.score 
from student, score where student.id = score.student_id and student.name = '许仙';    
-- +----+--------+------------+-------+
-- | id | name   | student_id | score |
-- +----+--------+------------+-------+
-- |  4 | 许仙   |          4 |  67.0 |
-- |  4 | 许仙   |          4 |  23.0 |
-- |  4 | 许仙   |          4 |  56.0 |
-- |  4 | 许仙   |          4 |  72.0 |
-- +----+--------+------------+-------+

-- 解决思路：
-- 先把两张表联合在一起，得到笛卡尔积
-- 按照student id对笛卡尔积的记录进行筛选，保留有意义的数据
-- 再对名字进行删选

--使用join on进行查询
select student.id, student.name, score.score from student 
join score on student.id = score.student_id  and student.name = '许仙';
-- +----+--------+-------+
-- | id | name   | score |
-- +----+--------+-------+
-- |  4 | 许仙   |  67.0 |
-- |  4 | 许仙   |  23.0 |
-- |  4 | 许仙   |  56.0 |
-- |  4 | 许仙   |  72.0 |
-- +----+--------+-------+


-- b.查找所有同学的总成绩，以及该同学的基本信息
-- 同学信息在student中，成绩在score中
-- 筛选条件：
-- 按照学生id进行筛选，去掉笛卡尔积中的不必要的数据
-- 按照学生的id进行group by,求每个同学的总成绩
select student.id, student.name ,score.student_id, score.score from student,score;
-- +----+-----------------+------------+-------+
-- | id | name            | student_id | score |
-- +----+-----------------+------------+-------+
-- |  1 | 黑旋风李逵      |          1 |  70.5 |
-- |  2 | 菩提老祖        |          1 |  70.5 |
-- |  3 | 白素贞          |          1 |  70.5 |
-- |  4 | 许仙            |          1 |  70.5 |
-- |  5 | 不想毕业        |          1 |  70.5 |
-- |  6 | 好好说话        |          1 |  70.5 |
-- |  7 | tellme          |          1 |  70.5 |
-- |  8 | 老外学中文      |          1 |  70.5 |
-- |  1 | 黑旋风李逵      |          1 |  98.5 |
--            ......
select student.id, student.name ,score.student_id, score.score 
from student,score where student.id = score.student_id;
-- +----+-----------------+------------+-------+
-- | id | name            | student_id | score |
-- +----+-----------------+------------+-------+
-- |  1 | 黑旋风李逵      |          1 |  70.5 |
-- |  1 | 黑旋风李逵      |          1 |  98.5 |
-- |  1 | 黑旋风李逵      |          1 |  33.0 |
-- |  1 | 黑旋风李逵      |          1 |  98.0 |
-- |  2 | 菩提老祖        |          2 |  60.0 |
-- |  2 | 菩提老祖        |          2 |  59.5 |
-- |  3 | 白素贞          |          3 |  33.0 |
select student.id, student.name ,score.student_id, score.score 
from student,score where student.id = score.student_id group by student.id;
-- +----+-----------------+------------+-------+
-- | id | name            | student_id | score |
-- +----+-----------------+------------+-------+
-- |  1 | 黑旋风李逵      |          1 |  70.5 |
-- |  2 | 菩提老祖        |          2 |  60.0 |
-- |  3 | 白素贞          |          3 |  33.0 |
-- |  4 | 许仙            |          4 |  67.0 |
-- |  5 | 不想毕业        |          5 |  81.0 |
-- |  6 | 好好说话        |          6 |  56.0 |
-- |  7 | tellme          |          7 |  80.0 |
-- +----+-----------------+------------+-------+
-- group by 之后记录的数目 肯定比原来的少，如果某一列若干行的值已经相同了，groupby没影响，
-- 如果某一列不相同，group by最终就只剩下一条记录
-- 如果是求每个同学的总成绩，其实也不受影响
select student.id, student.name ,score.student_id, sum(score.score) 
from student,score where student.id = score.student_id group by student.id;
-- +----+-----------------+------------+------------------+
-- | id | name            | student_id | sum(score.score) |
-- +----+-----------------+------------+------------------+
-- |  1 | 黑旋风李逵      |          1 |            300.0 |
-- |  2 | 菩提老祖        |          2 |            119.5 |
-- |  3 | 白素贞          |          3 |            200.0 |
-- |  4 | 许仙            |          4 |            218.0 |
-- |  5 | 不想毕业        |          5 |            118.0 |
-- |  6 | 好好说话        |          6 |            178.0 |
-- |  7 | tellme          |          7 |            172.0 |
-- +----+-----------------+------------+------------------+


-- c.查找所有同学的每一科的成绩，和同学的相关信息
-- 最终的效果需要显示：同学姓名，科目名称，对应的成绩
--                   student    course   score
-- 先对三张表进行联合
select student.id, student.name, course.id, course.name, score.student_id, 
score.course_id, score.score from student,course,score;
-- 按照student.id 和score.student_id针对笛卡尔积结果进行筛选
select student.id, student.name, course.id, course.name, score.student_id, 
score.course_id, score.score from student,course,score
where student.id = score.student_id;
-- +----+-----------------+----+--------------------+------------+-----------+-------+
-- | id | name            | id | name               | student_id | course_id | score |
-- +----+-----------------+----+--------------------+------------+-----------+-------+
-- |  1 | 黑旋风李逵      |  1 | Java               |          1 |         1 |  70.5 |
-- |  1 | 黑旋风李逵      |  2 | 中国传统文化       |          1 |         1 |  70.5 |
-- |  1 | 黑旋风李逵      |  3 | 计算机原理         |          1 |         1 |  70.5 |
-- |  1 | 黑旋风李逵      |  4 | 语文               |          1 |         1 |  70.5 |
-- |  1 | 黑旋风李逵      |  5 | 高阶数学           |          1 |         1 |  70.5 |
-- |  1 | 黑旋风李逵      |  6 | 英文               |          1 |         1 |  70.5 |
-- |  1 | 黑旋风李逵      |  1 | Java               |          1 |         3 |  98.5 |
-- 按照course.id和score.course_id对上述结果再进行筛选
select student.id, student.name, course.id, course.name, score.student_id, score.course_id, 
score.score from student,course,score
where student.id = score.student_id
and course.id = score.course_id;
-- +----+-----------------+----+--------------------+------------+-----------+-------+
-- | id | name            | id | name               | student_id | course_id | score |
-- +----+-----------------+----+--------------------+------------+-----------+-------+
-- |  1 | 黑旋风李逵      |  1 | Java               |          1 |         1 |  70.5 |
-- |  1 | 黑旋风李逵      |  3 | 计算机原理          |          1 |         3 |  98.5 |
-- |  1 | 黑旋风李逵      |  5 | 高阶数学            |          1 |         5 |  33.0 |
-- |  1 | 黑旋风李逵      |  6 | 英文                |          1 |         6 |  98.0 |
-- |  2 | 菩提老祖        |  1 | Java               |          2 |         1 |  60.0 |
-- |  2 | 菩提老祖        |  5 | 高阶数学            |          2 |         5 |  59.5 |
-- |  3 | 白素贞          |  1 | Java               |          3 |         1 |  33.0 |
-- |  3 | 白素贞          |  3 | 计算机原理          |          3 |         3 |  68.0 |
-- 去掉重复的列，只保留关心的列
select student.name, course.name, score.score from student,course,score
where student.id = score.student_id
and course.id = score.course_id;
-- +-----------------+--------------------+-------+
-- | name            | name               | score |
-- +-----------------+--------------------+-------+
-- | 黑旋风李逵      | Java               |  70.5 |
-- | 黑旋风李逵      | 计算机原理         |  98.5 |
-- | 黑旋风李逵      | 高阶数学           |  33.0 |
-- | 黑旋风李逵      | 英文               |  98.0 |
-- | 菩提老祖        | Java               |  60.0 |
-- | 菩提老祖        | 高阶数学           |  59.5 |
-- | 白素贞          | Java               |  33.0 |
-- | 白素贞          | 计算机原理         |  68.0 |
-- | 白素贞          | 高阶数学           |  99.0 |
-- | 许仙            | Java               |  67.0 |
-- | 许仙            | 计算机原理         |  23.0 |
-- | 许仙            | 高阶数学           |  56.0 |



-- 内连接：只能查出两张表中同时存在的数据
-- 外连接：在A表中存在，在B表中不存在；或者在A中不存在，在B中存在，这样的记录也能查出来
-- 左连接：能查到在A中存在的数据，在B中不存在；在A中不存在，在B中存在的数据查不到
-- 右连接：查不到在A中存在，在B中不存在的数据；在A中不存在，在B中存在的数据能查到







-- 2.自连接：本质上相当于把同一列的两行记录转换成不同列的同一行记录
-- 左右计算机原理的成绩比java成绩高的同学id
-- 先找到java和计算机原理课程id
-- 按照课程id在分数表中筛选数据
select * from course where name = 'java';
-- +----+------+
-- | id | name |
-- +----+------+
-- |  1 | Java |
-- +----+------+
select * from course where name = '计算机原理';
-- +----+-----------------+
-- | id | name            |
-- +----+-----------------+
-- |  3 | 计算机原理      |
-- +----+-----------------+
-- 针对score自身进行笛卡尔积
select s1.student_id, s1.score, s1.course_id, s2.student_id, s2.score, s2.course_id from score s1, score s2;
-- +------------+-------+-----------+------------+-------+-----------+
-- | student_id | score | course_id | student_id | score | course_id |
-- +------------+-------+-----------+------------+-------+-----------+
-- |          1 |  70.5 |         1 |          1 |  70.5 |         1 |
-- |          1 |  98.5 |         3 |          1 |  70.5 |         1 |
-- |          1 |  33.0 |         5 |          1 |  70.5 |         1 |
-- |          1 |  98.0 |         6 |          1 |  70.5 |         1 |
-- |          2 |  60.0 |         1 |          1 |  70.5 |         1 |
-- |          2 |  59.5 |         5 |          1 |  70.5 |         1 |
-- |          3 |  33.0 |         1 |          1 |  70.5 |         1 |
-- |          3 |  68.0 |         3 |          1 |  70.5 |         1 |
-- 加上学生id的限制
select s1.student_id, s1.score, s1.course_id, s2.student_id, s2.score, s2.course_id from score s1, score s2 where s1.student_id = s2.student_id;
-- +------------+-------+-----------+------------+-------+-----------+
-- | student_id | score | course_id | student_id | score | course_id |
-- +------------+-------+-----------+------------+-------+-----------+
-- |          1 |  70.5 |         1 |          1 |  70.5 |         1 |
-- |          1 |  98.5 |         3 |          1 |  70.5 |         1 |
-- |          1 |  33.0 |         5 |          1 |  70.5 |         1 |
-- |          1 |  98.0 |         6 |          1 |  70.5 |         1 |
-- |          1 |  70.5 |         1 |          1 |  98.5 |         3 |
-- |          1 |  98.5 |         3 |          1 |  98.5 |         3 |
-- |          1 |  33.0 |         5 |          1 |  98.5 |         3 |
-- |          1 |  98.0 |         6 |          1 |  98.5 |         3 |
-- 加上课程id的限制
-- 1为java;3为计算机原理
select s1.student_id, s1.score, s1.course_id, s2.student_id, s2.score, s2.course_id from score s1, score s2 where s1.student_id = s2.student_id
and s1.course_id = 3 and s2.course_id = 1;
-- +------------+-------+-----------+------------+-------+-----------+
-- | student_id | score | course_id | student_id | score | course_id |
-- +------------+-------+-----------+------------+-------+-----------+
-- |          1 |  98.5 |         3 |          1 |  70.5 |         1 |
-- |          3 |  68.0 |         3 |          3 |  33.0 |         1 |
-- |          4 |  23.0 |         3 |          4 |  67.0 |         1 |
-- +------------+-------+-----------+------------+-------+-----------+
-- 按照分数大小进行比较
select s1.student_id, s1.score, s1.course_id, s2.student_id, s2.score, s2.course_id from score s1, score s2 where s1.student_id = s2.student_id
and s1.course_id = 3 and s2.course_id = 1 and s1.score > s2.score;
-- +------------+-------+-----------+------------+-------+-----------+
-- | student_id | score | course_id | student_id | score | course_id |
-- +------------+-------+-----------+------------+-------+-----------+
-- |          1 |  98.5 |         3 |          1 |  70.5 |         1 |
-- |          3 |  68.0 |         3 |          3 |  33.0 |         1 |
-- +------------+-------+-----------+------------+-------+-----------+
-- 去掉不必要的列
select s1.student_id from score s1, score s2 where s1.student_id = s2.student_id
and s1.course_id = 3 and s2.course_id = 1 and s1.score > s2.score;
-- +------------+
-- | student_id |
-- +------------+
-- |          1 |
-- |          3 |
-- +------------+





-- 3.子查询：在其他sql中嵌入查询语句。

-- 单行子查询  借助=实现
-- 查询和“不想毕业”同班的同学有哪些
select * from student;
-- +----+-------+-----------------+------------------+------------+
-- | id | sn    | name            | qq_mail          | classes_id |
-- +----+-------+-----------------+------------------+------------+
-- |  1 | 09982 | 黑旋风李逵      | xuanfeng@qq.com  |          1 |
-- |  2 | 00835 | 菩提老祖        | NULL             |          1 |
-- |  3 | 00391 | 白素贞          | NULL             |          1 |
-- |  4 | 00031 | 许仙            | xuxian@qq.com    |          1 |
-- |  5 | 00054 | 不想毕业        | NULL             |          1 |
-- |  6 | 51234 | 好好说话        | say@qq.com       |          2 |
-- |  7 | 83223 | tellme          | NULL             |          2 |
-- |  8 | 09527 | 老外学中文      | foreigner@qq.com |          2 |
-- +----+-------+-----------------+------------------+------------+
select classes_id from student where name = '不想毕业';
-- +------------+
-- | classes_id |
-- +------------+
-- |          1 |
-- +------------+
 SELECT name from student where classes_id = (select classes_id from student where name = '不想毕业');
-- +-----------------+
-- | name            |
-- +-----------------+
-- | 黑旋风李逵      |
-- | 菩提老祖        |
-- | 白素贞          |
-- | 许仙            |
-- | 不想毕业        |
-- +-----------------+

-- 多行子查询
-- 查询语文或者英文课程对应的成绩
SELECT * from score;
-- +-------+------------+-----------+
-- | score | student_id | course_id |
-- +-------+------------+-----------+
-- |  70.5 |          1 |         1 |
-- |  98.5 |          1 |         3 |
-- |  33.0 |          1 |         5 |
-- |  98.0 |          1 |         6 |
-- |  60.0 |          2 |         1 |
-- |  59.5 |          2 |         5 |
-- |  33.0 |          3 |         1 |
-- |  68.0 |          3 |         3 |
-- |  99.0 |          3 |         5 |
SELECT * from course;
-- +----+--------------------+
-- | id | name               |
-- +----+--------------------+
-- |  1 | Java               |
-- |  2 | 中国传统文化       |
-- |  3 | 计算机原理         |
-- |  4 | 语文               |
-- |  5 | 高阶数学           |
-- |  6 | 英文               |
-- +----+--------------------+
SELECT id from course where name = '语文' or name = '英文';
-- +----+
-- | id |
-- +----+
-- |  4 |
-- |  6 |
-- +----+
-- 借助in的方式来实现:先执行子查询，把子查询的结果保存到内存中，再进行主查询，再结合刚才的子查询的结果来筛选最终结果
select * from score where course_id in (SELECT id from course where name = '语文' or name = '英文');
-- +-------+------------+-----------+
-- | score | student_id | course_id |
-- +-------+------------+-----------+
-- |  98.0 |          1 |         6 |
-- |  72.0 |          4 |         6 |
-- |  43.0 |          6 |         4 |
-- |  79.0 |          6 |         6 |
-- |  92.0 |          7 |         6 |
-- +-------+------------+-----------+
-- 借助exists也能完成子查询：限制性主查询，再出发子查询
select * from score where exists (select score.course_id from course where (name = '英文' or name = '语文') and course.id = score.course_id);
-- +-------+------------+-----------+
-- | score | student_id | course_id |
-- +-------+------------+-----------+
-- |  98.0 |          1 |         6 |
-- |  72.0 |          4 |         6 |
-- |  43.0 |          6 |         4 |
-- |  79.0 |          6 |         6 |
-- |  92.0 |          7 |         6 |
-- +-------+------------+-----------+
--如果子表查询的结果集合比较小，就使用in;如果子表查询的结果集合比较大，而主表的集合小，就使用exists






-- 4.合并查询：相当于把多个查询结果集合并成一个集合(需要保证多个结果集之间的字段类型和数目都得一致)
-- union
-- 查询id<3或者名字为“英文”的课程   如果筛选条件非常简单，直接使用or就行
select * from course where id < 3 or name = '英文';
-- +----+--------------------+
-- | id | name               |
-- +----+--------------------+
-- |  1 | Java               |
-- |  2 | 中国传统文化       |
-- |  6 | 英文               |
-- +----+--------------------+

SELECT * from course where id < 3 union SELECT * from course where name = '英文';
-- +----+--------------------+
-- | id | name               |
-- +----+--------------------+
-- |  1 | Java               |
-- |  2 | 中国传统文化       |
-- |  6 | 英文               |
-- +----+--------------------+

-- 如果两个查询结果中存在相同的记录，就会只保留一个
-- 如果不想去重，可以使用union all 即可



-- SQL的特点，不需要用户来指定一步一步该如何执行，只要告诉数据库，最终想要啥数据即可
-- 像C/Java需要告诉计算机每一步都该如何执行
