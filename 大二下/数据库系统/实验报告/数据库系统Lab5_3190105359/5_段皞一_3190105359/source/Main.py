class basedesk():
    def __init__(self, master):
        self.root = master
        self.root.geometry('1000x700')

        initwin(self.root)

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
        
        image=Image.open(".\document\\bg.jpg")
        im=ImageTk.PhotoImage(image)

        self.canvas.create_image(0,0,anchor='nw',image = im)      # 使用create_image将图片添加到Canvas组件中  

        self.canvas.pack()         # 将Canvas添加到主窗口。
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
    

class addwin(): 
    def __init__(self,master):
        global im
        global image
        self.master=master
        self.master.config(bg='GhostWhite')
        self.str="状态信息"
        self.addwin=tk.Frame(self.master,)
        self.addwin.pack()
        self.canvas = tk.Canvas(
            self.addwin,  
            width = 1000,      
            height = 700,     
            bg = 'white'
        )      
        
        image=Image.open('.\document\\add.jpg')
        im=ImageTk.PhotoImage(image)

        self.canvas.create_image(0,0,anchor='nw',image = im)      # 使用create_image将图片添加到Canvas组件中  

        self.canvas.pack()         # 将Canvas添加到窗口
        self.btn_back=ttk.Button(self.addwin,text="返回主菜单",command=self.back)
        self.canvas.create_window(100,50,width=200,height=40,window=self.btn_back)

        self.mode=tk.IntVar() #选择入库模式(单本或者批量)

        self.style_radio=ttk.Style()
        self.style_radio.configure("radio.TRadiobutton",font=("微软雅黑",12),background="#5698c3")

        self.r1=ttk.Radiobutton(self.addwin,text="单本入库（或修改信息）",variable=self.mode,value=1,command=self.display1,style="radio.TRadiobutton")
        self.r2=ttk.Radiobutton(self.addwin,text="批量入库",variable=self.mode,value=2,command=self.display2,style="radio.TRadiobutton")
        self.canvas.create_window(400,50,window=self.r1)
        self.canvas.create_window(400,100,window=self.r2)

        self.style_label=ttk.Style()
        self.style_label.configure("label.TLabel",font=("微软雅黑",14))
        self.s_title=ttk.Label(self.addwin,text="状态栏",style="label.TLabel", width=25, anchor="center")
        self.state=tk.Message(self.addwin,text=self.str,width=300,font=("微软雅黑",12))
        self.canvas.create_window(800,100,height=50,window=self.s_title)
        self.canvas.create_window(650,150,anchor="nw",width=300,window=self.state)
        self.flag1=0 #标记“批量入库”的控件是否存在的flag
        self.flag2=0 #标记“单本入库”的控件是否存在的flag
        self.cflag=0 #change flag,用来区分是添加一本书还是修改书的信息.为1时代表修改

    def display1(self,):
        if(self.flag1==1):
            self.f_input.destroy()
            self.btn_conf1.destroy()
            self.f_prom.destroy()
            self.flag1=0

        if(self.flag2==1):
            return 
       
        self.bnum_prom=ttk.Label(self.addwin,text="书号:",anchor="center",style="label.TLabel", width=50)
        self.cob_prom=ttk.Label(self.addwin,text="类别:",anchor="center",style="label.TLabel",width=50)
        self.bname_prom=ttk.Label(self.addwin,text="书名:",anchor="center",style="label.TLabel", width=50)
        self.pub_prom=ttk.Label(self.addwin,text="出版社:",anchor="center",style="label.TLabel", width=50)
        self.y_prom=ttk.Label(self.addwin,text="年份:",anchor="center",style="label.TLabel", width=50)
        self.auth_prom=ttk.Label(self.addwin,text="作者:",anchor="center",style="label.TLabel", width=50)
        self.pri_prom=ttk.Label(self.addwin,text="价格:",anchor="center",style="label.TLabel", width=50)
        self.num_prom=ttk.Label(self.addwin,text="数量:",anchor="center",style="label.TLabel", width=50)
        
        self.btn_conf2=ttk.Button(self.addwin,text="入库",command=self.onclick2)
        self.btn_conf3=ttk.Button(self.addwin,text="修改",command=self.onclick3)

        self.bnum_input=tk.Entry(self.addwin,show=None,font=("微软雅黑",14),width=20)
        self.cob_input=tk.Entry(self.addwin,show=None,font=("微软雅黑",14),width=20)
        self.bname_input=tk.Entry(self.addwin,show=None,font=("微软雅黑",14),width=20)
        self.pub_input=tk.Entry(self.addwin,show=None,font=("微软雅黑",14),width=20)
        self.y_input=tk.Entry(self.addwin,show=None,font=("微软雅黑",14),width=20)
        self.auth_input=tk.Entry(self.addwin,show=None,font=("微软雅黑",14),width=20)
        self.pri_input=tk.Entry(self.addwin,show=None,font=("微软雅黑",14),width=20)
        self.num_input=tk.Entry(self.addwin,show=None,font=("微软雅黑",14),width=20)

        self.flag2=1#标记一下上面的东西都被创立了，下面要把它们放在画布上

        self.canvas.create_window(250,150,width=70,window=self.bnum_prom)
        self.canvas.create_window(410,150,height=30,window=self.bnum_input)
        self.canvas.create_window(250,200,width=70,window=self.cob_prom)
        self.canvas.create_window(410,200,height=30,window=self.cob_input)
        self.canvas.create_window(250,250,width=70,window=self.bname_prom)
        self.canvas.create_window(410,250,height=30,window=self.bname_input)
        self.canvas.create_window(250,300,width=70,window=self.pub_prom)
        self.canvas.create_window(410,300,height=30,window=self.pub_input)
        self.canvas.create_window(250,350,width=70,window=self.y_prom)
        self.canvas.create_window(410,350,height=30,window=self.y_input)
        self.canvas.create_window(250,400,width=70,window=self.auth_prom)
        self.canvas.create_window(410,400,height=30,window=self.auth_input)
        self.canvas.create_window(250,450,width=70,window=self.pri_prom)
        self.canvas.create_window(410,450,height=30,window=self.pri_input)
        self.canvas.create_window(250,500,width=70,window=self.num_prom)
        self.canvas.create_window(410,500,height=30,window=self.num_input)

        self.canvas.create_window(300,550,window=self.btn_conf2)
        self.canvas.create_window(420,550,window=self.btn_conf3)

    def display2(self,):
        if(self.flag2==1):
            self.bnum_prom.destroy()
            self.cob_prom.destroy()
            self.bname_prom.destroy()
            self.pub_prom.destroy()
            self.y_prom.destroy()
            self.auth_prom.destroy()
            self.pri_prom.destroy()
            self.btn_conf2.destroy()
            self.btn_conf3.destroy()
            self.bnum_input.destroy()
            self.cob_input.destroy()
            self.bname_input.destroy()
            self.pub_input.destroy()
            self.y_input.destroy()
            self.auth_input.destroy()
            self.pri_input.destroy()
            self.num_input.destroy()
            self.num_prom.destroy()
            self.flag2=0
        
        if(self.flag1==1):
            return 

        self.f_prom=ttk.Label(self.addwin,text="请输入文件名字:",font=('微软雅黑', 12), width=70, style="label.TLabel",anchor="center")

        
        self.f_input=tk.Entry(self.addwin,show=None,font=("微软雅黑",14))

        self.btn_conf1=ttk.Button(self.addwin,text="确认",command=self.onclick1)

        self.flag1=1#(用来记录是否创建f_input)
        self.canvas.create_window(400,150,height=50,width=300,window=self.f_input)
        self.canvas.create_window(400,250,height=50,window=self.btn_conf1)
        self.canvas.create_window(150,150,height=50,width=150,window=self.f_prom)
        

    #读文件进行批量入库
    def onclick1(self,):
        file_addr=self.f_input.get()
        result=Add.AddBatch(conn,file_addr)
        self.state.destroy()
        if type(result)==type(()):
            self.str="导入完毕\n成功导入 %d 条记录,共 %d 本\n导入记录存至succeed_log.txt中\n导入失败 %d 条记录,共 %d 本\n详见屏幕下方"%(result[0],result[1],result[2],result[3])
            #用带竖向滚动条的message来输出添加失败的书单
            self.f_list=scrolledtext.ScrolledText(self.addwin,width=700,height=300,font=("微软雅黑",12))
            self.f_str="以下是导入失败的书的名单\n"
            self.f_list.insert(END,self.f_str)
            for _ in result[4]:
                self.f_list.insert(END,_+"\n")
            self.f_list.config(state='disabled')
            self.canvas.create_window(100,280,width=700,height=300,anchor="nw",window=self.f_list)
            self.btn_list=ttk.Button(self.addwin,text="确认导入失败名单",command=self.destroy_flist)
            self.canvas.create_window(400,600,anchor="nw",window=self.btn_list)
            self.r1.config(state="disabled")
            self.r2.config(state="disabled")
        else:
            self.str=result
        self.state=tk.Message(self.addwin,text=self.str,width=300,font=("微软雅黑",12))
        self.canvas.create_window(650,150,anchor="nw",width=300,window=self.state)

    def destroy_flist(self):
        self.addwin.destroy()
        addwin(self.master)

    def onclick2(self,):
        result=Add.AddOne(conn,self.bnum_input.get(),self.cob_input.get(),self.bname_input.get(),self.pub_input.get(),self.y_input.get(),self.auth_input.get(),self.pri_input.get(),self.cflag,self.num_input.get())
        if type(result)==type(()):
            self.str="添加成功\n图书馆现有此书%d本\n共有藏书%d本"%(int(result[1]), int(result[0]))
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


    def back(self,):
        self.addwin.destroy()
        initwin(self.master)

class querywin():
    def __init__(self,master):
        global im
        global image
        self.master=master
        self.querywin=tk.Frame(self.master,)
        self.querywin.pack()
        self.canvas=tk.Canvas(
            self.querywin,
            width=1000,
            height=700,
            bg='white'
        )

        image=Image.open('.\document\query.jpg')
        im=ImageTk.PhotoImage(image)

        self.canvas.create_image(0, 0, anchor="nw", image=im)

        self.canvas.pack()
        self.btn_back=ttk.Button(self.querywin, text="返回主菜单", command=self.back)
        self.canvas.create_window(100, 50, width=200, height=40, window=self.btn_back)

        self.sel_title=ttk.Label(self.querywin,text="请选择您的查询方式，并点击确认", width=30, style="l.TLabel", anchor="center")
        self.canvas.create_window(380, 90, height=50, anchor="nw", window=self.sel_title)

        self.btn_sel=ttk.Button(self.querywin,text="确认",command=self.judge)
        self.canvas.create_window(435, 420, anchor="nw", height=40, window=self.btn_sel)

        self.list=tk.Listbox(self.querywin)
        for i in ["书号", "类别", "书名", "出版社", "作者", "年份(区间)", "价格(区间)"]:
            self.list.insert(END,i)
        self.list.config(font=("微软雅黑",15),height=7)
        self.canvas.create_window(310,180,width=340,anchor="nw",window=self.list)

    def judge(self):
            self.sel_index=self.list.curselection()
            if self.sel_index==():
                pass
            else:
                self.query(self.sel_index[0])

    def query(self,index):
        self.index=index
        self.search_str=self.list.get(index)
        self.sel_title.destroy()
        self.btn_sel.destroy()
        self.list.destroy()

        if index in range(5):
            self.search_prom1=ttk.Label(self.querywin,text="请输入 "+self.search_str+":",style="l.TLabel",width=20,anchor="center")
            self.search_input1=tk.Entry(self.querywin,show=None,font=("微软雅黑",14))
            self.btn_search1=ttk.Button(self.querywin,text="查询",command=self.onclick1)

            self.canvas.create_window(150,150,anchor="nw",height=50,window=self.search_prom1)
            self.canvas.create_window(400,150,anchor="nw",height=50,width=300,window=self.search_input1)
            self.canvas.create_window(780,150,anchor="nw",height=50,window=self.btn_search1)

        else:
            self.search_prom2=ttk.Label(self.querywin,text="请输入 "+self.search_str+':',style="l.TLabel",anchor="center",width=20)
            self.search_input2=tk.Entry(self.querywin,show=None,font=("微软雅黑",14))
            self.search_link=ttk.Label(self.querywin,text="————")
            self.search_input3=tk.Entry(self.querywin,show=None,font=("微软雅黑",14))
            self.btn_search2=ttk.Button(self.querywin,text="查询",command=self.onclick2)

            self.canvas.create_window(150,150,anchor="nw",height=50,window=self.search_prom2)
            self.canvas.create_window(400,155,anchor="nw",width=100,height=40,window=self.search_input2)
            self.canvas.create_window(550,165,anchor="nw",window=self.search_link)
            self.canvas.create_window(650,155,anchor="nw",width=100,height=40,window=self.search_input3)
            self.canvas.create_window(800,150,anchor="nw",height=50,window=self.btn_search2)

    def onclick1(self):
        result=Query.Query(conn, self.search_input1.get(), 0, self.index)
        self.show(result)

    def onclick2(self):
        result=Query.Query(conn,self.search_input2.get(),self.search_input3.get(),self.index)
        self.show(result)

    def show(self,result):
        self.query_list=ttk.Treeview(self.querywin,columns=["书号","类别","书名","出版社","年份","作者","价格","总藏书量", "库存"],show="headings")
        self.query_list.column("书号",width=50)
        self.query_list.column("类别",width=100)
        self.query_list.column("书名",width=200)
        self.query_list.column("出版社",width=150)
        self.query_list.column("年份",width=50)
        self.query_list.column("作者",width=140)
        self.query_list.column("价格",width=80)
        self.query_list.column("总藏书量",width=70)
        self.query_list.column("库存",width=70)
        self.query_list.heading("书号",text="书号",)
        self.query_list.heading("类别",text="类别",)
        self.query_list.heading("书名",text="书名",)
        self.query_list.heading("出版社",text="出版社")
        self.query_list.heading("年份",text="年份")
        self.query_list.heading("作者",text="作者")
        self.query_list.heading("价格",text="价格")
        self.query_list.heading("总藏书量",text="总藏书量")
        self.query_list.heading("库存",text="库存")
        self.canvas.create_window(50,250,height=300,anchor="nw",window=self.query_list)
        self.backQuery = ttk.Button(self.querywin,text="返回",command=self.destroy_search)
        self.canvas.create_window(500,600,anchor="center",height=30,window=self.backQuery)

        if type(result) != type(()):
            return

        i = 0
        for item in result:
            self.query_list.insert("",i,values=(item[0],item[1],item[2],item[3],item[4],item[5],item[6],item[7],item[8]))
            i += 1
    
    def destroy_search(self):
        self.querywin.destroy()
        querywin(self.master)

    def back(self):
        self.querywin.destroy()
        initwin(self.master)

class cardwin():
    def __init__(self,master):
        global im
        global image
        self.master=master
        self.cardwin=tk.Frame(self.master)
        self.cardwin.pack()
        self.canvas=tk.Canvas(
            self.cardwin,
            width=1000,
            height=700,
            bg='white'
        )

        image=Image.open('.\document\card.jpg')
        im=ImageTk.PhotoImage(image)

        self.canvas.create_image(0,0,anchor="nw",image=im)

        self.canvas.pack()
        self.btn_back=ttk.Button(self.cardwin,text="返回主菜单",command=self.back)
        self.canvas.create_window(100,50,width=200,height=40,window=self.btn_back)

        self.mode=tk.IntVar()
        self.style_r=ttk.Style()
        self.style_r.configure("r.TRadiobutton",font=("微软雅黑",10),background="Aqua")
        self.r1=ttk.Radiobutton(self.cardwin,text="增添或修改",variable=self.mode,value=1,command=self.Add,style="r.TRadiobutton")
        self.r2=ttk.Radiobutton(self.cardwin,text="删除借书证",variable=self.mode,value=2,command=self.Delete,style="r.TRadiobutton")

        self.canvas.create_window(400,50,window=self.r1)
        self.canvas.create_window(400,100,window=self.r2)

        self.flag_add=0
        self.flag_del=0
        self.cflag=0
        self.type="S"

        self.str="此处输出状态信息"
        self.style_l=ttk.Style()
        self.style_l.configure("l.TLabel",font=("微软雅黑",14))
        self.s_title=ttk.Label(self.cardwin,text="状态栏",width=27, style="l.TLabel",anchor="center")
        self.state=tk.Message(self.cardwin,text=self.str,width=300, font=("微软雅黑",12))
        self.canvas.create_window(800,100,height=30,window=self.s_title)
        self.canvas.create_window(650,150,anchor="nw",width=300,window=self.state)

    def Add(self):
        if self.flag_del==1:
            #destroy窗口里的东西
            self.cnum_input.destroy()
            self.cnum_prom.destroy()
            self.btn_del.destroy()

            self.flag_del=0
        if self.flag_add==1:
            return

        self.cnum_prom=ttk.Label(self.cardwin,text="借书证号:",style="l.TLabel",width=50,anchor="center")
        self.name_prom=ttk.Label(self.cardwin,text="姓名:",style="l.TLabel",width=50,anchor="center")
        self.dept_prom=ttk.Label(self.cardwin,text="所属单位(学院):",style="l.TLabel",width=50,anchor="center")
        self.type_prom=ttk.Label(self.cardwin,text="身份类别:",style="l.TLabel",width=50,anchor="center")

        self.canvas.create_window(150,150,anchor="nw",width=150,height=40,window=self.cnum_prom)
        self.canvas.create_window(150,200,anchor="nw",width=150,height=40,window=self.name_prom)
        self.canvas.create_window(150,250,anchor="nw",width=150,height=40,window=self.dept_prom)
        self.canvas.create_window(150,300,anchor="nw",width=150,height=40,window=self.type_prom)

        self.cnum_input=tk.Entry(self.cardwin,show=None,font=("微软雅黑",14))
        self.name_input=tk.Entry(self.cardwin,show=None,font=("微软雅黑",14))
        self.dept_input=tk.Entry(self.cardwin,show=None,font=("微软雅黑",14))

        self.style_r1=ttk.Style()
        self.style_r1.configure("r1.TRadiobutton",font=("微软雅黑",14))
        self.type_input=tk.IntVar()
        self.type_input1=ttk.Radiobutton(self.cardwin,text="老师",variable=self.type_input,value=1,command=self.T_type,style="r1.TRadiobutton")
        self.type_input2=ttk.Radiobutton(self.cardwin,text="学生",variable=self.type_input,value=2,command=self.S_type,style="r1.TRadiobutton")

        self.canvas.create_window(350,150,anchor="nw",height=40,window=self.cnum_input)
        self.canvas.create_window(350,200,anchor="nw",height=40,window=self.name_input)
        self.canvas.create_window(350,250,anchor="nw",height=40,window=self.dept_input)
        self.canvas.create_window(380,305,anchor="nw",window=self.type_input1)
        self.canvas.create_window(480,305,anchor="nw",window=self.type_input2)

        self.btn_add=ttk.Button(self.cardwin,text="增添",command=self.add)
        self.btn_change=ttk.Button(self.cardwin,text="修改",command=self.change)

        self.canvas.create_window(250,400,anchor="nw",window=self.btn_add)
        self.canvas.create_window(400,400,anchor="nw",window=self.btn_change)
        self.flag_add=1

        
    def add(self):
        result=Card.AddCard(conn,self.cnum_input.get(),self.name_input.get(),self.dept_input.get(),self.type,self.cflag)
        if result==1:
            self.str="添加成功"
        elif result==2:
            self.str="修改成功"
        else :
            self.str=result
        self.state.destroy()
        self.state=tk.Message(self.cardwin,text=self.str,width=300,font=("微软雅黑",12))
        self.canvas.create_window(650,150,anchor="nw",width=300,window=self.state)
        self.cflag=0
        

    def change(self):
        self.cflag=1
        self.add()

    def T_type(self):
        self.type="T"

    def S_type(self):
        self.type="S"

    def Delete(self):
        if self.flag_add==1:
            self.cnum_prom.destroy()
            self.cnum_input.destroy()
            self.name_prom.destroy()
            self.name_input.destroy()
            self.dept_prom.destroy()
            self.dept_input.destroy()
            self.type_prom.destroy()
            
            self.type_input1.destroy()
            self.type_input2.destroy()
            self.btn_add.destroy()
            self.btn_change.destroy()
            self.flag_add=0

        if self.flag_del==1:
            return

        self.cnum_prom=ttk.Label(self.cardwin,text="请输入借书证号:",style="l.TLabel",width=70,anchor="center")
        self.cnum_input=tk.Entry(self.cardwin,show=None,font=("微软雅黑",14))
        self.btn_del=ttk.Button(self.cardwin,text="删除",command=self.dele)

        self.canvas.create_window(150,200,width=150,height=50,anchor="nw",window=self.cnum_prom)
        self.canvas.create_window(350,205,width=250,height=40,anchor="nw",window=self.cnum_input)
        self.canvas.create_window(430,300,width=70,height=40,anchor="nw",window=self.btn_del)

        self.flag_del=1
    def dele(self):
        cnum=self.cnum_input.get()
        result=Card.DeleteCard(conn,cnum)

        if(result==1):
            self.str="删除成功"
        else:
            self.str=result

        self.state.destroy()
        self.state=tk.Message(self.cardwin,text=self.str,width=300,font=("微软雅黑",12))
        self.canvas.create_window(650,150,anchor="nw",width=300,window=self.state)

    def back(self):
        self.cardwin.destroy()
        initwin(self.master)

class borrowwin():
    def __init__(self,master):
        global im
        global image
        self.master=master
        self.borrowwin=tk.Frame(self.master)
        self.borrowwin.pack()
        self.canvas=tk.Canvas(
            self.borrowwin,
            width=1000,
            height=700,
            bg='white'
        )

        image=Image.open('.\document\\borrow.jpg')
        im=ImageTk.PhotoImage(image)

        self.canvas.create_image(0,0,anchor="nw",image=im)

        self.canvas.pack()
        self.btn_back=ttk.Button(self.borrowwin,text="返回主菜单",command=self.back)
        self.canvas.create_window(100,50,width=200,height=40,window=self.btn_back)

        self.style_l=ttk.Style()
        self.style_l.configure("l.TLabel",font=("微软雅黑",14))

        self.cnum_prom=ttk.Label(self.borrowwin,text="请输入借书证号:",style="l.TLabel",anchor="center")
        self.cnum_input=tk.Entry(self.borrowwin,show=None,font=("微软雅黑",14))
        self.btn_cnum=ttk.Button(self.borrowwin,text="确认",command=self.confirm)

        self.canvas.create_window(100,100,height=40,width=200,anchor="nw",window=self.cnum_prom)
        self.canvas.create_window(350,100,height=40,width=300,anchor="nw",window=self.cnum_input)
        self.canvas.create_window(700,100,height=40,width=70,anchor="nw",window=self.btn_cnum)

    def confirm(self):
        self.cnum=self.cnum_input.get()
        self.borrow_list=Borrow.ShowList(conn,self.cnum)
        self.btn_next=ttk.Button(self.borrowwin,text="下一步",command=self.next)
        self.canvas.create_window(430,550,width=100,height=40,anchor="nw",window=self.btn_next)
        self.btn_cnum['state']='disabled'

        if type(self.borrow_list) != type(()):
            self.error=ttk.Label(self.borrowwin,text=self.borrow_list,style="l.TLabel",anchor="center")
            self.canvas.create_window(400,300,width=200,height=50,anchor="nw",window=self.error)
        if type(self.borrow_list)==type(()):
            self.query_list=ttk.Treeview(self.borrowwin,columns=["书号","书名","借书时间","归还期限"],show="headings")#show设为headings可以隐藏首列
            self.query_list.column("书号",width=100)
            self.query_list.column("书名",width=200)
            self.query_list.column("借书时间",width=200)
            self.query_list.column("归还期限",width=200)
            self.query_list.heading("书号",text="书号",)
            self.query_list.heading("书名",text="书名",)
            self.query_list.heading("借书时间",text="借书时间")
            self.query_list.heading("归还期限",text="归还期限")
            self.canvas.create_window(100,250,height=230,anchor="nw",window=self.query_list)
            i=0#临时变量
            for item in self.borrow_list:
                self.query_list.insert("",i,values=(item[0],item[1],item[2],item[3]))
                i+=1
        
        
    def next(self):
        if type(self.borrow_list)==type(()):
            self.query_list.destroy()
            self.cnum_prom.destroy()
            self.cnum_input.destroy()
            self.btn_cnum.destroy()
            self.btn_next.destroy()

            self.bnum_prom=ttk.Label(self.borrowwin,text="请输入书号:",style="l.TLabel",anchor="center")
            self.bnum_input=tk.Entry(self.borrowwin,show=None,font=("微软雅黑",14))
            self.btn_bnum=ttk.Button(self.borrowwin,text="借书",command=self.borrow)

            self.canvas.create_window(250,150,height=40,anchor="nw",window=self.bnum_prom)
            self.canvas.create_window(400,150,anchor="nw",height=40,window=self.bnum_input)
            self.canvas.create_window(650,150,anchor="nw",height=40,window=self.btn_bnum)
        else:
            self.borrowwin.destroy()
            borrowwin(self.master)

    def borrow(self):
        self.bnum=self.bnum_input.get()
        result=Borrow.Borrow(conn,self.cnum,self.bnum)
        self.borrow_str = ""
        if type(result)==type(()):
            if result[0]==0:
                self.borrow_str="%s借书成功,请在%s前归还"%(result[2],result[1])
            elif result[0]==1:
                self.borrow_str="尚无库存，最早归还日期为%s"%result[1]
        else:
            self.borrow_str=result
        self.borrow_success=ttk.Label(self.borrowwin,text=self.borrow_str,style="l.TLabel",anchor="center")
        self.btn_borrow_over=tk.Button(self.borrowwin,text="返回上一级菜单",command=self.return_last)
        self.canvas.create_window(170,300,width=700,anchor="nw",height=50,window=self.borrow_success)
        self.canvas.create_window(450,400,anchor="nw",width=100,height=40,window=self.btn_borrow_over)

    def return_last(self):
        self.borrowwin.destroy()
        borrowwin(self.master)
        
    def back(self):
        self.borrowwin.destroy()
        initwin(self.master)

class returnwin():
    def __init__(self,master):
        global im
        global image
        self.master=master
        self.returnwin=tk.Frame(self.master)
        self.returnwin.pack()
        self.canvas=tk.Canvas(
            self.returnwin,
            width=1000,
            height=700,
            bg='white'
        )

        image=Image.open('.\document\\return.jpg')
        im=ImageTk.PhotoImage(image)

        self.canvas.create_image(0,0,anchor="nw",image=im)

        self.canvas.pack()
        self.btn_back=ttk.Button(self.returnwin,text="返回主菜单",command=self.back)
        self.canvas.create_window(100,50,width=200,height=40,window=self.btn_back)

        self.style_l=ttk.Style()
        self.style_l.configure("l.TLabel",font=("微软雅黑",14))

        self.cnum_prom=ttk.Label(self.returnwin,text="请输入借书证号:",style="l.TLabel",anchor="center")
        self.cnum_input=tk.Entry(self.returnwin,show=None,font=("微软雅黑",14))
        self.btn_cnum=ttk.Button(self.returnwin,text="确认",command=self.confirm)

        self.canvas.create_window(100,100,height=40,width=200,anchor="nw",window=self.cnum_prom)
        self.canvas.create_window(350,100,height=40,width=300,anchor="nw",window=self.cnum_input)
        self.canvas.create_window(700,100,height=40,width=70,anchor="nw",window=self.btn_cnum)

    
    def confirm(self):
        self.cnum=self.cnum_input.get()
        borrow_list=Borrow.ShowList(conn,self.cnum)
        self.borrow_list=borrow_list
        self.btn_next=ttk.Button(self.returnwin,text="下一步",command=self.next)
        self.canvas.create_window(430,550,width=100,height=40,anchor="nw",window=self.btn_next)
        self.btn_cnum['state']='disabled'
        if type(borrow_list)!=type(()):
            self.error=ttk.Label(self.returnwin,text=borrow_list,style="l.TLabel",anchor="center")
            self.canvas.create_window(400,300,width=200,height=50,anchor="nw",window=self.error)
        else:
            self.query_list=ttk.Treeview(self.returnwin,columns=["书号","书名","借书时间","归还期限"],show="headings")
            self.query_list.column("书号",width=100)
            self.query_list.column("书名",width=200)
            self.query_list.column("借书时间",width=200)
            self.query_list.column("归还期限",width=200)
            self.query_list.heading("书号",text="书号",)
            self.query_list.heading("书名",text="书名",)
            self.query_list.heading("借书时间",text="借书时间")
            self.query_list.heading("归还期限",text="归还期限")
            self.canvas.create_window(100,250,height=230,anchor="nw",window=self.query_list)
            i=0#临时变量
            for item in borrow_list:
                self.query_list.insert("",i,values=(item[0],item[1],item[2],item[3]))
                i+=1
        
    def next(self):
        if type(self.borrow_list)==type(()):
            self.query_list.destroy()
            self.cnum_prom.destroy()
            self.cnum_input.destroy()
            self.btn_cnum.destroy()
            self.btn_next.destroy()

            self.bnum_prom=ttk.Label(self.returnwin,text="请输入书号:",style="l.TLabel",anchor="center")
            self.bnum_input=tk.Entry(self.returnwin,show=None,font=("微软雅黑",14))
            self.btn_bnum=ttk.Button(self.returnwin,text="还书",command=self.return_book)

            self.canvas.create_window(250,150,height=40,anchor="nw",window=self.bnum_prom)
            self.canvas.create_window(400,150,anchor="nw",height=40,window=self.bnum_input)
            self.canvas.create_window(650,150,anchor="nw",height=40,window=self.btn_bnum)
        else:
            self.returnwin.destroy()
            returnwin(self.master)

    def return_book(self):
        self.bnum=self.bnum_input.get()
        result=Return.Return(conn,self.cnum,self.bnum)
        if type(result)==type(()):
            if result[1] is False:
                late="，没有超期"
            else:
                late="，超出还书期限"
            self.return_str="%s还书成功"%result[0]
            self.return_str=self.return_str+late
        else:
            self.return_str=result

        self.borrow_success=ttk.Label(self.returnwin,text=self.return_str,style="l.TLabel",anchor="center")
        self.btn_borrow_over=tk.Button(self.returnwin,text="返回上一级菜单",command=self.return_last)
        self.canvas.create_window(170,300,width=700,anchor="nw",height=50,window=self.borrow_success)
        self.canvas.create_window(450,400,anchor="nw",width=100,height=40,window=self.btn_borrow_over)

    def return_last(self):
        self.returnwin.destroy()
        returnwin(self.master)

    def back(self):
        self.returnwin.destroy()
        initwin(self.master)

def StartGui():
    root = tk.Tk()
    basedesk(root)
    root.mainloop()

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

    with open(".\document\host.txt", "r") as config:
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