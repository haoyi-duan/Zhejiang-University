# 实验5 数据库程序设计

#### 段皞一

#### 计算机科学与技术

#### 3190105359



### 一  实验目的

- #### **掌握数据库应用开发程序设计方法**



### 二  实验平台

- #### **数据库管理系统：*MySQL***

- #### **开发语言：*Python*(通过 *pymysql* 与 *MySQL* 连接)**

- #### **开发工具：Thonny, VScode**

- #### **交互界面环境：基于 tkinter 、*ttk* 库的图形界面**



### 三  实验原理

#### **3.1 配置实验环境**

- 本实验的数据库平台为 *MySQL*，开发语言为 *Python*，开发工具为 *Thonny* 和 *VScode* 。

#### **3.2 设计图书管理数据库概念模式**

**3.2.1 设计思路**

- 首先，创建存储书籍信息的表，命名为 *book* 。

- 其次，创建一个存储借书证的表，命名为 *card* ，增加了一个属性“已借书的数量”，上限为10，防止一个借书证借太多的书。

- 最后，再创建一个存储书籍借阅情况的表，命名为 *borrow* ，规定书籍借阅时间为30天。 *borrow* 表的书号、卡号分别是与 *book* 、*card*表相关联的外码。

**3.2.2 基本数据对象**

​	实验的**数据对象**设计如下表所示：

| 对象名称 | 属性                                                         |
| -------- | ------------------------------------------------------------ |
| 书       | 书号，类别，书名，出版社，年份，作者，价格，总藏书量，库存   |
| 借书证   | 借书证号，姓名，单位（学院），类别（教师、学生），已借书的量 |
| 借书记录 | 借书证号，书号，借书时间，归还时间                           |

​	关系模式的**E-R图**如下所示：

![](C:\Users\lenovo\AppData\Roaming\Typora\typora-user-images\image-20210425165503573.png)

**3.2.3 基本功能模块**

| 模块名称   | 功能描述                                                     |
| ---------- | ------------------------------------------------------------ |
| 图书入库   | 1. 单本入库<br>    在单本入库的模式下同时支持修改图书的信息<br>2. 批量入库（方便最后测试）<br>    图书信息存放在文件中，每条图书信息为一行，一行中的内容如下：<br>    ( 书号，类别，书名，出版社，年份，作者，价格，数量 )<br>    *Note*: 其中 年份、数量是整数类型；价格是小数类型；其余为字符串类型<br>    *Sample*: <br>    *( book_no_1, Computer Science, Computer Architecture, xxx, 2004, xxx,*<br>    *90.00, 2)* |
| 图书查询   | 可以对书的 书号，类别，书名，出版社，年份（区间），作者，价格（区间），进行查询。<br>每个查询结果包含 书号，类别，书名，出版社，年份，作者，价格，总藏书量，库存 |
| 借书       | 1. 输入借书证卡号<br>    显示该借书证所有已借书籍（返回，格式同查询模块）<br>2. 输入书号<br>    如果该书还有库存，则借书成功，同时库存数减一<br>    否则输出该书无库存，且输出最近归还的时间 |
| 还书       | 1. 输入借书证号<br>    显示该借书证所有已借书籍（返回，格式同查询模块）<br>2. 输入书号<br>    如果该书在已借书籍列表内，则还书成功，同时库存加一<br>    否则输出出错信息 |
| 借书证管理 | 增加或删除一个借书证<br>1. 如果该借书证还存在书籍未归还的情况，则删除时会报错<br>2. 在该模式下，还支持修改借书证的信息（例如修改姓名，单位/学院） |

#### **3.3 用户界面**

​	用户界面为图形界面，采用 *Python* 原生的 *tkinter* 以及 *ttk* 构建。



### 四 实验具体步骤

#### 4.1 数据库逻辑结构设计

​	首先在 *MySQL* 中建立 *Library* 数据库，并按照前面所述的关系模式进行数据库表的创建。

- **Book**

```mysql
create table book
(
bno char(10),
category varchar(10),
title varchar(20),
press varchar(20),
year int,
author varchar(20),
price decimal(7,2),
total int,
stock int,
primary key(bno)
);
```

​	分别对应前面基本数据对象描述中，书的各个属性：书号，类别，书名，出版社，年份，作者，价格，总藏书量，库存。主码是书号，这是区分不同书籍的标记。

- **Card**

```mysql
create table card
(
cno char(10), -- 注意卡号程度为10
name varchar(10),
department varchar(40),
type char(1),
numbers int,
primary key(cno),
check(type in ('T', 'S')),
check(numbers <= 10 and numbers >= 0)
);
```

​	与前文所说的借书证的属性相对应：借书证号，姓名，单位（学院），类别（老师，学生），已借书量。主码是借书证号，是和使用者一一对应且唯一的。

​	添加了两个约束条件：

​	类别只能是老师("T")或者学生("S")中的一个；

​	借书量的上线为10本。

- **Borrow**

```mysql
create table borrow
(
cno char(10),
bno char(10),
borrow_date datetime,
return_date datetime,
primary key(cno, bno),
foreign key(cno) references card(cno),
foreign key(bno) references book(bno)
);
```

​	对应之前所述的借书记录模块的属性：借书证号，书号，借书时间，归还时间。

​	将时间设成了*datetime* 类型，因为这样更加贴近现实中的情况，而且可以调用 *Python* 中的 *datetime* 模块进行时间类型的计算与比较，非常方便，而且 *datetime* 类型也支持聚合函数中的选取最小值的功能，对于后续的判断也是非常方便的。

​	该模块的主码是书号，借书证号，即本实验设定的是，对于相同卡号的书籍，同一张卡只能一次借一本。借书证号作为外码与 *card* 关联，保证了不会有不存在的卡号进行借阅\归还书籍的操作；书号作为外码与 *book* 关联，又保证了不能够借阅\归还图书馆不存在的书籍。

#### 4.2 书写实验代码，实现图书、借书证及图书借阅的管理的基本功能

**4.2.1 主函数 *Main.py***

**4.2.1.1 连接数据库**

​	主函数模块部分首先要进行数据库 *Library* 的连接。登录数据库的密码默认为我的账号密码。可以在 *host.txt* 中改成运行程序的电脑上的数据库账号和密码。

```mysql
if __name__ == "__main__":
    import tkinter as tk
    from tkinter import scrolledtext, END
    from tkinter import ttk
    from PIL import Image, ImageTk
    import Add
    import Query
    import Card
    import Borrow
    import Return
    import logging
    import pymysql

    image = None
    im = None

    with open("host.txt", "r") as config:
        user = config.readline().split(":")[1].strip(" \n")
        pw = config.readline().split(":")[1].strip(" \n")    
    try:
        conn = pymysql.connect(
            host = "localhost", 
            port = 3306, 
            database = "library", 
            user = user,
            password = pw, 
            charset = "utf8", 
            autocommit = True
        )
    except Exception as ex:
        logging.exception(ex)

    StartGui()
```

**4.2.1.2 *StartGui()***

​	初始化图形界面：

```mysql
def StartGui():
    root = tk.Tk()
    basedesk(root)
    root.mainloop()
```

​	初始化的图形界面类型 *root* 之后传给 *basedest()* 进行后期的操作。

**4.2.1.3 *basedesk()***

​	设置了图形界面的大小为 $1000\times700$ , 之后交给 *initwin(self.root)* 做之后的处理。

```mysql
class basedesk():
    def __init__(self, master):
        self.root = master
        self.root.geometry('1000x700')

        initwin(self.root)
```

**4.2.1.4 *initwin()***

​	该部分代码的主要作用是打开开始画面：

```mysql
class initwin(): #主窗口
    def __init__(self,master):
        global im
        global image
        self.master=master
        self.master.config(bg='#1ba784')
        self.initwin=tk.Frame(self.master,)
        self.initwin.pack()
        self.canvas = tk.Canvas(
            self.initwin,  
            width = 1000,      
            height = 700,     
            bg = '#1ba784'
        )      
        
        image=Image.open("bg.jpg")
        im=ImageTk.PhotoImage(image)

        self.canvas.create_image(0,0,anchor='nw',image = im)      # 使用create_image将图片添加到Canvas组件中  
```

​	游戏开始画面设置了“图书入库”、“查阅书籍”、“借书证管理”、“借书”、“还书”、“退出”的按钮。

![image-20210425194434965](C:\Users\lenovo\AppData\Roaming\Typora\typora-user-images\image-20210425194434965.png)

​	开始界面的几个按钮都设置成 *ttk* 库下的 *Button* 类型。

```mysql
        btn_add=ttk.Button(self.initwin, text="图书入库或修改信息", command=self.add)
        btn_query=ttk.Button(self.initwin, text="查询图书信息", command=self.query)
        btn_card=ttk.Button(self.initwin, text="借书证管理", command=self.card)
        btn_borrow=ttk.Button(self.initwin, text="借书", command=self.borrow)
        btn_return=ttk.Button(self.initwin, text="还书", command=self.returnbook)
        btn_exit=ttk.Button(self.initwin, text="退出", command=quit)

        self.canvas.create_window(500,250,width=200,height=40,window=btn_add)
        self.canvas.create_window(500,300,width=200,height=40,window=btn_query)
        self.canvas.create_window(500,350,width=200,height=40,window=btn_card)
        self.canvas.create_window(500,400,width=200,height=40,window=btn_borrow)
        self.canvas.create_window(500,450,width=200,height=40,window=btn_return)
        self.canvas.create_window(850,600,width=100,height=40,window=btn_exit)
```

​	当点击按钮时，会分别触发相应的函数：

```mysql

    def add(self): #add窗口，实现的功能：选择批量入库或者单本入库，添加或是修改
        self.initwin.destroy()
        addwin(self.master)
    def query(self):
        self.initwin.destroy()
        querywin(self.master)
    def card(self):
        self.initwin.destroy()
        cardwin(self.master)
    def borrow(self):
        self.initwin.destroy()
        borrowwin(self.master)
    def returnbook(self):
        self.initwin.destroy()
        returnwin(self.master)
```

**4.2.2 *Add.py***

​	*Add.py* 函数的作用是处理“书籍入库或修改信息”的部分。

​	当用户选择“单本入库”时，主函数 *Main.py* 将触发 *onclick2(self)* 或者 *onclick3(self)* 函数，前者是进行书籍的添加，后者时进行书籍信息的修改。

```mysql
    def onclick2(self,):
        result=Add.AddOne(conn,self.bnum_input.get(),self.cob_input.get(),self.bname_input.get(),self.pub_input.get(),self.y_input.get(),self.auth_input.get(),self.pri_input.get(),self.cflag,self.num_input.get())
        if type(result)==type(()):
            self.str="添加成功\n图书馆现有此书%d本\n共有藏书%d本"%(result[1], result[0])
        elif result!="修改成功":
            self.str=result
        else:
            self.str=result
        self.state.destroy()
        self.state=tk.Message(self.addwin,text=self.str,width=300,font=("微软雅黑",12))
        self.canvas.create_window(650,150,anchor="nw",width=300,window=self.state)
        self.cflag=0
        print(result)

    def onclick3(self,):
        self.cflag=1
        self.onclick2()
```

​	主函数读取用户输入的信息以后，把信息传给 *Add.py* 模块。

​	首先判断用户传给的数据是否有空项，如果有，返回错误。

```mysql
if (bno=="" or category=="" or title=="" or press=="" or year=="" or author=="" or price==""):
	return "不能有空项"
```

​	然后根据传入的 *flag* 参数判断是添加还是修改。分别进行相应的操作。

​	添加：

```mysql
sql = "insert into book values(%s, %s, %s, %s, %s, %s, %s, %s, %s)"
try:
cursor.execute(sql, (bno, category, title, press, year, author, price, num, num))
conn.commit()
return (num, num)
```

​	修改：

```mysql
sql = "update book set category = %s, title = %s, press = %s, year = %s, author = %s, price = %s where bno = %s"
cursor.execute(sql, (category, title, press, int(year), author, float(price), bno))
conn.commit()
return "修改成功"
```

​	当用户选择 “批量入库” 时，其本质就是将文件中的入库书目一条一条依次读出，多次调用“单本入库”函数模块进行添加。

**4.2.3 *Query.py***

​	依照之前的设计，用户可以按照书号，类别，书名，出版社，作者，年份（区间），价格（区间）进行书籍的检索。

![](C:\Users\lenovo\AppData\Roaming\Typora\typora-user-images\image-20210425200426734.png)

​	在 *Query.py* 模块下，连接数据库进行相应的搜索：

```mysql
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
```

​	年份和价格是按照区间，所以该模块统一有两个输入，当用户使用“年份”、“价格”类别进行查询时，两个输入的参数分别是下限和上限；而用户选择其他的类别进行查询的时候，由于只需要一个参数，所以第二个参数在主函数传参的时候置“0”，在 *Query()* 模块中不管第二个参数。

**4.2.4 *Card.py***

​	该模块负责处理借书证的管理指令。

- ***def AddCard(conn, cno, name, department, type, flag):***

  该模块负责添加借书证，以及添加过程中相应的判断。

```mysql
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
```

- ***def* *DeleteCard*(conn, cno):**

  该模块负责删除借书证，以及进行删除过程中必要的判断。

```mysql
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
        conn.commit()
        return 1
    except Exception as ex:
        conn.rollback()
        return ex
```

**4.2.5 *Borrow.py***

​	借书模块首先判断借书证是否存在：

```mysql
cursor = conn.cursor()
sql = "select * from card where cno = %s"
cursor.execute(sql, cno)
result = cursor.fetchone()
if result is None:
    return "无效的借书证号"
```

​	之后判断借书数量是否达到上限10本：

```mysql
cursor = conn.cursor()
sql = "select numbers from card where cno = %s"
cursor.execute(sql, cno)
numbers = cursor.fetchone()[0]
if numbers >= 10:
    return "借书数量达到上限"
```

​	由于实验设定同一本书只能借一本，所以还要加如下判断：

```mysql
sql = "select bno from borrow where cno = %s"
cursor.execute(sql, cno)
result = cursor.fetchall()
for i in result:
    if bno in i:
        return "已经借过该书"
```

​	如果书号不存在数据库系统中，同样也是不能借书的：

```mysql
sql = "select title, stock from book where bno = %s"
cursor.execute(sql, bno)
result = cursor.fetchone()
    if result is None:
        return "借书失败，书号不存在"
```

​	以上都判断了以后，还要判断该书是否存在库存：

```mysql
else:
	#借书失败，因为库存不足
    sql = "select min(return_time) from borrow where bno = %s"
    cursor.execute(sql, bno)
    return_date = cursor.fetchone()
    return_date = return_date.striftime('%Y-%m-%d %H:%M:%S')
    return (1, return_date)
```

**4.2.6 *Return.py***

​	还书模块，还书成功后，图书的库存数加1；该借书记录从数据库中删除；该借书证号的借书数量减1.

```mysql
sql = "update book set stock = stock+1 where bno = %s"
cursor.execute(sql, bno)
sql = "delete from borrow where bno = %s and cno = %s"
cursor.execute(sql, (bno, cno))
sql = "update card set numbers = numbers - 1 where cno = %s"
cursor.execute(sql, cno)
conn.commit()
```



### 五 程序运行结果

#### 5.1 初始界面

​	首先是初始界面，注意在登陆前确保 *MySQL* 的 *library* 这个数据库中有相应的 *table*. 并且确定*host.txt* 文件中的账号和密码是正确的。按“退出”按钮，程序能够正常退出。

![image-20210425202757262](C:\Users\lenovo\AppData\Roaming\Typora\typora-user-images\image-20210425202757262.png)

#### 5.2 图书入库或修改信息

​	首先可以选择“批量入库”，方便后面的测试。将文件夹下的"book.txt"输入，可见导入成功：

![image-20210425203142377](C:\Users\lenovo\AppData\Roaming\Typora\typora-user-images\image-20210425203142377.png)

​	下面尝试进行单本入库。

​	输入不存在的书籍： ( CS-011, 计算机, 《操作系统》, 机械工程出版社, 2021, Turing, 39.50, 2 )

![image-20210425203511087](C:\Users\lenovo\AppData\Roaming\Typora\typora-user-images\image-20210425203511087.png)

​	下面尝试进行已有书籍的信息修改，把刚刚导入的《操作系统》的价格改为59.50.

![image-20210425203607645](C:\Users\lenovo\AppData\Roaming\Typora\typora-user-images\image-20210425203607645.png)

​	在 *MySQL* 中可以看到，书籍的价格被成功修改：

![image-20210425203652286](C:\Users\lenovo\AppData\Roaming\Typora\typora-user-images\image-20210425203652286.png)

​	下面尝试导入已经存在的书籍，但是书籍记录与之前不一致。保持其他信息不变，把书名改为《汇编语言》，点击“入库”：

![image-20210425203822899](C:\Users\lenovo\AppData\Roaming\Typora\typora-user-images\image-20210425203822899.png)

​	程序报出“与记录中信息不一致”的错误。

​	“批量入库”时，注意图书的各个属性要在之前定义的长度范围之内，属性过长的话就会入库失败。“信息栏”会给出相应的信息的。

![image-20210425204137381](C:\Users\lenovo\AppData\Roaming\Typora\typora-user-images\image-20210425204137381.png)

#### 5.3 查阅图书信息

​	查询主要分为两类：锁定查询和区间查询。

**5.3.1 锁定查询**

​	如，选择“类别”，输入“计算机”查询计算机类的书籍信息。

![image-20210425204401014](C:\Users\lenovo\AppData\Roaming\Typora\typora-user-images\image-20210425204401014.png)

**5.3.2 区间查询**

​	比如，选择“价格（区间）”进行查询，输入(50， 100)。

![image-20210425204512848](C:\Users\lenovo\AppData\Roaming\Typora\typora-user-images\image-20210425204512848.png)

#### 5.4 借书证管理

**5.4.1 增添**

- 增添学生

![image-20210425204706763](C:\Users\lenovo\AppData\Roaming\Typora\typora-user-images\image-20210425204706763.png)

​	查询数据库的 *card* 表，发现增添成功：

![image-20210425204736861](C:\Users\lenovo\AppData\Roaming\Typora\typora-user-images\image-20210425204736861.png)

- 增添老师

  同理可以增添老师：

![image-20210425204848612](C:\Users\lenovo\AppData\Roaming\Typora\typora-user-images\image-20210425204848612.png)

![image-20210425204910051](C:\Users\lenovo\AppData\Roaming\Typora\typora-user-images\image-20210425204910051.png)

​	同时可以发现，新增添的借书证借书的数量是“0”，结果正确。

**5.4.2 修改**

​	修改该借书证同学的学院：

![image-20210425205141487](C:\Users\lenovo\AppData\Roaming\Typora\typora-user-images\image-20210425205141487.png)

​	在 *MySQL* 中观察到，该同学的学院确实变为”计算机与技术学院“。

![image-20210425205303210](C:\Users\lenovo\AppData\Roaming\Typora\typora-user-images\image-20210425205303210.png)

​	不过借书证修改的前提是借书证号码要存在。

![image-20210425205458111](C:\Users\lenovo\AppData\Roaming\Typora\typora-user-images\image-20210425205458111.png)

**5.4.3 删除**

- 没有借书记录

![image-20210425205022659](C:\Users\lenovo\AppData\Roaming\Typora\typora-user-images\image-20210425205022659.png)

​	成功删除借书证。

- 有借书记录

![image-20210425205555155](C:\Users\lenovo\AppData\Roaming\Typora\typora-user-images\image-20210425205555155.png)

#### 5.5 借书

**5.5.1 成功借书**

![image-20210425205725811](C:\Users\lenovo\AppData\Roaming\Typora\typora-user-images\image-20210425205725811.png)

**5.5.2 不存在的书号，借书失败**

![image-20210425205756389](C:\Users\lenovo\AppData\Roaming\Typora\typora-user-images\image-20210425205756389.png)

**5.5.3 超过上限，借书失败**

​	输入借书证号，可以发现，该用户已经借了10本书且还没有归还。

![image-20210425205941638](C:\Users\lenovo\AppData\Roaming\Typora\typora-user-images\image-20210425205941638.png)

​	之后借书，就会报”借书数量超过上限“的提醒。

![image-20210425210017258](C:\Users\lenovo\AppData\Roaming\Typora\typora-user-images\image-20210425210017258.png)

**5.5.3 借过该书，借书失败**

![image-20210425205625649](C:\Users\lenovo\AppData\Roaming\Typora\typora-user-images\image-20210425205625649.png)

#### 5.6 还书

**5.6.1 成功还书**

![image-20210425210131054](C:\Users\lenovo\AppData\Roaming\Typora\typora-user-images\image-20210425210131054.png)

**5.6.2 书号不存在，还书失败**

![image-20210425210153515](C:\Users\lenovo\AppData\Roaming\Typora\typora-user-images\image-20210425210153515.png)

**5.6.3 未借该书，还书失败**

![image-20210425210205784](C:\Users\lenovo\AppData\Roaming\Typora\typora-user-images\image-20210425210205784.png)



### 六 代码

​	程序的源代码见文件夹 *"source"*.

