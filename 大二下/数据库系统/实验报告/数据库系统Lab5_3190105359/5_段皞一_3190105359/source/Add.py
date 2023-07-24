import pymysql
import logging

def AddOne(conn, bno, category, title, press, year, author, price, flag, num):
    cursor = conn.cursor()
    try:
        if (bno=="" or category=="" or title=="" or press=="" or year=="" or author=="" or price==""):
            return "不能有空项"
        sql = "select total, stock from book where bno = %s"
        cursor.execute(sql, bno)
        result = cursor.fetchone()
    except Exception as ex:
        conn.rollback()
        logging.exception(ex)
        return ex

    if result is None:
        if (flag == 1):
            return "此书未被收录，修改失败"
        sql = "insert into book values(%s, %s, %s, %s, %s, %s, %s, %s, %s)"
        try:
            cursor.execute(sql, (bno, category, title, press, year, author, float(price), num, num))
            conn.commit()
            return (num, num)
        except Exception as ex:
            conn.rollback()
            logging.exception(ex)
            return ex
    else:
        try:
            sql = "select category, title, press, year, author, price, total, stock from book where bno = %s"
            cursor.execute(sql, bno)
            record = cursor.fetchone()

            if flag == 0: #添加
                if record[0]==category and record[1]==title and record[2]==press and record[3]==int(year) and record[4]==author and float(record[5])==float(price):
                    sql = "update book set total = %s, stock = %s where bno = %s"
                    cursor.execute(sql, (record[6]+int(num), record[7]+int(num), bno))
                    conn.commit()
                    return (record[6]+int(num), record[7]+int(num))
                else:
                    conn.rollback()
                    return "与记录中信息不一致！"
            else:
                sql = "update book set category = %s, title = %s, press = %s, year = %s, author = %s, price = %s where bno = %s"
                cursor.execute(sql, (category, title, press, int(year), author, float(price), bno))
                conn.commit()
                return "修改成功"
        except Exception as ex:
            logging.exception(ex)
            conn.rollback()
            return ex

def AddBatch(conn, file_addr):
    success_cnt = 0
    fail_Cnt = 0
    success_list = []
    fail_list = []
    try:
        with open(file_addr, "r", encoding="utf8") as fin:
            for line in fin.readlines():
                str1 = line.strip('\n')
                str2 = line.strip('()\n').split(',')
                if len(str2) != 8:
                    fail_list.append(str1)
                    continue
                bno = str2[0].strip()
                category = str2[1].strip()
                title = str2[2].strip()
                press = str2[3].strip()
                year = int(str2[4].strip())
                author = str2[5].strip()
                price = float(str2[6].strip())
                num = int(str2[7].strip())

                result = AddOne(conn, bno, category, title, press, year, author, price, 0, num)
                if type(result) == type(()):
                    success_list.append(str1)
                    success_cnt += num
                else:
                    fail_list.append(str1)
                    fail_list.append(result)
                    fail_Cnt += num
        
        with open(".\document\succeed_log.txt", "a") as fin2:
            for line in success_list:
                fin2.write(line)
                fin2.write("\n")

        return (len(success_list), success_cnt, len(fail_list), fail_Cnt, fail_list)
    except Exception as ex:
        logging.exception(ex)
        return ex        
