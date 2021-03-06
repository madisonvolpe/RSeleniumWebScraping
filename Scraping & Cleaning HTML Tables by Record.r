## Demographic Table

```{r}
mylist.names <- dfInmates$DCNumber
DemoList <- as.list(rep(NA, length(mylist.names)))
names(DemoList) <- mylist.names

start.time<-Sys.time()

for(i in 1:length(HTMLs)){
  DemoList[[i]]<- HTMLs[[i]]%>%
    read_html()%>%
    html_nodes(css = "td:nth-child(2) table")%>%
  html_table(fill=TRUE)%>%
  data.frame()
}

end.time <- Sys.time()

end.time-start.time

save(DemoList, file = "DemoTable.rda")
```

## Clean Demographic Table

```{r}
BtoNA <- function(g){
  g[g==""] <- NA
  return(g)
} #function to turn blanks into NAs 

DemoList <- lapply(DemoList, BtoNA)#apply Blank to NA function to each dataframe in the list

DemoList <- lapply(DemoList, na.omit)#omit each blank row in the list 

for(i in 1:length(DemoList)){
  DemoList[[i]]<-data.frame(split(DemoList[[i]][1:nrow(DemoList[[i]]), 2],DemoList[[i]][1:nrow(DemoList[[i]]),1]))
} #Loop that switches the dataframe to a longer format 

CurrentDate <- Sys.Date()

for(df in 1:length(DemoList)){
  DemoList[[df]]$RunDate <- rep(NA,nrow(DemoList[[df]]))
  DemoList[[df]]$RunDate <- rep(CurrentDate, nrow(DemoList[[df]]))
} 

DemoTable<- rbind.fill(DemoList) #Because there are a different number of columns in each dataframe - this combines all the dataframes in the list into one dataset! 
```

## Final Demographic Table 

```{r}
DemoTable <- DemoTable[,c(10,5,1,2,3,4,6,7,8,9,11,12,13,14,15)] #rearranging some columns

DemoTable$Birth.Date. <- as.POSIXct(DemoTable$Birth.Date, tz = "UTC", format='%m/%d/%Y')

DemoTable$RunDate <- as.POSIXct(DemoTable$RunDat, tz = "UTC", format = '%m/%d/%Y')
```

## Current Prison Sentence History (CPSH)

```{r}
mylist.names <- dfInmates$DCNumber
CPSHList <- as.list(rep(NA, length(mylist.names)))
names(CPSHList) <- mylist.names

start.time <- Sys.time()

for(i in 1:length(HTMLs)){
  CPSHList[[i]]<- HTMLs[[i]]%>%
    read_html()%>%
    html_nodes(xpath =
              "//table[@class='dcCSStableAlias']/tr/th[contains(text(),'Current')]/ancestor::table")%>%
  html_table()%>%
  data.frame(stringsAsFactors = FALSE)
}

end.time <- Sys.time()

end.time-start.time

save(CPSHList, file = "CPSHTable.rda")
```

## Clean CPSH Table

```{r}
sapply(CPSHList, is.data.frame) #make sure each element of the list is a dataframe 
Ncols <- sapply(CPSHList, ncol)
unique(Ncols)

CPSHList<- Filter(function(x) dim(x)[1] > 0, CPSHList) #works best, filters out those dataframes that are empty

headernames <- c("OffenseDate", "Offense", "SentenceDate", "County", "CaseNo.", "PrisonSentenceLength") #header names 

for (df in 1:length(CPSHList)){
  colnames(CPSHList[[df]]) <- headernames
}#change header names for each list in dataframe 

CPSHList <- lapply(CPSHList, function(x) x[-1,])#drops first row, which contained the "headers" 

for(df in 1:length(CPSHList)){
  CPSHList[[df]]$DCNumber <- rep(NA,nrow(CPSHList[[df]]))
  CPSHList[[df]]$DCNumber <- rep(names(CPSHList)[[df]], nrow(CPSHList[[df]]))
} #for loop that creates a DC Number column so that the people remain identifiable throughout!

CurrentDate <- Sys.Date()

for(df in 1:length(CPSHList)){
  CPSHList[[df]]$RunDate <- rep(NA,nrow(CPSHList[[df]]))
  CPSHList[[df]]$RunDate <- rep(CurrentDate, nrow(CPSHList[[df]]))
} #for loop that creates a DC Number column so that the people remain identifiable throughout!

```

## Final CPSH Table 

```{r}
CPSHTable <- do.call(rbind.data.frame, CPSHList) #converts list to dataframe 

rownames(CPSHTable) <- NULL #rownames null

CPSHTable$OffenseDate <- as.POSIXct(CPSHTable$OffenseDate, tz="UTC", format = "%m/%d/%Y")
CPSHTable$SentenceDate<- as.POSIXct(CPSHTable$SentenceDate, tz="UTC", format = "%m/%d/%Y")
CPSHTable$RunDate <- as.POSIXct(CPSHTable$RunDate,tz="UTC", format = "%m/%d/%Y")
```

## Incarceration History 

```{r}
mylist.names <- dfInmates$DCNumber
IncarcerationList <- as.list(rep(NA, length(mylist.names)))
names(IncarcerationList) <- mylist.names

start.time <- Sys.time()

for(i in 1:length(HTMLs)){
  IncarcerationList[[i]]<- HTMLs[[i]]%>%
    read_html()%>%
    html_nodes(xpath =
              "//table[@class='dcCSStableAlias']/tr/th[contains(text(),'Incarceration')]/ancestor::table")%>%
  html_table()%>%
  data.frame(stringsAsFactors = FALSE)
}

end.time <- Sys.time()

end.time-start.time

save(IncarcerationList, file = "IncarcerationTable.rda")
```

## Clean Incarceration History 

```{r}
sapply(IncarcerationList, is.data.frame)
  
IncarcerationList<- Filter(function(x) dim(x)[1] > 0, IncarcerationList) #works best, filters out those dataframes that are empty: 

headernames <- c("DateIn","DateOut")


for (df in 1:length(IncarcerationList)){
  colnames(IncarcerationList[[df]]) <- headernames
}#change header names for each list in dataframe 

IncarcerationList <- lapply(IncarcerationList, function(x) x[-1,])#drops first row, which contained the "headers" 

for(df in 1:length(IncarcerationList)){
 IncarcerationList[[df]]$DCNumber <- rep(NA,nrow(IncarcerationList[[df]]))
  IncarcerationList[[df]]$DCNumber <- rep(names(IncarcerationList)[[df]], nrow(IncarcerationList[[df]]))
} #for loop that creates a DC Number column so that the people remain identifiable throughout!

CurrentDate <- Sys.Date()

for(df in 1:length(IncarcerationList)){
  IncarcerationList[[df]]$RunDate <- rep(NA,nrow(IncarcerationList[[df]]))
  IncarcerationList[[df]]$RunDate <- rep(CurrentDate, nrow(IncarcerationList[[df]]))
} 
```

## Final Incarceration History Table 

```{r}
IncarcerationTable <- do.call(rbind.data.frame, IncarcerationList) #converts list to dataframe 

rownames(IncarcerationTable) <- NULL #rownames null

IncarcerationTable$DateIn <- as.POSIXct(IncarcerationTable$DateIn, tz="UTC", format = "%m/%d/%Y")
IncarcerationTable$DateOut <- as.POSIXct(IncarcerationTable$DateOut, tz="UTC", format = "%m/%d/%Y")
IncarcerationTable$RunDate <- as.POSIXct(IncarcerationTable$RunDate, tz="UTC", format = "%m/%d/%Y")
```


## Prior Prison History 

```{r}
mylist.names <- dfInmates$DCNumber
PriorPrisonList <- as.list(rep(NA, length(mylist.names)))
names(PriorPrisonList) <- mylist.names

start.time <- Sys.time()

for(i in 1:length(HTMLs)){
  PriorPrisonList[[i]]<- HTMLs[[i]]%>%
    read_html()%>%
    html_nodes(xpath =
              "//table[@class='dcCSStableAlias']/tr/th[contains(text(),'Prior')]/ancestor::table")%>%
  html_table()%>%
  data.frame(stringsAsFactors = FALSE)
}

end.time <- Sys.time()
end.time-start.time

save(PriorPrisonList, file = "PriorPrisonTable.rda")
```

## Clean Prior Prison History 

```{r}
sapply(PriorPrisonList, is.data.frame)

PriorPrisonList<- Filter(function(x) dim(x)[1] > 0, PriorPrisonList) #works best, filters out those dataframes that are empty: Some people did not have "Prior Prison Histories", since it was there first time being Incarcerated. 

headernames <- c("OffenseDate","Offense", "SentenceDate", "County", "CaseNo.", "SentenceLength")

for (df in 1:length(PriorPrisonList)){
  colnames(PriorPrisonList[[df]]) <- headernames
}#change header names for each list in dataframe 

PriorPrisonList <- lapply(PriorPrisonList, function(x) x[-1,])#drops first row, which contained the "headers" 

for(df in 1:length(PriorPrisonList)){
 PriorPrisonList[[df]]$DCNumber <- rep(NA,nrow(PriorPrisonList[[df]]))
  PriorPrisonList[[df]]$DCNumber <- rep(names(PriorPrisonList)[[df]], nrow(PriorPrisonList[[df]]))
} #for loop that creates a DC Number column so that the people remain identifiable throughout!

CurrentDate <- Sys.Date()

for(df in 1:length(PriorPrisonList)){
  PriorPrisonList[[df]]$RunDate <- rep(NA,nrow(PriorPrisonList[[df]]))
  PriorPrisonList[[df]]$RunDate <- rep(CurrentDate, nrow(PriorPrisonList[[df]]))
} 
```

## Final Prior Prison History Table 

```{r}
PriorPrisonTable <- do.call(rbind.data.frame, PriorPrisonList) #converts list to dataframe

rownames(PriorPrisonTable) <- NULL #rownames null 

PriorPrisonTable$OffenseDate <- as.POSIXct(PriorPrisonTable$OffenseDate, format='%m/%d/%Y')
PriorPrisonTable$SentenceDate <- as.POSIXct(PriorPrisonTable$SentenceDate, format='%m/%d/%Y')
PriorPrisonTable$RunDate <- as.POSIXct(PriorPrisonTable$RunDate, format='%m/%d/%Y')
```
