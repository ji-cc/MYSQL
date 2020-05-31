use mysql0528;
-- 修改
-- update 表名 set 列名 = 修改的值， 列名= 修改的值 where 子句;
-- a)把小王的数学成绩改成80
select * from  exam_result;
-- 如果不加任何where限定条件，此时就会把所有的记录进行修改
update exam_result set math = 80 ;   -- 不加条件，此处等价于把所有的数学成绩改为80
select * from  exam_result;
-- update每次修改几行记录，不确定。具体取决于where中的条件怎么写，得看where条件过滤之后剩下多少记录
update exam_result set math = 90 where name = '小王';
select * from  exam_result;

-- b)把小李数学成绩改成50分，语文成绩改成95分
update exam_result set math = 50, chinese = 95 where name = '小李';

-- c)所有同学的语文成绩都-10分
update exam_result set chinese = chinese - 10;

-- d)将总成绩倒数三名的同学的数学成绩加10分
update exam_result set math = math + 10 order by chinese + math + english asc limit 3;

-- Rows matched: 3  Changed: 3  Warnings: 0
--  Rows matched: 3  ： where子句匹配到了多少行    Changed: 3 ：真正修改了多少行
-- 一般来说，这两个值会相等，但是如果对应内容为null可能会存在差异











