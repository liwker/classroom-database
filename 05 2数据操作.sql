DROP DATABASE 教室综合管理系统;

CREATE DATABASE 教室综合管理系统;
USE 教室综合管理系统;

-- 插入数据

INSERT INTO 学生 VALUES('S005','陈边','18080808000');
INSERT INTO 学生 VALUES('S001','刘三','18080808001');
INSERT INTO 学生 VALUES('S002','李聪','18080808002');
INSERT INTO 学生 VALUES('S003','赵海','18080808003');
INSERT INTO 学生 VALUES('S004','王海','18080808004');

INSERT INTO 教师 VALUES('T001','宋晓梅','17021954593');
INSERT INTO 教师 VALUES('T002','罗云霄','17021954593');
INSERT INTO 教师 VALUES('T003','李四','17022544593');
INSERT INTO 教师 VALUES('T004','王明','17021947593');
INSERT INTO 教师 VALUES('T005','陈欢','17021951293');

INSERT INTO 教室 VALUES('10A303',100);
INSERT INTO 教室 VALUES('10A201',90);
INSERT INTO 教室 VALUES('10A202',100);
INSERT INTO 教室 VALUES('10A203',100);
INSERT INTO 教室 VALUES('10A204',90);
INSERT INTO 教室 VALUES('10A301',100);
INSERT INTO 教室 VALUES('10A302',100);



INSERT INTO 课程 VALUES('C001','网络营销',90);
INSERT INTO 课程 VALUES('C002','C语言程序设计',120);
INSERT INTO 课程 VALUES('C003','java面向对象程序设计',95);
INSERT INTO 课程 VALUES('C004','C++面向对象程序设计',80);
INSERT INTO 课程 VALUES('C005','编译原理',123);
INSERT INTO 课程 VALUES('C006','计算机组成原理',90);
INSERT INTO 课程 VALUES('C007','操作系统',92);

INSERT INTO 课程安排 VALUES('C001','10A201',1,17,1,1112);
INSERT INTO 课程安排 VALUES('C002','10A202',1,18,2,910);
INSERT INTO 课程安排 VALUES('C006','10A202',1,18,2,34);
INSERT INTO 课程安排 VALUES('C003','10A201',1,15,3,12);
INSERT INTO 课程安排 VALUES('C004','10A204',1,18,4,34);
INSERT INTO 课程安排 VALUES('C007','10A204',1,18,4,12);
INSERT INTO 课程安排 VALUES('C005','10A301',1,18,5,56);
INSERT INTO 课程安排 VALUES('C007','10A301',1,18,5,12);
INSERT INTO 课程安排 VALUES('C002','10A301',1,18,7,910);


INSERT INTO 教室占用记录 VALUES('10A302','S005',NULL,17,1,1112,'开班会');
INSERT INTO 教室占用记录 VALUES('10A302','S001',NULL,18,1,910,'宣传部例会');
INSERT INTO 教室占用记录 VALUES('10A201','S002',NULL,5,7,1112,'团日活动');
INSERT INTO 教室占用记录 VALUES('10A201','S002',NULL,5,7,910,'自习');
INSERT INTO 教室占用记录 VALUES('10A201',NULL,NULL,20,7,12,'考试');
INSERT INTO 教室占用记录 VALUES('10A201',NULL,NULL,20,7,34,'考试');
INSERT INTO 教室占用记录 VALUES('10A201',NULL,NULL,20,7,56,'考试');
INSERT INTO 教室占用记录 VALUES('10A201',NULL,NULL,20,6,12,'考试');
INSERT INTO 教室占用记录 VALUES('10A201',NULL,NULL,20,6,34,'考试');
INSERT INTO 教室占用记录 VALUES('10A201',NULL,NULL,20,6,56,'考试');
INSERT INTO 教室占用记录 VALUES('10A201',NULL,NULL,20,5,12,'考试');
INSERT INTO 教室占用记录 VALUES('10A201',NULL,NULL,20,5,34,'考试');
INSERT INTO 教室占用记录 VALUES('10A201',NULL,NULL,20,5,56,'考试');
INSERT INTO 教室占用记录 VALUES('10A201',NULL,NULL,19,7,12,'维修');
INSERT INTO 教室占用记录 VALUES('10A202',NULL,NULL,20,7,34,'维修');
INSERT INTO 教室占用记录 VALUES('10A203',NULL,NULL,20,7,56,'维修');
INSERT INTO 教室占用记录 VALUES('10A204',NULL,NULL,20,6,12,'维修');
INSERT INTO 教室占用记录 VALUES('10A302',NULL,NULL,20,6,34,'维修');
INSERT INTO 教室占用记录 VALUES('10A301',NULL,NULL,20,6,56,'维修');
INSERT INTO 教室占用记录 VALUES('10A202',NULL,NULL,20,5,12,'维修');
INSERT INTO 教室占用记录 VALUES('10A202',NULL,NULL,20,5,34,'维修');
INSERT INTO 教室占用记录 VALUES('10A202',NULL,NULL,20,5,56,'维修');


-- 问题测试

-- 王德发同学要借用10A301教室，时间为17周星期5下午78节课，他的学号为S065，电话为15368458821。
INSERT INTO 学生 VALUES('S065','王德发','15368458821');
INSERT INTO 教室占用记录 VALUES('10A301','S065',NULL,17,5,78,'无');

-- 查询所有被考试占用的教室
SELECT * FROM 教室占用记录 WHERE 占用原因 = '考试';

-- 查询第19周的有哪些教室在维修。
SELECT 教室号 FROM 教室占用记录 WHERE 占用周=19 AND 占用原因 = '维修';

-- 查询课程名为C语言程序设计的课程在哪个教室上课
SELECT 教室号 FROM 课程安排 WHERE 课程号 IN(SELECT 课程号 FROM 课程 WHERE 课程名='C语言程序设计');

-- 网络营销所在的教室，在第17周时，有哪些时间被占用
SELECT 占用星期,占用课时 FROM 教室占用记录 WHERE 占用周 =17 AND 教室号 IN (SELECT 教室号 FROM 课程安排 WHERE 课程号 =(SELECT 课程号 FROM 课程 WHERE 课程名='网络营销'))
UNION
SELECT 星期 AS 占用星期, 课时 AS 占用课时 FROM 课程安排 WHERE 教室号 IN (SELECT 教室号 FROM 课程安排 WHERE 课程号 =(SELECT 课程号 FROM 课程 WHERE 课程名='网络营销')) AND 开始周<=17 AND 结束周>=17;

-- 查询在第5周星期7晚上910节课，容量>90的空闲教室有哪些。
SELECT 教室号 FROM  教室 WHERE   容量 >90 AND 教室号 NOT IN (SELECT 教室号 FROM 教室占用记录 WHERE 占用周 =5 AND 占用星期 =7 AND 占用课时=910 )AND 教室号 NOT IN (SELECT 教室号 FROM 课程安排 WHERE 开始周<=5 AND 结束周>=5 AND 星期=7 AND 课时=910);

-- 查询第17周星期1，3-4节课期间有哪些教室空闲。
SELECT 教室号 FROM  教室 WHERE  教室号 NOT IN (SELECT 教室号 FROM 教室占用记录 WHERE 占用周 =17 AND 占用星期 =1 AND 占用课时=34 ) AND 教室号 NOT IN (SELECT 教室号 FROM 课程安排 WHERE 开始周<=17 AND 结束周>=17 AND 星期=1 AND 课时=34);

-- 查询教室10A204在第17周所有因课程占用的时间。
SELECT 星期 AS 占用星期, 课时 AS 占用课时 FROM 课程安排 WHERE 教室号="10A204" AND 开始周<=17 AND 结束周>=17;

-- 查询第20周10A201的考试占用情况。
SELECT 占用周, 占用星期, 占用课时 FROM 教室占用记录 WHERE 教室号 = '10A201' AND 占用原因 = '考试';

-- 谢特老师要借用10A301教室，时间为15周星期4下午56节课，他的工号为T006，电话为16868593521。
INSERT INTO 教师 VALUES('T006','谢特','16868593521');
INSERT INTO 教室占用记录 VALUES('10A301',NULL,'T006',15,4,56,'无');



-- 触发器 -- 教室占用申请
DELIMITER ;
DELIMITER $$

CREATE TRIGGER lease_ins_chk BEFORE INSERT
  ON 教室占用记录
  FOR EACH ROW
BEGIN
-- 检查是否存在此教室
  IF new.教室号 NOT IN (SELECT 教室号 FROM 教室) THEN
    signal SQLSTATE "HY000"
    SET message_text = "添加失败，不存在此教室号！";
  END IF;
  
-- 若有学生号，则检查是否存在此学生号
  IF new.学号 IS NOT NULL AND new.学号 NOT IN (SELECT 学号 FROM 学生 WHERE 学号=new.学号) THEN
    signal SQLSTATE "HY000"
    SET message_text = "添加失败，不存在此学生号！";
  END IF;
  
-- 若有工号，则检查是否存在此工号
  IF new.工号 IS NOT NULL AND new.工号 NOT IN (SELECT 工号 FROM 教师 WHERE 工号=new.工号) THEN
    signal SQLSTATE "HY000"
    SET message_text = "添加失败，不存在此工号！";
  END IF;
  
-- 检查此教室是否被占用
  IF new.教室号 IN (SELECT 教室号 FROM 教室占用记录 WHERE new.占用周=占用周 AND new.占用星期=占用星期 AND new.占用课时=占用课时
                    UNION SELECT 教室号 FROM 课程安排 WHERE 开始周<=new.占用周 AND 结束周>=new.占用周 AND new.占用星期=星期 AND new.占用课时=课时)
  THEN
    signal SQLSTATE "HY000"
    SET message_text = "添加失败，此教室于此时刻被占用！";
  END IF;
  
END$$



-- 触发器测试

INSERT INTO 教室占用记录
VALUES("10A201", NULL, NULL, 1, 7, 1112, "自习");

INSERT INTO 教室占用记录
VALUES("10A201", "S001", "T001", 1, 6, 1112, "补习");

INSERT INTO 教室占用记录
VALUES("10A201", "S666", NULL, 1, 7, 1112, "自习");

INSERT INTO 教室占用记录
VALUES("10A201", NULL, "T666", 1, 7, 1112, "自习");

INSERT INTO 教室占用记录
VALUES("10A201", NULL, NULL, 1, 7, 1112, "自习");

INSERT INTO 教室占用记录
VALUES("10A201", NULL, NULL, 17, 1, 1112, "自习");






