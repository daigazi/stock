library(rvest)
library(RCurl)
library(XML)

url="http://quotes.money.163.com/f10/zcfzb_601668.html#01c05"
web=read_html(url,encoding="UTF-8")
pro=web %>%  html_nodes(".td_1") %>% html_text() #项目
pro=iconv(pro,'utf-8','gbk') #乱码，转换输出格式
t=web %>%  html_nodes(".scr_table td:nth-child(1)") %>% html_text()
tablehead=web %>%  html_nodes("th") %>% html_text()
tablehead=iconv(tablehead,'utf-8','gbk') 
tab=web %>%  html_nodes(".scr_table td") %>% html_text()
#这样操作的话合并表格时很复杂的，改用XML


#用XML和getURL
url="http://quotes.money.163.com/f10/zcfzb_601668.html#01c05"
doc=xmlTreeParse(url,useInternal=TRUE) #报错，有未闭合的标签
data=getURL(url,.encoding = "utf-8")
tab=readHTMLTable(doc =data,header = T,colClasses = NULL, trim=T)
df=cbind(tab[[4]][-1,],tab[[5]])

#

#模拟鼠标点击界面里"下载数据"这个功能
#实际上就是跳入到"http://quotes.money.163.com/service/zcfzb_601668.html"这个页面
x=web %>%  html_nodes("#downloadData") %>% html_text() #项目
iconv(x,"utf-8","gbk") #只返回“下载数据”这几个字

url="http://quotes.money.163.com/service/zcfzb_601668.html"
web=read_html(url,encoding="utf-8")


