import pymysql
import logging
import datetime

def Return(conn, cno, bno):
    if (cno=="" or bno==""):
        return "书号不能为空"
    try:
        cursor = conn.cursor()
        sql = "select * from book where bno = %s"
        cursor.execute(sql, bno)
        result = cursor.fetchone()
        if result is None:
            return "不存在该书"
        sql = "select title, stock, return_date from book natural join borrow where bno = %s and cno = %s"
        cursor.execute(sql, (bno, cno))
        result = cursor.fetchone()
        if result is None:
            return "您尚未借阅此书，因此无法归还"
        else:
            title = result[0]
            real_date = datetime.datetime.now()
            if real_date > result[2]:
                late = True
            else:
                late = False
            sql = "update book set stock = stock+1 where bno = %s"
            cursor.execute(sql, bno)
            sql = "delete from borrow where bno = %s and cno = %s"
            cursor.execute(sql, (bno, cno))
            sql = "update card set numbers = numbers - 1 where cno = %s"
            cursor.execute(sql, cno)
            conn.commit()
        return (title, late)
    except Exception as ex:
        logging.exception(ex)
        conn.rollback()
        return ex