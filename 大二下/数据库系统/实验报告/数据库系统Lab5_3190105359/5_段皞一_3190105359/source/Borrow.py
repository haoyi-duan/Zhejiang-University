import pymysql
import logging
import datetime

def ShowList(conn, cno):
    if (cno == ""):
        return "借书证号不能为空"
    try:
        cursor = conn.cursor()
        sql = "select * from card where cno = %s"
        cursor.execute(sql, cno)
        result = cursor.fetchone()
        if result is None:
            return "无效的借书证号"
        sql = "select bno, title, borrow_date, return_date from book natural join borrow where cno = %s"
        cursor.execute(sql, cno)
        result = cursor.fetchall()
        return result

    except Exception as ex:
        logging.exception(ex)
        return ex

def Borrow(conn, cno, bno):
    if (cno=="" or bno==""):
        return "存在为空的项"
    try:
        cursor = conn.cursor()
        sql = "select numbers from card where cno = %s"
        cursor.execute(sql, cno)
        numbers = cursor.fetchone()[0]
        if numbers >= 10:
            return "借书数量达到上限"
        sql = "select bno from borrow where cno = %s"
        cursor.execute(sql, cno)
        result = cursor.fetchall()
        for i in result:
            if bno in i:
                return "已经借过该书"
        else:
            sql = "select title, stock from book where bno = %s"
            cursor.execute(sql, bno)
            result = cursor.fetchone()
            if result is None:
                return "借书失败，书号不存在"
            if result[1] != 0:
                #借书成功
                sql = "update book set stock = stock-1 where bno = %s"
                cursor.execute(sql, bno)
                borrow_date = datetime.datetime.now()
                return_date = (borrow_date+datetime.timedelta(days=30)).strftime("%Y-%m-%d %H:%M:%S")
                borrow_date = borrow_date.strftime("%Y-%m-%d %H:%M:%S")
                sql = "insert into borrow values(%s, %s, %s, %s)"
                cursor.execute(sql, (cno, bno, borrow_date, return_date))
                sql = "update card set numbers = numbers+1 where cno = %s"
                cursor.execute(sql, cno)
                conn.commit()
                return (0, return_date, borrow_date)
            else:
                #借书失败，因为库存不足
                sql = "select min(return_time) from borrow where bno = %s"
                cursor.execute(sql, bno)
                return_date = cursor.fetchone()
                return_date = return_date.striftime('%Y-%m-%d %H:%M:%S')
                return (1, return_date)

    except Exception as ex:
        logging.exception(ex)
        return ex                
