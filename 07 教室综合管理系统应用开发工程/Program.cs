using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using MySql.Data.MySqlClient;

namespace 教室综合管理系统
{
    class Program
    {
        static void Main(string[] args)
        {
            //showLease();
            //showNotLeaseRoom();
            borrowClass();
        }

        // 查询所有教室借用记录
        static void showLease()
        {
            // 连接数据库
            string conStr = "server=localhost;user=root;database=教室综合管理系统;password=1110";
            MySqlConnection con = new MySqlConnection(conStr);
            con.Open();
            MySqlCommand cmd = new MySqlCommand();
            cmd.Connection = con;
            cmd.CommandType = System.Data.CommandType.Text;

            cmd.CommandText = "SELECT * FROM 教室占用记录;";
            MySqlDataAdapter adapter = new MySqlDataAdapter(cmd);
            DataSet ds = new DataSet();
            int n = adapter.Fill(ds);

            if(ds.Tables[0].Rows.Count > 0)
            {
                for (int i = 0; i< ds.Tables[0].Rows.Count; i++)
                {
                    System.Console.WriteLine("教室号: {0}", ds.Tables[0].Rows[i]["教室号"]);
                    System.Console.WriteLine("学号: {0}", ds.Tables[0].Rows[i]["学号"]);
                    System.Console.WriteLine("工号: {0}", ds.Tables[0].Rows[i]["工号"]);
                    System.Console.WriteLine("占用周: {0}", ds.Tables[0].Rows[i]["占用周"]);
                    System.Console.WriteLine("占用星期: {0}", ds.Tables[0].Rows[i]["占用星期"]);
                    System.Console.WriteLine("占用课时: {0}", ds.Tables[0].Rows[i]["占用课时"]);
                    System.Console.WriteLine("占用原因: {0}", ds.Tables[0].Rows[i]["占用原因"]);
                    System.Console.WriteLine("\n");
                }
                System.Console.WriteLine("总共有 " + n + " 条教室借用记录：");
                System.Console.WriteLine("\n");
            }
            else
            {
                System.Console.WriteLine("目前还没有教室借用记录！");
            }
            con.Close();
        }

        // 查询某时间某容量哪些有空闲的教室
        static void showNotLeaseRoom()
        {
            int lease_week = 0, lease_day = 0, lease_course_time = 0, seats = 0;
            string temp = "";
            // 连接数据库
            string conStr = "server=localhost;user=root;database=教室综合管理系统;password=1110";
            MySqlConnection con = new MySqlConnection(conStr);
            con.Open();
            MySqlCommand cmd = new MySqlCommand();
            cmd.Connection = con;
            cmd.CommandType = System.Data.CommandType.Text;

            // 查询时间
            Console.WriteLine("查询多少周：");
            temp = Console.ReadLine();
            if(temp == "")
                lease_week = 0;
            else
                lease_week = Convert.ToInt32(temp);
            while (lease_week < 1 || lease_week > 20)
            {
                Console.WriteLine("周数输入错误，请重新输入：");
                temp = Console.ReadLine();
                if (temp == "")
                    lease_week = 0;
                else
                    lease_week = Convert.ToInt32(temp);
            }

            Console.WriteLine("查询星期几：");
            temp = Console.ReadLine();
            if (temp == "")
                lease_day = 0;
            else
                lease_day = Convert.ToInt32(temp);
            while (lease_day < 1 || lease_day > 7)
            {
                Console.WriteLine("星期输入错误，请重新输入：");
                temp = Console.ReadLine();
                if (temp == "")
                    lease_day = 0;
                else
                    lease_day = Convert.ToInt32(temp);
            }

            Console.WriteLine("查询多少课时：");
            temp = Console.ReadLine();
            if (temp == "")
                lease_course_time = 0;
            else
                lease_course_time = Convert.ToInt32(temp);
            while (lease_course_time != 12 && lease_course_time != 34 && lease_course_time != 56 && lease_course_time != 78 && lease_course_time != 910 && lease_course_time != 1112)
            {
                Console.WriteLine("课时输入错误，请重新输入：");
                temp = Console.ReadLine();
                if (temp == "")
                    lease_course_time = 0;
                else
                    lease_course_time = Convert.ToInt32(temp);
            }

            Console.WriteLine("查询多少容量（可选填）：");
            temp = Console.ReadLine();
            if (temp == "")
                seats = 0;
            else
                seats = Convert.ToInt32(temp);
            while (seats < 0)
            {
                Console.WriteLine("容量有误，请重新输入：");
                temp = Console.ReadLine();
                if (temp == "")
                    seats = 0;
                else
                    seats = Convert.ToInt32(temp);
            }

            cmd.CommandText = "SELECT 教室号 FROM  教室 WHERE 容量>@seats AND 教室号 NOT IN (SELECT 教室号 FROM 教室占用记录 WHERE 占用周=@lease_week AND 占用星期=@lease_day AND 占用课时=@lease_course_time) AND 教室号 NOT IN (SELECT 教室号 FROM 课程安排 WHERE 开始周<=@lease_week AND 结束周>=@lease_week AND 星期=@lease_day AND 课时=@lease_course_time);";
            cmd.Parameters.AddWithValue("@seats", seats);
            cmd.Parameters.AddWithValue("@lease_week", lease_week);
            cmd.Parameters.AddWithValue("@lease_day", lease_day);
            cmd.Parameters.AddWithValue("@lease_course_time", lease_course_time);

            MySqlDataAdapter adapter = new MySqlDataAdapter(cmd);
            DataSet ds = new DataSet();
            adapter.Fill(ds);
            if (ds.Tables[0].Rows.Count > 0)
            {
                System.Console.WriteLine("找到在第" + lease_week + "周 星期" + lease_day + " " + lease_course_time + "节课时 并且容量大于"+seats+" 的空闲教室了：");
                for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
                {
                    System.Console.WriteLine("教室号: {0}", ds.Tables[0].Rows[i]["教室号"]);
                }
                System.Console.WriteLine("\n");
            }
            else
            {
                System.Console.WriteLine("第"+lease_week+"周 星期"+ lease_day+" "+lease_course_time+"课时，没有空闲教室！");
                System.Console.WriteLine("\n");
            }

            con.Close();
        }

        // 申请借用教室
        static void borrowClass() {
            // 连接数据库
            string conStr = "server=localhost;user=root;database=教室综合管理系统;password=1110";
            MySqlConnection con = new MySqlConnection(conStr);
            con.Open();

            // 声明变量
            string classroom_id = "", student_id = "", teacher_id = "", lease_reason = "", temp = "";
            int lease_week = 0, lease_day = 0, lease_course_time = 0;

            // 申请占用教室
            Console.WriteLine("申请占用教室：");
            classroom_id = Console.ReadLine();

            MySqlCommand cmd1 = new MySqlCommand();
            cmd1.Connection = con;
            cmd1.CommandType = System.Data.CommandType.Text;
            // 获取已有的教室号
            cmd1.CommandText = "select 教室号 from 教室";
            MySqlDataAdapter adapter1 = new MySqlDataAdapter(cmd1);
            DataSet ds1 = new DataSet();
            adapter1.Fill(ds1);
            // 是否存在教室号
            for (int i = 0; i < ds1.Tables[0].Rows.Count; i++)
            {
                if (classroom_id == (string)ds1.Tables[0].Rows[i]["教室号"])
                    break;
                else if (i + 1 == ds1.Tables[0].Rows.Count)
                {
                    Console.WriteLine("无此教室，请重新输入：");
                    classroom_id = Console.ReadLine();
                    i = -1;
                }
            }

            // 申请者学号
            Console.WriteLine("申请者学号（可选填）：");
            student_id = Console.ReadLine();

            if(student_id != "") { 
                MySqlCommand cmd2 = new MySqlCommand();
                cmd2.Connection = con;
                cmd2.CommandType = System.Data.CommandType.Text;
                // 先获取已有的学生的学号
                cmd2.CommandText = "select 学号 from 学生";
                MySqlDataAdapter adapter2 = new MySqlDataAdapter(cmd2);
                DataSet ds2 = new DataSet();
                adapter2.Fill(ds2);
                // 是否存在学生
                for (int i = 0; i < ds2.Tables[0].Rows.Count; i++)
                {
                    if (student_id == (string)ds2.Tables[0].Rows[i]["学号"])
                        break;
                    else if (i + 1 == ds2.Tables[0].Rows.Count)
                    {
                        Console.WriteLine("无此学生号，请重新输入：");
                        student_id = Console.ReadLine();
                        i = -1;
                    }
                }
            }

            // 申请者工号
            Console.WriteLine("申请者工号（可选填）：");
            teacher_id = Console.ReadLine();
            if(teacher_id != "") {
                MySqlCommand cmd3 = new MySqlCommand();
                cmd3.Connection = con;
                cmd3.CommandType = System.Data.CommandType.Text;
                // 先获取已有的工号
                cmd3.CommandText = "select 工号 from 教师";
                MySqlDataAdapter adapter3 = new MySqlDataAdapter(cmd3);
                DataSet ds3 = new DataSet();
                adapter3.Fill(ds3);
                // 是否存在此工号
                for (int i = 0; i < ds3.Tables[0].Rows.Count; i++)
                {
                    if (teacher_id == (string)ds3.Tables[0].Rows[i]["工号"])
                        break;
                    else if (i + 1 == ds3.Tables[0].Rows.Count)
                    {
                        Console.WriteLine("无此工号，请重新输入：");
                        teacher_id = Console.ReadLine();
                        i = -1;
                    }
                }
            }

            // 申请时间
            Console.WriteLine("申请多少周：");
            temp = Console.ReadLine();
            if (temp == "")
                lease_week = 0;
            else
                lease_week = Convert.ToInt32(temp);
            while (lease_week < 1 || lease_week > 20)
            {
                Console.WriteLine("周数输入错误，请重新输入：");
                temp = Console.ReadLine();
                if (temp == "")
                    lease_week = 0;
                else
                    lease_week = Convert.ToInt32(temp);
            }

            Console.WriteLine("申请星期几：");
            temp = Console.ReadLine();
            if (temp == "")
                lease_day = 0;
            else
                lease_day = Convert.ToInt32(temp);
            while (lease_day < 1 || lease_day > 7)
            {
                Console.WriteLine("星期输入错误，请重新输入：");
                temp = Console.ReadLine();
                if (temp == "")
                    lease_day = 0;
                else
                    lease_day = Convert.ToInt32(temp);
            }

            Console.WriteLine("申请多少课时：");
            temp = Console.ReadLine();
            if (temp == "")
                lease_course_time = 0;
            else
                lease_course_time = Convert.ToInt32(temp);
            while (lease_course_time != 12 && lease_course_time != 34 && lease_course_time != 56 && lease_course_time != 78 && lease_course_time != 910 && lease_course_time != 1112)
            {
                Console.WriteLine("课时输入错误，请重新输入：");
                temp = Console.ReadLine();
                if (temp == "")
                    lease_course_time = 0;
                else
                    lease_course_time = Convert.ToInt32(temp);
            }

            // 教室是否被占用
            int f = 0;
            do
            {
                if (f != 0)
                {
                    Console.WriteLine("此教室于此时被占用，请重新输入时间\n");
                    Console.WriteLine("申请多少周：");
                    lease_week = Convert.ToInt32(Console.ReadLine());
                    while (lease_week < 1 && lease_week > 20)
                    {
                        Console.WriteLine("周数输入错误，请重新输入：");
                        lease_week = Convert.ToInt32(Console.ReadLine());
                    }
                    Console.WriteLine("申请星期几：");
                    lease_day = Convert.ToInt32(Console.ReadLine());
                    while (lease_day < 1 && lease_day > 7)
                    {
                        Console.WriteLine("星期输入错误，请重新输入：");
                        lease_day = Convert.ToInt32(Console.ReadLine());
                    }
                    Console.WriteLine("申请多少课时：");
                    lease_course_time = Convert.ToInt32(Console.ReadLine());
                    while (lease_course_time != 12 && lease_course_time != 34 && lease_course_time != 56 && lease_course_time != 78 && lease_course_time != 910 && lease_course_time != 1112)
                    {
                        Console.WriteLine("课时输入错误，请重新输入：");
                        lease_course_time = Convert.ToInt32(Console.ReadLine());
                    }
                }
                MySqlCommand cmd4 = new MySqlCommand();
                cmd4.Connection = con;
                cmd4.CommandType = System.Data.CommandType.Text;

                cmd4.CommandText = "SELECT 教室号 FROM 教室占用记录 WHERE @classroom_id=教室号 AND @lease_week=占用周 AND @lease_day=占用星期 AND @lease_course_time=占用课时 UNION SELECT 教室号 FROM 课程安排 WHERE @classroom_id=教室号 AND 开始周<=@lease_week AND 结束周>=@lease_week AND @lease_day=星期 AND @lease_course_time=课时";
                cmd4.Parameters.AddWithValue("@classroom_id", classroom_id);
                cmd4.Parameters.AddWithValue("@lease_week", lease_week);
                cmd4.Parameters.AddWithValue("@lease_day", lease_day);
                cmd4.Parameters.AddWithValue("@lease_course_time", lease_course_time);

                MySqlDataAdapter adapter4 = new MySqlDataAdapter(cmd4);
                DataSet ds4 = new DataSet();
                f = adapter4.Fill(ds4);
            } while (f>0);


            // 申请原因
            Console.WriteLine("申请原因（可选填）：");
            temp = Console.ReadLine();
            if (temp == "")
                lease_reason = "无";
            else
                lease_reason = temp;
            MySqlCommand cmd = new MySqlCommand();
            cmd.Connection = con;
            cmd.CommandType = System.Data.CommandType.Text;

            cmd.CommandText = "insert into 教室占用记录 values(@classroom_id,@student_id,@teacher_id,@lease_week,@lease_day,@lease_course_time,@lease_reason);";
            cmd.Parameters.AddWithValue("@classroom_id", classroom_id);
            if (student_id == "")
                cmd.Parameters.AddWithValue("@student_id", null);
            else
                cmd.Parameters.AddWithValue("@student_id", student_id);
            if(teacher_id == "")
                cmd.Parameters.AddWithValue("@teacher_id", null);
            else
                cmd.Parameters.AddWithValue("@teacher_id", teacher_id);
            cmd.Parameters.AddWithValue("@lease_week", lease_week);
            cmd.Parameters.AddWithValue("@lease_day", lease_day);
            cmd.Parameters.AddWithValue("@lease_course_time", lease_course_time);
            cmd.Parameters.AddWithValue("@lease_reason", lease_reason);


            int r = cmd.ExecuteNonQuery();
            //MySql.Data.MySqlClient.MySqlException
            if (r == 1)
            {
                System.Console.WriteLine("\n申请成功！");
                System.Console.WriteLine("\n");
            }
            else
            {
                System.Console.WriteLine("\n申请失败！");
                System.Console.WriteLine("\n");
            }

            con.Close();
        }
    }
}
