library(stats4) 
# 本例来自 example(mle) 
y <- c(26, 17, 13, 12, 20, 5, 9, 8, 5, 4, 8) 
nLL <- function(lambda) - sum(dpois(y, lambda, log = TRUE)) 
fit <- mle(nLL, start = list(lambda = 5), nobs = length(y)) 
# 一个 S4 对象 
isS4(fit) #True
str(fit)  #返回Formal class字样，说明是S4类
library(pryr)
otype(fit)
is(fit) 
#> [1] "mle" 
is(fit, "mle") 
#> [1] TRUE 
getGenerics(where =  search()) #列出全局环境中的S4泛型函数
#getGenerics(where = .GlobalEnv())
getClasses(where =  search()) #列出全局环境中的S4类
showMethods(where =  search()) #列出全局环境中的S4方法




setClass(Class = "Person",slots = list(name="character",age="numeric"),
         prototype = list(age=20)) 
setClass("employee",slots = list(boss="Person"),contains = "Person")
 #boss="Person"中的Person必须是大写的

alice=new(Class = "Person",name="alice",age=40)
john=new(Class = "employee",name="john",age=20,boss=alice) #boss="alice"就报错

#如下所示
setClass(Class = "Person",slots = list(name="character",age="numeric"),
         prototype = list(age=20)) 
setClass("employee",slots = list(boss="person"),contains = "Person")
alice=new(Class = "Person",name="alice",age=40)
john=new(Class = "employee",name="john",age=20) 
john #报错

#因此有几处地方需要注意到：1、boss="Person"，2、contains = "Person"，3、boss=alice

setClass(Class = "Person",slots = list(name="character",age="numeric"),
         prototype = list(age=20)) 
setClass("employee",slots = list(boss="Person"),contains = "Person")
#boss="Person"中的Person必须是大写的

alice=new(Class = "Person",name="alice",age=40)
john=new(Class = "employee",name="john",age=20,boss=alice) #boss="alice"就报错
john
alice@age  #不能用$，但是@和$的意思是一致的
slot(john,"boss")  #slot等价于[[,但是不可以用[[


# 如果一个 S4 对象包含(继承自)S3 类或者基本类型，那么它将有一个特别的.Data
# 槽，它会包含底层的基本类型或者 S3 对象： 
setClass(Class = "RangedNumeric",contains="numeric",slots = list(min="numeric",max="numeric"))
rn=new(Class = "RangedNumeric",.Data=1:10,min=1,max=10)
rn
rn@.Data




################################################################################
##############                     总结                             ############
################################################################################

#创建S4类
setClass(Class = "Person",slots=list(name="character",age="numeric"))
#检查字段有效性
setValidity(Class = "Person",method = function(object){
        if(objiect@age<=0) stop("age is negetive")
})
#初始化对象
father=new(Class = "Person",name="papa",age=44)
mother=new(Class="Person",name="mama",age=40)
#创建子类，继承自Person类
setClass(Class = "Son",slots = list(father="Person",mother="Person"),contains = "Person")
#初始化对象
son_first=new("Son",name="1",age=16,father=father,mother=mother)
#由一个已经存在的对象修改
son_sec=initialize(.Object = son_first,age=14,name="2")
#设置泛型函数lesson
setGeneric(name = "lesson",def = function(x){
        standardGeneric("lesson")
})
#设置方法lesson
setMethod(f = "lesson",signature (x="Person"),function(x){
        cat(x@name,", this time to have a lesson")
})
lesson(son_sec)

################################################################################
##############                    案例                             ############
################################################################################



