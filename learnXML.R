---
title: "XML"
author: "daigazi"
date: "2015年11月4日"
output: html_document
---
```{r}
opts_chunk$set(comment=NA, fig.width=6, fig.height=6,cache = TRUE)
```



```{r,eval=FALSE,echo=TRUE}
library(XML)
fileUrl <- "http://www.w3schools.com/xml/simple.xml"
doc <- xmlTreeParse(fileUrl,useInternal=TRUE)
rootNode <- xmlRoot(doc)
xmlName(rootNode)
```

```{r,eval=T,echo=TRUE}
library(XML)
fileUrl <- "http://www.w3schools.com/xml/simple.xml"
doc <- xmlTreeParse(fileUrl,useInternal=TRUE)
rootNode <- xmlRoot(doc)
xmlName(rootNode)
```


```{r, echo=FALSE}
plot(cars)
```


