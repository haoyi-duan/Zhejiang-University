import pymysql
import logging

def AddCard(conn, cno, name, department, type, flag):
    if (cno=="" or name=="" or department=="" or type==""):
        return "不能有空项"
    try:
        cursor = conn.cursor()
        sql = "select * from card where cno = %s"
        cursor.execute(sql, cno)
        result = cursor.fetchone()
        if result is None:
            if flag == 0:
                sql = "insert into card values(%s, %s, %s, %s, 0)"
                cursor.execute(sql, (cno, name, department, type))
                conn.commit()
                user = cno+" "+name+" "+department+" "+type
                with open(".\\document\\users.txt", "a") as fin:
                    fin.write(user)
                    fin.write("\n")
                return 1
            elif flag == 1:
                return "借书证不存在，修改失败"
        if flag == 0:
            return "借书证已存在，添加失败"
        elif flag == 1:
            sql = "update card set name=%s, department=%s, type=%s where cno=%s"
            cursor.execute(sql, (name, department, type, cno))
            conn.commit()
            return 2
    except Exception as ex:
        conn.rollback()
        return ex

def DeleteCard(conn, cno):
    if cno=="":
        return "卡号不能为空"
    try:
        cursor = conn.cursor()
        sql = "select numbers from card where cno = %s"
        cursor.execute(sql, cno)
        result = cursor.fetchone()
        if result is None:
            return "借书证不存在"
        if result[0] > 0:
            return "该借书证还有书未归还，删除失败"
        sql = "delete from card where cno = %s"
        cursor.execute(sql, cno)
        sql = "select * from card"
        cursor.execute(sql)
        conn.commit()
        result = cursor.fetchall()
        with open(".\\document\\users.txt", "w") as fin2:
            for i in result:
                fin2.write(i[0]+" "+i[1]+" "+i[2]+" "+i[3])
                fin2.write("\n")
        return 1
    except Exception as ex:
        conn.rollback()
        return ex