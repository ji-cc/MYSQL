create database mysql0528;
use mysql0528;
create table exam_result(
    id int,
    name varchar(20),
    chinese decimal(3,1),
    math decimal(3,1),
    english decimal(3,1)
);

insert into exam_result values 
(1, 'my1', 67.8, 78.9, 89.1),
(2, 'my2', 87.5, 78.5, 90),
(3, 'my3', 50, 60, 70),
(4, 'my4', 96, 45, 32),
(5, 'my5', 86, 56.7, 98.5),
(6, 'my6', 89, 74, 82)；

-- 1.全列查找   select * from 表名；
select * from exam_result;
-- 这样的查找方式仅限于在测试环境中使用，不能在生产环境的服务器上执行这样的SQL

-- 2.指定列查找   select 列名 from 表名；
select chinese from exam_result;


-- 3.查询字段为表达式
-- 针对查到的列进行一定的表达式计算
-- eg:(a)查找所有同学的姓名和总成绩   sum是多行数据的和，此处是求多列数据的和
select name, chinese + english + math from exam_result;

-- eg:(b)  查找所有同学的语文成绩，并在基础上 + 10分
select name, chinese + 10 from exam_result;
-- 表达式计算得到的结果类型不一定和原来的列的类型完全一致，会尽可能保证数据正确的

-- 4.查询字段指定别名  
-- 把列指定了别名total, as可以省略
select name, chinese + math + english as total from exam_result;


insert into exam_result values
(7, '小王', 98, 56, 53);

-- 5.去重  去重查找得到结果表的行数和原来可能不一样
-- 大部分的select操作的查找结果是无法和原来的表的记录一一对应的
-- 把chinese重复的成绩去掉
select distinct chinese from exam_result;

--去重也能指定多列来去重
-- 此时就是要求指定的列都完全相同才会被合并在一起
insert into exam_result values
(7, '小李', 98, 54, 30);
select distinct chinese, math from exam_result; 
-- 使用distinct 时，必须把对应的列都放到distinct之后

-- 所有的select操作都不会对原来的表造成任何改变，基于原来的表，生成结果表
-- 要想修改，insert,update,delete

-- 6.排序
-- order by 指定针对那个列进行排序
-- asc升序   desc降序
-- a)查找同学们的信息并且按照数学成绩升序排序   asc不写也是升序
select * from exam_result order by math asc;
-- b)查找同学们的信息并且按照数学成绩降序排序
select * from exam_result order by math desc;
-- c)查找同学们的信息并且按照总成绩成绩降序排序
select name, chinese + math + english from exam_result order by chinese + math + english  desc;
-- d)查找同学们的信息并且按照总成绩成绩排序,使用别名
 select name, chinese + math + english as total from exam_result order by total desc;
-- e) 按照多个列来排序
-- 先把所有同学的信息按照语文降序排序，再按照数学降序排序，在按照英语降序排序
-- 越靠前优先级越高，如果语文的分数一样，就按照数学排序；如果语文数学都一样，就按照英语排序
select * from exam_result order by chinese desc, math desc, english desc;
-- NULL 认为是最小的值

-- 7.条件查询（特别重要）
-- 比较运算符
-- >     >=   <      <=
-- =:比较相等，而不是赋值   （update中的= 相当于赋值）    
--       如果表达式 NULL = NULL ------>NULL 相当于条件不成立  
-- <=>:比较相等，能够针对NULL进行比较
--       如果表达式 NULL <=> NULL ------>true  相当于条件成立
-- !=   <>  :都表示不等于
-- between x and y:表示当值在[x,y]闭区间都是满足条件
-- in(若干选项):当前值在（）中的若干选项里匹配任意一个都是满足条件
-- is null：是NULL
-- is not null :不是null
-- like:模糊匹配
-- 逻辑运算符
-- and:逻辑与
-- or:逻辑或
-- not:逻辑取反

insert into exam_result values
(7, '小赵', null, null, null);

-- a) 查找数据中chinese为null的记录
--    select * from exam_result where chinese = null  错误写法：null=null，结果是false
select * from exam_result where chinese <=> null
select * from exam_result where chinese is null;

-- b)查找英语成绩不及格的同学（<60)
select * from exam_result where english < 60;

-- c)查找英语成绩比英语好的同学信息
select * from exam_result where chinese > english;

-- d)查找总分在200分一下的同学
-- select name, chinese + math + english as total from exam_result where total < 200;   错误写法：where中不能使用别名
select name, chinese + math + english as total from exam_result where chinese + math + english < 200;  

-- e) 查询语文成绩大于80并且英语也大于80的同学
-- and 和 or 如果同时出现，and的优先级更高一些，建议加上适当的括号
select * from exam_result where chinese > 80 and english > 80;

-- f) 查询语文大于80 或者英语大于80的同学
select * from exam_result where chinese > 80 or english > 80;

-- g) 查询语文成绩在[80，90]之间的同学
select * from exam_result where chinese between 80 and 90;
select * from exam_result where chinese  >= 80 and chinese <= 90;

-- h)查询数学成绩是45.0或者60.0或者90.0的
select * from exam_result where math in (45.0,60.0,90.0);
select * from exam_result where math = 45.0 or math = 60.0 or math = 90.0;

-- like操作要搭配通配符来使用    模糊匹配查询效率相对较低，一般不太建议使用like
-- like不仅仅能针对字符串进行匹配，也能针对数字进行匹配
-- %：匹配任意个任意字符
-- _:匹配一个任意字符
 
-- i) 查找所有性小的同学的成绩
select * from exam_result where name like '小%';
insert into exam_result values
(8, '小李李', 56, 89, 30);
select * from exam_result where name like '小__';     -- 一个下划线匹配一个字符


-- g) 查找语文成绩是9开头的
select * from exam_result where chinese like '9%';    

-- 进行复杂条件查询的时候存在最左原则
-- 先后顺序不影响最终结果，但是建议把name like 这个条件放在左边
-- k)查找所有同学中姓小 并且语文成绩大于60的同学
-- 先针对第一个条件，遍历表中的所有记录，最终保留8条记录，再遍历剩下的八条记录，留下满足第二个条件的记录
select * from exam_result where chinese > 60 and name like '小%';
-- 先针对第一个条件，遍历表中所有记录，最终保留4条记录，再遍历这2条记录，留下满足第二个条件的记录
select * from exam_result where name like '小%' and chinese > 60;   -- 更推荐的表达方式（更高效）
-- 多个天剑在一起联合生效时，一般要求哪个条件能过滤掉的数据多（剩下的数据少），就把该条件放到左侧

-- 上面的这些select操作，除了条件查找之外，剩下的都是不应该在生产服务器上直接执行



-- 8.分页查找
-- a) 查找同学信息总分最高的前3名
select name, chinese + math + english as total from exam_result order by total desc;
select name, chinese + math + english as total from exam_result order by total desc limit 3;

-- b) 查找同学信息中总分最高的第4-6名
-- offset 3:从下标为3的位置开始往后找
select name, chinese + math + english as total from exam_result order by total desc limit 3 offset 3;

-- c) 如果limit后面的数字太大，超出记录的数目，返回结果不会有任何错误
select name, chinese + math + english as total from exam_result order by total desc limit 3 offset 1000;

-- d) 如果offset过大，得到的结果可能是一个空的结果










