import pymysql
import logging

def Query(conn, para1, para2, index):
    if para1=="" or para2=="":
        return "输入不能为空"
    cursor = conn.cursor()
    try:
        if index==0:
            sql="select bno, category, title, press, year, author, price, total, stock from book where bno = %s"
        if index==1:
            sql="select bno, category, title, press, year, author, price, total, stock from book where category = %s"
        elif index==2:
            sql="select bno, category, title, press, year, author, price, total, stock from book where title = %s"
        elif index==3:
            sql="select bno, category, title, press, year, author, price, total, stock from book where press = %s"
        elif index==4:
            sql="select bno, category, title, press, year, author, price, total, stock from book where author = %s"
        elif index==5:
            y1=int(para1)
            y2=int(para2)
            sql="select bno, category, title, press, year, author, price, total, stock from book where year >= %s and year <= %s"
        elif index==6:
            p1=float(para1)
            p2=float(para2)
            sql="select bno, category, title, press, year, author, price, total, stock from book where price >= %s and price <= %s"
        try:
            if index in range(5):
                cursor.execute(sql, para1)
            elif index == 5:
                cursor.execute(sql, (y1, y2))
            else:
                cursor.execute(sql, (p1, p2))
            
            conn.commit()
            result = cursor.fetchall()
            return result
            
        except Exception as ex:
            conn.rollback()
            return ex

    except Exception as ex:
        return ex