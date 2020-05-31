-- 约束：数据库针对数据进行一系列的校验。如果发现插入的数据不符合约束中描述的校验规则，就会插入失败，为了更好的保证数据的准确性

-- 约束类型
-- NOT NULL - 指示某列不能存储 NULL 值。
-- UNIQUE - 保证某列的每行必须有唯一的值。
-- DEFAULT - 规定没有给列赋值时的默认值。
-- PRIMARY KEY - NOT NULL 和 UNIQUE 的结合。确保某列（或两个列多个列的结合）有唯一标识，有助于更容易更快速地找到表中的一个特定的记录。
-- FOREIGN KEY - 保证一个表中的数据匹配另一个表中的值的参照完整性。
-- CHECK - 保证列中的值符合指定的条件。对于MySQL数据库，对CHECK子句进行分析，但是忽略CHECK子句





-- 1.not null：该列的所有数据不能为空
create table student(
    id int not null,   -- 表示这一列非空
    name varchar(20),
    scor decimal(3, 1)
);
-- 查看表结构
desc student;     -- id行Null列提示No,表示不能为空
-- insert into student values(null, '小王', 90);   -- 此时会报错：ERROR 1048 (23000): Column 'id' cannot be null
select * from student;





-- 2.unique:该列的所有行的数据是不能重复的
drop table student;
create table student(
    id int unique,    
    name varchar(20),
    scor decimal(3, 1)
);
desc student;   -- id行key列提示UNI，表示不能重复
insert into student values(1, '小王', 90);
insert into student values(2, '小李', 89);
-- insert into student values(1, '小红', 50);   -- 此时会报错：ERROR 1062 (23000): Duplicate entry '1' for key 'id'

drop table student;
create table student(
    id int unique not null,     -- 可以同时使用，等同于primary key的效果
    name varchar(20),
    scor decimal(3, 1)
);





-- 3.default 给列指定默认值
drop table student;
create table student(
    id int not null,   
    name varchar(20) default 'unknow'
);
desc student;  
insert into student (id) values (1);
select * from student;   -- name为默认值‘unknow’





-- 4.primary key主键，等价于not null + unique
drop table student;
create table student(
    id int not null primary key,   
    name varchar(20) 
);
desc student;  
-- insert into student values (null,'小王');
-- 此时报错：ERROR 1048 (23000): Column 'id' cannot be null
insert into student values (1,'小王');
-- insert into student values (1,'小李');
-- 此时报错：ERROR 1062 (23000): Duplicate entry '1' for key 'PRIMARY'


-- 一般建议创建每张表的时候，最好都给这个表指定一个主键
-- 如何保证主键不重复？人工保证不靠谱，可以借助数据库自动来生成
-- auto_increment
-- 自增的特点是：如果表中没有任何记录，自增从1开始
drop table student;
create table student(
    id int primary key auto_increment,
    name varchar(20)
);
desc student;  
insert into student values (10, "小王");
select * from student;
insert into student values (null, "小李");    -- 此时的null会自动变成11
select * from student;
insert into student values (null, "小红");   -- 此时的null会自动变成12
select * from student;

-- 如果是int类型的自增主键，有效范围就是-21亿--> +21亿
-- 如果数据超出范围，再继续自增，就会出现溢出的情况




-- 5.foreign key :描述两张表之间的关联关系
drop table student;
create table class (
    id int primary key auto_increment, 
    name varchar(20)
);
create table student(
    id int primary key auto_increment,
    name varchar(20),
    classId int 
);
desc class; 
desc student;
insert  into class values (null, 'java16');
insert  into class values (null, 'java15');
insert  into class values (null, 'java14');
insert  into class values (null, 'java13');
select * from class;

insert into student values(null, '小红', 1);
select * from student;

insert into student values(null, '小红2', 100);  
-- 此处student表中的classId字段的值，按理说要出现在class表中，才是正确的，
-- 而当前qingk，100不在class表中，但是插入操作仍然成功了
-- 为了让此处的数据校验更严格，就可以使用外键   
select * from student;
-- +----+---------+---------+
-- | id | name    | classId |
-- +----+---------+---------+
-- |  1 | 小红    |       1 |
-- |  2 | 小红2   |     100 |
-- +----+---------+---------+



drop table class;
drop table student;
create table class (
    id int primary key auto_increment, 
    name varchar(20)
);
create table student(
    id int primary key auto_increment,
    name varchar(20),
    classId int,
    foreign key(classId) references class(id)
    -- 设立外键   本表中的classId   指向 class表中的id
);
-- 需要指定三方面的信息
-- 1.指定当前表中哪列进行关联
-- 2.指定和那张表关联
-- 3.指定和目标表中的哪一列关联

-- 后续往student插入数据的时候，
-- MySQL就会自动检查当前classId字段的值是否在class表的id列中出现过
-- 如果没有出现过，就会插入失败
insert  into class values (null, 'java16');
insert  into class values (null, 'java15');
insert  into class values (null, 'java14');
insert  into class values (null, 'java13');
select * from class;
insert into student values(null, '小红', 1);
select * from student;
insert into student values(null, '小李', 2);  

-- insert into student values(null, '小王', 5);
--  此时报错：Cannot add or update a child row: a foreign key constraint fails  

desc student;
-- +---------+-------------+------+-----+---------+----------------+
-- | Field   | Type        | Null | Key | Default | Extra          |
-- +---------+-------------+------+-----+---------+----------------+
-- | id      | int(11)     | NO   | PRI | NULL    | auto_increment |
-- | name    | varchar(20) | YES  |     | NULL    |                |
-- | classId | int(11)     | YES  | MUL | NULL    |                |
-- +---------+-------------+------+-----+---------+----------------+

-- 使用外键，会对插入操作的效率产生一定的影响
-- 外键约束也会影响表的删除

-- class 表被其他表关联着，此时是无法直接删除class表
drop table class;  -- 会报错
-- ERROR 1217 (23000): Cannot delete or update a parent row: a foreign key constraint fails
-- 如果真的把class删了，此时再对student的classId列进行任何操作都是没有意义的



-- check约束
-- mysql使用时不报错，但忽略该约束
desc student;