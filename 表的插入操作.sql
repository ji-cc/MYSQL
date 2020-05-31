create database mysql0526;
use mysql0526;

create table student (
    id int,
    name varchar(20),
    score decimal(3, 1),
    email varchar(50)
);
-- 插入数据
insert into student values(1, 'test', 98.5, 'test@qq.com');

-- 查看数据
select * from student;
-- 插入指定列
insert into student (id, name) values (2, 'test2');