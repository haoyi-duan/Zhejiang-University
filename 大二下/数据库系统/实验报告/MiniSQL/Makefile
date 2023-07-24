cc = g++
cflags = -Wl,--stack=16777216 -g3 -o
objs = API.o base.o bptree.o BufferManager.o IndexManager.o Interpreter.o RecordManager.o  Catalog.o
objs1 = main.o
cpps = $(objs:.o=.cpp)
cpps1 = $(objs1:.o=.cpp)
headers = $(objs:.o=.h)

main.exe : $(cpps) $(cpps1) $(headers)
	$(cc) $(cflags) $@  $(cpps) $(cpps1)

# main.exe : $(objs) $(objs1)
# 	$(cc) $(cflags) $@  $(objs) $(objs1)

# $(objs) : $(cpps) $(headers)
# 	$(cc) $(cflags) $*.o -c $*.cpp 

# $(objs1) : $(cpps1)
# 	$(cc) $(cflags) $*.o -c $*.cpp 


#不加 -I 就没有 nuknown source 了:
#转为binary时加 -g， link 时可以不用加-g 也可debug
#-g3 使得我们可以debug MARCO 里的东西，不过没有什么变化
clean:
	del *.o
	del T_City
	del T_ContryLanguage
	del City0.index
