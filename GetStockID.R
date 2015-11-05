#获取沪深股票的代码，用的是东方财富网的数据


## 加载包
library(RCurl)
library(stringr)
library(XML)

#网址
url="http://quote.eastmoney.com/stocklist.html"

#读入网页数据
rawdat=getURL(url,.encoding="GB2312")

#整理数据

#设置分离的字符串
pattern="http://quote.eastmoney.com/"
#分解原始数据
tmp=strsplit(x=rawdat,split =pattern )[[1]]
#提取含有</a></li>的部分
tmp=rawdat1[grepl(pattern = "</a></li>",  tmp)]
#进一步分解
tmp=unlist(strsplit(tmp,"</a></li>"))

ind_sta=grep(pattern="201000",tmp)
ind_end=grep(pattern="500159",tmp)
table=tmp[seq(from=ind_sta,to=ind_end,by=2)]
table1=strsplit(table,"\r\n")
Company=data.frame(matrix(NA,ncol=2,nrow=length(seq_along(table1))))
names(Company)=c("company","ID")
for(i in seq_along(table1)){
        company=unlist(strsplit(x=table1[[i]],split="[>()]"))[2]
        ID=unlist(strsplit(x=table1[[i]],split="[>()]"))[3]
        Company[i,]=c(company,ID)
}
rm(list=ls())
#6开头为上海，0和3开头为深圳。
kt=substr(x = Company$ID,start = 1,stop = 1)
kt_ind=which(kt %in% c("6","0","3"))
kt=kt[kt_ind]
Company=Company[kt_ind,]
Company$SS_SZ=ifelse(kt %in% c("0","3"),"SZ","SS")
Company$ID.SS_SZ=paste(Company$ID,".",Company$SS_SZ,sep = "")
#筛选company里有“退市”两个字
Company=Company[-grep(pattern = "退市",Company$company),]
save.image("Company.RData")
write.csv(Company,"company.csv")




#获取沪深股票的代码，用的是同花顺数据
library(RCurl)
library(stringr)
rawdat=getURL("http://bbs.10jqka.com.cn/codelist.html",.encoding="GBK")
#股票代码
pattern="target='_blank' title="
rawdat1=strsplit(x = rawdat,split = pattern)[[1]]
rawdat2=rawdat1[grep(pattern="</a></li>",  rawdat1)]
tmp=unlist(strsplit(rawdat2,"</a></li>"))
