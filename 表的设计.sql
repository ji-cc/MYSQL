-- 数据库表设计时所设计到的关系
-- 1.一对一关系


-- 2.一对多的关系，组织形式是这样的:
-- class 表(id, name)
-- student 表(id,name,classId)
-- student 表中可能会存在很多条记录
-- 这很多条记录中，其中的classId可能都是相同的
-- 这些classId相同的记录就表示存在于统一班级中

-- 一对多能否这样表示呢？
-- -- class 表(id,name,students)
-- --                 students这一列当成一个数组，数组中的每个元素表示一个学生的信息
-- 这样是不可以的：因为mysql中没有数组leix


-- 3.多对多
-- 例如当前有很多学生：甲乙丙丁.....
-- 当前又有很多课程：语文，数学，英语，物理，化学.....
-- 任意一个学生，都有可能会选择多门课程
-- 任意一门课程，都有可能会被多个学生选择

-- 甲：语文数学
-- 乙：英语物理
-- 丙：语文数学化学物理
-- 丁：数学英语化学






-- 例如，描述每个同学的每个科目的考试成绩
-- 先创建表来描述同学信息，然后再创建表来描述科目信息
drop table student;
drop table class;
create table student(
    id int primary key auto_increment,
    name varchar(20)
);

create table course (
    id int primary key auto_increment,
    name varchar(20)
);

insert into student values(null, '甲'), (null, '乙'), (null, '丙'), (null, '丁');
select * from student;
-- +----+------+
-- | id | name |
-- +----+------+
-- |  1 | 甲   |
-- |  2 | 乙   |
-- |  3 | 丙   |
-- |  4 | 丁   |
-- +----+------+

insert into course values(null, '语文'), (null, '数学'), (null, '英语'), (null, '物理'), (null, '化学');
select * from course;
-- +----+--------+
-- | id | name   |
-- +----+--------+
-- |  1 | 语文   |
-- |  2 | 数学   |
-- |  3 | 英语   |
-- |  4 | 物理   |
-- |  5 | 化学   |
-- +----+--------+

-- 为了描述每个同学每一科考了多少分，就需要搞一个中间表来描述
create table score(
    courseId int,
    studentId int,
    score decimal(3, 1)
);
insert into score values(1, 4, 90);
select * from score;
-- +----------+-----------+-------+
-- | courseId | studentId | score |
-- +----------+-----------+-------+
-- |        1 |         4 |  90.0 |
-- +----------+-----------+-------+
--   语文         甲       成绩

-- 由于是多对多的关系，会看到courseId存在很多重复的（很多同学都可能修了这门课程0）
-- 很多studentId也存在重复（一个同学可能修了多门课程）

-- 如果想找到“甲”这个同学的“语文”成绩如何？
-- 此时的查找过程就会更复杂
-- 1.先找到甲的studentId
-- 2.再找到语文的courseId
-- 结合这两个id再在score表中查找