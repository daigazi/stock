# setRefClass(Class, fields = , contains = , methods =, where =, ...)
# 参数列表：
# 
# Class: 定义类名
# fields: 定义属性和属性类型
# contains: 定义父类，继承关系
# methods: 定义类中的方法
# where: 定义存储空间

#定义一个RC类
Per=setRefClass(Class = "Person",fields = list(name="character",age="numeric"))
Per
#实例化对象
P1=Per$new(name="p1",age="22") #自带有效性检验
 
#Error: invalid assignment for reference class field ‘age’, should be from class #“numeric” or a subclass (was class “character”)

P1=Per$new(name="p1",age=22) #自带有效性检验
P1

P1=Per$new(name="p1",age=-22)
P1
class(P1)

library(pryr)
otype(P1)

father=Per$new(name="papa",age=44) 
mother=Per$new(name="mama",age=40)
otype(father)  #"RC"
#创建有继承关系的RC类
son=setRefClass(Class = "Son",fileds=list(father=father,mother=mother),contains = "Person")   #报错

son=setRefClass(Class = "Son",fields=list(school="character"),contains = "Person")

#实例化对象
s1=son$new(school=" No 1 middle school")
s1
s1$age=11;s1
s1@age=11  #Error in checkAtAssignment("Son", "age", "numeric") : 
           #‘age’ is not a slot in class “Son”



#RC对象的默认值

son=setRefClass(class="Son",fields=list(school="character"),contains = "Person",
                #设置对象的默认值
                methods=list(
                        initialize=function(x){
                        cat("设置初始化对象")
                        x$name="gazi"
                        x$age=13
                        }
                        )
                )


son=setRefClass(class="Son",fields=list(school="character"),contains = "Person",
                #设置对象的默认值
                methods=list(
                         #构造方法
                        initialize = function(school){
                                print("User::initialize")
                                # 给属性增加默认值
                                school <<- 'conan'
                               
                                
                        }
                )
)

# 创建RC类User
 User<-setRefClass("User",fields=list(name="character"))

# 创建User的子类Member
Member<-setRefClass("Member",contains="User",fields=list(manager="User"))
 User<-setRefClass("User",
                    
                            # 定义2个属性
                  fields=list(name="character",level='numeric'),
                    methods=list(
                        # 构造方法
                              initialize = function(name,level){
                              print("User::initialize")
                                # 给属性增加默认值
                                name <<- 'conan'
                               level <<- 1
 }
 )
)
# 实例化对象u1
 u1<-User$new()
#[1] "User::initialize"

# 查看对象u1，属性被增加了默认值
 u1



#对象赋值
p2=Per$new(name="p2",age=40)
p2
#p3由p2来复制，测试改了p2的值后，p3会改变吗
p3=p2
p3$age;p2$age
p2$age=50;p3$age #发现p3的值改变了，相当于p3只是指向了p2的内存，并没有新开一个内存

p4=p2$copy() #p4就是新开一个内存
p2$age=60
p4$age


#RC中“方法可以也只能定义在类的内部，通过实例化的对象完成方法调用”。

#定义一个RC类，包括方法
Per_plus=setRefClass("Person",fields = list(name="character",age="numeric",
                                            act="vector"),
                     methods=list(
                             #技能一：吃饭方法
                             eat=function(x){
                                     cat("time to eat now")
                                     act<<-c(act,x)
                             },
                             #技能2：睡觉方法
                             sleep=function(x){
                                     cat("time to sleep now")
                                     act<<-c(act,x)
                             },
                             #删除一个技能
                             del=function(x){
                                     act<<-act[1:(length(act)-1)]
                             }
                             
                             ))
Per_plus #新增了sleep 和eat和del方法
#实例化对象
p1x=Per_plus$new(name="P1x",age=24,act=c("go to class","shooping"))
p1x
p1x$eat("eat")
p1x  #新增了吃饭的功能
p1x$sleep("sleeping")
p1x  #新增了睡觉的功能
p1x$del("xx")
p1x 


#RC对象内置方法和内置属性
# 5.1 内置方法：

# initialize 类的初始化函数，用于设置属性的默认值，只能在类定义的方法中使用。
# callSuper 调用父类的同名方法，只能在类定义的方法中使用。
# copy 复制实例化对象的所有属性。
# initFields 给对象的属性赋值。
# field 查看属性或给属性赋值。
# getClass 查看对象的类定义。
# getRefClass 同getClass。
# show 查看当前对象。
# export 查看属性值以类为作用域。
# import 把一个对象的属性值赋值给另一个对象。
# trace 跟踪对象中方法调用，用于程序debug。
# untrace 取消跟踪。
# usingMethods 用于实现方法调用，只能在类定义的方法中使用。这个方法不利于程序的健壮性，所以不建议使用。
# 接下来，我们使用这些内置的方法。



p2x=p1x$copy();p2x
p2x$initFields()
class(p2x$initFields());otype(p2x$initFields())
p2x$initFields(name="p2x")
p2x$getclass()  #S3的吧，报错
p2x$getRefClass() #查看对象的类定义。
p2x$show()  #查看当前对象。
show(p2x)  #同上
p2x #同上
p2x$trace("del")  #Tracing reference method "del" for object from class "Person"
Per_plus$methods() #P2x$methods()会报错,p2x是实例化的对象，而Per_plus是类型
Per_plus$help()
Per_plus$help("eat")
Per_plus$accessors("name")  #给level属性增加get/set方法