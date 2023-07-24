## 项目说明

#### 一 准备阶段

1. 程序需要用到的库有 ***logging & pymysql & PIL & tkinter***

2. 确保自己的数据库系统MySQL中新建了名为library的数据库，且数据库下按如下方式新建了三个表：

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

3. document文件夹下的host.txt存储了数据库系统的用户名和密码，默认的是我的sql的用户名和密码，若要验证，请自行修改成自己sql的用户名和密码。

#### 二 实验阶段

1. 程序的入口是**Main.py**, 用VsCode打开这个文件，右键，然后选择**在终端运行python文件**。
2. 程序所要用到的.txt和.jpg等文件默认的相对路径是".\document\"，若由于更改路径等原因导致无法读到文件，请尝试更换工作目录，或者在Main.py代码的文件读写部分自行修改或者添加文件路径。
3. document文件夹下的book.txt存储了书本信息，可以在实验开始的时候，通过“批量入库”的方式入库，方便后续进行验证。导入时，注意写上文件的相对路径信息：**“.\document\book.txt”.**
4. 实验开始的时候，借书证需要自己添加，document文件夹下**users.txt**可以记录当前借书证的信息。
5. document文件夹下的succeed_log.txt记录每次批量入库成功的信息。

