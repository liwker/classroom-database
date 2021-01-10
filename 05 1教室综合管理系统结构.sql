/*==============================================================*/
/* DBMS name:      MySQL 5.0                                    */
/* Created on:     2021/1/9 18:11:55                            */
/*==============================================================*/


drop table if exists 学生;

drop table if exists 教室;

drop table if exists 教室占用记录;

drop table if exists 教师;

drop table if exists 课程;

drop table if exists 课程安排;

/*==============================================================*/
/* Table: 学生                                                    */
/*==============================================================*/
create table 学生
(
   学号                   varchar(15) not null,
   学生姓名                 varchar(10),
   学生电话                 varchar(15),
   primary key (学号)
);

/*==============================================================*/
/* Table: 教室                                                    */
/*==============================================================*/
create table 教室
(
   教室号                  varchar(10) not null,
   容量                   int not null,
   primary key (教室号)
);

/*==============================================================*/
/* Table: 教室占用记录                                                */
/*==============================================================*/
create table 教室占用记录
(
   教室号                  varchar(10) not null,
   学号                   varchar(15),
   工号                   varchar(15),
   占用周                  int not null,
   占用星期                 int not null,
   占用课时                 int not null,
   占用原因                 varchar(50) not null,
   primary key (教室号, 占用周, 占用星期, 占用课时)
);

/*==============================================================*/
/* Table: 教师                                                    */
/*==============================================================*/
create table 教师
(
   工号                   varchar(15) not null,
   老师姓名                 varchar(10),
   老师电话                 varchar(15),
   primary key (工号)
);

/*==============================================================*/
/* Table: 课程                                                    */
/*==============================================================*/
create table 课程
(
   课程号                  varchar(10) not null,
   课程名                  varchar(20),
   上课人数                 int,
   primary key (课程号)
);

/*==============================================================*/
/* Table: 课程安排                                                  */
/*==============================================================*/
create table 课程安排
(
   课程号                  varchar(10) not null,
   教室号                  varchar(10) not null,
   开始周                  int,
   结束周                  int,
   星期                   int,
   课时                   int,
   primary key (课程号, 教室号)
);

alter table 教室占用记录 add constraint FK_教室占用记录 foreign key (教室号)
      references 教室 (教室号) on delete restrict on update restrict;

alter table 教室占用记录 add constraint FK_教室占用记录2 foreign key (学号)
      references 学生 (学号) on delete restrict on update restrict;

alter table 教室占用记录 add constraint FK_教室占用记录3 foreign key (工号)
      references 教师 (工号) on delete restrict on update restrict;

alter table 课程安排 add constraint FK_课程安排 foreign key (课程号)
      references 课程 (课程号) on delete restrict on update restrict;

alter table 课程安排 add constraint FK_课程安排2 foreign key (教室号)
      references 教室 (教室号) on delete restrict on update restrict;

