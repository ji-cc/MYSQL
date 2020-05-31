-- 删除
-- delete from 表名 where 删选条件

show databases;   -- 显示所有数据库
create table student (
    id int,
    name varchar(20),
    score decimal(3, 1)
);
insert into student values(1, '小李', 90), (2, '小红', 85), (3, '小王', 80);
select * from student;

delete from student where score = 85.0;
select * from student;

-- 删除所有数据   
delete from student;

-- 删除操作一旦执行，通过常规手段无法恢复
-- 数据库都会支持一些丰富的“权限控制”，有专门的的运维工程师，或者DBA来负责管理
-- 例如有些数据只能读不能改，有些数据能读能改，不能删除

--删除student表
drop table student;