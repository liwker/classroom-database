/*
SQLyog Ultimate v12.08 (64 bit)
MySQL - 5.5.61-log : Database - 教室综合管理系统
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`教室综合管理系统` /*!40100 DEFAULT CHARACTER SET utf8 */;

USE `教室综合管理系统`;

/*Table structure for table `学生` */

DROP TABLE IF EXISTS `学生`;

CREATE TABLE `学生` (
  `学号` varchar(15) NOT NULL,
  `学生姓名` varchar(10) DEFAULT NULL,
  `学生电话` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`学号`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `学生` */

insert  into `学生`(`学号`,`学生姓名`,`学生电话`) values ('S001','刘三','18080808001'),('S002','李聪','18080808002'),('S003','赵海','18080808003'),('S004','王海','18080808004'),('S005','陈边','18080808000');

/*Table structure for table `教室` */

DROP TABLE IF EXISTS `教室`;

CREATE TABLE `教室` (
  `教室号` varchar(10) NOT NULL,
  `容量` int(11) NOT NULL,
  PRIMARY KEY (`教室号`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `教室` */

insert  into `教室`(`教室号`,`容量`) values ('10A201',90),('10A202',100),('10A203',100),('10A204',90),('10A301',100),('10A302',100),('10A303',100);

/*Table structure for table `教室占用记录` */

DROP TABLE IF EXISTS `教室占用记录`;

CREATE TABLE `教室占用记录` (
  `教室号` varchar(10) NOT NULL,
  `学号` varchar(15) DEFAULT NULL,
  `工号` varchar(15) DEFAULT NULL,
  `占用周` int(11) NOT NULL,
  `占用星期` int(11) NOT NULL,
  `占用课时` int(11) NOT NULL,
  `占用原因` varchar(50) NOT NULL,
  PRIMARY KEY (`教室号`,`占用周`,`占用星期`,`占用课时`),
  KEY `FK_教室占用记录2` (`学号`),
  KEY `FK_教室占用记录3` (`工号`),
  CONSTRAINT `FK_教室占用记录3` FOREIGN KEY (`工号`) REFERENCES `教师` (`工号`),
  CONSTRAINT `FK_教室占用记录` FOREIGN KEY (`教室号`) REFERENCES `教室` (`教室号`),
  CONSTRAINT `FK_教室占用记录2` FOREIGN KEY (`学号`) REFERENCES `学生` (`学号`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `教室占用记录` */

insert  into `教室占用记录`(`教室号`,`学号`,`工号`,`占用周`,`占用星期`,`占用课时`,`占用原因`) values ('10A201','S001','T001',1,6,1112,'补习'),('10A201',NULL,NULL,1,7,1112,'自习'),('10A201','S002',NULL,5,7,910,'自习'),('10A201','S002',NULL,5,7,1112,'团日活动'),('10A201',NULL,NULL,19,7,12,'维修'),('10A201',NULL,NULL,20,5,12,'考试'),('10A201',NULL,NULL,20,5,34,'考试'),('10A201',NULL,NULL,20,5,56,'考试'),('10A201',NULL,NULL,20,6,12,'考试'),('10A201',NULL,NULL,20,6,34,'考试'),('10A201',NULL,NULL,20,6,56,'考试'),('10A201',NULL,NULL,20,7,12,'考试'),('10A201',NULL,NULL,20,7,34,'考试'),('10A201',NULL,NULL,20,7,56,'考试'),('10A202',NULL,NULL,20,5,12,'维修'),('10A202',NULL,NULL,20,5,34,'维修'),('10A202',NULL,NULL,20,5,56,'维修'),('10A202',NULL,NULL,20,7,34,'维修'),('10A203',NULL,NULL,20,7,56,'维修'),('10A204',NULL,NULL,20,6,12,'维修'),('10A301',NULL,NULL,20,6,56,'维修'),('10A302','S005',NULL,17,1,1112,'开班会'),('10A302','S001',NULL,18,1,910,'宣传部例会'),('10A302',NULL,NULL,20,6,34,'维修');

/*Table structure for table `教师` */

DROP TABLE IF EXISTS `教师`;

CREATE TABLE `教师` (
  `工号` varchar(15) NOT NULL,
  `老师姓名` varchar(10) DEFAULT NULL,
  `老师电话` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`工号`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `教师` */

insert  into `教师`(`工号`,`老师姓名`,`老师电话`) values ('T001','宋晓梅','17021954593'),('T002','罗云霄','17021954593'),('T003','李四','17022544593'),('T004','王明','17021947593'),('T005','陈欢','17021951293');

/*Table structure for table `课程` */

DROP TABLE IF EXISTS `课程`;

CREATE TABLE `课程` (
  `课程号` varchar(10) NOT NULL,
  `课程名` varchar(20) DEFAULT NULL,
  `上课人数` int(11) DEFAULT NULL,
  PRIMARY KEY (`课程号`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `课程` */

insert  into `课程`(`课程号`,`课程名`,`上课人数`) values ('C001','网络营销',90),('C002','C语言程序设计',120),('C003','java面向对象程序设计',95),('C004','C++面向对象程序设计',80),('C005','编译原理',123),('C006','计算机组成原理',90),('C007','操作系统',92);

/*Table structure for table `课程安排` */

DROP TABLE IF EXISTS `课程安排`;

CREATE TABLE `课程安排` (
  `课程号` varchar(10) NOT NULL,
  `教室号` varchar(10) NOT NULL,
  `开始周` int(11) DEFAULT NULL,
  `结束周` int(11) DEFAULT NULL,
  `星期` int(11) DEFAULT NULL,
  `课时` int(11) DEFAULT NULL,
  PRIMARY KEY (`课程号`,`教室号`),
  KEY `FK_课程安排2` (`教室号`),
  CONSTRAINT `FK_课程安排2` FOREIGN KEY (`教室号`) REFERENCES `教室` (`教室号`),
  CONSTRAINT `FK_课程安排` FOREIGN KEY (`课程号`) REFERENCES `课程` (`课程号`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `课程安排` */

insert  into `课程安排`(`课程号`,`教室号`,`开始周`,`结束周`,`星期`,`课时`) values ('C001','10A201',1,17,1,1112),('C002','10A202',1,18,2,910),('C002','10A301',1,18,7,910),('C003','10A201',1,15,3,12),('C004','10A204',1,18,4,34),('C005','10A301',1,18,5,56),('C006','10A202',1,18,2,34),('C007','10A204',1,18,4,12),('C007','10A301',1,18,5,12);

/* Trigger structure for table `教室占用记录` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `lease_ins_chk` */$$

/*!50003 CREATE */ /*!50017 DEFINER = 'root'@'localhost' */ /*!50003 TRIGGER `lease_ins_chk` BEFORE INSERT ON `教室占用记录` FOR EACH ROW BEGIN
-- 检查是否存在此教室
  IF new.教室号 not in (select 教室号 from 教室) THEN
    signal SQLSTATE "HY000"
    SET message_text = "添加失败，不存在此教室号！";
  END IF;
  
-- 若有学生号，则检查是否存在此学生号
  IF new.学号 is not NULL and new.学号 not in (select 学号 from 学生 where 学号=new.学号) then
    signal sqlstate "HY000"
    set message_text = "添加失败，不存在此学生号！";
  end if;
  
-- 若有工号，则检查是否存在此工号
  IF new.工号 IS NOT NULL AND new.工号 NOT IN (SELECT 工号 FROM 教师 WHERE 工号=new.工号) THEN
    signal SQLSTATE "HY000"
    SET message_text = "添加失败，不存在此工号！";
  END IF;
  
-- 检查此教室是否被占用
  if new.教室号 in (select 教室号 from 教室占用记录 where new.占用周=占用周 and new.占用星期=占用星期 and new.占用课时=占用课时
                    union select 教室号 from 课程安排 where 开始周<=new.占用周 and 结束周>=new.占用周 and new.占用星期=星期 and new.占用课时=课时)
  then
    signal sqlstate "HY000"
    set message_text = "添加失败，此教室于此时刻被占用！";
  end if;
  
END */$$


DELIMITER ;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
