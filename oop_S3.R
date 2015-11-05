
# base type【基本类型】
f=function(x){}
typeof(f) #函数的类型是closure
typeof(sum) #原始函数 primitive function 是builtin
formals(sum) #原始函数，底层是用C语言写的
formals(f) #非原始函数
f #可以看到源代码

a=c(1);b=list();e=new.env();df=data.frame(matrix(NA,3,2));fa=factor(c("f","m"))
typeof(a) #double
typeof(b)  #list
typeof(e)   #environment
typeof(df) #list


# S3类型
a=c(1);b=list();e=new.env();df=data.frame(matrix(NA,3,2));fa=factor(c("f","m"))
library(pryr)
otype(df)  #S3
otype(a)   #base
otype(b)   #base
otype(e)   #base
otype(f)   #base
otype(sum) #base
otype(fa)  #S3

#总结之：向量、列表、环境、函数是基本类型；数据框和因子是S3类型

mean
ftype(mean) #pryr::ftype
methods("mean")
methods("sum") #no methods were found ,因为sum是原始函数，底层用C语言写，
                #是内部泛型函数（internal generics ，?internal generics）

#在S3中，方法（methods）属于函数，即所谓的泛型函数（generic functions），
#S3的方法不属于对象（objects)或者类(classes),如C#语言是先定义类，给类
#加属性和方法，初始化对象后，对象就可以使用类的方法了。泛型函数，如mean，
#当给你一个类后，如dataf.frame，mena泛函就会在mean.Date     mean.default  
#mean.difftime mean.POSIXct  mean.POSIXlt 这几个函数中寻找适合的函数，
#本例中就找到mean.default;如果是给定POSIXlt类，就寻找到mean.POSIXlt

ftype(t.data.frame) #t()函数的方法t.data.frame使用在data frame类型上
#t.data.frame这样的命名不好的原因有：1、大部分的现代编程风格指南都不鼓励使用.
#2、容易引起混淆，如t.data.frame到底是方法t.data还是t。
methods(class = "ts")
mean   #泛型函数，看不到源代码
#[1] mean.Date     mean.default  mean.difftime mean.POSIXct  mean.POSIXlt
mean.POSIXct #方法，可以源代码
mean.default #方法，可以看到源代码
#advanced R中讲到大部分的S3方法都不可见
methods(class = "ts") #查看ts类的方法
# [1] [.ts*            [<-.ts*          aggregate.ts     as.data.frame.ts cbind.ts*       
# [6] cycle.ts*        diff.ts*         diffinv.ts*      kernapply.ts*    lines.ts*       
# [11] monthplot.ts*    na.omit.ts*      Ops.ts*          plot.ts          print.ts*       
# [16] t.ts*            time.ts*         window.ts*       window<-.ts* 
#t.ts*  中的*表示函数是不可见源代码的（Non-visible functions are asterisked）
getS3method(f = "aggregate",class = "ts")  #查看aggregate.ts的源代码
getS3method(f = "na.omit",class = "ts")  #查看na.omit.ts的源代码
getS3method(f = "cycle",class = "ts")  #查看na.omit.ts的源代码
#或者用getAnywhere()来看源代码
getAnywhere("cycle.ts")
##定义S3类和创建对象

dai=structure(list(),class="dai") #一步创建并设置类
class(dai);dai
#分两步，第一先创建，再设定类
dai=list()
class(dai)="dai";dai
#You can also turn functions into S3 objects. Other base types are either rarely 
#seen in R, or have unusual semantics that don’t work well with attributes.@advance R
#有什么问题呢

#对于因子，能否设置类呢？
dai=factor(c("f","m"))
class(dai)="dai"
class(dai);dai 
#对于数据框，能否设置类呢？
dai=data.frame(a=1:2,b=2:1)
class(dai)="dai"
class(dai);dai 
#对于函数，能否设置类呢？
dai=function(x){print("函数变成类")}
class(dai)="dai"
class(dai);dai 
gazi=c()
class(gazi)="dai" #Error in class(gazi) = "dai" : attempt to set an attribute on NULL

gazi=function(){}
class(gazi)="dai" #没错，可以通过

inherits(x = dai,what = "dai") #是否继承自指定的类
## Dobson (1990) Page 93: Randomized Controlled Trial :
counts <- c(18,17,15,20,10,20,25,13,12)
outcome <- gl(3,1,9)
treatment <- gl(3,3)
print(d.AD <- data.frame(treatment, outcome, counts))
glm.D93 <- glm(counts ~ outcome + treatment, family = poisson())
class(glm(glm.D93)) #"glm" "lm" ，说明S3对象的类可以继承自多个类


#大部分S3类提供一个构造函数
dai=function(x){
        if(!is.funtion(x)){stop("X must be function")}
        structure(function(x){print("构造函数")})
}
gazi=function(){}
class(gazi)="dai" #没错，可以通过

##创建新的方法和泛型函数
#新增一个泛型函数，需要使用UseMethod(),UseMethod()函数有两个参数，一个是泛型函数
#的名字，另一个是方法分派的参数。如果你省略掉第二个参数，那么它将分配到函数的第
#一个函数。 不需要对 UseMethod()传递任何泛型函数的参数，并且你也不应该这样做。 
#UseMethod()会使用所谓的"黑魔法"来找到它们本身。

f=function(x) UseMethod("f") #创建泛型函数
f.dai=function(x) "Class dai"  #方法函数！泛型函数如果没有方法函数就不可用的
dai=function(x){
        if(!is.funtion(x)){stop("X must be function")}
        structure(function(x){print("构造函数")})
}
gazi=function(){}
class(gazi)="dai" #没错，可以通过
class(gazi)
f(gazi)
#新增一个方法到现有的泛型函数，如mean
mean.dai=function(x)"dai"
mean(gazi)

5 S3对象的继承关系

# S3对象有一种非常简单的继承方式，用NextMethod()函数来实现。
# 
# 定义一个 node泛型函数


 node <- function(x) UseMethod("node",x)
#等于node <- function(x) UseMethod("node")
 node.default <- function(x) "Default node"

# father函数
 node.father <- function(x) c("father")

# son函数，通过NextMethod()函数指向father函数
 node.son <- function(x) c("son", NextMethod())

# 定义n1
 n1 <- structure(1, class = c("father"))
# 在node函数中传入n1，执行node.father()函数
 node(n1)
#[1] "father"

# 定义n2，设置class属性为两个
 n2 <- structure(1, class = c("son", "father"))
# 在node函数中传入n2，执行node.son()函数和node.father()函数
 node(n2)
#[1] "son"    "father"
# 通过对node()函数传入n2的参数，node.son()先被执行，然后通过NextMethod()函数继续执
# 行了node.father()函数。这样其实就模拟了，子函数调用父函数的过程，实现了面向对象
# 编程中的继承。

# Read the source code for t() and t.test() and confirm that t.test() is an S3 
#generic and not an S3 method. What happens if you create an object with class
#test and call t() with it?
rm(list=ls())
structure(list(),class="test")
a=list(x=1,y=2)
class(a)="test"
t(a)
t.test(a)



rm(list=ls())
y <- 1 
g <- function(x) { 
        y <- 2 
        UseMethod("g") 
} 
g.numeric <- function(x) y 
g(10)  #返回2
h <- function(x) { 
        x <- 10 
        UseMethod("h") 
} 
h.character <- function(x) paste("char", x) 
h.numeric <- function(x) paste("num", x) 
h("a")  #返回"char a"



f <- function() 1 
g <- function() 2 
class(g) <- "function" 
class(f) 
class(g) 
length.function <- function(x) "function" 
length(f) 
length(g)