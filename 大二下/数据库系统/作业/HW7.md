# DataBase System Homework 7

#### 3190105359 段皞一

## **7.1**

![image-20210419201929587](C:\Users\lenovo\AppData\Roaming\Typora\typora-user-images\image-20210419201929587.png)

## **7.20**

Consider the E-R diagram in Figure 7.29, which models an on-line bookstore.

**a. Entity sets:**

​	**author(<u>name</u>, address, URL )**

​	**publisher(<u>name</u>, address, phone, URL)**

​	**book(<u>ISBN</u>, title, year, price)**

​	**customer(<u>email</u>, name, address, phone)**

​	**shopping_basket(<u>basket_id</u>)**

​	**warehouse(<u>code</u>, address, phone)**

**b. The E-R diagram portion related to videos is shown below:**

![image-20210419204750046](C:\Users\lenovo\AppData\Roaming\Typora\typora-user-images\image-20210419204750046.png)

**c. The E-R diagram shown below should be added to the E-R diagram of Figure 7.29. All other parts of Figure 7.29 remain unchanged.**

![image-20210419205536749](C:\Users\lenovo\AppData\Roaming\Typora\typora-user-images\image-20210419205536749.png)

## 7.22

**Two alternative E-R diagrams are shown below:**

![image-20210419211652266](C:\Users\lenovo\AppData\Roaming\Typora\typora-user-images\image-20210419211652266.png)

**As an alternative:**

![image-20210419211904500](C:\Users\lenovo\AppData\Roaming\Typora\typora-user-images\image-20210419211904500.png)

**The relational schema, including  primary-key and foreign-key constraints, corresponding to the second alternative is shown below:**

​	customer(<u>customer_id</u>, name, address)

​	packet(<u>packet_id</u>, weight)

​	place(<u>place_id</u>, city, country, address)

​	sends(<u>sender_id</u>, <u>receiver_id</u>, <u>packet_id</u>, time_received, time_sent)

​	**foreign key** sender_id **references** customer,

​	**foreign key** receiver_id **references** customer,

​	**foreign key** packet_id **references** packet

)

​	has_gone_through(<u>packet_id</u>, <u>place_id</u>, 

​	**foreign key** packet_id **references** packet,

​	**foreign key** place_id **references** place

)



