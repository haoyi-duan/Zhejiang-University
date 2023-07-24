## readme

The Personal Diary is a CLI software, witch consists of 4 programs: **pdadd, pdlist[], pdshow, and pdremove**. Some details are shown as follow.

**First of all, the diaries are stored in the file named "personal_diary.txt" in the folder.**



- **pdadd**

Compile and run the **pdadd.cpp** on VsCode or Dev-C, etc. Or you can simply run the **pdadd.exe** provided in the folder. 

The file **"pdadd_test1.txt"** stores the entity to be added to the diary for the date. After running the pdadd program, the information in the **"personal_diary.txt"** will be changed. You can modify the contents of the file "pdadd_test1.txt" to check whether the pdadd works well or not. 



- **pdlist[]**

Compile and run the **pdlist.cpp** on VsCode or Dev-C, etc. Or you can simply run the **pdlist.exe** provided in the folder. 

The file lists all the entities in the diary ordered by date. If the start and end date are provided in the file **"pdlist_test1.txt"**, for example:

```
2021-05-07
2021-10-10
```

The program lists entities between the start and the end only. The result is store in the file **"pdlist_out.txt".**



- **pdshow**

Compile and run the **pdshow.cpp** on VsCode or Dev-C, etc. Or you can simply run the **pdshow.exe** provided in the folder. 

This program prints the content of the entity specified by the date to the file **"pdshow_out.txt"**. The date is provided in the file **"pdshow_test1.txt"**. You can modify the contents of the file **"pdshow_test1.txt"** and check the result.



- **pdremove**

Compile and run the **pdremove.cpp** on VsCode or Dev-C, etc. Or you can simply run the **pdremove.exe** provided in the folder. 

The entity of date to be removed is stored in the file **"pdremove.txt"**. It returns the information about whether the remove is successful or not. You can modify the date in the file **"pdremove.txt"** to check the result in the file **"personal_diary.txt"**.



